## rankall function takes two arguments: an outcome (outcome) and a hospital rank.
## It reads the outcome-of-care-measures.csv file and returns a data frame containing the names 
## of the hospitals that are the best in their respective states for 30-day heart attack death rates.
## Hospitals that do not have data on a particular outcome are not excluded from the set of hospitals
## when deciding the rankings. The first column in the data frame is named hospital,and the second
## column is named state.

rankall <- function(outcome = NULL, num = "best") {
  ## Read outcome-of-care-measures data
  careMeasuresData <- read.csv("outcome-of-care-measures.csv", na.strings = 'Not Available', stringsAsFactors = FALSE)
  
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
  
  ## Reorder rows by State, Death.Rate and Hospital.Name, and ignore any moratility rate
  ## not available
  outcomeSubset <- arrange(outcomeSubset, State, Death.Rate, Hospital.Name)
  outcomeSubset <- filter(outcomeSubset, Death.Rate != 'Not Available')
  
  ## Aggregate outcomeSubset by State, choosing the row that corresponds to the num argument ( rank )
  outcomeRankByState <- aggregate(outcomeSubset, by = list(outcomeSubset$State), function(x) {
    if (!is.numeric(num)) {
      if (num == 'best') {
        num <- 1
      } else {
        if (num == 'worst') {
          num <- length(x)
        } else {
          stop("Invalid Num")
        }
      }
    }
    x[num]
  })
  
  ## Create the final result list with columns Hospital.Name and State, and rename them to:
  ##    Hospital.Name = hospital
  ##    State         = state
  bestHospitals <- outcomeRankByState[,c(2,3)]
  names(bestHospitals) <- c('hospital', 'state')
  
  bestHospitals
}