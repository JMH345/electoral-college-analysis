/*
Selected raw data from the original data sets is merged by joining
 the General Election data with the proper apportionment data for that year.
*/

-- 2008_General_Election_2000_apportionment_combination

CREATE TABLE Elect_2008_comb
AS
SELECT *
FROM Gen_Elect_Results_2008_csv
LEFT JOIN "2000_appro_table_csv"
ON Gen_Elect_Results_2008_csv.State = "2000_appro_table_csv".State;

-- 2012_General_Election_2010_apportionment_combination

CREATE TABLE Elect_2012_comb
AS
SELECT *
FROM Gen_Elect_Results_2012_csv
LEFT JOIN "2010_appro_table_csv"
ON Gen_Elect_Results_2012_csv.State = "2010_appro_table_csv".State;

-- 2016_General_Election_2010_apportionment_combination

CREATE TABLE Elect_2016_comb
AS
SELECT *
FROM Gen_Elect_Results_2016_csv
LEFT JOIN "2010_appro_table_csv"
ON Gen_Elect_Results_2016_csv.State = "2010_appro_table_csv".State;

-- 2020_General_Election_2010_apportionment_combination

CREATE TABLE Elect_2020_comb
AS
SELECT *
FROM Gen_Elect_Results_2020_csv
LEFT JOIN "2010_appro_table_csv"
ON Gen_Elect_Results_2020_csv.State = "2010_appro_table_csv".State;

/* 
The total number of state votes are removed as a separate row and joined back as a new column for each state 
*/


-- Reformate total state votes 2008

CREATE TABLE Cleaned_Elect_2008
AS

-- Takes the total number of votes by state from separated rows
WITH TOTAL_V_2008 AS (
SELECT STATE, `TOTAL VOTES #`
FROM Elect_2008_comb
WHERE `TOTAL VOTES #` IS NOT NULL
),

-- Adds total number of votes by state as a new column by state
Elect_2008_ALL AS (
SELECT Elect_2008_comb.*, TOTAL_V_2008.State as "state2", TOTAL_V_2008.`TOTAL VOTES #` as "VOTE_TOTALS"
FROM Elect_2008_comb
LEFT JOIN TOTAL_V_2008
ON Elect_2008_comb.State = TOTAL_V_2008.State
)

-- Keeps only rows that display candidate data
Select *
FROM Elect_2008_ALL
WHERE `LAST NAME;  FIRST` IS NOT NULL;



-- Reformate total state votes 2012

CREATE TABLE Cleaned_Elect_2012
AS

-- Takes the total number of votes by state from separated rows
WITH TOTAL_V_2012 AS (
SELECT STATE, `TOTAL VOTES #`
FROM Elect_2012_comb
WHERE `TOTAL VOTES #` IS NOT NULL
),

-- Adds total number of votes by state as a new column by state
Elect_2012_ALL AS (
SELECT Elect_2012_comb.*, TOTAL_V_2012.State as "state2", TOTAL_V_2012.`TOTAL VOTES #` as "VOTE_TOTALS"
FROM Elect_2012_comb
LEFT JOIN TOTAL_V_2012
ON Elect_2012_comb.State = TOTAL_V_2012.State
)

-- Keeps only rows that display candidate data
Select *
FROM Elect_2012_ALL
WHERE `LAST NAME;  FIRST` IS NOT NULL;


-- Reformate total state votes 2016


CREATE TABLE Cleaned_Elect_2016 
AS

-- Takes the total number of votes by state from separated rows
WITH TOTAL_V_2016 AS (
SELECT STATE, `TOTAL VOTES #`
FROM Elect_2016_comb
WHERE `TOTAL VOTES #` IS NOT NULL
),

-- Adds total number of votes by state as a new column by state
Elect_2016_ALL AS (
SELECT Elect_2016_comb.*, TOTAL_V_2016.State as "state2", TOTAL_V_2016.`TOTAL VOTES #` as "VOTE_TOTALS"
FROM Elect_2016_comb
LEFT JOIN TOTAL_V_2016
ON Elect_2016_comb.State = TOTAL_V_2016.State
)

-- Keeps only rows that display candidate data
Select *
FROM Elect_2016_ALL
WHERE `LAST NAME;  FIRST` IS NOT NULL;


-- Reformate total state votes 2020


CREATE TABLE Cleaned_Elect_2020
AS

-- Takes the total number of votes by state from separated rows
WITH TOTAL_V_2020 AS (
SELECT STATE, `TOTAL VOTES #`
FROM Elect_2020_comb
WHERE `TOTAL VOTES #` IS NOT NULL
),

-- Adds total number of votes by state as a new column by state
Elect_2020_ALL AS (
SELECT Elect_2020_comb.*, TOTAL_V_2020.State as "state2", TOTAL_V_2020.`TOTAL VOTES #` as "VOTE_TOTALS"
FROM Elect_2020_comb
LEFT JOIN TOTAL_V_2020
ON Elect_2020_comb.State = TOTAL_V_2020.State
)

-- Keeps only rows that display candidate data
Select *
FROM Elect_2020_ALL
WHERE `LAST NAME;  FIRST` IS NOT NULL;

/* 
Data prepared to be transferred for analysis in standardized format
*/

-- Selects and formats data need for analysis transfer table 2008

CREATE TABLE Transfer_table_2008 AS
SELECT `STATE`, `FEC ID` AS "FEC_ID", `LAST NAME;  FIRST` AS "Candidate_Name", `GENERAL RESULTS` AS "Candidate_Votes",
`Apportionment population` AS "Apportionment_pop",`"` AS "Num_Reps_Capped", VOTE_TOTALS AS "State_Vote_Total"
FROM Cleaned_Elect_2008;

-- Selects and formats data need for analysis transfer table 2012

CREATE TABLE Transfer_table_2012 AS
SELECT `STATE`, `FEC ID` AS "FEC_ID", `LAST NAME;  FIRST` AS "Candidate_Name", `GENERAL RESULTS` AS "Candidate_Votes",
`2010: Apportionment population` AS "Apportionment_pop",`"2010:` AS "Num_Reps_Capped", VOTE_TOTALS AS "State_Vote_Total"
FROM Cleaned_Elect_2012;

-- Selects and formats data need for analysis transfer table 2016

CREATE TABLE Transfer_table_2016 AS
SELECT `STATE`, `FEC ID` AS "FEC_ID", `LAST NAME;  FIRST` AS "Candidate_Name", `GENERAL RESULTS` AS "Candidate_Votes",
`2010: Apportionment population` AS "Apportionment_pop",`"2010:` AS "Num_Reps_Capped", VOTE_TOTALS AS "State_Vote_Total"
FROM Cleaned_Elect_2016;

-- Selects and formats data need for analysis as transfer table 2020

CREATE TABLE Transfer_table_2020 AS
SELECT `STATE`, `FEC ID` AS "FEC_ID", `LAST NAME;  FIRST` AS "Candidate_Name", `GENERAL RESULTS` AS "Candidate_Votes",
`2010: Apportionment population` AS "Apportionment_pop",`"2010:` AS "Num_Reps_Capped", VOTE_TOTALS AS "State_Vote_Total"
FROM Cleaned_Elect_2020;