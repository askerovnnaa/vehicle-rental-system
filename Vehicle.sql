CREATE TABLE Vehicle (
    vehicle_id SERIAL PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    price_per_day DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('available', 'rented', 'maintenance'))
);

CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

CREATE TABLE RentalService (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customer(customer_id) ON DELETE CASCADE,
    vehicle_id INT REFERENCES Vehicle(vehicle_id) ON DELETE CASCADE,
    rental_date DATE DEFAULT CURRENT_DATE,
    return_date DATE,
    total_price DECIMAL(10,2)
);

INSERT INTO Vehicle (vehicle_id,make, model, year, price_per_day, status)
VALUES (1,'Toyota', 'Corolla', 2020, 40.00, 'available'),
       (2,'Nissan','Maxima','2015',20.00,'rented'),
       (3 ,'Mercedes','Benz','2018',30.00,'maintenance'),
       (4,'BMW','X5','2022',50.00,'rented'),
       (5,'Lexus','RX540','2024',80.00,'available');

INSERT INTO Customer (name, email, phone)
VALUES ('John Doe', 'john@example.com', '87091247683'),
       ('Selena Gomes','selena@example.com','87014539598'),
       ('Jennie Kim','jennie@example.com','87717859001'),
       ('Lalisa Manoban','lalisa@example.com','87054378791'),
       ('Jisoo Kim','jisoo@example.com','87712849988');

SELECT * FROM Vehicle;
SELECT * FROM Customer;
SELECT * FROM RentalService;
SELECT * FROM Vehicle WHERE status = 'available';
SELECT c.name, c.email, r.rental_date, r.return_date, v.make, v.model
FROM RentalService r
JOIN Customer c ON r.customer_id = c.customer_id
JOIN Vehicle v ON r.vehicle_id = v.vehicle_id;
SELECT v.make, v.model, r.rental_date, r.return_date
FROM RentalService r
JOIN Vehicle v ON r.vehicle_id = v.vehicle_id
JOIN Customer c ON r.customer_id = c.customer_id
WHERE c.name = 'Jennie Kim';



UPDATE Vehicle
SET status = 'rented'
WHERE vehicle_id = 1;


UPDATE Vehicle
SET status = 'available'
WHERE vehicle_id IN (
    SELECT vehicle_id FROM RentalService
    WHERE return_date < CURRENT_DATE
);
UPDATE Vehicle
SET price_per_day = price_per_day + 5
WHERE year = 2020;

DELETE FROM Customer WHERE customer_id = 1;

DELETE FROM RentalService
WHERE customer_id = (SELECT customer_id FROM Customer WHERE name = 'Selena Gomes');

DELETE FROM Vehicle WHERE year < 2015;

DELETE FROM Customer WHERE name = 'Jisoo Kim';


