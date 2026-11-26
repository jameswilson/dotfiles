interface EntityReference { id: number; label: string; }
type Result<T> = {value: T; enabled: boolean};
// Generic types, optional parameters, and template strings.
export function label(entity: EntityReference, prefix?: string): Result<string> {
  return {value: `${prefix ?? 'Drupal'}: ${entity.label}`, enabled: true};
}
