# Les images :
## La règle d'or : on ne stocke PAS les images dans la base de données
C'est la pratique universelle. Dans ta base SQLite, tu ne mets jamais les fichiers image eux-mêmes. Tu stockes uniquement un chemin (une chaîne de texte) qui pointe vers l'image.
Les images vivent sur le système de fichiers du serveur, et la BDD sait où les trouver.

----

## Pourquoi pas dans la BDD ?
Techniquement SQLite peut stocker des fichiers binaires (type BLOB), mais c'est une très mauvaise idée car les bases de données ne sont pas optimisées pour servir des fichiers, ça fait exploser la taille du fichier .db, et ça empêche toute mise en cache HTTP des images.

## Comment ça fonctionne concrètement sur un serveur 
cf `image_storage_flow.svg`

```
INSERT INTO projects (slug, cover_image, ...)
VALUES ('dashboard-sante', '/images/projects/dashboard/cover.png', ...);
```

C'est tout. SQLite ne "voit" jamais l'image elle-même.

### Ce que contient ton serveur

Sur le disque du serveur, les fichiers image sont rangés dans une arborescence de dossiers, par exemple :
```
/var/www/portfolio/
├── public/
│   └── images/
│       ├── projects/
│       │   ├── dashboard-sante/
│       │   │   ├── cover.png
│       │   │   ├── apercu-1.png
│       │   │   └── apercu-2.png
│       │   └── atelier-bot/
│       │       └── cover.png
│       ├── media/
│       │   ├── portrait.png
│       │   ├── hero-light.png
│       │   └── hero-dark.png
│       └── logo.svg
├── portfolio.db          ← ta base de données SQLite
└── .next/                ← ton app Next.js compilée
```


## Ce qui se passe quand un visiteur charge la page
Next.js interroge SQLite et récupère le chemin /images/projects/dashboard-sante/cover.png. Il construit le HTML avec <img src="/images/projects/dashboard-sante/cover.png">. Le navigateur du visiteur fait une deuxième requête HTTP séparée pour ce fichier. Nginx (le serveur web) lit le fichier sur le disque et le renvoie directement — sans passer par Next.js. C'est ce qu'on appelle "servir des fichiers statiques", c'est ultra-rapide.

``` 
// Server Component — app/projets/[slug]/page.jsx
const project = db.prepare(`
  SELECT p.cover_image, pt.title
  FROM projects p
  JOIN project_translations pt ON pt.project_id = p.id
  WHERE p.slug = ? AND pt.locale = ?
`).get(slug, locale)

// cover_image vaut '/images/projects/dashboard-sante/cover.png'
return <img src={project.cover_image} alt={project.title} />
``` 
Et pour les images clair/sombre (la table media) ?

```
const media = db.prepare(`SELECT * FROM media WHERE key = ?`).get('hero-illustration')

// Tu choisis la version selon le thème actif
const src = theme === 'dark' ? media.file_path_dark : media.file_path_light
``` 

## Comment ajouter un nouveau projet avec ses images
Le workflow en pratique sera celui-ci : tu places les images dans le bon dossier sur le serveur (via FTP/SFTP ou scp), tu insères une ligne dans projects avec le chemin, et c'est fini. Tu n'as pas besoin de redémarrer le serveur ni de recompiler Next.js pour les images — elles sont servies directement par Nginx.
*Pour simplifier encore plus ce processus au quotidien, on pourrais même créer un petit script add-project.js qui copie les images au bon endroit et insère les lignes SQL en une seule commande.*
### C'est l'équivalent d'un backoffice en entreprise :
Le script vs une interface d'administration  
En entreprise s'appelle un back-office ou CMS (Content Management System). C'est une interface web privée (accessible seulement sur le réseauc privé) avec un formulaire :  remplir les champs titre, description, uploades une image, cliquer sur "Publier" — et en arrière-plan, le code fait exactement ce qu'on ferait à la main : il copie l'image dans le bon dossier et insère les lignes SQL.  
Pour le portfolio, il n'y a pas forcément besoin d'aller aussi loin. Un simple script Node.js lancé en ligne de commande suffit largement.  

## Workflow dev local → Docker → serveur distant :
Comment faire pour que mon projet en dev fonctionne toujours sur le serveur ? Où mettre mes images, comment les mettre sur le serveur etc .

cf : dev_workflow_environments.svg

**--> Metre les images dans public/images/ dans le projet, mais ne pas les commites dans Git.** (.gitignore)  

### Pendant le développement sur PC :  
Les images sont dans `public/images/`, la base de donnée est à la racine. Next.js en dev les sert directement. Tout fonctionne.  
L'astuce : pour ne pas avoir à gérer des vrais chemins différents entre local et prod, tuon utilises les mêmes chemins relatifs partout. Sur en phase dev comme sur le serveur, une image est toujours à `/images/projects/dashboard/cover.png`. Le chemin ne change jamais — c'est juste l'endroit physique sur le disque qui change.  

