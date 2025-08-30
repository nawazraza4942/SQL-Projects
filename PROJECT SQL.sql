CREATE TABLE Books(
	Book_ID	SERIAL	PRIMARY KEY,
	Title	VARCHAR(100)	NOT NULL,
	Author	VARCHAR(100)	NOT NULL,
	Genre	VARCHAR(100)	,
	Published_Year	INT	,
	Price	NUMERIC (10,2),	
	Stock	SMALLINT	
);

SELECT * FROM Books;

CREATE TABLE Customers(
Customer_ID	SERIAL	PRIMARY KEY,
Name	VARCHAR(100)	NOT NULL,
Email	VARCHAR(100)	UNIQUE,
Phone	INT	,
City	VARCHAR(100),	
Country	VARCHAR(100)	
);

SELECT * FROM Customers;

DROP TABLE Orders;

CREATE TABLE Orders(
	Order_ID	SERIAL	PRIMARY KEY,
Customer_ID	INT REFERENCES Customers(Customer_ID)	,
Book_ID	INT REFERENCES Books(Book_ID)	,
Order_Date	DATE,	
Quantity	INT,	
Total_Amount	NUMERIC(10,2)	
);

SELECT * FROM Orders;



COPY Books(Book_ID,Title,Author, Genre, Published_Year, Price,Stock)
FROM 'C:\Program Files\PostgreSQL\17\data\Books.csv'
CSV HEADER;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE Genre= 'Fantasy';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year>1950 ;

-- 3) List all customers from the Canada:

SELECT * FROM Customers 
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:

SELECT * FROM Orders
WHERE order_date BETWEEN '01-11-2023' AND '30-11-2023';

-- 5) Retrieve the total stock of books available:

SELECT SUM (stock) AS Total_STock
FROM Books;


-- 6) Find the details of the most expensive book:

SELECT * FROM Books
ORDER BY price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM orders
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM orders
WHERE total_amount>20;



-- 9) List all genres available in the Books table:

SELECT DISTINCT genre
FROM BOOKS;

-- 10) Find the book with the lowest stock:

SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM (total_amount)
AS REVENUE
FROM Orders;

-- Advance Questions : 

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.genre, SUM(o.quantity) AS Total_sold 
FROM Books b JOIN orders o ON o.book_id = b.book_id
GROUP BY genre ;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) 
FROM Books 
WHERE genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;


-- 4) Find the most frequently ordered book:
SELECT Book_id, COUNT (Order_id) AS ORDER_COUNT 
FROM orders
GROUP BY Book_id
ORDER BY ORDER_COUNT DESC;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author ,SUM(o.quantity) AS total_books_sold
FROM orders o 
JOIN Books b ON O.Book_id = b.Book_id
GROUP BY author ;

-- 7) List the cities where customers who spent over $30 are located:

SELECT c.city, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount >30 ;

-- 8) Find the customer who spent the most on orders:

SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;






