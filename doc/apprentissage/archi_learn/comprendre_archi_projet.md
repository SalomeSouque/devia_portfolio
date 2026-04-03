## [DOC] — Cours : comprendre l'architecture du projet

---

### Partie 1 — Pourquoi cette structure de dossiers ?

La question à te poser devant chaque dossier : **"qui a besoin de ce contenu, et quand ?"**

**`src/`** — tout le code source de l'application. Next.js pourrait fonctionner sans ce dossier (en mettant `app/` directement à la racine), mais `src/` sépare visuellement "le code" des "fichiers de configuration". Quand tu ouvres le projet dans 6 mois, tu sais exactement où chercher.

**`src/app/`** — c'est le cœur de Next.js App Router. Chaque dossier ici correspond à une URL. `[locale]/` est un segment dynamique : `fr` et `en` sont des valeurs possibles pour ce paramètre. Next.js et next-intl vont intercepter toutes les URLs et injecter la bonne locale automatiquement. (slug = détail du projet)

**`src/components/`** — divisé en trois niveaux de responsabilité :
- `ui/` : un `Button` ne sait pas qu'il est dans un portfolio. Il prend des props et affiche quelque chose. Il pourrait être dans n'importe quel projet.
- `features/` : un `ProjectCard` sait qu'un projet a un titre, une image, des catégories. Il est lié à ton domaine métier.
- `layout/` : `Header`, `Footer`, `Navigation` — les éléments qui encadrent toutes les pages.

Cette séparation évite un piège classique : importer de la logique métier dans un composant générique. Si `Button` importait des données de projets, tu ne pourrais plus le réutiliser ailleurs.

**`src/lib/`** — tout ce qui n'est pas un composant React mais qui est du code partagé :
- `db/client.ts` : la connexion à PostgreSQL. Un seul endroit, jamais dupliqué.
- `db/queries/` : toutes les requêtes SQL organisées par domaine. Jamais de SQL dans un composant.
- `utils/` : fonctions utilitaires pures (formater une date, tronquer un texte).
- `constants/` : valeurs qui ne changent pas (`LOCALES = ['fr', 'en']`).

**`src/types/`** — les interfaces TypeScript qui décrivent tes données. Par exemple :

```typescript
// src/types/project.ts
export interface Project {
  id: number
  slug: string
  coverImage: string | null
  featured: boolean
  title: string        // vient de project_translations
  shortDescription: string | null
}
```

TypeScript va vérifier à la compilation que ton code utilise ces types correctement. C'est ton filet de sécurité.

**`src/messages/`** — les fichiers de traduction pour next-intl. `fr.json` contient tous les labels de l'interface en français, `en.json` en anglais. Attention : ce sont les **labels UI** (boutons, titres de section fixes), pas le contenu des projets — ça, c'est en base de données.

---

### Partie 2 — Les fichiers à la racine, un par un

**`package.json`** — le "contrat" de ton projet. Il liste toutes les dépendances (les bibliothèques dont tu as besoin) et les scripts (`npm run dev`, `npm run build`). `dependencies` sont nécessaires en production, `devDependencies` seulement pendant le développement.

**`tailwind.config.ts`** — la configuration de Tailwind. Tu y as défini tous les tokens de couleur du design spec. Sans ce fichier, tu aurais des classes comme `bg-[#595A6F]` partout dans le code — illisible et impossible à maintenir. Avec les tokens, tu écris `bg-cta` et si la couleur change un jour, tu la changes à un seul endroit.

**`tsconfig.json`** — la configuration TypeScript. Le paramètre le plus important : `"strict": true`. Ça active toutes les vérifications strictes — TypeScript refusera les `any`, les variables potentiellement `undefined` non gérées, etc. C'est contraignant au début, c'est ce qui t'évite des bugs en production.

**`next.config.ts`** — la configuration Next.js. On y mettra les domaines d'images autorisés, la configuration de next-intl, les variables d'environnement publiques.

**`eslint.config.mjs`** — ESLint analyse ton code et signale les problèmes stylistiques ou les erreurs courantes avant que tu les exécutes. Il fonctionne avec Prettier : ESLint vérifie la qualité, Prettier formate le style.

**`.env.local`** — les variables d'environnement locales. Ce fichier n'est **jamais commité** parce qu'il contient ton mot de passe PostgreSQL. `.env.example` est la version vide publique pour que quelqu'un qui clone le repo sache quelles variables créer.

**`progress.md`** — l'état vivant du projet. Mis à jour par [SYNC] à chaque fin de session. Il remplace "où j'en étais" quand tu reviens après une pause.

**`CLAUDE.md`** — le contexte permanent du projet pour Claude. Décisions d'architecture, conventions, stack. Reste stable dans le temps contrairement à `progress.md`.

**`migrations/`** — les fichiers SQL versionnés. `001_initial_schema.sql` crée toutes les tables. Si tu dois modifier le schéma plus tard, tu crées `002_add_education_translations.sql` — tu ne modifies jamais le fichier 001. Comme ça l'historique des changements est traçable.

**`scripts/`** — outils de développement : `seed.sql` pour peupler la base, `reset.sql` pour tout effacer (dev uniquement), et plus tard les scripts CLI interactifs pour ajouter du contenu.

**`doc/`** — tes notes, le design spec, les PDFs. Pas du code, mais de la connaissance sur le projet.

---