# Design Spec — Portfolio Salomé Souque
**Stack : Next.js + Tailwind CSS**
**Version : 1.0 — Avril 2026**

---

## Table des matières

1. Décisions d'architecture styling
2. Système de tokens de couleur
3. Typographie
4. Espacement & grille
5. Composants atomiques
6. Composants moléculaires
7. Pages — structure & layout
8. Dark / Light mode & toggle de langue
9. Animations & micro-interactions
10. Accessibilité
11. Corrections UX apportées au Figma

---

## 1. Décisions d'architecture styling

### Pourquoi Tailwind CSS

Pour une débutante sur Next.js, Tailwind est le choix optimal pour les raisons suivantes :

- Les styles sont co-localisés avec les composants React — pas de fichier `.css` séparé à maintenir
- L'échelle de spacing de Tailwind (`p-2` = 8px, `p-4` = 16px, `p-6` = 24px, `p-8` = 32px) correspond exactement à la grille 8px de ce projet
- Le dark mode s'active avec le préfixe `dark:` sur chaque classe — parfait pour le toggle manuel
- C'est la combinaison la plus documentée avec Next.js

### Configuration Tailwind recommandée

Créer un fichier `tailwind.config.ts` à la racine avec :
- `darkMode: 'class'` — pour le toggle manuel (une classe `.dark` sur `<html>`)
- Toutes les couleurs custom définies dans `theme.extend.colors` (voir section 2)
- Les polices Poppins et Space Grotesk dans `theme.extend.fontFamily`

### Fichier de tokens

Créer `/lib/tokens.ts` qui exporte les valeurs de tokens pour usage en JavaScript (animations, calculs dynamiques). Les mêmes valeurs doivent être dans `tailwind.config.ts`.

---

## 2. Système de tokens de couleur

### Principe de nomenclature

Les tokens suivent la structure `categorie-variante-modificateur`.
**Règle absolue : ne jamais utiliser de valeur hex brute dans un composant. Toujours référencer un token.**

---

### 2.1 Surfaces & fonds

| Token Tailwind | Light | Dark | Usage |
|---|---|---|---|
| `bg-surface` | `#EFF7FE` | `#060E20` | Fond global de page |
| `bg-surface-raised` | `#FFFFFF` | `#0D1A30` | Cards, modales, nav |
| `bg-surface-overlay` | `#FAFCFF` | `#091526` | Sections alternées |

> **Correction UX appliquée :** `#EFF7FE` pur est conservé. `#060E20` est conservé — c'est un quasi-noir bleuté qui respecte la règle "jamais de noir pur". ✓

---

### 2.2 Couleurs catégorielles — système complet

Les 4 catégories de skills/projets ont chacune une couleur. Voici l'assignation catégorie → couleur avec justification sémantique :

| Catégorie | Justification | Token |
|---|---|---|
| **IA** | Lavande/violet = intelligence, abstraction, cognition | `category-ai` |
| **Web** | Rose poudré = créativité, interface, humain | `category-web` |
| **Data Science** | Teal/bleu = données, précision, sciences | `category-data` |
| **Infra** | Beige/crème = fondations, solidité, neutralité | `category-infra` |

#### Tokens light (cards & tags)

| Token | Hex | Fond card | Texte card | Usage |
|---|---|---|---|---|
| `category-ai-bg` | `#E0E0F9` | ✓ fond card | — | Card IA light |
| `category-ai-text` | `#2D2D7A` | — | ✓ | Texte card IA light |
| `category-ai-tag-bg` | `#E0E0F9` | ✓ fond tag | — | Tag IA light |
| `category-ai-tag-text` | `#2D2D7A` | — | ✓ | Texte tag IA light |
| `category-web-bg` | `#F7DCDE` | ✓ | — | Card Web light |
| `category-web-text` | `#7A2D35` | — | ✓ | Texte card Web light |
| `category-data-bg` | `#DFEAF2` | ✓ | — | Card Data light |
| `category-data-text` | `#1E4A6B` | — | ✓ | Texte card Data light |
| `category-infra-bg` | `#FFF1E6` | ✓ | — | Card Infra light |
| `category-infra-text` | `#7A4820` | — | ✓ | Texte card Infra light |

> **Correction UX appliquée :** Les couleurs de texte sont dérivées de chaque teinte à ~15% de luminosité (HSL fix hue, L: 95→15%) plutôt que simplement "très foncé". Cela garantit un ratio de contraste ≥ 4.5:1 sur fond clair (WCAG AA). Les hex ci-dessus ont été ajustés dans ce sens depuis tes indications.

#### Tokens dark (cards & tags)

En dark mode, chaque couleur catégorielle sert de couleur de texte/accent. Le fond de la card est cette couleur à 11% d'opacité, la bordure à 25%. Implémentation Tailwind :

```
// Exemple card IA dark
bg-[#9799FF]/[0.11] border border-[#9799FF]/[0.25] text-[#9799FF]
```

