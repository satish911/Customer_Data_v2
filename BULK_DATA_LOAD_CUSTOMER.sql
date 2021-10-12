CREATE PROC BULK_LOAD_CUSTOMER_DATA
AS

IF OBJECT_ID('dbo.STG_Customer_DATA', 'U') IS NOT NULL
DROP TABLE dbo.STG_Customer_DATA;

CREATE TABLE STG_Customer_DATA(
Customer_Name VARCHAR(255)
,Customer_Id VARCHAR(18)
,Open_Date DATE
,Last_Consulted_Date DATE
,Vaccination_Id CHAR(5)
,Dr_Name  CHAR(255)
,State CHAR(5)
,Country CHAR(5) ,DOB varchar(20),Is_Active  CHAR(1))
BULK INSERT STG_Customer_DATA
FROM 'C:\Users\satish.yadav.HCECORP\Pictures\CUST_VAC.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR = '\n'
)
GO

DECLARE @name VARCHAR(20),@tbl_name VARCHAR(20),@SQL VARCHAR(MAX)
DECLARE db_cursor CURSOR FOR 
SELECT DISTINCT Country  FROM STG_Customer_DATA

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    
SET @tbl_name='Customer_DATA_'+@NAME
SET @SQL='

IF OBJECT_ID('''+@tbl_name+''', ''U'') IS NOT NULL
DROP TABLE dbo.'+@tbl_name+';


CREATE TABLE '+@tbl_name+' (
 [CUSTOMER NAME]  VARCHAR(255) NOT NULL 
 ,[CUSTOMER ID] VARCHAR(18)   NOT NULL
 ,[CUSTOMER OPEN DATE]  DATE   NOT NULL
 ,[LAST CONSULTED DATE]  DATE 
 ,[VACCINATION TYPE]  CHAR(5)
 ,[DOCTOR CONSULTED]  CHAR(255)
 ,[STATE]  CHAR(5)
 ,[COUNTRY]  CHAR(5) 
 ,[POST CODE]  INT 
 ,[DATE OF BIRTH]  DATE 
 ,[ACTIVE CUSTOMER]  CHAR(1))'
--PRINT @SQL
EXEC (@SQL)
SET @SQL='INSERT INTO '+@tbl_name+' SELECT Customer_Name
,Customer_Id
,Open_Date
,Last_Consulted_Date
,Vaccination_Id
,Dr_Name
,State
,Country
,NULL
,CAST(SUBSTRING(DOB,5,9)+SUBSTRING(DOB,3,2)+SUBSTRING(DOB,1,2) AS date)
,Is_Active FROM STG_Customer_DATA WHERE Country='''+@NAME+''''
--PRINT @SQL
EXEC (@SQL)
--SELECT * FROM 


      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 




