SELECT
    'Branch_Code' as homebranch,
    'Catalogue_key' as biblionumber,
    'Ean/ISBN13' AS ISBN,
    'Loans' AS Loans,
    'Renewal' AS Renewal,
    'Holds' AS Holds ,
    'Copies' AS Copies,
    'Copies_Out' AS 'Copies Out',
    'Ordered' AS Ordered,
    'Date' AS date
UNION
(
    SELECT
        homebranch,
        biblionumber,
        isbn AS ISBN,
        SUM( IF(type='issue',1,0) ) AS Loans,
        SUM( IF(type='renew',1,0) ) AS Renewal,
        IFNULL(Holds, 0) AS Holds ,
        Count( DISTINCT items.itemnumber) AS Copies,
        COUNT(DISTINCT onloan) AS 'Copies Out',
        SUM(notforloan=-7) AS Ordered,
        DATE_FORMAT( DATE_SUB( CURRENT_DATE, INTERVAL 1 DAY ), "%m/%d/%Y") as Date
    FROM
        items
        JOIN biblio USING (biblionumber)
        JOIN biblioitems USING (biblionumber)
        LEFT JOIN statistics
            ON items.itemnumber=statistics.itemnumber
            AND DATE(datetime) BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
            AND type IN ('issue','renew')
        LEFT JOIN (SELECT count(*) AS Holds, biblionumber FROM reserves GROUP BY biblionumber) hold_sub USING (biblionumber)
    WHERE isbn IS NOT NULL
    GROUP BY biblionumber
    ORDER BY Ordered,Loans DESC, Renewal DESC 
)

