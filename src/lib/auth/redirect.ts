const PLACEHOLDER_ORIGIN = "http://redirect-check.invalid";

/**
 * Allow only same-app relative destinations; never reflect arbitrary URLs.
 * Rejects backslashes and control characters (browsers treat "/\host" and "/<tab>/host"
 * like "//host"), then parses the value and confirms the origin did not change.
 */
export function safeInternalPath(value: string | null | undefined, fallback = "/dashboard") {
  if (!value || !value.startsWith("/") || value.startsWith("//")) {
    return fallback;
  }
  const hasControlCharacter = Array.from(value).some((character) => {
    const codePoint = character.codePointAt(0) ?? 0;
    return codePoint <= 0x1f || codePoint === 0x7f;
  });
  if (value.includes("\\") || hasControlCharacter) {
    return fallback;
  }
  try {
    const parsed = new URL(value, PLACEHOLDER_ORIGIN);
    if (parsed.origin !== PLACEHOLDER_ORIGIN) {
      return fallback;
    }
    return `${parsed.pathname}${parsed.search}${parsed.hash}`;
  } catch {
    return fallback;
  }
}
