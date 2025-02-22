

-- players who have both scored and assisted in the same matchnosql
WITH goal_and_assist_times AS (
	SELECT DISTINCT S.player_id, P.name, count(S.match_id) as times
	FROM PlayerScoresnosql AS S
	JOIN PlayerAssistnosql AS A 
 	 	ON S.player_id = A.player_id AND S.match_id = A.match_id
	JOIN Playernosql AS P 
  		ON S.player_id = P.id
	GROUP BY S.player_id, P.name	
)
SELECT player_id, ga.name, times, country, birth, position, foot, highest_market_value, height
FROM goal_and_assist_times AS ga
JOIN Playernosql as P
	ON ga.player_id = P.id
where country is not null and birth is not null and position is not null and foot is not null and highest_market_value is not null and height is not null
ORDER BY times desc



-- most international goals and their market value
with int_goals_player as (
	with goals_matches as(
		select player_id, match_id, count(*) as goals
		from playerscoresnosql p join matchnosql m on p.match_id = m.id
		where international_match = true
		group by player_id, match_id
	)
	select player_id, sum(goals) as total_international_goals
	from goals_matches gm
	group by player_id
)
select player_id, total_international_goals, name, highest_market_value
from int_goals_player join playernosql on player_id = id
where highest_market_value is not null
order by total_international_goals desc



--players nomined for ballon dor but have 0 international goals in the dataset
with nomined_bd_int_goals as (
	select n.player_id
	from playernominedbdnosql n join playerscoresnosql s on n.player_id = s.player_id join matchnosql m on s.match_id = m.id
	where m.international_match = true
)
select name, year as nomination_year, n.position as nomined_in_position, country, highest_market_value, height
from playernominedbdnosql n join playernosql p on p.id = n.player_id
where player_id not in (select * from nomined_bd_int_goals) and highest_market_value is not null
order by highest_market_value desc

-- let's try to see if there is a correlation among lost matches and number of transfers (maybe more wins, means more trophies, which means more money and so more players bought)
with v1 as(
	select home_club_id, count(*) as matches_won_as_home_team
	from matchnosql
	where home_score > away_score
	group by home_club_id
	order by matches_won_as_home_team desc
),
v2 as(
	select away_club_id, count(*) as matches_won_as_away_team
	from matchnosql
	where home_score < away_score
	group by away_club_id
	order by matches_won_as_away_team desc	
),
v3 as(
	select acquiring_club_id, sum(cost) as total_money_spent
	from transfernosql
	group by acquiring_club_id
	having sum(cost) > 0
	order by total_money_spent desc
)
select home_club_id as club_id, matches_won_as_away_team + matches_won_as_home_team as total_matches_won, name, total_money_spent
from v1 join v2 on away_club_id = home_club_id join clubnosql on away_club_id = id join v3 on id = acquiring_club_id
order by total_matches_won desc

-- let's check see for the opposite correlation
with v1 as(
	select home_club_id, count(*) as matches_lost_as_home_team
	from matchnosql
	where home_score < away_score
	group by home_club_id
	order by matches_lost_as_home_team desc
),
v2 as(
	select away_club_id, count(*) as matches_lost_as_away_team
	from matchnosql
	where home_score > away_score
	group by away_club_id
	order by matches_lost_as_away_team desc	
),
v3 as(
	select acquiring_club_id, sum(cost) as total_money_spent
	from transfernosql
	group by acquiring_club_id
	having sum(cost) > 0
	order by total_money_spent desc
)
select home_club_id as club_id, matches_lost_as_away_team + matches_lost_as_home_team as total_matches_lost, name, total_money_spent
from v1 join v2 on away_club_id = home_club_id join clubnosql on away_club_id = id join v3 on id = acquiring_club_id
order by total_matches_lost desc;

-- trying to see if there is a correlation among the red cards and goals per matchnosql (it could be that a red card fosters one team to make more goals)
with v3 as(
	select stadium_name, count(*) as total_red_cards
	from  playertakesredcardnosql p join matchnosql m on p.match_id = m.id join clubnosql c on m.home_club_id = c.id
	where c.stadium_name is not null
	group by stadium_name
),
v1 as(
	select stadium_name, count(*) as c1
	from  playerscoresnosql p join matchnosql m on p.match_id = m.id join clubnosql c on m.home_club_id = c.id
	where c.stadium_name is not null
	group by stadium_name
),
v2 as(
	select stadium_name, count(*) as c2
	from matchnosql m join clubnosql c on m.home_club_id = c.id
	where c.stadium_name is not null
	group by stadium_name
),
v4 as(
	select v1.stadium_name, c1 as total_goals_scored, c2 as total_matches_played, (c1 * 1.0) / c2 as goals_per_match
	from v1 join v2 on v1.stadium_name = v2.stadium_name
	order by goals_per_match desc	
)
select *
from v3 join v4 on v3.stadium_name = v4.stadium_name
order by total_red_cards desc

SELECT AGE(TO_TIMESTAMP(birth, 'YYYY-MM-DD HH24:MI:SS')::DATE) AS age
FROM playernosql;

-- assuming that we infer that a player has played a game by checking if he is present in playertakesredcard, playerscores or playerassist, compute the total numbers of matches_played with the age, looking for young players who already have a lot of matches
with v as(
	select player_id, match_id
	from playerscoresnosql
	union
	select player_id, match_id
	from playerassistnosql
	union
	select player_id, match_id
	from playertakesredcardnosql
)
select player_id, name, AGE(TO_TIMESTAMP(birth, 'YYYY-MM-DD HH24:MI:SS')::DATE) AS age, count(distinct match_id) as total_matches
from v join playernosql on v.player_id = id
where birth is not null
group by player_id, birth, name
order by total_matches desc



select home_club_id
from matchnosql
except
select id
from clubnosql



