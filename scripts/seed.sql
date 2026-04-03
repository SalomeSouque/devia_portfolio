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