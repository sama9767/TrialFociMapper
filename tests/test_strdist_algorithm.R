library(RPostgreSQL)
library(assertthat)
library(magrittr)
library(readr)
library(readxl)
library(dplyr)
library(stringr)



# Read test data
data <- read_csv('data/matching_algorithm_sample.csv') %>% sample_n(1000)
nctids <- data$'NCT Number'
# data <- read_xlsx('data/01-foci_weight_assignment.xlsx', sheet = 'test-trials') %>%
#   select('NCT ID')
# nctids <- data$'NCT ID'


# Check that TRN is well-formed
assertthat::assert_that(
  is.character(nctids),
  all(grepl("^NCT\\d{8}$", nctids))
)

# Fixed database connection details
dbname <- "aact"
host <- "aact-db.ctti-clinicaltrials.org"
port <- 5432

username <- 'martinholst'
password <- 'mupmub-tyjcYg-2bykco'

# Load default mesh_tree
mesh_tree <- rio::import("https://raw.githubusercontent.com/sama9767/TrialFociMapper/main/data/mesh_tree.csv")

# Connect to the AACT database
con <- dbConnect(RPostgreSQL::PostgreSQL(),
                dbname = dbname,
                host = host,
                port = port,
                user = username,
                password = password)

data <- data.frame(
  id = integer(),
  nct_id = character(),
  mesh_term = character(),
  downcase_mesh_term = character(),
  mesh_type = character(),
  m_strdist_1 = character(),
  m_strdist_2 = character(),
  m_strdist_3 = character(),
  m_strdist_4 = character(),
  m_strdist_5 = character(),
  m_strdist_6 = character(),
  m_strdist_7 = character(),
  m_strdist_8 = character(),
  m_strdist_9 = character(),
  stringsAsFactors = FALSE
)

for (nctid in nctids) {

  # Download browse_conditions table for the current NCT ID
  query <- paste0("SELECT * FROM browse_conditions WHERE nct_id = '", nctid, "'")
  browse_conditions <- RPostgreSQL::dbGetQuery(con, query)

  for (i in 1:9) {

    # Find matching major mesh headings for the mesh terms
    mesh_terms <- browse_conditions$downcase_mesh_term
    matching_mesh_headings <- mesh_tree$major_mesh_heading[stringdist::amatch(mesh_terms, mesh_tree$mesh_heading, maxDist = i)] %>% as.data.frame()

    # Append results to the final data frame
    browse_conditions <- bind_cols(browse_conditions, matching_mesh_headings, .name_repair = 'universal')

  }

  browse_conditions <- browse_conditions %>% rename(
    'm_strdist_1' = 6,
    'm_strdist_2' = 7,
    'm_strdist_3' = 8,
    'm_strdist_4' = 9,
    'm_strdist_5' = 10,
    'm_strdist_6' = 11,
    'm_strdist_7' = 12,
    'm_strdist_8' = 13,
    'm_strdist_9' = 14
  )

  data <- bind_rows(data, browse_conditions)

}

# Disconnect from the database
RPostgreSQL::dbDisconnect(con)

# Sava data
data %>% write_csv('data/matching_algorithm_test.csv')
