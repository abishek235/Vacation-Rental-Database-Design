--Drop Table codes to get rid of redundant tables in the database
Drop 
  table review;
Drop 
  table message;
Drop 
  table payout;
Drop 
  table booking;
Drop 
  table period;
Drop 
  table amenities;
Drop 
  table listing;
Drop 
  table host;
Drop 
  table guest;
Drop 
  table users;


--Users Table create code
create table users(
  u_id number, 
  u_fname varchar(20), 
  u_lname varchar(20), 
  u_g_type varchar(5), 
  u_h_type varchar(5), 
  u_email varchar(30), 
  u_password varchar(50), 
  u_street varchar(30), 
  u_state varchar(10), 
  u_zip number, 
  u_city varchar(20), 
  u_phone varchar(12), 
  primary key (u_id)
);

--Users Table value insertion code
insert into users 
values 
  (
    1, 'Hena', 'Sainani', 'Y', 'N', 'Hena.Sainani@gmail.com', 
    'Hena.Sainani', 'Roop Nagar', 'Maryland', 
    '21089', 'Silver Spring', '640-929-1375'
  );
insert into users 
values 
  (
    2, 'Sheela', 'Patel', 'Y', 'N', 'Sheela.Patel@gmail.com', 
    'Sheela.Patel', 'Roop Nagar', 'Maryland', 
    '23654', 'Baltimore', '240-452-7000'
  );
insert into users 
values 
  (
    3, 'Abishek', 'Gupta', 'Y', 'N', 'Abishek.Gupta@gmail.com', 
    'Abishek.Gupta', 'Delhi gali 8', 
    'Maryland', '20904', 'Greenbelt', 
    '567-765-1876'
  );
insert into users 
values 
  (
    4, 'Joey', 'Watson', 'Y', 'N', 'Joey.Watson@gmail.com', 
    'Joey.Watson', 'Strateford Garden Drive', 
    'Maryland', '21076', 'Calverton', 
    '756-964-9000'
  );
insert into users 
values 
  (
    5, 'Sultan', 'Khan', 'Y', 'Y', 'Sultan.Khan@gmail.com', 
    'Sultan.Khan', 'Apple Garden Drive', 
    'Maryland', '20904', 'Greenbelt', 
    '240-897-0002'
  );
insert into users 
values 
  (
    6, 'Ravi', 'Singh', 'N', 'Y', 'Ravi.Singh@gmail.com', 
    'Ravi.Singh', 'Rose Garden Drive', 
    'Maryland', '21089', 'Silver Spring', 
    '240-897-0021'
  );
insert into users 
values 
  (
    7, 'Richard', 'kennedy', 'N', 'Y', 'Richard.kennedy@gmail.com', 
    'Richard.kennedy', 'Rosewood Merry street', 
    'Virginia', '20910', 'Alexandria', 
    '240-890-1200'
  );
insert into users 
values 
  (
    8, 'Jessica', 'Simpson', 'N', 'Y', 'Jessica.Simpson@gmail.com', 
    'Jessica.Simpson', 'Strateford Garden Drive', 
    'Virginia', '20906', 'Annetter', 
    '240-897-1908'
  );
insert into users 
values 
  (
    9, 'Leela', 'Patel', 'N', 'Y', 'Leela.Patel@gmail.com', 
    'Leela.Patel', 'Rosewood Merry street', 
    'Virginia', '20905', 'Alexandria', 
    '301-899-1489'
  );
insert into users 
values 
  (
    10, 'Malcolm', 'Galdwell', 'Y', 'Y', 
    'Malcolm.Galdwell@gmail.com', 'Malcolm.Galdwell', 
    'Rosewood Merry street', 'Virginia', 
    '20904', 'Greenbelt', '240-100-0467'
  );




--Code to create sequence for the user table as we have already inserted 10 users to start the counter from 11
--Sequence for USERS U_ID from Users Table

create sequence seq_u_id start with 11 increment by 1 NOCACHE NOCYCLE;


