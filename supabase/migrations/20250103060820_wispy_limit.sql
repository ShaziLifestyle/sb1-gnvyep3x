/*
  # Update Form Metadata

  1. Changes
    - Safely insert forms if they don't exist
    - Add widgets for each form
    - Set up table relationships
*/

-- Create Forms safely
WITH forms AS (
  INSERT INTO meta_forms (name, description, form_type)
  SELECT name, description, form_type
  FROM (
    VALUES
      ('Agents Form', 'Main form for managing AI agents and their properties', 'Main'::form_type),
      ('Tasks Form', 'Sub form for managing tasks associated with agents', 'Sub Form'::form_type),
      ('Prompts Form', 'Sub form for managing prompts associated with tasks', 'Sub Form'::form_type)
  ) AS new_forms(name, description, form_type)
  WHERE NOT EXISTS (
    SELECT 1 FROM meta_forms WHERE name = new_forms.name
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

-- Create Table Relationships safely
INSERT INTO meta_table_relationships (parent_table, child_table, relationship_type, on_click_action)
SELECT parent_table, child_table, relationship_type, on_click_action
FROM (
  VALUES
    (
      'agents',
      'tasks',
      'one_to_many'::relationship_type,
      '{"action": "navigate", "target_form": "Tasks Form", "filter": {"agent_id": "parent.id"}}'::jsonb
    ),
    (
      'tasks',
      'prompts',
      'one_to_many'::relationship_type,
      '{"action": "navigate", "target_form": "Prompts Form", "filter": {"task_id": "parent.id"}}'::jsonb
    )
) AS new_relationships(parent_table, child_table, relationship_type, on_click_action)
WHERE NOT EXISTS (
  SELECT 1 FROM meta_table_relationships 
  WHERE parent_table = new_relationships.parent_table 
  AND child_table = new_relationships.child_table
);