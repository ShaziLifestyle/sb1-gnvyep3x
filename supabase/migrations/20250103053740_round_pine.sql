/*
  # Meta Tables Schema

  1. New Tables
    - `meta_forms`: Stores form metadata and navigation logic
    - `meta_widgets`: Stores widget configurations
    - `meta_table_relationships`: Defines table relationships
  2. Security
    - Enables RLS on all tables
  3. Indexes
    - Adds index on meta_widgets.form_id
*/

-- Safe enum creation
DO $$ BEGIN
  CREATE TYPE widget_type AS ENUM (
    'text',
    'textarea',
    'number',
    'dropdown',
    'checkbox',
    'radio',
    'date',
    'time',
    'datetime',
    'file'
  );
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
  CREATE TYPE relationship_type AS ENUM (
    'one_to_one',
    'one_to_many',
    'many_to_many'
  );
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Create meta_forms table
CREATE TABLE IF NOT EXISTS meta_forms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  navigation_logic jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  CONSTRAINT meta_forms_name_unique UNIQUE (name)
);

-- Create meta_widgets table
CREATE TABLE IF NOT EXISTS meta_widgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  form_id uuid REFERENCES meta_forms(id) ON DELETE CASCADE,
  name text NOT NULL,
  type widget_type NOT NULL,
  size text,
  default_value jsonb,
  is_required boolean DEFAULT false,
  "order" integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  CONSTRAINT meta_widgets_form_order_unique UNIQUE (form_id, "order")
);

-- Create meta_table_relationships table
CREATE TABLE IF NOT EXISTS meta_table_relationships (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_table text NOT NULL,
  child_table text NOT NULL,
  relationship_type relationship_type NOT NULL,
  on_click_action jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  CONSTRAINT meta_table_relationships_unique UNIQUE (parent_table, child_table)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_meta_widgets_form_id ON meta_widgets(form_id);

-- Enable RLS
ALTER TABLE meta_forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE meta_widgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE meta_table_relationships ENABLE ROW LEVEL SECURITY;