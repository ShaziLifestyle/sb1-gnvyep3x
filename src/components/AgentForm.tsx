import React from 'react';
import type { MetaWidget } from '../types/form';

interface AgentFormProps {
  widgets: MetaWidget[];
  initialData?: Record<string, any>;
  onSubmit: (data: Record<string, any>) => void;
  onCancel: () => void;
}

export function AgentForm({ widgets, initialData, onSubmit, onCancel }: AgentFormProps) {
  const [formData, setFormData] = React.useState(initialData || {});

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(formData);
  };

  const handleChange = (name: string, value: string) => {
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {widgets.map((widget) => (
        <div key={widget.id}>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            {widget.name}
            {widget.is_required && <span className="text-red-500 ml-1">*</span>}
          </label>
          {widget.type === 'textarea' ? (
            <textarea
              required={widget.is_required}
              value={formData[widget.name] || ''}
              onChange={(e) => handleChange(widget.name, e.target.value)}
              className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              rows={4}
            />
          ) : (
            <input
              type="text"
              required={widget.is_required}
              value={formData[widget.name] || ''}
              onChange={(e) => handleChange(widget.name, e.target.value)}
              className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            />
          )}
        </div>
      ))}
      
      <div className="flex justify-end gap-3 pt-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
        >
          Cancel
        </button>
        <button
          type="submit"
          className="px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700"
        >
          Save
        </button>
      </div>
    </form>
  );
}