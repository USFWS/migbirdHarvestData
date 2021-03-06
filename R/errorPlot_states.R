#' Plot errors by state
#'
#' Create a bar plot of errors by state, either by count or proportion.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom tidyr separate
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr rename
#' @importFrom dplyr filter
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr ungroup
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_text
#' @importFrom stats reorder
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 expansion
#' @importFrom ggplot2 theme_classic
#' @importFrom ggplot2 element_text
#'
#' @param x A proofed data table created by \code{\link{proof}}
#' @param threshold Optional. A decimal value above which error proportions should be plotted.
#'
#' @author Abby Walter, \email{abby_walter@@fws.gov}
#' @references \url{https://github.com/USFWS/migbirdHarvestData}
#'
#' @export

errorPlot_states <-
  function(x, threshold = NA) {

    if(is.na(threshold)){

      # Proportion plot: no threshold specified

      state_plot <-
        # Suppress warning: "Expected 25 pieces. Missing pieces filled with `NA`
        # in ... rows". We start by splitting errors for plotting purposes; if
        # there are less than the full amount of errors in a row, the warning
        # happens.
        suppressWarnings(
          # Suppress message from summarize:
          # "`summarise()` ungrouping output (override with `.groups` argument)"
          suppressMessages(
            x %>%
              select(errors, dl_state) %>%
              # Pull errors apart, delimited by hyphens
              separate(errors, into = as.character(c(1:25)), sep = "-") %>%
              # Transform errors into a single column
              pivot_longer(1:25, names_to = "name") %>%
              select(-name) %>%
              rename(errors = value) %>%
              filter(!is.na(dl_state)) %>%
              group_by(dl_state) %>%
              # Count number of correct and incorrect values
              summarize(
                count_errors = sum(!is.na(errors)),
                count_correct = sum(is.na(errors))) %>%
              ungroup() %>%
              # Calculate the proportion
              mutate(
                proportion = count_errors / (count_errors + count_correct)) %>%
              # Plot
              ggplot() +
              geom_bar(aes(
                y = proportion,
                x = reorder(dl_state, proportion)),
                stat = "identity") +
              geom_text(
                aes(
                  y = proportion,
                  x = reorder(dl_state, proportion),
                  label = count_errors,
                  angle = 90),
                vjust = 0.2, hjust = -0.2) +
              labs(
                x = "State",
                y = "Errors (proportion)",
                title = "Error proportion by state") +
              scale_y_continuous(expand = expansion(mult = c(-0, 0.3))) +
              theme_classic() +
              theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
          )
        )
        }
    else{

      # Proportion plot: threshold specified

      state_tbl <-
        # Suppress warning: "Expected 25 pieces. Missing pieces filled with `NA`
        # in ... rows". We start by splitting errors for plotting purposes; if
        # there are less than the full amount of errors in a row, the warning
        # happens.
        suppressWarnings(
          # Suppress message from summarize:
          # "`summarise()` ungrouping output (override with `.groups` argument)"
          suppressMessages(
            x %>%
              select(errors, dl_state) %>%
              # Pull errors apart, delimited by hyphens
              separate(errors, into = as.character(c(1:25)), sep = "-") %>%
              # Transform errors into a single column
              pivot_longer(1:25, names_to = "name") %>%
              select(-name) %>%
              rename(errors = value) %>%
              filter(!is.na(dl_state)) %>%
              group_by(dl_state) %>%
              # Count number of correct and incorrect values
              summarize(
                count_errors = sum(!is.na(errors)),
                count_correct = sum(is.na(errors))) %>%
              ungroup() %>%
              # Calculate the proportion
              mutate(
                proportion = count_errors / (count_errors + count_correct)) %>%
              # Keep only the states with more than specified error percentage
              filter(proportion >= threshold)
            )
          )

      if(nrow(state_tbl == 0)){

        # If the threshold was set too high, return a message that says so

        message("Threshold too great; no data to plot. Reduce threshold value.")}

      else{

        # If the threshold wasn't set too high, make a plot

        state_plot <-
          ggplot() +
          geom_bar(aes(
            y = proportion,
            x = reorder(dl_state, proportion)),
            stat = "identity") +
          geom_text(
            aes(
              y = proportion,
              x = reorder(dl_state, proportion),
              label = count_errors,
              angle = 90),
            vjust = 0.2, hjust = -0.2) +
          labs(
            x = "State",
            y = "Errors (proportion)",
            title =
              paste0(
                "Error proportion by state (> ",
                as.character(threshold),
                ")")) +
          scale_y_continuous(expand = expansion(mult = c(-0, 0.3))) +
          theme_classic() +
          theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
      }
    }

    return(state_plot)

  }