--Guest Table create code
create table guest(
  g_u_id number, 
  g_dob date, 
  g_gender varchar(1), 
  g_job varchar(15), 
  g_avg_rating float, 
  primary key (g_u_id), 
  foreign key (g_u_id) references users (u_id)
);

insert into Guest 
values 
  (
    1, date '2000-01-01', 'F', 'Scientist', 
    4.2
  );
insert into Guest 
values 
  (
    2, date '1987-01-01', 'F', 'Lecturer', 
    4.3
  );
insert into Guest 
values 
  (
    3, date '1988-01-01', 'M', 'Doctor', 
    3.5
  );
insert into Guest 
values 
  (
    4, date '1988-01-01', 'M', 'Astronaut', 
    4
  );
insert into Guest 
values 
  (
    5, date '1988-01-01', 'M', 'Writer', 
    5
  );
insert into Guest 
values 
  (
    6, date '1991-01-01', 'M', 'Writer', 
    2.5
  );
			

/*******************************************************************************************************************************************************************************************/

--Host

create table host(
  h_u_id number, 
  h_dob date, 
  h_gender varchar(1), 
  h_avg_rating float, 
  primary key (h_u_id), 
  foreign key (h_u_id) references users (u_id)
);

-- Inserting sample data into the Host Table
insert into Host 
values 
  (5, date '1980-01-01', 'M', 4.2);
insert into Host 
values 
  (6, date '1987-01-01', 'M', 4.3);
insert into Host 
values 
  (7, date '1982-01-01', 'M', 3.5);
insert into Host 
values 
  (8, date '1983-01-01', 'F', 4);
insert into Host 
values 
  (9, date '1977-01-01', 'F', 5);
insert into Host 
values 
  (10, date '2025-01-01', 'M', 2.5);


/*******************************************************************************************************************************************************************************************/

--Listing	

 
create table listing(
  l_id number, 
  h_u_id number, 
  l_street varchar(30), 
  l_city varchar(15), 
  l_state varchar(15), 
  l_zip number, 
  l_type varchar(10), 
  max_cap number, 
  num_bed number, 
  num_room number, 
  num_bath number, 
  min_nights number, 
  checkin_time interval DAY(0) TO SECOND(0), 
  checkout_time interval DAY(0) TO SECOND(0), 
  l_desc varchar(50), 
  primary key (l_id), 
  foreign key (h_u_id) references host (h_u_id)
);
INSERT INTO LISTING 
VALUES 
  (
    14, 
    5, 
    '1000 hilltop road', 
    'baltimore', 
    'MD', 
    20723, 
    'house', 
    3, 
    2, 
    2, 
    2, 
    1, 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    'Upper Fells Point home with parking'
  );
INSERT INTO LISTING 
VALUES 
  (
    12, 
    6, 
    '22 Gorman road', 
    'atlanta', 
    'GA', 
    31210, 
    'house', 
    3, 
    1, 
    2, 
    1, 
    2, 
    INTERVAL '0 11:00:00.00' DAY(0) TO SECOND(0), 
    INTERVAL '0 11:00:00.00' DAY(0) TO SECOND(0), 
    'Close to downtown with public transportation'
  );
INSERT INTO LISTING 
VALUES 
  (
    15, 
    7, 
    '3 fry blvd', 
    'hanover', 
    'MD', 
    21076, 
    'apartment', 
    1, 
    1, 
    1, 
    1, 
    1, 
    INTERVAL '0 12:00:00.00' DAY(0) TO SECOND(0), 
    INTERVAL '0 12:00:00.00' DAY(0) TO SECOND(0), 
    'Cozy apartment in downtown'
  );
INSERT INTO LISTING 
VALUES 
  (
    11, 
    8, 
    '1 east Pratt street', 
    'baltimore', 
    'MD', 
    20723, 
    'apartment', 
    1, 
    1, 
    1, 
    1, 
    0, 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    'Apartment with a view of harbor'
  );
INSERT INTO LISTING 
VALUES 
  (
    13, 
    9, 
    '21 Lombard street', 
    'baltimore', 
    'MD', 
    20723, 
    'apartment', 
    1, 
    1, 
    1, 
    2, 
    0, 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    'Artsy apartment near the museum'
  );
