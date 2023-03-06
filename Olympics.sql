-- Table: public.Athlete Events

-- DROP TABLE IF EXISTS public."Athlete Events";

CREATE TABLE IF NOT EXISTS public."Athlete Events"
(
    id integer,
    name character varying COLLATE pg_catalog."default",
    sex character varying COLLATE pg_catalog."default",
    age character varying COLLATE pg_catalog."default",
    height character varying COLLATE pg_catalog."default",
    weight character varying COLLATE pg_catalog."default",
    team character varying COLLATE pg_catalog."default",
    noc character varying COLLATE pg_catalog."default",
    games character varying COLLATE pg_catalog."default",
    year integer,
    season character varying COLLATE pg_catalog."default",
    city character varying COLLATE pg_catalog."default",
    "sport " character varying COLLATE pg_catalog."default",
    event character varying COLLATE pg_catalog."default",
    medal character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Athlete Events"
    OWNER to postgres;

--How many olympics games have been held?
SELECT COUNT(DISTINCT games) 
FROM "Athlete Events"

--List down all Olympics games held so far.
SELECT DISTINCT year, season, city 
FROM "Athlete Events"
ORDER BY year

--Mention the total no of nations who participated in each olympics game?
SELECT games, COUNT(DISTINCT noc) as total_countries
FROM "Athlete Events"
GROUP BY games

--Which year saw the highest and lowest no of countries participating in olympics
with low as
(SELECT CONCAT(games, ' - ', COUNT(DISTINCT noc)) as lowest_countries 
FROM "Athlete Events"
GROUP BY games
ORDER BY COUNT(DISTINCT noc)
LIMIT 1),
high as
(SELECT CONCAT(games, ' - ', COUNT(DISTINCT noc)) as highest_countries 
FROM "Athlete Events"
GROUP BY games
ORDER BY COUNT(DISTINCT noc) DESC
LIMIT 1)
SELECT *
FROM low, high


--Which nation has participated in all of the olympic games
with tot_games as
	(SELECT COUNT(DISTINCT games) as total_games
	FROM "Athlete Events"),
	countries as
	(SELECT games, nr.region as country
	FROM "Athlete Events" ah
	Join "noc regions" nr on ah.noc = nr.noc
	GROUP BY games, nr.region),
	countries_participated as
    (SELECT country, count(1) as total_participated_games
    FROM countries
    GROUP BY country)
SELECT cp.*
FROM countries_participated cp
JOIN tot_games tg on tg.total_games = cp.total_participated_games
ORDER BY 1;

--Identify the sport which was played in all summer olympics.
SELECT "sport ", COUNT(DISTINCT(games)) as no_of_games, COUNT(DISTINCT(year)) as total_games
FROM "Athlete Events"
WHERE season = 'Summer' 
GROUP BY "sport "
ORDER BY no_of_games DESC
LIMIT 5

--Which Sports were just played only once in the olympics.
with t1 as
          	(SELECT DISTINCT games, "sport "
          	FROM "Athlete Events"),
          t2 as
          	(SELECT "sport ", COUNT(1) as no_of_games
          	FROM t1
          	GROUP BY "sport ")
      SELECT t2.*, t1.games
      FROM t2
      JOIN t1 on t1."sport " = t2."sport "
      WHERE t2.no_of_games = 1
      ORDER BY t1."sport "
	  
--Fetch the total no of sports played in each olympic games.

SELECT games, COUNT(DISTINCT "sport " ) as no_of_sports
FROM "Athlete Events"
GROUP BY games
ORDER BY no_of_sports DESC, games


--Fetch oldest athletes to win a gold medal
SELECT name, sex, 
CASE
	WHEN age = 'NA' THEN '0'
	ELSE age
END as age,
team, games, city, "sport ", event, medal
FROM "Athlete Events"
WHERE medal = 'Gold'
ORDER BY age DESC


--Fetch the top 5 athletes who have won the most gold medals.
SELECT name, team, COUNT(name) as total_gold_medals
FROM "Athlete Events"
WHERE medal = 'Gold'
GROUP BY name, team
ORDER BY total_gold_medals DESC
LIMIT 5


--List down total gold, silver and bronze medals won by each country.
with t1 as
	(SELECT team, medal, COUNT(medal) as gold
	FROM "Athlete Events" ae
	WHERE medal = 'Gold'
	GROUP BY team, medal),
	t2 as
	(SELECT team, medal, COUNT(medal) as silver
	FROM "Athlete Events" ae
	WHERE medal = 'Silver'
	GROUP BY team, medal),
	t3 as 
	(SELECT team, medal, COUNT(medal) as bronze
	FROM "Athlete Events" ae
	WHERE medal = 'Bronze'
	GROUP BY team, medal)
SELECT t1.team, t1.gold, t2.silver, t3.bronze
FROM t1
JOIN t2 on t1.team = t2.team
JOIN t3 on t1.team = t3.team
ORDER BY t1.gold DESC, t2.silver DESC, t3.bronze DESC


--In which Sport, France has won highest medals.
SELECT "sport ", team, COUNT(medal) as total_medals
FROM "Athlete Events"
WHERE team = 'France' and medal <> 'NA'
GROUP BY "sport ", team
ORDER BY total_medals DESC
LIMIT 1


--Break down all olympic games where France won medal for Fencing and how many medals in each olympic games
SELECT "sport ", team, games, COUNT(medal) as total_medals
FROM "Athlete Events"
WHERE team = 'France' and medal <> 'NA' and "sport " = 'Fencing'
GROUP BY "sport ", team, games
ORDER BY total_medals DESC





	  





