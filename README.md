Electoral College Systems Analysis

A data analytics project evaluating how accurately different Electoral College allocation methods reflect the U.S. popular vote.

📊 Project Overview

This project analyzes U.S. presidential elections (2008–2020) to measure how different Electoral College systems align with the popular vote.

I built and compared three allocation methods:

Winner-Take-All (current system)
Full Divide (proportional allocation)
Nebraska-like (hybrid system)

Each method was tested under both capped and uncapped representation scenarios.

🧰 Tools & Technologies
Python (Pandas) – data cleaning and transformation
SQL (SQLite) – vote allocation logic and ranking
Excel – initial data structuring and validation
Tableau – data visualization
🗂️ Data Sources
U.S. Census Bureau (apportionment data)
Federal Election Commission (election results)
⚙️ Methodology
Cleaned and standardized raw election and population data
Built data pipeline from Excel → Python → SQLite
Used SQL window functions (PARTITION BY, ranking) to allocate electoral votes by state
Handled edge cases such as:
District of Columbia apportionment
Rounding inconsistencies between Python and SQL
📈 Key Findings
Winner-Take-All consistently distorts Electoral College outcomes relative to the popular vote
Proportional methods (Full Divide, Nebraska-like) produce results much closer to actual vote percentages
Under proportional systems, some elections (e.g., 2016) would likely not produce a majority winner, shifting the decision to Congress
Third-party candidates receive meaningful representation under non-Winner-Take-All systems
📊 Example Output

(Include screenshots of your graphs here)

🚀 How to Run
Clone the repository
Open the Python notebooks
Run data cleaning and transformation steps
Execute SQL scripts for vote allocation
Review outputs and visualizations
💡 Key Skills Demonstrated
Data cleaning and transformation
SQL analytics and window functions
Data modeling and scenario analysis
Handling real-world data inconsistencies
Translating complex analysis into clear insights