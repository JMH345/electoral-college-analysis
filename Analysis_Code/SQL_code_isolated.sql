-- Assigns Electoral Votes based on popular vote remainders

CREATE TABLE RemVotes_Assigned AS

/* 
Determines how many Electoral Votes (Representative Electoral Votes for NE Style and all for Full Divide)
are still to be awarded by remainder for each method and state after intiate Electoral Votes awarded 
*/

WITH Remainder AS (
SELECT STATE, Num_Reps_Capped - SUM(CapEC_NE_CanVotes)as "CapEC_NE_CanRemVote", 
(Num_Reps_Capped + 2) - SUM(CapEC_Full_CanVotes) as "CapEC_Full_CanRemVote",
Num_Reps_Uncapped - SUM(UnCapEC_NE_CanVotes) as "UnCapEC_NE_CanRemVote", 
(Num_Reps_Uncapped + 2) - SUM(UnCapEC_Full_CanVotes) as "UnCapEC_Full_CanRemVote"
FROM LG_Elect
GROUP BY STATE
),

-- Joins number of remaining Electoral Votes to main table by method and state

LG_Remain AS (
SELECT LG_Elect.*, Remainder.CapEC_NE_CanRemVote, Remainder.CapEC_Full_CanRemVote,
Remainder.UnCapEC_NE_CanRemVote, Remainder.UnCapEC_Full_CanRemVote
FROM LG_Elect
LEFT JOIN Remainder
ON LG_Elect.State = Remainder.State
),

-- For all methods, ranks candidates in each state by remaining popular votes with 1 being the highest

Ranking AS (
SELECT *,
CAST(ROW_NUMBER() OVER (PARTITION BY STATE ORDER BY CapEC_NE_CanRemainder DESC, Candidate_Votes DESC) AS REAL) AS CapEC_NE_CanRemain_Rank,
CAST(ROW_NUMBER() OVER (PARTITION BY STATE ORDER BY CapEC_Full_CanRemainder DESC, Candidate_Votes DESC) AS REAL) AS CapEC_Full_CanRemain_Rank,
CAST(ROW_NUMBER() OVER (PARTITION BY STATE ORDER BY UnCapEC_NE_CanRemainder DESC, Candidate_Votes DESC) AS REAL) AS UnCapEC_NE_CanRemain_Rank,
CAST(ROW_NUMBER() OVER (PARTITION BY STATE ORDER BY UnCapEC_Full_CanRemainder DESC, Candidate_Votes DESC) AS REAL) AS UnCapEC_Full_CanRemain_Rank
FROM LG_Remain
)

/*
For each method, apportions remaining Electoral Votes of each state (one for each candidate) 
to the highest ranking candidates by popular vote remainder as new table RemVotes_Assigned
*/

SELECT
STATE,
Candidate_Name,
CASE
WHEN Ranking.CapEC_NE_CanRemain_Rank <= Ranking.CapEC_NE_CanRemVote
THEN 1 ELSE 0 END AS CapEC_NE_RemainAdd, 
CASE
WHEN Ranking.CapEC_Full_CanRemain_Rank <= Ranking.CapEC_Full_CanRemVote
THEN 1 ELSE 0 END AS CapEC_Full_RemainAdd, 
CASE
WHEN Ranking.UnCapEC_NE_CanRemain_Rank <= Ranking.UnCapEC_NE_CanRemVote
THEN 1 ELSE 0 END AS UnCapEC_NE_RemainAdd,
CASE
WHEN Ranking.UnCapEC_Full_CanRemain_Rank <= Ranking.UnCapEC_Full_CanRemVote
THEN 1 ELSE 0 END AS UnCapEC_Full_RemainAdd
FROM Ranking;




-- For each method, adds remainder Electoral Votes to previous candidate Electoral Vote totals by state as a new table

CREATE TABLE Rep_Vote_w_RemAdd
AS
Select LG_Elect.STATE, LG_Elect.FEC_ID, LG_Elect.Candidate_Name, LG_Elect.Candidate_Votes, LG_Elect.Num_Reps_Capped,
LG_Elect.Num_Reps_Uncapped,
CAST((LG_Elect.CapEC_NE_CanVotes + RemVotes_Assigned.CapEC_NE_RemainAdd) AS REAL) AS CapEC_NE_CanVote_ARem,
CAST((LG_Elect.CapEC_Full_CanVotes + RemVotes_Assigned.CapEC_Full_RemainAdd) AS REAL) AS CapEC_Full_CanVote_ARem, 
CAST((LG_Elect.UnCapEC_NE_CanVotes + RemVotes_Assigned.UnCapEC_NE_RemainAdd) AS REAL) AS UnCapEC_NE_CanVote_ARem, 
CAST((LG_Elect.UnCapEC_Full_CanVotes + RemVotes_Assigned.UnCapEC_Full_RemainAdd) AS REAL) AS UnCapEC_Full_CanVote_ARem
FROM LG_Elect
LEFT JOIN RemVotes_Assigned
ON LG_Elect.STATE = RemVotes_Assigned.STATE
AND LG_Elect.Candidate_Name = RemVotes_Assigned.Candidate_Name;

-- Senatorial Electoral Vote Assignment


CREATE TABLE Sen_ECvote_assigned AS

-- Ranks states' candidates by popular vote and initializes columns CapEC_Standard, UnCapEC_Standard, and SenNum with values of zero

SELECT *,
CAST(ROW_NUMBER() OVER (PARTITION BY STATE ORDER BY Candidate_Votes DESC) AS REAL) AS Sen_Rank,
CAST(0 AS REAL) AS CapEC_Standard,
CAST(0 AS REAL) AS UnCapEC_Standard,
CAST(0 AS REAL) AS SenNum
FROM Rep_Vote_w_RemAdd;

/* 
Gives state popular vote winner all state Electoral College Votes in Standard Electoral College method 
and two additional Senatorial Electoral College Votes for the NE Style Method
*/

UPDATE Sen_ECvote_assigned
SET
CapEC_Standard = Num_Reps_Capped + 2,
UnCapEC_Standard = Num_Reps_Uncapped + 2,
SenNum = 2
WHERE Sen_Rank = 1;


-- Totals Electoral College Votes for each methods and removes unneeded data for final comparisions with national popular vote

CREATE TABLE Total
AS
SELECT STATE, FEC_ID, Candidate_Name, Candidate_Votes, CAST((Num_Reps_Capped + 2) AS REAL) AS Capped_Num_State_EC_Votes,
CAST((Num_Reps_Uncapped + 2) AS REAL) AS UnCapped_Num_State_EC_Votes,
CapEC_Standard AS Capped_EC_Standard,
CAST((CapEC_NE_CanVote_ARem + SenNum) AS REAL) AS Capped_EC_NE_Candidate_Vote, 
CapEC_Full_CanVote_ARem AS Capped_EC_Full_Candidate_Vote, 
UnCapEC_Standard AS UnCapped_EC_Standard,
CAST((UnCapEC_NE_CanVote_ARem + SenNum) AS REAL) AS UnCapped_EC_NE_Candidate_Vote,
UnCapEC_Full_CanVote_ARem AS UnCapped_EC_Full_Candidate_Vote
FROM Sen_ECvote_assigned;



