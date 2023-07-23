DROP DATABASE IF EXISTS twitter_db;

CREATE DATABASE twitter_db;

USE twitter_db;

DROP TABLE IF EXISTS users;

CREATE TABLE users ( 
    user_id INT NOT NULL AUTO_INCREMENT, 
    user_handle VARCHAR(50) NOT NULL UNIQUE, 
    email_address VARCHAR(50) NOT NULL UNIQUE, 
    first_name VARCHAR(100) NOT NULL, 
    last_name VARCHAR(100) NOT NULL, 
    phonenumber CHAR(10) UNIQUE, 
    follower_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()), 
    PRIMARY KEY(user_id)
);

INSERT INTO users (user_handle, email_address, first_name, last_name, phonenumber) 
VALUES 
    ("yisuslalala", "yisuslalala1.00@gmail.com", "Jesús Eduardo", "Quiñones Mata", 8342473594),
    ("Miguelito", "miguelito@gmail.com", "Miguel", "Herrera", 3333333333),
    ("AuroraOficial", "aurora_singer@vevo.com", "Aurora", "Ødegaard", 1000000001),
    ("Pepito", "pepito_arqui@hotmail.com", "José", "Ramírez", 8341234567);

DROP TABLE IF EXISTS followers;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    FOREIGN KEY(follower_id) REFERENCES users(user_id),
    FOREIGN KEY(following_id) REFERENCES users(user_id),
    PRIMARY KEY (follower_id, following_id)
);

INSERT INTO followers (follower_id, following_id)
VALUES
    (2, 1),
    (3, 1),
    (2, 3),
    (3, 2),
    (4, 1),
    (4, 2),
    (2, 4),
    (3, 4);


-- TOP 3 usuarios con más followers

SELECT following_id, COUNT(follower_id) as followers 
FROM followers 
GROUP BY follower_id 
ORDER BY followers DESC
LIMIT 3;

-- TOP 3 usuarios con más followers con joins
SELECT users.user_id, users.user_handle, users.first_name, COUNT(follower_id) as followers 
FROM followers 
JOIN users on users.user_id = followers.following_id
GROUP BY follower_id 
ORDER BY followers DESC
LIMIT 3;

CREATE TABLE tweets(
    tweet_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_text VARCHAR(280) NOT NULL,
    num_likes INT DEFAULT 0,
    num_retweets INT DEFAULT 0,
    num_comments INT DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()),    
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    PRIMARY KEY (tweet_id)
);

INSERT INTO tweets (user_id, tweet_text) 
VALUES 
(1, "Hola amigos de twitter"),
(2, "Soy miguelito"),
(3, "I was listening to the ocean"),
(4, "No me gusta que me digan Pepito -Pepito"),
(1, "Soy un increible programador"),
(1, "Python es el lenguaje que más me ha gustado :)"),
(2, "Me gusta CR"),
(3, "Nobody know me"),
(1, "Explorando nuevas tecnologías, por fin a crear");

-- Obtener los tweets de los usuarios con más de 2 seguidres
SELECT user_id, tweet_text
FROM tweets
WHERE user_id IN (
    SELECT following_id
    FROM followers
    GROUP BY following_id
    HAVING COUNT(*) > 2
);

/*
DELETE FROM tweets WHERE tweet_id = 1;
*/
-- Update likes
UPDATE tweets SET num_likes = num_likes + 1 WHERE tweet_id = 2;

-- Replace text
UPDATE tweets SET tweet_text = REPLACE(tweet_text, "was", "am")
WHERE tweet_text LIKE '%was%';


CREATE TABLE tweet_likes(
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    PRIMARY KEY (user_id, tweet_id)
);

INSERT INTO tweet_likes (user_id, tweet_id)
VALUES
    (1, 3),
    (1, 4),
    (1, 2),
    (3, 3),
    (2, 4),
    (4, 4);

-- Obtener el número de likes para cada tuit
SELECT tweet_id, COUNT(*) AS likes
FROM tweet_likes
GROUP BY tweet_id;

/*CREATE TRIGGER*/
DELIMITER $$
CREATE TRIGGER increase_follower_count
    AFTER INSERT ON followers
    FOR EACH ROW
    BEGIN 
        UPDATE users SET follower_count = follower_count + 1
        WHERE user_id = NEW.following_id;
    END $$
DELIMITER ;

