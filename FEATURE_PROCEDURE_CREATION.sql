--FEATURE 1
CREATE OR REPLACE PROCEDURE RegisterUser (
            IN_FName                  VARCHAR,
            IN_LName                  VARCHAR, 
            IN_U_G_Type               VARCHAR,
            IN_U_H_Type               VARCHAR,
            IN_Email                  VARCHAR,
            IN_Password               VARCHAR,
            IN_Street                 VARCHAR, 
            IN_State                  VARCHAR,
            IN_Zipcode                INT, 
            IN_City                   VARCHAR,   
            IN_Phone                  VARCHAR,
            IN_DOB                    DATE,
            IN_Gender                 VARCHAR,
            IN_JOB                    VARCHAR
) IS
            SeqNumber                 INT;
            PrevID                    INT;
BEGIN
	 --Checks if email exists already.
            SELECT COUNT(*)
            INTO PrevID
            FROM  users
WHERE u_email = IN_Email;
 --Will generate a sequence for user ID.
            IF PrevID = 0 THEN
            	SeqNumber := SEQ_U_ID.NEXTVAL;
                        INSERT INTO users (
                                    u_id,
                                    u_fname,
                                    u_lname,
                                    u_g_type,
                                    u_h_type,
                                    u_email,
                                    u_password,
                                    u_street,
                                    u_state,
                                    u_zip,
                                    u_city,
                                    u_phone
                        ) VALUES (
                                    SeqNumber,
                                    IN_FName,
                                    IN_LName,
                                    IN_U_G_Type,
                                    IN_U_H_Type,
                                    IN_Email,
                                    IN_Password,
                                    IN_Street,
                                    IN_State,
                                    IN_Zipcode,
                                    IN_City,
                                    IN_Phone
                        );  
--CHECKS FOR USER WITH GUEST TYPE 'Y' TO INSERT INTO GUEST TABLE
            IF IN_U_G_Type = 'Y' THEN
            INSERT INTO GUEST (     g_u_id,
                                    g_dob,
                                    g_gender,
                                    g_job,
                                    g_avg_rating
                        ) VALUES (
                                    SeqNumber,
                                    IN_DOB,
                                    IN_Gender,
                                    IN_JOB,
                                    NULL
                        );  
            END IF;
--CHECKS FOR USER WITH HOST TYPE 'Y' TO INSERT INTO HOST TABLE
            IF IN_U_H_Type = 'Y' THEN
            INSERT INTO HOST (      h_u_id,
                                    h_dob,
                                    h_gender,
                                    h_avg_rating
                        ) VALUES (
                                    SeqNumber,
                                    IN_DOB,
                                    IN_Gender,
                                    NULL
                        );  
             END IF;
--Prints out appropriate messages.
DBMS_OUTPUT.PUT_LINE('Registered a new user with ID = ' || seqNumber);
            ELSE
DBMS_OUTPUT.PUT_LINE('The email is already registered');
            END IF;
END;

--Demo Script
--Testing
--User Already Exists:

EXEC RegisterUser ('Sam', 'Williams', 'Y', 'N', 'swilliams@gmail.com', 'abc%467', 'Strateford Garden Drive','Maryland',20910,'Calverton', '3016458723', date'1978-12-10', 'M', 'Student');
--Adding a New User(Guest):
EXEC RegisterUser ('Jen', 'Rutz', 'Y', 'N', 'jen@gmail.com', 'JenRuTz', '1 East Street','Maryland',21076,'Hanover', '240-876-1001', date '1978-12-10', 'F', 'Professor');
--Adding a New User(Host):
EXEC RegisterUser ('Holand', 'Gerrard', 'N', 'Y', 'holand@gmail.com', 'HolGer', '122 North Street','Maryland',22374,'Catonsville', '867-993-7374', date '1990-2-1', 'M', 'Mechanic');

--DELETE FROM GUEST WHERE G_U_ID=16;
--DELETE FROM USERS WHERE U_ID=16;
--DELETE FROM GUEST WHERE G_U_ID=17;
--DELETE FROM USERS WHERE U_ID=17;


--FEATURE 2
create or replace procedure UserLogins (email users.u_email%type, password users.u_password%type)
as
passwordchk users.u_password%type;

BEGIN
--E-Mail ID being checked.
select u_password into passwordchk from users where u_email=email;

--Password is checked. 
if passwordchk != password or passwordchk is null then
dbms_output.put_line('Invalid Password.');

else
dbms_output.put_line('Login Successful.');
end if;

