/* Q.1 : What is the senior most employee based on job title? */

select * from employee
ORDER BY levels desc
limit 1;

/* Q.2 : Which countries have the most invoice ?*/

select COUNT(*) as c,billing_country 
from invoice
group by billing_country
order by c desc;

/* Q.3 : What are the top 3 values of total invoice */

select total from invoice
order by total desc
limit 3;

/* Q.4 : which city has the best customers ? we would like to through a promotinal music festival
in the city we made most money. Write a query that returns one city has the highest sum
of invoice totals . return both city name and sum of all invoice totals.*/

select SUM(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc;

/* Q.5: who is best customer ? the customer who has spent the most money will be declared
the best customer . Write a query that returns the person who hasspent the most money.*/

select customer.customer_id , customer.first_name,customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id  = invoice.customer_id
group by customer.customer_id 
order by total desc
limit 1;

/* Moderate Ques 

Q.1: Write query to return the email, first name , last name , and genre of all rock music
listeners. return your list order alphabetically by email starting with A.*/

select distinct email, first_name , last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email;

/* Q2 : let's invite the artist who have written the most rock music in our dataset.write
a query that returns the artist name and total track count of top 10 rock bands*/

select artist.artist_id,artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs DESC
limit 10;

/* Q3: Return all track names that have a song length longer than average song length . return the name ang
miliseconds for each track . order by song length with the longest songs listed first.*/

select name, milliseconds
from track
where milliseconds >(
	select avg(milliseconds) as avg_track_length
	from track)
order by milliseconds desc;

/*HARD QUES 

Q1: Find how much amount spent by each customer on artists ? write a query to return customer name ,
artist name and total spent .*/

WITH best_selling_artist AS(
	 select artist.artist_id as artist_id, artist.name as artist_name,
	 SUM(invoice_line.unit_price*invoice_line.quantity) as total_sales
	 from invoice_line
	 join track on track.track_id = invoice_line.track_id
	 join album on album.album_id = track.album_id
	 join artist on artist.artist_id = album.artist_id
	 group by 1
	 order by 3 desc
	 limit 1
)
select c.customer_id, c.first_name , c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;



