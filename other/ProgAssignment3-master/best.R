best <- function (state = "TX", outcome="heart attack") {
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
    
    state_outcome <- subset(outcomes, State==state, 
                            select = c(2, outcome_index),  # column 2 is the name of the hospital
                            stringsAsFactors = FALSE)
    
    state_outcome[, 2] <- suppressWarnings (as.numeric(state_outcome[, 2] ) )
    min_outcome <- min(state_outcome[, 2], na.rm = TRUE)
    
    best_hospitals <- subset(state_outcome, state_outcome[2] == min_outcome)
    hospital_names <- sort(best_hospitals[,1])
    hospital_names[1]
    
}