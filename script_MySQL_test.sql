CREATE DATABASE Users CHARACTER SET utf8;
USE Users;

CREATE TABLE courses(
	course_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	course_name VARCHAR(20) NOT NULL,
	course_code VARCHAR(10) UNIQUE NOT NULL	
);

CREATE TABLE users(
	user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_name VARCHAR(30) NOT NULL,
	user_email VARCHAR(40) UNIQUE NOT NULL,
    user_status TINYINT(2)
    
);

CREATE TABLE user_course(
	user_id INT,
	course_id INT,
	PRIMARY KEY (user_id, course_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE,
	FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE CASCADE
    );


DELIMITER //
CREATE PROCEDURE add_user(
	IN username VARCHAR(30),
	IN useremail VARCHAR(40),
    IN userstatus TINYINT(2)
)
BEGIN
    IF(username = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'user_name field is required!';
    ELSEIF(useremail = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'email field is required!';
    ELSEIF(useremail NOT RLIKE '^[a-zA-Z0-9][+a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]*\\.[a-zA-Z]{2,4}$') THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'email enter the valid email adress!';
    ELSE
    	INSERT INTO users(
    	user_name,
    	user_email,
        user_status
    	)
    	VALUES(
    	username,
    	useremail,
        userstatus
    	);
    END IF;
END
//
DELIMITER //
CREATE PROCEDURE get_users(
	IN num_from INT,
    IN num_row INT
)
BEGIN
SELECT user_id, user_name, user_email, user_status FROM users LIMIT num_from, num_row;
END
//

DELIMITER //
CREATE PROCEDURE get_courses()
BEGIN
SELECT course_id, course_name, course_code FROM courses;
END
//

DELIMITER //
CREATE PROCEDURE add_course(
	IN coursename VARCHAR(20),
    IN coursecode VARCHAR(10)
)
BEGIN
    IF(coursename = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'course_name field is required!';
	ELSEIF(coursecode = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'course_code field is required!';
	ELSE
		INSERT INTO courses(
        course_name,
        course_code
        )
        VALUES(
        coursename,
        coursecode
		);
	END IF;
END
//

DELIMITER //
CREATE PROCEDURE add_completed_course(
	IN userid INT,
    IN courseid INT
)
BEGIN
	IF(userid = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'User id is required!';
	ELSEIF(courseid = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Course id is required!';
    ELSEIF(NOT(SELECT EXISTS(SELECT * FROM users WHERE user_id = userid))) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'course or user id does not exist!';
	
	ELSE
		INSERT INTO user_course(
			user_id,
			course_id
			)
		VALUES(
			(SELECT user_id FROM users WHERE user_id = userid),
			(SELECT course_id FROM courses WHERE course_id = courseid)
			);	
	END IF;
END
//

DELIMITER //
CREATE PROCEDURE get_completed_course(
	IN userid INT
)
BEGIN
	IF(userid = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'User id is required!';
	
	ELSEIF(NOT(SELECT EXISTS(SELECT * FROM users WHERE user_id = userid))) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'user id does not exist!';
	ELSE
		SELECT course_name FROM courses
		INNER JOIN user_course ON user_course.course_id = courses.course_id
		AND user_course.user_id = userid;
	END IF;
END
//

DELIMITER //
CREATE PROCEDURE get_not_completed_course(
	IN userid INT
)
BEGIN
	IF(userid = '') THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'User id is required!';
	
	ELSEIF(NOT(SELECT EXISTS(SELECT * FROM users WHERE user_id = userid))) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'user id does not exist!';
	ELSE
		SELECT course_name FROM courses
        WHERE course_id NOT IN (SELECT courses.course_id FROM courses
		INNER JOIN user_course ON user_course.course_id = courses.course_id
		AND user_course.user_id = userid);
	END IF;
END
//

DELIMITER //
CREATE PROCEDURE delete_user(
	IN userid INT
)
BEGIN
	IF(NOT(SELECT EXISTS(SELECT * FROM users WHERE user_id = userid))) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'user id does not exist!';
	ELSE
		DELETE FROM users WHERE user_id = userid;
	END IF;
END
//

DELIMITER //
CREATE PROCEDURE delete_course(
	IN courseid INT
)
BEGIN
	IF(NOT(SELECT EXISTS(SELECT * FROM courses WHERE course_id = courseid))) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'course id does not exist!';
	ELSE
		DELETE FROM courses WHERE course_id = courseid;
	END IF;
END
//

DELIMITER //
CREATE PROCEDURE delete_complete_course(
	IN userid INT,
    IN courseid INT
)
BEGIN
	IF(NOT(SELECT EXISTS(SELECT * FROM user_course WHERE course_id = courseid))) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'course id does not exist!';
	ELSEIF(NOT(SELECT EXISTS(SELECT * FROM user_course WHERE user_id = userid))) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'user id does not exist!';
	ELSE
		DELETE FROM user_course WHERE user_id = userid AND course_id = courseid;
	END IF;
END
//
DELIMITER ;