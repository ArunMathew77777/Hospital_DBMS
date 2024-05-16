-- Inserting data into the RACE table
INSERT INTO RACE (Race_Code, Race_Description) VALUES
('R1', 'Asian'),
('R2', 'Caucasian');

-- Inserting data into the LOCATIONS table
INSERT INTO LOCATIONS (Location_ID, City_Name, State_Province_Name, Country_Name, Developing_Flag, Wealth_Rank_Number) VALUES
(1, 'New York', 'NY', 'USA', true, 1),
(2, 'Tokyo', 'Tokyo', 'Japan', true, 2);

-- Inserting data into the MEDICINE table
INSERT INTO MEDICINE (Medicine_ID, Standard_Industry_Number, Name, Company, Active_Ingridient_Name) VALUES
('M1', 123456, 'Aspirin', 'PharmaCo', 'Acetaminophen'),
('M2', 789012, 'Ibuprofen', 'MediCorp', 'Ibuprofen');

-- Inserting data into the DISEASE_TYPE table
INSERT INTO DISEASE_TYPE (Disease_Type_Code, Disease_Type_Description, Exclusions_Other_Note) VALUES
('DT1', 'Cardiovascular', 'Excludes genetic heart conditions'),
('DT2', 'Respiratory', 'Excludes allergies');

-- Inserting data into the PERSON table
INSERT INTO PERSON (Person_id, Last_Name, First_Name, Gender, Primary_location_ID, Race_CD) VALUES
(1, 'Doe', 'John', 'Male', 1, 'R1'),
(2, 'Smith', 'Jane', 'Female', 2, 'R2');

-- Inserting data into the DISEASE table
INSERT INTO DISEASE (Disease_ID, Disease_Name, Intensity_Level_Qty, Disease_Type_Cd, Source_Disease_Cd) VALUES
('D1', 'Hypertension', 0.8, 'DT1', 'ICD-10'),
('D2', 'Asthma', 0.6, 'DT2', 'ICD-9');

-- Inserting data into the INDICATION table
INSERT INTO INDICATION (Medicine_ID, Disease_ID, Indication_Date, Effectiveness_Percent) VALUES
('M1', 'D1', '2023-01-01', 0.9),
('M2', 'D2', '2023-02-01', 0.8);

-- Inserting data into the RACE_DISEASE_PROPENSITY table
INSERT INTO RACE_DISEASE_PROPENSITY (Race_Code, Disease_ID, Propensity_Value) VALUES
('R1', 'D1', 0.75),
('R2', 'D2', 0.6);

-- Inserting data into the DISEASED_PATIENT table
INSERT INTO DISEASED_PATIENT (Person_ID, Disease_ID, Severity_Value, Start_date, End_Date) VALUES
(1, 'D1', 0.7, '2023-01-15', '2023-02-15'),
(2, 'D2', 0.5, '2023-02-01', NULL);

-- Updating data in the MEDICINE table
UPDATE MEDICINE SET Medicine_ID = '26' WHERE Medicine_ID = 'M1';
UPDATE MEDICINE SET Active_Ingridient_Name = 'Paracetamol' WHERE Medicine_ID = '26';

-- Updating data in the INDICATION table
UPDATE INDICATION SET Effectiveness_Percent = 0.85 WHERE Medicine_ID = 'M1' AND Disease_ID = 'D1';

-- Updating data in the DISEASED_PATIENT table
UPDATE DISEASED_PATIENT SET End_Date = '2023-03-01' WHERE Person_ID = 1 AND Disease_ID = 'D1';

-- Deleting data in the PERSON table
DELETE FROM PERSON WHERE Person_id = 2;

-- Deleting data in the DISEASE table
DELETE FROM DISEASE WHERE Disease_ID = 'D2';

-- Deleting data in the RACE_DISEASE_PROPENSITY table
DELETE FROM RACE_DISEASE_PROPENSITY WHERE Race_Code = 'R2' AND Disease_ID = 'D2';

select * from medicine where Medicine_ID = 'M1';
select * from indication WHERE Medicine_ID = 'M1';

select * from person where person_id = 2;



select * from diseased_patient where person_id = 2;



select p.person_id, d.Active_Ingridient_Name,i.disease_id,i.effectiveness_percent
from medicine m
inner join
indication i
on m.medicine_id=i.medicine_id where m.medicine_id = '26';
