/* Copy the file data into variable */
DECLARE @filedata VARCHAR(MAX) =
'City|TemperatureInCelcius
Namakkal|31
New York|18
London|7
Chennai|30
Singapore|29'

/* Row Delimiter: New Line (\r\n); Column Delimiter: | */
-------------------------------------------
SET @filedata = @filedata + CHAR(13) -- Adding line to avoid length issue in last recursion
-------------------------------------------
/* Parse Logic using recursive CTE */
;WITH cterows AS
(
	SELECT SUBSTRING(@filedata, 1, CHARINDEX(CHAR(13), @filedata, 1)-1) AS rowdata
		, STUFF(@filedata, 1, CHARINDEX(CHAR(13), @filedata, 1)+1,'') AS remainingdata
	UNION ALL
	SELECT SUBSTRING(remainingdata, 1, CHARINDEX(CHAR(13), remainingdata, 1)-1) AS rowdata
		, STUFF(remainingdata, 1, CHARINDEX(CHAR(13), remainingdata, 1)+1,'') AS remainingdata
	FROM cterows WHERE LEN(remainingdata) > 0
),ctetable AS
(
SELECT SUBSTRING(rowdata, 1, CHARINDEX('|', rowdata, 1)-1) AS City
	, SUBSTRING(rowdata, CHARINDEX('|', rowdata, 1)+1, LEN(rowdata)) AS TemperatureInCelcius
FROM cterows 
)
SELECT * FROM ctetable WHERE City <> 'City'