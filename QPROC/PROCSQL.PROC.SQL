/*From DB2 UDB for AS/400 SQL Programming Concepts V4R5
  Chapter 7 Stored Procedures
  Page 121  */

-- SQL PROCEDURE pseudo-source
--   LMi will also create PROCSQL *PGM CLE
--   Requires:  EMPLOYEE Table

CREATE PROCEDURE &LIB/PROCSQL
         (IN DEPT_NUMBER CHAR(3),
          INOUT CNT INT)
          LANGUAGE SQL MODIFIES SQL DATA
          CS1:  BEGIN ATOMIC
          DECLARE FULLNAME VARCHAR(30) DEFAULT NULL;
          DECLARE FSTNAM VARCHAR(12) DEFAULT NULL;
          DECLARE MDLINL CHAR(1) DEFAULT NULL;
          DECLARE LSTNAM VARCHAR(15) DEFAULT NULL;
          DECLARE BONUS DECIMAL(10,2) DEFAULT NULL;
          DECLARE CONTINUE HANDLER FOR SQLSTATE '42710'
             SELECT COUNT(*) INTO CNT
             FROM EMPLOYEE;
          DECLARE CONTINUE HANDLER FOR SQLSTATE '23505'
             SET CNT = CNT + 1;
          DECLARE UNDO HANDLER FOR SQLEXCEPTION
             SET CNT = NULL;
                SET FULLNAME = FSTNAM CONCAT ' ' CONCAT
                           MDLINL CONCAT ' ' CONCAT LSTNAM;
                INSERT INTO EMPLOYEE_BONUS
                   VALUES(CS1.FULLNAME, BONUS);
                SET CNT = CNT +1;
        END CS1;

comment on procedure PROCSQL
is 'I am an SQL PROC!'
