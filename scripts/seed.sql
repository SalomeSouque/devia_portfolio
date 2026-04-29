-- seed.sql
-- Données de test — développement uniquement
-- Reset : psql ... < reset.sql && psql ... < schema.sql && psql ... < seed.sql
--


-- ── 1. SKILL CATEGORIES ──────────────────────────────────────────
INSERT INTO skill_categories (slug, color_hex) VALUES
  ('ia',           '#6c63ff'),
  ('web',          '#e96b99'),
  ('data-science', '#2ec4b6'),
  ('infra',        '#f4a261');

INSERT INTO skill_category_translations (skill_category_id, locale, label) VALUES
  (1, 'fr', 'Intelligence Artificielle'),
  (1, 'en', 'Artificial Intelligence'),
  (2, 'fr', 'Développement Web'),
  (2, 'en', 'Web Development'),
  (3, 'fr', 'Data Science'),
  (3, 'en', 'Data Science'),
  (4, 'fr', 'Infrastructure'),
  (4, 'en', 'Infrastructure');


-- ── 2. SKILLS ────────────────────────────────────────────────────
INSERT INTO skills (slug, skill_category_id, proficiency_level) VALUES
  ('python',           1, 85),  -- id 1
  ('pytorch',          1, 70),  -- id 2
  ('machine-learning', 1, 80),  -- id 3
  ('react',            2, 75),  -- id 4
  ('nextjs',           2, 70),  -- id 5
  ('sql',              3, 80),  -- id 6
  ('pandas',           3, 75),  -- id 7
  ('power-bi',         3, 65),  -- id 8
  ('docker',           4, 60);  -- id 9

INSERT INTO skill_translations (skill_id, locale, label) VALUES
  (1, 'fr', 'Python'),          (1, 'en', 'Python'),
  (2, 'fr', 'PyTorch'),         (2, 'en', 'PyTorch'),
  (3, 'fr', 'Machine Learning'),(3, 'en', 'Machine Learning'),
  (4, 'fr', 'React'),           (4, 'en', 'React'),
  (5, 'fr', 'Next.js'),         (5, 'en', 'Next.js'),
  (6, 'fr', 'SQL'),             (6, 'en', 'SQL'),
  (7, 'fr', 'Pandas'),          (7, 'en', 'Pandas'),
  (8, 'fr', 'Power BI'),        (8, 'en', 'Power BI'),
  (9, 'fr', 'Docker'),          (9, 'en', 'Docker');


-- ── 3. PAGE SKILLS (badges flottants sur la home) ────────────────
INSERT INTO page_skills (page_key, skill_id, display_order) VALUES
  ('home', 1, 1),  -- Python
  ('home', 3, 2),  -- Machine Learning
  ('home', 4, 3),  -- React
  ('home', 8, 4);  -- Power BI


-- ── 4. CATEGORIES DE PROJETS ─────────────────────────────────────
-- CORRECTION : infra ajoutée (manquait dans le seed précédent)
INSERT INTO categories (slug, color_hex) VALUES
  ('ia',           '#6c63ff'),  -- id 1
  ('web',          '#e96b99'),  -- id 2
  ('data-science', '#2ec4b6'),  -- id 3
  ('infra',        '#f4a261');  -- id 4

INSERT INTO category_translations (category_id, locale, label) VALUES
  (1, 'fr', 'IA'),            (1, 'en', 'AI'),
  (2, 'fr', 'Web'),           (2, 'en', 'Web'),
  (3, 'fr', 'Data Science'),  (3, 'en', 'Data Science'),
  (4, 'fr', 'Infrastructure'),(4, 'en', 'Infrastructure');


-- ── 5. PROJETS ───────────────────────────────────────────────────
-- Stratégie cover_image :
--   - Projet avec vraie cover → chemin réel
--   - Projets sans cover → NULL (le composant affichera le placeholder selon catégorie)
-- Projet 6 volontairement incomplet pour tester les cas d'erreur

INSERT INTO projects (slug, cover_image, date, github_url, demo_url, featured, display_order) VALUES
  -- Projet 1 : vraie cover, featured
  ('dashboard-sante-femmes',
   '/images/projects/dashboard-sante/cover.png',
   '2024-03',
   'https://github.com/salome/dashboard-sante',
   NULL,
   true, 1),
  -- Projet 2 : catégorie IA → placeholder-ia
  ('atelier-bot',
   NULL,
   '2024-06',
   'https://github.com/salome/atelier-bot',
   'https://atelier-bot.vercel.app',
   true, 2),
  -- Projet 3 : catégorie Web → placeholder-web
  ('portfolio-next',
   NULL,
   '2024-11',
   'https://github.com/salome/portfolio-next',
   NULL,
   false, 3),
  -- Projet 4 : catégorie Data Science → placeholder-data
  ('analyse-tweets-climat',
   NULL,
   '2025-01',
   'https://github.com/salome/tweets-climat',
   NULL,
   false, 4),
  -- Projet 5 : catégorie Infra → placeholder-infra
  ('pipeline-etl-open-data',
   NULL,
   '2025-03',
   NULL,
   NULL,
   false, 5),
  -- Projet 6 : volontairement incomplet — pas de traduction EN, pas de skills
  -- Sert à tester le comportement du composant quand des données manquent
  ('projet-incomplet-test',
   NULL,
   NULL,
   NULL,
   NULL,
   false, 6);

