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

        console.log('Fetching data for form:', formName);
        const tableName = formName.split(' ')[0].toLowerCase();
        console.log('Table name:', tableName);
        
        let query = supabase.from(tableName).select('*');
        
        if (filter) {
          Object.entries(filter).forEach(([key, value]) => {
            query = query.eq(key, value);
          });
        }

        const { data: result, error: dataError } = await query;
        
        if (dataError) throw dataError;
        console.log('Fetched data:', result);
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