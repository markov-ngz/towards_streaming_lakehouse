USE rest ; -- weirdly it is not shown

-- create ns 
CREATE DATABASE sandbox ; 

USE sandbox; 


create table rest.sandbox.my_table (
    k int,
    v string
) tblproperties (
    'primary-key' = 'k'
);

INSERT INTO rest.sandbox.my_table(k,v) VALUES (1,'a') , (2,'b') ; 

SELECT * FROM my_table ; 