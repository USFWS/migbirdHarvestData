#' Tidy data
#'
#' After reading the data with \code{\link{compile}}, rename the column names and do preliminary cleaning of firstname, lastname, middle initial, and suffixes.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr rename
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr cur_group_id
#' @importFrom dplyr ungroup
#' @importFrom dplyr case_when
#' @importFrom dplyr row_number
#' @importFrom dplyr mutate_all
#' @importFrom dplyr na_if
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_tile
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 theme_classic
#' @importFrom ggplot2 theme
#' @importFrom stringr str_to_upper
#' @importFrom stringr str_detect
#' @importFrom stringr str_extract
#' @importFrom stringr str_remove_all
#' @importFrom stringr str_remove
#' @importFrom stringr str_replace
#' @importFrom stringr str_trim
#' @importFrom rlang .data
#'
#' @param x The object created after reading in data with \code{\link{compile}}
#' @param plot If TRUE, plots the records and fields that were filtered out of critical identifying information was missing; default is FALSE.
#'
#' @author Abby Walter, \email{abby_walter@@fws.gov}
#' @references \url{https://github.com/USFWS/migbirdHarvestData}
#'
#' @export

clean <-
  function(x, plot){

    tidied_x <-
      x %>%
      rename(
        title = X1,
        firstname = X2,
        middle = X3,
        lastname = X4,
        suffix = X5,
        address = X6,
        city = X7,
        state = X8,
        zip = X9,
        birth_date = X10,
        # Edited X11 to specific .data$X11 to avoid error:
        # "Found an obsolete/platform-specific call in: 'tidy'"
        # "Found the platform-specific device: 'X11'"
        issue_date = .data$X11,
        hunt_mig_birds = X12,
        ducks_bag = X13,
        geese_bag = X14,
        dove_bag = X15,
        woodcock_bag = X16,
        coots_snipe = X17,
        rails_gallinules = X18,
        cranes = X19,
        band_tailed_pigeon = X20,
        brant = X21,
        seaducks = X22,
        registration_yr = X23,
        email = X24
      ) %>%
      # Add a download key
      group_by(dl_date, dl_state) %>%
      mutate(dl_key = paste0("dl_", cur_group_id())) %>%
      ungroup() %>%
      # Filter out records if firstname, lastname, city of residence, state of
      # residence, or date of birth are missing -- records discarded
      filter(!is.na(firstname)) %>%
      filter(!is.na(lastname)) %>%
      filter(!is.na(city)) %>%
      filter(!is.na(state)) %>%
      filter(!is.na(birth_date)) %>%
      mutate(
        # Add a record key
        record_key = paste0("record_", row_number()),
        # Names to uppercase for easier stringr
        firstname = str_to_upper(firstname),
        lastname = str_to_upper(lastname),
        # Extract suffixes from lastname to suffix col
        # We cannot go above VII in Roman numerals or 9TH in ordinal numbering
        # because of the 3 char column limit
        suffix =
          case_when(
            str_detect(lastname, "(?<=\\s)JR") ~
              str_extract(lastname, "(?<=\\s)JR"),
            str_detect(lastname, "(?<=\\s)SR") ~
              str_extract(lastname, "(?<=\\s)SR"),
            str_detect(lastname, "(?<=\\s)I$") ~
              str_extract(lastname, "(?<=\\s)I"),
            str_detect(lastname, "(?<=\\s)II") ~
              str_extract(lastname, "(?<=\\s)II"),
            str_detect(lastname, "(?<=\\s)III") ~
              str_extract(lastname, "(?<=\\s)III"),
            str_detect(lastname, "(?<=\\s)IV") ~
              str_extract(lastname, "(?<=\\s)IV"),
            str_detect(lastname, "(?<=\\s)V") ~
              str_extract(lastname, "(?<=\\s)V"),
            str_detect(lastname, "(?<=\\s)VI") ~
              str_extract(lastname, "(?<=\\s)VI"),
            str_detect(lastname, "(?<=\\s)VII") ~
              str_extract(lastname, "(?<=\\s)VII"),
            str_detect(lastname, "(?<=\\s)1ST") ~
              str_extract(lastname, "(?<=\\s)1ST"),
            str_detect(lastname, "(?<=\\s)2ND") ~
              str_extract(lastname, "(?<=\\s)2ND"),
            str_detect(lastname, "(?<=\\s)3RD") ~
              str_extract(lastname, "(?<=\\s)3RD"),
            str_detect(lastname, "(?<=\\s)4TH") ~
              str_extract(lastname, "(?<=\\s)4TH"),
            str_detect(lastname, "(?<=\\s)5TH") ~
              str_extract(lastname, "(?<=\\s)5TH"),
            str_detect(lastname, "(?<=\\s)6TH") ~
              str_extract(lastname, "(?<=\\s)6TH"),
            str_detect(lastname, "(?<=\\s)7TH") ~
              str_extract(lastname, "(?<=\\s)7TH"),
            str_detect(lastname, "(?<=\\s)8TH") ~
              str_extract(lastname, "(?<=\\s)8TH"),
            str_detect(lastname, "(?<=\\s)9TH") ~
              str_extract(lastname, "(?<=\\s)9TH"),
            TRUE ~ suffix
          ),
        # Delete suffixes from lastname col
        lastname =
          case_when(
            str_detect(lastname, "(?<=\\s)JR") ~
              str_remove_all(lastname, "(?<=\\s)JR"),
            str_detect(lastname, "(?<=\\s)SR") ~
              str_remove_all(lastname, "(?<=\\s)SR"),
            str_detect(lastname, "(?<=\\s)XX") ~
              str_remove_all(lastname, "(?<=\\s)XX"),
            str_detect(lastname, "(?<=\\s)XIX") ~
              str_remove_all(lastname, "(?<=\\s)XIX"),
            str_detect(lastname, "(?<=\\s)XVIII") ~
              str_remove_all(lastname, "(?<=\\s)XVIII"),
            str_detect(lastname, "(?<=\\s)XVII") ~
              str_remove_all(lastname, "(?<=\\s)XVII"),
            str_detect(lastname, "(?<=\\s)XVI") ~
              str_remove_all(lastname, "(?<=\\s)XVI"),
            str_detect(lastname, "(?<=\\s)XV") ~
              str_remove_all(lastname, "(?<=\\s)XV"),
            str_detect(lastname, "(?<=\\s)XIV") ~
              str_remove_all(lastname, "(?<=\\s)XIV"),
            str_detect(lastname, "(?<=\\s)XIII") ~
              str_remove_all(lastname, "(?<=\\s)XIII"),
            str_detect(lastname, "(?<=\\s)XII") ~
              str_remove_all(lastname, "(?<=\\s)XII"),
            str_detect(lastname, "(?<=\\s)XI") ~
              str_remove_all(lastname, "(?<=\\s)XI"),
            str_detect(lastname, "(?<=\\s)X") ~
              str_remove_all(lastname, "(?<=\\s)X"),
            str_detect(lastname, "(?<=\\s)IX") ~
              str_remove_all(lastname, "(?<=\\s)IX"),
            str_detect(lastname, "(?<=\\s)VIII") ~
              str_remove_all(lastname, "(?<=\\s)VIII"),
            str_detect(lastname, "(?<=\\s)VII") ~
              str_remove_all(lastname, "(?<=\\s)VII"),
            str_detect(lastname, "(?<=\\s)VI") ~
              str_remove_all(lastname, "(?<=\\s)VI"),
            str_detect(lastname, "(?<=\\s)V") ~
              str_remove_all(lastname, "(?<=\\s)V"),
            str_detect(lastname, "(?<=\\s)IV") ~
              str_remove_all(lastname, "(?<=\\s)IV"),
            str_detect(lastname, "(?<=\\s)III") ~
              str_remove_all(lastname, "(?<=\\s)III"),
            str_detect(lastname, "(?<=\\s)II") ~
              str_remove_all(lastname, "(?<=\\s)II"),
            str_detect(lastname, "(?<=\\s)I$") ~
              str_remove_all(lastname, "(?<=\\s)I"),
            str_detect(lastname, "(?<=\\s)1ST") ~
              str_remove_all(lastname, "(?<=\\s)1ST"),
            str_detect(lastname, "(?<=\\s)2ND") ~
              str_remove_all(lastname, "(?<=\\s)2ND"),
            str_detect(lastname, "(?<=\\s)3RD") ~
              str_remove_all(lastname, "(?<=\\s)3RD"),
            str_detect(lastname, "(?<=\\s)4TH") ~
              str_remove_all(lastname, "(?<=\\s)4TH"),
            str_detect(lastname, "(?<=\\s)5TH") ~
              str_remove_all(lastname, "(?<=\\s)5TH"),
            str_detect(lastname, "(?<=\\s)6TH") ~
              str_remove_all(lastname, "(?<=\\s)6TH"),
            str_detect(lastname, "(?<=\\s)7TH") ~
              str_remove_all(lastname, "(?<=\\s)7TH"),
            str_detect(lastname, "(?<=\\s)8TH") ~
              str_remove_all(lastname, "(?<=\\s)8TH"),
            str_detect(lastname, "(?<=\\s)9TH") ~
              str_remove_all(lastname, "(?<=\\s)9TH"),
            str_detect(lastname, "(?<=\\s)ESQ") ~
              str_remove_all(lastname, "(?<=\\s)ESQ"),
            TRUE ~ lastname
          )
      ) %>%
      # Add another mutate because can't pipe '.'
      mutate(
        lastname =
          # Delete lase name periods if they were used for a JR or SR suffix
          str_remove_all(lastname, "\\s\\.$"),
        # Extract suffixes from firstname to suffix col
        # We cannot go above VII in Roman numerals or 9TH in ordinal numbering
        # because of the 3 char column limit
        suffix =
          case_when(
            str_detect(firstname, "(?<=\\s)JR") ~
              str_extract(firstname, "(?<=\\s)JR"),
            str_detect(firstname, "(?<=\\s)SR") ~
              str_extract(firstname, "(?<=\\s)SR"),
            str_detect(firstname, "(?<=\\s)I$") ~
              str_extract(firstname, "(?<=\\s)I"),
            str_detect(firstname, "(?<=\\s)II") ~
              str_extract(firstname, "(?<=\\s)II"),
            str_detect(firstname, "(?<=\\s)III") ~
              str_extract(firstname, "(?<=\\s)III"),
            str_detect(firstname, "(?<=\\s)IV") ~
              str_extract(firstname, "(?<=\\s)IV"),
            str_detect(firstname, "(?<=\\s)V") ~
              str_extract(firstname, "(?<=\\s)V"),
            str_detect(firstname, "(?<=\\s)VI") ~
              str_extract(firstname, "(?<=\\s)VI"),
            str_detect(firstname, "(?<=\\s)VII") ~
              str_extract(firstname, "(?<=\\s)VII"),
            str_detect(firstname, "(?<=\\s)1ST") ~
              str_extract(firstname, "(?<=\\s)1ST"),
            str_detect(firstname, "(?<=\\s)2ND") ~
              str_extract(firstname, "(?<=\\s)2ND"),
            str_detect(firstname, "(?<=\\s)3RD") ~
              str_extract(firstname, "(?<=\\s)3RD"),
            str_detect(firstname, "(?<=\\s)4TH") ~
              str_extract(firstname, "(?<=\\s)4TH"),
            str_detect(firstname, "(?<=\\s)5TH") ~
              str_extract(firstname, "(?<=\\s)5TH"),
            str_detect(firstname, "(?<=\\s)6TH") ~
              str_extract(firstname, "(?<=\\s)6TH"),
            str_detect(firstname, "(?<=\\s)7TH") ~
              str_extract(firstname, "(?<=\\s)7TH"),
            str_detect(firstname, "(?<=\\s)8TH") ~
              str_extract(firstname, "(?<=\\s)8TH"),
            str_detect(firstname, "(?<=\\s)9TH") ~
              str_extract(firstname, "(?<=\\s)9TH"),
            TRUE ~ suffix
          )
      ) %>%
      # Add another mutate because can't pipe '.'
      mutate(
        suffix =
          # The original suffixes aren't uppercase, convert them to upper
          str_to_upper(suffix),
        suffix =
          # Delete periods and commas from suffixes
          str_remove_all(suffix, "\\.|\\,"),
        # Delete suffixes from firstname col
        firstname =
          case_when(
            str_detect(firstname, "(?<=\\s)JR") ~
              str_remove_all(firstname, "(?<=\\s)JR"),
            str_detect(firstname, "(?<=\\s)SR") ~
              str_remove_all(firstname, "(?<=\\s)SR"),
            str_detect(firstname, "(?<=\\s)XX") ~
              str_remove_all(firstname, "(?<=\\s)XX"),
            str_detect(firstname, "(?<=\\s)XIX") ~
              str_remove_all(firstname, "(?<=\\s)XIX"),
            str_detect(firstname, "(?<=\\s)XVIII") ~
              str_remove_all(firstname, "(?<=\\s)XVIII"),
            str_detect(firstname, "(?<=\\s)XVII") ~
              str_remove_all(firstname, "(?<=\\s)XVII"),
            str_detect(firstname, "(?<=\\s)XVI") ~
              str_remove_all(firstname, "(?<=\\s)XVI"),
            str_detect(firstname, "(?<=\\s)XV") ~
              str_remove_all(firstname, "(?<=\\s)XV"),
            str_detect(firstname, "(?<=\\s)XIV") ~
              str_remove_all(firstname, "(?<=\\s)XIV"),
            str_detect(firstname, "(?<=\\s)XIII") ~
              str_remove_all(firstname, "(?<=\\s)XIII"),
            str_detect(firstname, "(?<=\\s)XII") ~
              str_remove_all(firstname, "(?<=\\s)XII"),
            str_detect(firstname, "(?<=\\s)XI") ~
              str_remove_all(firstname, "(?<=\\s)XI"),
            str_detect(firstname, "(?<=\\s)X") ~
              str_remove_all(firstname, "(?<=\\s)X"),
            str_detect(firstname, "(?<=\\s)IX") ~
              str_remove_all(firstname, "(?<=\\s)IX"),
            str_detect(firstname, "(?<=\\s)VIII") ~
              str_remove_all(firstname, "(?<=\\s)VIII"),
            str_detect(firstname, "(?<=\\s)VII") ~
              str_remove_all(firstname, "(?<=\\s)VII"),
            str_detect(firstname, "(?<=\\s)VI") ~
              str_remove_all(firstname, "(?<=\\s)VI"),
            str_detect(firstname, "(?<=\\s)V") ~
              str_remove_all(firstname, "(?<=\\s)V"),
            str_detect(firstname, "(?<=\\s)IV") ~
              str_remove_all(firstname, "(?<=\\s)IV"),
            str_detect(firstname, "(?<=\\s)III") ~
              str_remove_all(firstname, "(?<=\\s)III"),
            str_detect(firstname, "(?<=\\s)II") ~
              str_remove_all(firstname, "(?<=\\s)II"),
            str_detect(firstname, "(?<=\\s)I$") ~
              str_remove_all(firstname, "(?<=\\s)I"),
            str_detect(firstname, "(?<=\\s)1ST") ~
              str_remove_all(firstname, "(?<=\\s)1ST"),
            str_detect(firstname, "(?<=\\s)2ND") ~
              str_remove_all(firstname, "(?<=\\s)2ND"),
            str_detect(firstname, "(?<=\\s)3RD") ~
              str_remove_all(firstname, "(?<=\\s)3RD"),
            str_detect(firstname, "(?<=\\s)4TH") ~
              str_remove_all(firstname, "(?<=\\s)4TH"),
            str_detect(firstname, "(?<=\\s)5TH") ~
              str_remove_all(firstname, "(?<=\\s)5TH"),
            str_detect(firstname, "(?<=\\s)6TH") ~
              str_remove_all(firstname, "(?<=\\s)6TH"),
            str_detect(firstname, "(?<=\\s)7TH") ~
              str_remove_all(firstname, "(?<=\\s)7TH"),
            str_detect(firstname, "(?<=\\s)8TH") ~
              str_remove_all(firstname, "(?<=\\s)8TH"),
            str_detect(firstname, "(?<=\\s)9TH") ~
              str_remove_all(firstname, "(?<=\\s)9TH"),
            str_detect(firstname, "(?<=\\s)ESQ") ~
              str_remove_all(firstname, "(?<=\\s)ESQ"),
            TRUE ~ firstname
          )
      ) %>%
      # Add another mutate because can't pipe '.'
      mutate(
        firstname =
          # Delete first name periods if they were used for a JR or SR suffix
          str_remove_all(firstname, "\\."),
        # Remove punctuation from middle initial col
        middle =
          ifelse(# Preserve numbers in case of a frame shift
            str_detect(middle, "[^A-Z|0-9]"),
            NA,
            middle),
        # Remove ending hyphen from zip codes with 5 digits
        zip =
          ifelse(str_detect(zip, "\\-$"),
                 str_remove(zip, "\\-"),
                 zip),
        # Do a little P.O. Box string cleaning
        address =
          case_when(
            str_detect(address, "P.O.BOX ") ~
              str_replace(address, "P.O.BOX ", "P.O. BOX "),
            str_detect(address, "PO BOX ") ~
              str_replace(address, "PO BOX ", "P.O. BOX "),
            TRUE ~ address
          )
      ) %>%
      # Delete white space around strings
      mutate_all(str_trim) %>%
      # Convert N/A strings to NA
      na_if("N/A")

    missing_x <-
      x %>%
      rename(
        title = X1,
        firstname = X2,
        middle = X3,
        lastname = X4,
        suffix = X5,
        address = X6,
        city = X7,
        state = X8,
        zip = X9,
        birth_date = X10,
        # Edited X11 to specific .data$X11 to avoid error:
        # "Found an obsolete/platform-specific call in: 'tidy'"
        # "Found the platform-specific device: 'X11'"
        issue_date = .data$X11,
        hunt_mig_birds = X12,
        ducks_bag = X13,
        geese_bag = X14,
        dove_bag = X15,
        woodcock_bag = X16,
        coots_snipe = X17,
        rails_gallinules = X18,
        cranes = X19,
        band_tailed_pigeon = X20,
        brant = X21,
        seaducks = X22,
        registration_yr = X23,
        email = X24
      ) %>%
      # Add a download key
      group_by(dl_date, dl_state) %>%
      mutate(dl_key = paste0("dl_", cur_group_id())) %>%
      ungroup() %>%
      # Filter to records if firstname, lastname, city of residence, state of
      # residence, or date of birth are missing
      filter(is.na(firstname)|is.na(lastname)|is.na(city)|is.na(state)|is.na(birth_date))

    if(plot == TRUE){
      if(nrow(missing_x) > 0){
        missing_plot <-
          missing_x %>%
          select(firstname, lastname, city, state, birth_date) %>%
          # Add an ID per row
          mutate(hunter_id = row_number()) %>%
          # Pivot the field names to long format
          pivot_longer(firstname:birth_date, names_to = "field") %>%
          # Pnly keep hunters' fields with NA values
          filter(is.na(value)) %>%
          # Set NA to 1 for plotting
          mutate(value = 1) %>%
          # Make a heat map
          ggplot(aes(x = field, y = as.factor(hunter_id), fill = value)) +
          geom_tile() +
          labs(y = "Hunter ID", x = "Data Field") +
          theme_classic() +
          theme(legend.position = "none")

        print(missing_plot)
      }
      else{
        message(
          paste0("No records detected with missing first name, last name, city",
                 " state, or date of birth.")
        )
      }
    }
    else{
      NULL
    }

    return(tidied_x)
  }

