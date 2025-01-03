/*
  # Row Level Security Policies

  1. Meta Forms Policies
    - View: Users can view their own forms
    - Create: Users can create their own forms
    - Update: Users can update their own forms
    - Delete: Users can delete their own forms
  
  2. Meta Widgets Policies
    - View: Users can view widgets of their forms
    - Create: Users can create widgets for their forms
    - Update: Users can update widgets of their forms
    - Delete: Users can delete widgets of their forms
*/

-- Drop existing policies if they exist
DO $$ BEGIN
  -- Meta Forms policies
  DROP POLICY IF EXISTS "Users can view their own forms" ON meta_forms;
  DROP POLICY IF EXISTS "Users can create their own forms" ON meta_forms;
  DROP POLICY IF EXISTS "Users can update their own forms" ON meta_forms;
  DROP POLICY IF EXISTS "Users can delete their own forms" ON meta_forms;
  
  -- Meta Widgets policies
  DROP POLICY IF EXISTS "Users can view widgets of their forms" ON meta_widgets;
  DROP POLICY IF EXISTS "Users can create widgets for their forms" ON meta_widgets;
  DROP POLICY IF EXISTS "Users can update widgets of their forms" ON meta_widgets;
  DROP POLICY IF EXISTS "Users can delete widgets of their forms" ON meta_widgets;
END $$;

-- Meta Forms Policies
CREATE POLICY "Users can view their own forms"
  ON meta_forms FOR SELECT
  TO authenticated
  USING (auth.uid() = created_by);

CREATE POLICY "Users can create their own forms"
  ON meta_forms FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update their own forms"
  ON meta_forms FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can delete their own forms"
  ON meta_forms FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);

-- Meta Widgets Policies
CREATE POLICY "Users can view widgets of their forms"
  ON meta_widgets FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM meta_forms
    WHERE meta_forms.id = meta_widgets.form_id
    AND meta_forms.created_by = auth.uid()
  ));

CREATE POLICY "Users can create widgets for their forms"
  ON meta_widgets FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM meta_forms
    WHERE meta_forms.id = meta_widgets.form_id
    AND meta_forms.created_by = auth.uid()
  ));

CREATE POLICY "Users can update widgets of their forms"
  ON meta_widgets FOR UPDATE
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM meta_forms
    WHERE meta_forms.id = meta_widgets.form_id
    AND meta_forms.created_by = auth.uid()
  ));

CREATE POLICY "Users can delete widgets of their forms"
  ON meta_widgets FOR DELETE
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM meta_forms
    WHERE meta_forms.id = meta_widgets.form_id
    AND meta_forms.created_by = auth.uid()
  ));