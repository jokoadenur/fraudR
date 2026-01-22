#' Plot Fraud Signature
#'
#' Visualizes forensic patterns of a numeric variable, including
#' time trends, digit preference, change distribution, and entropy collapse.
#'
#' @param data A data frame containing the variable of interest.
#' @param variable A character string specifying the numeric variable to plot.
#'
#' @export
plot_fraud_signature <- function(data, variable) {

  if (!variable %in% names(data)) {
    stop("Variable not found in the data.")
  }

  x <- data[[variable]]
  if (!is.numeric(x)) {
    stop("Selected variable must be numeric.")
  }

  time_candidates <- c(
    "bulan", "kako", "waktu", "period", "tanggal", "month", "day", "year",
    "time", "date", "year", "nomor", "id", "kode", "timestamps"
  )

  time_match <- intersect(tolower(names(data)), time_candidates)

  if (length(time_match) > 0) {
    time_col <- names(data)[tolower(names(data)) == time_match[1]]
    t <- data[[time_col]]
    if (!is.numeric(t)) t <- seq_along(x)
  } else {
    t <- seq_along(x)
  }

  valid <- complete.cases(x, t)
  x <- x[valid]
  t <- t[valid]

  dx <- diff(x)

  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))

  graphics::par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))

  graphics::plot(
    t, x, type = "b", pch = 19,
    main = "Time Pattern",
    xlab = "Time", ylab = variable
  )
  graphics::abline(stats::lm(x ~ t), col = "red", lwd = 2)

  last_digit <- abs(round(x)) %% 10
  graphics::barplot(
    prop.table(table(last_digit)),
    main = "Last Digit Distribution",
    xlab = "Digit", ylab = "Proportion"
  )

  graphics::hist(
    dx, breaks = 20,
    main = "First Difference Distribution",
    xlab = "\u0394 value", col = "gray"
  )

  entropy_norm <- function(v) {
    v <- v[!is.na(v)]
    if (length(v) < 5 || length(unique(v)) < 2) return(0)
    p <- prop.table(table(v))
    -sum(p * log(p))
  }

  entropy_values <- c(
    level = entropy_norm(x),
    diff1 = entropy_norm(dx),
    diff2 = entropy_norm(diff(dx))
  )

  graphics::barplot(
    entropy_values,
    main = "Entropy Collapse",
    ylab = "Entropy",
    col = c("steelblue", "orange", "red")
  )
}
