/*
  # Add Form Type to Meta Forms Table
  
  1. Changes
    - Adds form_type enum type for Main/Sub Form classification
    - Adds form_type column to meta_forms table
    - Sets default form_type to 'Main'
  
  2. Purpose
    - Supports hierarchical form navigation
    - Enables parent-child form relationships
    - Helps organize forms like Agents -> Tasks -> Prompts
*/

-- Create form type enum
DO $$ BEGIN
  CREATE TYPE form_type AS ENUM ('Main', 'Sub Form');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Add form_type column to meta_forms
DO $$ BEGIN
  ALTER TABLE meta_forms 
    ADD COLUMN form_type form_type NOT NULL DEFAULT 'Main';
EXCEPTION
  WHEN duplicate_column THEN null;
END $$;