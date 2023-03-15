"Convert cause-specific death rates to mean age at death."

library(here)
library(tidyverse)
library(tidync)

args <- lst(
  region = "LAD",
  sex = "female",
  model = "car_as_at"
)

nc <- tidync(
  here(
    "data",
    "death_rates",
    str_c(args$region, "_", args$sex, "_", args$model, "_cancers.nc")
  )
)

death_rates <- nc |> hyper_array(force = TRUE)
death_rates <- death_rates$`__xarray_dataarray_variable__`

midpoints <- c(c(0, 1), seq(5, 85, 5))
midpoints <- midpoints + c(diff(midpoints) / 2, 5)

population <- tidync(
  here(
    "data",
    "population",
    str_c(args$region, "_", args$sex, "_population.nc")
  )
)

population <- population |> hyper_array(force = TRUE)
population <- population$population

deaths <- sweep(death_rates, c(1, 2, 3), population, "*")

mean_age_death <- apply(
  sweep(deaths, 3, midpoints, "*")[, , 1:17, , ],
  c(1, 2, 4, 5),
  sum
) / apply(deaths[, , 1:17, , ], c(1, 2, 4, 5), sum)

dimnames(mean_age_death) <- list(
  year = hyper_transforms(nc)$year$year,
  LAD = hyper_transforms(nc)$LAD$LAD,
  sample = hyper_transforms(nc)$sample$index,
  cause = hyper_transforms(nc)$cause$cause
)

write_rds(
  mean_age_death,
  here("data", "life_table", str_c(args$region, "_", args$sex, "_", args$model, "_cancers_mean_age_death.rds")),
)
