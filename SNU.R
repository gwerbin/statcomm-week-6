library(reshape2)

snu <- read.csv("SNU.csv", sep = ",", na.strings = TRUE)

names(snu) <- tolower(names(snu))

snu$unicameral <- is.na(snu$unicameral)

percap_variables <- c(
  "lower.chamber.seats",
  "upper.chamber.seats",
  "district.gdp",
  "spending.1"
)

for (variable in percap_variables) {
  snu[, sprintf("%s.percap", variable)] <- snu[, variable] / snu[, "district.population"]
}

regression_variables <- c(paste0(percap_variables, ".percap"), "district.population")

#' filters/highlights:
#' - unicameral?
#' - land area
#' - compare with/without capitals

scale_2sd <- function (x, center = FALSE, scale = TRUE) {
  if (center) x <- x - mean(x, na.rm = TRUE)
  if (scale) x <- x / (2 * sd(x, na.rm = TRUE))
  x
}

snu_model <- function (x, y, dat = snu) {
  out <- t(sapply(unique(dat$country), function(country) {
    dat <- dat[dat$country == country, ]
    y <- scale_2sd(dat[[y]])
    x <- scale_2sd(dat[[x]], center = TRUE)
    fit <- lm(y ~ x)
    c(fit$coef[2], confint(fit, 2, .95), confint(fit, 2, .5), length(x))
  }))
  colnames(out) <- c("coef", "X2.5", "X97.5", "X25", "X75", "N")
  out <- cbind(country = rownames(out), as.data.frame(out))
  out$country <- as.factor(paste(out$country, out$N, sep = "\nN = "))
  out
}

# remember to change the arguments
x <- regression_variables[5]
y <- regression_variables[4]
snu_coefs <- snu_model(x, y)

ggplot(snu_coefs) + geom_point(aes(x = coef, y = country), size = 3) +
  geom_segment(aes(x = X2.5, xend = X97.5, y = as.numeric(country), yend = as.numeric(country))) +
  geom_segment(aes(x = X25, xend = X75, y = as.numeric(country), yend = as.numeric(country)), size = 1.5) +
  geom_hline(aes(yintercept = as.numeric(country)),  linetype = "dotted") +
  ggtitle(sprintf("Coefficients of %s vs. %s", y, x))
  theme_classic() + theme(
    legend.position = "none"
  )
