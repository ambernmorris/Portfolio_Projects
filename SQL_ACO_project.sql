Supplied data as follows:
A. physician_supplier_hcpcs.csv
Medicare Physician & Other Practitioners - by Provider and Service.
We limited this data set to records with state = DE and a subset of HCPCS codes.
https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-pra
ctitioners/medicare-physician-other-practitioners-by-provider-and-service
B. physician_supplier_agg.csv
Medicare Physician & Other Practitioners - by Provider.
We limited this data set to records with state = DE.
https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-pra
ctitioners/medicare-physician-other-practitioners-by-provider
C. physician _compare.csv
Doctors and Clinicians National Downloadable File.
We limited this data set to records with state = DE.
https://data.cms.gov/provider-data/dataset/mj5m-pzi6

This analysis was completed in SQL.
It is meant to theoretically aid in decision-making for an affordable care organization (ACO) while improving upon the value-based care model.

SELECT *
FROM aledade..physician_compare

SELECT *
FROM aledade..physician_supplier_agg

SELECT *
FROM aledade..physician_supplier_hcpcs

--Question #1: How many primary care practices are in the state of Delaware? Answer: 228.
--First step: queried * from the 3 tables to determine which was the junction table.
--Joined the 3 tables on the unique ID (NPI) and grouping by unique ID (NPI) and primary speciality (primary care, aka family medicine).
SELECT NPI, PRI_SPEC
FROM physician_compare
JOIN physician_supplier_agg
ON NPI = physician_supplier_agg.RNDRNG_NPI
JOIN physician_supplier_hcpcs
ON physician_supplier_hcpcs.RNDRNG_NPI = physician_supplier_agg.RNDRNG_NPI
GROUP BY NPI, PRI_SPEC
HAVING PRI_SPEC LIKE 'FAMILY%'
--Answer: 228 total primary care offices in Delaware.

--Question #2: Which Delaware primary care practice performed the highest volume of Medicare Annual Wellness Visits?
--In the physician_supplier_hcpcs table, some CPT codes are reported under the 'HCPCS_CD' column.
--However, annual wellness visit code (G0438, initial visit) is not used in the data set.
--As such, I assumed the 'NULL' values in 'HCPCS_CD' colulm were the annual wellness visits based on the description in the 'HCPCS_DESC' column.
SELECT RNDRNG_NPI, RNDRNG_PRVDR_TYPE, RNDRNG_PRVDR_ST1, RNDRNG_PRVDR_ST2, HCPCS_CD
FROM physician_supplier_hcpcs
WHERE RNDRNG_PRVDR_TYPE LIKE 'FAMILY%'
AND HCPCS_CD IS NULL
ORDER BY RNDRNG_PRVDR_ST1 DESC;
--Answer: 1401 Foulk Rd Ste 100B performed the highest volume of medicare annual wellness visits (per assumption of HCPCS_CD described above) at 10 visits. It should be noted that there were many variations in spelling and sorting between data entry for address line 1 (RNDRNG_PRVDR_ST1) and address line 2 (RNDRNG_PRVDR_ST2). If this variation was not accounted for, 20251 John H Williams Hospital could have seemed like the practice with the highest volume. This can easily be fixed and accounted for, but it might be relevant to incorporate a training piece of data entry to ensure it is consistent naming-systems between address line 2 and line 2. 
