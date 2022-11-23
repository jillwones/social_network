TRUNCATE TABLE user_accounts RESTART IDENTITY CASCADE; 

INSERT INTO user_accounts 
(user_name, email_address) 
VALUES ('jill53', 'jill53@hotmail.com');

INSERT INTO user_accounts 
(user_name, email_address) 
VALUES ('bob123', 'bob123@gmail.com');
