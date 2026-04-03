@AGENTS.md
# Portfolio Salomé Souque — Contexte Claude

## Stack
Next.js 14 App Router · PostgreSQL (Docker) · Tailwind CSS · next-intl · next-themes

## Conventions
- Server Components par défaut, Client Components uniquement si interactivité
- Requêtes SQL uniquement dans src/lib/db/queries/ via Server Actions
- Jamais de SELECT *
- Toujours filtrer par locale en DB, jamais côté JS
- Conventional Commits : feat/fix/style/refactor/test/chore/docs
- Nommage images : light/dark (pas day/night)

## Architecture DB
Schéma i18n : toutes les tables de contenu ont une table _translations associée.
Exception connue : table education sans traductions — diplômes affichés en FR
dans les deux langues, décision à réévaluer.

## Points techniques à ne pas oublier
- sharp est en devDependencies → à déplacer en dependencies à la phase Docker
- Le middleware next-intl doit être dans src/middleware.ts (pas dans app/, pas dans lib/)
- Les paths d'images en DB sont relatifs à public/ : '/images/projects/...'

## Architecture du projet
portfolio_developpeuse_ia/
├── CLAUDE.md
├── progress.md
├── migrations/
│   └── 001_initial_schema.sql
├── scripts/
│   ├── seed.sql
│   └── reset.sql
├── src/
│   ├── middleware.ts          ← à créer (next-intl)
│   ├── app/
│   │   ├── icon.tsx
│   │   ├── layout.tsx
│   │   ├── globals.css
│   │   └── [locale]/
│   │       ├── layout.tsx
│   │       ├── page.tsx
│   │       ├── projects/
│   │       │   ├── page.tsx
│   │       │   └── [slug]/page.tsx
│   │       └── skills/page.tsx
│   ├── components/
│   │   ├── ui/
│   │   ├── features/
│   │   └── layout/
│   ├── lib/
│   │   ├── db/
│   │   │   ├── client.ts
│   │   │   └── queries/
│   │   │       ├── projects.ts
│   │   │       ├── skills.ts
│   │   │       └── media.ts
│   │   ├── utils/
│   │   └── constants/
│   ├── types/
│   └── messages/
│       ├── fr.json
│       └── en.json
└── public/
    └── images/
        ├── design/
        │   ├── aureole/light/ dark/
        │   ├── clouds/light/ dark/
        │   └── stars/
        ├── logo/
        ├── media/
        └── projects/
            └── dashboard-sante/