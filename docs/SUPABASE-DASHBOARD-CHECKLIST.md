# Supabase dashboard checklist

These are settings in the Supabase dashboard, not in the repo. Tick and date each one.

- [ ] Auth: minimum password length set to 8 or more. Verify: try registering with a 6-character password; it should be rejected.
- [ ] Auth: email confirmation turned on. Verify: a new sign-up should not get a session until the email link is used.
- [ ] Auth: leaked-password protection turned on (may require a paid plan; note the plan outcome here: [FILL IN]).
- [ ] Auth URL configuration: site URL and allowed redirect URLs include the implemented `/auth/callback` and password-recovery destinations before the branch is deployed.
- [ ] Confirm no service-role key is present in any client-side code or `.env` committed to git.
- [ ] Run migrations `015`–`017` and both pgTAP suites in an isolated Docker-capable environment or GitHub Actions before applying them to the hosted project.
- [ ] Apply migrations `015`–`017` through the reviewed deployment workflow only after the database tests pass.
- [ ] Re-run the Supabase security advisors after migrations `015`–`017` are applied and record the result in the audit addendum.
