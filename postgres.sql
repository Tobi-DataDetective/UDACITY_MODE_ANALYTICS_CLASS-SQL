SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

SELECT *
FROM orders
LIMIT 1000;

--Get the 10 most recent orders
SELECT *
FROM orders
ORDER BY occurred_at DESC
LIMIT 10;

-- Return the 10 earliest orders in the orders table incude the id, occurred_at and total_amt_usd
SELECT id,occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- top 5 largest orders
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

--Write a query to return the bottom 20 orders in terms of least
SELECT id, account_id, total
FROM orders
ORDER BY total
LIMIT 20;


-- order by with multiple columns
SELECT account_id, total_amt_usd
FROM orders
ORDER  BY total_amt_usd DESC, account_id;
--
SELECT account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

--Write a query that returns the top 5 rows from orders ordered according to newest
--to oldest, but with the largest total_amt_usd for each date listed first for each date.
SELECT *
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;
--Write a query that returns the top 10 rows from orders ordered according to oldest to newest,
 --but with the smallest total_amt_usd for each date listed first for each date
SELECT *
FROM orders
ORDER BY occurred_at ASC, total_amt_usd ASC
LIMIT 10;


--------------------------------------------Using the WHERE clause
-- Pull the first 5 rows and all columns from
--the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
ORDER BY id
LIMIT 5;

--Pull the first 10 rows and all
--columns from the orders table that have a total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
ORDER BY id
LIMIT 10;

--WHERE with Non-Numeric
--Filter the accounts table to include the company name, website, and
--the primary point of contact (primary_poc) for Exxon Mobil in the accounts table.
SELECT name, website
FROM accounts
WHERE name = 'Exxon Mobil';
ORDER BY
LIMIT

------Questions using Arithmetic Operations
--Create a column that divides the standard_amt_usd by the standard_qty
--to find the unit price for standard paper for each order.
 --Limit the results to the first 10 orders, and include the id and account_id fields.
 SELECT id, account_id, standard_amt_usd/standard_qty AS std_unit_price
 FROM orders
-- WHERE
-- ORDER BY
 LIMIT 10;

--Write a query that finds the percentage of revenue that comes from poster paper
--for each order. You will need to use only the columns that end with _usd.
 --(Try to do this without using the total column). Include the id and account_id fields.
SELECT id, account_id,
       poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd)+2 AS post_per
FROM orders;

--------------------------------------Introduction to Logical Operators----------------
--LIKE
--This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
--
--IN
--This allows you to perform operations similar to using WHERE and =, but for more than one condition.
--
--NOT
--This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN
--a certain condition.
--
--AND & BETWEEN
--These allow you to combine operations where all combined conditions must be true.
--
--OR
--This allow you to combine operations where at least one of the combined conditions must be true.

--All the companies whose names start with 'C'.
SELECT *
FROM accounts
WHERE name LIKE 'C%';

--All companies whose names contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name LIKE '%one%';

--All companies whose names end with 's'.
SELECT *
FROM accounts
WHERE name LIKE '%s';

---Use the accounts table to find the account name, primary_poc, and sales_rep_id
---for Walmart, Target, and Nordstrom.

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstorm');

--Use the web_events table to find all in
--formation regarding individuals who were contacted via the channel of organic or adwords.

SELECT *
FROM web_events
WHERE channel IN ('organic','adwords');

--Use the accounts table to find the account name,
-- primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart','Target','Nordstrom');

--Use the web_events table to find all information regarding
--individuals who were contacted via any method except using organic or adwords methods.

SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';


SELECT *
FROM accounts
WHERE name NOT LIKE '%one%'
LIMIT 10;

SELECT *
FROM accounts
WHERE name NOT LIKE '%s'
LIMIT 10;

------------------------------------AND and BETWEEN
--Write a query that returns all the
--orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

--Using the accounts table find all the companies whose names do not start with 'C' and end with 's'

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

SELECT *
FROM web_events
WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;


---------------------------- OR
--Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table

SELECT id
FROM orders
WHERE (gloss_qty > 4000) OR (poster_qty > 4000);

--Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);


SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');



--------------------------JOIN STATEMENT
orders.account_id
accounts.id

SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON accounts.id = orders.account_id
LIMIT 5;



--Provide a table for all web_events associated with
--account name of Walmart. There should be three columns.
--Be sure to include the primary_poc, time of the event, and the
--channel for each event. Additionally, you might choose
--to add a fourth column to assure only Walmart events were chosen.

SELECT we.occurred_at, we.channel, ac.name, ac.primary_poc
FROM web_events as we
JOIN accounts as ac
ON we.account_id = ac.id
WHERE ac.name = 'Walmart'
LIMIT 5;