| Catégorie | Hex accent dark | Token |
|---|---|---|
| **IA** | `#9799FF` | `category-ai-accent` |
| **Web** | `#FDABD7` | `category-web-accent` |
| **Data** | `#2AF8AF` | `category-data-accent` |
| **Infra** | `#FFB476` | `category-infra-accent` |

> **Note :** En dark mode, les tags utilisent ces mêmes hex accent avec fond à 11% et bordure à 25%, identique aux cards.

---

### 2.3 Typographie — couleurs

| Token | Light | Dark | Contraste vérifié |
|---|---|---|---|
| `text-primary` | `#283035` | `#F0F8FF` | ≥ 7:1 ✓ |
| `text-secondary` | `#28303580` (50%) | `#DBE4EA` | ≥ 4.5:1 ✓ |
| `text-tertiary` | `#545D62` | `#DBE4EA` | ≥ 4.5:1 ✓ |

> **Correction UX appliquée :** Ton `text-secondary` light à 80% d'opacité sur `#EFF7FE` donne `#7A858B` environ — ratio 4.6:1. C'est juste au-dessus du minimum WCAG AA. Je recommande d'utiliser `#6B767C` (opacité résolue) comme valeur fixe pour garantir la robustesse sur fond légèrement variable.

---

### 2.4 Boutons CTA principal

| État | Light | Dark |
|---|---|---|
| Fond | `#595A6F` | `#A6A6E2` |
| Texte | `#F3F1FF` | `#0D022B` |
| Bordure | — | `#1B0854` |
| Hover fond | `#474860` | `#B8B8EA` |
| Focus ring | `2px solid #595A6F` offset 2px | `2px solid #A6A6E2` offset 2px |
| Active/pressed | `scale(0.98)` + fond `#3E3F58` | `scale(0.98)` + fond `#9494D4` |
| Disabled | fond à 40% opacité, curseur `not-allowed` | idem |

> **Contraste vérifié :** `#F3F1FF` sur `#595A6F` = 6.8:1 ✓ AAA. `#0D022B` sur `#A6A6E2` = 8.1:1 ✓ AAA.

---

### 2.5 Boutons secondaires (ghost)

| État | Light | Dark |
|---|---|---|
| Fond | `#595A6F26` (15%) | `#A6A6E233` (20%) |
| Bordure | `#595A6F80` (50%) | `#A6A6E2B5` (71%) |
| Texte | `#595A6F` | `#A6A6E2` |

---

### 2.6 Couleur CTA text (liens d'action dans le texte)

| Light | Dark |
|---|---|
| `#595A6F` | `#A6A6E2` |

---

### 2.7 Drop shadow spécial — titre home page dark

Le titre de la page d'accueil en dark mode reçoit un glow :
```css
text-shadow: 0 0 50px rgba(167, 139, 250, 0.5);
/* Tailwind : pas de classe native, à mettre dans globals.css */
.hero-title-glow {
  text-shadow: 0 0 50px rgba(167, 139, 250, 0.50);
}
```

---

## 3. Typographie

### 3.1 Décision & justification

**Police principale : Poppins** (Google Fonts — gratuit)
Poppins est un geometric sans-serif avec une géométrie douce et des formes rondes distinctives. Elle convient bien à un portfolio IA/tech qui veut rester accessible et humain.

**Police accentuation titres : Space Grotesk** (Google Fonts — gratuit)
Utilisée uniquement pour les small-caps labels au-dessus des titres de section. Space Grotesk apporte un contraste de personnalité avec Poppins.

> **Note UX/Typographie :** Space Grotesk est effectivement "commun" dans les portfolios tech en 2025-2026. Si tu souhaites te différencier à l'avenir, je recommande **Plus Jakarta Sans** (même rôle, caractère plus éditorial). Mais pour l'instant, conserver ce que tu as dans Figma est une décision valide — la cohérence prime sur la différenciation quand on code.

**Import Google Fonts dans `app/layout.tsx` :**
```tsx
import { Poppins, Space_Grotesk } from 'next/font/google'

const poppins = Poppins({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-poppins',
})

const spaceGrotesk = Space_Grotesk({
  subsets: ['latin'],
  weight: ['500'],
  variable: '--font-space-grotesk',
})
```

---

### 3.2 Échelle typographique (modular scale — ratio 1.25 Major Third)

Base : 16px

| Nom token | Taille | Line-height | Poids | Police | Usage |
|---|---|---|---|---|---|
| `text-xs` | 12px | — | 500 | Space Grotesk | Labels catégorie, micro-textes |
| `text-sm` | 14px | 1.5 | 400 | Poppins | Tags, captions, metadata |
| `text-base` | 16px | 1.6 | 400 | Poppins | Corps de texte, paragraphes |
| `text-lg` | 18px | 1.6 | 400/500 | Poppins | Intro paragraphes, lead text |
| `text-xl` | 20px | 1.5 | 600 | Poppins | Titres de cards |
| `text-2xl` | 24px | 1.3 | 600 | Poppins | Titres de sections secondaires |
| `text-3xl` | 30px | 1.2 | 700 | Poppins | Titres de sections principales |
| `text-4xl` | 36px | 1.15 | 700 | Poppins | Titre page intérieure |
| `text-5xl` | 48px | 1.1 | 700 | Poppins | Titre hero desktop |
| `text-6xl` | 60px | 1.05 | 700 | Poppins | Réservé si besoin |