### Ensuite vient docker et les volumes :  
cf `..volumes_docker_explicatiosvg`  
Les volumes Docker servent à faire persister la donnée.   
Un container Docker est par nature éphémère — il peut être arrêté, supprimé, recréé à tout moment (à chaque déploiement par exemple).   
Le volume, c'est donc un pont entre un dossier sur le disque réel du serveur et un chemin à l'intérieur du container. Les fichiers vivent sur le disque du serveur (ils persistent), et le container les voit comme s'ils étaient à l'intérieur de lui.   

Pour monter le projet sur le serveur distant on pull donc l'image docker avec ses services et ses volumes.    

### Et pout les images et la db ?  
Les images et la db ne sont pas dans le container docker directement il faut donc les copier coller sur le serveur.  
C'est la que rsync intervient. cf `fichiers_vers_serveur.svg`   
C'est une méthode via SSH pour copier coller les infos de manière sécurisé et crypté etant donnée que ca utilise le protocole SSH.  

# Les traductions :  
Le pattern que je vais utiliser cf `schema_portfolio.pdf` : "table mère + table de traductions". C'est exactement ce qu'utilisent des CMS comme Strapi, des frameworks comme Django avec django-parler, ou des e-commerces comme Shopify en interne, c'est la référence du secteur.   

## Mais concrètement comment ça marche  ?
### Exemple : les projets 
```
-- La table "mère" — données qui ne changent pas selon la langue
CREATE TABLE projects (
    id            SERIAL PRIMARY KEY,
    slug          TEXT NOT NULL UNIQUE,
    cover_image   TEXT,
    date          TEXT,
    github_url    TEXT,
    demo_url      TEXT,
    featured      BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0
);

-- La table de traductions
CREATE TABLE project_translations (
    id                SERIAL PRIMARY KEY,
    project_id        INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    locale            TEXT NOT NULL,
    title             TEXT NOT NULL,
    short_description TEXT,
    long_description  TEXT,
    UNIQUE (project_id, locale)   -- une seule traduction par langue
);
```

*Précisions : `ON DELETE CASCADE` signifie que si on supprimes un projet, toutes ses traductions sont supprimées automatiquement — pas de données orphelines.*  


***Ensuite, on cherche à ajouter un projet et sa traduction fr et en***
```
-- Étape 1 : insérer le projet (données neutres)
INSERT INTO projects (slug, cover_image, date, github_url, featured, display_order)
VALUES (
    'dashboard-sante-femmes',
    '/images/projects/dashboard-sante/cover.png',
    '2024-03',
    'https://github.com/salome/dashboard-sante',
    true,
    1
);
-- PostgreSQL lui attribue automatiquement id = 1
``` 
``` 
-- Étape 2 : insérer la traduction française
INSERT INTO project_translations (project_id, locale, title, short_description, long_description)
VALUES (
    1,
    'fr',
    'Dashboard santé des femmes pour data.gouv',
    'Analyse de l''accessibilité aux soins gynécologiques via les données ouvertes.',
    'Cette analyse s''inscrit dans le cadre du défi Santé et territoires...'
);
``` 
``` 
-- Étape 3 : insérer la traduction anglaise
INSERT INTO project_translations (project_id, locale, title, short_description, long_description)
VALUES (
    1,
    'en',
    'Women''s Health Dashboard for data.gouv',
    'Analysis of gynecological care accessibility using open data.',
    'This analysis is part of the Health and Territories challenge...'
);
``` 
***Visuelement dans la table on verrait ceci dans DBeaver :***   

La table `projects`  :

| id | slug | cover_image | date | featured |
|----|------|-------------|------|----------|
| 1 | dashboard-sante-femmes | /images/... | 2024-03 | true |
| 2 | atelier-bot | /images/... | 2024-05 | false |

Et la table `project_translations` :

| id | project_id | locale | title | short_description |
|----|-----------|--------|-------|-------------------|
| 1 | 1 | fr | Dashboard santé... | Analyse de l'accessibilité... |
| 2 | 1 | en | Women's Health... | Analysis of gynecological... |
| 3 | 2 | fr | Atelier Bot | Assistant conversationnel... |
| 4 | 2 | en | Atelier Bot | Conversational assistant... |

*Donc une ligne par traduction*

---

### La requête que tu feras depuis Next.js
Quand un visiteur arrive sur `/fr/projets/dashboard-sante-femmes`, Next.js fait une seule requête SQL :

```sql
SELECT
    p.id,
    p.slug,
    p.cover_image,
    p.date,
    p.github_url,
    p.demo_url,
    pt.title,
    pt.short_description,
    pt.long_description
FROM projects p
JOIN project_translations pt
    ON pt.project_id = p.id
    AND pt.locale = 'fr'        -- ← cette valeur vient de l'URL
WHERE p.slug = 'dashboard-sante-femmes';
```

Le résultat est une seule ligne plate, comme si tout était dans une seule table :