EXCEPTION
when NO_DATA_FOUND then
    dbms_output.put_line('Invalid E-Mail ID.');
END;

--Demo Script
--FEATURE 2 - User Login
--exec UserLogins(email, password);
--Login Unsuccessful - Invalid Password.
exec UserLogins('jen@gmail.com', 'JenGr');
--Login Unsuccessful - - Invalid Email.
exec UserLogins('Jenna@gmail.com', 'JenGer');
--Login Successful
exec UserLogins('jen@gmail.com', 'JenRuTz');

--FEATURE 3
create or replace procedure displayMessages( uid INT,mdate date)
IS
    cont NUMBER;
    rowcount int:=0;
--selects the messages and dates for specified user ID.
    cursor c1 is select m_date,m_body from message where u_id = uid and m_date>=mdate;
BEGIN
    SELECT COUNT (*) INTO cont from users where u_id = uid;
    IF(cont > 0) THEN
        for item in c1
 --Loop Will print all messages for dates requested 
 --for the user ID.
        loop
        dbms_output.put_line('Date      : '||item.m_date);
        dbms_output.put_line('Message   : '||item.m_body);
        dbms_output.put_line('--------------------------');
        rowcount:=rowcount+1;
        end loop;
	ELSE
		dbms_output.put_line('Incorrect user ID.');
	END IF;
    if rowcount=0 and cont>0 then 
        dbms_output.put_line('No messages available.');
    end if;
END;



--Demo Script
--Execution
--FEATURE 3 - Display messages for user
--exec displayMessages(userid,date);
--No message available
exec displayMessages(1,date'2017-12-17');
--Wrong user ID
exec displayMessages(175,date'2017-10-17');
--Correct user ID
exec displayMessages(5,date'2017-12-18');


--FEATURE 4
create or replace procedure createList(cl_u_id in int, cl_l_street in varchar, cl_l_city in varchar, cl_l_state in varchar, cl_l_zip in int, cl_l_type in varchar, cl_max_cap in int, cl_num_bed in int, cl_num_room in int, cl_num_bath in int, cl_min_nights in int, cl_checkin_time in interval day to second, cl_checkout_time in interval day to second, cl_l_desc in varchar) is
cl_l_id int;
listCheck int;
userCheck int;
begin
    --Start of Check to see if the listing exists already.
    select count(*) into listCheck from listing where h_u_id=cl_u_id  and l_street=cl_l_street and l_city=cl_l_city  and l_state=cl_l_state  and l_zip=l_zip  and l_type=cl_l_type  and max_cap=cl_max_cap  and num_bed=cl_num_bed  and num_room=cl_num_room  and num_bath=cl_num_bath  and min_nights=cl_min_nights  and checkin_time=cl_checkin_time  and checkout_time=cl_checkout_time  and l_desc=cl_l_desc;
    if listCheck > 0 then
    raise value_error;
    end if;
    select h_u_id into userCheck from host where h_u_id=cl_u_id;
    if userCheck=0 or userCheck is null then
    raise NO_DATA_FOUND;
    end if;
    --End of Checking if the listing exists already.
    cl_l_id := l_id_seq.nextval; 
--Inserts listing into listing table
    insert into listing(l_id,h_u_id,l_street,l_city,l_state,l_zip,l_type,max_cap,num_bed,num_room,num_bath,min_nights,checkin_time,checkout_time,l_desc) 
    values(cl_l_id,cl_u_id,cl_l_street,cl_l_city,cl_l_state,cl_l_zip,cl_l_type,cl_max_cap,cl_num_bed,cl_num_room,cl_num_bath,cl_min_nights,cl_checkin_time,cl_checkout_time,cl_l_desc);
    dbms_output.put_line('Listing has been successfully added. Your listing ID is '||cl_l_id);
exception
    when VALUE_ERROR then
        dbms_output.put_line('Listing already exists.');
    when NO_DATA_FOUND then
        dbms_output.put_line('The User ID '||cl_u_id||' does not exist.');
end;

