# Portfolio — État du projet
Dernière mise à jour : 2026-04-03

## État global
Phase actuelle : Setup initial
Pourcentage estimé : 10%

## Features terminées
- [x] Setup Next.js + Tailwind + next-intl + next-themes
- [ ] Types TypeScript depuis schéma SQL
- [ ] Client PostgreSQL + structure queries/
...

## Dernière session
Date : 2026-04-03
Agent(s) utilisé(s) : ARCH, GIT
Ce qui a été fait : Initialisation projet Next.js 14, structure dossiers, placement fichiers SQL, configuration .gitignore, tailwind.config.ts avec tokens design
Décision importante prise : education sans traductions pour l'instant — diplômes affichés en FR dans les deux langues, à réévaluer

## Points bloquants
- Paths images dans seed.sql pas encore renseignés (cover_image, file_path) (-- Exemple de ce que ça doit donner
UPDATE projects SET cover_image = '/images/projects/dashboard-sante/cover.png' WHERE slug = 'dashboard-sante';)
- next-intl pas encore configuré
- DB créée et seedée mais pas encore connectée à l'app

## Décisions d'architecture prises
- Server Components par défaut, Client Components uniquement pour interactivité
- Requêtes SQL uniquement dans src/lib/db/queries/ via Server Actions
- light/dark (pas day/night) pour les variantes de thème
- migrations/ pour le schéma versionné, scripts/ pour seed et reset


### Architecture du projet

portfolio_developpeuse_ia/
├── CLAUDE.md
├── doc/
│   ├── apprentissage/
│   │   └── db_learn/
│   │       ├── db_apprentissage.md
│   │       ├── note_cours_migrations.html
│   │       └── schemas/
│   │           ├── dev_workflow_environments.svg
│   │           ├── fichiers_vers_serveur.svg
│   │           ├── image_storage_flow.svg
│   │           ├── nextjs_i18n_routing.svg
│   │           └── volumes_docker_explication.svg
│   ├── db_doc/
│   │   ├── description_table_portfolio.pdf
│   │   ├── portfolio_schema_complet.pdf
│   │   └── schema_db.pdf
│   ├── design/
│   │   ├── design-spec-portfolio-salome.md
│   │   └── screen_figma/
│   │       ├── portfolio_dark/
│   │       │   ├── Détail d'un projet.png
│   │       │   ├── Home page dark.png
│   │       │   ├── Page tous projets.png
│   │       │   └── Page toutes compétences.png
│   │       └── portfolio_day/
│   │           ├── Détail d'un projet.png
│   │           ├── Home Page.png
│   │           ├── Page tous projets.png
│   │           └── Page toutes compétences.png
│   ├── guide_utilisation_projet_claude.md
│   ├── instruction_claude_project.txt
│   └── note.txt
├── eslint.config.mjs
├── migrations/
├── next.config.ts
├── next-env.d.ts
├── package.json
├── package-lock.json
├── postcss.config.mjs
├── prettier.config.js
├── progress.md
├── public/
│   └── images/
│       ├── design/
│       │   ├── aureole/
│       │   │   ├── dark/
│       │   │   │   ├── aureole_left.png
│       │   │   │   └── aureole_right.png
│       │   │   └── light/
│       │   │       ├── aureole_left.png
│       │   │       └── aureole_right.png
│       │   ├── clouds/
│       │   │   ├── dark/
│       │   │   │   ├── all_clouds.png
│       │   │   │   ├── cloud_girl.png
│       │   │   │   ├── cloud_left_bottom.png
│       │   │   │   ├── cloud_left_max.png
│       │   │   │   ├── cloud_left_top.png
│       │   │   │   ├── cloud_right_bottom.png
│       │   │   │   └── cloud_right_top.png
│       │   │   └── light/
│       │   │       ├── all_clouds.png
│       │   │       ├── cloud_girl.png
│       │   │       ├── cloud_left_bottom.png
│       │   │       ├── cloud_left_max.png
│       │   │       ├── cloud_left_top.png
│       │   │       ├── cloud_right_bottom.png
│       │   │       ├── cloud_right_top.png
│       │   │       └── unuse_cloud.png
│       │   └── stars/
│       │       ├── image 18.png
│       │       ├── image 21.png
│       │       ├── image 22.png
│       │       ├── image 23.png
│       │       ├── image 24.png
│       │       ├── image 29.png
│       │       ├── image 30.png
│       │       ├── image 31.png
│       │       └── image 32.png
│       ├── logo/
│       │   └── S_logo.png
│       ├── media/
│       └── projects/
│           └── dashboard-sante/
│               ├── apercu-1.png
│               ├── apercu-2.png
│               └── cover.png
├── README.md
├── scripts/
├── src/
│   ├── app/
│   │   ├── favicon.ico
│   │   ├── globals.css
│   │   │   ├── icon.tsx
│   │   ├── layout.tsx
│   │   └── [locale]/
│   │       ├── layout.tsx
│   │       ├── page.tsx
│   │       ├── projects/
│   │       │   ├── page.tsx
│   │       │   └── [slug]/
│   │       │       └── page.tsx
│   │       └── skills/
│   │           └── page.tsx
│   ├── components/
│   │   ├── features/
│   │   ├── layout/
│   │   └── ui/
│   ├── lib/
│   │   ├── constants/
│   │   ├── db/
│   │   │   ├── client.ts
│   │   │   └── queries/
│   │   │       ├── media.ts
│   │   │       ├── projects.ts
│   │   │       └── skills.ts
│   │   └── utils/
│   ├── messages/
│   │   ├── en.json
│   │   └── fr.json
│   └── types/
└── tsconfig.json