--Provide a table that provides the region for each sales_rep
--along with their associated accounts. Your final table should include
--three columns: the region name, the sales rep name, and the account name.
--Sort the accounts alphabetically (A-Z) according to account name.

--table with sales_rep account details, should have
--region name, rep name, account name ,
--sort asc with account name

SELECT sr.name as sale_rep_name, ac.name as acct_name, rg.name as region_name
FROM sales_reps as sr
JOIN accounts as ac
ON sr.id = ac.sales_rep_id
JOIN region as rg
ON rg.id = sr.region_id
ORDER BY ac.name;

--Provide the name for each region for every order,
--as well as the account name and the unit price they paid
--(total_amt_usd/total) for the order. Your final table should have 3
--columns: region name, account name, and unit price. A few accounts
--have 0 for total,
--so I divided by (total + 0.01) to assure not dividing by zero.
--
--get the order and give the regions, account name and unit price (total_amt_usd/total)
--from orders for them
--region_name, account_name, unit price

SELECT r.name as region_name,
        a.name as account_name,
        (o.total_amt_usd/(o.total+0.01)) as unit_price
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
JOIN sales_reps as s
ON s.id = a.sales_rep_id
JOIN region as r
ON r.id = s.region_id;



--Provide a table that provides the region for each sales_rep along with
--their associated accounts. This time only for the Midwest region.
--Your final table should include three columns: the region name, the
--sales rep name, and the account name.
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name as RegionName, s.name as SalasRepName, a.name as AccountName
FROM sales_reps as s
LEFT JOIN accounts as a
ON s.id = a.sales_rep_id
LEFT JOIN region as r
ON r.id = s.region_id
WHERE r.name = 'Midwest'
ORDER BY a.name;

--Provide a table that provides the region for each sales_rep along
--with their associated accounts. This time only for accounts where the
--sales rep has a first name starting with S and in the Midwest region.
--Your final table should include three columns: the region name, the sales rep name, and the account name.
--Sort the accounts alphabetically (A-Z) according to account name.


SELECT r.name as RegionName, s.name as SalasRepName, a.name as AccountName
FROM sales_reps as s
LEFT JOIN accounts as a
ON s.id = a.sales_rep_id
LEFT JOIN region as r
ON r.id = s.region_id
WHERE s.name LIKE 'S%' AND (r.name = 'Midwest')
ORDER BY a.name;



--Provide a table that provides the region for each sales_rep along with
--their associated accounts. This time only for accounts where the sales
--rep has a last name starting with K and in the Midwest region.
--Your final table should include three columns: the region name,
--the sales rep name, and the account name.
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name as RegionName, s.name as SalasRepName, a.name as AccountName
FROM sales_reps as s
LEFT JOIN accounts as a
ON s.id = a.sales_rep_id
LEFT JOIN region as r
ON r.id = s.region_id
WHERE s.name LIKE '% K%' AND (r.name = 'Midwest')
ORDER BY a.name;


--Provide the name for each region for every order, as well as the
--account name and the unit price they paid (total_amt_usd/total) for
--the order. However, you should only provide the results if the
--standard order quantity exceeds 100 and the poster order quantity
--exceeds 50. Your final table should have 3 columns: region name,
--account name, and unit price. Sort for the smallest unit price first.
--In order to avoid a division by zero error, adding .
--01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT o.id, r.name as RegionName, a.name as AccountName, (o.total_amt_usd/(o.total+0.01)) as unit_price
FROM orders as o
LEFT JOIN accounts as a
ON o.account_id = a.id
LEFT JOIN sales_reps as s
ON a.sales_rep_id = s.id
LEFT JOIN region as r
ON s.region_id = r.id
WHERE (o.standard_qty > 100) AND (o.poster_qty > 50)
ORDER BY unit_price;


--What are the different channels used by account id 1001?
--Your final table should have only 2 columns: account name and
--the different channels. You can try
--SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.name as AccountName, w.channel as Channels
FROM accounts as a
LEFT JOIN web_events as w
ON a.id = w.account_id
WHERE a.id = 1001;


--Find all the orders that occurred in 2015.
--Your final table should have 4 columns:
-- occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2015-12-31'
ORDER BY o.occurred_at DESC;


----------------------------AGGREGATES
SELECT COUNT (*) as NumberOfRows
FROM accounts;

SELECT COUNT (accounts.id) as NumberOfRows
FROM accounts;


SELECT COUNT(primary_poc)
FROM accounts;

SELECT COUNT(*)
FROM accounts
WHERE primary_poc IS NULL;

