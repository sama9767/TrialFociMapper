% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/assign_therapeutic_focus.R
\name{assign_therapeutic_focus}
\alias{assign_therapeutic_focus}
\title{assign_therapeutic_focus}
\usage{
assign_therapeutic_focus(data, "nct_id", c("major_mesh_heading_1", "major_mesh_heading_2",
"major_mesh_heading_3", "major_mesh_heading_4", "major_mesh_heading_5" ))
}
\arguments{
\item{data}{A data frame containing NCT IDs and major mesh headings.}

\item{nctid_col}{The name of the column in the data frame that contains the NCT IDs.}

\item{mesh_heading_cols}{A character vector specifying the column names in the data frame that
contain the major mesh headings.}
}
\value{
A modified data frame with an additional column "therapeutic_focus" containing the assigned
therapeutic focus for each clinical trial.
}
\description{
This function assigns a therapeutic focus to each clinical trial based on weights specified for
major mesh headings. The weights are determined based on a disease-centric approach, where higher
weights indicate higher prominence. This approach considers diseases as the primary factor in
determining the therapeutic focus, with secondary consideration given to the associated organ
systems, pathology, or symptoms.The function takes a data frame with NCT IDs and major mesh
headings as input and generates a single therapeutic focus for each trial.
}
