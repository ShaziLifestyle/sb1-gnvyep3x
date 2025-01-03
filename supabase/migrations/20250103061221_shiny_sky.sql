/*
  # Fix Form Types

  1. Changes
    - Update form_type for existing forms to ensure correct types are set
    - Add RLS policies for public access to meta forms and widgets
*/

-- Update form types
UPDATE meta_forms
SET form_type = 'Main'
WHERE name = 'Agents Form';

UPDATE meta_forms
SET form_type = 'Sub Form'
WHERE name IN ('Tasks Form', 'Prompts Form');

-- Add public access policies for meta forms
CREATE POLICY "Allow public read access to meta forms"
  ON meta_forms FOR SELECT
  TO public
  USING (true);

-- Add public access policies for meta widgets
CREATE POLICY "Allow public read access to meta widgets"
  ON meta_widgets FOR SELECT
  TO public
  USING (true);