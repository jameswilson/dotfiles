# DDEV

If the project root contains `.ddev/`, use DDEV as the project runtime unless repository guidance says otherwise. Prefix project `drush`, `composer`, `php`, and similar commands with `ddev`.

For a Solr reindex, determine the actual Search API server machine name, then run:

1. `ddev drush sapi-sc <server_machine_name>`
2. `ddev drush sapi-c`
3. `ddev drush sapi-r`
4. `ddev drush sapi-rt`
5. `ddev drush sapi-i`
