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
--Answer: 20251 John H Williams Hospital performed the highest volume of medicare annual wellness visits (per assumption of HCPCS_CD described above). Additionally, this could be incorrect because some data did not have the full address (i.e. including the suite number), which could alter the counts.

--If a quality improvement organization was embarking on a campaign to increase the number of Delaware Medicare beneficiaries receiving annual Wellness Visits from primary care practices, what actionable information would you provide to inform the campaign?
--Answer:I would identify and provide the practices not meeting the annual wellness visit target range. I would also try to identify and provide which practices not meeting the target range were not fully staffed. Lastly, I would provide information on which practices utilized a value-based care model and what their spendings/savings were in order to use that data as a key preformance indicator in a campaign to motivate other practices to be involved in similar models. 