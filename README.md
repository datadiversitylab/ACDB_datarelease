# Animal Culture Database (ACDB) – database release

The **Animal Culture Database (ACDB)** is a comparative database of cultural behaviors across nonhuman animal species. It synthesizes current literature on intra-species behavioral variation in contexts such as communication, foraging, and migration into a relational database. The latest version of the database can be accessed through an open-access [Shiny app](https://github.com/datadiversitylab/ACDB). In this repo, we store the relational databases associated to the ACDB.

## Table structures

Below we provide an overview of the tables and their respective columns in the SQLite database used for the **Animal Culture Database (ACDB)**. 

### `species_table`
   - **Description**: Contains species-level data.
   - **Columns**:
     - `species_id` (TEXT): Unique species identifier.
     - `common_name` (TEXT): Common name of the species.
     - `GBIF` (INTEGER): Global Biodiversity Information Facility (GBIF) identifier.
     - `canonicalName` (TEXT): Scientific name of the species.
     - `Genus`, `Family`, `Ordr`, `Class`, `Phylum` (TEXT): Taxonomic hierarchy.
     - `primary_social_unit` (INTEGER): Primary social unit type (e.g., group size).
     - `unit_evidence`, `unit_source` (INTEGER): Evidence codes and sources.
     - `IUCN` (INTEGER): Conservation status code from the IUCN Red List.

---

### `groups_table`
   - **Description**: Details about social groups within species.
   - **Columns**:
     - `group_id` (TEXT): Unique identifier for each group.
     - `species_id` (TEXT): Foreign key referencing `species_table`.
     - `group_name` (TEXT): Name of the social group.
     - `group_level` (INTEGER): Group hierarchy level.
     - `group_above` (TEXT): Higher-level group to which this group belongs.
     - `size` (INTEGER): Group size.
     - `size_evidence` (TEXT): Evidence for group size.
     - `lat`, `long` (REAL): Location coordinates.
     - `location_source` (TEXT): Source of location information.

---

### `behaviors_table`
   - **Description**: Detailed behavioral records for groups.
   - **Columns**:
     - `behavior_id` (TEXT): Unique identifier for the behavior.
     - `behavior` (TEXT): Description of the behavior.
     - `group_id` (TEXT): Foreign key referencing `groups_table`.
     - `group_name` (TEXT): Name of the group displaying the behavior.
     - `behavior_description` (TEXT): Detailed description of the behavior.
     - `behavior_source` (TEXT): Source of the behavioral observation.
     - `start_date`, `end_date` (INTEGER): Time range during which the behavior was observed.
     - `vertical`, `horizontal`, `oblique` (TEXT): Modes of social transmission.
     - `domains` (TEXT): Behavioral domains (e.g., foraging, communication).
     - `anth_effects` (TEXT): Recorded anthropogenic effects.

---

### `sources_table`
   - **Description**: Metadata for data sources and references.
   - **Columns**:
     - `source_id` (TEXT): Unique identifier for the source.
     - `title` (TEXT): Title of the reference.
     - `year` (INTEGER): Year of publication.
     - `authors` (TEXT): Authors of the study.
     - `doi` (TEXT): Digital Object Identifier (DOI) for the publication.

---

### Additional notes

- `sqlite_sequence`: Internal SQLite table that tracks the autoincrement values for primary keys in other tables.
- Foreign keys (e.g., `population_id`, `behavior_id`, `group_id`) ensure that data integrity is maintained across related tables.

## Contribution guidelines

We welcome contributions from researchers to expand and update the database. Please see the [Contribution Guidelines](#) for instructions on how to submit your data.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For questions or comments, please contact [Kiran Basava](mailto:kcb7@arizona.edu).


