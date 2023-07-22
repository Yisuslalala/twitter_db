CREATE TABLE users ( 
    user_id INT NOT NULL AUTO_INCREMENT, 
    user_handle VARCHAR(50) NOT NULL UNIQUE, 
    email_adress VARCHAR(50) NOT NULL UNIQUE, 
    first_name VARCHAR(100) NOT NULL, 
    last_name VARCHAR(100) NOT NULL, 
    phonenumber CHAR(10) UNIQUE, 
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()), 
    PRIMARY KEY(user_id)
);