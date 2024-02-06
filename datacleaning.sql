use sqlskills;

select * from sqlskills.dbo.datacleaning;
/*
cleaning data in sql queries
*/

Select * 
FROM sqlskills.dbo.datacleaning;



-- -------------------------------------------------------------------------------------------------------------------
-- Standardize Data format
select saledate, CONVERT(DATE,saledate)
FROM sqlskills.dbo.datacleaning;

-- -----------------------------------------------------------------------------------------------------------------------------

-- populate property address data

select *
FROM datacleaning
-- here propertyaddress is null
order by parcelID;

select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)   
FROM sqlskills.dbo.datacleaning a
JOIN sqlskills.dbo.datacleaning b
ON a.ParcelID = b.parcelID
AND a.[uniqueID] <> b.[uniqueID]
where a.propertyaddress is null;


update a
SET propertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)  
FROM sqlskills.dbo.datacleaning a
JOIN sqlskills.dbo.datacleaning b
ON a.ParcelID = b.parcelID
AND a.[uniqueID] <> b.[uniqueID]
where a.propertyaddress is null;





-- breaking out address into individual columns (address, city, states)

select  propertyaddress
FROM sqlskills.dbo.datacleaning;
--where propertyaddress is null
-- order by parcelID

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1 , LEN(propertyaddress)) as Address
FROM sqlskills.dbo.datacleaning;


alter table datacleaning
add propertyspiltaddress varchar(255);

update datacleaning 
set propertyspiltaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1);

alter table datacleaning
add propertyspiltCity varchar(255);

update datacleaning 
set propertyspiltCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1 , LEN(propertyaddress));

select * 
from  sqlskills.dbo.datacleaning;



select ownerAddress
from datacleaning;

select 
PARSENAME(REPLACE(owneraddress, ',',  '.') , 1),
PARSENAME(REPLACE(owneraddress, ',',  '.') , 2),
PARSENAME(REPLACE(owneraddress, ',',  '.') , 3)
from sqlskills.dbo.datacleaning;

alter table datacleaning
add ownerspiltaddress varchar(255);

update datacleaning 
set ownerspiltaddress = PARSENAME(REPLACE(owneraddress, ',',  '.') , 1);

alter table datacleaning
add ownerspiltCity varchar(255);

Update datacleaning 
set ownerspiltCity = PARSENAME(REPLACE(owneraddress, ',',  '.') , 2);

alter table datacleaning
add ownerspiltstate varchar(255);

update datacleaning 
set ownerspiltstate = PARSENAME(REPLACE(owneraddress, ',',  '.') , 3);

select *  from datacleaning;

-- change Y and N to yes and NO in 'solid vacant' field

Select 
distinct(SoldAsVacant), count(SoldAsVacant)
from 
datacleaning
group by SoldAsVacant
order  by 2;


alter table datacleaning
modify column soldasvacant varchar(50);

SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant = 1 THEN 'yes'
   WHEN SoldAsVacant = 0 THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM datacleaning;

alter table datacleaning
drop column soldasvacant1;






-- Remove duplicates

WITH row_numberCTE AS(
SELECT *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 Saleprice,
				 saledate,
				 LegalReference
				 ORDER BY 
				 uniqueID
				  ) row_number
FROM datacleaning
)
DELETE 
FROM row_numberCTE
where row_number > 1




select * from datacleaning;





-- DELETE UNUSED COLUMN

ALTER TABLE datacleaning
drop column owneraddress, taxdistrict, propertyaddress;

ALTER TABLE datacleaning
drop column saledate;













	  




