-- reset.sql — DANGER : efface tout et recrée
-- À n'utiliser qu'en développement, jamais en production

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;


-- Ces 4 lignes suppriment tout le contenu du schema `public` (toutes tes tables, contraintes, index) et le recréent vide. Après avoir exécuté `reset.sql`, tu ré-exécutes `schema.sql` puis `seed.sql` — tu repars de zéro proprement.
