import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

const url = process.env.SUPABASE_TEST_URL ?? process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_TEST_SERVICE_ROLE_KEY ?? process.env.SUPABASE_SERVICE_ROLE_KEY;
const anonKey = process.env.SUPABASE_TEST_ANON_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const configured = Boolean(url && serviceKey && anonKey);
const suite = configured ? describe : describe.skip;

suite("foundation database authorization", () => {
  let admin: SupabaseClient;
  let first: SupabaseClient;
  let second: SupabaseClient;
  let firstId = "";
  let secondId = "";
  let firstEmail = "";
  let secondEmail = "";

  beforeAll(async () => {
    admin = createClient(url!, serviceKey!, { auth: { autoRefreshToken: false, persistSession: false } });
    const suffix = `${Date.now()}-${Math.random().toString(36).slice(2)}`;
    firstEmail = `foundation-owner-${suffix}@example.invalid`;
    secondEmail = `foundation-other-${suffix}@example.invalid`;
    const firstUser = await admin.auth.admin.createUser({ email: firstEmail, password: "Foundation-test-password-123!", email_confirm: true });
    const secondUser = await admin.auth.admin.createUser({ email: secondEmail, password: "Foundation-test-password-123!", email_confirm: true });
    if (firstUser.error || secondUser.error || !firstUser.data.user || !secondUser.data.user) throw firstUser.error ?? secondUser.error ?? new Error("Could not create test users");
    firstId = firstUser.data.user.id;
    secondId = secondUser.data.user.id;
    first = createClient(url!, anonKey!, { auth: { autoRefreshToken: false, persistSession: false } });
    second = createClient(url!, anonKey!, { auth: { autoRefreshToken: false, persistSession: false } });
    await first.auth.signInWithPassword({ email: firstEmail, password: "Foundation-test-password-123!" });
    await second.auth.signInWithPassword({ email: secondEmail, password: "Foundation-test-password-123!" });
  });

  afterAll(async () => {
    if (firstId) await admin.auth.admin.deleteUser(firstId);
    if (secondId) await admin.auth.admin.deleteUser(secondId);
  });

  it("allows own profile access and denies another user's profile", async () => {
    const own = await first.from("profiles").select("user_id").eq("user_id", firstId).maybeSingle();
    const other = await first.from("profiles").select("user_id").eq("user_id", secondId).maybeSingle();
    expect(own.error).toBeNull();
    expect(own.data?.user_id).toBe(firstId);
    expect(other.error).toBeNull();
    expect(other.data).toBeNull();
  });

  it("blocks admin escalation and organization spoofing", async () => {
    const escalation = await first.from("profiles").update({ account_type: "admin" }).eq("user_id", firstId);
    expect(escalation.error).not.toBeNull();
    const spoofed = await first.from("organizations").insert({ name: "DEMO SECURITY TEST", organization_type: "demo", created_by: secondId, verification_status: "unverified" });
    expect(spoofed.error).not.toBeNull();
    const verified = await first.from("organizations").insert({ name: "DEMO SECURITY TEST", organization_type: "demo", created_by: firstId, verification_status: "verified" });
    expect(verified.error).not.toBeNull();
  });

  it("keeps document storage scoped to the owning user", async () => {
    const path = `documents/${firstId}/foundation-${Date.now()}.txt`;
    const upload = await first.storage.from("documents").upload(path, new Blob(["DEMO DATA / NOT OFFICIAL"]));
    expect(upload.error).toBeNull();
    const denied = await second.storage.from("documents").download(path);
    expect(denied.error).not.toBeNull();
    await admin.storage.from("documents").remove([path]);
  });
});
