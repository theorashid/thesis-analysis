"Life expectancy decomposition."

library(here)
library(tidyverse)
library(abind)

source(here("thesis_analysis", "causes", "period_life_table.R"))
source(here("thesis_analysis", "causes", "e0_decompose_age.R"))

args <- lst(
  region = "LAD",
  sex = "female",
  model = "car_as_at",
  year1 = "2002",
  year2 = "2019"
)

death_rates <- read_rds(
  here(
    "data",
    "death_rates",
    str_c(args$region,"_", args$sex, "_", args$model, "_causes_scaled.rds")
  )
)

death_rates_total <- apply(death_rates, MARGIN = c(1, 2, 3, 4), FUN = sum) |>
  apply(MARGIN = c(1, 2, 3), FUN = mean)

death_rates <- apply(death_rates, MARGIN = c(1, 2, 3, 5), FUN = mean)

system.time(
  lt <- apply(
    X = death_rates_total,
    MARGIN = c(1, 2),
    FUN = PeriodLifeTable,
    age = c(c(0, 1), seq(5, 85, 5)),
    ax = rep(NA, 19),
    sex = 1
  )
)

lt1 <- lt[args$year1, ]
lt2 <- lt[args$year2, ]

dec <- lapply(
  seq_along(lt1),
  \(x)  DecomposeLifeExpDiff(lt1[[x]], lt2[[x]])
)

dec <- abind(dec, along = 3)
dec <- aperm(dec, c(3, 1, 2))

prop <- sweep(
  death_rates[args$year2, , , ] - death_rates[args$year1, , , ],
  c(1, 2),
  death_rates_total[args$year2, , ] - death_rates_total[args$year1, , ],
  "/"
)

Dx_cause <- sweep(prop, c(1, 2), dec[, , "Dx"], "*")
Dx_cause <- apply(Dx_cause, MARGIN = c(1, 3), sum)

write_rds(
  death_rates,
  here(
    "data",
    "life_table",
    str_c(args$region, "_", args$sex, "_", args$model, "_e0_decompose", args$year1, args$year2, ".rds")
  ),
)
