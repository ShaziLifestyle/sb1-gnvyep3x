import React, { useState } from 'react';
import { useMetaForm } from '../hooks/useMetaForm';
import { useFormData } from '../hooks/useFormData';
import { useAgents } from '../hooks/useAgents';
import { DynamicForm } from './DynamicForm';
import { LoadingSpinner } from './LoadingSpinner';
import { ErrorMessage } from './ErrorMessage';
import { Modal } from './Modal';
import { AgentForm } from './AgentForm';

interface FormContainerProps {
  table?: string;
  filter?: Record<string, any>;
}

export function FormContainer({ table, filter }: FormContainerProps) {
  const { form, widgets, loading: metaLoading, error: metaError } = useMetaForm('Main');
  const { data, loading: dataLoading, error: dataError } = useFormData(form?.name || null, filter);
  const { addAgent, updateAgent, deleteAgent, loading: agentLoading } = useAgents();
  
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedAgent, setSelectedAgent] = useState<Record<string, any> | null>(null);

  const handleAdd = () => {
    setSelectedAgent(null);
    setIsModalOpen(true);
  };

  const handleEdit = (agent: Record<string, any>) => {
    setSelectedAgent(agent);
    setIsModalOpen(true);
  };

  const handleDelete = async (agent: Record<string, any>) => {
    if (!confirm('Are you sure you want to delete this agent?')) return;
    
    const success = await deleteAgent(agent.id);
    if (success) {
      window.location.reload(); // Refresh to show updated data
    }
  };

  const handleSubmit = async (formData: Record<string, any>) => {
    let success;
    
    if (selectedAgent) {
      success = await updateAgent(selectedAgent.id, formData);
    } else {
      success = await addAgent(formData);
    }
    
    if (success) {
      setIsModalOpen(false);
      window.location.reload(); // Refresh to show updated data
    }
  };

  if (metaLoading || dataLoading || agentLoading) {
    return <LoadingSpinner />;
  }

  if (metaError || dataError) {
    return <ErrorMessage message={metaError || dataError || 'An error occurred'} />;
  }

  if (!form || !widgets) {
    return <ErrorMessage message="No form configuration found" />;
  }

  return (
    <>
      <DynamicForm
        title={form.name}
        description={form.description}
        widgets={widgets}
        data={data}
        onAdd={handleAdd}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />
      
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={selectedAgent ? 'Edit Agent' : 'Add New Agent'}
      >
        <AgentForm
          widgets={widgets}
          initialData={selectedAgent || {}}
          onSubmit={handleSubmit}
          onCancel={() => setIsModalOpen(false)}
        />
      </Modal>
    </>
  );
}