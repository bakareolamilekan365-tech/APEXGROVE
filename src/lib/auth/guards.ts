import { createSupabaseServerClient } from "@/lib/supabase/server";
import type { StaffDepartment, StaffMember } from "@/types/verification";

export class AuthorizationError extends Error {
  constructor(message = "You are not authorized to perform this action.") {
    super(message);
    this.name = "AuthorizationError";
  }
}

export async function requireAuthenticatedUser() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new AuthorizationError("Authentication is required.");
  return { supabase, user };
}

export async function requireAdmin() {
  const context = await requireAuthenticatedUser();
  const { data: profile } = await context.supabase.from("profiles").select("account_type").eq("user_id", context.user.id).maybeSingle();
  if (profile?.account_type !== "admin") throw new AuthorizationError("Administrator permission is required.");
  return context;
}

export async function requireStaff() {
  const context = await requireAuthenticatedUser();
  const { data: staff, error } = await context.supabase
    .from("staff_members")
    .select("user_id, department, is_lead, active")
    .eq("user_id", context.user.id)
    .eq("active", true)
    .maybeSingle();

  if (error || !staff) {
    throw new AuthorizationError("Active staff access is required.");
  }

  return { ...context, staff: staff as StaffMember };
}

export async function requireLead(department?: StaffDepartment) {
  const context = await requireStaff();
  if (
    !context.staff.is_lead ||
    (department && context.staff.department !== department)
  ) {
    throw new AuthorizationError("Department lead permission is required.");
  }
  return context;
}

export async function requireOrganizationMembership(organizationId: string, roles?: string[]) {
  const context = await requireAuthenticatedUser();
  const query = context.supabase.from("organization_members").select("organization_id, user_id, role").eq("organization_id", organizationId).eq("user_id", context.user.id).maybeSingle();
  const { data: membership } = await query;
  if (!membership || (roles && !roles.includes(membership.role))) throw new AuthorizationError("Organization membership is required.");
  return { ...context, membership };
}

export async function requireOwnedRow(table: string, id: string, ownerColumn = "user_id") {
  const context = await requireAuthenticatedUser();
  const { data } = await context.supabase.from(table).select("id").eq("id", id).eq(ownerColumn, context.user.id).maybeSingle();
  if (!data) throw new AuthorizationError("You do not own this resource.");
  return context;
}
