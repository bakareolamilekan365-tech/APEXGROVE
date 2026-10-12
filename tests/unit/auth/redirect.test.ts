import { describe, expect, it } from "vitest";
import { safeInternalPath } from "@/lib/auth/redirect";

describe("safeInternalPath", () => {
  it("allows relative in-app paths, including query strings", () => {
    expect(safeInternalPath("/update-password")).toBe("/update-password");
    expect(safeInternalPath("/dashboard?tab=land#top")).toBe("/dashboard?tab=land#top");
  });

  it("falls back for empty values", () => {
    expect(safeInternalPath(null)).toBe("/dashboard");
    expect(safeInternalPath(undefined)).toBe("/dashboard");
    expect(safeInternalPath("")).toBe("/dashboard");
  });

  it("rejects external and protocol-relative redirects", () => {
    expect(safeInternalPath("https://example.com")).toBe("/dashboard");
    expect(safeInternalPath("//example.com")).toBe("/dashboard");
    expect(safeInternalPath("javascript:alert(1)")).toBe("/dashboard");
  });

  it("rejects backslash and control-character bypasses", () => {
    expect(safeInternalPath("/\\example.com")).toBe("/dashboard");
    expect(safeInternalPath("/\t/example.com")).toBe("/dashboard");
    expect(safeInternalPath("/\n/example.com")).toBe("/dashboard");
    expect(safeInternalPath("/\r/example.com")).toBe("/dashboard");
  });

  it("keeps percent-encoded slashes inside the path", () => {
    expect(safeInternalPath("/%2f/example.com")).toBe("/%2f/example.com");
  });

  it("honours a custom fallback", () => {
    expect(safeInternalPath("/\\example.com", "/login")).toBe("/login");
  });
});
