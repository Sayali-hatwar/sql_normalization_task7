/*
CREATE TABLE hospital_dump (
    appointment_id INT,
    appointment_date DATE,
    appointment_time TIME,
    patient_id INT,
    patient_name TEXT,
    patient_phone TEXT,
    doctor_id INT,
    doctor_name TEXT,
    doctor_specialty TEXT,
    room_number TEXT
);

INSERT INTO hospital_dump VALUES
(101, '2025-10-01', '09:00', 1, 'John Doe', '555-0001', 50, 'Dr. Smith', 'Cardiology', 'Room A'),
(102, '2025-10-01', '10:00', 2, 'Jane Roe', '555-0002', 50, 'Dr. Smith', 'Cardiology', 'Room A'),
(103, '2025-10-01', '11:00', 3, 'Bob Hill', '555-0003', 51, 'unkown', 'Neurology', 'Room B'),
(104, '2025-10-02', '09:30', 1, 'John Doe', '555-0001', 51, 'Dr. Adams', 'Neurology', 'Room B'),
(105, '2025-10-02', '10:30', 4, 'Alice Blue', '555-0004', 52, 'Dr. White', 'Dermatology', 'Room C'),
(106, '2025-10-03', '08:00', 5, 'Charlie Brown', '555-0005', 50, 'Dr. Smith', 'Cardiology', 'Room A'),
(107, '2025-10-03', '09:00', 2, 'Jane Roe', '555-0002', 52, 'Dr. White', 'Dermatology', 'Room C'),
(108, '2025-10-04', '14:00', 6, 'Lucy Van', '555-0006', 53, 'Dr. Green', 'General', 'Room D'),
(109, '2025-10-04', '15:00', 7, 'Linus P.', '555-0007', 53, 'Dr. Green', 'General', 'Room D'),
(110, '2025-10-05', '11:00', 8, 'Sally Brown', '555-0008', 50, 'Dr. Smith', 'Cardiology', 'Room A');

*/



SELECT * FROM hospital_dump;

--Normalizing doctor table
select doctor_id, doctor_name, doctor_specialty FROM hospital_dump;
-- has duplicates

select DISTINCT doctor_id, doctor_name, doctor_specialty FROM hospital_dump;
-- table has one unknown value

--transfer data from hospital_dump to doctor_entry table
create table doctor_entry as(
select DISTINCT doctor_id, doctor_name, doctor_specialty FROM hospital_dump  
);
select * from doctor_entry;

-- handle unknown value
update doctor_entry set doctor_id = (select max(doctor_id)+1 from doctor_entry)
where doctor_name = 'unkown';

select * from doctor_entry;
---This table contains unique doctors

-- insert primary key
ALTER TABLE doctor_entry add PRIMARY KEY (doctor_id);

---------------------------------------------------------
-- Normalizing patient table
select DISTINCT patient_id, patient_name, patient_phone from hospital_dump;

--Transfer data to patient_entry table
create table patient_entry as(
select DISTINCT patient_id, patient_name, patient_phone from hospital_dump
);

-- Adding primary key
alter table patient_entry add PRIMARY key(patient_id);
select * from patient_entry;

------------------------------------------------------------
--Normalizing appointment table
select distinct appointment_id, appointment_date, appointment_time,room_number from hospital_dump;

--Transfer data to appointment_entry table
create table appointment_entry as(
    select distinct appointment_id, appointment_date, appointment_time, room_number from hospital_dump);

--Renaming the column name
alter table appointment_entry rename room_number to patient_room;

--Adding primary key
alter table appointment_entry add primary key(appointment_id);

select * from appointment_entry;
