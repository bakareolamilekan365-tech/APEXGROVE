import { describe, expect, it } from "vitest";
import { accountRoleSchema } from "@/lib/auth/roles";

describe("account roles", () => {
  it("accepts the supported prototype roles", () => {
    expect(accountRoleSchema.parse("buyer")).toBe("buyer");
    expect(accountRoleSchema.parse("professional")).toBe("professional");
  });

  it("rejects unsupported roles", () => {
    expect(accountRoleSchema.safeParse("government").success).toBe(false);
  });
});