-- Name: Abhirami Kapilan

-- Complete Question 1, 7, 12 and 15 - Mandatory
-- The rest of the questions are optional 

--Q1
SELECT product_id, product_name
FROM products
WHERE discontinued = 0
ORDER BY product_name;


--Q7
--Method1
SELECT COUNT(employee_id)
FROM employees
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) > 5;

--Method 2
SELECT COUNT(employee_id)
FROM public.employees
WHERE hire_date < current_date - INTERVAL '5 years';


--Q12
SELECT country,COUNT(Supplier_id) AS "Number of Suppliers"
FROM suppliers
WHERE country IN ('USA', 'Italy','France') 
     AND fax IS NOT NULL
GROUP BY country
ORDER BY country DESC;


--Q15
SELECT first_name,address,hire_date
FROM employees
WHERE address LIKE '%2%'
AND hire_date<(SELECT hire_date
FROM employees
WHERE first_name='Steven')
ORDER BY first_name;


--Optional Questions

--Q2)
--Write a query to get Product list (name, unit price) where products cost between $15 and $25.

--(discontinued=0)
SELECT product_name, unit_price
FROM products
WHERE ((unit_price<=25 AND unit_price>=15) 
		AND(discontinued=0));


SELECT product_name,unit_price
FROM products
WHERE unit_price BETWEEN 15 AND 25;

	
--Q3)
--Write a query to get Product list (name, units on order, units in stock) of stock is less than the quantity on order.

----(discontinued=0)
SELECT product_name, units_on_order, units_in_stock
FROM products
WHERE ((units_in_stock < units_on_order) AND (discontinued=0));

SELECT product_name,units_on_order,units_in_stock
FROM products
WHERE units_in_stock < units_on_order;


--Q4)
--Select all product names, unit price and the supplier region that don’t have suppliers from the USA country. 
SELECT * FROM products;
SELECT * FROM suppliers;

SELECT p.product_name, p.unit_price, s.region
FROM products p
INNER JOIN suppliers s
ON p.supplier_id = s.supplier_id
WHERE s.country <> 'USA';

--Q5 
--Get all customer names that live in the same city as the employees.
SELECT * FROM customers;
SELECT * FROM employees;

SELECT Distinct c.contact_name
FROM customers c
INNER JOIN employees e 
ON c.city = e.city;

--Q6
--Get the number of customers living in each country 
--Where the number of residents is greater than 10 and sort the countries in descending order.

SELECT country,COUNT(*) AS number_of_customers
FROM customers
GROUP BY country
HAVING COUNT(*) > 10
ORDER BY number_of_customers DESC;

--Q8)
--When was the first employee hired in the company?
SELECT MIN(hire_date) AS first_hire_date
FROM employees;

--Q9)
/*Display the Customer Name (ContactName) and the number of orders ordered by this customer, 
for customers living in the UK. Arrange the result based on the number of orders from the greatest to the lowest.*/
SELECT * from orders;

SELECT c.contact_name AS customer_name, COUNT(o.order_id) AS num_orders
FROM Customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE c.country ='UK'
GROUP BY c.contact_name
ORDER BY num_orders DESC;

--Q10)
/* Get the number of orders for each displayed Customer Name (ContactName) living in the USA and 
restrict the result for those customers who ordered more than five orders. Label any un-named column(s) 
with a meaningful name(s) */

SELECT c.contact_name AS customer_name, COUNT(o.order_id) num_order
FROM Customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE c.country ='USA'
GROUP BY c.contact_name
HAVING COUNT(o.order_id)>5;


--Q11)
/* Get the total quantity ordered for each displayed product name with unit price higher than 30. 
Restrict the result for those products having total ordered quantity in the range between 1000 and 1500. 
Label any un-named column(s) with a meaningful name(s) */

SELECT p.product_name, p.unit_price,SUM(od.quantity) AS total_quantity_ordered
FROM products p
JOIN order_details od 
ON p.product_id = od.product_id
WHERE p.unit_price > 30
GROUP BY p.product_name, p.unit_price
HAVING SUM(od.quantity) BETWEEN 1000 AND 1500;

--Q13)
/* Display the first name, job title and the city of all employees not working as 
Sales Managers and living in the same city as the employee with first name: Michael. 
Sort the result by the first name of the employees in an ascending order.*/ 

SELECT e.first_name, e.title, e.city
FROM employees e
WHERE e.title <> 'Sales Manager' 
    AND e.city = (SELECT city FROM employees WHERE first_name = 'Michael') 
ORDER BY e.first_name ASC;

--Q14)
/*14.	Display the first name, job title and the country of all employees working as 
Sales Representatives and living in the same country as the manager 
(Note: the manager is the person that doesn’t report to anyone). Sort the result by the first name of the employees in a descending order.*/

SELECT * FROM employees

SELECT e.first_name, e.title, e.country
FROM employees e
WHERE e.title = 'Sales Representative'
AND e.country = (
    SELECT country FROM employees
    WHERE reports_to IS NULL
)
ORDER BY e.first_name DESC


--Q16)
/*Display the first name, country and the birth date of all employees who were born 
before 1958 and are working in the same country as the employee with first name: Laura. Sort the result 
by the first name of the employees in an ascending order*/

SELECT e.first_name, e.country, e.birth_date
FROM employees e
WHERE e.birth_date < '1958-01-01' 
    AND e.country = (SELECT country FROM employees WHERE first_name = 'Laura' LIMIT 1)
ORDER BY e.first_name ASC;

--Q17)
/*For each displayed country name, show how many products were supplied by suppliers who have got a fax number. 
Restrict the result for those countries having less than five supplied products. Label any un-named column(s) by a meaningful name(s). */

SELECT s.country,COUNT(p.product_id) AS num_products_supplied
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
WHERE s.fax IS NOT NULL
GROUP BY s.country
HAVING COUNT(p.product_id) < 5;
