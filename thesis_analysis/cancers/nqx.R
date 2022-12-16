"Convert mx rates to nqx"

nqx <- function(age, mx, ax, n, x) {
  mx <- mx[!is.na(age)]
  width = c(diff(age), Inf)
  ax[is.na(ax)] <- width/2
  mx[mx == 0] <- 1e-10
  
  idx <- age >= x & age <= x + n
  ax <- ax[idx]
  width <- width[idx]
  mx <- mx[idx]
  
  qx <- width * mx / (1 + (width - ax) * mx)
  
  qx[qx > 1] <- 0.99999
  
  px <- 1 - qx
  
  px <- matrix(px, nrow = length(unique(age[idx])))
  
  return(1 - apply(px, MARGIN = 2, FUN = prod))
}

