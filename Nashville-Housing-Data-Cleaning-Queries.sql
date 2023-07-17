
/*

Cleaning Data using SQL Queries

*/

SELECT * 
FROM NashvilleHousing.dbo.NashvilleHousingTable;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format (Convert datetime format to date format only)


SELECT SaleDate
FROM NashvilleHousing.dbo.NashvilleHousingTable;

-- Use these 2 queries below to modify the data type of the SaleDate column and update its values to the DATE format.
-- Ensure that the existing values in the SaleDate column are compatible with the DATE data type before running the UPDATE query.

-- This query alters the data type of the SaleDate column in the NashvilleHousingTable to DATE.
	-- This data type stores only the date portion without the time.
ALTER TABLE NashvilleHousingTable
ALTER COLUMN SaleDate DATE;

-- It then updates the values in the SaleDate column to reflect the new date format. 
	-- This is done by converting the existing datetime values to the desired DATE data type.
UPDATE NashvilleHousingTable
SET SaleDate = CONVERT(DATE, SaleDate);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Populate missing (NULL) Property Address data


-- This query retrieves all columns from the NashvilleHousingTable and returns the result set in ascending order based on the ParcelID column.
-- Use this query to fetch all records from the table while ensuring a specific order based on the ParcelID values. 
-- Use to look the records based on ParcelID and look for patterns (like same ParcelIDs)
SELECT *
FROM NashvilleHousing.dbo.NashvilleHousingTable
ORDER BY ParcelID;


-- This query retrieves rows from the NashvilleHousingTable where the ParcelID column has the same value in different rows (using self-join),
-- ensuring that the UniqueID values are different and the PropertyAddress value is NULL in the primary instance (a).
-- The result set includes the ParcelID and PropertyAddress values from both instances (a and b) for comparison purposes.
-- Only use this query if you need to identify and update rows with NULL PropertyAddress with the same ParcelID values
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing.dbo.NashvilleHousingTable a
INNER JOIN NashvilleHousing.dbo.NashvilleHousingTable b
	ON a.ParcelID = b.ParcelID
WHERE a.[UniqueID ] <> b.[UniqueID ]
	AND a.PropertyAddress IS NULL;


-- This query updates the PropertyAddress column in the NashvilleHousingTable by populating it with the PropertyAddress value
-- from rows where the ParcelID column has the same value in different rows, while ensuring the UniqueID values are distinct.
-- Only rows with a NULL value in the PropertyAddress column will be updated in the primary instance (a).
-- Use this query to populate missing PropertyAddress values (NULL) based on matching ParcelID values and distinct UniqueID values.
UPDATE a
SET a.PropertyAddress = b.PropertyAddress
FROM NashvilleHousingTable a
JOIN NashvilleHousingTable b 
	ON a.ParcelID = b.ParcelID
WHERE a.[UniqueID ] <> b.[UniqueID ]
  AND a.PropertyAddress IS NULL;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out PropertyAddress into 2 Columns (Street Number and Street Name, City)


-- This query retrieves the PropertyAddress column from the NashvilleHousingTable in the NashvilleHousing database.
-- Use this query to obtain the PropertyAddress values for ALL rows in the NashvilleHousingTable.
SELECT PropertyAddress 
FROM NashvilleHousing.dbo.NashvilleHousingTable;

-- This query retrieves the top 20 PropertyAddress values from the NashvilleHousingTable.
-- Use this query to obtain a limited result set of 20 PropertyAddress values from the table. 
-- This query retrieves results faster than selecting ALL rows for PropertyAddress due to the row limit set
SELECT TOP 20 PropertyAddress
FROM NashvilleHousingTable;

-- This query extracts the street number and name from the PropertyAddress column in the NashvilleHousingTable,
-- assigning it to the PropertyAddress_StreetNum_StreetName column. It also extracts the city name from the PropertyAddress column,
-- assigning it to the PropertyAddress_CityName column.
-- Use this query to separate the PropertyAddress values into distinct columns for street information and city name in the NashvilleHousingTable.
SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS PropertyAddress_StreetNum_StreetName,
    LTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))) AS PropertyAddress_CityName
FROM NashvilleHousingTable;


