USE imdb;

/* To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, we will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
SELECT 
    COUNT(*)
FROM
    movie;
-- Total number of rows in 'movie' table= 7997

SELECT 
    COUNT(*)
FROM
    genre;
-- Total number of rows in 'genre' table= 14662

SELECT 
    COUNT(*)
FROM
    director_mapping;
-- Total number of rows in 'director_mapping' table= 3867

SELECT 
    COUNT(*)
FROM
    role_mapping;
-- Total number of rows in 'role_mapping' table= 15615

SELECT 
    COUNT(*)
FROM
    names;
-- Total number of rows in 'names' table= 25735

SELECT 
    COUNT(*)
FROM
    ratings;
-- Total number of rows in 'ratings' table= 7997


-- Q2. Which columns in the movie table have null values?
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_id,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_title,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_year,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_date_published,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_duration,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_country,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_worlwide_gross_income,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_languages,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS NULL_COUNT_production_company
FROM
    movie;

-- Columns in the movie table having null values are :- 'country'(20), 'worldwide_wide_gross_income'(3724),'languages'(194),'production_company'(528).



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? 

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    year, COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY year;
/*+---------------+-----------------+
| Year			|	number_of_movies|
+-------------------+---------------+
|	2017		|	    3052		|
|	2018		|		2944		|
|	2019		|		2001		|
+---------------+-------------------+
- Number of movies released in 2017= 3052 [Highest]
- Number of movies released in 2018= 2944
- Number of movies released in 2019= 2001 [Lowest]  */

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;
/*+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+-------------------+
|	1			|	    804			|
|	2			|	    640 		|
|	3			|		824			|
|	4			|		680			|
|	5			|		625		    |
|	6			|		580			|
|	7			|		493			|
|	8			|		678			|
|	9			|		809			|
|	10			|		801			|
|	11			|		625			|
|	12			|		438			|
+---------------+-------------------+ 
-Highest number of movies are made in the month of March followed by September, January, October, etc.  
-Movies are usually refrained from releasing in the month of December, which has the lowest release in the entire year, due to some reason and are rather released in the 1st month, i.e., January*/


