"use client";

import { useActionState } from "react";
import {
  transitionVerificationCaseAction,
  type OpsActionState,
} from "@/app/ops/cases/actions";
import { availableCaseTransitions, caseStatusLabels } from "@/lib/verification-cases/status";
import type { VerificationCaseStatus } from "@/types/verification";
import { SubmitButton } from "./SubmitButton";
import styles from "./case-workflow.module.css";

const initialState: OpsActionState = { error: null, success: null };

export function StatusTransitionForm({
  caseId,
  currentStatus,
}: Readonly<{ caseId: string; currentStatus: VerificationCaseStatus }>) {
  const [state, action] = useActionState(
    transitionVerificationCaseAction,
    initialState,
  );
  const transitions = availableCaseTransitions(currentStatus);

  if (transitions.length === 0) {
    return <p className={styles.muted}>No further status moves are available.</p>;
  }

  return (
    <form action={action} className={styles.form}>
      <input type="hidden" name="caseId" value={caseId} />
      <div className={styles.field}>
        <label htmlFor="toStatus">New status</label>
        <select id="toStatus" name="toStatus" required defaultValue="">
          <option value="" disabled>Select the next status</option>
          {transitions.map((status) => (
            <option key={status} value={status}>{caseStatusLabels[status]}</option>
          ))}
        </select>
      </div>
      <div className={styles.field}>
        <label htmlFor="statusNote">Status note</label>
        <textarea id="statusNote" name="note" minLength={2} maxLength={2000} rows={4} required />
      </div>
      <label className={styles.checkbox}>
        <input type="checkbox" name="customerVisible" defaultChecked /> Show this note to the customer
      </label>
      {state.error ? <p className={styles.error} role="alert">{state.error}</p> : null}
      {state.success ? <p className={styles.success} role="status">{state.success}</p> : null}
      <SubmitButton pendingLabel="Updating...">Update status</SubmitButton>
    </form>
  );
}
