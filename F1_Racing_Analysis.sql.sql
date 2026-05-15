select * from seasons; 
select * from status;	
select * from circuits; 
select * from races;
select * from drivers; 
select * from constructors;
select * from constructor_results;
select * from constructor_standings; 
select * from driver_standings;
select * from lap_times; 
select * from pit_stops; 
select * from qualifying; 
select * from results;
select * from sprint_results;

1)Identify the country which has produced the most F1 drivers.
select d.nationality,count(*)as no_of_racers 
from drivers d 
group by d.nationality
order by 2 desc;


2) Which country has produced the most no of F1 circuits
select c.country,count(*)as no_of_circuits 
from circuits c 
group by c.country
order by 2 desc;


3) Which countries have produced exactly 5 constructors? 
select c.nationality as country,count(*)
from constructors c
group by c.nationality  
having count(*)=5;


4) List down the no of races that have taken place each year
select r.year,count(*)as no_of_races
from races r
group by r.year
order by r.year desc;


5) Who is the youngest and oldest F1 driver?
select max(case when rn=1 then forename||' '||surname end) as oldest_driver
	, max(case when rn=cnt then forename||' '||surname end) as youngest_driver
	from (
		select *, row_number() over (order by dob ) as rn, count(*) over() as cnt
		from drivers) x
	where rn = 1 or rn = cnt;


6) List down the no of races that have taken place each year and mentioned which was the first and the last race of each season.
select distinct year
	,first_value(name) over(partition by year order by date) as first_race
	, last_value(name) over(partition by year order by date 
						   range between unbounded preceding and unbounded following) as last_race
	, count(*) over(partition by year) as no_of_races
	from races
	order by year desc;


7) Which circuit has hosted the most no of races. 
Display the circuit name, no of races, city and country.
with cte as 
   (select c.name as circuit_name,r.circuitid as circuitid,count(*)no_of_races
    ,rank()over(order by count(*)desc)
    from races r  
    join circuits c on r.circuitid=c.circuitid
    group by c.name,r.circuitid) 
select ct.circuit_name,ct.no_of_races,c.location as city,c.country as country,rank
from cte as ct 
join circuits c on c.circuitid=ct.circuitid
where rank=1;


8) List down the names of all F1 champions and the no of times they have won it.
with cte as 
          (select concat(d.forename,' ',d.surname) as driver_name,sum(rs.points) as points 
          ,rank()over(partition by r.year order by sum(rs.points)desc) 
           from driver_standings ds
           join drivers d on ds.driverid=d.driverid
           join results rs on rs.raceid=ds.raceid and rs.driverid=ds.driverid 
           join races r on r.raceid=ds.raceid 
           group by concat(d.forename,' ',d.surname),r.year),
	cte_rank as 
(select * from cte where rank = 1)
 select driver_name,count(*)
 from cte_rank
 group by driver_name
 order by 2 desc;


9) Who has won the most constructor championships
with cte as 
         (select c.constructorid,c.name as constructor_name,r.year,sum(cr.points)as constructor_points,
          rank()over(partition by r.year order by sum(cr.points)desc)
          from constructors c
          join constructor_results cr on cr.constructorid=c.constructorid
          join races r on r.raceid=cr.raceid 
          join constructor_standings cs on cs.constructorid=c.constructorid and cs.raceid=r.raceid
          group by c.name,r.year,c.constructorid),
cte_rank as 
          (select * from cte where rank=1)
      select constructor_name,count(*)
      from  cte_rank cr
      group by constructor_name
     order by 2 desc;


10) Identify the driver who won the championship or was a runner-up. Also display the team they belonged to. 
with cte as 
        (select concat(d.forename,' ',d.surname)as driver_name,sum(rs.points),r.year as year,c.name as constructor_name
        ,rank()over(partition by r.year order by sum(rs.points) )
         from drivers d 
         join driver_standings ds on ds.driverid=d.driverid
         join results rs on rs.driverid=d.driverid and rs.raceid=ds.raceid
         join races r on r.raceid=ds.raceid
         join constructors c on c.constructorid=rs.constructorid
         where r.year>=2020
         group by concat(d.forename,' ',d.surname),c.name,r.year)	 
