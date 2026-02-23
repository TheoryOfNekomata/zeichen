--- CREATE ROLE web_backend_public WITH LOGIN PASSWORD '${WEB_BACKEND_PUBLIC_PASSWORD}';

GRANT CONNECT ON DATABASE "web-backend" TO web_backend_public;
GRANT USAGE ON SCHEMA public TO web_backend_public;

-- Allow SELECT, INSERT, UPDATE, and DELETE on all tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO web_backend_public;

-- Ensure new tables automatically get the same privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO web_backend_public;

-- Allow usage on sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO web_backend_public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO web_backend_public;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TYPE "user_type" AS ENUM (
    'admin',
    'member',
    'guest'
);

CREATE TYPE "rto_type" AS ENUM (
    'text',
    'mention',
    'equation'
);

CREATE TYPE "color" AS ENUM (
    'blue',
    'blue_background',
    'brown',
    'brown_background',
    'default',
    'gray',
    'gray_background',
    'green',
    'green_background',
    'orange',
    'orange_background',
    'pink',
    'pink_background',
    'purple',
    'purple_background',
    'red',
    'red_background',
    'yellow',
    'yellow_background'
);

CREATE TYPE "file_type" AS ENUM (
    'file',
    'file_upload',
    'external'
);

CREATE TYPE "upload_status" AS ENUM (
    'pending',
    'uploaded',
    'expired',
    'failed'
);

CREATE TYPE "id_type" AS ENUM (
    'database_id',
    'data_source_id',
    'page_id',
    'workspace',
    'block_id'
);

CREATE TYPE "data_source_type" AS ENUM (
    'checkbox',
    'created_by',
    'created_time',
    'date',
    'email',
    'files',
    'formulas',
    'last_edited_by',
    'last_edited_time',
    'multi_select',
    'number',
    'people',
    'phone_number',
    'place',
    'relation',
    'rich_text',
    'rollup',
    'select',
    'status',
    'title',
    'url'
);

CREATE TYPE "block_type" AS ENUM (
    'bookmark',
    'breadcrumb',
    'bulleted_list_item',
    'callout',
    'child_database',
    'child_page',
    'column',
    'column_list',
    'divider',
    'embed',
    'equation',
    'file',
    'heading_1',
    'heading_2',
    'heading_3',
    'image',
    'link_preview',
    'numbered_list_item',
    'paragraph',
    'pdf',
    'quote',
    'synced_block',
    'table',
    'table_of_contents',
    'table_row',
    'template',
    'to_do',
    'toggle',
    'unsupported',
    'video'
);

CREATE TYPE "icon_type" AS ENUM (
    'emoji',
    'file'
);

CREATE TYPE "data_rto_type" AS ENUM (
    'title',
    'description'
);

CREATE TABLE IF NOT EXISTS "databases" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "icon" UUID NOT NULL,
    "cover" UUID NOT NULL,
    "url" TEXT NOT NULL,
    "is_inline" BOOLEAN NOT NULL,
    "public_url" TEXT NOT NULL,
    "entity_id" UUID NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

CREATE INDEX "databases_index_0" ON "databases" ("icon", "cover", "entity_id");

CREATE TABLE IF NOT EXISTS "data_sources" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "properties" UUID NOT NULL,
    "database_parent" UUID NOT NULL,
    "icon" UUID NOT NULL,
    "entity_id" UUID NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

CREATE INDEX "data_sources_index_0" ON "data_sources" ("properties", "database_parent", "icon", "entity_id");

CREATE TABLE IF NOT EXISTS "pages" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "entity_id" UUID NOT NULL UNIQUE,
    "icon" UUID NOT NULL,
    "cover" UUID NOT NULL,
    -- idk which property I should link it to.
    "properties" UUID NOT NULL,
    "url" TEXT NOT NULL,
    "public_url" TEXT NOT NULL,
    PRIMARY KEY("id")
);

COMMENT ON COLUMN "pages"."properties" IS 'idk which property I should link it to.';
CREATE INDEX "pages_index_0" ON "pages" ("entity_id", "icon", "cover", "properties");

CREATE TABLE IF NOT EXISTS "blocks" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "type" BLOCK_TYPE NOT NULL,
    "has_children" BOOLEAN NOT NULL,
    "metadata" JSONB,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "users" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "name" TEXT NOT NULL,
    "avatar_url" TEXT NOT NULL,
    "email" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "user_credentials" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "user_id" UUID NOT NULL UNIQUE,
    -- Should be hashed with argon2
    "password_hash" TEXT NOT NULL,
    "updated_password_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY("id")
);

COMMENT ON COLUMN "user_credentials"."password_hash" IS 'Should be hashed with argon2';
CREATE INDEX "user_credentials_index_0" ON "user_credentials" ("user_id");

CREATE TABLE IF NOT EXISTS "rich_text_objects" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "type" RTO_TYPE NOT NULL,
    -- the type determines which fields in content goes in.
    "content" JSONB,
    -- There are only 2^5 * 19 = 608 possibilities hence we use SMALLINT bitmask to represent the annotations.
    --
    -- The first 5 bits are for boolean flag for styles in the ff. order: `bold, italic, strikethrough, underline, code`. The next 5 bits are from colors starting from index 0 to 18.
    "annotation_mask" SMALLINT NOT NULL,
    "plain_text" TEXT NOT NULL,
    "href" TEXT,
    PRIMARY KEY("id")
);

