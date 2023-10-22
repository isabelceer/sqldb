---Database for a delivery tracking system

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name varchar(40) NOT NULL,
	last_name varchar(60) NOT NULL,
	address varchar(60) NOT NULL,
	city varchar(60) NOT NULL,
	zip_code varchar(6) NOT NULL,
	phone_number varchar(11) NOT NULL,
	email_address varchar(100) NOT NULL
	
);

CREATE TABLE packages (
    package_id SERIAL PRIMARY KEY,
    sender_id integer,
	recipient_id integer,
	weight integer,
	dimension char(1) CHECK (dimension IN ('S', 'M', 'L')),
	FOREIGN KEY (sender_id) REFERENCES customers(customer_id),
	FOREIGN KEY (recipient_id) REFERENCES customers(customer_id)
);


CREATE TABLE couriers (
    courier_id SERIAL PRIMARY KEY,
    first_name varchar(40) NOT NULL,
	last_name varchar(60) NOT NULL,
	vehicle_type varchar(40)
);

CREATE TABLE tracking (
    tracking_id SERIAL PRIMARY KEY,
	package_id integer,
	sending_date date,
    delivery_date date,
	current_location varchar(60),
	status varchar(40) CHECK (status IN ('shipped', 'in transit', 'delivered')),
	FOREIGN KEY (package_id) REFERENCES packages (package_id)
);

CREATE TABLE invoices (
	invoice_id SERIAL PRIMARY KEY,
	customer_id integer,
	package_id integer, 
	invoice_date date, 
	total_amount integer NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
	FOREIGN KEY (package_id) REFERENCES packages (package_id)
);

CREATE MATERIALIZED VIEW customers_history_of_delivered_packages AS
SELECT 
   t.tracking_id,
   p.package_id,
   p.sender_id,
   p.recipient_id,
   t.delivery_date  
from packages p 
    INNER JOIN tracking t 
        ON p.package_id = t.package_id
		WHERE t.status= 'delivered';
		