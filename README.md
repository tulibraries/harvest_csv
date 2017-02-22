# Harvest CSV

Rake file to ingest CSV file data into Solr. Presumes the CSV file has unique headers

## Ingest CSV file into Solr

1. Generate initial map file, `solr_map.yml` that maps the CSV columns to one or more Solr fields

```sh
rake makemap
```

2. Edit `solr_map.yml`

Add or modify solr fields in this file. One column *must* be designated an ID field with unique values.

The file will look like this:

```yaml
  playerID:
    - id
    - playerID_display
    - title_display
  name:
    - name_display
    - name_t
  team:
    - team_display
    - team_facet
  biography:
    - text
```

3. Customize the Solr schema. For Blacklight applications, this file will be `solr/conf/schema.xml`.

    1. Optional: Add the new fields to the `<field>`block with the desired attributes. Those attributes are documented in the `schema.xml` comments.
    2. Add the fields to be searched to...
    3. Add the fields to be shown in the search results index page to...

4. Customize the Solr configuration. For Blacklight applications, this file will be `solr/conf/solrconfig.xml`.

5. Generate blacklight add field snippets

```sh
rake blacklight
```

6. Paste these into the Blacklight catalog controller

7. Ingest CSV into Blacklight:

```sh
rake
```
