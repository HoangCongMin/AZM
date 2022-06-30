IF EXISTS (SELECT*FROM sys.databases WHERE NAME='KINHDOANH') 
DROP DATABASE KINHDOANH
CREATE DATABASE KINHDOANH
GO


CREATE TABLE CUSTOMER (
 CUSTOMERID INT PRIMARY KEY NOT NULL,
 NAME VARCHAR(70),
 ADDRESS VARCHAR(100),
 TEL INT,
 STATUS VARCHAR(50)

)
CREATE TABLE ODER(
 ODERID INT PRIMARY KEY NOT NULL,
 CUSTOMERID INT FOREIGN KEY(CUSTOMERID) REFERENCES CUSTOMER(CUSTOMERID),
 ODERDATE DATE,
 STATUS VARCHAR(50) 
)

CREATE TABLE PRODUCT(
 PRODUCID INT PRIMARY KEY NOT NULL,
 PRODUCTNAME VARCHAR(70),
 DESCRIPTION VARCHAR(100),
 UNIT VARCHAR (50),
 PRICE MONEY,
 QTY INT,
 STATUS VARCHAR(50)

)

CREATE TABLE ODERDITAILS(
 ODERID INT FOREIGN KEY (ODERID) REFERENCES ODER(ODERID),
 PRODUCID INT FOREIGN KEY (PRODUCID) REFERENCES PRODUCT(PRODUCID),
 PRICE MONEY,
 QTY INT
)
INSERT INTO CUSTOMER(CUSTOMERID,NAME,ADDRESS,TEL,STATUS) VALUES(98,'MINH','THAINGUYEN',0973201993,'DANHAN')
INSERT INTO CUSTOMER(CUSTOMERID,NAME,ADDRESS,TEL,STATUS) VALUES(68,'QUANG','THAINGUYEN',0973201893,'CHUANHAN')


INSERT INTO ODER(ODERID,CUSTOMERID,ODERDATE,STATUS) VALUES(14,98,'3-7-2022','ON')
INSERT INTO ODER(ODERID,CUSTOMERID,ODERDATE,STATUS) VALUES(78,68,'3-9-2022','OFF')

INSERT INTO PRODUCT(PRODUCID,PRODUCTNAME,DESCRIPTION,UNIT,PRICE,QTY,STATUS) VALUES(90,'MENTIEUHOA','THUOCBO','HANGHIEM',500,1000,'BANCHAM')
INSERT INTO PRODUCT(PRODUCID,PRODUCTNAME,DESCRIPTION,UNIT,PRICE,QTY,STATUS) VALUES(78,'SUACHUA','DOUONG','HANGBANCHAY',300,1000,'BANCHAM')

INSERT INTO ODERDITAILS(ODERID,PRODUCID,PRICE,QTY) VALUES(14,90,500,9)
INSERT INTO ODERDITAILS(ODERID,PRODUCID,PRICE,QTY) VALUES(78,78,800,9)


SELECT*FROM ODER
SELECT*FROM CUSTOMER
SELECT*FROM ODERDITAILS
SELECT*FROM PRODUCT


SELECT NAME FROM CUSTOMER
SELECT PRODUCTNAME FROM PRODUCT
SELECT ODERID FROM ODER

SELECT*FROM CUSTOMER ORDER BY NAME ASC
SELECT*FROM CUSTOMER ORDER BY NAME DESC

SELECT PRODUCTNAME FROM PRODUCT WHERE PRODUCID =90

SELECT PRODUCTNAME FROM ODERDITAILS WHERE QTY=78

SELECT CUSTOMERID FROM CUSTOMER WHERE NAME='MINH'

SELECT ODERID FROM ODER WHERE CUSTOMERID=(SELECT CUSTOMERID FROM CUSTOMER WHERE NAME='MINH')

SELECT PRODUCID  FROM ODERDITAILS WHERE ODERID=(SELECT ODERID FROM ODER WHERE CUSTOMERID=(SELECT CUSTOMERID FROM CUSTOMER WHERE NAME='MINH'))

SELECT PRODUCTNAME FROM PRODUCT WHERE PRODUCID=(
    SELECT PRODUCID  FROM ODERDITAILS WHERE ODERID=(
        SELECT ODERID FROM ODER WHERE CUSTOMERID=(
            SELECT CUSTOMERID FROM CUSTOMER WHERE NAME='MINH'
        )
    )
);

SELECT COUNT(DISTINCT NAME ) FROM CUSTOMER
SELECT COUNT(DISTINCT PRODUCTNAME) FROM PRODUCT
SELECT*,(PRICE*QTY) AS TOTAL FROM ODERDITAILS

ALTER TABLE ODERDITAILS
ADD CONSTRAINT MCB CHECK(PRICE>0)



ALTER TABLE ODER
ADD CONSTRAINT MOP CHECK( DATEDIFF(SECOND,ODERDATE,GETDATE())>0);


ALTER TABLE PRODUCT
ADD NGAYSANXUAT DATE

CREATE UNIQUE INDEX MKLT
ON PRODUCT (PRODUCTNAME);

CREATE UNIQUE INDEX MKLM
ON CUSTOMER (NAME);

CREATE VIEW [CUSTOMERVIEW] AS 
SELECT NAME,ADDRESS,TEL
FROM CUSTOMER;

SELECT* FROM [CUSTOMERVIEW]

CREATE VIEW [PRODUCTVIEW] AS
SELECT PRODUCTNAME,PRICE
FROM PRODUCT;

SELECT* FROM [PRODUCTVIEW]


CREATE VIEW [PRODUCTVIEWCUSTOMERVIEW] AS(
    SELECT CUSTOMER.NAME,CUSTOMER.TEL, PRODUCT.PRODUCTNAME,ODERDITAILS.QTY,ODER.ODERDATE
    FROM CUSTOMER 
    INNER JOIN ODER ON CUSTOMER.CUSTOMERID=ODER.CUSTOMERID
    INNER JOIN ODERDITAILS ON ODER.ODERID= ODERDITAILS.ODERID
    INNER JOIN PRODUCT ON ODERDITAILS.PRODUCID=PRODUCT.PRODUCID

)

SELECT* FROM [PRODUCTVIEWCUSTOMERVIEW]

CREATE PROCEDURE SP_TimKH_MaKH
@MA INT
AS
SELECT * FROM CUSTOMER
WHERE CUSTOMERID= @MA
EXECUTE SP_TimKH_MaKH 98


CREATE PROCEDURE SP_TimKH_MaHD
@MB INT
AS
SELECT * FROM ODER
WHERE ODERID= @MB
EXECUTE SP_TimKH_MaHD 78

CREATE PROCEDURE SP_SanPham_MaKH1
@MC INT
AS
SELECT PRODUCT.PRODUCID,CUSTOMER.NAME,CUSTOMER.CUSTOMERID,PRODUCT.PRODUCTNAME FROM CUSTOMER
INNER JOIN ODER ON CUSTOMER.CUSTOMERID=ODER.CUSTOMERID
    INNER JOIN ODERDITAILS ON ODER.ODERID= ODERDITAILS.ODERID
    INNER JOIN PRODUCT ON ODERDITAILS.PRODUCID=PRODUCT.PRODUCID
WHERE CUSTOMER.CUSTOMERID= @MC
EXECUTE SP_SanPham_MaKH1 98



