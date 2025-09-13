File: cali_2022_pbi.pbix 

Data Sources: 
- cleaned_cali_2022.csv → main dataset (loan applications, etc.)
- county_population_cali.csv → reference population data by county

Data Model:
- One-to-many relationship between county_name in cleaned_cali_2022 and county_population_cali
- Merged queries in Power Query to enrich loan data with county-level population

Transformations:
- Cleaned column names and data types
- Handled missing values (where applicable)
- Created calculated columns for population-based metrics

Visuals:
- Card showing county population (drillthrough-enabled)
- Loan approval trends by county
- Comparison of approval rates vs. population

Drillthrough Pages:
- Select a county (e.g., Alameda) to drill through and view specific population + loan approval breakdown

Notes on Usage:
- Open in Power BI Desktop → refresh if needed
- Use slicers/filters to navigate by year, county, or applicant demographics
- Hover on visuals for tooltips (approval rates, counts, etc.)
