#' @name process MeSH Tree 2023
#'
#' Read and Process Mesh Tree Data
#'
#'The code reads an ASCII format UTF-8 Mesh Tree file and processes it to extract relevant information.
#'It filters the data for tree numbers related to diseases, assigns major tree numbers based on grouping,
#'and assigns major mesh headings. The resulting clean table of Mesh Tree data can be used as a reference
#'to assign therapeutic foci for clinical trials on ClinicalTrials.gov with MeSH terms stored in AACT database.
#'
#'
#'@param mtrees MeSH Files in ASCII UTF-8 format for year 2023
#'
#'@return mesh_tree containing mesh headings and tree
#'
#'
#'
#'@note MeSH tree files in a ASCII format UTF-8 and generated every year. Use updated MesH tree
#'file (link:https://www.nlm.nih.gov/databases/download/mesh.html)
#'

library(magrittr)
# read in binary file as text file (source: https://www.nlm.nih.gov/databases/download/mesh.html)
mtrees <- readLines(here::here("GitHub/TrialFociMapper/R/mtrees2023.bin"))


# split text into two columns based on semicolon separator
mesh_tree <- data.frame(do.call("rbind", strsplit(mtrees, ";")), stringsAsFactors = FALSE)


# rename columns
colnames(mesh_tree) <- c("mesh_heading", "tree_number")


# slicing mesh tree for interested variables related to 'Diseases[C]' (C01 to C26.986.950.500)
mesh_tree <- mesh_tree[which(
  mesh_tree$tree_number >= "C01" &
    mesh_tree$tree_number <= "C26.986.950.500"),]


# create column major_tree_number and major_mesh_heading and fill with "NA"
mesh_tree$major_tree_number <- NA


# assign variables major tree number ---------------------------------
#(e.g all tree code starting with same prefix (e.g A01.236.500) will be grouped into one (e.g A01))


# initialize two variables, prev_code and prev_major_tree_number, with empty strings (used to track
# the previous code and NLM code, respectively)
prev_code <- ""
prev_major_tree_number <- ""

# loop through each row of mesh_tree
for (i in 1:nrow(mesh_tree)) {
  # checks first three character of code and if matches assign NLM code
  if (substr(mesh_tree$tree_number[i], 1, 3) == substr(prev_code, 1, 3)) {
    mesh_tree$major_tree_number[i] <- prev_major_tree_number
  } else {
    mesh_tree$major_tree_number[i] <- substr(mesh_tree$tree_number[i], 1, 3)
    prev_major_tree_number <- mesh_tree$major_tree_number[i]
  }
  # updates prev_code to the code value of the current row ( to be compared to the next row in the loop)
  prev_code <- mesh_tree$tree_number[i]
}

# assign variables major mesh heading
mesh_tree <- mesh_tree %>%
  dplyr::group_by(major_tree_number) %>%
  dplyr::mutate(major_mesh_heading = dplyr::first(mesh_heading)) %>%
  dplyr::ungroup()



