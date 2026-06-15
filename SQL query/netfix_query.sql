---- Netflix project

CREATE TABLE netflix(
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts  VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM netflix;

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Showsunt

SELECT type,
     COUNT(*) AS total_content
	 FROM netflix
	 GROUP BY type;



--2. Find the most common rating for movies and TV shows

SELECT type, rating, total
FROM
(
SELECT 
	type,
	rating,
	COUNT(*) AS total,
	RANK() OVER(
	PARTITION BY type 
	ORDER BY COUNT(*) DESC
	) AS rnk
FROM netflix
GROUP BY type,rating
)
WHERE rnk = 1;



--3. List all movies released in a specific year (e.g., 2020)


SELECT title, release_year
     FROM netflix
	 WHERE release_year='2020'



--4. Find the top 5 countries with the most content on Netflix


SELECT 
       UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	   COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
	   

--5. Identify the longest movie or TV show duration


SELECT title,duration
FROM netflix
WHERE type='Movie'
ORDER BY 
CAST(SPLIT_PART(duration,' ',1) AS INT) DESC
LIMIT 1 OFFSET 3;


--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY')
>= CURRENT_DATE - INTERVAL '5 years';



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT title,type,director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';



--8. List all TV shows with more than 5 seasons

SELECT title,duration AS Season
FROM netflix
WHERE type ='TV Show'
AND
CAST(SPLIT_PART(duration,' ',1) AS INT)>5;



--9. Count the number of content items in each genre


SELECT
TRIM(unnest(string_to_array(listed_in,','))) AS genre,
COUNT(*) AS total
FROM netflix
GROUP BY genre
ORDER BY total DESC;



--10. Find the average release year for content produced in a specific country


SELECT 
country,
ROUND(AVG(release_year),0) AS avg_year
FROM netflix
WHERE country LIKE '%India%'
GROUP BY country;


--11. List all movies that are documentaries

SELECT title, type
FROM netflix
WHERE type='Movie'
AND 
Listed_in LIKE '%Documentaries%';


--12. Find all content without a director

SELECT * FROM NETFLIX
WHERE director is NULL;

13. Find how many movies actor 'Salman Khan' appeared in last 10 years

14. Find the top 10 actors who have appeared in the highest number of movies produced in India

15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
Label content containing these keywords as 'Bad' and all other content as 'Good'. 
Count how many items fall into each category.