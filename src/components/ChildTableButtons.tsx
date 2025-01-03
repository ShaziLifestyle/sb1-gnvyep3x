import React from 'react';
import { useChildTables } from '../hooks/useChildTables';
import { ChevronRight } from 'lucide-react';

interface ChildTableButtonsProps {
  formNumber: number;
  onTableSelect: (table: string) => void;
}

export function ChildTableButtons({ formNumber, onTableSelect }: ChildTableButtonsProps) {
  const { childTables, loading, error } = useChildTables(formNumber);

  if (loading || error || !childTables?.length) return null;

  return (
    <div className="flex gap-2 mt-4 border-t pt-4">
      {childTables.map((table) => (
        <button
          key={table}
          onClick={() => onTableSelect(table)}
          className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-blue-600 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors"
        >
          View {table.replace('_', ' ')}
          <ChevronRight className="w-4 h-4" />
        </button>
      ))}
    </div>
  );
}