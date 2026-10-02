create table if not exists public.audit_logs (
	id uuid primary key default gen_random_uuid(),
	actor_user_id uuid references auth.users(id) on delete set null,
	action text not null,
	entity_type text not null,
	entity_id uuid,
	metadata jsonb not null default '{}'::jsonb,
	created_at timestamptz not null default now()
);