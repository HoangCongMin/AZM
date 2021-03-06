IF EXISTS (SELECT*FROM sys.databases WHERE NAME='B6') 
DROP DATABASE B6
CREATE DATABASE B6
GO


CREATE TABLE NHAXUATBAN(
    IDNHAXUATBAN INT PRIMARY KEY,
    NAMENHAXUATBAN VARCHAR(50),
    DIACHINHASANXUAT VARCHAR(50)
)

GO


CREATE TABLE LOAISACH(
    IDLOAISACH INT PRIMARY KEY,
    NAMELOAISACH VARCHAR(50)

)

GO

CREATE TABLE SACH(
    IDSACH INT PRIMARY KEY,
    NAMESACH VARCHAR(50),
    IDNHAXUATBAN INT FOREIGN KEY (IDNHAXUATBAN) REFERENCES  NHAXUATBAN(IDNHAXUATBAN),
    IDLOAISACH INT FOREIGN KEY (IDLOAISACH) REFERENCES LOAISACH(IDLOAISACH),
    TENTACGIA VARCHAR (50),
    NOIDUNGTOMTAT VARCHAR (1000),
    LANXUATBAN INT,
    GIABAN MONEY,
    SOLUONG INT ,
    NAMXUATBAN DATETIME

)

GO

INSERT INTO NHAXUATBAN(IDNHAXUATBAN,NAMENHAXUATBAN,DIACHINHASANXUAT) VALUES(123,'MINHHOANG','THAINGUYEN'),
                                                                           (124,'NHIDONG','HANOI'),
                                                                           (125,'GARENA','TUYENQUANG'),
                                                                           (126,'TUOITRE','CAMAU')

CREATE TRIGGER CHECKIDNHAXUATBAN12
ON NHAXUATBAN
FOR INSERT
AS BEGIN
 IF EXISTS (SELECT * FROM inserted WHERE IDNHAXUATBAN <200)
 BEGIN
   PRINT 'ID KHONG THE NHO HON 200';
   ROLLBACK TRANSACTION;
   END
END
INSERT INTO NHAXUATBAN(IDNHAXUATBAN,NAMENHAXUATBAN,DIACHINHASANXUAT) VALUES(199,'MINHHOANG','THAINGUYEN')

DROP TRIGGER CHECKIDNHAXUATBAN0

DROP TRIGGER UPDATECLASSID

CREATE TRIGGER CHECKIDNHAXUATBAN0
ON SACH
FOR UPDATE
AS BEGIN
 IF EXISTS (SELECT * FROM inserted INNER JOIN deleted  ON inserted.IDNHAXUATBAN= deleted.IDNHAXUATBAN WHERE inserted.LANXUATBAN < deleted.LANXUATBAN)
 BEGIN
   PRINT 'ID KHONG THE NHO HON ID CU';
   ROLLBACK TRANSACTION;
   END
END
INSERT INTO SACH(IDSACH,NAMESACH,IDNHAXUATBAN,IDLOAISACH,TENTACGIA,NOIDUNGTOMTAT,LANXUATBAN,GIABAN,SOLUONG,NAMXUATBAN) VALUES(08968,'TEOEM',123,987,'TRINHCONGSON','VECHUYENHAI',20,700,100,'12-25-2001')
UPDATE SACH SET LANXUATBAN = 15

CREATE TRIGGER UPDATECLASSID
ON SACH
FOR UPDATE
AS
 IF (UPDATE(SOLUONG))
 BEGIN
  PRINT 'KHONG THE CAP NHAT SO LUONG';
  ROLLBACK TRANSACTION;
  END

  UPDATE SACH SET SOLUONG =5 WHERE SOLUONG= 20

GO

CREATE TRIGGER DELETESACH1
ON SACH
FOR DELETE
AS
BEGIN
 DECLARE @ID INT;
 SELECT @ID = IDSACH FROM deleted;
 ROLLBACK TRANSACTION;
 UPDATE SACH SET IDSACH=6789 WHERE IDSACH=@ID;
END
DELETE FROM SACH WHERE IDSACH=6789





