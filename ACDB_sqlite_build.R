library(DBI)
library(RSQLite)
library(dplyr)
library(readr)
#open database connection----
ACDB_v01 <- dbConnect(RSQLite::SQLite(), "/Users/kiranbasava/DDL/ACDB/nsdata_scripts/ACDB_v01.sql")

dbListTables(ACDB_v01)

#order of table creation is as follows: 1. sources, 2. species, 3. groups, 4. behaviors

#dbExecute(ACDB_v01, "DROP TABLE sources;")

#sources table----
dbExecute(ACDB_v01, "CREATE TABLE sources (
  source_id TEXT PRIMARY KEY,
  title TEXT,
  year INTEGER,
  authors TEXT,
  doi TEXT
);")

sources <- read.csv("/Users/kiranbasava/DDL/ACDB/nsdata_scripts/table_csvs/sources_jan23.25.csv", stringsAsFactors = FALSE)
dbWriteTable(ACDB_v01, "sources", sources, append=TRUE)
dbGetQuery(ACDB_v01, "SELECT * FROM sources WHERE year == 2010 ;") #checking out records for after 2010
View(dbGetQuery(ACDB_v01, "SELECT * FROM sources ;")) #all records as a dataframe

dbGetQuery(ACDB_v01, "PRAGMA table_info([sources]);")  #checking primary key acknowledged

#species table----
#dbExecute(ACDB_v01, "DROP TABLE species;")

species <- read.csv("/Users/kiranbasava/DDL/ACDB/nsdata_scripts/table_csvs/species_jan23.25.csv", stringsAsFactors = FALSE)
dbExecute(ACDB_v01,"CREATE TABLE species (
    species_id TEXT PRIMARY KEY,
    common_name TEXT,
    GBIF INTEGER,
    canonicalName TEXT,
    Genus TEXT,
    Family TEXT,
    Ordr TEXT,
    Class TEXT,
    Phylum TEXT,
    primary_social_unit TEXT,
    unit_evidence TEXT,
    unit_source TEXT,
    IUCN TEXT,
    FOREIGN KEY (
        unit_source
    )
    REFERENCES sources (source_id) 
);")
dbWriteTable(ACDB_v01, "species", species, append=TRUE)

dbGetQuery(ACDB_v01, "PRAGMA table_info([species]);")  #make sure species_id is primary key
dbGetQuery(ACDB_v01, "SELECT * FROM species WHERE Class LIKE '%Aves%' ;") #test query
View(dbGetQuery(ACDB_v01, "SELECT * FROM species ;"))


#groups table----
#dbExecute(ACDB_v01, "DROP TABLE groups;")

dbExecute(ACDB_v01,"CREATE TABLE groups (
    group_id INTEGER PRIMARY KEY,
    species_id TEXT REFERENCES species (species_id),
    group_name TEXT,
    group_level INTEGER,
    group_above TEXT,
    size INTEGER,
    size_evidence TEXT,
    size_date INTEGER,
    size_source TEXT REFERENCES sources (source_id),
    location_evidence TEXT,
    location_source TEXT REFERENCES sources (source_id),
    lat REAL,
    long REAL,
    FOREIGN KEY (
        species_id
    )
    REFERENCES species (species_id),
    FOREIGN KEY (
        size_source
    )
    REFERENCES sources (source_id),
    FOREIGN KEY (
        location_source
    )
    REFERENCES sources (source_id) 
);")

groups <- read.csv("/Users/kiranbasava/DDL/ACDB/nsdata_scripts/table_csvs/groups_jan24.25.csv", stringsAsFactors = FALSE)

dbWriteTable(ACDB_v01, "groups", groups, append = TRUE)
dbGetQuery(ACDB_v01, "PRAGMA table_info([groups]);")  #make sure species_id is primary key

View(dbGetQuery(ACDB_v01, "SELECT * FROM groups ;"))

#2. add group_id to behaviors using text matching for group names
behaviors <- read.csv("/Users/kiranbasava/DDL/ACDB/nsdata_scripts/table_csvs/behaviors_jan24.25.csv", stringsAsFactors = FALSE)
behaviors <- merge(behaviors, groups[c(1,2)], by="group_name", all.x=T, all.y=F)
anti_join(groups, behaviors, by="group_name")["group_name"]

behaviors$behavior_id <- seq(from=2,to=113) #primary key column

#pasting group name to behavior name to make unique behaviors----
behaviors$behavior <- paste(behaviors[,1], behaviors[,2], sep= ' ')
behaviors <- behaviors[-c(1)]
write_excel_csv(behaviors, "/Users/kiranbasava/DDL/ACDB/jan2025_tables/behaviors_jan24.25.csv")

#behaviors table----
dbExecute(ACDB_v01, "DROP TABLE behaviors;")

behaviors <- read.csv("/Users/kiranbasava/DDL/ACDB/dev_Kiran/table_csvs/behaviors_jan24.25.csv", stringsAsFactors = FALSE)
dbExecute(ACDB_v01, 
          "CREATE TABLE behaviors (
    behavior_id          INTEGER    PRIMARY KEY,
    behavior             TEXT,
    group_id             INTEGER,
    behavior_description TEXT,
    behavior_source      TEXT,
    start_date           INTEGER,
    end_date             INTEGER,
    vertical             TEXT,
    vertical_evidence    TEXT,
    vertical_source      TEXT,
    horizontal           TEXT,
    horizontal_evidence  TEXT,
    horizontal_source    TEXT,
    oblique              TEXT,
    oblique_evidence     TEXT,
    oblique_source       TEXT,
    domains              TEXT,
    domains_evidence     TEXT,
    domains_source       TEXT,
    anth_effects         TEXT,
    anth_source          TEXT,
    FOREIGN KEY (
        group_id
    )
    REFERENCES groups (group_id),
    FOREIGN KEY (
        behavior_source
    )
    REFERENCES sources (source_id),
    FOREIGN KEY (
        vertical_source
    )
    REFERENCES sources (source_id),
    FOREIGN KEY (
        horizontal_source
    )
    REFERENCES sources (source_id),
    FOREIGN KEY (
        oblique_source
    )
    REFERENCES sources (source_id),
    FOREIGN KEY (
        domains_source
    )
    REFERENCES sources (source_id),
    FOREIGN KEY (
        anth_source
    )
    REFERENCES sources (source_id) 
);
")
dbWriteTable(ACDB_v01, "behaviors", behaviors, append = TRUE)
View(dbGetQuery(ACDB_v01, "SELECT * FROM behaviors ;"))
dbGetQuery(ACDB_v01, "PRAGMA table_info([behaviors]);")  #make sure behavior_id primary key

#disconnect----
dbDisconnect(ACDB_v01)