--Demo Script
--FEATURE 4 - Create listing for host(GetNew HostID)
--exec createList(hostID,Street,City,State,zip,HouseType,MaxCap,MaxBed,NoRoom,NoBath,MinNight,CheckInTime,CheckOutTime,Description);
--Listing already exists
exec createList(10,'2nd Poplar Ave','Arbutus','MD',21220,'House',4,2,2,2,1,to_dsinterval('0 11:00:00'),to_dsinterval('0 12:00:00'),'This is an individual appartment with a balcony.');
--Wrong user ID
exec createList(1001,'Poplar Ave','Arbutus','MD',21220,'House',4,2,2,2,1,to_dsinterval('0 11:00:00'),to_dsinterval('0 12:00:00'),'This is an individual appartment with a balcony.');
--Correct Listing details
exec createList(25,'1999 Turnbury lane','North wales','PA',19454,'House',9,3,3,3,3,to_dsinterval('0 12:00:00'),to_dsinterval('0 12:00:00'),'Individual town house with relaxing view.');


--FEATURE 5

--FEATURE 5
create or replace procedure pricePeriod(pp_l_id in int,pp_start_date in date,pp_end_date in date,pp_price_night in float) is
pp_p_id int;
periodCheck int:=0;
periodCheck2 int:=0;
listingCheck int;
periodexist exception;
Begin
--Ensures that dates are correct.
    if pp_end_date < pp_start_date then
        raise value_error;
    end if;
    --select count(*) into periodCheck from period where l_id=pp_l_id and end_date<=pp_start_date;
    --periodCheck2:=periodCheck2+periodCheck;
    select count(*) into periodCheck from period where l_id=pp_l_id and start_date<=pp_start_date and end_date>=pp_start_date;
    periodCheck2:=periodCheck2+periodCheck;
    select count(*) into periodCheck from period where l_id=pp_l_id and start_date<=pp_end_date and end_date>=pp_end_date;
    periodCheck2:=periodCheck2+periodCheck;
    select count(*) into listingCheck from listing where l_id=pp_l_id;
    if periodCheck2 > 0 then
        raise periodexist;
    end if;
    if listingCheck = 0 then
        raise NO_DATA_FOUND;
    else 
    pp_p_id:=p_id_seq.nextval;
--After all the checks, inserts period/availability  into listing table
    insert into period(p_id,l_id,start_date,end_date,price_night) values(pp_p_id,pp_l_id,pp_start_date,pp_end_date,pp_price_night);
    dbms_output.put_line('Period successfully created.');
    end if;
    
Exception
--Prints out appropriate error messages.
    when VALUE_ERROR then
        dbms_output.put_line('Wrong dates entered.');
    when NO_DATA_FOUND then
        dbms_output.put_line('Wrong Listing ID');
    when periodexist then
        dbms_output.put_line('Period already exists.');
end;



--Demo Script
--execution
--period already exists
exec pricePeriod(16,date'2017-09-01',date'2017-11-30',100);
--Correct Period
exec pricePeriod(16,date'2018-11-01',date'2018-12-01',120);
--wrong listing ID
exec pricePeriod(137,date'2017-12-01',date'2017-12-31',100);
--Wrong dates (When start date > end date)
exec pricePeriod(16,date'2018-01-31',date'2018-01-01',100);

--FEATURE 6
create or replace procedure findListing(fl_l_city in varchar,fl_l_state in varchar,fl_checkin_date in date,fl_checkout_date in date) is
--Cursor to check for available listing for the given dates and location
cursor findlist is select distinct(l.l_street||', '||l.l_city||', '||l.l_state||', '||l.l_zip) as l_address,(l.l_id) as l_id from listing l,period p1,period p2 where p1.l_id=l.l_id and p2.l_id=l.l_id and p1.start_date<=fl_checkin_date and p2.end_date>=fl_checkout_date and l.l_city=fl_l_city and l.l_state=fl_l_state and l.l_id not in(select l_id from booking where b_status in ('Requested','Approved','Paid') and (booking.checkin_date>=fl_checkin_date and booking.checkin_date<=fl_checkout_date) and (booking.checkout_date>=fl_checkin_date and booking.checkout_date<=fl_checkout_date) );
fl_l_id int :=0;
fl_day_price float :=0;
cur_count int := 0;
no_list_found exception;
fl_address varchar(300);
fl_price float;
fl_sl_no int:=0;
begin
    for item in findlist
    loop
        cur_count := cur_count + 1;
        fl_l_id := item.l_id;
        fl_address := item.l_address;
        fl_price := 0;
        fl_day_price := 0;
        if fl_l_id = 0 or fl_l_id is null then
        raise no_list_found;
        end if;
        fl_sl_no:=fl_sl_no+1;
        dbms_output.put_line('Slno :'||fl_sl_no);
        dbms_output.put_line('Listing ID : '||fl_l_id);
        dbms_output.put_line('Address : ' ||fl_address);
        for i in 0 .. (fl_checkout_date-fl_checkin_date)
        Loop
