import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export function useFormData(formName: string | null, filter?: Record<string, any>) {
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      try {
        if (!formName) {
          setData([]);
          return;
        }

        // Get the table name from meta_forms
        const { data: formData } = await supabase
          .from('meta_forms')
          .select('name')
          .eq('name', formName)
          .single();

        if (!formData) {
          throw new Error('Form not found');
        }

        // Convert form name to table name (e.g., "Agents Form" -> "agents")
        const tableName = formData.name.split(' ')[0].toLowerCase();
        
        let query = supabase.from(tableName).select('*');
        
        if (filter) {
          Object.entries(filter).forEach(([key, value]) => {
            query = query.eq(key, value);
          });
        }

        const { data: result, error: dataError } = await query;
        
        if (dataError) throw dataError;
        setData(result || []);
      } catch (err) {
        console.error('Error fetching data:', err);
        setError(err instanceof Error ? err.message : 'An error occurred');
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, [formName, JSON.stringify(filter)]);

  return { data, loading, error };
}