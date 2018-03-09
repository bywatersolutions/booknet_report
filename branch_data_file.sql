SELECT
    'System_Code' AS 'System Code',
    'Branch_Code' AS branchcode,
    'Branch_Name' AS branchname,
    'Branch_Type' AS "Branch type",
    'Postal_code' AS "Postal code",
    'Address'     AS Address,
    'User_Count'  AS 'User count',
    'Date'        AS Date
UNION
(
    SELECT
        'CHANGEME' AS 'System Code',
        branchcode,
        branchname,
        "Public" AS "Branch type",
        branchzip AS "Postal code",
        CONCAT_WS('; ',
        branchaddress1,
        branchaddress2,
        branchaddress3,
        branchcity,
        branchstate,
        branchcountry) AS Address,
        COUNT(borrowernumber) AS 'User count',
        DATE_FORMAT(CURRENT_DATE, "%m/%d/%Y") as Date
    FROM
        borrowers
    JOIN
        branches USING (branchcode)
    WHERE
        dateexpiry >= CURDATE()
    GROUP BY branchcode 
)

