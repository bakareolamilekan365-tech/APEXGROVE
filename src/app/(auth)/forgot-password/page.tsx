"use client";

import { FormEvent, useState } from "react";
import { createSupabaseClient } from "@/lib/supabase/client";

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError(null);
    const redirectTo = `${window.location.origin}/auth/callback?next=/update-password`;
    const { error: resetError } = await createSupabaseClient().auth.resetPasswordForEmail(email, { redirectTo });
    if (resetError) {
      setError("We could not start password recovery. Please try again.");
      return;
    }
    // Keep this message identical for known and unknown addresses.
    setSubmitted(true);
  }

  return (
    <main>
      <h1>Forgot password</h1>
      {submitted ? (
        <p role="status">If an account exists for that email, a recovery link is on its way.</p>
      ) : (
        <form onSubmit={handleSubmit}>
          <label htmlFor="recovery-email">Email</label>
          <input id="recovery-email" type="email" value={email} onChange={(event) => setEmail(event.target.value)} required />
          {error ? <p role="alert">{error}</p> : null}
          <button type="submit">Send recovery link</button>
        </form>
      )}
      <p><a href="/login">Back to sign in</a></p>
    </main>
  );
}
