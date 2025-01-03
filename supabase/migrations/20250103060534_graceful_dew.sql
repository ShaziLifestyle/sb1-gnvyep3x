/*
  # Create Form Metadata Structure
  
  1. Forms
    - Agents (Main form)
    - Tasks (Sub form)
    - Prompts (Sub form)
  
  2. Widgets for each form
  3. Table relationships
*/

-- Create Forms
WITH forms AS (
  INSERT INTO meta_forms (name, description, form_type)
  VALUES
    (
      'Agents Form',
      'Main form for managing AI agents and their properties',
      'Main'
    ),
    (
      'Tasks Form',
      'Sub form for managing tasks associated with agents',
      'Sub Form'
    ),
    (
      'Prompts Form',
      'Sub form for managing prompts associated with tasks',
      'Sub Form'
    )
  RETURNING id, name
)
-- Create Widgets for each form
INSERT INTO meta_widgets (form_id, name, type, is_required, "order")
SELECT 
  f.id,
  w.widget_name,
  w.widget_type::widget_type,
  w.required,
  w.sort_order
FROM forms f
CROSS JOIN (
  VALUES 
    -- Agents Form Widgets
    ('name', 'text', true, 1),
    ('description', 'textarea', false, 2),
    ('role', 'text', true, 3),
    ('goal', 'textarea', true, 4),
    ('backstory', 'textarea', false, 5)
) w(widget_name, widget_type, required, sort_order)
WHERE f.name = 'Agents Form'
UNION ALL
SELECT 
  f.id,
  w.widget_name,
  w.widget_type::widget_type,
  w.required,
  w.sort_order
FROM forms f
CROSS JOIN (
  VALUES 
    -- Tasks Form Widgets
    ('name', 'text', true, 1),
    ('description', 'textarea', false, 2)
) w(widget_name, widget_type, required, sort_order)
WHERE f.name = 'Tasks Form'
UNION ALL
SELECT 
  f.id,
  w.widget_name,
  w.widget_type::widget_type,
  w.required,
  w.sort_order
FROM forms f
CROSS JOIN (
  VALUES 
    -- Prompts Form Widgets
    ('name', 'text', true, 1),
    ('description', 'textarea', false, 2),
    ('role', 'text', true, 3),
    ('goal', 'textarea', true, 4),
    ('backstory', 'textarea', false, 5)
) w(widget_name, widget_type, required, sort_order)
WHERE f.name = 'Prompts Form';

-- Create Table Relationships
INSERT INTO meta_table_relationships (parent_table, child_table, relationship_type, on_click_action)
VALUES
  (
    'agents',
    'tasks',
    'one_to_many',
    '{"action": "navigate", "target_form": "Tasks Form", "filter": {"agent_id": "parent.id"}}'
  ),
  (
    'tasks',
    'prompts',
    'one_to_many',
    '{"action": "navigate", "target_form": "Prompts Form", "filter": {"task_id": "parent.id"}}'
  );