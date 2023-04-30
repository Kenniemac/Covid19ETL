# total confirmed, death, and recovered cases
SELECT SUM("Confirmed") AS Total_Confirmed, 
SUM("Deaths") AS Total_Deaths, 
SUM("Recovered") AS Total_Recovered
FROM covid_19_data

# total confirmed, deaths and recovered cases for the first quarter
SELECT 
EXTRACT(year FROM "ObservationDate") as year,
SUM("Confirmed") AS Total_Confirmed, 
SUM("Deaths") AS Total_Deaths, 
SUM("Recovered") AS Total_Recovered
FROM covid_19_data
WHERE EXTRACT(year FROM "ObservationDate") IN (2019, 2020) 
AND EXTRACT(quarter FROM "ObservationDate") = 1
GROUP BY year
ORDER BY year

# summary of all the records
SELECT "Country", 
SUM("Confirmed") AS Total_Confirmed, 
SUM("Deaths") AS Total_Deaths, 
SUM("Recovered") AS Total_Recovered
FROM covid_19_data
GROUP BY "Country"

# percentage increase in the number of death cases from 2019 to 2020
SELECT 
(SUM(CASE WHEN EXTRACT(year FROM "ObservationDate") = 2020 THEN "Deaths" ELSE 0 END) - 
SUM(CASE WHEN EXTRACT(year FROM "ObservationDate") = 2019 THEN "Deaths" ELSE 0 END)) / 
SUM(CASE WHEN EXTRACT(year FROM "ObservationDate") = 2019 THEN "Deaths" ELSE 0 END) * 100 as percentage_increase
FROM covid_19_data
WHERE EXTRACT(year FROM "ObservationDate") IN (2019, 2020)

# top 5 countries with the highest confirmed cases
SELECT "Country", SUM("Confirmed") Total_Confirmed
FROM covid_19_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

# total number of drop (decrease) or increase in the confirmed cases from month to month in the 2 years of observation
WITH monthly_cases AS (
SELECT 
EXTRACT(year FROM "ObservationDate") AS year, 
EXTRACT(month FROM "ObservationDate") AS month, 
SUM("Confirmed") AS total_cases
FROM covid_19_data
WHERE EXTRACT(year FROM "ObservationDate") IN (2019, 2020)
GROUP BY 
EXTRACT(year FROM "ObservationDate"), EXTRACT(month FROM "ObservationDate")
),
monthly_diff AS (
SELECT 
m1.year, m1.month, m1.total_cases, 
m1.total_cases - COALESCE(m2.total_cases, 0) AS monthly_difference
FROM 
monthly_cases m1
LEFT JOIN monthly_cases m2 ON m1.year = m2.year AND m1.month = m2.month + 1
WHERE 
m1.year = 2020 OR (m1.year = 2019 AND m1.month > 11)
)
SELECT 
SUM(CASE WHEN monthly_difference > 0 THEN 1 ELSE 0 END) AS total_increases,
SUM(CASE WHEN monthly_difference < 0 THEN 1 ELSE 0 END) AS total_decreases
FROM 
monthly_diff





