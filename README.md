Changing Election Outcomes: Comparing Electoral College Methods To The Popular Vote

A data analytics project evaluating how accurately different Electoral College allocation methods reflect the U.S. popular vote.

📊 Project Overview

This project analyzes U.S. presidential elections (2008–2020) to measure how different Electoral College systems align with the popular vote.

Three allocation methods are used:

Winner-Take-All (current system)
Full Divide (proportional allocation)
Nebraska-like (hybrid system)

Each method is tested in the standard "Capped" Electoral College and "Uncapped" Electoral College with differing amounts of Representatives affecting the number of Electoral College Votes for each state.

🧰 Tools & Technologies
Python (Pandas) – Determining representative allocation and intial Electoral College Vote allocation
SQL (SQLite) – remainder and Senatorial Electoral College Vote allocation logic and ranking
Excel – initial data structuring and validation
Tableau – data visualization

🗂️ Data Sources
U.S. Census Bureau (apportionment data)
Federal Election Commission (election results)

⚙️ Methodology
Cleaned and standardized raw election and population data
Built data pipeline from Excel/SQLite → Python → SQLite
Calculated number of representatives for Uncapped Electoral College and apportionment of Washington D.C. based on U.S. Constitutional constraints
Used SQL window functions (PARTITION BY, ranking) to allocate electoral votes by state and candidate


📈 Key Findings
Winner-Take-All consistently distorts Electoral College outcomes relative to the popular vote
Proportional methods (Full Divide, Nebraska-like) produce results much closer to actual vote percentages
Under methods other than the Standard Winner-Take-All, some elections (e.g., 2016) would not produce a majority winner, shifting the decision to Congress
Third-party candidates receive meaningful representation under other than the Standard Winner-Take-All system


🚀 How to Run
Clone the repository
Open the Python notebooks
Run data cleaning and transformation steps
Execute Python and SQL scripts for vote allocation
Review outputs and visualizations

💡 Key Skills Demonstrated
Data cleaning and transformation
SQL analytics and window functions
Data modeling and scenario analysis
Handling real-world data inconsistencies
Translating complex analysis into clear insights