/*
  # Add public read access to agents table

  1. Security Changes
    - Add policy to allow public read access to agents table
*/

-- Add public read access policy for agents table
CREATE POLICY "Allow public read access to agents"
  ON agents FOR SELECT
  TO public
  USING (true);