# TrialFociMapper

## Description
The TrialFociMapper package retrieves and assigns major mesh headings for clinical trials stored in the AACT database, 
leveraging the information provided by data submitters to ClinicalTrials.gov. It applies a disease-centric approach to assign 
a single therapeutic focus for each trial, utilizing the major mesh headings. The major foci are assigned based on MeSH descriptor 
data from 2023, obtained from the MeSH Trees project by the National Library of Medicine (https://nlmpubs.nlm.nih.gov/projects/mesh/MESH_FILES/meshtrees/).

## How to install
To install package, you will nee to install devtools first, and then install via git:
```R
install.packages("devtools")
library(devtools)
install_github("sama9767/TrialFociMapper")
library(TrialFociMapper)
````

## TrialFoci functions
This package provides two functions:

1. Retrieve trial foci and assign major MeSH headings
(an account in the AACT database is required for generating a username and password ( https://aact.ctti-clinicaltrials.org/users/sign_up))
```R
generate_foci(nctids, username, password)
data <- generate_foci("NCT01271322",username, password)
````

|  nct_id | major_mesh_heading_1   |   major_mesh_heading_2 | major_mesh_heading_3| major_mesh_heading_4|
|---------|-----------|---------|-----|------------|
|   NCT01271322  |     Neoplasms         | Digestive System Diseases | NA |NA|

2. Assigns a single therapeutic focus to each clinical trial based on disease centric approach
```R
assign_therapeutic_focus(data, "nct_id", c("major_mesh_heading_1", "major_mesh_heading_2",  "major_mesh_heading_3", "major_mesh_heading_4"))
`````
|  nct_id | major_mesh_heading_1   |   major_mesh_heading_2 | major_mesh_heading_3| major_mesh_heading_4| therapeutic_focus|
|---------|-----------|---------|-----|------------|----|
|   NCT01271322  |     Neoplasms         | Digestive System Diseases | NA |NA| Neoplasm|

## Disease-centric approach
 The disease-centric approach prioritizes diseases as the main factor in determining the therapeutic focus. 
 Higher weights are assigned to diseases, indicating their greater importance. Associated organ systems, pathology, 
 or symptoms are also considered, although with lesser weight. To assign major foci, a specific category of 
 MeSH descriptors called "C" is used, which represent diseases. MeSH descriptors are organized hierarchically, 
 allowing navigation from general to specific terms. Following is the table of MeSH heading with corresponding weights:
 | Major MeSH Heading | Weight |
 |-----|------|
 |Infections| 4|
 |Neoplasms| 3|
 |Cardiovascular Diseases| 2.5|
 |Nervous System Diseases| 2.5|
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
 |Occupational Diseases|1|
 |Chemically-Induced Disorders|1|
 |Wounds and Injuries |1|

source: https://meshb.nlm.nih.gov/treeView
 
 







