# Instant Composition Edge Functions

## Relationship to the Dashboard function

The existing `generate-phrase` function was created and deployed directly from the Supabase Dashboard. The directories in this repository are local source code only until they are deployed.

Link this repository to the same `SpeakItNOW` project and deploy the two functions. They will then appear next to `generate-phrase` in the same Edge Functions screen and use the same project URL.

## Required secrets

```sh
supabase secrets set GEMINI_API_KEY=your_gemini_api_key
```

Both functions use `models/gemini-flash-lite-latest`, matching the existing `generate-phrase` function.

## Local development

Run the following commands from the repository root (`speakitnow`), not from the
`supabase` directory. On macOS, install the Supabase CLI with Homebrew and start
Docker Desktop or another Docker-compatible container runtime before serving
functions locally.

```sh
brew install supabase/tap/supabase
supabase --version
```

Create `supabase/functions/.env.local` without committing it:

```text
GEMINI_API_KEY=your_gemini_api_key
```

Supabase-provided environment variables such as `SUPABASE_ANON_KEY` are injected
by the local runtime and must not be declared in this file.

Serve each function:

```sh
supabase start
supabase functions serve instant-composition-generate --env-file supabase/functions/.env.local
supabase functions serve instant-composition-evaluate --env-file supabase/functions/.env.local
```

If the initial startup times out while containers are still initializing, run
`supabase start --ignore-health-check` once and wait for the services to finish
starting before serving the functions.

## Deployment

```sh
supabase link --project-ref myajfjhsmscznlknhrxh
supabase functions deploy instant-composition-generate
supabase functions deploy instant-composition-evaluate
```

Both functions require the project's publishable key in the `apikey` request header. Gemini credentials remain server-side.

The repository config disables gateway JWT verification for these two functions because the iOS client authenticates with the publishable `apikey` header. The function code still validates that key before calling Gemini.
