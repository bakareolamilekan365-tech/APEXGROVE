import { describe, expect, it } from "vitest";
import {
  availableCaseTransitions,
  canTransitionVerificationCase,
  caseStatusLabels,
} from "@/lib/verification-cases/status";

describe("verification case status transitions", () => {
  it.each([
    ["assigned", "in_review"],
    ["in_review", "needs_customer_info"],
    ["needs_customer_info", "in_review"],
    ["in_review", "closed"],
    ["in_review", "cancelled"],
  ] as const)("allows %s -> %s", (from, to) => {
    expect(canTransitionVerificationCase(from, to)).toBe(true);
  });

  it.each([
    ["submitted", "in_review"],
    ["assigned", "closed"],
    ["needs_customer_info", "closed"],
    ["closed", "in_review"],
    ["cancelled", "submitted"],
  ] as const)("rejects %s -> %s", (from, to) => {
    expect(canTransitionVerificationCase(from, to)).toBe(false);
  });

  it("offers only the transitions valid for the current state", () => {
    expect(availableCaseTransitions("in_review")).toEqual([
      "needs_customer_info",
      "closed",
      "cancelled",
    ]);
    expect(availableCaseTransitions("closed")).toEqual([]);
  });

  it("keeps the submitted label honest", () => {
    expect(caseStatusLabels.submitted).toBe("Received — not yet verified");
    expect(caseStatusLabels.submitted.toLowerCase()).not.toBe("verified");
    expect(caseStatusLabels.closed).toBe("Closed — no verification result issued");
  });
});
