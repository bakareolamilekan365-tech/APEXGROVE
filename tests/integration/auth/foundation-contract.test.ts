import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";

const migration = (name: string) =>
  readFileSync(resolve(process.cwd(), "supabase", "migrations", name), "utf8");

describe("auth foundation migration contract", () => {
  it("provisions profiles when Supabase users are created", () => {
    const sql = migration("002_users_profiles.sql");
    expect(sql).toContain("create table if not exists public.profiles");
    expect(sql).toContain("on_auth_user_created");
    expect(sql).toContain("public.handle_new_user");
  });

  it("defines organization ownership and audit persistence", () => {
    expect(migration("003_organizations.sql")).toContain(
      "organization_owner_on_create",
    );
    expect(migration("012_audit_logs.sql")).toContain("public.audit_logs");
  });

  it("enables row-level security for foundation tables", () => {
    const sql = migration("013_rls_policies.sql");
    expect(sql).toContain(
      "alter table public.profiles enable row level security",
    );
    expect(sql).toContain(
      "alter table public.organizations enable row level security",
    );
    expect(sql).toContain("Admins can view audit logs");
  });
});
