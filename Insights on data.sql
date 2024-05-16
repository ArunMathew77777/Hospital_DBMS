--Q1. people who are suffering from cancer (disease_id=23)

SELECT
    P.Person_id,
    P.Last_Name,
    P.First_Name,
    DP.Severity_Value,
    DP.Start_date,
    DP.End_Date
FROM
    DISEASED_PATIENT DP
JOIN
    PERSON P ON DP.Person_ID = P.Person_id
WHERE
    DP.Disease_ID = '23';
	
--Q2. Count of people for each disease
with disease_counts as (Select disease_id,count(*) from diseased_patient
group by disease_id)

Select d.disease_name , dc."count"
from disease_counts as dc 
inner join 
disease d
on d.disease_id = dc.disease_id
order by 2 desc;

--Q3 For each country which is common disease
WITH RankedDiseases AS (
    SELECT
        L.Country_Name,
        D.Disease_ID,
        D.Disease_Name,
        COUNT(*) AS Disease_Count,
        ROW_NUMBER() OVER (PARTITION BY L.Country_Name ORDER BY COUNT(*) DESC) AS rn
    FROM
        LOCATIONS L
    JOIN
        PERSON P ON L.Location_ID = P.Primary_location_ID
    JOIN
        DISEASED_PATIENT DP ON P.Person_id = DP.Person_ID
    JOIN
        DISEASE D ON DP.Disease_ID = D.Disease_ID
    GROUP BY
        L.Country_Name, D.Disease_ID, D.Disease_Name
)
SELECT
    Country_Name,
    Disease_ID,
    Disease_Name,
    Disease_Count
FROM
    RankedDiseases
WHERE
    rn = 1;


--Q4
SELECT
    COUNT(*) AS People_Count
FROM
    LOCATIONS L
JOIN
    PERSON P ON L.Location_ID = P.Primary_location_ID
WHERE
    L.Country_Name = 'United States';


--Q5--
SELECT
    M.Medicine_ID,
    M.Name AS Medicine_Name,
    M.Company,
    M.Active_Ingridient_Name,
    D.Disease_ID,
    D.Disease_Name
FROM
    MEDICINE M
JOIN
    INDICATION I ON M.Medicine_ID = I.Medicine_ID
JOIN
    DISEASE D ON I.Disease_ID = D.Disease_ID;

