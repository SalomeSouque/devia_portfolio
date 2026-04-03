--  GROUPES DE COMPÉTENCES 
CREATE TABLE skill_categories (
id SERIAL PRIMARY KEY,
slug TEXT NOT NULL UNIQUE,
color_hex TEXT NOT NULL
);

CREATE TABLE skill_category_translations (
id SERIAL PRIMARY KEY,
skill_category_id INTEGER NOT NULL REFERENCES skill_categories(id) ON DELETE CASCADE,
locale TEXT NOT NULL,
label TEXT NOT NULL,
UNIQUE (skill_category_id, locale)
);


--  COMPÉTENCES 
CREATE TABLE skills (
id SERIAL PRIMARY KEY,
slug TEXT NOT NULL UNIQUE,
skill_category_id INTEGER NOT NULL REFERENCES skill_categories(id),
icon_url TEXT,
proficiency_level INTEGER CHECK (proficiency_level BETWEEN 0 AND 100) DEFAULT 0
);

CREATE TABLE skill_translations (
id SERIAL PRIMARY KEY,
skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
locale TEXT NOT NULL,
label TEXT NOT NULL,
UNIQUE (skill_id, locale)
);

CREATE TABLE page_skills (
id SERIAL PRIMARY KEY,
page_key TEXT NOT NULL,
skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
display_order INTEGER DEFAULT 0
);


--  CATÉGORIES DE PROJETS 
CREATE TABLE categories (
id SERIAL PRIMARY KEY,
slug TEXT NOT NULL UNIQUE,
color_hex TEXT NOT NULL,
icon TEXT
);

CREATE TABLE category_translations (
id SERIAL PRIMARY KEY,
category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
locale TEXT NOT NULL,
label TEXT NOT NULL,
UNIQUE (category_id, locale)
);


--  PROJETS 
CREATE TABLE projects (
id SERIAL PRIMARY KEY,
slug TEXT NOT NULL UNIQUE,
cover_image TEXT,
date TEXT,
github_url TEXT,
demo_url TEXT,
featured BOOLEAN DEFAULT false,
display_order INTEGER DEFAULT 0
);

CREATE TABLE project_translations (
id SERIAL PRIMARY KEY,
project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
locale TEXT NOT NULL,
title TEXT NOT NULL,
short_description TEXT,
long_description TEXT,
UNIQUE (project_id, locale)
);

CREATE TABLE project_sections (
id SERIAL PRIMARY KEY,
project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
locale TEXT NOT NULL,
section_key TEXT NOT NULL,
title TEXT,
content TEXT,
display_order INTEGER DEFAULT 0
);

CREATE TABLE project_images (
id SERIAL PRIMARY KEY,
project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
file_path TEXT NOT NULL,
alt_text TEXT,
display_order INTEGER DEFAULT 0
);


--  TABLES DE LIAISON N:N 
CREATE TABLE project_categories (
project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
PRIMARY KEY (project_id, category_id)
);

CREATE TABLE project_skills (
project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
PRIMARY KEY (project_id, skill_id)
);


--  FORMATION, MÉDIAS, LIENS 
CREATE TABLE education (
id SERIAL PRIMARY KEY,
degree TEXT NOT NULL,
institution TEXT NOT NULL,
start_year INTEGER NOT NULL,
end_year INTEGER,
is_current BOOLEAN DEFAULT false,
display_order INTEGER DEFAULT 0
);

CREATE TABLE media (
id SERIAL PRIMARY KEY,
key TEXT NOT NULL UNIQUE,
file_path_light TEXT NOT NULL,
file_path_dark TEXT,
alt_text TEXT,
media_type TEXT NOT NULL
);

CREATE TABLE links (
id SERIAL PRIMARY KEY,
page_key TEXT,
project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
platform TEXT NOT NULL,
url TEXT NOT NULL,
locale TEXT
);


-- INDEX DE PERFORMANCE 
CREATE INDEX idx_project_translations_locale ON project_translations(project_id, locale);
CREATE INDEX idx_project_sections_locale ON project_sections(project_id, locale);
CREATE INDEX idx_skill_translations_locale ON skill_translations(skill_id, locale);
CREATE INDEX idx_category_translations_locale ON category_translations(category_id, locale);
CREATE INDEX idx_page_skills_page_key ON page_skills(page_key);
CREATE INDEX idx_projects_featured ON projects(featured);
CREATE INDEX idx_projects_display_order ON projects(display_order);