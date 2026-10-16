import Link from "next/link";
import { notFound } from "next/navigation";
import { AssignmentForm } from "@/components/cases/AssignmentForm";
import { CaseStatusBadge } from "@/components/cases/CaseStatusBadge";
import { StatusTransitionForm } from "@/components/cases/StatusTransitionForm";
import styles from "@/components/cases/case-workflow.module.css";
import { requireStaff } from "@/lib/auth/guards";
import { caseStatusLabels } from "@/lib/verification-cases/status";
import type { CaseStatusEvent, StaffMember, VerificationCase } from "@/types/verification";

export const dynamic = "force-dynamic";

type AssignmentRow = {
  id: string;
  assignee_user_id: string;
  assigned_by_user_id: string;
  status: string;
  created_at: string;
};

export default async function OperationsCasePage({
  params,
}: Readonly<{ params: Promise<{ id: string }> }>) {
  const { id } = await params;
  const { supabase, user, staff: currentStaff } = await requireStaff();

  const [{ data: caseData }, { data: eventData }, { data: assignmentData }] = await Promise.all([
    supabase.from("verification_cases").select("*").eq("id", id).maybeSingle(),
    supabase.from("case_status_events").select("*").eq("verification_case_id", id).order("created_at", { ascending: false }),
    supabase.from("case_assignments").select("id, assignee_user_id, assigned_by_user_id, status, created_at").eq("verification_case_id", id).order("created_at", { ascending: false }),
  ]);
  if (!caseData) notFound();

  const item = caseData as VerificationCase;
  const events = (eventData ?? []) as CaseStatusEvent[];
  const assignments = (assignmentData ?? []) as AssignmentRow[];
  const activeAssignment = assignments.find((assignment) => assignment.status === "active");
  const isAssignee = activeAssignment?.assignee_user_id === user.id;

  let departmentStaff: StaffMember[] = [];
  if (currentStaff.is_lead && currentStaff.department === item.department) {
    const { data } = await supabase
      .from("staff_members")
      .select("user_id, department, is_lead, active")
      .eq("department", item.department)
      .eq("active", true)
      .order("is_lead", { ascending: false });
    departmentStaff = (data ?? []) as StaffMember[];
  }

  return (
    <main className={styles.shell}>
      <div className={styles.headerRow}>
        <div>
          <p className={styles.eyebrow}>{item.department} · Case {item.id.slice(0, 8)}</p>
          <h1>{item.area_lga}, Abuja</h1>
          <div className={styles.metaRow}>
            <span className={styles.demo}>Demo data · not official</span>
            <CaseStatusBadge status={item.workflow_status} />
          </div>
        </div>
        <Link className={`${styles.button} ${styles.buttonSecondary}`} href="/ops/cases">Back to queue</Link>
      </div>

      <div className={styles.twoColumn}>
        <div className={styles.stack}>
          <section className={styles.panel}>
            <p className={styles.eyebrow}>Request details</p>
            <h2>{item.site_description}</h2>
            <p><strong>Customer:</strong> {item.customer_user_id}</p>
            <p><strong>Contact preference:</strong> {item.contact_preference}</p>
            <p><strong>Customer notes:</strong> {item.customer_notes || "None supplied"}</p>
            <div className={styles.notice}>This case is a coordination record. It is not a verified title, survey, boundary or government record.</div>
          </section>

          <section className={styles.panel}>
            <h2>Append-only timeline</h2>
            <ol className={styles.timeline}>
              {events.map((event) => (
                <li key={event.id}>
                  <strong>{caseStatusLabels[event.to_status]}</strong>
                  <p>{event.reason}</p>
                  <p className={`${styles.muted} ${styles.small}`}>
                    Actor {event.actor_user_id.slice(0, 8)} · {event.customer_visible ? "Customer visible" : "Staff only"}
                  </p>
                  <time className={`${styles.muted} ${styles.small}`} dateTime={event.created_at}>
                    {new Intl.DateTimeFormat("en-NG", { dateStyle: "medium", timeStyle: "short" }).format(new Date(event.created_at))}
                  </time>
                </li>
              ))}
            </ol>
          </section>
        </div>

        <aside className={styles.stack}>
          {item.workflow_status === "submitted" && currentStaff.is_lead && currentStaff.department === item.department ? (
            <section className={styles.card}>
              <h2>Assign case</h2>
              <p className={styles.muted}>Only an active department lead can assign manually.</p>
              <AssignmentForm caseId={item.id} staff={departmentStaff} />
            </section>
          ) : null}

          {activeAssignment ? (
            <section className={styles.card}>
              <p className={styles.eyebrow}>Active assignment</p>
              <h2>{activeAssignment.assignee_user_id.slice(0, 8)}</h2>
              <p className={styles.muted}>Assigned by {activeAssignment.assigned_by_user_id.slice(0, 8)}</p>
            </section>
          ) : null}

          {isAssignee ? (
            <section className={styles.card}>
              <h2>Move status</h2>
              <p className={styles.muted}>A note and actor timestamp are recorded with every move.</p>
              <StatusTransitionForm caseId={item.id} currentStatus={item.workflow_status} />
            </section>
          ) : null}
        </aside>
      </div>
    </main>
  );
}
