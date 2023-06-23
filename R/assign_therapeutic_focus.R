#' @title  assign_therapeutic_focus
#'
#' @description
#' This function assigns a therapeutic focus to each clinical trial based on weights specified for
#' major mesh headings. The weights are determined based on a disease-centric approach, where higher
#' weights indicate higher prominence. This approach considers diseases as the primary factor in
#' determining the therapeutic focus, with secondary consideration given to the associated organ
#' systems, pathology, or symptoms.The function takes a data frame with NCT IDs and major mesh
#' headings as input and generates a single therapeutic focus for each trial.
#'
#' @param data A data frame containing NCT IDs and major mesh headings.
#' @param nctid_col The name of the column in the data frame that contains the NCT IDs.
#' @param mesh_heading_cols A character vector specifying the column names in the data frame that
#' contain the major mesh headings.
#'
#' @return A modified data frame with an additional column "therapeutic_focus" containing the assigned
#' therapeutic focus for each clinical trial.
#'
#' @note
#' get_trial_foci function to generate the data for assigning final therapeutic focus
#'
#'
#' @usage
#' assign_therapeutic_focus(data, "nct_id", c("major_mesh_heading_1", "major_mesh_heading_2",
#' "major_mesh_heading_3", "major_mesh_heading_4", "major_mesh_heading_5" ))
#'
#'@export

assign_therapeutic_focus <- function(data, nctid_col, mesh_heading_cols) {
  # Define weights based on the disease-centric approach
  weights <- list(
    "Infections" = 4,
    "Neoplasms" = 3,
    "Cardiovascular Diseases" = 2.5,
    "Nervous System Diseases" = 2.5,
    "Musculoskeletal Diseases" = 2,
    "Digestive System Diseases" = 2,
    "Respiratory Tract Diseases" = 2,
    "Otorhinolaryngologic Diseases" = 2,
    "Eye Diseases" = 2,
    "Urogenital Diseases" = 2,
    "Hemic and Lymphatic Diseases" = 2,
    "Congenital, Hereditary, and Neonatal Diseases and Abnormalities" = 2,
    "Skin and Connective Tissue Diseases" = 2,
    "Nutritional and Metabolic Diseases" = 2,
    "Endocrine System Diseases" = 2,
    "Immune System Diseases" = 2,
    "Disorders of Environmental Origin" = 2,
    "Animal Diseases" = 2,
    "Pathological Conditions, Signs and Symptoms" = 1.5,
    "Stomatognathic Diseases" = 1.5,
    "Occupational Diseases" = 1,
    "Chemically-Induced Disorders" = 1,
    "Wounds and Injuries" = 1
  )

  # Iterate over each row in the data frame
  for (i in 1:nrow(data)) {
    # Get the major mesh headings for the current clinical trial
    major_headings <- unlist(data[i, mesh_heading_cols])

    # Remove NA values from the major mesh headings
    major_headings <- na.omit(major_headings)

    # Check if the clinical trial has multiple major mesh headings
    if (length(major_headings) > 1) {
      # Find the weights for the major mesh headings
      heading_weights <- unlist(weights[major_headings])

      # Find the major mesh heading with the highest weight
      max_weight <- max(heading_weights)

      # Assign the major mesh heading with the highest weight as the therapeutic focus
      data[i, "therapeutic_focus"] <- names(heading_weights[heading_weights == max_weight])[1]
    } else if (length(major_headings) == 1) {
      # Assign the single major mesh heading as the therapeutic focus
      data[i, "therapeutic_focus"] <- major_headings[1]
    } else {
      # No major mesh headings available
      data[i, "therapeutic_focus"] <- NA
    }
  }

  # Return the modified data frame
  return(data)
}
