--############################LEFT AND RIGHT######################

--In the accounts table, there is a column holding the website for each
--company. The last three digits specify what type of web address they
--are using. A list of extensions (and pricing) is provided here.
--Pull these extensions and provide how many of each website type exist
--in the accounts table.

SELECT RIGHT(website,3) AS account_type,
        COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2;



--There is much debate about how much the name (or even the first letter
--of a company name) matters. Use the accounts table to pull the first
--letter of each company name to see the
--distribution of company names that begin with each letter (or number).

SELECT LEFT(name,1) AS letter,
        COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;


--Use the accounts table and a CASE statement to create two groups:
--one group of company names that start with a number and a second
--group of those company names that start with a letter. What proportion
--of company names start with a letter?

WITH GROUPING AS (SELECT name,
                    CASE WHEN LEFT(UPPER(name),1) IN ('0','1','2','3','4','5','6','7','8','9')
                    THEN 1 ELSE 0 END AS "num",
                    CASE WHEN LEFT(UPPER(name),1) IN ('0','1','2','3','4','5','6','7','8','9')
                    THEN 0 ELSE 1 END AS "letter"
                    FROM accounts)

SELECT SUM(num) AS num,sum(letter) AS letter
FROM GROUPING;


--Use the accounts table to create first and last name columns that
--hold the first and last names for the primary_poc.

SELECT primary_poc,
        LEFT(primary_poc, (POSITION(' ' IN primary_poc) - 1)) AS first_name,
        RIGHT(primary_poc, (LENGTH(primary_poc) - POSITION(' ' IN primary_poc))) AS last_name
FROM accounts;



--Each company in the accounts table wants to create an email address
--for each primary_poc. The email address should be the first name of
--the primary_poc . last name primary_poc @ company name .com.


WITH t1 AS (SELECT primary_poc,
                    LEFT(primary_poc, (POSITION(' ' IN primary_poc) - 1)) AS first_name,
                    RIGHT(primary_poc, (LENGTH(primary_poc) - POSITION(' ' IN primary_poc))) AS last_name
            FROM accounts)

SELECT first_name, last_name, CONCAT(LOWER(first_name),'.',LOWER(last_name),'.com') as primary_email
FROM t1;


--You may have noticed that in the previous solution some of the company
--names include spaces, which will certainly not work in an email address.
--See if you can create an email address that will work by removing all of
--the spaces in the account name, but otherwise your solution should be
--just as in question 1. Some helpful documentation is here.

--SELECT name, regexp_split_to_table(name)
--FROM accounts;

WITH t1 AS (SELECT *
            FROM accounts)

SELECT name, CONCAT(regexp_replace(name,'[^\w]+','','g'),'.com') AS site
FROM t1;



WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

--We would also like to create an initial password, which they will
--change after their first log in. The first password will be the first
--letter of the primary_poc's first name (lowercase), then the last letter
--of their first name (lowercase), the first letter of their last name
--(lowercase), the last letter of their last name (lowercase), the number
--of letters in their first name, the number of letters in their last
--name, and then the name of
--the company they are working with, all capitalized with no spaces.

SELECT name, primary_poc,
        POSITION(' ' IN primary_poc),
        LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) as first_name,
        RIGHT(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1), 1) as firstname_ll,
        RIGHT(primary_poc,LENGTH(primary_poc)-LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)))) as last_name,
        LEFT(primary_poc,1) as firstname_fl,
        LEFT(RIGHT(primary_poc,LENGTH(primary_poc)-LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)))),1) as lastname_fl,
        RIGHT(RIGHT(primary_poc,LENGTH(primary_poc)-LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)))),1) as lastname_ll,
        LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)) as len_firstname,
        LENGTH(RIGHT(primary_poc,LENGTH(primary_poc)-LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc))))) as len_lastname,
        UPPER(regexp_replace(name,'[^\w]+','','g'))

FROM accounts;

-- DONE
SELECT name, primary_poc,
        CONCAT(LEFT(LOWER(primary_poc),1),
            RIGHT(LEFT(LOWER(primary_poc), POSITION(' ' IN LOWER(primary_poc))-1), 1),
            LEFT(RIGHT(LOWER(primary_poc),LENGTH(LOWER(primary_poc))-LENGTH(LEFT(LOWER(primary_poc), POSITION(' ' IN LOWER(primary_poc))))),1),
            RIGHT(RIGHT(LOWER(primary_poc),LENGTH((LOWER(primary_poc)))-LENGTH(LEFT(LOWER(primary_poc), POSITION(' ' IN LOWER(primary_poc))))),1),
            LENGTH(LEFT(LOWER(primary_poc), POSITION(' ' IN LOWER(primary_poc))-1)),
            LENGTH(RIGHT(LOWER(primary_poc),LENGTH(LOWER(primary_poc))-LENGTH(LEFT(LOWER(primary_poc), POSITION(' ' IN LOWER(primary_poc)))))),
            UPPER(regexp_replace(name,'[^\w]+','','g'))
            ) AS password

FROM accounts;


###################### WINDOWS FUNCTION ##########################

--Using Derek's previous video as an example, create another running
--total. This time, create a running total of standard_amt_usd (in the
--orders table) over order time with no date truncation. Your final table
-- should have two columns: one with the amount
--being added for each new row, and a second with the running total.

SELECT standard_amt_usd,
        SUM(standard_amt_usd) OVER (ORDER BY occurred_at) as running_total

FROM orders;


SELECT standard_amt_usd,
        DATE_TRUNC('year',occurred_at) as yearly,
        SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at) ORDER BY occurred_at) as running_total

FROM orders;



--Select the id, account_id, and total variable from the orders table,
--then create a column called total_rank that ranks this total amount of
--paper ordered (from highest to lowest) for each account
--using a partition. Your final table should have these four columns.

SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;









SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders




SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders







SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))