/*
  # Add form number to table relationships

  1. Changes
    - Add form_number column to meta_table_relationships
    - Update existing records based on target_form references
    - Make form_number NOT NULL
*/

-- Add form_number column
ALTER TABLE meta_table_relationships ADD COLUMN IF NOT EXISTS form_number integer;

-- Update form numbers based on target forms
UPDATE meta_table_relationships
SET form_number = CASE
  WHEN (on_click_action->>'target_form') = 'Tasks Form' THEN 2
  WHEN (on_click_action->>'target_form') = 'Prompts Form' THEN 3
  ELSE 1
END;

-- Make form_number NOT NULL
ALTER TABLE meta_table_relationships ALTER COLUMN form_number SET NOT NULL;