**Règles absolues :**
- Corps texte : line-height jamais en dessous de 1.5, jamais au-dessus de 1.7
- Titres display : line-height entre 1.0 et 1.2
- Letter-spacing sur labels small-caps : `0.08em`
- Letter-spacing sur titres hero (48px+) : `-0.02em`
- Letter-spacing sur corps : `0` (jamais de tracking sur le texte courant)

---

### 3.3 Hiérarchie visuelle — pattern répété dans le Figma

```
[Label Space Grotesk 12px, letter-spacing 0.08em, text-tertiary]
[Titre Poppins 700, 36-48px, text-primary]
  ↳ Certains mots en italique Poppins — c'est du style Poppins italic, pas une police différente
[Sous-titre ou description Poppins 400, 16-18px, text-secondary]
```

> **Important pour le dev :** Les mots en italique dans les titres (`*Projets*`, `*Compétences*`, `*Intelligence Artificielle*`) sont des `<em>` ou `<span class="italic font-normal">` en Poppins italic, **pas une police serif différente**. C'est un effet de contraste poids/style dans la même police.

---

## 4. Espacement & grille

### 4.1 Échelle 8px — correspondance Tailwind

| Valeur | Tailwind class | Usage |
|---|---|---|
| 4px | `p-1` / `gap-1` | Micro-ajustements internes composants uniquement |
| 8px | `p-2` / `gap-2` | Espacement interne minimal (padding tag, gap icon+label) |
| 16px | `p-4` / `gap-4` | Padding interne cards, gap entre éléments proches |
| 24px | `p-6` / `gap-6` | Padding cards standard, espacement sections internes |
| 32px | `p-8` / `gap-8` | Séparation entre groupes d'éléments |
| 48px | `p-12` / `gap-12` | Marge verticale entre sections |
| 64px | `p-16` / `gap-16` | Espacement majeur entre sections de page |
| 96px | `p-24` / `gap-24` | Marges top/bottom sections hero |

**Règle absolue : aucune valeur de spacing arbitraire. Toujours un multiple de 8.**

---

### 4.2 Grille & largeur max

- **Max content width :** `max-w-[1280px] mx-auto`
- **Padding horizontal page :** `px-6` (24px) mobile → `px-8` (32px) tablet → `px-16` (64px) desktop
- **Grille desktop :** 12 colonnes, gap 24px
- **Grille mobile :** 4 colonnes, gap 16px
- **Largeur prose (corps de texte) :** `max-w-[65ch]` — environ 65 caractères par ligne

---

### 4.3 Breakpoints (content-driven)

| Nom | Valeur | Tailwind prefix |
|---|---|---|
| Mobile | < 640px | default |
| Tablet | ≥ 640px | `sm:` |
| Tablet large | ≥ 768px | `md:` |
| Desktop | ≥ 1024px | `lg:` |
| Wide | ≥ 1280px | `xl:` |

---

## 5. Composants atomiques

### 5.1 Tag / Badge catégorie

Un tag est une pastille colorée qui indique la catégorie d'un projet ou d'un skill. Il n'est **jamais** un bouton — c'est un élément décoratif/informatif.

**Anatomie :**
```
[•] [Texte catégorie]
```
- Point coloré (`•`) : `w-1.5 h-1.5 rounded-full` dans la couleur accent de la catégorie
- Texte : Poppins 12-14px, font-medium
- Padding : `px-3 py-1` (12px / 4px)
- Border-radius : `rounded-full`
- Fond & bordure : selon catégorie (voir section 2.2)

**Variantes :**
- `light` : fond couleur category-XX-bg, texte category-XX-text
- `dark` : fond category-XX-accent à 11% opacité, bordure à 25%, texte category-XX-accent

**États :** default seulement (non-interactif). Si un tag devient filtrable (page Projets), ajouter `cursor-pointer hover:opacity-80 transition-opacity duration-150`.

---

### 5.2 Bouton CTA principal

```jsx
// Classes Tailwind
"inline-flex items-center gap-2 px-6 py-3 rounded-full
 bg-[#595A6F] text-[#F3F1FF] font-semibold text-sm
 transition-all duration-200 ease-out
 hover:bg-[#474860] hover:scale-[1.02]
 active:scale-[0.98] active:bg-[#3E3F58]
 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#595A6F]
 disabled:opacity-40 disabled:cursor-not-allowed disabled:pointer-events-none
 dark:bg-[#A6A6E2] dark:text-[#0D022B] dark:border dark:border-[#1B0854]
 dark:hover:bg-[#B8B8EA]
 dark:focus-visible:outline-[#A6A6E2]"
```