select driver_name,year,case when rank=1 then 'WINNER'else 'RUNNER' end as flag
from cte  
where rank<=2;


11) Display the top 10 drivers with most wins.
select driver_name,no_of_wins
from(select ds.driverid,concat(d.forename,' ',d.surname)as driver_name
    ,count(*) as no_of_wins 
    ,rank()over(order by count(1)desc)
     from drivers d 
     join driver_standings ds on d.driverid=ds.driverid
     where ds.position=1
     group by ds.driverid,concat(d.forename,' ',d.surname))
where rank<=10;


12) Display the top 3 constructors of all time.
select constructor_name,races_win
from 
   (select c.name as constructor_name,count(*)as races_win,cs.position as position
   ,rank()over(order by count(*)desc)
    from constructors c
    join constructor_standings cs on c.constructorid=cs.constructorid
    join results rs on  rs.raceid=cs.raceid
    where cs.position=1
    group by c.name,cs.position)
where rank<=3;


13) Identify the drivers who have won races with multiple teams.
select driver_id,driver_name,string_agg(constructor_name,', ')
from(select distinct r.driverid as driver_id
    ,concat(d.forename,' ',d.surname) as driver_name
	,c.name as constructor_name
     from results r 
     join drivers d on d.driverid=r.driverid
     join constructors c on r.constructorid=c.constructorid
	 where r.position=1)
group by driver_id,driver_name
having count(1)>1
order by driver_id,driver_name;


14) How many drivers have never won any race.
select d.driverid,concat(d.forename,' ',d.surname)
from drivers d 
where d.driverid not in( select ds.driverid
                        from driver_standings ds
						where ds.position=1);


15) Are there any constructors who never scored a point? if so mention their name and how many races they participated in?
select cr.constructorid,c.name as constructor_name
,sum(cr.points)as constructor_points
,count(*) as matches_played
from constructors c
join constructor_results cr on c.constructorid=cr.constructorid
group by c.name,cr.constructorid
having sum(cr.points)=0
order by cr.constructorid,c.name desc;


16) Mention the drivers who have won more than 50 races.
select concat(d.forename,' ',d.surname) as driver_name,count(*)races_won
     from drivers d 
     join driver_standings ds on d.driverid=ds.driverid
     join results r on r.driverid=ds.driverid and ds.raceid=r.raceid
	 where ds.position=1
     group by concat(d.forename,' ',d.surname),ds.position
     having count(*)>=50
     order by races_won desc;


17) For 2022 season, mention the points structure for each position. i.e. how many points are awarded to each race finished position. 
with cte as 
		(select min(res.raceid) as raceid
		from races r
		join results res on res.raceid=r.raceid
		where year=2022)
	select r.position, r.points
	from results r
	join cte on cte.raceid=r.raceid
	where r.points > 0;


18) Display the winners of every sprint so far in F1
select concat(d.forename,' ',d.surname),r.year,sp.position
from sprint_results sp 
join races r on sp.raceid=r.raceid 
join drivers d on d.driverid =sp.driverid
where sp.position=1
order by 1,2;


19) Find the driver who has the most no of Did Not Qualify during the race.
with cte as 
(select d.driverid as driverid,concat(d.forename,' ',d.surname)as driver_name,count(*)as not_quailfied
,rank()over(order by count(*)desc)
from drivers d
join results r on r.driverid=d.driverid
join status s on r.statusid=s.statusid
where lower(s.status)='did not qualify'
group by d.driverid,concat(d.forename,' ',d.surname))
select driverid,driver_name,not_quailfied
from cte c 
where c.rank=1;



20) What is the average lap time for each F1 circuit. Sort based on least lap time.
	*** There may be missing lap time data for some circuits.
	select cr.circuitid, cr.name as circuit_name
	, cr.location, cr.country
	, avg(lt.time) as avg_lap_time
	from circuits cr
	left join races r on cr.circuitid=r.circuitid
	left join lap_times lt on r.raceid=lt.raceid
	group by cr.circuitid, cr.name, cr.location, cr.country
	order by avg_lap_time ;


