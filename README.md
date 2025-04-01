# Animal Culture Database (ACDB) – database release

The **Animal Culture Database (ACDB)** is a comparative database of cultural behaviors across nonhuman animal species. It synthesizes current literature on intra-species behavioral variation in contexts such as communication, foraging, and migration into a relational database. The latest version of the database can be accessed through an open-access [Shiny app](https://github.com/datadiversitylab/ACDB). In this repo, we store the relational databases associated to the ACDB.

## Files
ACDB_sqlite_build.R is primarily for illustrative purposes. It contains the code used to build the database from the csv files. If you would like to access the data, you can look at the individual tables in table_csvs or download the current database as ACDB_v01.sql. The example_queries.R script can also be used to load the SQLite database in R and run example queries on the tables. 


## Table structures

Below we provide an overview of the tables and their respective columns in the SQLite database used for the **Animal Culture Database (ACDB)**. 

### `species_table`
   - **Description**: Contains species-level data.
   - **Columns**:
     - `species_id`: Unique species identifier in the format Genus_species. [primary key]
     - `common_name`: Common name of the species in English.
     - `GBIF`: Global Biodiversity Information Facility (GBIF) identifier.
     - `canonicalName`: Canonical name from GBIF API.
     - `Species`, `Genus`, `Family`, `Ordr`, `Class`, `Phylum`: Taxonomic hierarchy from GBIF backbone.
     - `primary_social_unit`: The largest social unit for this species in which individuals maintain stable membership, adapted from Prox & Farine 2020 and Groot et al. 2023. Individual (no stable association with conspecifics); pair (two individuals, presumably mating pair); family (unit is composed of related individuals); group (unit includes unrelated individuals, may display fission-fusion behavior)
     - `unit_evidence`, `unit_source`: Evidence and sources.
     - `IUCN`: Conservation status code from the IUCN Red List.

---

### `groups_table`
   - **Description**: Details about social groups within species.
   - **Columns**:
     - `group_id`: Unique identifier for each group. [primary key]
     - `species_id`: Foreign key referencing `species_table`.
     - `group_level`: The group level, relative to the species primary social unit, to which cultural behaviors are attributed. 0+ with primary unit = 0, e.g. for killer whales 0 = matriline, 1 = pod, 2 = clan, 3 = community/population, 4 = ecotype, 5 = species.
     - `group_above`: In the case of species with nested social structure, name of the higher-level group to which this group belongs.
     - `size`: Group size in number of individuals.
     - `size_date`: Date for group size record.
     - `size_evidence`, `size_source`: Evidence and sources.
     - `lat`: Approximate latitude for group location.
     - `long`: Approximat longitude for group location.
     - `location_evidence`: Description of group geographical location.
     - `location_source`: Source of location information.

---

### `behaviors_table`
   - **Description**: Detailed behavioral records for groups.
   - **Columns**:
     - `behavior_id`: Unique identifier for the behavior. [primary key]
     - `group_id`: Foreign key referencing `groups_table`.
     - `behavior`: Short name of the behavior.
     - `behavior_description`: Detailed description of the behavior.
     - `behavior_source`: Primary source used to describe the behavior.
     - `start_date`, `end_date`: Time range during which the behavior was observed in years.
     - `vertical`, `vertical_evidence`, `vertical_source`: Indicating whether behavior is transmitted from parents to offspring, evidence, and source. 
     - `horizontal`, `horizontal_evidence`, `horizontal_source`: Indicating whether behavior is transmitted among peers.
     - `oblique`, `oblique_evidence`, `oblique_source`: Indicating whether behavior is transmitted from unrelated adults to juveniles.
     - `domains`, `domains_evidence`, `domains_source`: One of more of migration (knowledge of migration routes or sites); foraging (methods or tools of hunting or obtaining food, knowledge of food or resource patches, etc.); vocal communication (vocal transmission of information to others, e.g. songs and vocal dialects); antipredation (predator knowledge and avoidance); play (nonfunctional behavior that appears to be ‘for fun’); mating (mating displays, breeding sites, mate selection); architecture (modifications to the physical environment- nest building, burrows, etc.); social (non-mating social behaviors, such as those that reinforce group identity). 
     - `anth_effects`, `anth_source`: Recorded anthropogenic effects.
       
---

### `sources_table`
   - **Description**: Metadata for data sources and references. 
   - **Columns**:
     - `source_id`: Unique identifier for the source in the format firstauthoryear, e.g. baker2005. [primary key]
     - `title`: Title of the reference.
     - `year`: Year of publication.
     - `doi`: Digital Object Identifier (DOI) for the publication.

---

### Additional notes

- `sqlite_sequence`: Internal SQLite table that tracks the autoincrement values for primary keys in other tables.
- Foreign keys (e.g., `population_id`, `behavior_id`, `group_id`) ensure that data integrity is maintained across related tables.

## Contribution guidelines

We welcome contributions from researchers to expand and update the database. Please see the [Contribution Guidelines](CONTRIBUTING.md) for instructions on how to submit your data.

## License

This project is licensed under the [MIT License](LICENSE.md).

## Contact

For questions or comments, please contact [Kiran Basava](mailto:kcb7@arizona.edu).


