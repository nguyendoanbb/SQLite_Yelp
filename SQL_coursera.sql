/*Project: Yelp Dataset SQL Lookup
Name: Nguyen Doan
Date: 7/10/2018
Purpose: Coursera's SQL for Data Science*/

/*Profile the data*/

SELECT * 
FROM attribute

SELECT * 
FROM business 

SELECT * 
FROM category

SELECT * 
FROM checkin

SELECT * 
FROM elite_years

SELECT * 
FROM friend

SELECT * 
FROM hours

SELECT * 
FROM review

SELECT * 
FROM tip

SELECT * 
FROM user

/*Total distinct records in each table*/
SELECT distinct business_id
FROM attribute

SELECT distinct id
FROM business

SELECT distinct business_id
FROM hours

SELECT distinct business_id
FROM category

SELECT distinct business_id
FROM review

SELECT distinct business_id
FROM checkin

SELECT distinct business_id
FROM photo

SELECT distinct business_id
FROM tip

SELECT distinct id
FROM user

SELECT distinct user_id
FROM friend

SELECT distinct user_id
FROM elite_years

/*Check for NULL values in Users table*/
SELECT *
FROM user
WHERE name is NULL or 
	review_count is NULL or
	yelping_since is NULL or
	useful is NULL or
	funny is NULL or
	cool is NULL or 
	fans is NULL or
	average_stars is NULL or
	compliment_hot is NULL or 
	compliment_more is NULL or
	compliment_profile is NULL or
	compliment_cute is NULL or
	compliment_list is NULL or 
	compliment_note is NULL or 
	compliment_plain is NULL or
	compliment_cool is NULL or
	compliment_funny is NULL or
	compliment_writer is NULL or
	compliment_photos is NULL 

/*descriptive statistics for each column*/
SELECT min(stars), max(stars), avg(stars)
	FROM review

SELECT min(stars), max(stars), avg(stars)
	FROM business

SELECT min(likes), max(likes), avg(likes)
	FROM tip

SELECT min(count), max(count), avg(count)
	FROM checkin

SELECT min(review_count), max(review_count), avg(review_count)
	FROM user

/*cities with the most reviews in descending order*/
SELECT city, sum(review_count)
	FROM business
	GROUP BY city
	ORDER BY sum(review_count) desc

/*distribution of star ratings in Avon city*/
SELECT stars as star_rating, count(stars) as count
	FROM business 
	WHERE city = 'Avon'
	GROUP BY stars

/*distribution of star ratings in Beachwood city*/
SELECT stars as star_rating, count(stars) as count
	FROM business 
	WHERE city = 'Beachwood'
	GROUP BY stars

/*top 3 users based on their total number of reviews*/
SELECT name, review_count
	FROM user 
	ORDER BY review_count desc
	LIMIT 3

/*top 10 users based on their total number of fans */
SELECT name, review_count, fans
	FROM user 
	ORDER BY fans desc
	LIMIT 10

/*count reviews with the word 'love' and 'hate'*/
SELECT count(text)
	FROM review
	WHERE text LIKE '%love%'
	UNION
	SELECT count(text)
	FROM review 
	WHERE text LIKE '%hate%'

/*relationship between having a high number of fans and being listed as 'useful' or 'funny'*/
SELECT funny, useful, fans, name
	FROM user
	ORDER BY funny desc, useful desc, fans desc

/*city with highest number of business*/
SELECT count(id), city
	FROM business
	GROUP BY city
	ORDER BY count(id) desc

/*category with highest number of business*/
SELECT count(business_id), category 
	FROM category
	GROUP BY category
	ORDER BY count(business_id) desc

/*compare 2-3 stars and 4-5 stars group in food category of Phoenix city*/
SELECT b.name, 
	c.category, 
	b.stars, 
	b.review_count as r_count, 
	h.hours,
	SUBSTR(h.hours,1,3) as open_day
FROM business as b
	INNER JOIN category as c on b.id = c.business_id
	INNER JOIN hours as h on b.id = h.business_id
WHERE b.city = 'Phoenix'
	AND c.category LIKE '%food%'
	GROUP BY b.stars, open_day
	HAVING b.stars in (2,2.5,3,4,4.5,5)
	ORDER BY open_day, b.stars

/*check correlation between location and 2 groups*/
SELECT b.name, 
	c.category, 
	b.stars, 
	b.postal_code as zipcode,
	b.latitude,
	b.longitude,
	SUBSTR(h.hours,1,3) as open_day
FROM business as b
INNER JOIN category as c on b.id = c.business_id
INNER JOIN hours as h on b.id = h.business_id
WHERE b.city = 'Phoenix'
	AND c.category LIKE '%food%'
	GROUP BY b.stars, open_day
	HAVING b.stars in (2,2.5,3,4,4.5,5)
	ORDER BY b.stars, open_day

/*difference betwen business that are still open and the ones that are closed*/

SELECT b.name,
	sum(c.count) as checkin_total,
	b.review_count,
	b.is_open
FROM checkin as c
INNER JOIN business as b on b.id = c.business_id
GROUP BY b.id
ORDER BY checkin_total desc
 
-- generate Yelp dataset for regression anaysis
SELECT user_id, stars, text, date, yelping_since,
useful, funny, cool, fans
	FROM review as r 
	INNER JOIN user as u ON r.user_id = u.id
	INNER JOIN business as b on r.business_id = 

/* group of interests:
- Restaurants
- Food 
*/

--average stars in each category
select c.category, count(c.business_id), avg(b.stars)
from business as b 
inner join category as c on b.id = c.business_id 
	group by c.category 
	order by count(c.business_id) desc  


select 
name, 
review_count, 
cast(julianday('now')- julianday(strftime('%Y-%m-%d', yelping_since)) as integer) as member_day_total, 
average_stars,
count(e.year) as total_elite,
u.useful,
u.funny,
u.cool,
u.fans,
u.compliment_hot as c_hot,
u.compliment_more as c_more,
u.compliment_profile as c_profile,
u.compliment_cute as c_cute,
u.compliment_list as c_list,
u.compliment_note as c_note,
u.compliment_plain as c_plain,
u.compliment_cool as c_cool,
u.compliment_funny as c_funny,
u.compliment_writer as c_write,
u.compliment_photos as c_photos, 
r.text
from user as u
left join review as r on r.user_id = u.id
left join elite_years as e on e.user_id = u.id
left join tip as t on t.user_id = u.id
group by u.id
order by review_count desc

https://www.coursera.org/learn/sql-for-data-science/peer/lBaEP/data-scientist-role-play-profiling-and-analyzing-the-yelp-dataset/review/rR-RMIvHEeixcg7-I5Ek7A

