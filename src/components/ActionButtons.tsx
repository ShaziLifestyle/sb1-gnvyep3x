import { PlusCircle, Pencil, Trash2 } from 'lucide-react';

interface ActionButtonsProps {
  onAdd: () => void;
  onEdit: () => void;
  onDelete: () => void;
}

export function ActionButtons({ onAdd, onEdit, onDelete }: ActionButtonsProps) {
  return (
    <div className="flex gap-2">
      <button
        onClick={onAdd}
        className="p-2 text-green-600 hover:bg-green-50 rounded-full transition-colors"
        title="Add new agent"
      >
        <PlusCircle className="w-5 h-5" />
      </button>
      <button
        onClick={onEdit}
        className="p-2 text-blue-600 hover:bg-blue-50 rounded-full transition-colors"
        title="Edit agent"
      >
        <Pencil className="w-5 h-5" />
      </button>
      <button
        onClick={onDelete}
        className="p-2 text-red-600 hover:bg-red-50 rounded-full transition-colors"
        title="Delete agent"
      >
        <Trash2 className="w-5 h-5" />
      </button>
    </div>
  );
}