-- Traductions projets
-- NOTE : projet 6 n'a QUE la version FR — pas de EN volontairement
INSERT INTO project_translations (project_id, locale, title, short_description, long_description) VALUES
  -- Projet 1
  (1, 'fr',
   'Dashboard santé des femmes pour data.gouv',
   'Analyse de l''accessibilité aux soins gynécologiques via les données ouvertes.',
   'Cette analyse s''inscrit dans le cadre du défi Santé et territoires. Trois territoires aux profils contrastés ont été comparés à partir des données de la CNAM et de la DREES, avec une attention particulière portée aux déserts médicaux.'),
  (1, 'en',
   'Women''s Health Dashboard for data.gouv',
   'Analysis of gynecological care accessibility using open data.',
   'This analysis is part of the Health and Territories challenge. Three contrasting territories were compared using CNAM and DREES data, with a focus on medical deserts.'),
  -- Projet 2
  (2, 'fr',
   'Atelier Bot',
   'Assistant conversationnel spécialisé dans l''assistance créative pour designers UX.',
   'Atelier Bot est un LLM fine-tuné sur un corpus de briefs créatifs et de retours utilisateurs. Il aide les designers à reformuler leurs intuitions, générer des alternatives et structurer leurs livrables.'),
  (2, 'en',
   'Atelier Bot',
   'Conversational assistant for creative support, built for UX designers.',
   'Atelier Bot is a fine-tuned LLM trained on a corpus of creative briefs and user feedback. It helps designers rephrase intuitions, generate alternatives and structure deliverables.'),
  -- Projet 3
  (3, 'fr',
   'Portfolio Next.js',
   'Ce portfolio — conçu avec Next.js 14, PostgreSQL et Tailwind CSS.',
   'Architecture App Router, support i18n FR/EN, mode sombre/clair, base de données PostgreSQL pour le contenu dynamique. Déployé via Docker derrière Traefik.'),
  (3, 'en',
   'Next.js Portfolio',
   'This portfolio — built with Next.js 14, PostgreSQL and Tailwind CSS.',
   'App Router architecture, FR/EN i18n support, dark/light mode, PostgreSQL for dynamic content. Deployed via Docker behind Traefik.'),
  -- Projet 4
  (4, 'fr',
   'Analyse des tweets sur le climat',
   'Classification et analyse de sentiment sur 50 000 tweets liés au changement climatique.',
   'Pipeline complet : collecte via l''API Twitter, nettoyage avec Pandas, classification par un modèle BERT fine-tuné, visualisation des résultats dans un dashboard Power BI.'),
  (4, 'en',
   'Climate Tweet Analysis',
   'Sentiment classification on 50,000 climate-related tweets.',
   'Full pipeline: data collection via Twitter API, cleaning with Pandas, classification using a fine-tuned BERT model, results visualised in a Power BI dashboard.'),
  -- Projet 5
  (5, 'fr',
   'Pipeline ETL — Open Data',
   'Automatisation de l''ingestion et de la transformation de jeux de données publics.',
   'Pipeline ETL conteneurisé sous Docker, orchestré par des cron jobs. Ingestion depuis data.gouv.fr, transformation avec Python et SQL, stockage dans PostgreSQL. Monitoring via logs structurés.'),
  (5, 'en',
   'ETL Pipeline — Open Data',
   'Automated ingestion and transformation of public datasets.',
   'Dockerised ETL pipeline orchestrated with cron jobs. Ingestion from data.gouv.fr, transformation with Python and SQL, storage in PostgreSQL. Monitoring via structured logs.'),
  -- Projet 6 — FR uniquement (cas d''erreur volontaire)
  (6, 'fr',
   'Projet de test incomplet',
   'Ce projet est volontairement incomplet pour tester les cas limites.',
   NULL);  -- long_description NULL aussi