--selecting and calculating the daily  price for the given dates.
            with dayprice as(
            select price_night from period where l_id = item.l_id and start_date<=(fl_checkin_date + i)  and end_date>=(fl_checkin_date + i))
            select max(price_night)into fl_day_price from dayprice;
            fl_price := fl_price + fl_day_price;
            if fl_price is null then
            fl_price :=0;
            end if;
        end loop;
--Checking if the price is available
        if fl_price=0 then
            dbms_output.put_line('Price not yet fixed by host.');
            dbms_output.put_line('');
            else
            fl_price:=fl_price*1.05;
            dbms_output.put_line('Price : $'||fl_price);
            dbms_output.put_line('');
            end if;
    end loop;
    if cur_count = 0 then
        raise no_list_found;
    end if; 
exception
    when NO_LIST_FOUND then
        dbms_output.put_line('There is no listing available.');
end;

--Demo Script
--Testing
--exec findListing(City,State,CheckInDate,CheckOutDate);

--No Period Available 
exec findListing('baltimore','MD',date'2018-04-02',date'2018-04-04');

--Existing Booking(267.75=> Rent=255, Service fee=12.75)
exec findListing('baltimore','MD',date'2017-04-02',date'2017-04-04');
--Wrong city
exec findListing('canada','MD',date'2017-03-02',date'2017-03-04');

--Correct Listing (267.75=> Rent=255, Service fee=12.75)
exec findListing('baltimore','MD',date'2017-04-25',date'2017-04-28');

--Canceled Booking (Price = Per Night price * No. of days) + 5% service tax
exec findListing('hanover','MD',date'2017-03-02',date'2017-03-04');


--FEATURE 7
create or replace procedure bookingRequest(br_l_id in int, br_g_u_id in int, br_checkin_date in date, br_checkout_date in date, br_num_guest in int, br_num_child in int) is
no_g_u_id exception;
no_list_found exception;
no_l_id exception;
er_max_cap exception;
er_min_stay exception;
br_min_night int;
G_U_ID_CHK int := 0;
br_h_u_id int;
L_ID_CHK int := 0;
br_max_cap int;
cur_count int := 0;
br_b_id int := 0;
br_m_id int :=0;
br_g_avg_rating int;
br_night_stay int:=0;
--Cursor to check for available listing for the given dates and location
cursor findlist is select l.l_id as l_id from listing l,period p1,period p2 where p1.l_id=l.l_id and p2.l_id=l.l_id and p1.start_date<=br_checkin_date and p2.end_date>=br_checkout_date and l.l_id=br_l_id and l.l_id not in(select l_id from booking where b_status in ('Requested','Approved','Paid') and (booking.checkin_date>=br_checkin_date and booking.checkin_date<=br_checkout_date) and (booking.checkout_date>=br_checkin_date and booking.checkout_date<=br_checkout_date) );
begin
    select count(*) into G_U_ID_CHK from users where u_id=br_g_u_id and u_g_type = 'Y';
    select count(*) into L_ID_CHK from listing where l_id=br_l_id;
    select max(max_cap),max(h_u_id),max(min_nights) into br_max_cap,br_h_u_id,br_min_night from listing where l_id=br_l_id; 
    select max(b_id) into br_b_id from booking;
    br_night_stay := br_checkout_date - br_checkin_date;
--Creating values for input parameter check.
    if br_b_id is null then
        br_b_id := 0;
        br_b_id := br_b_id+1;
    else
        br_b_id := br_b_id+1;
    end if;
    select max(m_id)+1 into br_m_id from message;
    if br_m_id is null then
        br_m_id := 0;
    end if;
    br_m_id := br_m_id+1;
    for item in findlist
    loop
        cur_count := cur_count + 1;
    end loop;
    --START - INPUT PARAMETER CHECKING
    if G_U_ID_CHK = 0 then
    raise no_g_u_id;
    elsif L_ID_CHK = 0 then
    raise no_l_id;
    elsif (br_num_guest+br_num_child)>br_max_cap then
    raise er_max_cap;
    elsif cur_count = 0 or cur_count is null then
    raise no_list_found;
    elsif br_min_night>br_night_stay then
    raise er_min_stay;
    else
    select g_avg_rating into br_g_avg_rating from guest where g_u_id=br_g_u_id;
    if br_g_avg_rating is null then
        br_g_avg_rating := 0;
    end if;   
    --END - INPUT PARAMETER CHECKING
