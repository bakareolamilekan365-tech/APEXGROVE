"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { createSupabaseClient } from "@/lib/supabase/client";
import { accountRoles, type AccountRole } from "@/lib/auth/roles";

export default function RolePage() {
  const router = useRouter();
  const [role, setRole] = useState<AccountRole>("buyer");
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const {
      data: { user },
    } = await createSupabaseClient().auth.getUser();
    if (!user) {
      router.push("/login");
      return;
    }

    const { error: updateError } = await createSupabaseClient()
      .from("profiles")
      .update({ account_type: role })
      .eq("user_id", user.id);

    if (updateError) {
      setError(updateError.message);
      return;
    }

    router.push("/dashboard");
    router.refresh();
  }

  return (
    <main>
      <h1>Choose your role</h1>
      <form onSubmit={handleSubmit}>
        <label htmlFor="role">I am joining as</label>
        <select
          id="role"
          value={role}
          onChange={(event) => setRole(event.target.value as AccountRole)}
        >
          {accountRoles.map((option) => (
            <option key={option} value={option}>
              {option}
            </option>
          ))}
        </select>
        {error ? <p role="alert">{error}</p> : null}
        <button type="submit">Continue</button>
      </form>
    </main>
  );
}
