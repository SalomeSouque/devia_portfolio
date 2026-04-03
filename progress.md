# Portfolio — État du projet
Dernière mise à jour : 2026-04-03

## État global
Phase actuelle : Configuration (next-intl + DB + TypeScript)
Pourcentage estimé : 15%

## Features terminées
- [x] Setup Next.js 14 App Router + TypeScript + ESLint + Prettier
- [x] Tailwind CSS avec tokens design complets (couleurs, polices, dark mode)
- [x] Structure de dossiers complète (src/, migrations/, scripts/, doc/)
- [x] Fichiers SQL placés (001_initial_schema.sql, seed.sql, reset.sql)
- [x] Base de données PostgreSQL créée et seedée (sans paths images)
- [x] Fichiers images placés dans public/images/ (design, logo, projects)
- [x] .gitignore, .env.example, progress.md, CLAUDE.md en place
- [x] Premier commit et push sur GitHub (main + develop)
- [ ] sharp déplacé en dependencies (actuellement devDependencies — corriger à la phase Docker)
- [ ] Paths images renseignés dans la DB (cover_image, file_path)
- [ ] next-intl configuré (middleware, routing, providers)
- [ ] next-themes configuré (ThemeProvider)
- [ ] Types TypeScript depuis schéma SQL
- [ ] Client PostgreSQL + structure queries/
- [ ] Scripts CLI add-project.js, add-skill.js
- [ ] Layout (Header, Footer, Navigation)
- [ ] Page Accueil
- [ ] Page Compétences
- [ ] Page Projets (avec filtres)
- [ ] Page Projet détail (galerie)
- [ ] docker-compose complet
- [ ] Pipeline CI/CD GitHub Actions
- [ ] Tests unitaires (couverture > 80%)
- [ ] Tests E2E Playwright

## Dernière session
Date : 2026-04-03
Agent(s) utilisé(s) : ARCH, GIT, QA, SYNC, DOC
Ce qui a été fait :
- Initialisation complète du projet Next.js 14
- Structure de dossiers définie et appliquée
- Tokens Tailwind du design spec intégrés dans tailwind.config.ts
- Fichiers SQL versionnés et placés correctement
- .gitignore, .env.example configurés
- Premier push GitHub sur main et develop

Décisions importantes prises :
- education sans traductions pour l'instant (diplômes en FR dans les deux langues)
- light/dark comme convention de nommage (pas day/night)
- Server Components par défaut, Client Components uniquement si interactivité
- Requêtes SQL uniquement dans src/lib/db/queries/ via Server Actions
- sharp à déplacer en dependencies lors de la phase Docker

## Prochaine étape
[ARCH] + [BACK] — Phase configuration : next-intl, next-themes, client PostgreSQL, types TypeScript

Ordre exact :
1. [ARCH] Configurer next-intl (middleware.ts, i18n.ts, routing, messages fr.json/en.json de base)
2. [ARCH] Configurer next-themes (ThemeProvider dans src/app/[locale]/layout.tsx)
3. [BACK] Créer src/lib/db/client.ts (pool PostgreSQL)
4. [BACK] Créer src/types/ (interfaces TypeScript depuis le schéma SQL)
5. [BACK] Créer les premières requêtes dans src/lib/db/queries/

## Points bloquants
- Paths images dans DB pas encore renseignés
  → UPDATE projects SET cover_image = '/images/projects/dashboard-sante/cover.png' WHERE slug = 'dashboard-sante'
  → À faire manuellement dans DBeaver ou via script avant de coder les pages
- Images de design (clouds, stars, aureole) : vérifier compression au moment du composant Hero avec [FRONT]

## Décisions d'architecture prises
- Server Components par défaut, Client Components uniquement pour interactivité
- Requêtes SQL uniquement dans src/lib/db/queries/ via Server Actions
- Jamais de SELECT * — colonnes explicites uniquement
- Toujours filtrer par locale en DB, jamais côté JS
- light/dark pour les variantes de thème (cohérent avec Tailwind darkMode: 'class')
- migrations/ pour le schéma versionné, scripts/ pour seed et reset
- node-pg-migrate pour les migrations futures
- sharp en devDependencies maintenant → à corriger en dependencies à la phase Docker

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
│   │   ├── icon.tsx  
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



