library(ggplot2)

snu <- read.csv("SNU.csv", sep = ",", na.strings = TRUE, stringsAsFactors = FALSE)

names(snu) <- tolower(names(snu))

snu$unicameral <- is.na(snu$unicameral)

percap_variables <- c(
  "lower.chamber.seats",
  "upper.chamber.seats",
  "district.gdp",
  "spending.1"
)

for (variable in percap_variables) {
  snu[, sprintf("%s.per.capita", variable)] <- snu[, variable] / snu[, "district.population"]
}

regression_variables <- sort(c(
  percap_variables,
  paste0(percap_variables, ".per.capita"),
  "district.population"
))

nice_names <- function(x) gsub("gdp", "GDP", gsub("\\.", " ", x))
# cap_first <- function(x) substr(x, 1, 1) <- toupper(substr(x, 1, 1))

names(snu)[names(snu) %in% regression_variables] <-
  sapply(regression_variables, nice_names, USE.NAMES = FALSE)
regression_variables <- sapply(regression_variables, nice_names, USE.NAMES = FALSE)

#' filters/highlights:
#' - unicameral?
#' - land area
#' - compare with/without capitals

scale_2sd <- function (x, center = FALSE, scale = TRUE) {
  if (center) x <- x - mean(x, na.rm = TRUE)
  if (scale) x <- x / (2 * sd(x, na.rm = TRUE))
  x
}

all_missing_or_same <- function (x) {
  all(is.na(x)) ||
    all(sapply(x[-1], FUN=function(z) identical(z, x[1]) ))
}

snu_model <- function(country, x, y, dat = snu) {
  dat <- dat[dat$country == country, ]
  y <- scale_2sd(dat[[y]])
  x <- scale_2sd(dat[[x]], center = TRUE)

  if (all_missing_or_same(x) || all_missing_or_same(y)) {
    out <- rep(NA, 6)
  } else {
    fit <- lm(y ~ x)
    out <- c(fit$coef[2], confint(fit, 2, .95), confint(fit, 2, .5), length(x))
  }
  
  names(out) <-  c("coef", "X2.5", "X97.5", "X25", "X75", "N")
  out
}

snu_fit <- function (x, y, dat = snu) {
  out <- as.data.frame(t(sapply(unique(dat$country), snu_model, x = x, y = y)))
  out$country <- row.names(out)
  out$country <- factor(out$country, out$country,
                        sprintf("%s \n(N = %s)", out$country, out$N))
  structure(out, x = x, y = y)
}

snu_coefplot <- function(snu_coefs) {
  g <- ggplot(snu_coefs) + geom_point(aes(x = coef, y = country), size = 3) +
    geom_segment(aes(x = X2.5, xend = X97.5, y = as.numeric(country), yend = as.numeric(country))) +
    geom_segment(aes(x = X25, xend = X75, y = as.numeric(country), yend = as.numeric(country)), size = 1.5) +
    geom_hline(aes(yintercept = as.numeric(country)),  linetype = "dotted") +
    geom_vline(xintercept = 0, linetype = "dashed") +
    xlab("Slope coefficient") + ylab("Country") +
    ggtitle(sprintf("Regression models of\n%s vs. %s", attr(snu_coefs, "y"), attr(snu_coefs, "x"))) +
    theme_classic() + theme(
      legend.position = "none"
    )
  
  plot(g)
#   g$layout[which(g$layout$name == "title"), c("l", "r")] <- c(1, max(g$layout$r))
#   plot.new()
#   grid.draw(g)
}

## for debugging/testing:
# rm(list=ls())
# x <- 5
# y <- 6
# snu_coefs <- snu_fit(x, y)
# snu_coefplot(snu_coefs)

# save.image(file = "snu.RData")