--Creating a booking request
    insert into booking values(br_b_id,br_g_u_id,br_h_u_id,br_l_id,br_checkin_date,br_checkout_date,br_num_guest,br_num_child,null,null,'Requested',0,0,0,0,0,null);
    insert into message values(br_m_id,br_h_u_id,sysdate,'There is a new request from '||br_g_u_id||' with all requirements met. The guest rating is '||br_g_avg_rating||'. The booking No. is '||br_b_id||'.');
    dbms_output.Put_line('Booking Request Successful.');
    dbms_output.Put_line('Your Booking ID is '||br_b_id);
    end if;

exception
    when no_g_u_id then
        dbms_output.put_line('Invalid Guest ID : '||br_g_u_id);
    when no_l_id then
        dbms_output.put_line('Invalid Listing ID : '||br_l_id);
    when er_max_cap then
        dbms_output.put_line('Exceeding maximum capacity. Maximum capacity : '||br_max_cap);
    when no_list_found then
        dbms_output.put_line('No list available for selected dates.');
    when er_min_stay then
        dbms_output.put_line('Minimum stay requirement not met.');
End;

--Demo Script
--Testing
--Place a Booking request(Get ListID and GuestID)
--exec bookingRequest(ListID,GuestID,CheckInDate,CheckOutDate,NoGuest,NoChild);
--INVALID GUEST ID
exec bookingRequest(11,75,date'2017-04-02',date'2017-04-04',1,0);
--INVALID LIST ID
exec bookingRequest(111,5,date'2017-04-02',date'2017-04-04',1,0);
--EXCEEDING GUEST NO (Max capacity for LID 16 is 2)
exec bookingRequest(16,5,date'2017-04-02',date'2017-04-04',10,0);
--DATES OUT OF PERIOD
exec bookingRequest(11,5,date'2017-03-02',date'2017-03-04',1,0);
--MINIMUM STAY REQUIREMENT (Min stay nights for LID 12 is 2)
exec bookingRequest(12,5,date'2017-02-02',date'2017-02-02',1,0);
--CORRECT DATA
exec bookingRequest(13,16,date'2017-04-28',date'2017-05-02',1,0);
delete from booking where b_id=5;


--FEATURE 8
create or replace procedure bookingStatus(bs_b_id in int,bs_book_status in varchar)
as
booking_chk int := 0;
bs_m_id int;
bs_guid int;
bs_huid int;
begin
--Checking if a booking exists
    select 1, g_u_id,h_u_id into booking_chk,bs_guid,bs_huid from booking where b_id=bs_b_id;
    select max(m_id)+1 into bs_m_id from message;
    if bs_m_id is null then
        bs_m_id := 0;
    end if;
    bs_m_id := bs_m_id+1;
--updating the status of the booking and sending message to users.
if booking_chk = 1 then
    update booking set b_status = bs_book_status where b_id=bs_b_id;
    dbms_output.put_line('Status has been updated');
    insert into message values(bs_m_id,bs_guid,sysdate,'Booking ID : '||bs_b_id||' has been Approved');
end if;    
exception
when NO_DATA_FOUND then
    dbms_output.put_line('The booking ID '||bs_b_id||' does not exist.');
end;


--Demo Script
--Approval/ Denial of Booking request by host(GetBookingID)
--exec bookingStatus(BookingID,Status);
--WRONG BOOKING ID
exec bookingStatus(1000,'Rejected');
--CORRECT DATA
exec bookingStatus(4, 'Approved');



--FEATURE 9
create or replace procedure showRequest(sr_h_u_id in int)
as
host_name varchar(70);
row_count int:=0;
--Cursor to generate list of requested booking.
cursor c1 is select b.b_id, u.u_fname,u.u_lname, b.l_id, b.checkin_date, b.checkout_date, b.num_guest, b.b_status from booking b, users u where b.g_u_id=u.u_id and b.h_u_id=sr_h_u_id and b.b_status='Requested';
begin
select u_fname||' '|| u_lname into host_name from users where u_id = sr_h_u_id;
dbms_output.put_line('The Requests for '||host_name||' are as follow : ');
--Displaying the available booking request.
for item in c1 loop
dbms_output.put_line('Booking ID : '||item.b_id||', Status : '||item.b_status||', Guest Name : '||item.u_fname||' '||item.u_lname);
dbms_output.put_line('Checkin Date : '||item.checkin_date||', Checkout Date : '||item.checkout_date||', Number of Guest(s) : '||item.num_guest);
dbms_output.put_line('');
row_count:=row_count+1;
end loop;
if row_count=0 then
dbms_output.put_line('No requests available.');
end if;
exception
when no_data_found then
    dbms_output.put_line('Invalid Host ID.');
