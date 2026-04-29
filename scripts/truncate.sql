-- truncate.sql
-- Vide toutes les tables sans supprimer leur structure
-- L'ordre est important : on supprime d'abord les tables qui ont des FK
-- RESTART IDENTITY remet les séquences d'ID à 1 (comme un vrai reset de données)

TRUNCATE TABLE
  project_skills,
  project_categories,
  project_images,
  project_sections,
  project_translations,
  projects,
  page_skills,
  skill_translations,
  skills,
  skill_category_translations,
  skill_categories,
  category_translations,
  categories,
  education_translations,
  education,
  links,
  media
RESTART IDENTITY CASCADE;