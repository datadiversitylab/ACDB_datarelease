# Animal Culture Database (ACDB) – database release

The **Animal Culture Database (ACDB)** is a comparative database of cultural behaviors across nonhuman animal species. It synthesizes current literature on intra-species behavioral variation in contexts such as communication, foraging, and migration into a relational database. The latest version of the database can be accessed through an open-access [Shiny app](https://github.com/datadiversitylab/ACDB). In this repo, we store the relational databases associated to the ACDB.

## Files
ACDB_sqlite_build.R is primarily for illustrative purposes. It contains the code used to build the database from the csv files. If you would like to access the data, you can look at the individual tables in table_csvs or download the current database as ACDB_v01.sql. 

## Table structures

Below we provide an overview of the tables and their respective columns in the SQLite database used for the **Animal Culture Database (ACDB)**. 

### `species_table`
   - **Description**: Contains species-level data.
   - **Columns**:
     - `species_id`: Unique species identifier.
     - `common_name`: Common name of the species.
     - `GBIF`: Global Biodiversity Information Facility (GBIF) identifier.
     - `Species`, `Genus`, `Family`, `Ordr`, `Class`, `Phylum`: Taxonomic hierarchy.
     - `primary_social_unit`: Primary social unit type (e.g., group size).
     - `unit_evidence`, `unit_source`: Evidence codes and sources.
     - `IUCN`: Conservation status code from the IUCN Red List.

---

### `groups_table`
   - **Description**: Details about social groups within species.
   - **Columns**:
     - `group_id`: Unique identifier for each group.
     - `species_id`: Foreign key referencing `species_table`.
     - `levels_above`
     - `group_above`: igher-level group to which this group belongs.
     - `size`: Group size.
     - `size_date`: Group size.
     - `size_source`: Evidence for group size.
     - `location`: Location.
     - `location_source`: Source of location information.

---

### `behaviors_table`
   - **Description**: Detailed behavioral records for groups.
   - **Columns**:
     - `behavior_id`: Unique identifier for the behavior.
     - `group_id`: Foreign key referencing `groups_table`.
     - `behavior`: Description of the behavior.
     - `behavior_description`: Detailed description of the behavior.
     - `start_date`, `end_date`: Time range during which the behavior was observed.
     - `group_name`: Name of the group displaying the behavior.
     - `transmission_mode`
     - `transmission_evidence`
     - `transmission_source`
     - `communication`
     - `communication_evidence`
     - `communication_source`
     - `other_categories`
     - `category_evidence`
     - `category_source`
     - `anth_effects`: Recorded anthropogenic effects.
     - `anth_source`

---

### `sources_table`
   - **Description**: Metadata for data sources and references.
   - **Columns**:
     - `source_id`: Unique identifier for the source.
     - `title`: Title of the reference.
     - `year`: Year of publication.
     - `doi`: Digital Object Identifier (DOI) for the publication.

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