COMMENT ON COLUMN "rich_text_objects"."content" IS 'the type determines which fields in content goes in.';
COMMENT ON COLUMN "rich_text_objects"."annotation_mask" IS 'There are only 2^5 * 19 = 608 possibilities hence we use SMALLINT bitmask to represent the annotations.

The first 5 bits are for boolean flag for styles in the ff. order: `bold, italic, strikethrough, underline, code`. The next 5 bits are from colors starting from index 0 to 18.';
CREATE INDEX "rich_text_objects_index_0" ON "rich_text_objects" ("type");

CREATE TABLE IF NOT EXISTS "files" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "type" FILE_TYPE NOT NULL,
    "url" TEXT,
    "expiry_time" TIMESTAMPTZ,
    "file_upload_id" UUID,
    PRIMARY KEY("id")
);

CREATE INDEX "files_index_0" ON "files" ("file_upload_id");

CREATE TABLE IF NOT EXISTS "file_uploads" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "expiry_time" TIMESTAMPTZ,
    "status" UPLOAD_STATUS NOT NULL,
    "filename" TEXT,
    "content_type" TEXT,
    "content_length" BIGINT,
    -- should only show up if status is pending.
    "upload_url" TEXT,
    "complete_url" TEXT,
    -- should only be here if status is `failed` or `uploaded`
    "file_import_result" TEXT,
    PRIMARY KEY("id")
);

COMMENT ON COLUMN "file_uploads"."upload_url" IS 'should only show up if status is pending.';
COMMENT ON COLUMN "file_uploads"."file_import_result" IS 'should only be here if status is `failed` or `uploaded`';

CREATE TABLE IF NOT EXISTS "parents" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "type" ID_TYPE NOT NULL,
    "database_id" UUID,
    "data_source_id" UUID,
    "page_id" UUID,
    "block_id" UUID,
    "workspace" BOOLEAN DEFAULT false,
    PRIMARY KEY("id")
);

CREATE INDEX idx_parents_db ON parents(database_id) WHERE database_id IS NOT NULL;
CREATE INDEX idx_parents_ds ON parents(data_source_id) WHERE data_source_id IS NOT NULL;
CREATE INDEX idx_parents_page ON parents(page_id) WHERE page_id IS NOT NULL;
CREATE INDEX idx_parents_block ON parents(block_id) WHERE block_id IS NOT NULL;

CREATE TABLE IF NOT EXISTS "data_source_properties" (
    -- I think this should be something with less bytes (ie. TEXT encoded with cuid)
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" DATA_SOURCE_TYPE NOT NULL,
    "metadata" JSONB,
    PRIMARY KEY("id")
);

COMMENT ON COLUMN "data_source_properties"."id" IS 'I think this should be something with less bytes (ie. TEXT encoded with cuid)';
CREATE INDEX "data_source_properties_index_0" ON "data_source_properties" ("type");

CREATE TABLE IF NOT EXISTS "entities" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    "archived" BOOLEAN NOT NULL,
    "is_trash" BOOLEAN NOT NULL,
    "parent" UUID NOT NULL,
    PRIMARY KEY("id")
);

CREATE INDEX "entities_index_0" ON "entities" ("created_by", "updated_by", "parent");

CREATE TABLE IF NOT EXISTS "comments" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "created_by" UUID NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_by" UUID NOT NULL,
    "parent" UUID NOT NULL,
    -- This is only used for grouping comments. Not used for linking to other tables.
    "discussion_id" UUID NOT NULL,
    PRIMARY KEY("id")
);

COMMENT ON COLUMN "comments"."discussion_id" IS 'This is only used for grouping comments. Not used for linking to other tables.';
CREATE INDEX "comments_index_0" ON "comments" ("created_by", "updated_by", "parent", "discussion_id");

CREATE TABLE IF NOT EXISTS "icons" (
    "id" UUID NOT NULL UNIQUE DEFAULT uuidv7(),
    "type" ICON_TYPE NOT NULL,
    "emoji" TEXT,
    "file" UUID,
    PRIMARY KEY("id")
);

CREATE INDEX "icons_index_0" ON "icons" ("type", "file");

CREATE TABLE IF NOT EXISTS "database_rich_text_links" (
    "database_id" UUID NOT NULL,
    "rich_text_id" UUID NOT NULL,
    "type" DATA_RTO_TYPE NOT NULL,
    "index_order" INTEGER NOT NULL,
    PRIMARY KEY("database_id", "rich_text_id", "type")
);

CREATE TABLE IF NOT EXISTS "data_source_rich_text_links" (
    "data_source_id" UUID NOT NULL,
    "rich_text_id" UUID NOT NULL,
    "type" DATA_RTO_TYPE NOT NULL,
    "index_order" INTEGER NOT NULL,
    PRIMARY KEY("data_source_id", "rich_text_id", "type")
);