--Find the total amount of poster_qty paper ordered in the orders table.

SELECT SUM(poster_qty) AS total_poster_qty
FROM orders;

--Find the standard_amt_usd per unit of standard_qty paper. Your
--solution should use both an aggregation and a mathematical operator.

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

--What was the smallest order placed by each ]
--account in terms of total usd. Provide only two columns -
--the account
--name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name as AccountName,
        MIN(o.total_amt_usd) as OrderAmount
FROM accounts as a
LEFT JOIN  orders as o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY OrderAmount ASC;

--Find the number of sales reps in each region.
--Your final table should have two columns - the region and
--the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name as RegionName, COUNT(s.name) NumberOfSalesReps
FROM region as r
LEFT JOIN sales_reps as s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY NumberOfSalesReps;


--For each account, determine the average amount of each type
--of paper they purchased across their orders.
-- Your result should have four columns - one for the account name
-- and one for the average
--quantity purchased for each of the paper types for each account.

SELECT a.name as AccountName,
        AVG(poster_amt_usd) Avg_Poster,
        AVG(gloss_amt_usd) Avg_Glossy,
        AVG(standard_amt_usd) Avg_Std
FROM accounts as a
LEFT JOIN orders as o
ON a.id = o.account_id
GROUP BY AccountName;



--For each account, determine the average amount spent per order on
--each paper type. Your result should have four columns - one for the
--account name and one for the average amount spent on each paper type.

SELECT a.name as AccountName,
        AVG(o.standard_amt_usd/(o.standard_qty+0.01)) ,
        AVG(o.gloss_amt_usd/(o.gloss_qty+0.01)) gloss,
        AVG(o.poster_amt_usd/(o.poster_qty+0.01))  pos
FROM accounts as a
LEFT JOIN orders as o
ON a.id = o.account_id
GROUP BY AccountName;


--Determine the number of times a particular channel was used in the
--web_events table for each sales rep. Your final table should have
--three columns - the name of the sales rep, the channel, and the number
--of occurrences.
--Order your table with the highest number of occurrences first.

SELECT s.name sale_name,
        w.channel channel,
        COUNT (a.*) num_of_times
FROM sales_reps as s
LEFT JOIN accounts as a
ON s.id = a.sales_rep_id
LEFT JOIN web_events as w
ON w.account_id = a.id
GROUP BY sale_name, channel
ORDER BY num_of_times DESC;

--Determine the number of times a particular channel was used in
--the web_events table for each region. Your final table should have
--three columns - the region name, the channel, and the number
--of occurrences.
--Order your table with the highest number of occurrences first.

SELECT r.name RegionName,
       w.channel channel,
       COUNT(r.id)  num_of_times
FROM sales_reps as s
LEFT JOIN accounts as a
ON s.id = a.sales_rep_id
LEFT JOIN web_events as w
ON w.account_id = a.id
LEFT JOIN region as r
ON r.id = s.region_id
GROUP BY RegionName, channel
ORDER BY num_of_times DESC;

-----------------DISTINCT
--Use DISTINCT to test if there are any accounts associated with
--more than one region.

SELECT DISTINCT a.name account, r.name region
FROM accounts as a
JOIN sales_reps as s
ON a.sales_rep_id = s.id
JOIN region as r
ON r.id = s.region_id
ORDER BY a.name;

------------------------------------HAVING

--How many of the sales reps have more than 5 accounts that they manage?

SELECT s.name as "Sales Rep",
        COUNT(a.id) as "Number of Accounts"
FROM accounts as a
JOIN sales_reps as s
ON a.sales_rep_id = s.id
JOIN region as r
ON r.id = s.region_id
GROUP BY s.name
HAVING COUNT(a.id) > 5;

--Which account has spent the most with us?
SELECT a.name ,
        max(total_amt_usd) as "Total Amount"
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY "Total Amount" DESC
LIMIT 1;

SELECT a.name ,
        SUM(total_amt_usd) as "Total Amount"
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY "Total Amount" DESC
LIMIT 1;


--Which accounts used facebook as
--a channel to contact customers more than 6 times?

SELECT a.name as account, w.channel as channel,
        COUNT(*) AS freq
FROM accounts as a
JOIN web_events as w
ON a.id = w.account_id
GROUP BY account,channel
HAVING w.channel = 'facebook' AND COUNT(*) > 6
ORDER BY freq;

--Which channel was most frequently used by most accounts?
SELECT  a.name as account, w.channel as channel,
        COUNT(a.id) AS freq
