#this script loads the database and runs some example queries

library(DBI)
library(RSQLite)
library(dplyr)
library(readr)
library(here)

#open database connection----
ACDB_v01 <- dbConnect(RSQLite::SQLite(), here("ACDB_v01.sql"))

dbListTables(ACDB_v01) #lists the four tables of the db

#view all tables as dataframes if needed
View(dbGetQuery(ACDB_v01, "SELECT * FROM behaviors;")) 
View(dbGetQuery(ACDB_v01, "SELECT * FROM groups;")) 
View(dbGetQuery(ACDB_v01, "SELECT * FROM species;")) 
View(dbGetQuery(ACDB_v01, "SELECT * FROM sources;")) 

#sources after 2010
View(dbGetQuery(ACDB_v01, "SELECT * FROM sources WHERE year == 2010 ;")) 

#birds in species table
View(dbGetQuery(ACDB_v01, "SELECT * FROM species WHERE Class LIKE '%Aves%' ;")) 

#all populations with behaviors tagged foraging (including behavior name, group name, group location)
View(dbGetQuery(ACDB_v01, "SELECT behaviors.behavior_id, behaviors.behavior, behaviors.behavior_description, behaviors.domains, groups.group_id, groups.group_name, groups.location_evidence 
FROM groups
LEFT JOIN behaviors ON groups.group_id = behaviors.group_id WHERE behaviors.domains LIKE '%foraging%'"))

#all populations belonging to critically endangered species and their locations
View(dbGetQuery(ACDB_v01, "SELECT groups.group_name, groups.species_id, groups.location_evidence, species.common_name, species.IUCN 
FROM groups
LEFT JOIN species ON groups.species_id = species.species_id WHERE species.IUCN == 'CR'"))

#all whale behaviors and sources
View(dbGetQuery(ACDB_v01,"SELECT behaviors.behavior, behaviors.behavior_description, sources.* FROM behaviors 
LEFT JOIN groups ON behaviors.group_id = groups.group_id
LEFT JOIN species ON groups.species_id = species.species_id
LEFT JOIN sources ON behavior_source = sources.source_id
WHERE species.Ordr == 'Cetacea'"))

#disconnect----
dbDisconnect(ACDB_v01)