| slug | cover_image | title | short_description |
|------|-------------|-------|-------------------|
| dashboard-sante-femmes | /images/... | Dashboard santé... | Analyse de l'accessibilité... |


---

## En code Next.js, concrètement

```typescript
// lib/db.ts — connexion PostgreSQL
import { Pool } from 'pg'

const pool = new Pool({
    connectionString: process.env.DATABASE_URL
    // ex: postgresql://user:password@localhost:5432/portfolio
})

export default pool
```

```typescript
// app/[locale]/projets/[slug]/page.tsx
import pool from '@/lib/db'

export default async function ProjectPage({
    params
}: {
    params: { locale: string; slug: string }
}) {
    const { locale, slug } = params

    const result = await pool.query(`
        SELECT p.*, pt.title, pt.short_description, pt.long_description
        FROM projects p
        JOIN project_translations pt
            ON pt.project_id = p.id
            AND pt.locale = $1
        WHERE p.slug = $2
    `, [locale, slug])   // $1 et $2 = paramètres sécurisés, pas de SQL injection

    const project = result.rows[0]

    return (
        <main>
            <h1>{project.title}</h1>
            <img src={project.cover_image} alt={project.title} />
            <p>{project.long_description}</p>
        </main>
    )
}
```

---

## La page "tous les projets" avec les filtres

Pour la page qui liste tous les projets avec les catégories, la requête devient un peu plus riche mais reste le même principe :

```sql
SELECT
    p.id,
    p.slug,
    p.cover_image,
    pt.title,
    pt.short_description,
    -- On récupère les catégories sous forme de tableau JSON
    JSON_AGG(
        JSON_BUILD_OBJECT(
            'slug', c.slug,
            'label', ct.label,
            'color', c.color_hex
        )
    ) AS categories
FROM projects p
JOIN project_translations pt
    ON pt.project_id = p.id AND pt.locale = 'fr'
JOIN project_categories pc
    ON pc.project_id = p.id
JOIN categories c
    ON c.id = pc.category_id
JOIN category_translations ct
    ON ct.category_id = c.id AND ct.locale = 'fr'
GROUP BY p.id, pt.title, pt.short_description
ORDER BY p.display_order;
```

`JSON_AGG` est une fonction PostgreSQL très pratique qui regroupe plusieurs catégories en un seul tableau — on reçois directement un objet JavaScript exploitable dans React.

---

## La gestion de la langue, comment servir la bonne langue à l'utilisateur même lors d'un changement de page : 

### Le flux complet :

Voici ce qui se passe quand un visiteur clique sur "EN" depuis une page en français :

