# TrialFociMapper

## Description
This package retrieves and assigns therapeutic foci to clinical trials from ClinicalTrials.gov and the EU Clinical Trials Register (EUCTR).

### ClinicalTrials.gov registry function

ClinicalTrials.gov data is structured within the AACT database schema. The AACT database incorporates information from ClinicalTrials.gov and features a "Browse Conditions" table, detailing the conditions studied in trials. When submitting study data to ClinicalTrials.gov, data submitters are advised to employ Medical Subject Headings (MeSH terms), sourced from a MeSH tree. This MeSH tree, hosted by the National Library of Medicine (NLM), has 16 overarching categories, each with subcategories. The two overarching categories "Diseases [C]” and “Psychiatry and Psychology [F]” contain subcategories, which are referred to as therapeutic foci in this package. For example, within the overarching category of "Diseases [C]” there is a subcategory ‘Infections’ [C01] which is  therapeutic foci 

In order to retrieve MeSH terms submitted for a particular trial by the trialist, the provided function accesses the "browse_conditions" table for a given trial and determines therapeutic focus based on the NLM descriptor data available at the NLM descriptor data reference. A single trial can have one or more than one MeSH headings associated with it. For such cases, an additional function (‘assign_therpeutic_focus’) is provided which assigns a single final focus for aggregation across trials based on the disease-centric approach (described below).

The following functions are provided: 

1. `get_foci_ctgov`: This function utilizes the "browse_conditions" table to generate a trial foci table list based on the Medical Subject Headings (MeSH) provided by data submitters. Each trial may have multiple therapeutic focuses, depending on the information submitted by data submitters.

get_foci_ctgov(nctids, username, password)
e.g data <- get_foci_ctgov("NCT01271322",username, password)


|  nct_id | trial_foci_table_list  |  
|---------|-----------|
|   NCT01271322  |     c("Neoplasms", "Digestive System Diseases")         |


2. `assign_therapeutic_focus` - This additional function assigns a single therapeutic focus to trials with multiple therapeutic focuses. This is achieved by using a predefined order/sequence based on a disease-centric approach.

assign_therapeutic_focus(data = data, nctid_col = nct_id, mesh_heading_cols = 'trial_foci_table_list')


|  nct_id | trial_foci_table_list | therapeutic_focus|
|---------|-----------|-----|
|   NCT01271322  |   c("Neoplasms, Digestive System Diseases")  | Neoplasms|



### What is a disease-centric approach?
The disease-centric approach prioritizes diseases as the primary factor in determining therapeutic focus. It assigns higher weights to therapeutic foci representing severe or prevalent diseases while giving lesser weight to associated organ systems, pathology, or symptoms. For example, in the ClinicalTrials.gov registered trial "NCT01271322,” studying Adenocarcinoma of the Esophagogastric Junction, package retrieves 'trial_foci_table_list' of  Neoplasm and Digestive System Diseases. In this scenario, the disease-centric approach would prioritize Neoplasms due to its significance, while assigning lower weight to the Digestive System Diseases as it represents the anatomical position rather than the actual disease. While our function focuses solely on this approach, there could be other approaches, such as anatomical-centric, for future exploration.

Following is the table of therapeutic focus with corresponding weights as assigned in the package: 

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
*Subcategories derived from MeSH tree 2023, for details, see https://meshb.nlm.nih.gov/treeView 

Additional Note 

In cases where the data submitters provide no information for a particular clinical trial, the function will assign "NA" as the therapeutic focus. In cases where a trial exhibits multiple therapeutic focuses with equal assigned weights, the function `assign_therapeutic_focus` defaults to assigning the first therapeutic focus. 
  
### EUCTR registry function

3. `get_foci_euctr`: This function facilitates the retrieval of therapeutic focus information from the EU Clinical Trials Register (EUCTR). It scrapes the "E.1 Medical condition or disease under investigation" field and assigns the corresponding therapeutic focus to a specified EUCTR identifier.

get_foci_euctr("2010-023457-11")
##advanced/recurrent ovarian and endometrial cancer



## How to install
To install the package, you will need to install devtools first, and then install via git:
```R
install.packages("devtools")
library(devtools)
install_github("sama9767/TrialFociMapper")
library(TrialFociMapper)
````

Thank you for your attention. If you find any bug, please open an issue in the issue tracker. 
