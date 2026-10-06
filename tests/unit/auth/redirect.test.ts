import { describe, expect, it } from "vitest";
import { safeInternalPath } from "@/lib/auth/redirect";

describe("safeInternalPath", () => {
  it("allows a relative in-app path", () => {
    expect(safeInternalPath("/update-password")).toBe("/update-password");
  });

  it("rejects external and protocol-relative redirects", () => {
    expect(safeInternalPath("https://example.com")).toBe("/dashboard");
    expect(safeInternalPath("//example.com")).toBe("/dashboard");
  });
});
