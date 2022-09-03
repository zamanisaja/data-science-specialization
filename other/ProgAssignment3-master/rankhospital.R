rankhospital <- function (state = "TX", outcome = "heart attack", n = 1){
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
  else {
    stop("invalid outcome")
  }
  
  if (! state %in% outcomes$State)
    stop("invalid state")
  
  state_outcomes <- subset(outcomes, State==state, 
                          select = c(2, outcome_index),  # column 2 is the name of the hospital
                          stringsAsFactors = FALSE)
  state_outcomes[, 2] <- suppressWarnings (as.numeric(state_outcomes[, 2] ) )
  state_outcomes <- na.omit(state_outcomes)
  colnames(state_outcomes) <- c("Hospital.Name", "Rate")
  
  names <- state_outcomes [ order(state_outcomes[,2], state_outcomes[, 1]), ]$Hospital.Name
  
  if  (n == "best")
    n <- 1
  else if ( n == "worst")
    n <- length(names)
  
  names[n]
  
}