SELECT * FROM SACH


INSERT INTO LOAISACH(IDLOAISACH,NAMELOAISACH) VALUES(987,'HAI'),
                                                    (986,'TRUYENTRANH'),
                                                    (985,'TIENGANH'),
                                                    (984,'TIENGANH')

INSERT INTO SACH(IDSACH,NAMESACH,IDNHAXUATBAN,IDLOAISACH,TENTACGIA,NOIDUNGTOMTAT,LANXUATBAN,GIABAN,SOLUONG,NAMXUATBAN) VALUES(6789,'TEOEM',123,987,'TRINHCONGSON','VECHUYENHAI',15,700,100,'12-25-2001'),
                                                                                                                      (6788,'DOEMON',124,986,'TRINHCONGAN','VECHUYENTRANH',10,200,50,'7-1-2009'),
                                                                                                                      (6787,'LIENMINH',125,985,'TRINHCONGTU','VETIRNGANH',15,300,1000,'8-12-2010'),
                                                                                                                      (6786,'KINHTE',126,984,'TRINHCONGSON','VETIENGANH',15,500,100,'9-12-2003')




SELECT NAMXUATBAN FROM SACH
WHERE NAMXUATBAN>'2008'

-- TOP3 SACH GIA BAN LON NHAT --
SELECT TOP 3
NAMESACH, GIABAN
FROM SACH ORDER BY GIABAN DESC

--NHững sách nội dung chứa chữ y--

SELECT * 
FROM SACH
WHERE NOIDUNGTOMTAT LIKE '%Y%'


--những sách nội dung chứa chữ e sắp xếp theo thứ tự từ lớn đến bé--
SELECT *
FROM SACH 
WHERE NAMESACH LIKE '%E%'
ORDER BY GIABAN DESC



-- liệt kê những sách của nhà xuất bản minh hoang--

SELECT SACH.IDNHAXUATBAN, SACH.NAMESACH, NHAXUATBAN.NAMENHAXUATBAN
FROM SACH
INNER JOIN NHAXUATBAN
ON SACH.IDNHAXUATBAN = NHAXUATBAN.IDNHAXUATBAN
WHERE NAMENHAXUATBAN='MINHHOANG'

--lấy thông tin chi tiết về nhà xuất bản của quyển sách kinh tế --
SELECT SACH.IDNHAXUATBAN, SACH.NAMESACH, NHAXUATBAN.NAMENHAXUATBAN, NHAXUATBAN.DIACHINHASANXUAT
FROM SACH
INNER JOIN NHAXUATBAN
ON SACH.IDNHAXUATBAN = NHAXUATBAN.IDNHAXUATBAN
WHERE NAMESACH='KINHTE'

--Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản,Loại sách--
SELECT SACH.IDSACH, SACH.NAMESACH, SACH.NAMXUATBAN, NHAXUATBAN.NAMENHAXUATBAN, LOAISACH.NAMELOAISACH
FROM SACH
INNER JOIN NHAXUATBAN
ON SACH.IDNHAXUATBAN = NHAXUATBAN.IDNHAXUATBAN
INNER JOIN LOAISACH ON LOAISACH.IDLOAISACH=SACH.IDLOAISACH

--Tìm cuốn sách có giá bán đắt nhất--

SELECT MAX(GIABAN)  FROM SACH

SELECT TOP 1
NAMESACH, GIABAN
FROM SACH ORDER BY GIABAN DESC

--Tìm cuốn sách có số lượng lớn nhất trong kho--
SELECT NAMESACH,MAX(SOLUONG)  FROM SACH

SELECT TOP 1
NAMESACH, SOLUONG
FROM SACH ORDER BY SOLUONG DESC

--Tìm các cuốn sách của tác giả TRINH CONG SƠN--

SELECT NAMESACH FROM SACH
WHERE TENTACGIA='TRINHCONGSON'

--Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước--


SELECT * FROM SACH 

ALTER TABLE SACH  
ADD GIAMGIA INT
UPDATE SACH
SET GIAMGIA = GIABAN - 10
WHERE NAMXUATBAN < '2008' 

