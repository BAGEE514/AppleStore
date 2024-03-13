CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**Exploratory Analysis**

--Check unique apps in both tables

SELECT COUNT(DISTINCT ID) AS UniqueAppIDS
FROM AppleStore

SELECT COUNT(DISTINCT ID) AS UniqueAppIDS
FROM appleStore_description_combined

--Check for any missin values

SELECT COUNT(*) as MissingValues
FROM AppleStore
WHERE track_name is NULL or user_rating is NULL or prime_genre is NULL

SELECT COUNT(*) as MissingValues
FROM appleStore_description_combined
WHERE app_desc is NULL

--Number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
group BY prime_genre
Order by NumApps DESC

--Overview of app ratings

SELECT min(user_rating) as MinRating,
		max(user_rating) as MaxRating,
	  	avg(user_rating) as AvgRating
FROM AppleStore

--Do paid apps have higher rating than free appsAppleStore

SELECT CASE 
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
         END AS App_Type,
         avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY App_Type

--Do apps with more supported languages have higher ratings

SELECT CASE 
			WHEN lang_num > 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
         END AS language_bucket,
         avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

--Check Genres with lowest  ratings

SELECT prime_genre,
	   avg(user_rating) AS Avg_Rating
from AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
limit 10

--Check correlation between length of app description and user rating

SELECT CASE
			WHEN length(AC.app_desc) < 500 THEN 'Short'
            WHEN length(AC.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
        END AS description_length_bucket,
        avg(a.user_rating) AS average_rating
FROM 
	AppleStore as A 
JOIN 
	appleStore_description_combined AS AC
ON 
	A.id = AC.id
GROUP BY description_length_bucket
ORDER BY average_rating DESC

--Check top rated apps for each genre

SELECT 
	   prime_genre,
	   track_name,
       user_rating
FROM  (
  	   SELECT
  	   prime_genre,
	   track_name,
       user_rating,
       RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank 
       FROM 
       AppleStore
      ) AS a 
WHERE 
A.RANK = 1
       



       