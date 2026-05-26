-- This is a Data Cleaning Project

SELECT*
FROM presidents;

-- Deleting the first useless column
ALTER TABLE presidents
DROP COLUMN MyUnknownColumn;

-- REMOVING DUPLICATES
-- Checking for duplicates
SELECT 
    president, party, vice, salary, COUNT(*) as duplicate_count
FROM presidents
GROUP BY 
    president, party, vice, salary
HAVING COUNT(*) > 1;

-- removing duplicates by creating a new table
CREATE TABLE presidents_clean AS
SELECT DISTINCT *
FROM presidents;

SELECT*
FROM presidents_clean;

-- Fixing naming convention in president column

-- Convert to upper case (first letter uppercase, rest lowercase)
UPDATE presidents_clean
SET president = CONCAT(UPPER(LEFT(president, 1)), UPPER(SUBSTRING(president, 2)))
WHERE president IS NOT NULL;

-- STANDARDIZING party column

SELECT DISTINCT(party)
FROM presidents_clean;

UPDATE presidents_clean
SET party = 'Democratic' 
WHERE party IN ('Demorcatic');

UPDATE presidents_clean
SET party = 'Republican' 
WHERE party IN ('Republicans');

UPDATE presidents_clean
SET party = 'Whig' 
WHERE party IN ('Whig   April 4, 1841  â€“  September 13, 1841');

-- standardizing vice column

UPDATE presidents_clean
SET vice = TRIM(CONCAT(UPPER(LEFT(president, 1)), UPPER(SUBSTRING(president, 2))))
WHERE vice IS NOT NULL;

SELECT*
FROM presidents_clean;

-- standardizing salary column
SELECT salary
FROM presidents_clean;

UPDATE presidents_clean
SET salary = REPLACE(
                REPLACE(
                    SUBSTRING_INDEX(salary, '.', 1),
                '$', ''),
            ',', '');
            

ALTER TABLE presidents_clean
CHANGE COLUMN salary salary INT;


-- standardized the date columns

ALTER TABLE presidents_clean
RENAME COLUMN `date updated` TO date_updated;

ALTER TABLE presidents_clean
RENAME COLUMN `date created` TO date_created;


UPDATE presidents_clean
SET date_updated =
CASE
    WHEN date_updated LIKE '%/%/%'
    THEN DATE_FORMAT(
        STR_TO_DATE(date_updated, '%d/%m/%Y'),
        '%Y-%m-%d'
    )

    WHEN date_updated LIKE '%,%'
    THEN DATE_FORMAT(
        STR_TO_DATE(date_updated, '%W, %d %M %Y'),
        '%Y-%m-%d'
    )

    ELSE date_updated
END;

UPDATE presidents_clean
SET date_created =
CASE
    WHEN date_created LIKE '%/%/%'
    THEN DATE_FORMAT(
        STR_TO_DATE(date_created, '%d/%m/%Y'),
        '%Y-%m-%d'
    )
    
	WHEN date_created LIKE '%,%'
    THEN DATE_FORMAT(
        STR_TO_DATE(date_created, '%W, %d %M %Y'),
        '%Y-%m-%d'
    )

    ELSE date_created
END;

ALTER TABLE presidents_clean
CHANGE COLUMN text date_update DATE;

ALTER TABLE presidents_clean
CHANGE COLUMN date_created date_created DATE;

SELECT*
FROM presidents_clean;

-- Finishing touches

ALTER TABLE presidents_clean
RENAME COLUMN `S.No.` TO Serial_number;

ALTER TABLE presidents_clean
DROP COLUMN prior;