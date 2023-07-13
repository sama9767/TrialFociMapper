#'@title generate_foci
#'
#'@name generate_foci
#
#'@description
#'This function retrieves trial foci based on a list of NCT IDs from a PostgreSQL database.
#'It connects to the AACT database, retrieves the major mesh headings associated with the NCT IDs, and
#'generates major therapeutic focus for each trial according to NLM 2023 MeSH headings.The output is
#'a data frame containing the NCT IDs and their respective therapeutic focuses.
#'
#
#'@param nctids (character vector): A vector of NCT IDs for which trial foci need to be generated.
#'@param username (character): The username for database authentication.
#'@param password (character): The password for database authentication.
#'
#'@note An account in AACT database is required for credentials
#'(visit this link for registration : https://aact.ctti-clinicaltrials.org/users/sign_up)
#'
#'@import RPostgreSQL
#'@import assertthat
#'@import magrittr
#'@import rio
#'@import stringdist
#'
#'@usage generate_foci(nctids, username, password)
#'
#'@export
#'

library(RPostgreSQL)
library(assertthat)
library(magrittr)

generate_foci <- function(nctids, username, password) {
  # Check that TRN is well-formed
  assertthat::assert_that(
    is.character(nctids),
    all(grepl("^NCT\\d{8}$", nctids))
  )

  # Fixed database connection details
  dbname <- "aact"
  host <- "aact-db.ctti-clinicaltrials.org"
  port <- 5432

  # Load default mesh_tree
mesh_tree <- rio::import("https://raw.githubusercontent.com/sama9767/TrialFociMapper/main/data/mesh_tree.csv")

  # Connect to the AACT database
  con <- dbConnect(RPostgreSQL::PostgreSQL(),
                   dbname = dbname,
                   host = host,
                   port = port,
                   user = username,
                   password = password)

  all_foci <- data.frame(nct_id = character(), trial_foci_table = character(), stringsAsFactors = FALSE)

  for (nctid in nctids) {
    # Download browse_conditions table for the current NCT ID
    query <- paste0("SELECT * FROM browse_conditions WHERE nct_id = '", nctid, "'")
    browse_conditions <- RPostgreSQL::dbGetQuery(con, query)

    # Find matching major mesh headings for the mesh terms
    mesh_terms <- browse_conditions$downcase_mesh_term
    matching_mesh_headings <- mesh_tree$major_mesh_heading[stringdist::amatch(mesh_terms, mesh_tree$mesh_heading, maxDist = 7)]

    # Combine matching major mesh headings into a single string
    trial_foci <- ifelse(length(matching_mesh_headings) == 0, "", stringr::str_c(unique(matching_mesh_headings), collapse = ";"))

    # Append results to the final data frame
    all_foci <- rbind(all_foci, data.frame(nct_id = nctid, trial_foci_table = trial_foci, stringsAsFactors = FALSE))
  }

  # Split the trial_foci_table column into major and other foci
  trial_foci_table_raw <- tidyr::separate(all_foci, trial_foci_table,
                                          into = c("major_mesh_heading_1", "major_mesh_heading_2",
                                                   "major_mesh_heading_3", "major_mesh_heading_4",
                                                   "major_mesh_heading_5", "major_mesh_heading_6",
                                                   "major_mesh_heading_7", "major_mesh_heading_8",
                                                   "major_mesh_heading_9", "major_mesh_heading_10"),
                                          sep = ";", fill = "right")

  # Keep distinct entries based on nct_id
  trial_foci_table <- trial_foci_table_raw %>%
    dplyr::distinct(nct_id, .keep_all = TRUE)

  # Disconnect from the database
 RPostgreSQL::dbDisconnect(con)


  return(trial_foci_table)
}
