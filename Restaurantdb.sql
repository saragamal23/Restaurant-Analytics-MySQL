CREATE DATABASE RESTAURANTDB;
USE RESTAURANTDB;

CREATE TABLE `cities` (
  `id` int PRIMARY KEY,
  `city` varchar(255)
);
CREATE TABLE `restaurant_types` (
  `id` int PRIMARY KEY,
  `restaurant_type` varchar(255)
);
CREATE TABLE `meal_types` (
  `id` int PRIMARY KEY,
  `meal_type` varchar(255)
);
CREATE TABLE `serve_types` (
  `id` int PRIMARY KEY,
  `serve_type` varchar(255)
);
CREATE TABLE `restaurants` (
  `id` int PRIMARY KEY,
  `restaurant_name` varchar(255),
  `restaurant_type_id` int,
  `income_persentage` decimal,
  `city_id` int
);
CREATE TABLE `meals` (
  `id` int PRIMARY KEY,
  `restaurant_id` int,
  `serve_type_id` int,
  `meal_type_id` int,
  `hot_cold` varchar(255),
  `meal_name` varchar(255),
  `price` decimal
);

CREATE TABLE `members` (
  `id` int PRIMARY KEY,
  `first_name` varchar(255),
  `surname` varchar(255),
  `sex` varchar(255),
  `email` varchar(255),
  `city_id` int,
  `monthly_budget` decimal
);
CREATE TABLE `orders` (
  `id` int PRIMARY KEY,
  `date` date,
  `hour` time,
  `member_id` int,
  `restaurant_id` int,
  `total_order` decimal
);
CREATE TABLE `monthly_member_totals` (
  `member_id` int,
  `first_name` varchar(255),
  `surname` varchar(255),
  `sex` varchar(255),
  `email` varchar(255),
  `city` varchar(255),
  `year` int,
  `month` int,
  `order_count` int,
  `meals_count` int,
  `monthly_budget` decimal,
  `total_expense` decimal,
  `balance` decimal,
  `commission` decimal
);

CREATE TABLE `order_details` (
  `id` int PRIMARY KEY,
  `order_id` int,
  `meal_id` int
);
ALTER TABLE `members` ADD FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`);

ALTER TABLE `meals` ADD FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`);

ALTER TABLE `meals` ADD FOREIGN KEY (`serve_type_id`) REFERENCES `serve_types` (`id`);

ALTER TABLE `meals` ADD FOREIGN KEY (`meal_type_id`) REFERENCES `meal_types` (`id`);

ALTER TABLE `monthly_member_totals` ADD FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`);

ALTER TABLE `order_details` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `order_details` ADD FOREIGN KEY (`meal_id`) REFERENCES `meals` (`id`);

ALTER TABLE `restaurants` ADD FOREIGN KEY (`restaurant_type_id`) REFERENCES `restaurant_types` (`id`);

ALTER TABLE `restaurants` ADD FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`);

/*Question 1
Retrieve combined member information by joining multiple related tables.
Include columns that give a full overview of member activity.
*/
-- Business Insight
/*his query shows member details with their order IDs, 
helping identify members who placed orders and track customer activity.*/
select m.* , o.id order_id from members m
left join orders o on m.id=o.member_id ;

/*Question 2
Count the number of members grouped by their gender (sex).
Rename the count column appropriately.
*/
-- Business Insight
/*This query counts members based on gender, 
helping analyze the distribution of male and female customers.
*/
select sex ,count(id) countofmembers
from members 
group by sex;

/*Question 3
Display each member’s total spending by combining data from members and 
monthly_member_totals.
Include their basic personal details.*/
-- Business Insight
/*This query displays each member’s personal details with total spending,
 helping identify valuable customers and spending patterns.*/
select m.* , mo.total_expense total_spending
 from members m
  join monthly_member_totals mo on mo.member_id=m.id;
 
 /*Question 4
List all hot meals that are of type Cheese.
Display all relevant meal details.*/
-- Business Insight
/* This query shows all hot cheese meals,
 helping identify menu items that may be popular with customers.*/
 
select m.* ,  mt.meal_type from meals m
join meal_types mt on m.meal_type_id=mt.id 
where m.hot_cold ="Hot" and mt.meal_type="Cheese";

/*Question 5
Retrieve all members who live in the cities Givatayim or Ramat Hasharon.
*/
-- Business Insight
/*This query identifies members from specific cities, 
helping target customers by location for promotions or services.*/

select m.* ,c.city from members m
join cities c on m.city_id = c.id
where c.city in ('Givatayim','Ramat Hasharon');

/*Question 6
Display all members whose surname starts with the letter ‘C’.
*/
-- Business Insight
/*This query filters members whose surname starts with C, 
helping organize and search customer records quickly.*/

select *from members 
where  surname like 'C%';

/*Question 7
List all meals where the serve_type is either ‘Starter’ or ‘Dessert’.
Show related columns from both tables.
*/
-- Business Insight
/*This query shows meals served as starters or desserts,
 helping analyze menu categories and customer preferences.
*/
select m.*,s.serve_type  from meals m 
join serve_types s on s.id = m. serve_type_id
where s.serve_type in ('Starter','Desert');

/*Question 8
Extract the hour component from the hour column in the orders table,
count the total number of orders for each hour,
and display the result sorted by order count in descending order.*/
-- Business Insight
/*This query shows the busiest order hours, 
helping optimize staffing and restaurant operations during peak times
*/
select hour, count(id) total_orders from orders
group by hour
order by total_orders  desc;

/*Question 9
Extract the first few characters of each serve_type value (substring)
and display it in a new column named ShortServeType.
Order the result alphabetically by the original serve_type.*/
--  Business Insight
/*Creating a short version of serve_type makes it easier to group and analyze meal types quickly. 
This helps simplify reporting and identify main categories faster.
*/
select *,substring(serve_type,1,3) ShortServeType
from serve_types 
order by serve_type;

/*Question 10
Select the distinct total_order values and display them
along with the corresponding member ID and name.
Sort the results from highest to lowest total order value.
(Hint: You may need a subquery to select distinct combinations.)
*/
--  Business Insight
/*Helps identify members with unique spending levels and rank them by total orders, 
making it easier to spot top contributors.
*/
select distinct m.id,m.first_name,m.surname,o.total_order
from members m
join orders o on o.member_id=m.id
order by o.total_order desc; 

/*Question 11
List all orders placed by members between April 1, 2020 and July 1, 2020.
Show relevant columns from both orders and members.
*/
-- Business Insight
/*This query helps identify member activity within a specific time period, 
allowing the business to analyze purchasing behavior and seasonal trends in orders.*/

select o.*,m.first_name,m.surname from orders o
join members m on m.id=o.member_id
where o.date between '2020-01-01'and '2020-01-05';