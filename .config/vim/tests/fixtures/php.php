<?php
/** Render Drupal vocabulary without English spelling backgrounds. */
namespace Drupal\syntax_review;
final class Greeting {
  public function render(string $name): array {
    return ['#markup' => "Hello {$name}", '#cache' => ['max-age' => 3600]];
  }
}

$query = <<<'SQL'
SELECT id FROM node_field_data WHERE status = 1
SQL;
