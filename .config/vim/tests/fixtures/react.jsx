import React from 'react';
// JSX combines JavaScript expressions and HTML-like tags.
export default function Greeting({name = 'Drupal'}) {
  return <section className="greeting"><h1>Hello {name}</h1></section>;
}