FROM accounts as a
JOIN web_events as w
ON a.id = w.account_id
GROUP BY a.name, channel
ORDER BY COUNT(a.id) DESC
LIMIT 10;

----------------------DATES
--Find the sales in terms of total dollars for all orders in each year,
--ordered from greatest
--to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year',occurred_at) as yr,
        SUM(o.total_amt_usd) as amount
FROM orders AS o
GROUP BY 1
ORDER BY 1;

--Which month did Parch & Posey have the greatest sales in terms of
--total dollars? Are all months evenly represented by the dataset?


SELECT DATE_PART('month',occurred_at) as months,
        SUM(o.total_amt_usd) as amount
FROM orders AS o
GROUP BY 1
ORDER BY 2 DESC;

--Which year did Parch & Posey have the greatest sales in
--terms of total number of orders?
--Are all years evenly represented by the dataset?

SELECT DATE_PART('year',o.occurred_at) as years,
        COUNT(o.id)
FROM orders as o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--In which month of which year did
--Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', occurred_at) as "month of year",
        a.name as name,SUM(o.gloss_amt_usd) as amount
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

----------------------------------------CASE
SELECT account_id,
        CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
             ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

--We would like to understand 3 different levels of customers based on
--the amount associated with their purchases. The top branch includes
-- anyone with a Lifetime Value (total sales of all orders) greater
-- than 200,000 usd. The second branch is between 200,000 and 100,000
-- usd. The lowest branch is anyone under 100,000 usd. Provide a table
-- that includes the level associated with each account. You should
-- provide the account name, the total sales of all orders for the customer,
--and the level. Order with the top spending customers listed first.

SELECT a.name as id, sum(o.total_amt_usd) as amount,
        CASE WHEN sum(o.total_amt_usd) > 200000 THEN 'TOP'
             WHEN sum(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'MIDDLE'
             ELSE 'BOTTOM' END AS "customer group"
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2;



SELECT DATE_PART('year',o.occurred_at) as years,
        sum(o.total_amt_usd) as amount,
        CASE WHEN sum(o.total_amt_usd) > 200000 THEN 'TOP'
             WHEN sum(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'MIDDLE'
             ELSE 'BOTTOM' END AS "customer group"
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 1 DESC
LIMIT 2;



--We would now like to perform a similar calculation to the first,
--but we want to obtain the total amount spent by customers only in
--2016 and 2017. Keep the same levels as in the previous question.
--Order with the top spending customers listed first.
SELECT a.name as id, sum(o.total_amt_usd) as amount,
        CASE WHEN sum(o.total_amt_usd) > 200000 THEN 'TOP'
             WHEN sum(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'MIDDLE'
             ELSE 'BOTTOM' END AS "customer group"
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
WHERE o.occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 desc;

--We would like to identify top performing sales reps, which are
--sales reps associated with more than 200 orders. Create a table with
--the sales rep name, the total number of orders, and a column with top
--or not depending on if they have more than 200 orders.
--Place the top sales people first in your final table.

SELECT s.name, COUNT(*) num_ords,
        CASE WHEN COUNT(*) > 200 THEN 'top'
        ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;


--Use the test environment below to find the number of
--events that occur for each day for each channel.

SELECT channel, AVG(event_count) as avg_count
FROM (SELECT DATE_TRUNC('day',occurred_at),
            channel,
            COUNT(*) AS event_count
    FROM web_events
    GROUP BY 1,2
    ORDER BY 1) sub
GROUP BY 1;


SELECT  DATE_TRUNC('month',occurred_at), avg(standard_qty),
        avg(standard_amt_usd),avg(gloss_qty),avg(gloss_amt_usd),
        avg(poster_qty), avg(poster_amt_usd)
FROM
    (SELECT *
    FROM orders
    WHERE DATE_TRUNC('month',occurred_at) =
    (SELECT DATE_TRUNC('month',MIN(occurred_at))
    FROM orders)
    ORDER BY occurred_at) sub2
GROUP BY 1;


--Provide the name of the sales_rep in each region with the
--largest amount of total_amt_usd sales.

SELECT t3.sales_name, t3.region_name, t3.max_std
FROM
    (SELECT region_name, MAX(max_std) as max_std
    FROM
        (SELECT s.name as sales_name, r.name as region_name, MAX(o.standard_amt_usd) as max_std
        FROM sales_reps as s
        JOIN region as r
        ON s.region_id = r.id
        JOIN accounts as a
        ON s.id = a.sales_rep_id
        JOIN orders as o
        ON o.account_id = a.id
        GROUP BY 1,2) AS t1
    GROUP BY 1) AS t2
JOIN
        (SELECT s.name as sales_name, r.name as region_name, MAX(o.standard_amt_usd) as max_std
        FROM sales_reps as s
        JOIN region as r
        ON s.region_id = r.id
        JOIN accounts as a
        ON s.id = a.sales_rep_id
        JOIN orders as o
        ON o.account_id = a.id
        GROUP BY 1,2) AS t3
ON t3.region_name = t2.region_name AND t3.max_std = t2.max_std;




########################################################################################################################
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
         SELECT MAX(total_amt)
         FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                 FROM sales_reps s
                 JOIN accounts a
                 ON a.sales_rep_id = s.id
                 JOIN orders o
                 ON o.account_id = a.id
                 JOIN region r
                 ON r.id = s.region_id
                 GROUP BY r.name) sub);


--------------------------WITH STATEMENT---------------------
--Provide the name of the sales_rep in each region with
--the largest amount of total_amt_usd sales.

SELECT s.name as sales_reps, r.name as region, a.name as acct_name,
        o.total_amt_usd
FROM region as r
JOIN sales_reps as s
ON r.id = s.region_id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON o.account_id = a.id;


SELECT s.name as sales_reps, r.name as region,
        SUM(o.total_amt_usd) total_amt_usd
FROM region as r
JOIN sales_reps as s
ON r.id = s.region_id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON o.account_id = a.id
GROUP BY 1,2;



WITH sum_regions AS (SELECT s.name as sales_reps, r.name as region,
                    SUM(o.total_amt_usd) total_amt_usd
                    FROM region as r
                    JOIN sales_reps as s
                    ON r.id = s.region_id
                    JOIN accounts as a
                    ON a.sales_rep_id = s.id
                    JOIN orders as o
                    ON o.account_id = a.id
                    GROUP BY 1,2),
     max_region AS (SELECT region, MAX(total_amt_usd) AS total_amt_usd
                    FROM sum_regions
                    GROUP BY 1
                    ORDER BY 2 DESC)


SELECT sr.sales_reps, sr.region, sr.total_amt_usd
FROM sum_regions as sr
JOIN max_region as mr
ON sr.region = mr.region AND sr.total_amt_usd = mr.total_amt_usd
ORDER BY 3 DESC;






--For the region with the largest sales total_amt_usd,
--how many total orders were placed?

WITH region_total_sales AS (SELECT r.name as region, SUM(o.total_amt_usd) AS total_amt_usd
                            FROM sales_reps as s
                            JOIN region as r
                            ON s.region_id = r.id
                            JOIN accounts as a
                            ON a.sales_rep_id = s.id
                            JOIN orders as o
                            ON o.account_id = a.id
                            GROUP BY 1),

     max_total_amt_usd AS (SELECT MAX(total_amt_usd)
                            FROM region_total_sales)

SELECT r.name as region, COUNT(o.total) AS total
FROM sales_reps as s
JOIN region as r
ON s.region_id = r.id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON o.account_id = a.id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT * FROM max_total_amt_usd);




