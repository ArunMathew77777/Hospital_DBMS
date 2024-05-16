-- Create Dimension Tables
CREATE TABLE disease_dw.Dim_Race (
    Race_Key SERIAL PRIMARY KEY,
    Race_Code VARCHAR(30) UNIQUE,
    Race_Description VARCHAR(300)
);

INSERT INTO disease_dw.Dim_Race (Race_Code, Race_Description)
SELECT DISTINCT Race_Code, Race_Description FROM RACE;

CREATE TABLE disease_dw.Dim_Locations (
    Location_Key SERIAL PRIMARY KEY,
    Location_ID INT UNIQUE,
    City_Name VARCHAR(50),
    State_Province_Name VARCHAR(50),
    Country_Name VARCHAR(50),
    Developing_Flag BOOLEAN,
    Wealth_Rank_Number INT
);

INSERT INTO disease_dw.Dim_Locations (Location_ID, City_Name, State_Province_Name, Country_Name, Developing_Flag, Wealth_Rank_Number)
SELECT DISTINCT Location_ID, City_Name, State_Province_Name, Country_Name, Developing_Flag, Wealth_Rank_Number FROM LOCATIONS;

CREATE TABLE disease_dw.Dim_Medicine (
    Medicine_Key SERIAL PRIMARY KEY,
    Medicine_ID VARCHAR(20) UNIQUE,
    Standard_Industry_Number INT,
    Name VARCHAR(100),
    Company VARCHAR(100),
    Active_Ingridient_Name VARCHAR(50)
);

INSERT INTO disease_dw.Dim_Medicine (Medicine_ID, Standard_Industry_Number, Name, Company, Active_Ingridient_Name)
SELECT DISTINCT Medicine_ID, Standard_Industry_Number, Name, Company, Active_Ingridient_Name FROM MEDICINE;

CREATE TABLE disease_dw.Dim_Disease_Type (
    Disease_Type_Key SERIAL PRIMARY KEY,
    Disease_Type_Code VARCHAR(20) UNIQUE,
    Disease_Type_Description VARCHAR(200),
    Exclusions_Other_Note TEXT
);

INSERT INTO disease_dw.Dim_Disease_Type (Disease_Type_Code, Disease_Type_Description, Exclusions_Other_Note)
SELECT DISTINCT Disease_Type_Code, Disease_Type_Description, Exclusions_Other_Note FROM DISEASE_TYPE;

select * from disease_dw.Dim_Disease_Type;

-- Dim_Disease DROP TABLE disease_dw.Dim_disease;
CREATE TABLE disease_dw.Dim_Disease (
    Disease_Key SERIAL ,
    Disease_ID VARCHAR(50) PRIMARY KEY,
    Disease_Name VARCHAR(200),
    Intensity_Level_Qty FLOAT,
    Source_Disease_Cd VARCHAR(30),
    Disease_Type_Cd VARCHAR(20) REFERENCES disease_dw.Dim_Disease_Type(Disease_Type_Code)
);


INSERT INTO disease_dw.Dim_Disease (Disease_ID, Disease_Name, Intensity_Level_Qty, Disease_Type_Cd, Source_Disease_Cd)
SELECT Disease_ID, Disease_Name, Intensity_Level_Qty, Disease_Type_Cd, Source_Disease_Cd
FROM Disease;

CREATE TABLE disease_dw.Dim_Person (
    Person_Key SERIAL PRIMARY KEY,
    Person_ID INT UNIQUE,
    Last_Name VARCHAR(50),
    First_Name VARCHAR(50),
    Gender VARCHAR(12),
    Primary_Location_ID INT,
    Race_CD VARCHAR(20),
    FOREIGN KEY (Primary_Location_ID) REFERENCES disease_dw.Dim_Locations(Location_ID),
    FOREIGN KEY (Race_CD) REFERENCES disease_dw.Dim_Race(Race_Code)
);