-- This query modifies the structure of the NashvilleHousingTable by adding two new columns:
-- PropertyAddress_StreetNum_StreetName and PropertyAddress_CityName.
-- These columns will be of data type NVARCHAR(255).
-- Use this query to expand the table structure to include separate columns for street number and name,
-- as well as the city name in the PropertyAddress field of the NashvilleHousingTable.
ALTER TABLE NashvilleHousingTable
ADD PropertyAddress_StreetNum_StreetName NVARCHAR(255),
    PropertyAddress_CityName NVARCHAR(255);

-- This query updates the newly added columns PropertyAddress_StreetNum_StreetName and PropertyAddress_CityName in the NashvilleHousingTable.
-- It assigns the appropriate values extracted from the PropertyAddress column to these new columns.
-- Use this query to populate the newly added columns with the street number and name, as well as the city name,
-- based on the existing values in the PropertyAddress column of the NashvilleHousingTable.
-- Ensure that the previous ALTER TABLE query has been executed to add the new columns before running this update query.
UPDATE NashvilleHousingTable
SET PropertyAddress_StreetNum_StreetName = LTRIM(RTRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1))),
    PropertyAddress_CityName = LTRIM(RTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))));


-- This query is used to verify the success of the previous queries (ALTER TABLE and UPDATE, SET) executed on the NashvilleHousingTable.
-- It retrieves the top 800 records from the table, specifically the PropertyAddress_StreetNum_StreetName and PropertyAddress_CityName columns.
-- Use this query to check if the table modifications were done properly and to validate the populated values in the new columns.
-- Filtering to the top 800 records helps to reduce data retrieval time for testing and validation purposes.
SELECT TOP 800 PropertyAddress_StreetNum_StreetName, PropertyAddress_CityName
FROM NashvilleHousingTable;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out OwnerAddress into 3 Individual Columns (Street Address, City, State)

-- This query retrieves the top 300 PropertyAddress values from the NashvilleHousingTable.
-- Use this query to obtain a limited result set of 300 PropertyAddress values from the table. 
-- This query retrieves results faster than selecting ALL rows for PropertyAddress due to the row limit set
SELECT TOP 300 OwnerAddress
FROM NashvilleHousingTable;


-- This query extracts the Street Address, City, and State from the OwnerAddress column in the NashvilleHousingTable using the PARSENAME function in SQL Server. 
-- The REPLACE function is first applied in the OwnerAddress column to replace the commas with periods, creating a modified string. 
	-- This is to prepare the string for parsing by the PARSENAME function. 
	-- The PARSENAME function is designed to parse object names with a period as the delimiter. 
	-- Therefore, the string to be parsed must have the commas replaced with periods.
-- Then, the PARSENAME function is used to parse the modified string and extract the desired components: 
	--  Owner_Street Address (index 3), Owner_City (index 2), and Owner_State (index 1). 
-- The resulting values are returned in separate columns with meaningful aliases. 
SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Owner_StreetAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS Owner_City,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS Owner_State
FROM NashvilleHousingTable;


-- This query updates the NashvilleHousingTable by adding 3 new columns:
	-- Owner_StreetAddress, Owner_City, and Owner_State.
-- These columns will be of data type NVARCHAR(255), allowing for a maximum length of 255 characters
-- After executing this query, the NashvilleHousingTable will have the new columns ready to store the respective components of the OwnerAddress: Street Address, City, and State.
ALTER TABLE NashvilleHousingTable
ADD Owner_StreetAddress NVARCHAR(255),
    Owner_City NVARCHAR(255),
    Owner_State NVARCHAR(255);


-- Run this query to assign the appropriate values extracted from the OwnerAddress column
-- to the newly added columns: Owner_StreetAddress, Owner_City, and Owner_State in the NashvilleHousingTable.
-- Before running this query, ensure that the previous ALTER TABLE query has been executed to add the 3 new columns to the NashvilleHousingTable 
UPDATE NashvilleHousingTable
SET Owner_StreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


