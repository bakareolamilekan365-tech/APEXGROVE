# APEXGROVE — Repository Structure

```text
APEXGROVE/
├── app/
│   ├── (auth)/
│   ├── dashboard/
│   ├── land/
│   ├── map/
│   ├── projects/
│   ├── professionals/
│   ├── properties/
│   ├── documents/
│   ├── ai/
│   ├── admin/
│   └── api/
├── components/
├── features/
├── lib/
├── types/
├── supabase/
│   ├── migrations/
│   ├── functions/
│   └── seed.sql
├── public/
├── data/
│   ├── geojson/
│   └── seed/
├── scripts/
├── tests/
├── .env.example
├── .gitignore
├── next.config.ts
├── package.json
├── tsconfig.json
└── README.md
```

## Organization rule
Keep routing in `app/`, reusable visual primitives in `components/`, domain behavior in `features/`, shared infrastructure in `lib/`, types in `types/`, and database changes in Supabase migrations.
