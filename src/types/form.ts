export interface MetaForm {
  id: string;
  name: string;
  description: string;
  form_number: number;
  navigation_logic?: Record<string, any>;
}

export interface MetaWidget {
  id: string;
  form_id: string;
  name: string;
  type: 'text' | 'textarea' | 'number' | 'dropdown' | 'checkbox' | 'radio' | 'date' | 'time' | 'datetime' | 'file';
  is_required: boolean;
  order: number;
}

export interface TableRelationship {
  id: string;
  parent_table: string;
  child_table: string;
  relationship_type: 'one_to_one' | 'one_to_many' | 'many_to_many';
  on_click_action: {
    action: string;
    target_form: string;
    filter: Record<string, any>;
  };
}