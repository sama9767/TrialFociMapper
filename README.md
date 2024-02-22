# TrialFociMapper

## Description
This package retrieves and assigns therapeutic focus to clinical trials from ClinicalTrials.gov and EU Clinical Trials Register (EUCTR).

### ClinicalTrials.gov
[ClinicalTrials.gov](https://classic.clinicaltrials.gov/) data is structured within the [AACT database schema](https://aact.ctti-clinicaltrials.org/). The AACT database incorporates information from ClinicalTrials.gov and features a "Browse Conditions" table, detailing the conditions studied in trials. When submitting study data to ClinicalTrials.gov, contributors are advised to employ [Medical Subject Heading (MeSH)](https://www.nlm.nih.gov/databases/download/mesh.html) terms, sourced from a [MeSH tree](https://meshb.nlm.nih.gov/treeView) with 16 overarching categories, each with subcategories. These subcategories (referred to as therapeutic focus in this package) form hierarchical trees, organizing descriptors from general to specific across up to thirteen levels.
Within the AACT database's "browse_conditions" table, MeSH terms are populated through an algorithm executed by the National Library of Medicine (NLM). This algorithm, rerun nightly, processes all studies in the ClinicalTrials.gov database. 

For ClinicalTrials.gov trials, this package focuses on the "Diseases" (C) and "Psychiatry and Psychology" [F] categories in the MeSH tree and the subcategories were used to represent therapeutic focuses. These subcategories, arranged from general to specific, were treated as nodes stemming from each therapeutic focus.  The function accesses the "browse_conditions" table for a given trial and determines therapeutic focus based on the NLM descriptor data available at the NLM descriptor data reference.

The following functions are provided:
1. `get_foci_ctgov`: This function retrieves the "browse_conditions" table and extracts clean high-level therapeutic focuses. It also returns parent nodes if only specific nodes are provided, using the NLM data as a guide.

2. `assign_therapeutic_focus`: This additional function assigns trials with multiple therapeutic focuses to a single therapeutic focus. This is achieved using a disease-centric approach, as outlined in the below.

### What is a disease-centric approach?
The disease-centric approach prioritizes "diseases" as the main factor in determining the therapeutic focus. Higher weights are assigned to therapeutic focus representing diseases whereas associated organ systems, pathology, 
or symptoms are given lesser weight. Following is the table of therapeutic focus with corresponding weights as assigned in the package:

 | Therapeutic focus | Assigned Weight |
 |-----|------|
 |Infections| 4|
 |Neoplasms| 3|
 |Cardiovascular Diseases| 2.5|
 |Nervous System Diseases| 2.5|
 |Mental Disorders|2.5|
 |Musculoskeletal Diseases|2|
 |Digestive System Diseases|2|
 |Respiratory Tract Diseases|2|
 |Otorhinolaryngologic Diseases|2|
 |Eye Diseases|2|
 |Urogenital Diseases|2|
 |Hemic and Lymphatic Diseases|2|
 |Congenital, Hereditary, and Neonatal Diseases and Abnormalities|2|
 |Skin and Connective Tissue Diseases|2|
 |Nutritional and Metabolic Diseases|2|
 |Endocrine System Diseases|2|
 |Immune System Diseases|2|
 |Disorders of Environmental Origin|2|
 |Animal Diseases|2|
 |Pathological Conditions, Signs and Symptoms|1.5|
 |Stomatognathic Diseases|1.5|
  |Behavioral Disciplines and Activities|1.5|
 |Occupational Diseases|1|
 |Chemically-Induced Disorders|1|
 |Wounds and Injuries |1|
 |Behaviour and Behaviour Mechanism|1|
 |Psychological Phenomena|1|
 
### EUCTR registry
It extracts the medical condition field from EUCTR for a given record EUCTR identifier via web-scraping.

The following functions are provided:
1. `get_foci_euctr`: This function extracts the medical condition field from EUCTR for a given record EUCTR identifier and assigns it as therapeutic foci.


### Note
🔺 In cases where no information is submitted from the data submitters for a particular clinical trial, the function will assign "NA" as the therapeutic focus.

🔺 In a trial where all Major MeSH headings are assigned equal weights, the first mentioned heading is designated as the therapeutic focus.

## How to install
To install the package, you will need to install devtools first, and then install via git:
```R
install.packages("devtools")
library(devtools)
install_github("sama9767/TrialFociMapper")
library(TrialFociMapper)
````

## TrialFoci functions
1. `get_foci_ctgov` -  Retrieve trial foci and assign major MeSH headings

Note: An account in the AACT database is required for generating a username and password (see link: https://aact.ctti-clinicaltrials.org/users/sign_up)
```R
get_foci_ctgov(nctids, username, password)
e.g data <- get_foci("NCT01271322",username, password)
````

|  nct_id | trial_foci_table_list  |  
|---------|-----------|
|   NCT01271322  |     Neoplasms, Digestive System Diseases         |

2. `assign_therapeutic_focus` - Assigns a single therapeutic focus to each clinical trial based on disease centric approach
```R
assign_therapeutic_focus(data, "nct_id", c("major_mesh_heading_1", "major_mesh_heading_2",  "major_mesh_heading_3", "major_mesh_heading_4"))
`````
|  nct_id | trial_foci_table_list | therapeutic_focus|
|---------|-----------|-----|
|   NCT01271322  |   c("Neoplasms, Digestive System Diseases")  | Neoplasms|

3. `get_foci_euctr` - Downloads the medical condition field from EUCTR for a given record identifier
```R
get_foci_euctr("2010-023457-11")
`````
##advanced/recurrent ovarian and endometrial cancer

## Additional Note
If you encounter any issues while downloading or using this package, please open an issue in the issue tracker above. Additionally, if you notice any problems with the extraction of information or have any suggestions for improvements, please feel free to report them in the issue tracker as well. 


