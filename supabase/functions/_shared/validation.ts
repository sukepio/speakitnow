export class ValidationError extends Error {}

export function parseObject(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new ValidationError("リクエストの形式が正しくありません。");
  }
  return value as Record<string, unknown>;
}

export function requiredString(
  object: Record<string, unknown>,
  key: string,
  maxLength: number,
): string {
  const value = object[key];
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new ValidationError(`${key}は必須です。`);
  }

  const trimmed = value.trim();
  if (trimmed.length > maxLength) {
    throw new ValidationError(`${key}が長すぎます。`);
  }
  return trimmed;
}

export function requiredInteger(
  object: Record<string, unknown>,
  key: string,
  minimum: number,
  maximum: number,
): number {
  const value = object[key];
  if (
    typeof value !== "number" || !Number.isInteger(value) || value < minimum ||
    value > maximum
  ) {
    throw new ValidationError(
      `${key}は${minimum}〜${maximum}の整数で指定してください。`,
    );
  }
  return value;
}