-- ── 6. SECTIONS DE PROJETS ───────────────────────────────────────
-- Projet 1 : sections complètes (3 sections FR + EN)
INSERT INTO project_sections (project_id, locale, section_key, title, content, display_order) VALUES
  (1, 'fr', 'challenge', 'Le Défi',
   'L''accessibilité aux soins gynécologiques varie fortement selon les territoires, avec un impact direct sur le dépistage précoce.', 1),
  (1, 'en', 'challenge', 'The Challenge',
   'Access to gynaecological care varies significantly by territory, directly impacting early screening rates.', 1),
  (1, 'fr', 'solution', 'La Solution',
   'Comparaison de trois territoires aux profils contrastés à partir de données ouvertes CNAM et DREES.', 2),
  (1, 'en', 'solution', 'The Solution',
   'Comparison of three contrasting territories using CNAM and DREES open data.', 2),
  (1, 'fr', 'role', 'Mon Rôle',
   '- Collecte et nettoyage des données (ETL)\n- Modélisation du dashboard\n- Déploiement via Docker', 3),
  (1, 'en', 'role', 'My Role',
   '- Data collection and cleaning (ETL)\n- Dashboard modelling\n- Docker deployment', 3),

  -- Projet 2 : sections partielles (challenge uniquement) pour tester page détail partielle
  (2, 'fr', 'challenge', 'Le Défi',
   'Les designers UX manquent d''outils pour explorer rapidement des alternatives créatives sans sortir de leur flux de travail.', 1),
  (2, 'en', 'challenge', 'The Challenge',
   'UX designers lack tools to quickly explore creative alternatives without breaking their workflow.', 1);

-- Projet 6 : aucune section — cas d'erreur volontaire


-- ── 7. IMAGES DE PROJETS ─────────────────────────────────────────
-- project_images : galerie affichée sur la page détail
-- Seul le projet 1 a de vraies images pour l'instant
-- Les autres n'ont pas de lignes ici → le composant gère le cas vide
INSERT INTO project_images (project_id, file_path, alt_text, display_order) VALUES
  (1, '/images/projects/dashboard-sante/cover.png',
      'Vue d''ensemble du dashboard santé des femmes', 1),
  (1, '/images/projects/dashboard-sante/apercu-1.png',
      'Carte d''accessibilité aux soins gynécologiques par territoire', 2),
  (1, '/images/projects/dashboard-sante/apercu-2.png',
      'Comparaison des indicateurs entre trois territoires', 3);


-- ── 8. LIAISONS N:N ──────────────────────────────────────────────
INSERT INTO project_categories (project_id, category_id) VALUES
  (1, 3),  -- dashboard → data-science
  (1, 1),  -- dashboard → ia
  (2, 1),  -- atelier-bot → ia
  (3, 2),  -- portfolio-next → web
  (4, 3),  -- tweets-climat → data-science
  (4, 1),  -- tweets-climat → ia aussi
  (5, 4),  -- pipeline-etl → infra
  (5, 3);  -- pipeline-etl → data-science aussi
  -- Projet 6 : aucune catégorie — cas d'erreur volontaire

INSERT INTO project_skills (project_id, skill_id) VALUES
  (1, 1), (1, 7), (1, 8), (1, 6),  -- dashboard : python, pandas, power-bi, sql
  (2, 1), (2, 2), (2, 3),           -- atelier-bot : python, pytorch, ml
  (3, 4), (3, 5),                   -- portfolio : react, nextjs
  (4, 1), (4, 7), (4, 8),           -- tweets : python, pandas, power-bi
  (5, 1), (5, 6), (5, 9);           -- pipeline : python, sql, docker
  -- Projet 6 : aucun skill — cas d'erreur volontaire


-- ── 9. FORMATION ─────────────────────────────────────────────────
INSERT INTO education (start_year, end_year, is_current, display_order) VALUES
  (2023, NULL, true,  1),  -- id 1 : alternance en cours
  (2024, 2024, false, 2),  -- id 2 : formation web
  (2022, 2022, false, 3);  -- id 3 : bac

INSERT INTO education_translations (education_id, locale, degree, institution) VALUES
  (1, 'fr', 'Alternance développement en Intelligence Artificielle', 'Artefact'),
  (1, 'en', 'AI Development Apprenticeship',                         'Artefact'),
  (2, 'fr', 'Formation développement web',                           'EM Lyon'),
  (2, 'en', 'Web Development Training',                              'EM Lyon'),
  (3, 'fr', 'Bac général — Mention Bien',                            'Lycée'),
  (3, 'en', 'French Baccalaureate — High Distinction',               'Lycée');


-- ── 10. MÉDIAS ───────────────────────────────────────────────────
-- CORRECTION : suppression de hero-illustration (le hero est composé d'assets design/)
-- CORRECTION : chemin logo corrigé + alt_text renseigné partout
INSERT INTO media (key, file_path_light, file_path_dark, alt_text, media_type) VALUES
  ('portrait',
   '/images/media/portrait.png',
   NULL,
   'Portrait de Salomé Souque',
   'portrait'),
  ('logo',
   '/images/logo/S_logo.png',
   NULL,
   'Logo S — Salomé Souque',
   'logo'),
  ('og-home',
   '/images/og/og-home.jpg',
   NULL,
   'Portfolio de Salomé Souque — Développeuse IA',
   'og');


-- ── 11. LIENS ────────────────────────────────────────────────────
INSERT INTO links (page_key, project_id, platform, url, locale) VALUES
  ('footer', NULL, 'linkedin',  'https://linkedin.com/in/salome-souque', NULL),
  ('footer', NULL, 'github',    'https://github.com/salome',             NULL),
  ('footer', NULL, 'instagram', 'https://instagram.com/salome',          NULL);

