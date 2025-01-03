import React from 'react';
import { PlusCircle } from 'lucide-react';
import { AgentCard } from './AgentCard';
import type { MetaWidget } from '../types/form';

interface DynamicFormProps {
  title: string;
  description: string;
  widgets: MetaWidget[];
  data: Record<string, any>[];
  formNumber: number;
  onRowClick?: (row: Record<string, any>) => void;
  onAdd: () => void;
  onEdit: (agent: Record<string, any>) => void;
  onDelete: (agent: Record<string, any>) => void;
  onTableSelect: (table: string) => void;
}

export function DynamicForm({ 
  title, 
  description, 
  widgets, 
  data,
  formNumber,
  onRowClick,
  onAdd,
  onEdit,
  onDelete,
  onTableSelect
}: DynamicFormProps) {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">{title}</h1>
          <p className="text-gray-600">{description}</p>
        </div>
        <button
          onClick={onAdd}
          className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
        >
          <PlusCircle className="w-5 h-5" />
          Add New
        </button>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {data.map((row) => (
          <AgentCard
            key={row.id}
            agent={row}
            widgets={widgets}
            formNumber={formNumber}
            onClick={() => onRowClick?.(row)}
            onAdd={onAdd}
            onEdit={() => onEdit(row)}
            onDelete={() => onDelete(row)}
            onTableSelect={onTableSelect}
          />
        ))}
      </div>
      
      {data.length === 0 && (
        <div className="text-center py-12">
          <p className="text-gray-500">No records found</p>
        </div>
      )}
    </div>
  );
}