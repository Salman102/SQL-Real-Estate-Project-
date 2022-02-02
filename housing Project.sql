select *
from Information
-- we see the column SaleDate has incorect format
select SaleDate
from Information

-- we see Column SaleDate has Date and time.
-- Here we dont need time 

select SaleDate,convert(Date,SaleDate)
from Information

-- Now we name this new Column
update Information
set SaleDate = Convert(Date,SaleDate)

-- Its Not working i dnt knw why 
-- we can try Other way 

Alter table Information
add SaleDates Date;
--Now we add this Column (SaleDates)
update Information
set SaleDates = convert(Date,SaleDate)
-- now we update this Column 
select SaleDates,convert(Date,SaleDate)
from Information
-- yes we got the right date formate Column
-- Now we go with Address column
 select PropertyAddress
from Information
-- now we check is PropertyAddress Column hass Null Values ?
select PropertyAddress
from Information
where PropertyAddress is Null
-- noe see all Tables
select *
from Information
where PropertyAddress is null

-- The que is why These adress are null ?
-- we compare address with ParcelID
select*
from Information
order by ParcelID
 -- we see here the ParcelID (052 01 0 296.00) hass PropertyAddress but its also show NULl Adress
 --and the (052 01 0 296.00) is come many times
 -- now we join two table to understand properly

 select A.ParcelID,A.PropertyAddress,B.ParcelID,b.PropertyAddress 
 from Information A --we gave short Name (A) to Information Table 
 join Information B -- Same as uper
 on A.ParcelID = B.ParcelID
 --we compair ParcelID and PropertyAddress Column with (ID) Column which is Unique id 
 and A.[ID] <> B.[ID]
 where A.PropertyAddress is null

 -- now we see ParcelID(044050135.00) hv PropertyAddress but its not Papulate 
 -- now we used ISNULL stament to fill the null values

 select A.ParcelID,A.PropertyAddress,B.ParcelID,b.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
 from Information A  
 join Information B 
 on A.ParcelID = B.ParcelID
 and A.[ID] <> B.[ID]
 where A.PropertyAddress is null

 --now we hv new Column with Null address
 -- now we and update 
 update A
 set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
 from Information A
 join Information B
  on A.ParcelID = B.ParcelID
 and A.[ID] <> B.[ID]
 where A.PropertyAddress is null

 -- we can check its work or not if we got no null value its work and update
  select A.ParcelID,A.PropertyAddress,B.ParcelID,b.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
 from Information A  
 join Information B 
 on A.ParcelID = B.ParcelID
 and A.[ID] <> B.[ID]
 where A.PropertyAddress is null

 -- its work  good 
 --Now we Hv PropertyAdress but in PropertyAddress has different information like (city ,state,address)

 select PropertyAddress 
 from Information
 
 -- now we see there is only 1 (,) which shows we hv Address and City .this (,) here uesd as called (delemitter) is a saprate tow values in one Column
-- we used here substring and charindex which is used for find something

select 
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)) as Address
from Information
-- here we get the address on the possion at 1 and find (,) as we want 
-- its drop the value after (,)
-- if we want to know in which possion (,) is we used this statement 

select 
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)) as Address,CHARINDEX(',',PropertyAddress) as possion
from Information

--if we dnt need to see (,) here
select 
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress) -1) as Address
from Information

--now we aslo need the values after (,) in different column
select 
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress ), len (PropertyAddress)) as City
from Information

-- here we have (,) in both Column we add -1 in first line and +1 in second line
select 
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress )+1, len (PropertyAddress)) as City
from Information
-- we get Adress and city but cant seprate two Values in one Column
-- so we can create Two new Column 
-- add column name PTYAdress

Alter table Information
add PTYAdress varchar(200);
-- now update 

update Information
set PTYAdress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) 
--now add other column name PTYCITY
alter table Information
Add PTYCity varchar(200);
-- now update it
update Information
set PTYCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress )+1, len (PropertyAddress)) 

-- check the new columns

select PTYAdress,PTYCity
from Information
-- its work 

-- now we hv Owner Address
select OwnerAddress
from Information
where OwnerAddress is not null

-- we see there is (,) and (.) soo where we need three column to stor 
-- we do same thing as uper but in eazy way . we use PARSENAME (BUT pARSENAME ONLY WORK WITH PERIOUD)  
-- SO WE CAN REPLACE (,) AND (.) WITH PERIOUD

select
parsename(replace(OwnerAddress,',','.'),1)
from Information
where OwnerAddress is not null

-- ITS WORK NOE ADD NEW THINGS

select
parsename(replace(OwnerAddress,',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
from Information
where OwnerAddress is not null
--very nice

-- so we add column and update same as uper 

Alter table Information
add AddressOwner varchar(200);

-- now update 

update Information
set AddressOwner =parsename(replace(OwnerAddress,',' , '.'),3)

--now add other column name OwnerCity

alter table Information
Add OwnerCity varchar(200);

-- now update it

update Information
set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

alter table Information
Add OwnerState varchar(200);

-- now update it

update Information
set OwnerState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

select OwnerCity,OwnerState,AddressOwner
from Information
where OwnerCity is not null

select *
from Information
