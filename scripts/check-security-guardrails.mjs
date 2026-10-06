import process from "node:process";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const migrationsDir = join(process.cwd(), "supabase", "migrations");
const files = readdirSync(migrationsDir).filter((file) => file.endsWith(".sql"));
const sql = files.map((file) => readFileSync(join(migrationsDir, file), "utf8")).join("\n");
const tables = [...sql.matchAll(/create table if not exists public\.([a-z_][a-z0-9_]*)/gi)].map((match) => match[1]);
const missingRls = [...new Set(tables)].filter((table) => {
  const pattern = new RegExp(`alter\\s+table\\s+public\\.${table}\\s+enable\\s+row\\s+level\\s+security`, "i");
  return !pattern.test(sql);
});

if (missingRls.length > 0) {
  globalThis.console.error(`Application tables without an RLS enablement statement: ${missingRls.join(", ")}`);
  process.exit(1);
}

const hardening = readFileSync(join(migrationsDir, "015_foundation_security_hardening.sql"), "utf8");
if (!/values\s*\('documents',\s*'documents',\s*false\)/i.test(hardening)) {
  globalThis.console.error("The foundation documents bucket must be private by default.");
  process.exit(1);
}
for (const operation of ["select", "insert", "update", "delete"]) {
  if (!new RegExp(`create policy [^\\n]*private documents[\\s\\S]*?for ${operation}`, "i").test(hardening)) {
    globalThis.console.error(`Missing private documents ${operation.toUpperCase()} policy.`);
    process.exit(1);
  }
}

globalThis.console.log(`Security guardrails passed for ${new Set(tables).size} application table(s); system-managed Supabase tables are excluded.`);