End;

--Demo Script
--Execution
--Display Booking request for a host
--exec showRequest(HostID);
--CORRECT HOST ID NO REQUEST
exec showRequest(6);
--INCORRECT HOST ID
exec showRequest(299);
--CORRECT HOST ID WITH REQUEST
exec showRequest(7);


--FEATURE 10
create or replace procedure guestPayment(gp_b_id in int, gp_pay_method in varchar, gp_pay_date in date)
    as
    booking_chk int:=0;
    booking_status booking.b_status%type;
	gp_huid int;
	gp_guid int;
	gp_m_id int;
    gp_checkin_date date;
    gp_checkout_date date;
    gp_day_price float:=0;
    gp_price float:=0;
    gp_l_id int;
    gp_price_rental float:=0;
begin 
--Checking and collecting details about the given booking ID.
    select 1,b_status,checkin_date,checkout_date,l_id into booking_chk,booking_status,gp_checkin_date,gp_checkout_date,gp_l_id from booking where b_id = gp_b_id and b_status='Approved';
	select h_u_id, g_u_id into gp_huid,gp_guid from booking where b_id=gp_b_id;
	for i in 1 .. (gp_checkout_date-gp_checkin_date)
    Loop
--Calculating price for the booking.
        with dayprice as(
            select price_night from period where l_id = gp_l_id and start_date<=(gp_checkin_date + i)  and end_date>=(gp_checkin_date + i))
            select max(price_night)into gp_day_price from dayprice;
            gp_price := gp_price + gp_day_price;  
    end loop;
    if gp_price is null then
        gp_price :=0;
    end if;
    gp_price_rental:=gp_price*0.05;
    gp_price:=gp_price+gp_price_rental;
            
    select max(m_id) into gp_m_id from message;
	if gp_m_id is null then
		gp_m_id:=0;
	end if;
	gp_m_id:=gp_m_id+1;
    if gp_pay_date >= gp_checkin_date then
        dbms_output.put_line('Paydate exceeded.');
        return;
    else
--updating booking table and sending message to the users.
		update booking set b_pay_status= 1,b_status='Paid',b_pay_method=gp_pay_method,b_pay_date=sysdate,b_total=gp_price,B_TOTAL_RENTAL=gp_price_rental where b_id=gp_b_id;
		insert into message values (gp_m_id,gp_huid,sysdate,'Payment complete for Booking ID : '||gp_b_id||'.');
		gp_m_id:=gp_m_id+1;
		insert into message values (gp_m_id,gp_guid,sysdate,'Payment complete for Booking ID : '||gp_b_id||'.');
        dbms_output.put_line('Payment completed.');
        insert into review values(gp_b_id,null,null,null);
	end if;  		
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Booking already paid or does not exist.');
end;

--Demo Script
--exec guestPayment(BookingID,PaymentType,PaymentDate);
--Payment date exceeded
exec guestPayment(2,'Card',date'2017-12-15');
--Booking already paid.
exec guestPayment(1,'Card',date'2017-12-15');
--Booking does not exist:
exec guestPayment(5,'Card',date'2017-9-19');
-- Correct
exec guestPayment(2,'Card',date'2017-01-31');
update booking set b_pay_status = 0, b_status = 'Approved', b_pay_method = null, b_pay_date = null, b_total = null, b_total_rental = null where b_id = 2;
delete from review where b_id = 2;






--FEATURE 11
Create or replace procedure Cancellation (BookingID int)
IS
BookingId_chk int;
BookingPay_chk number;
c_m_id int;
c_g_u_id int;
Begin
--Checking if the booking exists and collecting details
Select B_ID, B_pay_status,g_u_id into BookingId_chk, BookingPay_chk,c_g_u_id from Booking Where B_id  = BookingId;
select max(m_id) into c_m_id from message;
if c_m_id is null then
    c_m_id:=0;
end if;
c_m_id:=c_m_id+1;

--Prints out appropriate messages.
If BookingID is Null then DBMS_output.put_line('Invalid Booking ID'); 

