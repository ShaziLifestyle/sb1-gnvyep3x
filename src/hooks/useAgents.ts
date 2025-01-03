import { useState } from 'react';
import { supabase } from '../lib/supabase';

interface Agent {
  id?: string;
  name: string;
  description?: string;
  role: string;
  goal: string;
  backstory?: string;
}

export function useAgents() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const addAgent = async (agent: Omit<Agent, 'id'>) => {
    try {
      setLoading(true);
      const { error } = await supabase
        .from('agents')
        .insert([agent]);
      
      if (error) throw error;
      return true;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to add agent');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const updateAgent = async (id: string, agent: Partial<Agent>) => {
    try {
      setLoading(true);
      const { error } = await supabase
        .from('agents')
        .update(agent)
        .eq('id', id);
      
      if (error) throw error;
      return true;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update agent');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const deleteAgent = async (id: string) => {
    try {
      setLoading(true);
      const { error } = await supabase
        .from('agents')
        .delete()
        .eq('id', id);
      
      if (error) throw error;
      return true;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to delete agent');
      return false;
    } finally {
      setLoading(false);
    }
  };

  return {
    loading,
    error,
    addAgent,
    updateAgent,
    deleteAgent
  };
}