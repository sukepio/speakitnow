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

const responseSchema = {
  type: "object",
  properties: {
    text: {
      type: "string",
      description: "The best English phrase for the user's query.",
    },
    meaning_ja: {
      type: "string",
      description: "Natural Japanese meaning of the phrase.",
    },
    phrase_details: {
      type: "object",
      properties: {
        detailed_meaning: { type: "string" },
        contexts: {
          type: "array",
          items: { type: "string" },
        },
        conversations: {
          type: "array",
          minItems: 3,
          maxItems: 3,
          items: {
            type: "object",
            properties: {
              id: { type: "string" },
              text: { type: "string" },
              meaning_ja: { type: "string" },
              conversation_pair: {
                type: "object",
                properties: {
                  first: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: { type: "string" },
                    },
                    required: ["en", "ja"],
                    additionalProperties: false,
                  },
                  second: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: { type: "string" },
                    },
                    required: ["en", "ja"],
                    additionalProperties: false,
                  },
                },
                required: ["first", "second"],
                additionalProperties: false,
              },
            },
            required: ["id", "text", "meaning_ja", "conversation_pair"],
            additionalProperties: false,
          },
        },
        collocations: {
          type: "array",
          minItems: 1,
          maxItems: 3,
          items: {
            type: "object",
            properties: {
              id: { type: "string" },
              text: { type: "string" },
              meaning_ja: { type: "string" },
              conversation_pair: {
                type: "object",
                properties: {
                  first: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: { type: "string" },
                    },
                    required: ["en", "ja"],
                    additionalProperties: false,
                  },
                  second: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: { type: "string" },
                    },
                    required: ["en", "ja"],
                    additionalProperties: false,
                  },
                },
                required: ["first", "second"],
                additionalProperties: false,
              },
            },
            required: ["id", "text", "meaning_ja", "conversation_pair"],
            additionalProperties: false,
          },
        },
        examples: {
          type: "array",
          minItems: 1,
          maxItems: 3,
          items: {
            type: "object",
            properties: {
              id: { type: "string" },
              en: { type: "string" },
              ja: { type: "string" },
            },
            required: ["id", "en", "ja"],
            additionalProperties: false,
          },
        },
        origin: { type: "string" },
        tips: { type: "string" },
        similar: {
          type: "array",
          items: {
            type: "object",
            properties: {
              id: { type: "string" },
              phrase: { type: "string" },
              meaning_ja: { type: "string" },
            },
            required: ["id", "phrase", "meaning_ja"],
            additionalProperties: false,
          },
        },
      },
      required: [
        "detailed_meaning",
        "contexts",
        "conversations",
        "collocations",
        "examples",
        "origin",
        "tips",
        "similar",
      ],
      additionalProperties: false,
    },
  },
  required: ["text", "meaning_ja", "phrase_details"],
  additionalProperties: false,
};

Deno.serve(async (request) => {
  const optionsResponse = handleOptions(request);
  if (optionsResponse) return optionsResponse;

  if (request.method !== "POST") {
    return errorResponse(405, "method_not_allowed", "POSTメソッドを使用してください。");
  }
  if (!(await isAuthenticatedRequest(request))) {
    return errorResponse(401, "unauthorized", "ログインが必要です。");
  }

  try {
    const body = parseObject(await request.json());
    const query = requiredString(body, "query", 500);
    const result = await createStructuredOutput<Record<string, unknown>>({
      schema: responseSchema,
      maxOutputTokens: 8192,
      instructions: [
        "You generate one best English phrase result for a Japanese English-learning dictionary app.",
        "Return exactly one phrase that best matches the user's query.",
        "Write Japanese explanations naturally and clearly for Japanese learners.",
        "Use short stable ids such as conv-1, col-1, ex-1, and sim-1.",
        "Return exactly 3 conversations, 1 to 3 collocations, and 1 to 3 examples.",
        "Make every conversation different and practical for daily conversation.",
      ].join("\n"),
      input: JSON.stringify({ query }),
    });

    return jsonResponse(result);
  } catch (error) {
    if (error instanceof ValidationError || error instanceof SyntaxError) {
      return errorResponse(400, "invalid_request", error.message);
    }
    if (error instanceof GeminiRequestError) {
      return errorResponse(error.status, "llm_error", error.message);
    }
    console.error("Unexpected phrase generation error", error);
    return errorResponse(500, "internal_error", "英語表現の生成中にエラーが発生しました。");
  }
});
