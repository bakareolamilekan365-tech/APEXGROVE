import { caseStatusLabels } from "@/lib/verification-cases/status";
import type { VerificationCaseStatus } from "@/types/verification";
import styles from "./case-workflow.module.css";

export function CaseStatusBadge({
  status,
}: Readonly<{ status: VerificationCaseStatus }>) {
  return (
    <span className={`${styles.status} ${styles[`status_${status}`]}`}>
      {caseStatusLabels[status]}
    </span>
  );
}