1. Il est sur `/fr` → il clique EN → `router.push('/en')`
2. Le middleware laisse passer (l'URL a déjà une locale)
3. Next.js charge `app/[locale]/page.tsx` avec `params.locale = 'en'`
4. Le composant charge `translations['en']` → les textes de l'interface sont en anglais
5. La requête SQL part avec `AND pt.locale = 'en'` → les titres de projets sont en anglais
6. Il clique sur un projet → il va sur `/en/projets/dashboard-sante-femmes`
7. Même chose : locale `en` se propage, tout est en anglais

La locale ne se perd jamais parce qu'elle est dans chaque URL. Pas besoin de cookies, de localStorage, ni de state global — l'URL suffit.
cf `nextjs_i18n_routing.svg`
---

## Le principe : la langue vit dans l'URL

C'est la méthode professionnelle universelle. Au lieu d'essayer de "mémoriser" la langue choisie séparément, elle est encodée directement dans l'URL :

```
salomesouque.fr/fr/projets          ← version française
salomesouque.fr/en/projects         ← version anglaise

salomesouque.fr/fr/projets/dashboard-sante-femmes
salomesouque.fr/en/projects/dashboard-sante-femmes
```

Quand le visiteur navigue d'une page à l'autre, la locale reste dans l'URL — elle se propage naturellement. Il n'y a rien à "mémoriser" côté serveur.

---

### Comment Next.js gère ça ? 
***Le routing i18nLa structure du dossier `app/` ressemble à ça :***

```
app/
└── [locale]/               ← les crochets = paramètre dynamique
    ├── layout.tsx           ← layout commun à toutes les pages
    ├── page.tsx             ← page d'accueil  →  /fr  ou  /en
    ├── competences/
    │   └── page.tsx         ← /fr/competences  ou  /en/skills
    └── projets/
        ├── page.tsx         ← /fr/projets  ou  /en/projects
        └── [slug]/
            └── page.tsx     ← /fr/projets/dashboard-sante-femmes
```

Le dossier `[locale]` est un segment dynamique — Next.js capture automatiquement `fr` ou `en` depuis l'URL et le passe à toutes les pages enfants via `params.locale`. (cf projet ddc avec l'id d'un lotimage pour changer la page)

---

### Le fichier middleware.ts — le chef d'orchestre

C'est le fichier le plus important pour l'i18n. Il s'exécute sur chaque requête, avant que la page se charge :

```typescript
// middleware.ts — à la racine du projet
import { NextRequest, NextResponse } from 'next/server'

const locales = ['fr', 'en']
const defaultLocale = 'fr'

export function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname

  // Vérifie si l'URL a déjà une locale
  // ex: /fr/projets → oui, /projets → non
  const pathnameHasLocale = locales.some(
    locale => pathname.startsWith(`/${locale}/`) || pathname === `/${locale}`
  )

  if (pathnameHasLocale) return // tout va bien, on laisse passer

  // Sinon, on redirige vers la locale par défaut
  // /projets  →  /fr/projets
  // /         →  /fr
  const locale = defaultLocale
  request.nextUrl.pathname = `/${locale}${pathname}`
  return NextResponse.redirect(request.nextUrl)
}

export const config = {
  // Ce middleware s'applique à toutes les routes sauf les fichiers statiques
  matcher: ['/((?!_next|images|favicon).*)']
}
```

Donc si quelqu'un tape `salomesouque.fr` directement, il est automatiquement redirigé vers `salomesouque.fr/fr`. Et si quelqu'un envoie un lien `salomesouque.fr/projets`, il atterrit sur `salomesouque.fr/fr/projets`.

---

### Le bouton de changement de langue

C'est là que tout se connecte visuellement. Le bouton FR/EN fait juste une chose : il remplace `fr` par `en` dans l'URL actuelle.

```typescript
// components/LocaleSwitcher.tsx
'use client'

import { usePathname, useRouter } from 'next/navigation'

export default function LocaleSwitcher({ currentLocale }: { currentLocale: string }) {
  const pathname = usePathname()
  const router = useRouter()

  function switchLocale(newLocale: string) {
    // pathname vaut par ex: /fr/projets/dashboard-sante-femmes
    // on remplace juste la partie locale
    const newPath = pathname.replace(`/${currentLocale}`, `/${newLocale}`)
    router.push(newPath)
    // → /en/projets/dashboard-sante-femmes
  }

  return (
    <div>
      <button
        onClick={() => switchLocale('fr')}
        style={{ fontWeight: currentLocale === 'fr' ? 'bold' : 'normal' }}
      >
        FR
      </button>
      <span>/</span>
      <button
        onClick={() => switchLocale('en')}
        style={{ fontWeight: currentLocale === 'en' ? 'bold' : 'normal' }}
      >
        EN
      </button>
    </div>
  )
}
```

Quand le visiteur clique sur EN depuis `/fr/projets/dashboard-sante-femmes`, il est renvoyé vers `/en/projets/dashboard-sante-femmes`. Next.js recharge la page avec `locale = 'en'`, la requête SQL repart avec `AND pt.locale = 'en'`, et le titre en anglais s'affiche.

---

### Et pour les textes statiques de l'interface

Au dessus c'était pour les données dynamiques (projets, compétences) qui viennent de la base. Mais l'interface elle-même a des textes fixes — "Voir le projet", "Tous mes projets", "Compétences clés" — qui ne sont pas en base de données.

Pour ça, on utilise des fichiers de traduction JSON simples :

```
locales/
├── fr.json
└── en.json
```

```json
// locales/fr.json
{
  "nav": {
    "home": "Accueil",
    "projects": "Projets",
    "skills": "Compétences",
    "about": "À propos",
    "contact": "Contact"
  },
  "project": {
    "see_project": "Voir le projet",
    "back": "Tous les projets",
    "key_skills": "Compétences clés",
    "my_role": "Mon rôle",
    "gallery": "Aperçus du projet"
  },
  "home": {
    "featured": "Projets sélectionnés",
    "see_all": "Voir tous les projets"
  }
}
```

```json
// locales/en.json
{
  "nav": {
    "home": "Home",
    "projects": "Projects",
    "skills": "Skills",
    "about": "About",
    "contact": "Contact"
  },
  "project": {
    "see_project": "View project",
    "back": "All projects",
    "key_skills": "Key skills",
    "my_role": "My role",
    "gallery": "Project previews"
  },
  "home": {
    "featured": "Selected projects",
    "see_all": "View all projects"
  }
}
```

Et dans les composants :

```typescript
// app/[locale]/page.tsx
import fr from '@/locales/fr.json'
import en from '@/locales/en.json'

const translations = { fr, en }

export default function HomePage({ params }: { params: { locale: 'fr' | 'en' } }) {
  const t = translations[params.locale]

  return (
    <main>
      <h2>{t.home.featured}</h2>
      {/* ... projets depuis la DB ... */}
      <a href={`/${params.locale}/projets`}>{t.home.see_all}</a>
    </main>
  )
}
```
## Assigner des skills à un projet : DB directement

```javascript
-- Afficher Python, React, Power BI sur la home
-- page_key = 'home'
INSERT INTO page_skills (page_key, skill_id, display_order) VALUES
  ('home', 3, 1),   -- Python
  ('5', 2, 2),      -- React
  ('home', 7, 3);   -- Power BI

-- La page compétences affiche TOUS les skills
-- → pas besoin de page_skills pour cette page,
--   tu fais juste un SELECT * FROM skills
```


---

### Pourquoi les textes fixes ne sont pas en base de données

La règle n'est pas arbitraire, elle repose sur **deux critères** :

**Est-ce que ce contenu change souvent ?** "Voir le projet" ne changera jamais. Un titre de projet peut changer.

**Est-ce que ce contenu appartient à la logique de l'interface ou aux données métier ?** "Voir le projet" est un libellé d'interface — ça appartient au code. Le titre d'un projet est une donnée — ça appartient à la base.

Voici comment les sites professionnels tranchent :

| Contenu | Où ça vit | Pourquoi |
|---|---|---|
| "Voir le projet", "Accueil" | Fichier JSON | Libellé d'interface, ne change jamais |
| Titre d'un projet | Base de données | Donnée métier, peut évoluer |
| Nom d'une compétence | Base de données | Donnée avec couleur, icône, relations |
| "©2026 Salomé Souque" | Fichier JSON ou hardcodé | Contenu statique |
| Description d'un projet | Base de données | Contenu riche, traduit |

Même des sites très grands comme Airbnb ou Spotify suivent ce principe — leurs libellés d'interface ("Book now", "Play") sont dans des fichiers de traduction, pas en base.

---

### La formation en base de données 

Rappel : les textes d'interface fixes → JSON, les données dynamiques → base de données.

**La formation, c'est quoi exactement ?**
```
2023–présent  Alternance développement en Intelligence Artificielle
              Artefact, leader mondial sur l'information du marché de l'art
              [badge : En cours]

2024          Formation développement web
              EM Lyon
              [badge : Terminé]
```

Ce n'est pas un libellé d'interface. C'est une **vraie donnée** — elle a une date, un statut, un établissement, elle va changer quand tu finiras ton alternance, et elle a une logique de rendu (le badge "En cours" est conditionnel). Elle est donc **parfaitement à sa place en base de données**.
Une timeline avec des statuts dynamiques, c'est clairement de la donnée.

**La vraie ligne de démarcation** n'est donc pas "fixe vs dynamique" mais plutôt :

Fait partie de l'identité du site (libellés, navigation)  →  JSON
Fait partie du contenu du site (projets, skills, parcours) →  Base de données




Super sujet, et j'aime beaucoup l'approche — apprendre en faisant plutôt qu'en lisant un cours. Je vais être direct et conversationnel.

---

# Le fichier `seed.sql`

### C'est quoi concrètement ?

C'est un fichier SQL qui contient des données de test réalistes à injecter dans ta base pour pouvoir développer ton interface. Il s'exécute une fois après la création des tables.

Tu as trois fichiers qui s'enchaînent dans l'ordre :

```
schema.sql   →   seed.sql   →   ton code Next.js
  (tables)       (données)       (requêtes)
```

Sans seed, tu lances ton serveur Next.js, tu vas sur `/fr/projets`... et tu vois une page vide. Impossible de savoir si ton composant carte fonctionne, si les couleurs des tags s'affichent bien, si le filtre par catégorie marche. Le seed te donne de quoi travailler dès le premier jour.

### Ce qu'il n'est PAS

Ce n'est pas tes vraies données de production — c'est des données fictives mais crédibles. En entreprise on les appelle aussi "fixtures". Elles ressemblent à ce que le vrai site contiendra (même structure, même longueur de textes) mais sans être les vraies infos finales.

### Comment il s'articule avec le projet

Dans ton repo, la structure ressemblera à ça :

```
portfolio/
├── sql/
│   ├── schema.sql     ← crée les tables (le MPD du PDF)
│   ├── seed.sql       ← injecte les données de test
│   └── reset.sql      ← DROP tout + recrée (pratique en dev)
├── src/
│   └── app/...
└── .env
```

Le `reset.sql` c'est le fichier que tu vas utiliser des dizaines de fois pendant le développement quand tu veux repartir de zéro — il supprime tout et rappelle `schema.sql` + `seed.sql`.

### L'exemple concret

Voici un seed réaliste pour ton portfolio, que je commente ligne par ligne :

```sql
-- seed.sql
-- On désactive les vérifications de FK le temps de l'insertion
-- (pour pouvoir insérer dans n'importe quel ordre sans erreur)
SET session_replication_role = 'replica';

-- ── 1. SKILL CATEGORIES ──────────────────────────────────────────
-- On insère d'abord ce dont les autres tables dépendent (les FK)
INSERT INTO skill_categories (slug, color_hex) VALUES
  ('ia',           '#6c63ff'),  -- violet
  ('web',          '#e96b99'),  -- rose
  ('data-science', '#2ec4b6'),  -- teal
  ('infra',        '#f4a261');  -- ambre

INSERT INTO skill_category_translations (skill_category_id, locale, label) VALUES
  (1, 'fr', 'Intelligence Artificielle'),
  (1, 'en', 'Artificial Intelligence'),
  (2, 'fr', 'Développement Web'),
  (2, 'en', 'Web Development'),
  (3, 'fr', 'Data Science'),
  (3, 'en', 'Data Science'),          -- même mot dans les deux langues
  (4, 'fr', 'Infrastructure'),
  (4, 'en', 'Infrastructure');

-- ── 2. SKILLS ────────────────────────────────────────────────────
INSERT INTO skills (slug, skill_category_id, proficiency_level) VALUES
  ('python',            1, 85),
  ('pytorch',           1, 70),
  ('machine-learning',  1, 80),
  ('react',             2, 75),
  ('nextjs',            2, 70),
  ('sql',               3, 80),
  ('pandas',            3, 75),
  ('power-bi',          3, 65),
  ('docker',            4, 60);

INSERT INTO skill_translations (skill_id, locale, label) VALUES
  (1, 'fr', 'Python'),       (1, 'en', 'Python'),
  (2, 'fr', 'PyTorch'),      (2, 'en', 'PyTorch'),
  (3, 'fr', 'Machine Learning'), (3, 'en', 'Machine Learning'),
  (4, 'fr', 'React'),        (4, 'en', 'React'),
  (5, 'fr', 'Next.js'),      (5, 'en', 'Next.js'),
  (6, 'fr', 'SQL'),          (6, 'en', 'SQL'),
  (7, 'fr', 'Pandas'),       (7, 'en', 'Pandas'),
  (8, 'fr', 'Power BI'),     (8, 'en', 'Power BI'),
  (9, 'fr', 'Docker'),       (9, 'en', 'Docker');

-- ── 3. PAGE SKILLS (ce qui apparaît sur la home) ─────────────────
-- Tu choisis manuellement quels skills flottent sur la home
INSERT INTO page_skills (page_key, skill_id, display_order) VALUES
  ('home', 1, 1),   -- Python
  ('home', 3, 2),   -- Machine Learning
  ('home', 4, 3),   -- React
  ('home', 8, 4);   -- Power BI

-- ── 4. CATEGORIES ────────────────────────────────────────────────
INSERT INTO categories (slug, color_hex) VALUES
  ('ia',           '#6c63ff'),
  ('web',          '#e96b99'),
  ('data-science', '#2ec4b6');

INSERT INTO category_translations (category_id, locale, label) VALUES
  (1, 'fr', 'IA'),           (1, 'en', 'AI'),
  (2, 'fr', 'Web'),          (2, 'en', 'Web'),
  (3, 'fr', 'Data Science'), (3, 'en', 'Data Science');

-- ── 5. PROJETS ───────────────────────────────────────────────────
INSERT INTO projects (slug, cover_image, date, github_url, featured, display_order) VALUES
  ('dashboard-sante-femmes',
   '/images/projects/dashboard-sante/cover.png',
   '2024-03',
   'https://github.com/salome/dashboard-sante',
   true, 1),
  ('atelier-bot',
   '/images/projects/atelier-bot/cover.png',
   '2024-06',
   'https://github.com/salome/atelier-bot',
   true, 2),
  ('site-json',
   '/images/projects/site-json/cover.png',
   '2024-09',
   NULL,       -- projet privé, pas de lien GitHub
   false, 3);

INSERT INTO project_translations (project_id, locale, title, short_description, long_description) VALUES
  -- Projet 1 FR
  (1, 'fr',
   'Dashboard santé des femmes pour data.gouv',
   'Analyse de l''accessibilité aux soins gynécologiques via les données ouvertes.',
   'Cette analyse s''inscrit dans le cadre du défi Santé et territoires...'),
  -- Projet 1 EN
  (1, 'en',
   'Women''s Health Dashboard for data.gouv',
   'Analysis of gynecological care accessibility using open data.',
   'This analysis is part of the Health and Territories challenge...'),
  -- Projet 2 FR
  (2, 'fr',
   'Atelier Bot',
   'Assistant conversationnel spécialisé dans l''assistance créative pour designers UX.',
   'Atelier Bot est un LLM fine-tuné pour...'),
  -- Projet 2 EN
  (2, 'en',
   'Atelier Bot',
   'Conversational assistant specialised in creative support for UX designers.',
   'Atelier Bot is a fine-tuned LLM for...'),
  (3, 'fr', 'Site JSON', 'Générateur de structures JSON via LLM.', 'Description longue...'),
  (3, 'en', 'JSON Site',  'JSON structure generator powered by LLM.', 'Long description...');

-- ── 6. SECTIONS D'UN PROJET ──────────────────────────────────────
-- Pour le projet 1 seulement (pour tester la page détail)
INSERT INTO project_sections (project_id, locale, section_key, title, content, display_order) VALUES
  (1, 'fr', 'challenge', 'Le Défi',
   'L''accessibilité aux soins gynécologiques et son impact sur le dépistage.', 1),
  (1, 'en', 'challenge', 'The Challenge',
   'Accessibility to gynecological care and its impact on screening.', 1),
  (1, 'fr', 'solution',  'La Solution',
   'Comparaison de trois territoires aux profils contrastés...', 2),
  (1, 'en', 'solution',  'The Solution',
   'Comparison of three territories with contrasting profiles...', 2),
  (1, 'fr', 'role',      'Mon Rôle',
   '- Architecture de la structure neuronale\n- Lead data pipeline (ETL)\n- Déploiement via Docker', 3),
  (1, 'en', 'role',      'My Role',
   '- Neural architecture design\n- Lead data pipeline (ETL)\n- Docker deployment', 3);

-- ── 7. LIAISONS N:N ──────────────────────────────────────────────
INSERT INTO project_categories (project_id, category_id) VALUES
  (1, 3), -- dashboard → data-science
  (1, 1), -- dashboard → ia
  (2, 1), -- atelier-bot → ia
  (3, 2), -- site-json → web
  (3, 1); -- site-json → ia aussi (multi-catégorie)

INSERT INTO project_skills (project_id, skill_id) VALUES
  (1, 1), (1, 7), (1, 8), (1, 6),  -- dashboard : python, pandas, power-bi, sql
  (2, 1), (2, 2), (2, 3),           -- atelier-bot : python, pytorch, ml
  (3, 4), (3, 5), (3, 1);           -- site-json : react, nextjs, python

-- ── 8. FORMATION ─────────────────────────────────────────────────
INSERT INTO education (degree, institution, start_year, end_year, is_current, display_order) VALUES
  ('Alternance développement en Intelligence Artificielle',
   'Artefact', 2023, NULL, true, 1),
  ('Formation développement web',
   'EM Lyon', 2024, 2024, false, 2),
  ('Bac général — Mention Bien',
   'Lycée', 2022, 2022, false, 3);

-- ── 9. MÉDIAS ────────────────────────────────────────────────────
INSERT INTO media (key, file_path_light, file_path_dark, media_type) VALUES
  ('hero-illustration', '/images/media/hero-light.png', '/images/media/hero-dark.png', 'illustration'),
  ('portrait',          '/images/media/portrait.png',   NULL,                           'portrait'),
  ('logo',              '/images/media/logo.svg',        NULL,                           'logo');

-- ── 10. LIENS ────────────────────────────────────────────────────
INSERT INTO links (page_key, project_id, platform, url, locale) VALUES
  ('footer', NULL, 'linkedin',  'https://linkedin.com/in/salome-souque', NULL),
  ('footer', NULL, 'github',    'https://github.com/salome',             NULL),
  ('footer', NULL, 'instagram', 'https://instagram.com/salome',          NULL);

-- On réactive les vérifications FK
SET session_replication_role = 'origin';
```

Le point important sur les apostrophes : en SQL, une apostrophe dans une chaîne de texte s'écrit avec deux apostrophes `''` (pas un guillemet double). C'est pour ça que `'l''accessibilité'` est correct.

---

# Créer ses tables de façon professionnelle

### 1. Conventions et erreurs de débutant à éviter

**Le nommage — adopte une convention et ne la quitte plus jamais.** La règle pro pour PostgreSQL : tout en `snake_case` minuscule, sans exception. Pas `projectId`, pas `ProjectID`, pas `PROJECTID` — seulement `project_id`. PostgreSQL est insensible à la casse mais si tu mets des majuscules, tu seras obligée de mettre des guillemets partout dans tes requêtes (`"projectId"`), et c'est une source de bugs permanente.

**N'utilise jamais `id` comme nom de colonne seul dans tes requêtes de jointure.** C'est ambigu quand tu joins plusieurs tables. Toujours faire `p.id`, `pt.project_id` explicitement.

**`TEXT` vs `VARCHAR(n)` — en PostgreSQL, utilise `TEXT`.** C'est le piège classique des gens qui viennent de MySQL. En PostgreSQL, `TEXT` et `VARCHAR` ont exactement les mêmes performances. Mettre `VARCHAR(255)` n'optimise rien et te force à gérer des erreurs de troncature inutiles. La seule raison d'utiliser `VARCHAR(n)` c'est si tu as une règle métier réelle qui impose une longueur max (ex: un code pays `CHAR(2)`).

**Ne jamais mettre de `NOT NULL` à la légère... mais ne jamais l'oublier non plus.** Chaque colonne doit avoir une décision consciente : est-ce qu'une valeur NULL a du sens ici ? `cover_image` peut être NULL (projet sans image), mais `slug` ne peut jamais être NULL. Si tu n'y penses pas, PostgreSQL accepte NULL partout par défaut, et tu te retrouves avec des données incohérentes impossible à déboguer côté front.

**`ON DELETE CASCADE` — toujours sur les FK enfants.** Sans ça, si tu supprimes un projet, PostgreSQL refuse parce que des traductions y font référence. Tu dois supprimer manuellement dans le bon ordre à chaque fois. C'est pénible et source d'erreurs. Avec `CASCADE`, supprimer le projet supprime tout ce qui en dépend automatiquement.

**Les index — ne les oublie pas, mais ne les abuse pas non plus.** Les colonnes que tu utilises dans tes `WHERE` et tes `JOIN` fréquents méritent un index. Pour toi : `project_id`, `locale`, `page_key`, `slug`, `featured`. Le MPD du PDF les liste déjà tous.

**Connaître l'ordre d'exécution**

C'est la règle d'or : ***une table qui a une FK vers une autre table doit être créée APRÈS cette autre table.*** Si tu crées `project_translations` avant `projects`, PostgreSQL va refuser parce que `projects` n'existe pas encore.

Voici l'ordre exact pour ton projet :
```
1.  skill_categories
2.  skill_category_translations
3.  skills
4.  skill_translations
5.  page_skills
6.  categories
7.  category_translations
8.  projects
9.  project_translations
10. project_sections
11. project_images
12. project_categories        ← liaison N:N, dépend de projects + categories
13. project_skills            ← liaison N:N, dépend de projects + skills
14. education                 ← autonome, aucune FK
15. media                     ← autonome, aucune FK
16. links                     ← dépend de projects (FK nullable)

---

### 2. DBeaver — les points pratiques

Quelques indications qui t'éviteront de chercher :

Pour **exécuter un fichier SQL entier** (ton `schema.sql` ou `seed.sql`), tu fais `File > Open File` depuis l'éditeur SQL, ou tu fais glisser le fichier directement dans l'éditeur. Ensuite `Ctrl+A` pour tout sélectionner puis `Ctrl+Enter` pour tout exécuter d'un coup.

Pour **voir le résultat d'une requête SELECT**, le panneau résultat apparaît en bas. Si tu ne le vois pas, c'est souvent qu'il est réduit — regarde la barre de séparation en bas de l'éditeur.

Pour **naviguer dans tes tables**, dans le panneau de gauche (Database Navigator) : connexion → nom de ta base → Schemas → public → Tables. Tu peux double-cliquer sur une table pour voir ses données directement sans écrire de requête.

Pour **voir si une FK est bien créée**, double-clique sur ta table → onglet "Foreign Keys". Si c'est vide alors que tu as mis des `REFERENCES`, c'est que le script a échoué silencieusement — vérifie les erreurs dans l'onglet en bas.

Un comportement qui surprend souvent : DBeaver peut se connecter à plusieurs bases en même temps. Si tu exécutes une requête et que tu as un message "table does not exist" alors qu'elle existe, vérifie que tu es bien connectée à la bonne base dans la liste déroulante en haut de l'éditeur SQL.

Pour **réinitialiser** complètement avec ton `reset.sql`, c'est la même procédure — ouvrir, sélectionner tout, exécuter. C'est ce que tu feras souvent pendant le dev.

---

### 3. SQL — comment on travaille ensemble

Je ne te donne pas les requêtes. Tu les écris, tu me les montres, et je te signale uniquement si quelque chose va te créer un problème structurel ou une mauvaise habitude sur le long terme. Les petites erreurs de syntaxe tu les verras dans les messages d'erreur de DBeaver — c'est le meilleur apprentissage.

Ce que je surveillerai particulièrement : l'ordre de création des tables (les FK avant les tables qui les référencent), la présence de `ON DELETE CASCADE`, le respect des contraintes `UNIQUE` sur les paires `(project_id, locale)`, et la cohérence du nommage.



# Tips :
Connexion d'urgence à postgreesql : 
Sur Linux : sudo -i -u postgres suivie de psql pour accéder à PostgreSQL.   
**A savoir :**    
Quand PostgreSQL s'installe, il crée un super-utilisateur postgres. PostgreSQL sur Linux utilise par défaut l'authentification peer pour l'utilisateur système postgres, ce qui signifie que l'on peut te connecter sans mot de passe directement depuis le terminal en tant que cet utilisateur.   
**A se souvenir :**  
J'ai créé un utilisateur dédié appelé dbeaver lors de la configuration initiale a ma connexion PostgreSQL. (mdp dans mon premier projet).  
Pourquoi ? On ne travaille jamais directement avec le super-utilisateur postgres au quotidien.
L'utilisateur postgres c'est l'équivalent du compte root sur Linux — il a tous les droits sur tout. On s'en sert uniquement pour les opérations d'administration ponctuelles, pas pour le développement de tous les jours. Travailler avec un utilisateur dédié par projet est une bonne pratique.  

## 

a quoi sert reset et a quoi sert unique ? a quoi sert la table project_categoriesLiaison projet ↔ catégorie & project_skillsLiaison projet ↔ compétence ? Pourquoi créer une page à part pour les liens ? Je n'ai pas bien compris à quoi servent les index.





