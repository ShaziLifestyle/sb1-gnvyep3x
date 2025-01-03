import React from 'react';
import { FormContainer } from './components/FormContainer';
import { Navigation } from './components/Navigation';

export default function App() {
  // Get form number from URL query parameter
  const searchParams = new URLSearchParams(window.location.search);
  const formNumber = parseInt(searchParams.get('form') || '1', 10);

  return (
    <div className="min-h-screen bg-gray-100">
      <Navigation formNumber={formNumber} />
      <FormContainer formNumber={formNumber} />
    </div>
  );
}