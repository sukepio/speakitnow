type JSONSchema = Record<string, unknown>;

interface StructuredOutputOptions {
  schema: JSONSchema;
  instructions: string;
  input: string;
  maxOutputTokens: number;
}

interface GeminiResponse {
  candidates?: Array<{
    content?: {
      parts?: Array<{ text?: string }>;
    };
    finishReason?: string;
  }>;
  promptFeedback?: {
    blockReason?: string;
  };
  error?: {
    message?: string;
  };
}

export const GEMINI_MODEL = "models/gemini-flash-lite-latest";

export class GeminiRequestError extends Error {
  constructor(
    message: string,
    readonly status: number,
  ) {
    super(message);
  }
}

export async function createStructuredOutput<T>(
  options: StructuredOutputOptions,
): Promise<T> {
  const apiKey = Deno.env.get("GEMINI_API_KEY");
  if (!apiKey) {
    throw new GeminiRequestError("GEMINI_API_KEYが設定されていません。", 500);
  }

  const prompt = [
    options.instructions,
    "レスポンスは指定されたJSON Schemaに一致するJSONだけを返してください。",
    "",
    `Input: ${options.input}`,
  ].join("\n");

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/${GEMINI_MODEL}:generateContent`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-goog-api-key": apiKey,
      },
      body: JSON.stringify({
        contents: [
          {
            parts: [{ text: prompt }],
          },
        ],
        generationConfig: {
          temperature: 0.2,
          maxOutputTokens: options.maxOutputTokens,
          responseMimeType: "application/json",
          responseJsonSchema: options.schema,
        },
      }),
    },
  );

  const body = await response.json() as GeminiResponse;
  if (!response.ok) {
    console.error("Gemini API error", response.status, body.error?.message);
    throw new GeminiRequestError("Gemini APIの呼び出しに失敗しました。", 502);
  }

  const outputText = body.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!outputText) {
    const blockReason = body.promptFeedback?.blockReason;
    const finishReason = body.candidates?.[0]?.finishReason;
    console.error("Gemini response did not contain text", {
      blockReason,
      finishReason,
    });
    throw new GeminiRequestError(
      blockReason
        ? "この内容では問題を作成できません。"
        : "Gemini APIから回答を取得できませんでした。",
      blockReason ? 422 : 502,
    );
  }

  try {
    return JSON.parse(outputText) as T;
  } catch {
    throw new GeminiRequestError(
      "Gemini APIの回答形式が正しくありません。",
      502,
    );
  }
}
