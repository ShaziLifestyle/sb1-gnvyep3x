import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export function useChildTables(formNumber: number) {
  const [childTables, setChildTables] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchChildTables() {
      try {
        const { data, error } = await supabase
          .from('meta_table_relationships')
          .select('child_table')
          .eq('form_number', formNumber);

        if (error) throw error;
        
        const tables = data?.map(item => item.child_table) || [];
        setChildTables(tables);
      } catch (err) {
        console.error('Error fetching child tables:', err);
        setError(err instanceof Error ? err.message : 'An error occurred');
      } finally {
        setLoading(false);
      }
    }

    fetchChildTables();
  }, [formNumber]);

  return { childTables, loading, error };
}