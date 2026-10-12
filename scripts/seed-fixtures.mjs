import process from "node:process";
import { createClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const password = process.env.DEMO_SEED_PASSWORD;

if (!url || !serviceKey || !password) {
  throw new Error("Set NEXT_PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, and DEMO_SEED_PASSWORD before seeding synthetic fixtures.");
}

const supabase = createClient(url, serviceKey, { auth: { autoRefreshToken: false, persistSession: false } });
const fixtures = [
  { email: "demo.buyer@apexgrove.invalid", full_name: "DEMO Buyer", account_type: "buyer" },
  { email: "demo.landowner@apexgrove.invalid", full_name: "DEMO Landowner", account_type: "landowner" },
  { email: "demo.developer@apexgrove.invalid", full_name: "DEMO Developer", account_type: "developer" },
  { email: "demo.professional@apexgrove.invalid", full_name: "DEMO Professional", account_type: "professional" },
  { email: "demo.admin@apexgrove.invalid", full_name: "DEMO Admin", account_type: "admin" },
];

const users = [];
for (const fixture of fixtures) {
  const created = await supabase.auth.admin.createUser({ email: fixture.email, password, email_confirm: true, user_metadata: { full_name: fixture.full_name, synthetic_demo: true } });
  let user = created.data.user;
  if (created.error && !created.error.message.toLowerCase().includes("already")) throw created.error;
  if (!user) {
    const listed = await supabase.auth.admin.listUsers({ page: 1, perPage: 1000 });
    user = listed.data.users.find((candidate) => candidate.email === fixture.email);
  }
  if (!user) throw new Error(`Could not find synthetic fixture user ${fixture.email}`);
  users.push({ ...fixture, id: user.id });
  const { error } = await supabase.from("profiles").upsert({ user_id: user.id, full_name: fixture.full_name, account_type: fixture.account_type, location_text: "DEMO / NOT OFFICIAL — Abuja sample", bio: "Synthetic fixture only." }, { onConflict: "user_id" });
  if (error) throw error;
}

const owner = users.find((user) => user.account_type === "landowner");
if (!owner) throw new Error("Synthetic landowner fixture missing");
const organizationId = "00000000-0000-0000-0000-000000000101";
const { error: organizationError } = await supabase.from("organizations").upsert({ id: organizationId, created_by: owner.id, name: "DEMO Abuja Land Cooperative", organization_type: "demo", description: "DEMO DATA / NOT OFFICIAL", location_text: "Abuja sample area", verification_status: "unverified" }, { onConflict: "id" });
if (organizationError) throw organizationError;

globalThis.console.log(`Seeded ${users.length} synthetic demo users and organization ${organizationId}. No real credentials or official records were added.`);