CREATE TABLE IF NOT EXISTS "comment_rich_text_links" (
    "comment_id" UUID NOT NULL,
    "rich_text_id" UUID NOT NULL,
    "index_order" INTEGER NOT NULL,
    PRIMARY KEY("comment_id", "rich_text_id")
);

CREATE TABLE IF NOT EXISTS "comment_attachment_links" (
    "comment_id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "index_order" INTEGER NOT NULL,
    PRIMARY KEY("comment_id", "file_id")
);

-- Triggers for updated_at fields
CREATE TRIGGER tr_entities_updated BEFORE UPDATE ON "entities" FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER tr_comments_updated BEFORE UPDATE ON "comments" FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER tr_file_uploads_updated BEFORE UPDATE ON "file_uploads" FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Foreign Key Constraints with ON DELETE CASCADE where applicable
ALTER TABLE "user_credentials" ADD FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE;
ALTER TABLE "files" ADD FOREIGN KEY("file_upload_id") REFERENCES "file_uploads"("id") ON DELETE SET NULL;
ALTER TABLE "databases" ADD FOREIGN KEY("cover") REFERENCES "files"("id") ON DELETE SET NULL;
ALTER TABLE "databases" ADD FOREIGN KEY("icon") REFERENCES "icons"("id") ON DELETE SET NULL;
ALTER TABLE "databases" ADD FOREIGN KEY("entity_id") REFERENCES "entities"("id") ON DELETE CASCADE;

ALTER TABLE "parents" ADD FOREIGN KEY("database_id") REFERENCES "databases"("id") ON DELETE CASCADE;
ALTER TABLE "parents" ADD FOREIGN KEY("data_source_id") REFERENCES "data_sources"("id") ON DELETE CASCADE;
ALTER TABLE "parents" ADD FOREIGN KEY("page_id") REFERENCES "pages"("id") ON DELETE CASCADE;
ALTER TABLE "parents" ADD FOREIGN KEY("block_id") REFERENCES "blocks"("id") ON DELETE CASCADE;

ALTER TABLE "data_sources" ADD FOREIGN KEY("properties") REFERENCES "data_source_properties"("id") ON DELETE CASCADE;
ALTER TABLE "data_sources" ADD FOREIGN KEY("database_parent") REFERENCES "parents"("id") ON DELETE CASCADE;
ALTER TABLE "data_sources" ADD FOREIGN KEY("entity_id") REFERENCES "entities"("id") ON DELETE CASCADE;
ALTER TABLE "data_sources" ADD FOREIGN KEY("icon") REFERENCES "icons"("id") ON DELETE SET NULL;

ALTER TABLE "pages" ADD FOREIGN KEY("entity_id") REFERENCES "entities"("id") ON DELETE CASCADE;
ALTER TABLE "pages" ADD FOREIGN KEY("cover") REFERENCES "files"("id") ON DELETE SET NULL;
ALTER TABLE "pages" ADD FOREIGN KEY("icon") REFERENCES "icons"("id") ON DELETE SET NULL;

ALTER TABLE "entities" ADD FOREIGN KEY("created_by") REFERENCES "users"("id") ON DELETE RESTRICT;
ALTER TABLE "entities" ADD FOREIGN KEY("updated_by") REFERENCES "users"("id") ON DELETE RESTRICT;
ALTER TABLE "entities" ADD FOREIGN KEY("parent") REFERENCES "parents"("id") ON DELETE CASCADE;

ALTER TABLE "comments" ADD FOREIGN KEY("parent") REFERENCES "parents"("id") ON DELETE CASCADE;
ALTER TABLE "comments" ADD FOREIGN KEY("created_by") REFERENCES "users"("id") ON DELETE RESTRICT;
ALTER TABLE "comments" ADD FOREIGN KEY("updated_by") REFERENCES "users"("id") ON DELETE RESTRICT;

ALTER TABLE "database_rich_text_links" ADD FOREIGN KEY("database_id") REFERENCES "databases"("id") ON DELETE CASCADE;
ALTER TABLE "database_rich_text_links" ADD FOREIGN KEY("rich_text_id") REFERENCES "rich_text_objects"("id") ON DELETE CASCADE;

ALTER TABLE "data_source_rich_text_links" ADD FOREIGN KEY("data_source_id") REFERENCES "data_sources"("id") ON DELETE CASCADE;
ALTER TABLE "data_source_rich_text_links" ADD FOREIGN KEY("rich_text_id") REFERENCES "rich_text_objects"("id") ON DELETE CASCADE;

ALTER TABLE "comment_rich_text_links" ADD FOREIGN KEY("comment_id") REFERENCES "comments"("id") ON DELETE CASCADE;
ALTER TABLE "comment_rich_text_links" ADD FOREIGN KEY("rich_text_id") REFERENCES "rich_text_objects"("id") ON DELETE CASCADE;

ALTER TABLE "comment_attachment_links" ADD FOREIGN KEY("comment_id") REFERENCES "comments"("id") ON DELETE CASCADE;
ALTER TABLE "comment_attachment_links" ADD FOREIGN KEY("file_id") REFERENCES "files"("id") ON DELETE CASCADE;