--THONG KE SO DAU SACH CỦA MOI NXB--
SELECT NAMENHAXUATBAN, COUNT(IDSACH) AS "So luong"
  FROM SACH
INNER JOIN NHAXUATBAN
ON SACH.IDNHAXUATBAN = NHAXUATBAN.IDNHAXUATBAN
  GROUP BY NAMENHAXUATBAN;

--Thống kê số đầu sách của mỗi loại sách--
SELECT NAMELOAISACH, COUNT(IDSACH) AS "So luong"
  FROM SACH
INNER JOIN LOAISACH
ON SACH.IDLOAISACH = LOAISACH.IDLOAISACH
  GROUP BY NAMELOAISACH;

--Đặt chỉ mục (Index) cho trường tên sách--
CREATE INDEX MQK
ON SACH (NAMESACH);

--Viết view lấy thông tin gồm: Mã sách, tên sách, tác giả, nhà xb và giá bán--

CREATE VIEW HMM AS
SELECT SACH.IDSACH, SACH.NAMESACH, SACH.TENTACGIA, NHAXUATBAN.NAMENHAXUATBAN, SACH.GIABAN
FROM SACH
INNER JOIN NHAXUATBAN ON SACH.IDNHAXUATBAN=NHAXUATBAN.IDNHAXUATBAN


--Viết Store Procedure:SP_Them_Sach: thêm mới một cuốn sách--
CREATE PROCEDURE SP_Them_Sach_INSERT
@MC INT , @NS VARCHAR(50), @IDNXB INT ,@IDLS INT,@TG VARCHAR(50),@NDS VARCHAR(1000),@LXB INT, @GB MONEY, @SL INT, @NXB DATETIME, @GG INT
AS
INSERT INTO SACH (IDSACH,NAMESACH,IDNHAXUATBAN,IDLOAISACH,TENTACGIA,NOIDUNGTOMTAT,LANXUATBAN,GIABAN,SOLUONG,NAMXUATBAN,GIAMGIA) VALUES(@MC,@NS,@IDNXB,@IDLS,@TG,@NDS,@LXB,@GB,@SL,@NXB,@GG)

EXECUTE SP_Them_Sach_INSERT 6781,'TEOE',123,987,'TRINHCONGSON','VECHUYENHAI',15,700,100,'12-25-2001',690


--TIM SACH THEO TU KHOA

CREATE PROCEDURE SP_Tim_Sach1
AS
SELECT * FROM SACH
WHERE NAMESACH LIKE '%H%'


--LIET KE CAC CUON SACH THEO MA CHUYEN MUC--
CREATE PROCEDURE SP_Sach_ChuyenMuc2
@MLS1 INT
AS
SELECT SACH.NAMESACH,LOAISACH.NAMELOAISACH,LOAISACH.IDLOAISACH
FROM SACH
INNER JOIN LOAISACH ON LOAISACH.IDLOAISACH =SACH.IDLOAISACH
WHERE SACH.IDLOAISACH = @MLS1
EXECUTE SP_Sach_ChuyenMuc2 985

GO

--Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho (số lượng > 0)--


CREATE TRIGGER XOA8
ON SACH
FOR DELETE AS 
BEGIN      
     IF	exists (select *FROM deleted SACH  WHERE SACH.SOLUONG>0)
     BEGIN
         print'Cannot xoa';
         ROLLBACK TRANSACTION;
     END
END
GO
delete from SACH where SOLUONG>0
GO

--Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên MUC NAY --

CREATE TRIGGER XOA9
ON SACH
FOR DELETE 
AS
BEGIN 
 IF exists (SELECT COUNT(SACH.IDLOAISACH) FROM deleted,SACH INNER JOIN LOAISACH ON SACH.IDLOAISACH = LOAISACH.IDLOAISACH WHERE SACH.SOLUONG> 0 )
  
    print'Cannot xoa';
         ROLLBACK TRANSACTION;
    
  END


    DELETE FROM SACH  WHERE IDLOAISACH= 984







SELECT * FROM SACH


