import React from 'react';
interface Props { name: string; count?: number; }
export function Greeting({name, count = 42}: Props) {
  return <div data-count={count}><strong>Hello {name}</strong></div>;
}
