# coursera-johnHopkins-rProgramming-week2-3
**R Programming by Johns Hopkins University - Week 2 - Assignment 3**

Part 1

A function named 'best' that takes two arguments: the 2-character abbreviated name of a state and an outcome name. It reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state. Hospitals that do not have data on a particular outcome are excluded from the set of hospitals when deciding the rankings.

Part 2

A function named 'rankhospital' that takes three arguments: the 2-character abbreviated name of a state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num). It reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital that has the ranking specified by the num argument. Hospitals that do not have data on a particular outcome are excluded from the set of hospitals when deciding the rankings.

Part 3

A function named 'rankall' that takes two arguments: an outcome (outcome) and a hospital rank. It reads the outcome-of-care-measures.csv file and returns a data frame containing the names of the hospitals that are the best in their respective states for 30-day heart attack death rates. Hospitals that do not have data on a particular outcome are not excluded from the set of hospitals when deciding the rankings. The first column in the data frame is named hospital,and the second column is named state.
