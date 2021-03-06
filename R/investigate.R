#' Investigate data
#'
#' After checking the data with \code{\link{validate}}, look into reported repeated values to determine if they are worrisome.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom dplyr filter
#' @importFrom dplyr distinct
#' @importFrom dplyr quo_name
#'
#' @param x The object created after cleaning data with \code{\link{clean}}
#' @param loc The download state in question
#' @param period_type The type of time period that will be given. You may choose one of two types:
#' \itemize{
#' \item dl_date
#' \item dl_cycle}
#' @param period Value of the time period in question
#' @param species The bird group in question. One of the bird groups from the following list may be supplied:
#' \itemize{
#' \item ducks_bag, geese_bag, dove_bag, woodcock_bag, coots_snipe, rails_gallinules, cranes, band_tailed_pigeon, brant, seaducks}
#'
#' @author Abby Walter, \email{abby_walter@@fws.gov}
#' @references \url{https://github.com/USFWS/migbirdHarvestData}
#'
#' @export

investigate <-
  function(x, loc, period_type, period, species){

    # Pull requested value

    investigated_x <-
      x %>%
      select(dl_state, {{period_type}}, ducks_bag:seaducks, source_file) %>%
      filter(dl_state == loc & !!sym(period_type) == period) %>%
      select(quo_name(species), source_file) %>%
      distinct()

    if(nrow(investigated_x) == 0) {
      message("Are you sure you entered all of the parameters correctly?")
    }

    else{
      return(investigated_x)
    }
  }

