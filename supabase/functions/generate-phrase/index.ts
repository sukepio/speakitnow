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
      description: "Natural Japanese meaning written in Japanese only.",
    },
    phrase_details: {
      type: "object",
      properties: {
        detailed_meaning: {
          type: "string",
          description: "Detailed explanation written in natural Japanese.",
        },
        contexts: {
          type: "array",
          description: "Usage contexts explained in natural Japanese.",
          items: {
            type: "string",
            description: "One usage context written in Japanese.",
          },
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
              meaning_ja: {
                type: "string",
                description: "Japanese meaning written in Japanese.",
              },
              conversation_pair: {
                type: "object",
                properties: {
                  first: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: {
                        type: "string",
                        description: "Japanese translation written in Japanese.",
                      },
                    },
                    required: ["en", "ja"],
                    additionalProperties: false,
                  },
                  second: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: {
                        type: "string",
                        description: "Japanese translation written in Japanese.",
                      },
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
              meaning_ja: {
                type: "string",
                description: "Japanese meaning written in Japanese.",
              },
              conversation_pair: {
                type: "object",
                properties: {
                  first: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: {
                        type: "string",
                        description: "Japanese translation written in Japanese.",
                      },
                    },
                    required: ["en", "ja"],
                    additionalProperties: false,
                  },
                  second: {
                    type: "object",
                    properties: {
                      en: { type: "string" },
                      ja: {
                        type: "string",
                        description: "Japanese translation written in Japanese.",
                      },
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
              ja: {
                type: "string",
                description: "Japanese translation written in Japanese.",
              },
            },
            required: ["id", "en", "ja"],
            additionalProperties: false,
          },
        },
        origin: {
          type: "string",
          description: "Origin and etymology explained in natural Japanese.",
        },
        tips: {
          type: "string",
          description: "Usage tips explained in natural Japanese.",
        },
        similar: {
          type: "array",
          items: {
            type: "object",
            properties: {
              id: { type: "string" },
              phrase: { type: "string" },
              meaning_ja: {
                type: "string",
                description: "Japanese meaning written in Japanese.",
              },
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

const japaneseCharacterPattern =
  /[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}]/u;

function findNonJapaneseExplanationPaths(
  result: Record<string, unknown>,
): string[] {
  const invalidPaths: string[] = [];
  const phraseDetails = result.phrase_details as Record<string, unknown>;

  const check = (path: string, value: unknown) => {
    if (typeof value !== "string" || !japaneseCharacterPattern.test(value)) {
      invalidPaths.push(path);
    }
  };

  const checkArray = (
    path: string,
    value: unknown,
    checkItem: (itemPath: string, item: Record<string, unknown>) => void,
  ) => {
    if (!Array.isArray(value)) return;
    value.forEach((item, index) => {
      checkItem(`${path}[${index}]`, item as Record<string, unknown>);
    });
  };

  check("meaning_ja", result.meaning_ja);
  check("phrase_details.detailed_meaning", phraseDetails.detailed_meaning);
  if (Array.isArray(phraseDetails.contexts)) {
    phraseDetails.contexts.forEach((context, index) => {
      check(`phrase_details.contexts[${index}]`, context);
    });
  }
  check("phrase_details.origin", phraseDetails.origin);
  check("phrase_details.tips", phraseDetails.tips);

  checkArray("phrase_details.conversations", phraseDetails.conversations, (path, item) => {
    check(`${path}.meaning_ja`, item.meaning_ja);
    checkConversationPair(`${path}.conversation_pair`, item.conversation_pair, check);
  });
  checkArray("phrase_details.collocations", phraseDetails.collocations, (path, item) => {
    check(`${path}.meaning_ja`, item.meaning_ja);
    checkConversationPair(`${path}.conversation_pair`, item.conversation_pair, check);
  });
  checkArray("phrase_details.examples", phraseDetails.examples, (path, item) => {
    check(`${path}.ja`, item.ja);
  });
  checkArray("phrase_details.similar", phraseDetails.similar, (path, item) => {
    check(`${path}.meaning_ja`, item.meaning_ja);
  });

  return invalidPaths;
}

function checkConversationPair(
  path: string,
  value: unknown,
  check: (path: string, value: unknown) => void,
) {
  const pair = value as Record<string, Record<string, unknown>>;
  check(`${path}.first.ja`, pair.first?.ja);
  check(`${path}.second.ja`, pair.second?.ja);
}

const japaneseExplanationInstructions = [
  "All explanatory and translation fields must be written in natural Japanese.",
  "The Japanese-only fields are meaning_ja, detailed_meaning, contexts, origin, tips, every ja field, and every nested meaning_ja field.",
  "Never write an explanatory sentence only in English. English words may appear only when quoted inside an otherwise Japanese explanation.",
  "The English-only fields are text, en, phrase, and id. Do not translate those fields into Japanese.",
].join("\n");

async function generatePhrase(
  query: string,
  invalidPaths: string[] = [],
): Promise<Record<string, unknown>> {
  const retryInstruction = invalidPaths.length > 0
    ? `The previous response used non-Japanese text in these fields: ${invalidPaths.join(", ")}. Correct every listed field and return all explanations in Japanese.`
    : "";

  return await createStructuredOutput<Record<string, unknown>>({
    schema: responseSchema,
    maxOutputTokens: 8192,
    instructions: [
      "You generate one best English phrase result for a Japanese English-learning dictionary app.",
      "Return exactly one phrase that best matches the user's query.",
      japaneseExplanationInstructions,
      "Use short stable ids such as conv-1, col-1, ex-1, and sim-1.",
      "Return exactly 3 conversations, 1 to 3 collocations, and 1 to 3 examples.",
      "Make every conversation different and practical for daily conversation.",
      retryInstruction,
    ].filter(Boolean).join("\n"),
    input: JSON.stringify({ query }),
  });
}

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
    let result = await generatePhrase(query);
    let invalidPaths = findNonJapaneseExplanationPaths(result);

    if (invalidPaths.length > 0) {
      console.warn("Retrying phrase generation for non-Japanese explanations", {
        invalidPaths,
      });
      result = await generatePhrase(query, invalidPaths);
      invalidPaths = findNonJapaneseExplanationPaths(result);
    }

    if (invalidPaths.length > 0) {
      console.error("Phrase generation still contained non-Japanese explanations", {
        invalidPaths,
      });
      throw new GeminiRequestError(
        "日本語の解説を生成できませんでした。もう一度お試しください。",
        502,
      );
    }

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
