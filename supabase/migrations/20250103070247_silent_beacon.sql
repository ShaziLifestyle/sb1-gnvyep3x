-- Add public read access policy for meta_table_relationships table
CREATE POLICY "Allow public read access to meta_table_relationships"
  ON meta_table_relationships FOR SELECT
  TO public
  USING (true);