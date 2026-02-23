-- 1. DROP TRIGGERS
DROP TRIGGER IF EXISTS tr_entities_updated ON "entities";

DROP TRIGGER IF EXISTS tr_comments_updated ON "comments";

DROP TRIGGER IF EXISTS tr_file_uploads_updated ON "file_uploads";

-- 2. DROP LINK TABLES (Many-to-Many)
DROP TABLE IF EXISTS "comment_attachment_links";

DROP TABLE IF EXISTS "comment_rich_text_links";

DROP TABLE IF EXISTS "data_source_rich_text_links";

DROP TABLE IF EXISTS "database_rich_text_links";

-- 3. DROP TABLES (Child/Specialized tables first)
DROP TABLE IF EXISTS "comments";

DROP TABLE IF EXISTS "icons";

DROP TABLE IF EXISTS "pages";

DROP TABLE IF EXISTS "data_sources";

DROP TABLE IF EXISTS "data_source_properties";

DROP TABLE IF EXISTS "databases";

DROP TABLE IF EXISTS "blocks";

DROP TABLE IF EXISTS "entities";

DROP TABLE IF EXISTS "parents";

DROP TABLE IF EXISTS "rich_text_objects";

DROP TABLE IF EXISTS "files";

DROP TABLE IF EXISTS "file_uploads";

DROP TABLE IF EXISTS "user_credentials";

DROP TABLE IF EXISTS "users";

-- 4. DROP TYPES (Enums)
DROP TYPE IF EXISTS "data_rto_type";

DROP TYPE IF EXISTS "icon_type";

DROP TYPE IF EXISTS "block_type";

DROP TYPE IF EXISTS "data_source_type";

DROP TYPE IF EXISTS "id_type";

DROP TYPE IF EXISTS "upload_status";

DROP TYPE IF EXISTS "file_type";

DROP TYPE IF EXISTS "color";

DROP TYPE IF EXISTS "rto_type";

DROP TYPE IF EXISTS "user_type";

-- 5. DROP FUNCTIONS
DROP FUNCTION IF EXISTS set_updated_at ();

-- 6. REVOKE PRIVILEGES & ROLES
-- Note: We only revert the privileges. Usually, you don't drop the ROLE
-- in a migration script unless you are absolutely sure it isn't used elsewhere.
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE USAGE,
SELECT
  ON SEQUENCES
FROM
  web_backend_public;

GRANT USAGE,
SELECT
  ON ALL SEQUENCES IN SCHEMA public TO web_backend_public;

ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE
SELECT
,
  INSERT,
UPDATE,
DELETE ON TABLES
FROM
  web_backend_public;

REVOKE
SELECT
,
  INSERT,
UPDATE,
DELETE ON ALL TABLES IN SCHEMA public
FROM
  web_backend_public;

REVOKE USAGE ON SCHEMA public
FROM
  web_backend_public;

REVOKE CONNECT ON DATABASE "web-backend"
FROM
  web_backend_public;

-- Uncomment the line below if you want the migration to delete the role entirely:
-- DROP ROLE IF EXISTS web_backend_public;