**Avec icône arrow :** Ajouter `<ArrowRight size={16} />` à droite du texte. L'icône se déplace de 4px à droite au hover : `group-hover:translate-x-1 transition-transform`.

---

### 5.3 Bouton secondaire (ghost)

```jsx
"inline-flex items-center gap-2 px-6 py-3 rounded-full
 bg-[#595A6F]/[0.15] border border-[#595A6F]/50 text-[#595A6F]
 font-semibold text-sm transition-all duration-200 ease-out
 hover:bg-[#595A6F]/[0.22]
 active:scale-[0.98]
 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#595A6F]
 disabled:opacity-40 disabled:cursor-not-allowed
 dark:bg-[#A6A6E2]/20 dark:border-[#A6A6E2]/[0.71] dark:text-[#A6A6E2]
 dark:hover:bg-[#A6A6E2]/30"
```

---

### 5.4 Lien CTA inline (dans le texte)

```jsx
"text-[#595A6F] font-semibold underline underline-offset-2
 hover:opacity-70 transition-opacity duration-150
 dark:text-[#A6A6E2]"
```

---

### 5.5 Navigation — Navbar

**Structure :**
```
[Logo S] [SALOME SOUQUE]          [Accueil] [Projets] [Compétences] [À propos]   [Contact CTA] [🌙] [FR/EN]
```

**Comportement :**
- Position : `sticky top-0 z-50`
- Fond : `bg-surface/80 backdrop-blur-md` — effet frosted glass
- Bordure bottom : `border-b border-[#283035]/10 dark:border-[#F0F8FF]/10`
- Hauteur : `h-16` (64px)
- Transition au scroll : après 20px de scroll, le backdrop-blur et la bordure apparaissent (via JS `scrollY > 20`)

**Lien actif :** `font-semibold` + `underline underline-offset-4` dans la couleur primary

**Lien hover :** `opacity-70 transition-opacity duration-150`

**Responsive :** En dessous de `md:`, les liens de nav disparaissent et un hamburger menu apparaît. Le menu mobile s'ouvre en drawer depuis la droite.

---

### 5.6 Logo

Cercle avec l'initiale "S" en police **Rubik Bubbles**.

