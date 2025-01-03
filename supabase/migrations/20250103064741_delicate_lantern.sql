/*
  # Update form type to form number

  1. Changes
    - Add form_number column
    - Update existing records using a more compatible approach
    - Make form_number NOT NULL
    - Drop form_type column and enum
*/

-- Add form_number column
ALTER TABLE meta_forms ADD COLUMN IF NOT EXISTS form_number integer;

-- Update Main forms to number 1
UPDATE meta_forms
SET form_number = 1
WHERE form_type = 'Main';

-- Create a temporary sequence for Sub Forms
DO $$
DECLARE
    r RECORD;
    counter INTEGER := 2;
BEGIN
    FOR r IN (SELECT id FROM meta_forms WHERE form_type = 'Sub Form' ORDER BY created_at)
    LOOP
        UPDATE meta_forms 
        SET form_number = counter 
        WHERE id = r.id;
        counter := counter + 1;
    END LOOP;
END $$;

-- Make form_number NOT NULL
ALTER TABLE meta_forms ALTER COLUMN form_number SET NOT NULL;

-- Drop form_type column and enum
ALTER TABLE meta_forms DROP COLUMN form_type;
DROP TYPE IF EXISTS form_type;