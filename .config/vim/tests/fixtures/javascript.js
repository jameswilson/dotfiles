// Comments, strings, regular expressions, and template literals.
const settings = {drupal: true, entity_reference_revisions: 42};
export async function greeting(name = 'Drupal') {
  const pattern = /entity_[a-z]+/gi;
  return `${name}: ${pattern.test('entity_reference') && settings.drupal}`;
}
