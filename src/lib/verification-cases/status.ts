import type { VerificationCaseStatus } from "@/types/verification";

export const caseStatusLabels: Record<VerificationCaseStatus, string> = {
  draft: "Draft",
  submitted: "Received — not yet verified",
  assigned: "Assigned — not yet verified",
  in_review: "In review — not yet verified",
  needs_customer_info: "More information needed",
  closed: "Completed",
  cancelled: "Cancelled",
};

export const caseStatusTransitions: Readonly<
  Partial<Record<VerificationCaseStatus, readonly VerificationCaseStatus[]>>
> = {
  assigned: ["in_review"],
  in_review: ["needs_customer_info", "closed", "cancelled"],
  needs_customer_info: ["in_review"],
};

export function canTransitionVerificationCase(
  from: VerificationCaseStatus,
  to: VerificationCaseStatus,
) {
  return caseStatusTransitions[from]?.includes(to) ?? false;
}

export function availableCaseTransitions(from: VerificationCaseStatus) {
  return caseStatusTransitions[from] ?? [];
}
