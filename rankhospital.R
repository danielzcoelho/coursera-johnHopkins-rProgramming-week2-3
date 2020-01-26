## rankhospital function takes three arguments: the 2-character abbreviated name of a state (state),
## an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
## It reads the outcome-of-care-measures.csv file and returns a character vector with the name of the
## hospital that has the ranking specified by the num argument. Hospitals that do not have data on
## a particular outcome are excluded from the set of hospitals when deciding the rankings.

rankhospital <- function(state = NULL, outcome = NULL, num = "best") {
  ## Read outcome-of-care-measures data
  careMeasuresData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  #Defining default value for state
  if (is.null(state)) {
    state <- 'ZZ'
  }
  
  #Defining default value for outcome
  if (is.null(outcome)) {
    outcome <- 'whatever'
  }
  
  ## Check if outcome is valid, and create a subset of careMeasuresData containing only 3 columns:
  ##   1 - Hospital.Name
  ##   2 - State
  ##   3 - The specific column related to the outcome argument
  ##       heart attack  = Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  ##       heart failure = Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
  ##       pneumonia     = Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
  if (outcome == 'heart attack') {
    outcomeSubset <- select(careMeasuresData, c(2, 7, 11))
    outcomeSubset <- rename(outcomeSubset, Death.Rate = Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
  } else {
    if (outcome == 'heart failure') {
      outcomeSubset <- select(careMeasuresData, c(2, 7, 17))
      outcomeSubset <- rename(outcomeSubset, Death.Rate = Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
    } else {
      if (outcome == 'pneumonia') {
        outcomeSubset <- select(careMeasuresData, c(2, 7, 23))
        outcomeSubset <- rename(outcomeSubset, Death.Rate = Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
      } else {
        stop("Invalid Outcome")
      }
    }
  }
  
  ## Check if state is valid, and apply a filter in outcomeSubset based on the state argument, and
  ## ignoring any mortality rate not available
  outcomeSubsetDim <- dim(filter(outcomeSubset, State == state))
  
  if (outcomeSubsetDim[1] == 0) {
    stop("Invalid State")
  } else {
    outcomeSubset <- filter(outcomeSubset, State == state & Death.Rate != 'Not Available')
  }
  
  ## Reorder rows by Death.Rate and Hospital.Name
  outcomeSubset <- arrange(outcomeSubset, as.numeric(Death.Rate), Hospital.Name)
  
  ## Return hospital name in that state with the given rank
  if (num == 'best') {
    outcomeSubset$Hospital.Name[1]
  } else {
    if (num == 'worst') {
      outcomeSubset$Hospital.Name[dim(outcomeSubset)[1]]
    } else {
      outcomeSubset$Hospital.Name[num]
    }
  }
}