--For the name of the account that purchased the most (in total over their
--lifetime as a customer) standard_qty paper, how many accounts still had
--more in total purchases?

WITH t1 AS (SELECT a.name as account, SUM(o.standard_qty) as std_qty,
                                SUM(O.total) as total
                        FROM accounts as a
                        JOIN orders as o
                        ON o.account_id = a.id
                        GROUP BY 1
                        ORDER BY 2 DESC
                        LIMIT 1),

     t2 AS (SELECT a.name as account
                        FROM accounts as a
                        JOIN orders as o
                        ON o.account_id = a.id
                        GROUP BY 1
                        HAVING SUM(O.total) > (SELECT total FROM t1))

SELECT COUNT(*)
FROM t2;






SELECT a.name as account, SUM(o.total) as total
FROM sales_reps as s
JOIN region as r
ON s.region_id = r.id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON o.account_id = a.id
GROUP BY 1
HAVING SUM(o.total) > (SELECT * FROM max_acct_qyt);




--For the customer that spent the most (in total over their lifetime
-- as a customer)
--total_amt_usd, how many web_events did they have for each channel?





WITH t2 AS (SELECT a.id, a.name as account, SUM(o.total_amt_usd) as total_amt_usd
        FROM accounts as a
        JOIN orders as o
        ON a.id = o.account_id
        GROUP BY 1,2
        ORDER BY 3 DESC
        LIMIT 1)

SELECT a.id, a.name as account, w.channel AS channel, COUNT(*) AS freq
FROM accounts as a
JOIN web_events as w
ON a.id = w.account_id
GROUP BY 1,2,3
HAVING a.id = (select t2.id from t2);
