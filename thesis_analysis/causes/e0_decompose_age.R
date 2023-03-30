"Calculate the contribution of each age group to a difference in life expectancy
at birth between two populations. The method used is due to Arriaga (1984) and is
detailed in Preston pp 64-65."

CalculateDiffTable <- function(lt1, lt2) {
  # If rates and sexes are provided, then the life table is calculated using
  # these inputs. Otherwise, the life tables of the two populations, lt1 and lt2,
  # must be provided. It returns a merged life table for the two populations,
  # used to calculate the contribution of each age group towards the change in
  # life expectancy in CalculateAgeContribution()
  stopifnot(lt1$age == lt2$age)
  data.frame(
    age = lt1$age,
    lx1 = lt1$lx,
    Lx1 = lt1$Lx,
    Tx1 = lt1$Tx,
    lx2 = lt2$lx,
    Lx2 = lt2$Lx,
    Tx2 = lt2$Tx
  )
}

CalculateAgeContribution <- function(dtbl) {
  # See Preston pp64-65 for details of calculations
  N <- nrow(dtbl)
  dtbl$Dx <- with(dtbl, lx1 / lx1[1] * (Lx2 / lx2 - Lx1 / lx1) +
    c(Tx2[2:N], NA) / lx1[1] * c(-diff(lx1 / lx2), NA))
  dtbl$Dx[N] <- with(
    dtbl,
    lx1[N] / lx1[1] * (Tx2[N] / lx2[N] - Tx1[N] / lx1[N])
  )
  dtbl$percent <- dtbl$Dx / sum(dtbl$Dx) * 100
  dtbl
}

DecomposeLifeExpDiff <- function(lt1, lt2) {
  # Takes either mortality rates and sexes for two populations (mx1, sex1,
  # mx2, sex2) or life tables for two populations (lt1, lt2) and returns
  # a data frame with the % contribution of each age group towards the change
  # in life expectancy at birth from population 1 to population 2
  dtbl <- CalculateDiffTable(lt1, lt2)
  CalculateAgeContribution(dtbl)
}
