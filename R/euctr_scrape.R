#' @title euctr_scrape
#'
#' @description Downloads the medical condition field from EUCTR for a
#'     given record identifier
#'
#' @param trn A character string containing a well-formed EUCTR
#'     identifier
#'
#' @return A character string with the contents of the
#'     "Medical condition field" from EUCTR for the record that
#'     corresponds to the provided identifier
#'
#' @export
#'
#' @examples
#' euctr_scrape("2010-023457-11")
#' ## "advanced/recurrent ovarian and endometrial cancer"

euctr_scrape <- function (trn) {

    ## Check that trn is well-formed
    assertthat::assert_that(
                    grepl("^[0-9]{4}-[0-9]{6}-[0-9]{2}$", trn),
                    msg = "TRN is not well-formed"
                )

    ## Check that the site is reachable
    assertthat::assert_that(
                    ! httr::http_error("https://www.clinicaltrialsregister.eu"),
                    msg = "Unable to connect to EUCTR"
                )
    
    ## Construct the URL
    url <- paste0(
        "https://www.clinicaltrialsregister.eu/ctr-search/search?query=",
        trn
    )

    ## Download data
    html <- NA
    html <- rvest::read_html(url)

    ## Select medical condition field
    condition <- html %>%
        rvest::html_nodes(
                   xpath=".//*[contains(text(), 'Medical condition')]/.."
               ) %>%
        rvest::html_text2() %>%
        stringr::str_extract("^Medical condition: (.*)$", group = 1) %>%
        stringr::str_trim()
    
    ## Check that exactly one record was returned
    assertthat::assert_that(
                    length(condition) == 1,
                    msg = "There are zero or more than one records returned by this query"
                )

    ## Return result
    return(condition)
    
}
