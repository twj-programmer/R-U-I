-- D2-BIZ-01 private test fixture. Public create_tables.sql remains owned by D2-QA-01.
ALTER TABLE crm_business ADD COLUMN IF NOT EXISTS lose_reason_code VARCHAR(64);
ALTER TABLE crm_business ADD COLUMN IF NOT EXISTS version INT NOT NULL DEFAULT 0;