/*The highest number of movies is produced in the month of March.
So, now that we have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
SELECT 
    COUNT(DISTINCT id) AS number_of_movies, year
FROM
    movie
WHERE
    (country LIKE '%INDIA%'
        OR country LIKE '%USA%')
        AND year = 2019; 

-- Number of movies produced in the year 2019 is 1059.


/* USA and India produced more than a thousand movies in the year 2019. 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
SELECT DISTINCT
    genre
FROM
    genre;

-- There are a total of 13 unique genres present in the data set. They are Drama, Fantasy, Thriller, Comedy, Horror,Family, Romance, Adventure, Action, Sci-fi, Crime, Mystery and Others.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t we want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
SELECT 
    genre, COUNT(m.id) AS number_of_movies
FROM
    movie AS m
        INNER JOIN
    genre AS g
WHERE
    g.movie_id = m.id
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;

-- 'Drama' genre has the highest number of movies, i.e., 4285 movies.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre;

-- Number of movies having only one genre associated with them are 3289.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie AS m
        INNER JOIN
    genre AS g ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;

/* Average duration of movies in each genre is as follows:-
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+---------------+
|	Action  	|		112.88      |
|	Romance		|		109.53      |
|	Crime		|		107.05      |
|	Drama		|		106.77      |
|	Fantasy		|		105.14      |
|	Comedy		|		102.62      |
|	Adventure	|	    101.87      |
|	Mystery		|		101.80      |
|	Thriller	|		101.58      |
|	Family		|		100.97      |
|	Others		|		100.16      |
|	SCi-Fi		|		97.94       |
|	Horror		|		92.72       |
+---------------+-------------------+
The genre 'Drama' has the highest average duration of 106.77 minutes.
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_summary AS
(
           SELECT     genre,
                      Count(movie_id) AS movie_count ,
                      Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
           FROM       genre                                 
           GROUP BY   genre )
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER";

-- The genre 'Thriller' ranks 3rd.

--Thriller movies is in top 3 among all genres in terms of number of movies



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS MIN_AVG_RATING,
    MAX(avg_rating) AS MAX_AVG_RATING,
    MIN(total_votes) AS MIN_TOTAL_VOTES,
    MAX(total_votes) AS MAX_TOTAL_VOTES,
    MIN(median_rating) AS MIN_MEDIAN_RATING,
    MAX(median_rating) AS MAX_MEDIAN_RATING
FROM
    ratings; 




/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT     title,
           avg_rating,
           DENSE_RANK()OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings                               AS r
INNER JOIN movie                                 AS m
ON         m.id = r.movie_id limit 10;




-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)                     AS MOVIE_COUNT,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 

-- 'Dream Warrior Pictures', 'National Theatre Live' are the production houses with the highest number of hits.



-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
SELECT 
    genre, COUNT(M.id) AS MOVIE_COUNT
FROM
    movie AS M
        INNER JOIN
    genre AS G ON G.movie_id = M.id
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    year = 2017
        AND MONTH(date_published) = 3
        AND country LIKE '%USA%'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 

-- The genre 'Drama' had the most number of movies (24) which had more than 1000 votes.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
SELECT 
    title, avg_rating, genre
FROM
    movie AS M
        INNER JOIN
    genre AS G ON G.movie_id = M.id
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    avg_rating > 8 AND title LIKE 'THE%'
GROUP BY title
ORDER BY avg_rating DESC;


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
SELECT 
    median_rating, COUNT(*) AS movie_count
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- A total of 361 movies were given a median rating of 8.

-- Q17. Do German movies get more votes than Italian movies? 
SELECT 
    languages, SUM(total_votes) AS VOTES
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    languages LIKE '%Italian%' 
UNION SELECT 
    languages, SUM(total_votes) AS VOTES
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    languages LIKE '%GERMAN%'
ORDER BY votes DESC; 

-- German movies got 1861985 votes more than Italian movies.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

-- Every column has null except for the 'Name' column.

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?

/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

--  The top three directors are 'James Mangold', 'Joe Russo', 'Anthony Russo'.

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT 
    N.name AS actor_name, COUNT(movie_id) AS movie_count
FROM
    role_mapping AS RM
        INNER JOIN
    movie AS M ON M.id = RM.movie_id
        INNER JOIN
    ratings AS R USING (movie_id)
        INNER JOIN
    names AS N ON N.id = RM.name_id
WHERE
    R.median_rating >= 8
        AND category = 'ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2; 

-- Top two actors are 'Mammootty' and 'Mohanlal'.

/* RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

SELECT     production_company,
           Sum(total_votes)                            AS vote_count,
           Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS m
INNER JOIN ratings                                     AS r
ON         r.movie_id = m.id
GROUP BY   production_company limit 3;

-- The top three Prodution houses are 'Marvel Studios', 'Twentieth Century Fox' and 'Warner Bros.'.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?


/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

WITH actor_summary
     AS (SELECT N.NAME AS actor_name,
                total_votes,
                Count(R.movie_id) AS  movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
                   
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTOR'
                AND country = "india"
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_summary;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      total_votes,
                      Count(r.movie_id) AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie AS m
           INNER JOIN ratings AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country = "INDIA"
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     movie_count>=3 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary LIMIT 5;

-- The top 5 actresses are 'Taapsee Pannu','Kriti Sanon', 'Divya Dutta', 'Shraddha Kapoor' and 'Kriti Kharbanda'.

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/

WITH thriller_movies
     AS (SELECT DISTINCT title, avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 


-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 

/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/

SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;






-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 


/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/


WITH top_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie                                                                     AS m
           INNER JOIN genre                                                                     AS g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_genres)
            GROUP BY   movie_name
           )
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;

-- Top 3 Genres based on most number of movies are 'Action', Comedy' and 'Drama'.


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2; 

-- The top two production houses that have produced the highest number of hits are 'Star Cinema' and 'Twentieth Century Fox'.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)  AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie  AS m
           INNER JOIN ratings AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;

-- The top 3 actresses based on number of Super Hit movies are 'Parvathy Thiruvothu', 'Susan Brown' and 'Amanda Lawrence'.

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id AS director_id,
         NAME  AS director_name,
         Count(movie_id)  AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
