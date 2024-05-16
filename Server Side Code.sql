---Server Side Codes


-- Create a view to retrieve information about patients with diseases
CREATE VIEW disease_dw.ViewPatients AS
SELECT
    DP.Person_ID,
    P.Last_Name,
    P.First_Name,
    D.Disease_Name,
    DP.Severity_Value,
    DP.Start_date,
    DP.End_Date
FROM
    disease_dw.FACT_DISEASED_PATIENT DP
JOIN
    disease_dw.DIM_PERSON P ON DP.Person_ID = P.Person_id
JOIN
    disease_dw.DIM_DISEASE D ON DP.Disease_ID = D.Disease_ID;
	
-- Create a stored function to calculate the average severity for a given disease	


CREATE OR REPLACE FUNCTION CalculateAverageSeverity(p_DiseaseID VARCHAR(50)) RETURNS FLOAT AS $$
DECLARE
    avgSeverity FLOAT;
BEGIN
    SELECT AVG(Severity_Value) INTO avgSeverity
    FROM disease_dw.FACT_DISEASED_PATIENT
    WHERE Disease_ID = p_DiseaseID;

    RETURN avgSeverity;
END;
$$ LANGUAGE plpgsql;


SELECT CalculateAverageSeverity('22');




-- Create a view to display patients with their diseases and severity
CREATE VIEW PatientDiseaseSeverityView AS
SELECT
    P.Person_id,
    P.Last_Name,
    P.First_Name,
    D.Disease_Name,
    DP.Severity_Value,
    DP.Start_date,
    DP.End_Date
FROM
    disease_dw.FACT_DISEASED_PATIENT DP
JOIN
    disease_dw.DIM_PERSON P ON DP.Person_ID = P.Person_id
JOIN
    disease_dw.DIM_DISEASE D ON DP.Disease_ID = D.Disease_ID;
	
	
	
Select * from	PatientDiseaseSeverityView;