INSERT INTO disease_dw.Dim_Person (Person_ID, Last_Name, First_Name, Gender, Primary_Location_ID, Race_CD)
SELECT DISTINCT Person_ID, Last_Name, First_Name, Gender, Primary_Location_ID, Race_CD FROM PERSON;

-- Create Fact Tables 
CREATE TABLE disease_dw.Fact_Indication (
    Indication_Key SERIAL PRIMARY KEY,
    Medicine_Key VARCHAR(20),
    Disease_Key VARCHAR(50),
    Indication_Date DATE,
    Effectiveness_Percent FLOAT,
    FOREIGN KEY (Medicine_Key) REFERENCES disease_dw.Dim_Medicine(Medicine_ID),
    FOREIGN KEY (Disease_Key) REFERENCES disease_dw.Dim_Disease(Disease_ID)
);

--SELECT * FROM disease_dw.Fact_Race_Disease_Propensity;


INSERT INTO disease_dw.Fact_Indication (Medicine_Key, Disease_Key, Indication_Date, Effectiveness_Percent)
SELECT DISTINCT Medicine_ID, Disease_ID, Indication_Date, Effectiveness_Percent FROM INDICATION;

-- DROP TABLE disease_dw.Fact_Race_Disease_Propensity;
CREATE TABLE disease_dw.Fact_Race_Disease_Propensity (
    Race_Key INT,
	Race_Code VARCHAR(20),
    Disease_Key VARCHAR(50),
    Propensity_Value FLOAT,
    FOREIGN KEY (Race_Key) REFERENCES disease_dw.Dim_Race(Race_Key),
    FOREIGN KEY (Disease_Key) REFERENCES disease_dw.Dim_Disease_Type(Disease_Type_Code)
);

-- INSERT INTO disease_dw.Fact_Race_Disease_Propensity (Race_Key, Disease_Key, Propensity_Value)
-- (SELECT CAST(race_code AS INT) ,disease_id,propensity_value from RACE_DISEASE_PROPENSITY );

INSERT INTO disease_dw.Fact_Race_Disease_Propensity (Race_Key, Disease_Key, Propensity_Value)
SELECT DISTINCT
    (SELECT Race_Key FROM disease_dw.Dim_Race WHERE Race_Code = rdp.Race_Code),
    (SELECT Disease_Type_Key FROM disease_dw.Dim_Disease_Type WHERE Disease_Type_Code = rdp.Disease_ID),
    Propensity_Value
FROM RACE_DISEASE_PROPENSITY rdp;

-- drop table disease_dw.Fact_Diseased_Patient;
CREATE TABLE disease_dw.Fact_Diseased_Patient (
    Person_ID INT,
    Disease_ID VARCHAR(50),
    Severity_Value FLOAT,
    Start_Date DATE,
    End_Date DATE,
    FOREIGN KEY (Person_ID) REFERENCES disease_dw.Dim_Person(Person_ID),
    FOREIGN KEY (Disease_ID) REFERENCES disease_dw.Dim_Disease(Disease_ID)
);

-- INSERT INTO disease_dw.Fact_Diseased_Patient (Person_Key, Disease_Key, Severity_Value, Start_Date, End_Date)
-- SELECT DISTINCT dp.Person_ID, dp.Disease_ID, dp.Severity_Value, dp.Start_Date, dp.End_Date
-- FROM DISEASED_PATIENT dp
-- JOIN disease_dw.Dim_Person p ON dp.Person_ID = p.Person_ID
-- JOIN disease_dw.Dim_Disease_Type d ON dp.Disease_ID = d.Disease_Type_Code;


INSERT INTO disease_dw.Fact_Diseased_Patient (Person_ID, Disease_ID, Severity_Value, Start_Date, End_Date)
SELECT DISTINCT
    (SELECT Person_ID FROM disease_dw.Dim_Person WHERE Person_id = dp.Person_ID),
    (SELECT Disease_ID FROM disease_dw.Dim_Disease WHERE Disease_ID = dp.Disease_ID),
    Severity_Value, Start_date, End_Date
FROM diseased_patient dp;