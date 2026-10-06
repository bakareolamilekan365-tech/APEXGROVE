import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export default async function DashboardPage() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("full_name, account_type, location_text, bio")
    .eq("user_id", user.id)
    .maybeSingle();

  const role = profile?.account_type ?? "buyer";
  const roleCopy: Record<string, string> = {
    buyer: "Explore opportunities and keep your next property decision organized.",
    landowner: "Prepare your land information for future discovery and verification workflows.",
    developer: "Plan your future project workspace and connect the right professionals.",
    professional: "Prepare your professional profile for future project collaboration.",
    admin: "Review foundation activity and security responsibilities within your assigned scope.",
  };

  return (
    <main>
      <h1>Dashboard</h1>
      <p>Welcome{profile?.full_name ? `, ${profile.full_name}` : ""}.</p>
      <p>Platform role: {role}</p>
      <p>{roleCopy[role] ?? "Your role-aware workspace is being prepared."}</p>
      <section aria-label="Planned modules">
        <h2>Coming next</h2>
        <ul>
          <li>Land discovery and GIS: planned foundation work</li>
          <li>Verification and private documents: planned trust workflows</li>
          <li>Projects and professionals: planned collaboration workflows</li>
        </ul>
      </section>
    </main>
  );
}