Elsif BookingID is not Null and BookingPay_chk = 1 then DBMS_output.put_line('Payment has already been made for this Booking, so it cannot be cancelled!');
insert into message values(c_m_id,c_g_u_id,sysdate,'Payment has already been made for this Booking, so it cannot be cancelled!');
Elsif BookingID is not Null and BookingPay_chk = 0 then
Update booking Set b_status = 'Cancelled' where B_ID = BookingID;
DBMS_output.put_line('Booking has been cancelled!');
insert into message values(c_m_id,c_g_u_id,sysdate,'Booking '||BookingID||' has been cancelled.');
End if; 

Exception
when no_data_found then
DBMS_output.put_line('Invalid Booking ID');

End;

--Demo Script
--Invalid Booking
exec Cancellation(30);
-- Correct Booking ID, Booking Pay Status (b_pay_status) = 1 (Already paid)
exec Cancellation(1);
-- Correct Booking ID, Booking Pay Status (b_pay_status) = 0
exec Cancellation(3);
update booking set b_status='Approved' where b_id=3;



--FEATURE 12
Create or replace procedure HostPayout(HostIDCheck Booking.h_u_id%type, InputDate date)
is

--Select host who have received payment for the booking from the guest before the stated date but not from the RentalCompany.
Cursor c1 is Select b_id,h_u_id, b_h_payout_status, b_total from Booking where H_u_id = HostIDCheck and b_pay_date <= InputDate and b_h_payout_status = 0; 
bid int;
HostId Booking.h_u_id%type;
HostPayStatus Booking.b_h_payout_status%type;
GuestPayout Booking.b_total%type;
HostPayout Booking.b_total_host%type;
HostTotalPayout Booking.b_total_host%type:=0;
row_count int:=0;
hp_m_id int:=0;
Begin
select max(m_id) into hp_m_id from message;
if hp_m_id is null then
    hp_m_id:=0;
end if;
hp_m_id:=hp_m_id+1;
Open C1;
Loop
Fetch C1 into bid,HostId, HostPayStatus, GuestPayout;
Exit when C1%notfound;
row_count:=row_count+1;
HostPayout := GuestPayout/1.05 * .97;
Update Booking Set b_h_payout_status = 1,b_total_host=HostPayout  where H_u_id = HostIDCheck and b_pay_date <= InputDate and b_h_payout_status = 0 and b_id=bid;
DBMS_output.put_line('Host Payment has been updated');
HostTotalPayout:=HostTotalPayout+HostPayout;
End loop;
Close C1;
If (row_count is Null or row_count=0) then raise no_data_found;
end if;
insert into payout values(seq_pay_id.nextval,HostIDCheck,sysdate,HostTotalPayout);
insert into message values(hp_m_id,HostIDCheck,sysdate,'Payment has been made for $'||HostTotalPayout);
Exception
when no_data_found then
DBMS_output.put_line('Wrong host ID or no payment left.');

End;


--Demo Script
--exec HostPayout(HostID,PaymentDate);
--Case1: Valid HostID + GuestPayout status (b_pay_status) = 1 Paid + HostPayoutStatus(b_h_status) = 0 Unpaid & GuestPaymentDate < InputDate
exec HostPayout(8,sysdate);
select * from payout;
select * from message;
update booking set b_h_payout_status = 0, b_total_host = 0 where h_u_id = 8;
delete from payout where pay_id = 9;
delete from message where m_id = 29;
--Case2: Invalid HostID
exec HostPayout(100,sysdate);


--FEATURE 13
Create or replace Procedure HostReview (BookingID Booking.B_ID%type, guest_ID int, HostRating Review.h_rating%type, HostReview Review.r_body%type)
IS
PaymentStatus varchar(10);
guest_ID_chk int;
havgrating float:=0;
host_id int;

--Selects the payment status into variable for the specific booking ID.

Begin
select b_pay_status,g_u_id,h_u_id into PaymentStatus,guest_ID_chk,host_id  
From Booking
where B_ID = BookingID;  

if guest_ID_chk != guest_ID then
    dbms_output.put_line('Guest ID not related to Booking.');
    return;
end if;    
--Ensures that host has received payment from the guest for the booking.

If PaymentStatus = 1
	then
update Review set h_rating = HostRating, r_body = HostReview where b_id = BookingID;

select avg(h_rating) into havgrating from review where b_id in (select b_id from booking where h_u_id=host_id);
update host set h_avg_rating=havgrating where h_u_id=host_id;
--Prints out the results

DBMS_output.put_line('Host Rating and Review has been successfully updated');
else
DBMS_output.put_line('Booking is not yet paid.');
end if;
Exception
when NO_DATA_FOUND then
dbms_output.put_line('No Booking Found.');
end; 


