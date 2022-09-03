rankall <- function(outcome = "heart attack", num = "best") {
  ## Read outcome data
  outcomes <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
  
  state_index <- 7
  outcome_index <- 0
  
  if (outcome == "heart attack")
    outcome_index <- 11
  else if (outcome == "heart failure")
    outcome_index <- 17
  else if (outcome == "pneumonia")
    outcome_index <- 23
  else
    stop("invalid outcome")
  
  if ( num != "best" && num != "worst" && num%%1 != 0 ) stop("invalid num")
  
  outcomes_1 <- subset(outcomes,
                        select = c(2,         # column 2 is the name of the hospital
                                   7,         # column 7 is the name of the state
                                   outcome_index), 
                           stringsAsFactors = FALSE)
  
  outcomes_1[, 3] <- suppressWarnings (as.numeric(outcomes_1[, 3] ) )
  outcomes_1 <- na.omit(outcomes_1)
  
  outcomes_1 <- outcomes_1 [ order(outcomes_1[,3], outcomes_1[, 1]), ]
  states <- sort(unique(outcomes_1[, 2]))
  
  results <- data.frame(hospital=character(), state=character())
  
  for (st in states) {
    tmp <- outcomes_1[outcomes_1$State==st, ]
    if( num == "best" ) {
      hosp_st <- tmp[1,]$Hospital.Name
    } else if( num == "worst" ) {
      hosp_st <- lapply(tmp, tail, 1)$Hospital.Name
    } else {
      hosp_st <- tmp[num,]$Hospital.Name
    }
    
    results <- rbind(results, data.frame("hospital" = hosp_st, "state"=st))
  }
  
  results
  
}
