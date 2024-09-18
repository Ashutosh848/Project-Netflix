LOAD DATA INFILE "C:/netflix_titles.csv"
INTO TABLE netflix
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

#1. Count the number of Movies vs TV Shows
select type,count(type) as total_content from netflix group by type;

#2. Find the most common rating for movies and TV shows
select type,rating from
(select type,rating,count(*),
rank() over(partition by type order by count(*) desc) 
as ranking from netflix 
group by type,rating)
as t1 where ranking = 1;

#3. List all movies released in a specific year (e.g., 2020)
select * from netflix where type = "Movie" and release_year = "2020";

#4. Find the top 5 countries with the most content on Netflix
select country,count(type) as total_count from netflix
 group by country order by total_count desc limit 5;
 
#5. Identify the longest movie
select * from netflix;
select type,title,duration from netflix where type = "Movie"
 and duration = (select max(duration) from netflix)
 order by duration desc;
 
#6.Find content added in the last 5 years
select title,date_added,release_year from netflix where release_year>=2015 and release_year<=2021 order by release_year desc;

#7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix where director like "%Rajiv Chilaka%";

#8. List all TV shows with more than 5 seasons
select * from netflix where type = "TV Show" and duration >="5 Seasons";

#9.Find each year and the average numbers of content release in India on netflix. 
#return top 5 year with highest avg content release!

SELECT 
    release_year,
    COUNT(show_id) AS show_count,
    COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE "%India%") AS proportion
FROM 
    netflix
WHERE 
    country LIKE "%India%"
GROUP BY 
    release_year;

#10.Find all content without a director
select * from netflix where director = "";

#11.Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix where casts like "%Salman Khan%" order by release_year desc limit 10;

#12.Find the top 10 actors who have appeared in the highest number of movies produced in India.
select casts,count(show_id) from netflix where type = "Movie" and country like "%India%" group by casts order by count(show_id) desc;