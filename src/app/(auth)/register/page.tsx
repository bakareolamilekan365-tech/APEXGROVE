"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { createSupabaseClient } from "@/lib/supabase/client";
import { accountRoles, type AccountRole } from "@/lib/auth/roles";

export default function RegisterPage() {
  const router = useRouter();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [accountType, setAccountType] = useState<AccountRole>("buyer");
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage(null);
    setError(null);

    const { data, error: signUpError } = await createSupabaseClient().auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName, account_type: accountType } },
    });

    if (signUpError) {
      setError(signUpError.message);
      return;
    }

    if (data.session) {
      router.push("/dashboard");
      router.refresh();
      return;
    }

    setMessage("Check your email to confirm your account, then sign in.");
  }

  return (
    <main>
      <h1>Create your account</h1>
      <form onSubmit={handleSubmit}>
        <label htmlFor="full-name">Full name</label>
        <input id="full-name" value={fullName} onChange={(event) => setFullName(event.target.value)} required />
        <label htmlFor="email">Email</label>
        <input id="email" type="email" value={email} onChange={(event) => setEmail(event.target.value)} required />
        <label htmlFor="password">Password</label>
        <input id="password" type="password" minLength={8} value={password} onChange={(event) => setPassword(event.target.value)} required />
        <label htmlFor="account-type">I am joining as</label>
        <select id="account-type" value={accountType} onChange={(event) => setAccountType(event.target.value as AccountRole)}>
          {accountRoles.map((role) => <option key={role} value={role}>{role}</option>)}
        </select>
        {message ? <p role="status">{message}</p> : null}
        {error ? <p role="alert">{error}</p> : null}
        <button type="submit">Create account</button>
      </form>
      <p><a href="/login">Already have an account?</a></p>
    </main>
  );
}