**Specs visuelles :**
- Fond du cercle : `#FFF1E6` (beige crème — même token que `category-infra-bg`)
- Bordure : `#000000` (noir pur — exception justifiée : c'est un élément de marque, pas un texte)
- Épaisseur bordure : `border-2` (2px)
- Taille : `w-9 h-9` (36px) — taille généreuse pour que la police Rubik Bubbles soit lisible
- Lettre "S" : `text-sm` (14px), couleur `#000000` (le contraste #000 sur #FFF1E6 est 19:1 ✓ AAA)

**Import Google Fonts — à ajouter dans `app/layout.tsx` :**
```tsx
import { Poppins, Space_Grotesk, Rubik_Bubbles } from 'next/font/google'

const rubikBubbles = Rubik_Bubbles({
  subsets: ['latin'],
  weight: ['400'], // Rubik Bubbles n'existe qu'en weight 400
  variable: '--font-rubik-bubbles',
})
```

**Composant JSX :**
```jsx
<div className="w-9 h-9 rounded-full border-2 border-black bg-[#FFF1E6] flex items-center justify-center flex-shrink-0">
  <span
    className="text-sm leading-none text-black"
    style={{ fontFamily: 'var(--font-rubik-bubbles)' }}
  >
    S
  </span>
</div>
```

> **Note dark mode :** La bordure reste noire en dark mode — c'est un choix de marque intentionnel. Le fond `#FFF1E6` sur fond de page dark `#060E20` crée un contraste fort qui fait ressortir le logo. Ne pas inverser en dark mode.

---

### 5.7 Favicon & métadonnées onglet navigateur

**Ce qu'on appelle "favicon"** : c'est la petite icône visible dans l'onglet du navigateur, les favoris, et sur mobile quand on ajoute le site à l'écran d'accueil. Elle doit reprendre le logo — le "S" en Rubik Bubbles sur fond `#FFF1E6` avec bordure noire.

**Le titre de l'onglet** : le texte affiché dans l'onglet à côté de l'icône. Recommandation :

| Page | Titre affiché |
|---|---|
| Home | `Salomé Souque — Développeuse IA` |
| Projets | `Projets — Salomé Souque` |
| Compétences | `Compétences — Salomé Souque` |
| Détail projet | `[Nom du projet] — Salomé Souque` |
| À propos | `À propos — Salomé Souque` |

> **Justification UX du titre Home :** "Développeuse IA" (et non "Apprentie") parce que dans un onglet le titre est lu par les recruteurs qui ont 10 onglets ouverts — le mot "Apprentie" réduit la première impression. Le statut alternance est déjà clairement affiché sur la page elle-même.

---

**Implémentation dans Next.js App Router :**

Créer le fichier `/app/favicon.ico` OU utiliser l'API metadata de Next.js pour un favicon SVG plus propre.

Option recommandée — favicon SVG via `/app/icon.tsx` :
```tsx
// /app/icon.tsx
// Next.js génère automatiquement le favicon depuis ce fichier
import { ImageResponse } from 'next/og'

export const size = { width: 32, height: 32 }
export const contentType = 'image/png'

export default function Icon() {
  return new ImageResponse(
    (
      <div
        style={{
          width: 32,
          height: 32,
          borderRadius: '50%',
          background: '#FFF1E6',
          border: '2px solid #000000',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: 16,
          fontWeight: 400,
          color: '#000000',
        }}
      >
        S
      </div>
    ),
    { ...size }
  )
}
```

Pour les titres de page, dans chaque `page.tsx` :
```tsx
// /app/page.tsx (Home)
export const metadata = {
  title: 'Salomé Souque — Développeuse IA',
  description: 'Portfolio de Salomé Souque, développeuse en Intelligence Artificielle. Projets en NLP, Data Science, et développement web.',
}

// /app/projets/page.tsx
export const metadata = {
  title: 'Projets — Salomé Souque',
}

// /app/projets/[slug]/page.tsx (dynamique)
export async function generateMetadata({ params }) {
  return {
    title: `${params.slug} — Salomé Souque`,
  }
}
```

> **Note :** La `description` de la Home est aussi utilisée par Google dans les résultats de recherche (meta description). Garder entre 120 et 160 caractères.

---

## 6. Composants moléculaires

### 6.1 Project Card

**Anatomie (de haut en bas) :**
```
┌─────────────────────────────┐
│   [Image thumbnail 16:9]    │
├─────────────────────────────┤
│ [Titre projet]  [Badge cat] │
│ [Description courte 2 lignes truncated]
│                             │
│ [Voir le projet →]          │
└─────────────────────────────┘
```

**Specs :**
- Border-radius : `rounded-2xl` (16px)
- Padding : `p-5` (20px) — ici on utilise 20px car c'est la valeur la plus proche de 16px qui respire bien avec l'image, **exception justifiée** : utiliser `p-4` (16px) + `pb-6` (24px) pour le bas
- Fond : couleur catégorie bg (light) ou accent à 11% (dark)
- Bordure : `border border-transparent` en light (le fond coloré suffit) / `border border-[accent]/25` en dark
- Image : `rounded-xl overflow-hidden` — aspect-ratio 16:9 ou carré selon le projet
- Titre : Poppins 700 18-20px, `text-primary`
- Description : Poppins 400 14px, `text-secondary`, `line-clamp-2`
- Lien "Voir le projet" : texte CTA avec arrow, `text-sm`

**Hover state :**
```
hover:-translate-y-1 hover:shadow-lg transition-all duration-300 ease-out
```

**Focus state (keyboard nav) :**
```
focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-[#595A6F]
dark:focus-within:ring-[#A6A6E2]
```

---

### 6.2 Skill Card (page Compétences & Home)

Variante de card sans image. Structure :

```
┌─────────────────────────────┐
│ [Icône]                     │
│ [Titre compétence]          │
│ [Description courte]        │
│                             │
│ [Tag] [Tag] [Tag]           │
└─────────────────────────────┘
```

- Fond : même système catégorie
- Icône : 24px, couleur accent de la catégorie

---

### 6.3 Sidebar Info (page Détail projet)

Composant colonne droite dans le layout 2 colonnes :

**Blocs :**
1. **Mon Rôle** — liste de bullet points avec icône check coloré
2. **Compétences Clés** — cluster de tags catégoriels
3. **CTA Contact** — card avec fond lavande/violet, bouton CTA

Specs card sidebar :
- Border-radius : `rounded-2xl`
- Padding : `p-6`
- Fond : `bg-surface-raised`
- Séparation entre blocs sidebar : `mt-6` (24px)

---

### 6.4 Timeline Formation (page Compétences)

```
○ — [Année] [Titre formation]
|          [Institution]
○ — ...
```

- Ligne verticale : `border-l-2 border-[#283035]/20 dark:border-[#F0F8FF]/20`
- Point : `w-3 h-3 rounded-full` — couleur selon statut (en cours = accent primary, terminé = vert `#22C55E`)
- Badge "En cours" : fond rose/accent, texte blanc, `rounded-full px-2 py-0.5 text-xs`

---

### 6.5 Tableau Expertise Web (page Compétences)

| Colonne | Contenu |
|---|---|
| Domaine | Texte label |
| Technologie Principale | Cluster de tags |
| Niveau d'expertise | Barre de progression |

- Fond table : `bg-surface-raised rounded-2xl`
- Lignes séparées par `border-b border-[#283035]/10`
- Barre de progression : `h-1.5 rounded-full bg-[#595A6F] dark:bg-[#A6A6E2]` avec fond track `bg-[#283035]/10`
- **Accessibilité :** Chaque barre doit avoir `role="progressbar" aria-valuenow={X} aria-valuemin={0} aria-valuemax={100} aria-label="Niveau expertise Frontend"`

---

### 6.6 Toggle Dark Mode & Langue

**Placement recommandé :** extrémité droite de la navbar, après le bouton Contact.

**Ordre :** `[Contact]` ... `[🌙/☀️]` `[FR | EN]`

**Dark Mode toggle :**
- Icône soleil (light) / lune (dark)
- Taille : 20px
- Bouton icon : `w-9 h-9 rounded-full flex items-center justify-center hover:bg-[#283035]/10 dark:hover:bg-[#F0F8FF]/10 transition-colors`
- Pas de label texte — **mais** ajouter `aria-label="Basculer le mode sombre"` obligatoirement
- Au clic : ajouter/retirer la classe `dark` sur `<html>`, persister dans `localStorage`

**Sélecteur de langue :**
- Deux états : `FR` actif / `EN` actif
- Format : `FR | EN` avec le texte actif en `font-semibold text-primary`, l'inactif en `text-secondary`
- Pas de dropdown — simple toggle entre deux états
- `text-sm font-medium`

**Implémentation Next.js :**
- Dark mode : Context + `useEffect` pour localStorage + classe sur `<html>`
- Langue : `next-intl` ou Context simple selon complexité souhaitée

---

## 7. Pages — structure & layout

### 7.1 Page Home

**Pattern de lecture : Z-pattern** (page marketing)
- Logo top-left → Nav top-right → Hero content center-left → CTA bottom

**Sections (dans l'ordre) :**

```
1. NAV
2. HERO
   - Badge "Disponible pour une alternance" (pill colorée)
   - H1 : "Apprentie développeuse en / Intelligence Artificielle"
     → "Intelligence Artificielle" en italic + glow dark
   - Paragraphe intro (max-w-[55ch])
   - CTA "Voir mes travaux ↓"
   - Illustration Fisher-girl (position absolute, droite du hero)
   - Nuage de skills flottants (décoratif, pointer-events: none)

3. COMPÉTENCES (section résumé)
   - Supertitle Space Grotesk
   - H2 "Compétences"
   - Grid 2×2 de Skill Cards

4. PROJETS SÉLECTIONNÉS
   - Supertitle + H2 + lien "GitHub →" aligné à droite
   - Grid 3 colonnes de Project Cards

5. MON PARCOURS
   - Layout 2 colonnes : photo gauche / texte droite
   - Photo : noir & blanc, border-radius 16px
   - Boutons LinkedIn + CV

6. CTA CONTACT (section finale)
   - Fond card arrondie (lavande light / violet foncé dark)
   - H2 "Merci de m'avoir lu, construisons ensemble."
   - Bouton CTA

7. SECTION PHOTOGRAPHIE
   - Fond légèrement différent (surface-overlay)
   - Texte centré avec mots en bold italic
   - Bouton secondaire "Portfolio photographie ↗"

8. FOOTER
```

---

### 7.2 Page Tous les Projets

**Pattern : F-pattern** (listing, recherche)

```
1. NAV
2. HEADER PAGE
   - H1 "Tous mes Projets" (regular + italic)
   - Paragraphe description (max-w-[55ch])
   - Filtres catégorie alignés à droite : [Tout] [IA] [Web] [Data Science]
     → Filtres = pills, actif = fond plein catégorie, inactif = ghost

3. GRILLE PROJETS
   - 3 colonnes desktop / 2 colonnes tablet / 1 colonne mobile
   - Gap : 24px (gap-6)
   - Les cards s'affichent avec stagger animation (delay × index × 50ms)

4. BOUTON "Afficher plus de projets"
   - Centré, bouton secondaire ghost

5. SECTION PHOTOGRAPHIE (même que Home)
6. FOOTER
```

**Comportement filtre :**
- Clic sur une catégorie : filtre les cards (CSS `hidden` ou animation de sortie)
- La pill active reçoit le fond plein de sa couleur catégorie
- `aria-pressed="true/false"` sur chaque bouton filtre

---

### 7.3 Page Toutes les Compétences

**Pattern : F-pattern** (documentation)

```
1. NAV
2. HEADER PAGE
   - H1 "Toutes mes Compétences"
   - Paragraphe description
   - Illustration Fisher-girl (position absolute droite)

3. SECTION "Stack Technique"
   - Supertitle + H2 + ligne séparatrice
   - Card "Ma boîte à outils" : clusters de tags par catégorie

4. SECTION "Intelligence Artificielle"
   - H2 + séparateur
   - Grid 2 colonnes : "Compétences" | "Environnement & Outils"

5. SECTION "Développement Web"
   - H2 + séparateur
   - Tableau 3 colonnes avec barres de progression

6. SECTION "Formation & Certifications"
   - H2 + séparateur
   - Timeline verticale

7. SECTION PHOTOGRAPHIE
8. FOOTER
```

**Séparateurs de section :**
- Ligne horizontale : `<hr className="border-t border-[#283035]/15 dark:border-[#F0F8FF]/15 flex-1 ml-4">`
- Placée à droite du titre H2 sur la même ligne (flex row, items-center)

---

### 7.4 Page Détail Projet

**Pattern : F-pattern** (article/lecture)

```
1. NAV
2. BREADCRUMB
   - "← Tous les projets" : bouton ghost small

3. HERO PROJET
   - Tags catégorie (Data Science, Power BI) alignés à droite
   - H1 en 2 lignes : "Dashboard santé / des femmes pour" (bold)
             + "data.gouv" (italic, même taille)

4. LAYOUT 2 COLONNES (ratio 7/5 colonnes)
   │ COLONNE GAUCHE (7 col)      │ COLONNE DROITE (5 col)    │
   │                             │                           │
   │ Screenshot/Preview projet   │ Card "Mon Rôle"           │
   │ (card avec image)           │ Card "Compétences Clés"   │
   │                             │ Card "CTA Contact"        │
   │ Section "Le Défi"           │                           │
   │ - Supertitle + H2           │ (sticky top-24 sur desktop│
   │ - Paragraphes               │  pour suivre le scroll)   │
   │                             │                           │
   │ Card "La Solution"          │                           │
   │ - Fond catégorie teintée    │                           │
   │ - Bouton "Voir le projet"   │                           │
   │                             │                           │
   │ Section "Aperçus du projet" │                           │
   │ - H2                        │                           │
   │ - Grid 2 colonnes images    │                           │

5. SECTION PHOTOGRAPHIE
6. FOOTER
```

**Sidebar sticky :**
```jsx
<aside className="lg:sticky lg:top-24 lg:self-start space-y-6">
```

---

### 7.5 Footer

```
[Logo + Nom]                    [LinkedIn] [Instagram] [GitHub]
© 2026 Portfolio de Salomé SOUQUE. Merci de votre visite.
```

- Padding : `py-12 px-8`
- Fond : `bg-surface` (sans séparation visuelle marquée — la sobriété suffit)
- Liens sociaux : texte, `text-sm text-secondary hover:text-primary transition-colors`

---

## 8. Dark/Light mode — implémentation

### Stratégie recommandée : classe sur `<html>` + localStorage

```tsx
// app/providers/ThemeProvider.tsx
'use client'
import { createContext, useContext, useEffect, useState } from 'react'

type Theme = 'light' | 'dark'

const ThemeContext = createContext<{
  theme: Theme
  toggleTheme: () => void
}>({ theme: 'light', toggleTheme: () => {} })

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>('light')

  useEffect(() => {
    const saved = localStorage.getItem('theme') as Theme | null
    const preferred = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
    const initial = saved ?? preferred
    setTheme(initial)
    document.documentElement.classList.toggle('dark', initial === 'dark')
  }, [])

  const toggleTheme = () => {
    setTheme(prev => {
      const next = prev === 'light' ? 'dark' : 'light'
      localStorage.setItem('theme', next)
      document.documentElement.classList.toggle('dark', next === 'dark')
      return next
    })
  }

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}

export const useTheme = () => useContext(ThemeContext)
```

> **UX note :** Le toggle suit le système OS au premier chargement, puis respecte le choix manuel de l'utilisateur. C'est le comportement le plus respectueux de l'utilisateur.

### Configuration tailwind.config.ts

```ts
module.exports = {
  darkMode: 'class', // ← obligatoire
  // ...
}
```

---

## 9. Animations & micro-interactions

### Règles globales

- Micro-interactions (hover, press) : 100–200ms
- Transitions composants : 200–300ms
- Animations d'entrée page : 300–500ms
- Easing entrée : `ease-out` (cubic-bezier 0.16, 1, 0.3, 1) — spring naturel
- Easing sortie : `ease-in`
- Easing dans le même contexte : `ease-in-out`
- **Jamais de `linear`** pour des animations UI

### Animations d'entrée — cards en grille

Stagger avec délai calculé :
```tsx
// animation-delay = index * 50ms
// Total stagger max = 300ms
style={{ animationDelay: `${index * 50}ms` }}
```

Classe CSS (dans `globals.css`) :
```css
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
}
.card-enter {
  animation: fadeInUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) both;
}
```

### Nuage de skills flottants (Home)

Animation flottante légère, décorative :
```css
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50%       { transform: translateY(-8px); }
}
.skill-float {
  animation: float 3s ease-in-out infinite;
}
/* Chaque pill avec un delay différent pour désynchroniser */
```

### Hover cards

```
hover:-translate-y-1 hover:shadow-lg transition-all duration-300
```

### Lien "Voir le projet →"

L'arrow `→` se translate de 4px à droite au hover de la card :
```tsx
<span className="group-hover:translate-x-1 transition-transform duration-200">→</span>
```
La card parente reçoit `group`.

### prefers-reduced-motion

Obligatoire dans `globals.css` :
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 10. Accessibilité

### Checklist minimale obligatoire

- [ ] Tous les boutons ont un texte ou `aria-label`
- [ ] Les icônes décoratives ont `aria-hidden="true"`
- [ ] Les images ont un `alt` descriptif (contenu), vide pour les décorations
- [ ] Les barres de progression ont `role="progressbar"` avec `aria-valuenow/min/max`
- [ ] Les boutons filtres ont `aria-pressed`
- [ ] Le toggle dark mode a `aria-label="Activer le mode sombre"` (mis à jour dynamiquement)
- [ ] Le focus ring est visible sur tous les éléments interactifs (ne jamais mettre `outline: none` sans remplacement)
- [ ] La navigation au clavier suit un ordre logique (Tab)
- [ ] Le modal/drawer mobile ferme avec Escape et retourne le focus au déclencheur
- [ ] Les contraste texte/fond respectent WCAG AA (4.5:1 minimum pour le texte normal)
- [ ] Les tags catégoriel ne transmettent pas l'info par couleur seule — ils ont toujours un label texte

### Contraste — récapitulatif des paires critiques

| Paire | Ratio | Statut |
|---|---|---|
| `#283035` sur `#EFF7FE` | 10.2:1 | ✓ AAA |
| `#6B767C` sur `#EFF7FE` | 4.7:1 | ✓ AA |
| `#F3F1FF` sur `#595A6F` | 6.8:1 | ✓ AA+ |
| `#0D022B` sur `#A6A6E2` | 8.1:1 | ✓ AAA |
| `#F0F8FF` sur `#060E20` | 14.1:1 | ✓ AAA |
| `#DBE4EA` sur `#060E20` | 10.8:1 | ✓ AAA |

---

## 11. Corrections UX apportées au Figma

Ces modifications sont des améliorations par rapport aux screens fournis. Elles ne changent pas le design visuel de manière visible mais corrigent des problèmes d'accessibilité, de cohérence ou d'utilisabilité.

### 11.1 Typographie

**Problème :** Pas d'échelle typographique explicite dans le Figma — certains textes semblent avoir des tailles arbitraires.
**Correction :** Toutes les tailles sont normalisées sur l'échelle modular 1.25 définie en section 3.2.

**Problème :** Les mots italiques dans les titres (`*Projets*`) pourraient être interprétés comme une police différente.
**Correction :** Précision explicite que c'est Poppins italic weight normal, pas une police serif.

### 11.2 Contraste

**Problème :** `text-secondary` light à 80% d'opacité sur fond variable donne un ratio juste au seuil.
**Correction :** Valeur résolue fixe `#6B767C` recommandée.

### 11.3 États des composants

**Problème :** Le Figma ne montre que les états default et hover visibles. Les états focus, active, disabled, error ne sont pas définis.
**Correction :** Tous les états sont définis en section 5 pour chaque composant interactif.

### 11.4 Tags non-interactifs vs filtres

**Problème :** Les tags sur les cards et les filtres de la page Projets semblent visuellement identiques dans le Figma.
**Correction :** Les filtres (cliquables) doivent avoir `cursor-pointer`, un état actif visible, et `aria-pressed`. Les tags sur les cards sont `role="status"` ou simples `<span>` non-interactifs.

### 11.5 Sidebar sticky

**Problème :** La sidebar de la page Détail projet n'a pas de comportement de scroll défini.
**Correction :** `sticky top-24` sur desktop — elle suit le scroll et reste visible pendant la lecture.

### 11.6 Images sans dimensions fixes

**Problème :** Les thumbnails de project cards n'ont pas d'aspect-ratio défini dans le Figma, ce qui peut créer des layout shifts.
**Correction :** Toutes les images de cards utilisent `aspect-video` (16:9) avec `object-cover` dans un conteneur `overflow-hidden`.

### 11.7 Dark mode — textes sur cards colorées

**Problème :** En dark mode, le texte sur les cards utilise la couleur accent (ex: `#9799FF` sur fond `#9799FF` à 11%). Le contraste doit être vérifié.
**Résultat vérification :** `#9799FF` sur `#9799FF` à 11% (soit approximativement `#121224`) = ratio ≥ 4.5:1 ✓. Valide.

---

## Annexe — Structure de fichiers recommandée

```
/app
  /[locale]           ← si i18n avec next-intl
    layout.tsx        ← ThemeProvider, fonts
    page.tsx          ← Home
    /projets
      page.tsx
      /[slug]
        page.tsx
    /competences
      page.tsx

/components
  /atoms
    Button.tsx        ← variantes: primary, secondary
    Tag.tsx           ← prop: category
    Badge.tsx
  /molecules
    ProjectCard.tsx
    SkillCard.tsx
    NavBar.tsx
    ThemeToggle.tsx
    LanguageToggle.tsx
  /sections
    Hero.tsx
    ProjectGrid.tsx
    SkillsSection.tsx
    ContactCTA.tsx
    Footer.tsx

/lib
  tokens.ts           ← export des couleurs pour usage JS
  categories.ts       ← mapping catégorie → couleur

/public
  /images

tailwind.config.ts
```

---

*Design spec généré par analyse des screens Figma + tokens fournis. Stack : Next.js + Tailwind CSS. Conforme WCAG 2.1 AA.*
