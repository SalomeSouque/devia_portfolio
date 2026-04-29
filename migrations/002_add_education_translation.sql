-- migrations/002_add_education_translations.sql
-- Contexte : la table education stockait degree et institution en dur,
-- sans support i18n. Cette migration extrait ces colonnes traduisibles
-- dans une table education_translations, conformément au pattern
-- utilisé par toutes les autres tables de contenu du projet.

-- Étape 1 : créer la table de traductions
CREATE TABLE education_translations (
  id           SERIAL  PRIMARY KEY,
  education_id INTEGER NOT NULL REFERENCES education(id) ON DELETE CASCADE,
  locale       TEXT    NOT NULL,
  degree       TEXT    NOT NULL,
  institution  TEXT    NOT NULL,
  UNIQUE (education_id, locale)
);

-- Étape 2 : migrer les données existantes vers FR (langue d'origine)
-- On suppose que les données actuelles sont en français.
-- Si la table est vide en dev, ces INSERT n'insèrent rien — pas de risque.
INSERT INTO education_translations (education_id, locale, degree, institution)
SELECT id, 'fr', degree, institution
FROM education
WHERE degree IS NOT NULL;

-- Étape 3 : supprimer les colonnes devenues redondantes
ALTER TABLE education DROP COLUMN degree;
ALTER TABLE education DROP COLUMN institution;

-- Étape 4 : index de performance (cohérent avec les autres tables)
CREATE INDEX idx_education_translations_locale
  ON education_translations(education_id, locale);