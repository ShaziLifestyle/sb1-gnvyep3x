/*
  # Insert Sample Data with Dynamic UUIDs
  
  1. Sample Data Overview
    - Creates 2 AI agents with different roles
    - Adds multiple tasks for each agent
    - Creates prompts for each task
  
  2. Implementation Details
    - Uses gen_random_uuid() for all IDs
    - Uses WITH clause for referential integrity
*/

WITH inserted_agents AS (
  INSERT INTO agents (name, description, role, goal, backstory)
  VALUES
    (
      'Research Assistant',
      'AI assistant specialized in academic research',
      'Research Specialist',
      'Help users conduct thorough academic research',
      'Trained on academic papers and research methodologies'
    ),
    (
      'Content Creator',
      'Creative AI for content generation',
      'Content Specialist',
      'Generate engaging and original content',
      'Experienced in various content formats and styles'
    )
  RETURNING id, name
),
inserted_tasks AS (
  INSERT INTO tasks (agent_id, name, description)
  SELECT 
    a.id,
    t.name,
    t.description
  FROM inserted_agents a
  CROSS JOIN (
    VALUES 
      ('Literature Review', 'Conduct comprehensive literature review on specified topic'),
      ('Data Analysis', 'Analyze research data and provide insights')
    ) t(name, description)
  WHERE a.name = 'Research Assistant'
  UNION ALL
  SELECT 
    a.id,
    t.name,
    t.description
  FROM inserted_agents a
  CROSS JOIN (
    VALUES 
      ('Blog Writing', 'Create engaging blog posts on various topics'),
      ('Social Media Content', 'Generate social media posts and captions')
    ) t(name, description)
  WHERE a.name = 'Content Creator'
  RETURNING id, name
)
INSERT INTO prompts (task_id, name, description, role, goal, backstory)
SELECT 
  t.id,
  p.name,
  p.description,
  p.role,
  p.goal,
  p.backstory
FROM inserted_tasks t
CROSS JOIN (
  VALUES 
    (
      'Initial Research',
      'Gather and analyze primary sources',
      'Research Assistant',
      'Find relevant academic papers',
      'Specialized in academic database search'
    ),
    (
      'Statistical Analysis',
      'Perform statistical tests on research data',
      'Data Analyst',
      'Extract meaningful insights from data',
      'Expert in statistical methods'
    ),
    (
      'Tech Blog Post',
      'Write engaging tech-focused blog post',
      'Tech Writer',
      'Create informative content',
      'Experience in technical writing'
    ),
    (
      'Twitter Thread',
      'Create viral Twitter thread',
      'Social Media Expert',
      'Maximize engagement',
      'Skilled in social media optimization'
    )
) p(name, description, role, goal, backstory)
WHERE 
  (t.name IN ('Literature Review', 'Data Analysis') AND p.name IN ('Initial Research', 'Statistical Analysis'))
  OR
  (t.name IN ('Blog Writing', 'Social Media Content') AND p.name IN ('Tech Blog Post', 'Twitter Thread'));