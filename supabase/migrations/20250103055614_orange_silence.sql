/*
  # Automatic Updated At Timestamps
  
  Creates triggers to automatically update the updated_at column whenever a row is modified.
  
  1. Function
    - Creates/updates the trigger function for timestamp updates
  
  2. Triggers
    - Safely creates triggers for all tables after removing any existing ones
    - Applies to: meta_forms, meta_widgets, meta_table_relationships, agents, tasks, prompts
*/

-- Drop existing triggers
DROP TRIGGER IF EXISTS update_meta_forms_updated_at ON meta_forms;
DROP TRIGGER IF EXISTS update_meta_widgets_updated_at ON meta_widgets;
DROP TRIGGER IF EXISTS update_meta_table_relationships_updated_at ON meta_table_relationships;
DROP TRIGGER IF EXISTS update_agents_updated_at ON agents;
DROP TRIGGER IF EXISTS update_tasks_updated_at ON tasks;
DROP TRIGGER IF EXISTS update_prompts_updated_at ON prompts;

-- Create or replace trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers
CREATE TRIGGER update_meta_forms_updated_at
  BEFORE UPDATE ON meta_forms
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meta_widgets_updated_at
  BEFORE UPDATE ON meta_widgets
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meta_table_relationships_updated_at
  BEFORE UPDATE ON meta_table_relationships
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agents_updated_at
  BEFORE UPDATE ON agents
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_prompts_updated_at
  BEFORE UPDATE ON prompts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();