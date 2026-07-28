import { isAuthenticatedRequest } from "../_shared/auth.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/http.ts";
import {
  createStructuredOutput,
  GeminiRequestError,
} from "../_shared/gemini.ts";
import {
  parseObject,
  requiredInteger,
  requiredString,
  ValidationError,
} from "../_shared/validation.ts";

interface GeneratedQuestion {
  questionJa: string;
  modelAnswerEn: string;
}

interface GenerationResult {
  questions: GeneratedQuestion[];
}

const responseSchema = {
  type: "object",
  properties: {
    questions: {
      type: "array",
      items: {
        type: "object",
        properties: {
          questionJa: { type: "string" },
          modelAnswerEn: { type: "string" },
        },
        required: ["questionJa", "modelAnswerEn"],
        additionalProperties: false,
      },
    },
  },
  required: ["questions"],
  additionalProperties: false,
};

function difficultyGuidance(difficulty: string): string {
  switch (difficulty) {
    case "初級":
      return [
        "CEFR A1〜A2相当の学習者向けにしてください。",
        "模範英文は1つの主節だけで構成し、1文につき1つの情報だけを扱ってください。",
        "模範英文は5〜10語を目安とし、指定表現を含めても最大12語にしてください。",
        "中学校で学ぶ基本語彙と、現在形・過去形・未来表現などの単純な文型を使ってください。",
        "関係詞、分詞構文、間接疑問、仮定法、完了形、長い修飾句は使わないでください。",
        "日本語問題も短く直接的にし、条件や理由を複数含めないでください。",
        "ビジネスやフォーマルなシーンでも、語彙と文型の難易度を上げないでください。",
      ].join("\n");
    case "中級":
      return [
        "CEFR B1相当の学習者向けにしてください。",
        "日常的な語彙を中心に、理由や状況を1つ加えた自然な英文にしてください。",
        "模範英文は原則18語以内にし、複雑な従属節や長い修飾句は避けてください。",
      ].join("\n");
    case "上級":
      return [
        "CEFR B2以上の学習者向けにしてください。",
        "自然な語彙の選択、複文、具体的な文脈を必要に応じて使用できます。",
      ].join("\n");
    default:
      return "指定された難易度に合わせ、語彙・文型・文長を一貫させてください。";
  }
}

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
    const questionCount = requiredInteger(body, "questionCount", 1, 20);
    const difficulty = requiredString(body, "difficulty", 50);
    const scene = requiredString(body, "scene", 50);
    const formalLevel = requiredString(body, "formalLevel", 50);
    const locale = requiredString(body, "locale", 100);
    const difficultyRules = difficultyGuidance(difficulty);

    const result = await createStructuredOutput<GenerationResult>({
      schema: responseSchema,
      maxOutputTokens: Math.max(1200, questionCount * 220),
      instructions: [
        "あなたは日本人英語学習者向けの瞬間英作文教材を作る専門家です。",
        "指定された英語表現を自然かつ適切に使う問題だけを作成してください。",
        "日本語問題と模範英文は意味が一致し、文法的に正しく自然でなければなりません。",
        "各問題は異なる状況にし、日本語問題に英語の答えを直接含めないでください。",
        "以下の難易度基準を最優先し、シーンやフォーマル度によって基準より難しくしないでください。",
        difficultyRules,
        "出力前に各問題の語彙・文型・文長を確認し、基準を超える問題は簡単に作り直してください。",
        "指定数と同じ数の問題を返してください。",
      ].join("\n"),
      input: JSON.stringify({
        targetExpression: phraseText,
        meaningInJapanese: phraseMeaning,
        questionCount,
        difficulty,
        scene,
        formalLevel,
        learnerLocale: locale,
      }),
    });

    if (result.questions.length !== questionCount) {
      throw new GeminiRequestError(
        "指定した問題数を生成できませんでした。",
        502,
      );
    }

    return jsonResponse({
      questions: result.questions.map((question) => ({
        id: crypto.randomUUID(),
        questionJa: question.questionJa.trim(),
        modelAnswerEn: question.modelAnswerEn.trim(),
      })),
    });
  } catch (error) {
    if (error instanceof ValidationError || error instanceof SyntaxError) {
      return errorResponse(400, "invalid_request", error.message);
    }
    if (error instanceof GeminiRequestError) {
      return errorResponse(error.status, "llm_error", error.message);
    }
    console.error("Unexpected generation error", error);
    return errorResponse(
      500,
      "internal_error",
      "問題生成中にエラーが発生しました。",
    );
  }
});
