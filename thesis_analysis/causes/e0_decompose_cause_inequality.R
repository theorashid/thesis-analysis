"Life expectancy decomposition compared to top district."

library(here)
library(tidyverse)
library(abind)

source(here("thesis_analysis", "causes", "period_life_table.R"))
source(here("thesis_analysis", "causes", "e0_decompose_age.R"))

args <- lst(
  region = "LAD",
  sex = "male",
  model = "car_as_at",
  year = "2019"
)

death_rates <- read_rds(
  here(
    "data",
    "death_rates",
    str_c(args$region, "_", args$sex, "_", args$model, "_causes_scaled.rds")
  )
)

death_rates <- death_rates[args$year, , , , ]

death_rates_total <- apply(death_rates, MARGIN = c(1, 2, 3), FUN = sum) |>
  apply(MARGIN = c(1, 2), FUN = mean)

death_rates <- apply(death_rates, MARGIN = c(1, 2, 4), FUN = mean)

system.time(
  lt <- apply(
    X = death_rates_total,
    MARGIN = 1,
    FUN = PeriodLifeTable,
    age = c(c(0, 1), seq(5, 85, 5)),
    ax = rep(NA, 19),
    sex = 1
  )
)

lt_max_id <- lapply(lt, \(x) x$ex[1]) |>
  unlist() |>
  which.max() |>
  names()

print(lt_max_id)

lt_max <- lt |> pluck(lt_max_id)

dec <- lapply(
  seq_along(lt),
  \(x)  DecomposeLifeExpDiff(lt[[x]], lt_max)
)

dec <- abind(dec, along = 3)
dec <- aperm(dec, c(3, 1, 2))

prop <- sweep(
  sweep(death_rates, c(2, 3), death_rates[lt_max_id, , ], "-"),
  c(1, 2),
  sweep(death_rates_total, 2, death_rates_total[lt_max_id, ], "-"),
  "/"
)

Dx_cause <- sweep(prop, c(1, 2), dec[, , "Dx"], "*")
Dx_cause <- apply(Dx_cause, MARGIN = c(1, 3), sum)

write_rds(
  Dx_cause,
  here(
    "data",
    "life_table",
    str_c(args$region, "_", args$sex, "_", args$model, "_e0_decompose_inequality", args$year, ".rds")
  ),
)
