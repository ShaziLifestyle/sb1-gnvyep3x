import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { MetaForm, MetaWidget } from '../types/form';

export function useMetaForm(formNumber: number = 1) {
  const [form, setForm] = useState<MetaForm | null>(null);
  const [widgets, setWidgets] = useState<MetaWidget[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchFormData() {
      try {
        console.log('Fetching form data for number:', formNumber);
        
        const { data: formData, error: formError } = await supabase
          .from('meta_forms')
          .select('*')
          .eq('form_number', formNumber)
          .single();

        if (formError) throw formError;
        console.log('Form data:', formData);
        setForm(formData);

        const { data: widgetData, error: widgetError } = await supabase
          .from('meta_widgets')
          .select('*')
          .eq('form_id', formData.id)
          .order('order');

        if (widgetError) throw widgetError;
        console.log('Widget data:', widgetData);
        setWidgets(widgetData || []);
      } catch (err) {
        console.error('Error in useMetaForm:', err);
        setError(err instanceof Error ? err.message : 'An error occurred');
      } finally {
        setLoading(false);
      }
    }

    fetchFormData();
  }, [formNumber]);

  return { form, widgets, loading, error };
}