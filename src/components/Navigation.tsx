import React from 'react';
import { Home, ArrowLeft } from 'lucide-react';

interface NavigationProps {
  formNumber: number;
}

export function Navigation({ formNumber }: NavigationProps) {
  const canGoBack = formNumber > 1;
  
  const handleBack = () => {
    const prevFormNumber = formNumber - 1;
    window.location.href = `?form=${prevFormNumber}`;
  };

  const handleHome = () => {
    window.location.href = '?form=1';
  };

  return (
    <div className="bg-white shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-4">
            {canGoBack && (
              <button
                onClick={handleBack}
                className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-full transition-colors"
                title="Go back"
              >
                <ArrowLeft className="w-5 h-5" />
              </button>
            )}
            <button
              onClick={handleHome}
              className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-full transition-colors"
              title="Go to home"
            >
              <Home className="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}