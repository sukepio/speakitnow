import { isAuthenticatedRequest } from "../_shared/auth.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/http.ts";
import {
  createStructuredOutput,
  GeminiRequestError,
} from "../_shared/gemini.ts";
import {
  parseObject,
  requiredString,
  ValidationError,
} from "../_shared/validation.ts";

interface EvaluationResult {
  isPerfect: boolean;
  feedback: string | null;
  alternativeAnswers: string[];
}

const responseSchema = {
  type: "object",
  properties: {
    isPerfect: { type: "boolean" },
    feedback: {
      type: ["string", "null"],
    },
    alternativeAnswers: {
      type: "array",
      items: { type: "string" },
    },
  },
  required: ["isPerfect", "feedback", "alternativeAnswers"],
  additionalProperties: false,
};

Deno.serve(async (request) => {
  const optionsResponse = handleOptions(request);
  if (optionsResponse) return optionsResponse;

  if (request.method !== "POST") {
    return errorResponse(
      405,
      "method_not_allowed",
      "POSTメソッドを使用してください。",
    );
  }
  if (!(await isAuthenticatedRequest(request))) {
    return errorResponse(401, "unauthorized", "ログインが必要です。");
  }

  try {
    const body = parseObject(await request.json());
    const phraseText = requiredString(body, "phraseText", 200);
    const phraseMeaning = requiredString(body, "phraseMeaning", 500);
    const questionJa = requiredString(body, "questionJa", 1000);
    const modelAnswerEn = requiredString(body, "modelAnswerEn", 2000);
    const userAnswerEn = requiredString(body, "userAnswerEn", 2000);
    const difficulty = requiredString(body, "difficulty", 50);
    const locale = requiredString(body, "locale", 100);

    const result = await createStructuredOutput<EvaluationResult>({
      schema: responseSchema,
      maxOutputTokens: 900,
      instructions: [
        "あなたは日本人英語学習者の瞬間英作文を添削する専門家です。",
        "意味の一致、英文法、自然さ、指定表現の適切な使用を評価してください。",
        "模範解答との完全一致は不要です。意味が正しく自然なら正解にしてください。",
        "isPerfectがtrueの場合feedbackはnullにしてください。",
        "isPerfectがfalseの場合、具体的で短い日本語の改善説明をfeedbackに設定してください。",
        "正解として使える自然な別表現を最大2件alternativeAnswersに設定してください。",
      ].join("\n"),
      input: JSON.stringify({
        targetExpression: phraseText,
        meaningInJapanese: phraseMeaning,
        questionInJapanese: questionJa,
        referenceAnswer: modelAnswerEn,
        learnerAnswer: userAnswerEn,
        difficulty,
        learnerLocale: locale,
      }),
    });

    if (!result.isPerfect && !result.feedback?.trim()) {
      throw new GeminiRequestError("添削結果が不足しています。", 502);
    }

    return jsonResponse({
      isPerfect: result.isPerfect,
      feedback: result.isPerfect ? null : result.feedback?.trim(),
      alternativeAnswers: result.alternativeAnswers
        .map((answer) => answer.trim())
        .filter((answer) => answer.length > 0)
        .slice(0, 2),
    });
  } catch (error) {
    if (error instanceof ValidationError || error instanceof SyntaxError) {
      return errorResponse(400, "invalid_request", error.message);
    }
    if (error instanceof GeminiRequestError) {
      return errorResponse(error.status, "llm_error", error.message);
    }
    console.error("Unexpected evaluation error", error);
    return errorResponse(
      500,
      "internal_error",
      "回答添削中にエラーが発生しました。",
    );
  }
});
