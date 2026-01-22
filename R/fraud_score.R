#' Fraud Score Detection
#'
#' Detects potential data manipulation in numeric variables using
#' digit preference, entropy collapse, smoothness, and time-pattern analysis.
#'
#' The function automatically detects a time or index column if present.
#'
#' @param data A data frame containing numeric variables and an optional
#'   time or index column.
#'
#' @return A data frame summarizing fraud indicators and risk levels
#'   for each numeric variable.
#'
#' @export
fraud_score <- function(data) {

  if (!is.data.frame(data)) {
    stop("Input must be a data.frame.")
  }

  # ---------- 1. Detect Time Column ----------
  time_candidates <- c(
    "bulan", "kako", "waktu", "period", "tanggal", "month", "day", "year",
    "time", "date", "year", "nomor", "id", "kode", "timestamps"
  )

  time_match <- intersect(tolower(names(data)), time_candidates)

  if (length(time_match) > 0) {
    time_col <- names(data)[tolower(names(data)) == time_match[1]]
    t_raw <- data[[time_col]]
    t <- if (is.numeric(t_raw)) t_raw else seq_len(nrow(data))
  } else {
    t <- seq_len(nrow(data))
    time_col <- "(index)"
  }

  # ---------- 2. Detect Numeric Columns ----------
  numeric_cols <- names(data)[vapply(data, is.numeric, logical(1))]
  value_cols <- setdiff(numeric_cols, time_col)

  if (length(value_cols) == 0) {
    stop("No numeric columns available for analysis.")
  }

  results <- list()

  # ---------- 3. Loop per Variable ----------
  for (col in value_cols) {

    x_raw <- data[[col]]
    valid <- complete.cases(x_raw, t)
    x <- x_raw[valid]
    t_use <- t[valid]

    if (length(x) < 10 || length(unique(x)) < 5) next

    # ===== 1. Digit Preference =====
    last_digit <- abs(round(x)) %% 10
    digit_score <- max(prop.table(table(last_digit)))

    # ===== 2. Entropy Forensics =====
    dx <- diff(x)
    ddx <- diff(dx)

    entropy_norm <- function(v) {
      v <- v[!is.na(v)]
      if (length(v) < 5 || length(unique(v)) < 2) return(0)
      p <- prop.table(table(v))
      -sum(p * log(p)) / log(length(v))
    }

    e_dx  <- entropy_norm(dx)
    e_ddx <- entropy_norm(ddx)

    benford_expected <- log10(1 + 1 / (1:9))
    fd_dx <- abs(dx[dx != 0])
    first_digit <- as.numeric(substr(fd_dx, 1, 1))
    obs <- prop.table(table(first_digit))
    obs <- obs[names(benford_expected)]
    obs[is.na(obs)] <- 0
    benford_dev <- sum(abs(obs - benford_expected)) / 2

    entropy_score <- mean(c(
      1 - e_dx,
      1 - e_ddx,
      min(1, benford_dev * 2)
    ))

    # ===== 3. Smoothness =====
    sd_diff <- stats::sd(dx, na.rm = TRUE)
    smooth_score <- ifelse(is.na(sd_diff) || sd_diff == 0,
                           1, min(1, 1 / sd_diff))

    # ===== 4. Time Pattern (R-squared) =====
    r2 <- tryCatch({
      if (is.na(sd_diff) || sd_diff == 0) 1
      else summary(stats::lm(x ~ t_use))$r.squared
    }, error = function(e) 0.5)

    # ===== 5. Final Fraud Score =====
    final_score <- mean(c(digit_score, entropy_score, smooth_score, r2))
    percentage <- round(final_score * 100, 1)

    risk_level <- if (final_score < 0.3) {
      "LOW"
    } else if (final_score < 0.6) {
      "MEDIUM"
    } else {
      "HIGH"
    }

    message(
      paste0(
        "Variable '", col,
        "' shows a potential manipulation score of ",
        percentage, "% - Risk level: ", risk_level
      )
    )

    results[[col]] <- data.frame(
      variable = col,
      fraud_score = round(final_score, 3),
      fraud_percent = percentage,
      risk_level = risk_level,
      digit_preference = round(digit_score, 3),
      entropy_forensic = round(entropy_score, 3),
      smoothness = round(smooth_score, 3),
      pattern_r2 = round(r2, 3),
      time_reference = time_col,
      stringsAsFactors = FALSE
    )
  }

  invisible(do.call(rbind, results))
}
