/*
  # Update form type to form number

  1. Changes
    - Add form_number column to meta_forms
    - Update existing records with form numbers
    - Drop form_type column and enum
  
  2. Data Migration
    - 'Main' forms become form_number = 1
    - 'Sub Form' forms get incremental numbers
*/

-- Add form_number column
ALTER TABLE meta_forms ADD COLUMN IF NOT EXISTS form_number integer;

-- Update existing records
UPDATE meta_forms
SET form_number = CASE 
  WHEN form_type = 'Main' THEN 1
  ELSE ROW_NUMBER() OVER (
    PARTITION BY CASE WHEN form_type = 'Sub Form' THEN 1 ELSE 0 END 
    ORDER BY created_at
  ) + 1
END;

-- Make form_number NOT NULL
ALTER TABLE meta_forms ALTER COLUMN form_number SET NOT NULL;

-- Drop form_type column and enum
ALTER TABLE meta_forms DROP COLUMN form_type;
DROP TYPE IF EXISTS form_type;