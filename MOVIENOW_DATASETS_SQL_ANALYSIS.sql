 
 --SQL PROJECT


--MOVIENOW

--1. Create an ERD for the tables in the database

CREATE DATABASE movienow

DROP TABLE IF EXISTS "movies";
CREATE TABLE movies
(
    movie_id INT PRIMARY KEY,
    title TEXT,
    genre TEXT,
    runtime INT,
    year_of_release INT,
    renting_price numeric
);



DROP TABLE IF EXISTS "actors";
CREATE TABLE actors
(
    actor_id integer PRIMARY KEY,
    name character varying,
    year_of_birth integer,
    nationality character varying,
    gender character varying
);




DROP TABLE IF EXISTS "actsin";
CREATE TABLE actsin
(
    actsin_id integer PRIMARY KEY,
    movie_id integer,
    actor_id integer,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);




DROP TABLE IF EXISTS "customers";
CREATE TABLE customers
(
	customer_id integer PRIMARY KEY,
    name character varying,
    country character varying,
    gender character varying,
    date_of_birth date,
    date_account_start date
);




DROP TABLE IF EXISTS "renting";
CREATE TABLE renting
(
    renting_id integer PRIMARY KEY,
    customer_id integer NOT NULL,
    movie_id integer NOT NULL,
    rating integer,
    date_renting date,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),  
     FOREIGN KEY (movie_id) REFERENCES movies(movie_id));

SELECT * FROM customers
SELECT * FROM renting
SELECT * FROM movies
SELECT * FROM actsin
SELECT * FROM actors


--2. How much income did each movie generate?

SELECT movie_id, title, SUM(renting_price) income
FROM renting 
LEFT JOIN movies USING (movie_id)
GROUP BY movie_id,title;


--3 Which genre are most in demand?

SELECT genre, COUNT(genre) no_of_genre
FROM renting 
LEFT JOIN movies USING (movie_id)
GROUP BY genre 
ORDER BY no_of_genre DESC;

--Drama is the most genre in demand


--4. Top 5 highest spending customers and the number of times they patronized
MovieNow?


SELECT name, customer_id,COUNT(customer_id) times, SUM(renting_price)amount_spent
FROM (SELECT * 
FROM renting 
LEFT JOIN movies USING (movie_id))a 
LEFT JOIN customers USING (customer_id)
GROUP BY (customer_id),name
ORDER BY amount_spent DESC
LIMIT 5 


--5 How much money is spent on rentals by each Customer?

SELECT name, customer_id, SUM(renting_price)amount_spent
FROM (SELECT * 
FROM renting 
LEFT JOIN movies USING (movie_id))a 
LEFT JOIN customers USING (customer_id)
GROUP BY (customer_id),name
ORDER BY amount_spent DESC

--6. Who is the most popular actor in spain?
SELECT actsin_id, COUNT(actsin_id) no_of_times, name, nationality
FROM actsin 
LEFT JOIN actors USING (actor_id)
WHERE nationality = 'Spain'
GROUP BY name, nationality, actsin_id

--7. If MovieNow decides to reward her highest paying customer. Who would that
customer be and what country would that customer be residing?

SELECT name, customer_id,COUNT(customer_id) times, SUM(renting_price)amount_spent, country
FROM (SELECT * 
FROM renting 
LEFT JOIN movies USING (movie_id))a 
LEFT JOIN customers USING (customer_id)
GROUP BY (customer_id),name,country
ORDER BY amount_spent DESC
LIMIT 1 


--8.  Who are MovieNow customers and where do they come from?

SELECT name, customer_id,renting_id, country
FROM (SELECT * 
FROM renting 
LEFT JOIN movies USING (movie_id))a 
LEFT JOIN customers USING (customer_id)
GROUP BY (customer_id),name,country,name,renting_id


--9. Which movies have a perfect rating of 10. find out the top 10 based on how
recent they were released.
select * from movies
select * from renting

SELECT title,rating,year_of_release
FROM renting 
LEFT JOIN movies USING (movie_id)
WHERE rating = 10
ORDER BY year_of_release DESC 
LIMIT 10
