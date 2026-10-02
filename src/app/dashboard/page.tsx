import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export default async function DashboardPage() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("full_name, account_type")
    .eq("user_id", user.id)
    .maybeSingle();

  return (
    <main>
      <h1>Dashboard</h1>
      <p>Welcome{profile?.full_name ? `, ${profile.full_name}` : ""}.</p>
      <p>Role: {profile?.account_type ?? "incomplete"}</p>
      <p>Land discovery and projects will appear here as those modules are implemented.</p>
    </main>
  );
}
