-- =========================================
-- Music Store Data Analysis
-- SQL Portfolio Project
-- =========================================

-- Skills demonstrated:
-- JOINs
-- GROUP BY and aggregate functions
-- CASE statements
-- Subqueries
-- Common Table Expressions (CTEs)
-- Window functions
-- Date-based analysis
-- Sorting and filtering


-- Query 1: Customer Invoice Transactions
SELECT
    customer.first_name,
    customer.last_name,
    invoice.total
FROM customer
INNER JOIN invoice
    ON customer.customer_id = invoice.customer_id;

--Query 2: Total Spending per Customer
	SELECT
    customer.first_name,
    customer.last_name,
    SUM(invoice.total) AS total_spent
FROM customer
INNER JOIN invoice
    ON customer.customer_id = invoice.customer_id
GROUP BY
    customer.customer_id,
    customer.first_name,
    customer.last_name
ORDER BY total_spent DESC;
--Query 3: Revenue by Genre
SELECT
    genre.name AS genre,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS revenue
FROM invoice_line
INNER JOIN track
    ON invoice_line.track_id = track.track_id
INNER JOIN genre
    ON track.genre_id = genre.genre_id
GROUP BY genre.name
ORDER BY revenue DESC;
--Query 4: Invoice Value Categories
SELECT
    invoice_id,
    total,
    CASE
        WHEN total >= 10 THEN 'High'
        WHEN total >= 5 THEN 'Medium'
        ELSE 'Low'
    END AS spending_category
FROM invoice;
--Query 5: Invoices Above Average Value
SELECT invoice_id, total
FROM invoice
WHERE total > (
    SELECT AVG(total)
    FROM invoice
);
--Query 6: High-Spending Customers (CTE)
WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total) AS total_spent
    FROM invoice
    GROUP BY customer_id
)
SELECT *
FROM customer_spending
WHERE total_spent > 40
ORDER BY total_spent DESC;
--Query 7: Customer Spending Rankings
SELECT
    customer_id,
    SUM(total) AS total_spent,
    RANK() OVER (ORDER BY SUM(total) DESC) AS spending_rank
FROM invoice
GROUP BY customer_id;
--Query 8: Monthly Revenue Analysis
SELECT
    DATE_TRUNC('month', invoice_date) AS sales_month,
    SUM(total) AS monthly_revenue
FROM invoice
GROUP BY sales_month
ORDER BY sales_month;
--Query 9: Revenue by Employee
SELECT
    employee.first_name,
    employee.last_name,
    SUM(invoice.total) AS revenue_generated
FROM employee
INNER JOIN customer
    ON employee.employee_id = customer.support_rep_id
INNER JOIN invoice
    ON customer.customer_id = invoice.customer_id
GROUP BY
    employee.employee_id,
    employee.first_name,
    employee.last_name
ORDER BY revenue_generated DESC;
--Query 10: Top 10 Tracks by Revenue
SELECT
    track.name AS track_name,
    SUM(invoice_line.quantity) AS units_sold,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS revenue
FROM invoice_line
INNER JOIN track
    ON invoice_line.track_id = track.track_id
GROUP BY track.track_id, track.name
ORDER BY revenue DESC
LIMIT 10;