
#1 建表dept
CREATE TABLE dept(  
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,  
deptno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,   
dname VARCHAR(20) NOT NULL DEFAULT "",  
`loc` VARCHAR(13) NOT NULL DEFAULT ""  
) ENGINE=INNODB DEFAULT CHARSET=utf8 ;  


#2 建表emp
CREATE TABLE emp  
(  
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,  
empno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '编号', /*编号*/  
ename VARCHAR(20) NOT NULL DEFAULT "" COMMENT '名字', /*名字*/  
job VARCHAR(9) NOT NULL DEFAULT "" COMMENT '名字',/*名字*/  
mgr MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级编号',/*上级编号*/  
hiredate DATE NOT NULL COMMENT '入职时间',/*入职时间*/  
sal DECIMAL(7,2) NOT NULL COMMENT '薪水',/*薪水*/  
comm DECIMAL(7,2) NOT NULL COMMENT '红利',/*红利*/  
deptno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '部门编号' /*部门编号*/  
)ENGINE=INNODB DEFAULT CHARSET=utf8 ;

SHOW VARIABLES LIKE 'log_bin_trust_function_creators'; 
SET GLOBAL log_bin_trust_function_creators=1;

DELIMITER $$
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
BEGIN
 DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFJHIJKLMNOPQRSTUVWXYZ';
 DECLARE return_str VARCHAR(255) DEFAULT '';
 DECLARE i INT DEFAULT 0;
 WHILE i < n DO
 SET return_str =CONCAT(return_str,SUBSTRING(chars_str,FLOOR(1+RAND()*52),1));
 SET i = i + 1;
 END WHILE;
 RETURN return_str;
END $$

#用于随机产生部门编号
DELIMITER $$
CREATE FUNCTION rand_num( ) 
RETURNS INT(5)  
BEGIN   
 DECLARE i INT DEFAULT 0;  
 SET i = FLOOR(100+RAND()*10);  
RETURN i;  
 END $$
 
 
#假如要删除
#drop function rand_num;

#执行存储过程，往dept表添加随机数据
DELIMITER $$
CREATE PROCEDURE insert_dept(IN START INT(10),IN max_num INT(10))  
BEGIN  
DECLARE i INT DEFAULT 0;   
 SET autocommit = 0;    
 REPEAT  
 SET i = i + 1;  
 INSERT INTO dept (deptno ,dname,loc ) VALUES ((START+i) ,rand_string(10),rand_string(8));  
 UNTIL i = max_num  
 END REPEAT;  
 COMMIT;  
 END $$
 
DELIMITER $$
CREATE PROCEDURE insert_emp(IN START INT(10),IN max_num INT(10))  
BEGIN  
DECLARE i INT DEFAULT 0;   
#set autocommit =0 把autocommit设置成0  
 SET autocommit = 0;    
 REPEAT  
 SET i = i + 1;  
 INSERT INTO emp (empno, ename ,job ,mgr ,hiredate ,sal ,comm ,deptno ) VALUES ((START+i) ,rand_string(6),'SALESMAN',0001,CURDATE(),2000,400,rand_num());  
 UNTIL i = max_num  
 END REPEAT;  
 COMMIT;  
 END $$
 
#删除
# DELIMITER ;
# drop PROCEDURE insert_emp;

DELIMITER ;
#执行存储过程，往dept中插入10条数据
CALL insert_dept(100,10); 
 
 
#执行存储过程，往emp表添加50万条数据
DELIMITER ;
CALL insert_emp(100000,5000000); 