--Demo Script
--Testing
--Wrong Booking ID
exec HostReview(30,2,4,'Good host. Had a nice stay.');
--Correct Booking ID, Wrong Guest ID
exec HostReview(1,2,4,'Good host. Had a nice stay.');
--Correct Booking ID, Correct Guest ID, Status:Not Paid
exec HostReview(2,5,4,'Good host. Had a nice stay.');
--Correct Booking ID
exec HostReview(1,5,4,'Good host. Had a nice stay.');	


update review set h_rating=null, g_rating=null, r_body=null where b_id=1;



--FEATURE 14
Create or replace Procedure GuestReview (BookingID Booking.B_ID%type, host_ID int, GuestRating Review.h_rating%type)
IS
PaymentStatus varchar(10);
host_ID_chk int;
--Selects the payment status into variable for the specific booking ID.

Begin
select b_pay_status,h_u_id into PaymentStatus,host_ID_chk  
From Booking
where B_ID = BookingID;  

if host_ID_chk != host_ID then
    dbms_output.put_line('Host ID not related to Booking.');
    return;
end if;    
--Ensures that host has received payment from the guest for the booking.

If PaymentStatus = 1
	then
update Review set g_rating = GuestRating where b_id = BookingID;
--Prints out the results
DBMS_output.put_line('Host Rating and Review has been successfully updated');
else
DBMS_output.put_line('Booking is not yet paid.');
end if;
Exception
when NO_DATA_FOUND then
dbms_output.put_line('No Booking Found.');
end; 

--Demo Script
--Wrong Booking ID
exec GuestReview(30,2,4);
--Correct Booking ID, Wrong Host ID
exec GuestReview(1,2,4);
--Correct Booking ID, Correct Guest ID, Status:Not Paid
exec GuestReview(2,6,4);
--Correct Booking ID
exec GuestReview(1,8,4);




--FEATURE 15
Create or replace Procedure SummaryStatistics (k number) 
as
TotalUsers number;
TotalHosts number;
TotalGuests number;
TotalListings number;
TotalBookings number;
AvgGuestRating number;
AvgHostRating number;
HostId Host.h_u_id%type;
HostRating number;
StayPeriod float;
AvgStayPeriod float;
BookingPrice float;
AvgBookingPrice float;


--Cursor retrieves the data
cursor c1 is select h_u_id,h_avg_rating as havgrating from (select h_u_id, h_avg_rating from host where h_avg_rating is not null order by h_avg_rating desc) where rownum<=k;

cursor c2 is select g_u_id,g_avg_rating as gavgrating from (select g_u_id, g_avg_rating from guest where g_avg_rating is not null order by g_avg_rating desc) where rownum<=k;

Begin
--inputs it into the variables

Select distinct count(u_id) into TotalUsers from Users;
Select distinct count(h_u_id) into TotalHosts from Host;
Select distinct count(g_u_id) into TotalGuests from Guest;
Select distinct count(l_id) into TotalListings from Listing;
Select distinct count(b_id) into TotalBookings from Booking;
Select avg(Checkout_date - Checkin_date) into AvgStayPeriod from Booking where b_pay_status = 1;
Select avg(b_total) into AvgBookingPrice from Booking where b_pay_status = 1;


--Prints out the results
DBMS_output.put_line('Total no. of users are ' || TotalUsers);
DBMS_output.put_line('Total no. of hosts are ' || TotalHosts);
DBMS_output.put_line('Total no. of guests are ' || TotalGuests);
DBMS_output.put_line('Total no. of listings are ' || TotalListings);
DBMS_output.put_line('Total no. of bookings are ' || TotalBookings);
DBMS_output.put_line('Average Stay period is ' || AvgStayPeriod);
DBMS_output.put_line('Average Booking Price is ' || AvgBookingPrice);

DBMS_output.put_line('Top ' || k || ' hosts with highest average ratings are' );

--Loop for finding top k Host
for item in c1 loop
dbms_output.put_line('Host ID : '||item.h_u_id|| ', Host Rating : '||item.havgrating);
end loop;

DBMS_output.put_line('Top ' || k || ' guests with highest average ratings are' );

--Loop for finding top k Guest
for item in c2 loop
dbms_output.put_line('Guest ID : '||item.g_u_id|| ', Guest Rating : '||item.gavgrating);
end loop;
End;


--Demo Script
--Execution
exec SummaryStatastics(3);






