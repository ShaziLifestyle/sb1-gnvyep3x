import React from 'react';
import { User } from 'lucide-react';
import type { MetaWidget } from '../types/form';
import { ActionButtons } from './ActionButtons';

interface AgentCardProps {
  agent: Record<string, any>;
  widgets: MetaWidget[];
  onAdd: () => void;
  onEdit: () => void;
  onDelete: () => void;
  onClick?: () => void;
}

export function AgentCard({ agent, widgets, onAdd, onEdit, onDelete, onClick }: AgentCardProps) {
  const getWidgetValue = (widget: MetaWidget) => {
    const value = agent[widget.name];
    if (widget.type === 'textarea') {
      return value?.length > 150 ? `${value.slice(0, 150)}...` : value;
    }
    return value;
  };

  const handleAction = (e: React.MouseEvent, action: () => void) => {
    e.stopPropagation();
    action();
  };

  return (
    <div 
      className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200 cursor-pointer"
      onClick={onClick}
    >
      <div className="p-6">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-4">
            <div className="bg-blue-100 p-3 rounded-full">
              <User className="w-6 h-6 text-blue-600" />
            </div>
            <div>
              <h3 className="text-xl font-semibold text-gray-900">
                {agent.name}
              </h3>
              <p className="text-sm text-gray-500">{agent.role}</p>
            </div>
          </div>
          <div onClick={(e) => e.stopPropagation()}>
            <ActionButtons
              onAdd={() => handleAction(event as React.MouseEvent, onAdd)}
              onEdit={() => handleAction(event as React.MouseEvent, onEdit)}
              onDelete={() => handleAction(event as React.MouseEvent, onDelete)}
            />
          </div>
        </div>

        {widgets.map((widget) => {
          if (widget.name === 'name' || widget.name === 'role') return null;
          const value = getWidgetValue(widget);
          if (!value) return null;

          return (
            <div key={widget.id} className="mb-3">
              <h4 className="text-sm font-medium text-gray-700 mb-1 capitalize">
                {widget.name}
              </h4>
              <p className="text-gray-600 text-sm">
                {value}
              </p>
            </div>
          );
        })}
      </div>
    </div>
  );
}