import pandas as pd
import sqlite3


Year_list = [("Analysis_2008.db",'select * from Transfer_Table_2008'), ("Analysise_2012.db",'select * from Transfer_Table_2012'),("Analysis_2016.db",'select * from Transfer_Table_2016'), ("Analysis_2020.db",'select * from Transfer_Table_2020')]

for table_year, query_year in Year_list:

    dbfile = "Data\Cleaning_Process_and_Cleaned_Data\Cleaning_process.db"
    dbfile2 = table_year

    con = sqlite3.connect(dbfile)


    DF = pd.read_sql_query(query_year, con)

    DF[["Apportionment_pop", "Candidate_Votes", "State_Vote_Total"]] = DF[["Apportionment_pop", "Candidate_Votes", "State_Vote_Total"]].apply(pd.to_numeric)

    # Electoral College Capped
    # Assigns 1 Electoral Vote for Washington D.C. null values

    DF["Num_Reps_Capped"] = DF["Num_Reps_Capped"].fillna(1)

    # Uncapped Electoral College
    # Uses quotient of apportionment population division to assign Rep. Electoral Votes
    # Assigns the lowest number of Electoral Votes for a state to Washington D.C. null values

    DF = DF.assign(Num_Reps_Uncapped=DF["Apportionment_pop"] // 30000)

    DF["Num_Reps_Uncapped"] = DF["Num_Reps_Uncapped"].fillna(DF["Num_Reps_Uncapped"].min())

    # Capped EC NE Style
    # Calculates the number of popular votes needed for an Electoral Vote,
    # the number of Electoral Votes for each candidate, 
    # and the remainder of popular votes for each candidate

    DF = DF.assign(CapEC_NE_VotePop=DF["State_Vote_Total"] / DF["Num_Reps_Capped"])
    DF = DF.assign(CapEC_NE_CanVotes=DF["Candidate_Votes"] // DF["CapEC_NE_VotePop"])
    DF = DF.assign(CapEC_NE_CanRemainder=DF["Candidate_Votes"] % DF["CapEC_NE_VotePop"])

    # Capped EC Full Divide
    # Calculates the number of popular votes needed for an Electoral Vote,
    # the number of Electoral Votes for each candidate, 
    # and the remainder of popular votes for each candidate

    DF = DF.assign(CapEC_Full_VotePop=DF["State_Vote_Total"] / (DF["Num_Reps_Capped"] + 2))
    DF = DF.assign(CapEC_Full_CanVotes=DF["Candidate_Votes"] // DF["CapEC_Full_VotePop"])
    DF = DF.assign(CapEC_Full_CanRemainder=DF["Candidate_Votes"] % DF["CapEC_Full_VotePop"])

    # Uncapped EC NE style
    # Calculates the number of popular votes needed for an Electoral Vote,
    # the number of Electoral Votes for each candidate, 
    # and the remainder of popular votes for each candidate

    DF = DF.assign(UnCapEC_NE_VotePop=DF["State_Vote_Total"] / DF["Num_Reps_Uncapped"])
    DF = DF.assign(UnCapEC_NE_CanVotes=DF["Candidate_Votes"] // DF["UnCapEC_NE_VotePop"])
    DF = DF.assign(UnCapEC_NE_CanRemainder=DF["Candidate_Votes"] % DF["UnCapEC_NE_VotePop"])

    # Uncapped EC full divide
    # Calculates the number of popular votes needed for an Electoral Vote,
    # the number of Electoral Votes for each candidate, 
    # and the remainder of popular votes for each candidate

    DF = DF.assign(UnCapEC_Full_VotePop=DF["State_Vote_Total"] / (DF["Num_Reps_Uncapped"] + 2))
    DF = DF.assign(UnCapEC_Full_CanVotes=DF["Candidate_Votes"] // DF["UnCapEC_Full_VotePop"])
    DF = DF.assign(UnCapEC_Full_CanRemainder=DF["Candidate_Votes"] % DF["UnCapEC_Full_VotePop"])

    con2 = sqlite3.connect(dbfile2)
    cursor = con2.cursor()

    DF.to_sql('LG_Elect', con2, if_exists='replace', index=False)
    con.close()