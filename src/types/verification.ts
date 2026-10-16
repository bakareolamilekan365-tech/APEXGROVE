export const verificationCaseStatuses = [
  "draft",
  "submitted",
  "assigned",
  "in_review",
  "needs_customer_info",
  "closed",
  "cancelled",
] as const;

export type VerificationCaseStatus =
  (typeof verificationCaseStatuses)[number];

export type StaffDepartment = "Verification" | "Feasibility" | "Operations";

export type VerificationCase = {
  id: string;
  customer_user_id: string;
  created_by_user_id: string;
  creation_channel: "customer";
  jurisdiction: "Abuja/FCT";
  department: StaffDepartment;
  site_description: string;
  area_lga: string;
  customer_notes: string | null;
  contact_preference: "email" | "phone" | "whatsapp";
  current_stage: "Request received";
  workflow_status: VerificationCaseStatus;
  assigned_lead_user_id: string | null;
  is_demo_data: boolean;
  created_at: string;
  updated_at: string;
};

export type CaseStatusEvent = {
  id: string;
  verification_case_id: string;
  actor_user_id: string;
  from_status: VerificationCaseStatus | null;
  to_status: VerificationCaseStatus;
  reason: string;
  customer_visible: boolean;
  created_at: string;
};

export type StaffMember = {
  user_id: string;
  department: StaffDepartment;
  is_lead: boolean;
  active: boolean;
};
