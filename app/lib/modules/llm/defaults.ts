const DEFAULT_PROVIDER_FALLBACK = 'Ollama';
const DEFAULT_MODEL_FALLBACK = 'gemma4:e4b';

function getConfiguredEnvValue(env: Record<string, string | undefined>, keys: string[]) {
  for (const key of keys) {
    const value = env[key]?.trim();

    if (value) {
      return value;
    }
  }

  return undefined;
}

export function resolveDefaultProviderName(env: Record<string, string | undefined> = {}) {
  return getConfiguredEnvValue(env, ['DEFAULT_LLM_PROVIDER', 'VITE_DEFAULT_LLM_PROVIDER']) || DEFAULT_PROVIDER_FALLBACK;
}

export function resolveDefaultModelName(env: Record<string, string | undefined> = {}) {
  return getConfiguredEnvValue(env, ['DEFAULT_LLM_MODEL', 'VITE_DEFAULT_LLM_MODEL']) || DEFAULT_MODEL_FALLBACK;
}