-- This query is used to verify the success of the previous queries (ALTER TABLE and UPDATE, SET) executed on the NashvilleHousingTable.
-- It retrieves the top 800 records from the table, specifically the Owner_StreetAddress, Owner_City, Owner_State columns.
-- Use this query to check if the table modifications were done properly and to validate the populated values in the new columns.
-- Filtering to the top 800 records helps to reduce data retrieval time for testing and validation purposes.
SELECT TOP 800 Owner_StreetAddress, Owner_City, Owner_State
FROM NashvilleHousingTable;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No respectively in "Sold as Vacant" field

-- Use this query to explore the unique or distinct values present in the SoldAsVacant column of the NashvilleHousingTable.
-- DISTINCT keyword filter out duplicate values and returns a set of distinct values
-- This query is also used to verify the success of the previous queries (UPDATE, SET) executed on the NashvilleHousingTable.
SELECT DISTINCT (SoldAsVacant)
FROM NashvilleHousingTable;


-- This query retrieves the distinct values from the SoldAsVacant column in the NashvilleHousingTable.
-- It also includes the occurrence count for each distinct value, sorted in ascending order of occurrence.
-- This query is also used to verify the success of the previous queries (UPDATE, SET) executed on the NashvilleHousingTable.
SELECT SoldAsVacant, COUNT(*) AS Occurrence
FROM NashvilleHousingTable
GROUP BY SoldAsVacant
ORDER BY Occurrence ASC;

-- Executing this query will retrieve the values from the SoldAsVacant column of the NashvilleHousingTable, 
-- where 'Y' is replaced by 'Yes' and 'N' is replaced by 'No', while leaving other values unchanged.
SELECT
    CASE SoldAsVacant
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
        ELSE SoldAsVacant
    END AS UpdatedSoldAsVacant
FROM NashvilleHousingTable;

-- Executing this query will retrieve the values from the SoldAsVacant column of the NashvilleHousingTable, 
-- where 'Y' is replaced by 'Yes' and 'N' is replaced by 'No', while leaving other values unchanged.
-- This query returns the original SoldAsVacant column and UpdatedSoldAsVacant column
SELECT SoldAsVacant,
    CASE SoldAsVacant
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
        ELSE SoldAsVacant
    END AS UpdatedSoldAsVacant
FROM NashvilleHousingTable;

-- Execute this query to update the values in the SoldAsVacant column of the NashvilleHousingTable, converting 'Y' to 'Yes' and 'N' to 'No', while  leaving any other values unchanged.
UPDATE NashvilleHousingTable
SET SoldAsVacant = CASE SoldAsVacant
                        WHEN 'Y' THEN 'Yes'
                        WHEN 'N' THEN 'No'
                        ELSE SoldAsVacant
                  END;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates



-- This query uses a Common Table Expression (CTE) named "RowNumCTE" to generate row numbers for duplicate rows
-- within specific partitions based on the columns ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference
-- in the "NashvilleHousingTable". The row numbers are assigned in ascending order of the UniqueID column.
-- The CTE retrieves all columns from the table along with the generated row numbers.

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM NashvilleHousingTable
)

-- The outer query selects and displays the rows from the CTE where the row number is greater than 1,
-- indicating duplicate rows. 
-- Executing this query will display the duplicate rows from the "NashvilleHousingTable" based on the specified columns, filtering out the rows where the row number is 1 (non-duplicates)
-- The result set is ordered by the PropertyAddress column.
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;




WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM NashvilleHousingTable
)
-- This outer query deletes rows from the CTE named "RowNumCTE" where the row number (row_num) is greater than 1.
-- It effectively removes duplicate rows or retains only the first occurrence of each record based on the row numbering (first occurrence: row_num = 1).
-- The CTE serves as a virtual table from which the rows are deleted.
DELETE
FROM RowNumCTE
WHERE row_num > 1;




---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

-- This query alters the structure of the table "NashvilleHousingTable" by dropping three columns:
	-- OwnerAddress, TaxDistrict, PropertyAddress. 
-- The DROP COLUMN operation permanently removes these columns and their associated data from the table.
ALTER TABLE NashvilleHousingTable
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;


-- Use this query to check if the table modifications were done properly and to validate that the specified columns and their associated data were removed from the table.
SELECT * 
FROM NashvilleHousing.dbo.NashvilleHousingTable;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------


