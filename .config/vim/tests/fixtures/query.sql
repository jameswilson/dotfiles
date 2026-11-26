-- SQL identifiers, strings, joins, and numeric conditions.
SELECT n.id, n.title, 'Drupal' AS application
FROM node_field_data AS n
LEFT JOIN node__field_reference AS r ON r.entity_id = n.id
WHERE n.status = 1 AND n.title IS NOT NULL
ORDER BY n.id DESC;