INSERT INTO LISTING 
VALUES 
  (
    16, 
    10, 
    '45 savage street', 
    'laurel', 
    'MD', 
    20723, 
    'apartment', 
    2, 
    2, 
    2, 
    1, 
    1, 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    INTERVAL '0 10:00:00.00' DAY(0) TO SECOND(0), 
    'Inner Harbor near Fells Point'
  );

--LISTING L_ID
create sequence l_id_seq start with 17 increment by 1 NOCACHE NOCYCLE;

							

/*******************************************************************************************************************************************************************************************/

--Amenities
create table amenities(
  l_id number, 
  wifi varchar(3), 
  tv varchar(3), 
  washer varchar(3), 
  dryer varchar(3), 
  parking varchar(3), 
  balcony varchar(3), 
  iron varchar(3), 
  primary key (l_id), 
  foreign key (l_id) references listing (l_id)
);
INSERT INTO AMENITIES 
VALUES 
  (14, 'Y', 'Y', 'N', 'N', 'Y', 'N', 'N');
INSERT INTO AMENITIES 
VALUES 
  (12, 'Y', 'Y', 'N', 'N', 'N', 'N', 'N');
INSERT INTO AMENITIES 
VALUES 
  (15, 'N', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO AMENITIES 
VALUES 
  (11, 'Y', 'Y', 'N', 'Y', 'N', 'Y', 'Y');
INSERT INTO AMENITIES 
VALUES 
  (13, 'N', 'Y', 'Y', 'N', 'Y', 'N', 'N');


/*******************************************************************************************************************************************************************************************/

--Period			
create table period(
  p_id number, 
  l_id number, 
  start_date date, 
  end_date date, 
  price_night float, 
  primary key (p_id), 
  foreign key (l_id) references listing (l_id)
);
INSERT INTO PERIOD 
VALUES 
  (
    1, '14', DATE '2017-01-01', DATE '2017-01-31', 
    '95'
  );
INSERT INTO PERIOD 
VALUES 
  (
    2, '12', DATE '2017-02-01', DATE '2017-02-28', 
    '70'
  );
INSERT INTO PERIOD 
VALUES 
  (
    3, '15', DATE '2017-03-01', DATE '2017-03-31', 
    '110'
  );
INSERT INTO PERIOD 
VALUES 
  (
    4, '11', DATE '2017-04-01', DATE '2017-04-30', 
    '80'
  );
INSERT INTO PERIOD 
VALUES 
  (
    5, '13', DATE '2017-05-01', DATE '2017-05-31', 
    '90'
  );
--PERIOD P_ID
create sequence p_id_seq start with 6 increment by 1 NOCACHE NOCYCLE;

/*******************************************************************************************************************************************************************************************/

--All the insert statements from Booking and onwards are subject to change. 

--Booking				

 
create table booking(
  b_id int, 
  g_u_id int, 
  h_u_id int, 
  l_id int, 
  checkin_date date, 
  checkout_date date, 
  num_guest int, 
  num_child int, 
  b_pay_method varchar(15), 
  b_pay_date date, 
  b_status varchar(10), 
  b_pay_status number, 
  b_total float, 
  b_total_rental float, 
  b_total_host float, 
  b_total_guest float, 
  b_h_payout_status number, 
  primary key (b_id), 
  foreign key (l_id) references listing (l_id), 
  foreign key (g_u_id) references guest (g_u_id), 
  foreign key (h_u_id) references host (h_u_id)
);
INSERT INTO BOOKING 
VALUES 
  (
    1, 1, 5, 14, DATE '2017-11-10', DATE '2017-11-16', 
    3, 0, 'Creditcard', DATE '2017-11-16', 
    'Approved', 0, 570, 45.6, 17.1, 28.5, 
    0
  );
INSERT INTO BOOKING 
VALUES 
  (
    2, 2, 6, 12, DATE '2017-11-15', DATE '2017-11-24', 
    2, 0, 'CreditCard', DATE '2017-11-14', 
    'Requested', 1, 0, 0, 0, 0, 0
  );
INSERT INTO BOOKING 
VALUES 
  (
    3, 3, 7, 15, DATE '2017-10-20', DATE '2017-10-22', 
    1, 0, 'CreditCard', DATE '2017-11-19', 
    'Approved', 0, 220, 17.6, 6.6, 11, 0
  );
INSERT INTO BOOKING 
VALUES 
  (
    4, 4, 8, 11, DATE '2017-12-21', DATE '2017-12-28', 
    2, 1, '', DATE '2017-12-20', 'Requested', 
    1, 0, 0, 0, 0, 0
  );
INSERT INTO BOOKING 
VALUES 
  (
    5, 5, 9, 13, DATE '2017-11-19', DATE '2017-12-05', 
    5, 2, '', DATE '2017-11-18', 'Rejected', 
    0, 0, 0, 0, 0, 0
  );


/*******************************************************************************************************************************************************************************************/
 
--Payout

create table payout(
  pay_id int, 
  h_u_id int, 
  pay_date date, 
  pay_amt float, 
  Primary key (pay_id), 
  foreign key (h_u_id) references host (h_u_id)
);
INSERT INTO PAYOUT 
VALUES 
  (1, 5, DATE '2017-11-30', 762);
INSERT INTO PAYOUT 
VALUES 
  (2, 6, DATE '2017-11-15', 150);
INSERT INTO PAYOUT 
VALUES 
  (3, 7, DATE '2017-10-31', 342);
INSERT INTO PAYOUT 
VALUES 
  (4, 8, DATE '2017-11-28', 568);
INSERT INTO PAYOUT 
VALUES 
  (5, 9, DATE '2017-10-20', 172);
--PAYOUT PAY_ID
create sequence seq_pay_id start with 6 increment by 1 NOCACHE NOCYCLE;


/*******************************************************************************************************************************************************************************************/
	

--Message
create table message(
  m_id int, 
  u_id int, 
  m_date date, 
  m_body varchar(500), 
  primary key (m_id), 
  foreign key (u_id) references users (u_id)
);
insert into Message 
values 
  (
    1, 1, date '2017-10-17', 'The WiFi was slow, and the dishwasher made interesting sounds'
  );
insert into Message 
values 
  (
    2, 2, date '2017-11-17', 'It was hard to find parking and the directions to the rental were ambiguous. Please clarify.'
  );
insert into Message 
values 
  (
    3, 3, date '2017-11-27', 'The overal cleanliness of the rental was terrible. Needs to be improved. Also, how does the hot water work?'
  );
insert into Message 
values 
  (
    4, 4, date '2017-12-27', 'There were two rolling beds missing, and the closet doors were very sqeaky.'
  );
insert into Message 
values 
  (
    5, 5, date '2017-10-04', 'There are problems with the hot water. Please fix ASAP. Thank you.'
  );
insert into Message 
values 
  (
    6, 6, date '2017-10-09', 'There were not enough sheets.'
  );
					

/*******************************************************************************************************************************************************************************************/

--Review

	Create table review(
  b_id int, 
  H_rating float, 
  G_rating float, 
  R_body varchar(500), 
  primary key (b_id), 
  foreign key (b_id) references booking (b_id)
);
INSERT INTO REVIEW 
VALUES 
  (
    1, 5, 3, 'Overall nice place. As described. Would stay again.'
  );
INSERT INTO REVIEW 
VALUES 
  (
    2, 4, 2, 'Very noisy due to the main road and busses that pass by, but otherwise nice. Would stay again.'
  );
INSERT INTO REVIEW 
VALUES 
  (
    3, 5, 5, 'Owner was a great host! The neighbors were loud, and the WiFi slow, but the apartment was nice. Would stay again.'
  );
INSERT INTO REVIEW 
VALUES 
  (
    4, 3, 1, 'The place had a bad smell. Pictures were not accurate. Not very comfortable. Would NOT stay again.'
  );
INSERT INTO REVIEW 
VALUES 
  (
    5, 5, 2, 'Owner was very accommodating.The only thing was the laundry did not work. Overall great experience.'
  );

/********************************************************************************************************************************************************************************************/
