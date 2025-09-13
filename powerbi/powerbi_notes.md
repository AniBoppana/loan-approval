File: cali_2022_pbi.pbix

[Dashboard](dashboard_screenshot.png)

Data Sources: 
- cleaned_cali_2022.csv: main dataset
- county_population_cali.csv: reference population data by county

Data Model:
- One-to-many relationship between county_name in cleaned_cali_2022 and county_population_cali
- Merged queries in Power Query to enrich loan data with county-level population

Transformations:
- Cleaned column names and data types
- Handled missing values (where applicable)
- Created calculated columns for population-based metrics

Visuals:
- Bar chart of loan approval rate by county in descending order
- Small multiples bar chart of interest rate by race and gender
- Interactive map with county dropdown selection and drillthrough
- Tooltip for loan amount by purpose (refinancing vs. home purchase)

Drillthrough Page:
- Select a county (e.g., Los Angeles) to drill through and view breakdown with the following:
  - Scatterplot of loan amount by property value
  - Card with total population 
  - Card with number of loans
  - Loan amount by race donut chart
  - Filled area chart of interest rate by debt-to-income ratio
  - Gauge with average county approval rate compared to state approval rate

Notes on Usage:
- Open in Power BI Desktop
- Click on visuals to sort page by county or applicant demographics
- Hover on visuals for tooltips and right click for drillthroughs
