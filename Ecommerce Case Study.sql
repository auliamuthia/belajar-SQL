select *
from Analysis.dbo.[ordertab$] as d1


#1) Number of Users per Country
select country, count (userid) as Number_of_User_Per_Country from Analysis.dbo.[usertab$] group by country;

#2) Number of Orders per Country
select d1.country, count (d2.orderid) as Number_Order
from Analysis.dbo.[usertab$] as d1 
full join Analysis.dbo.[ordertab$] as d2 on d1.userid = d2.userid 
group by d1.country;

#3) First order date of each users (one user can make 2 order one time at their first order)

SELECT H.userid, H.order_time
FROM Analysis.dbo.[ordertab$] as H
intersect
    (SELECT userid, MIN(order_time) As first_order
    FROM Analysis.dbo.[ordertab$]
    GROUP BY userid)
order by order_time asc

#OR

select userid, MIN (order_time)
from Analysis.dbo.[ordertab$]
group by userid

#OR

with cte as (SELECT userid, MIN(order_time) As first_order
    FROM Analysis.dbo.[ordertab$]
    GROUP BY userid)
	select userid, first_order from cte

#4) number of users who made their first order in each country, each day 

select t1.country, count (t1.userid) as Number_of_User,  MIN (t2.order_time) as First_Order
from Analysis.dbo.[usertab$] as t1
full join Analysis.dbo.[ordertab$] as t2
on t1.userid = t2.userid
group by t1.country
	
#5)first order GMV of each user. If there is a tie, use the order with the lower orderid 

select * from Analysis.dbo.[ordertab$] as a 
	where not exists(select 1 
						from Analysis.dbo.[ordertab$] as b 
						where a.userid  = b.userid 
						and a.order_time < b.order_time 
						and a.orderid < b.orderid )

#OR

select u.*,
       (select o.gmv
        from Analysis.dbo.[ordertab$] as o
        where o.userid = u.userid
        order by order_time, orderid
        limit 1
       ) as earliest_gmv
from Analysis.dbo.[usertab$] as u;




