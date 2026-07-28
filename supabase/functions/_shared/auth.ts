function configuredPublishableKeys(): string[] {
  const keys: string[] = [];
  const configuredKeys = Deno.env.get("SUPABASE_PUBLISHABLE_KEYS");

  if (configuredKeys) {
    try {
      const parsed = JSON.parse(configuredKeys) as Record<string, unknown>;
      for (const value of Object.values(parsed)) {
        if (typeof value === "string") {
          keys.push(value);
        }
      }
    } catch {
      console.error("SUPABASE_PUBLISHABLE_KEYS is not valid JSON");
    }
  }

  const legacyKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (legacyKey) {
    keys.push(legacyKey);
  }

  return keys;
}

export function hasValidPublishableKey(request: Request): boolean {
  const apiKey = request.headers.get("apikey");
  if (!apiKey) {
    return false;
  }
  return configuredPublishableKeys().includes(apiKey);
}

export async function isAuthenticatedRequest(request: Request): Promise<boolean> {
  if (!hasValidPublishableKey(request)) {
    return false;
  }

  const authorization = request.headers.get("authorization");
  const apiKey = request.headers.get("apikey");
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  if (
    !authorization?.startsWith("Bearer ") ||
    authorization === `Bearer ${apiKey}` ||
    !apiKey ||
    !supabaseUrl
  ) {
    return false;
  }

  try {
    const response = await fetch(`${supabaseUrl}/auth/v1/user`, {
      headers: {
        apikey: apiKey,
        authorization,
      },
    });
    return response.ok;
  } catch (error) {
    console.error("Failed to validate Supabase user", error);
    return false;
  }
}
