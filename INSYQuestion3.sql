-- Q.3.1: Create the Patient table
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    PatientSurname VARCHAR(50),
    DateOfBirth DATE
);

-- Q.3.2: Create the Doctor table
CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50),
    DoctorSurname VARCHAR(50)
);

-- Q.3.3: Create the Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    AppointmentDate DATE,
    AppointmentTime TIME,
    Duration INT,
    DoctorID INT,
    PatientID INT,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

-- Q.3.4: Insert data into Patient table
INSERT INTO Patient (PatientID, PatientName, PatientSurname, DateOfBirth)
VALUES 
(1, 'Debbie', 'Theart', '1980-03-17'),
(2, 'Thomas', 'Duncan', '1976-08-12');

-- Insert data into Doctor table
INSERT INTO Doctor (DoctorID, DoctorName, DoctorSurname)
VALUES
(1, 'Zintle', 'Nukani'),
(2, 'Ravi', 'Maharaj');

-- Insert data into Appointments table
INSERT INTO Appointments (AppointmentID, AppointmentDate, AppointmentTime, Duration, DoctorID, PatientID)
VALUES
(1, '2025-01-15', '09:00:00', 15, 2, 1),
(2, '2025-01-18', '15:00:00', 30, 2, 2),
(3, '2025-01-20', '10:00:00', 15, 1, 1),
(4, '2025-01-21', '11:00:00', 15, 2, 1);

-- Q.3.5: Display appointments between 2025-01-16 and 2025-01-20 inclusive
SELECT *
FROM Appointments
WHERE AppointmentDate BETWEEN '2025-01-16' AND '2025-01-20';

-- Q.3.6: Display patient names with total number of appointments, sorted descending
SELECT P.PatientName, P.PatientSurname, COUNT(A.AppointmentID) AS TotalAppointments
FROM Patient P
LEFT JOIN Appointments A ON P.PatientID = A.PatientID
GROUP BY P.PatientID
ORDER BY TotalAppointments DESC;

-- Q.3.7: Display all appointments with details, sorted by date descending
SELECT 
    A.AppointmentDate,
    A.AppointmentTime,
    D.DoctorName,
    D.DoctorSurname,
    P.PatientName,
    P.PatientSurname
FROM Appointments A
JOIN Doctor D ON A.DoctorID = D.DoctorID
JOIN Patient P ON A.PatientID = P.PatientID
ORDER BY A.AppointmentDate DESC;

-- Q.3.8: Create a view for patients with appointments with DoctorID 2
CREATE VIEW PatientsWithDoctor2 AS
SELECT DISTINCT P.PatientName, P.PatientSurname
FROM Patient P
JOIN Appointments A ON P.PatientID = A.PatientID
WHERE A.DoctorID = 2
ORDER BY P.PatientSurname ASC;

-- Q.3.9: Create stored procedure to get appointments for a given date
DELIMITER $$
CREATE PROCEDURE get_appointments(IN app_date DATE)
BEGIN
    SELECT 
        A.AppointmentTime,
        A.Duration,
        D.DoctorName,
        D.DoctorSurname,
        P.PatientName,
        P.PatientSurname
    FROM Appointments A
    JOIN Doctor D ON A.DoctorID = D.DoctorID
    JOIN Patient P ON A.PatientID = P.PatientID
    WHERE A.AppointmentDate = app_date
    ORDER BY A.AppointmentTime ASC;
END $$
DELIMITER ;