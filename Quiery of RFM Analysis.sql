CREATE TABLE ecommerce_data (
    invoiceno VARCHAR(50),
    stockcode VARCHAR(50),
    description TEXT,
    quantity INT,
    invoicedate TIMESTAMP,
    unitprice DECIMAL(10, 2),
    customerid INT,
    country VARCHAR(50)
);

COPY ecommerce_data(invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country)
FROM '/Users/elifcici/Desktop/Olist_Dataset/E-Commerce Data_RFM.csv'
DELIMITER ','
CSV HEADER
ENCODING 'WIN1252';

'RFM Score Query'

WITH recency AS 
( 
    WITH max_date AS (
        SELECT
            customerid,
            MAX(invoicedate::date) AS max_invoicedate
        FROM
            ecommerce_data
        WHERE
            InvoiceNo NOT LIKE 'C%' 
            AND customerid IS NOT NULL 
            AND unitprice <> 0
        GROUP BY
            customerid
    )
    SELECT
        customerid,
        max_invoicedate,
        EXTRACT(DAY FROM AGE('2011-12-09'::date, max_invoicedate)) AS recency
    FROM
        max_date
),

frequency AS
(
    SELECT
        customerid,
        COUNT(DISTINCT invoiceno) AS frequency
    FROM
        ecommerce_data
    WHERE
        invoiceno NOT LIKE 'C%' 
        AND customerid IS NOT NULL 
        AND unitprice <> 0
    GROUP BY
        customerid
),

monetary AS
(
    SELECT
        customerid,
        SUM(quantity * unitprice) AS monetary
    FROM
        ecommerce_data
    WHERE
        invoiceno NOT LIKE 'C%' 
        AND customerid IS NOT NULL 
        AND unitprice <> 0
    GROUP BY
        customerid
)

SELECT
    r.customerid,
    r.recency,
    NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
    f.frequency,
    
    -- Using CASE WHEN instead of NTILE for frequency
    CASE 
        WHEN f.frequency = 1 THEN 1
        WHEN f.frequency BETWEEN 2 AND 3 THEN 2
        WHEN f.frequency BETWEEN 4 AND 5 THEN 3
        WHEN f.frequency BETWEEN 6 AND 10 THEN 4
        ELSE 5
    END AS frequency_score,
    
    m.monetary,
    NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score,

    -- Adjusted RFM Score calculation using the modified frequency score
    CAST(
        (NTILE(5) OVER (ORDER BY recency DESC) * 100) + 
        (CASE 
            WHEN f.frequency = 1 THEN 1
            WHEN f.frequency BETWEEN 2 AND 3 THEN 2
            WHEN f.frequency BETWEEN 4 AND 5 THEN 3
            WHEN f.frequency BETWEEN 6 AND 10 THEN 4
            ELSE 5
        END * 10) + 
        (NTILE(5) OVER (ORDER BY monetary DESC))
        AS VARCHAR
    ) AS rfmscore

FROM
    recency AS r
INNER JOIN
    frequency AS f ON r.customerid = f.customerid
INNER JOIN
    monetary AS m ON m.customerid = r.customerid
ORDER BY
    rfmscore DESC;
	
	
WITH recency AS 
( 
    WITH max_date AS (
        SELECT
            customerid,
            MAX(invoicedate::date) AS max_invoicedate
        FROM
            ecommerce_data
        WHERE
            InvoiceNo NOT LIKE 'C%' AND 
		customerid IS NOT NULL AND
		unitprice <> 0
		
        GROUP BY
            customerid
    )

    SELECT
        customerid,
        max_invoicedate,
        EXTRACT(DAY FROM AGE('2011-12-09'::date, max_invoicedate)) AS recency
    FROM
        max_date
),

frequency AS
(
    SELECT
        customerid,
        COUNT(DISTINCT invoiceno) AS frequency
    FROM
        ecommerce_data
    WHERE
        invoiceno NOT LIKE 'C%'AND 
		customerid IS NOT NULL AND
		unitprice <> 0
		
    GROUP BY
        customerid
),

monetary AS
(
    SELECT
        customerid,
        SUM(quantity * unitprice) AS monetary
    FROM
        ecommerce_data
    WHERE
        invoiceno NOT LIKE 'C%'AND 
		customerid IS NOT NULL AND
		unitprice <> 0
    GROUP BY
        customerid
),

RFMScores  AS
(
	SELECT
    r.customerid,
    r.recency,
    NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
    f.frequency,
    NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
    m.monetary,
    NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score,
    CAST((NTILE(5) OVER (ORDER BY recency DESC) * 100) + (NTILE(5) OVER (ORDER BY frequency DESC) * 10) + (NTILE(5) OVER (ORDER BY monetary DESC)) AS VARCHAR) AS rfmscore
FROM
    recency AS r
INNER JOIN
    frequency AS f ON r.customerid = f.customerid
INNER JOIN
    monetary AS m ON m.customerid = r.customerid
ORDER BY
    rfmscore DESC
)
	
	SELECT
    customerid,
    recency,
    recency_score,
    frequency,
    frequency_score,
    monetary,
    monetary_score,
    CASE
        WHEN rfmscore ~ '[1-2][1-2]' THEN 'Hibernating'
        WHEN rfmscore ~ '[1-2][3-4]' THEN 'At Risk'
        WHEN rfmscore ~ '[1-2]5' THEN 'Can''t Lose'
        WHEN rfmscore ~ '3[1-2]' THEN 'About to Sleep'
        WHEN rfmscore = '33' THEN 'Need Attention'
        WHEN rfmscore ~ '[3-4][4-5]' THEN 'Loyal Customers'
        WHEN rfmscore = '41' THEN 'Promising'
        WHEN rfmscore = '51' THEN 'New Customers'
        WHEN rfmscore ~ '[4-5][2-3]' THEN 'Potential Loyalists'
        WHEN rfmscore ~ '5[4-5]' THEN 'Champions'
        ELSE 'Undefined'
    END AS segment
FROM
    RFMScores

