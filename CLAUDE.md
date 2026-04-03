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

## Architecture DB
Schéma i18n : toutes les tables de contenu ont une table _translations associée.
Exception connue : table education sans traductions (à traiter).