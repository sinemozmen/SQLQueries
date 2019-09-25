use Northwind
-------------------DDL---------------------------
--Create , alter, drop,truncate
--Objeler için yazýlacak 

create objeTipi objeIsmi
alter objeTipi objeIsmi ( add,remove (obje olmayan alt ogeler icin),drop,modify,set) yapilacakIslem

-----------------------DB DDL -------------------

create database AlafortanfoniDB-- default ayarlar ile bir DB olusturur.

create database AlafortanfoniDB2
on --mmf dosyasi icin ozellikler gir
(
Name = 'AlafDB',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\AlafDB.mdf',
Size=7MB,
MaxSize=10GB,
FileGrowth=14MB
)
log on 
(
Name = 'AlafLogDB',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\AlafLogDB.ldf',
Size=7MB,
MaxSize=10GB,
FileGrowth=14MB

)

alter database AlafortanfoniDB2 set COMPATIBILITY_LEVEL=100
alter database AlafortanfoniDB2 remove file AlafLogDB
drop database AlafortanfoniDB2
--trancate database için kullanýlmaz.

------------------Table DDL----------------------

use AlafortanfoniDB


create table Bolum 
(
	ID int identity(1,1) not null,
	BolumAdi varchar(30) not null,

)

alter table Bolum add Constraint PrimaryKey_Bolum_ID primary key (ID)

create table Ogrenci
(
	ID int identity(1,1) not null,-- sadece null yazilirsa allow null anlamýna gelir.
	Ad varchar(20) not null,
	Soyad varchar(20) not null,
	Telefon char(10) null)
	alter table Ogrenci add BolumID int foreign key references Bolum(ID) default 1 
	alter table Ogrenci add MezuniyetNotu tinyint check(MezuniyetNotu>=0 and MezuniyetNotu<=100)
	alter table Ogrenci add Constraint Unique_Ogrenci_Telefon unique (Telefon)
	alter table Ogrenci	add Constraint PrimaryKey_Ogrenci_Telefon primary key (ID)
	
	alter table Ogrenci add TcKimlikNo char(11)
	alter table Ogrenci add constraint Unique_Ogrenci_TCKN unique(TcKimlikNo)
	--MezuniyetNotu sutununu silebilmek icin once iliskili olan objeler silinir .

	alter table Ogrenci drop Constraint CK__Ogrenci__Mezuniy__3D5E1FD2
	alter table Ogrenci drop column MezuniyetNotu
	alter table Ogrenci drop column BolumID


	--Scriptte asagidaki gibidir:
	--CREATE TABLE [dbo].[Bolum](
	--[ID] [int] IDENTITY(1,1) NOT NULL,
	--[BolumAdi] [varchar](30) NOT NULL,
	--CONSTRAINT [PrimaryKey_Bolum_ID] PRIMARY KEY CLUSTERED on [PRIMARY]

	--Product ,Category ve Suppliers tablolarýný içeren yeni bir DB oluþturunuz.
	create database UrunlerDB
	use UrunlerDB
	create table Product
	(
		ID int identity(1,1) not null,
		ProductName varchar(30) not null,
	
	)
	alter table Product add Constraint PrimaryKey_Product_ID primary key (ID)
	alter table Product add CategoryID int foreign key references Category(ID) default 1 
	--insert into  Northwind..Products(ProductID,ProductName)
	--select ProductID,ProductName from Northwind..Products

	create table Category
	(
		ID int identity(1,1) not null,
		CategoryName varchar(30) not null,
	)
		alter table Category add Constraint PrimaryKey_Category_ID primary key (ID)
		
	create table Suppliers
	(
		ID int identity(1,1) not null,
		SupplierName varchar(30) not null,
	)
		alter table Suppliers add Constraint PrimaryKey_Suppliers_ID primary key (ID)
		alter table Suppliers add ProductID int foreign key references Product(ID) default 1 

--Veri kopyalama.Alttaki sorgu ile kolonlarýn uymasý gerekiyor.
insert into AlafortanfoniDB..Products 
select*from Northwind..Products p 

--sadece productname ve discontinued alýnacak ise 
insert into AlafortanfoniDB..Products (ProductName,Discontinued)
select ProductName,Discontinued from Northwind..Products

--sadece productname ve discontinued farklý serverdan alýnacak ise 
insert into AlafortanfoniDB..Products (ProductName,Discontinued)
select ProductName,Discontinued from [176.43.149.228].Northwind..Products

--herhangi bir sorgu kalýbýnýn sonucu bir update datasý olarak kullanýlabilir.

update AlafortanfoniDB..Products set productname=uzakproduct.Productname
where uzakproduct.categoryID>10

--data transferi ve tablo kopyalama.. Products2 tablosu olusturur ve icine secilen kolonlara ait datalari yazar

select ProductID,ProductName,Discontinued into AlafortanfoniDB..Products2  from AlafortanfoniDB..Products
select*from Products2

---------------------------Trigger (Event)--------------------
--tabloya insert,update yapildiginda,sunu yap gibi 
create table Islemler
(
ID int identity(1,1) not null,
IslemTuru varchar(10) not null,
constraint pk_Islemler primary key (ID)
)
insert into Islemler values('Insert')
insert into Islemler values('Update')
insert into Islemler values('Delete')

create table LogTable
(
ID int identity(1,1) not null,
TabloAdi varchar(Max) not null,
	EskiDeger varchar(Max) not null,
	YeniDeger varchar(max) not null,
	YapilanIslem int not null foreign key references Islemler(ID),
	IslemTarihi DateTime not null
	--IslemYapan int not null foreign key references Users(ID)
)

ALTER TABLE LogTable
ALTER COLUMN EskiDeger  varchar(Max)  null ;
ALTER TABLE LogTable
ALTER COLUMN YeniDeger  varchar(Max)  null ;
--create trigger 
alter trigger Trigger_Insert
on Ogrenci for insert
as 
insert into LogTable(TabloAdi,YeniDeger,YapilanIslem,IslemTarihi)
values('Ogrenci',
(
select'ID='+CAST(ID as varchar(10))+
'Ad='+Ad+
',Soyad='+Soyad+
',Telefon='+Telefon+
',TCKimlikNo='+TcKimlikNo from inserted
),1, GetDate())--insert'in id'si 1 oldugu icin 1 yazildi.

insert into Ogrenci values('Osman','yazici','5059819044','11111111111')
select*from Ogrenci

alter trigger Trigger_Ogrenci_Delete
on Ogrenci for delete
as 
insert into LogTable(TabloAdi,EskiDeger,YapilanIslem,IslemTarihi)
values('Ogrenci',
(
select'ID='+CAST(ID as varchar(10))+
'Ad='+Ad+
',Soyad='+Soyad+
',Telefon='+Telefon+
',TCKimlikNo='+TcKimlikNo+
',IsDeleted='+IsDeleted from deleted
),3, GetDate())
delete from Ogrenci where Ad='Osman'


alter trigger Trigger_Ogrenci_Delete
on Ogrenci for update
as 
insert into LogTable(TabloAdi,EskiDeger,YeniDeger,YapilanIslem,IslemTarihi)
values('Ogrenci',
(
select'ID='+CAST(ID as varchar(10))+
'Ad='+Ad+
',Soyad='+Soyad+
',Telefon='+Telefon+
',TCKimlikNo='+TcKimlikNo+
',IsDeleted='+Cast(IsDeleted as varchar(10)) from deleted),
(select'ID='+CAST(ID as varchar(10))+
'Ad='+Ad+
',Soyad='+Soyad+
',Telefon='+Telefon+
',TCKimlikNo='+TcKimlikNo+
',IsDeleted='+Cast(IsDeleted as varchar(10)) from inserted
),2, GetDate())

insert into Ogrenci values ('Sinem','Ozmen','5333333333','11111111111')
update Ogrenci set Ad='Hulya' where TcKimlikNo='11111111111'
select*from Ogrenci
select*from LogTable

alter table Ogrenci add IsDeleted bit 

create trigger Trigger_Ogrenci_DeleteInsteadOf
on Ogrenci instead of Delete 
as
update Ogrenci set IsDeleted=1 where ID =(select ID from deleted )

delete from Ogrenci where ID = 3 
update Ogrenci set IsDeleted=0

-------------------------Northwind icin Sil Bastan---------------------
create table Islemler
(
ID int identity(1,1) not null,
IslemTuru varchar(10) not null,
constraint pk_Islemler primary key (ID)
)
insert into Islemler values('Insert')
insert into Islemler values('Update')
insert into Islemler values('Delete')

create table LogTable
(
ID int identity(1,1) not null,
TabloAdi varchar(Max) not null,
	EskiDeger varchar(Max) not null,
	YeniDeger varchar(max) not null,
	YapilanIslem int not null foreign key references Islemler(ID),
	IslemTarihi DateTime not null
	--IslemYapan int not null foreign key references Users(ID)
)
alter table LogTable alter column EskiDeger varchar(Max)  null
alter table LogTable alter column YeniDeger varchar(Max)  null

alter table Categories add IsDeleted bit 
update Categories set IsDeleted=0
alter table Categories alter column IsDeleted bit not null

alter trigger Trigger_Categories_Insert
on Categories for Insert
as
Insert into LogTable(TabloAdi,YeniDeger,YapilanIslem,IslemTarihi)
values
(
	'Categories',
	(select
		'CategoryID='+Cast(CategoryID as varchar(40))+
		',CategoryName='+CategoryName+
	---	',Description='+[Description]+
		--',Picture='+Cast(Picture as varchar(max))+
		',IsDeleted='+Cast(IsDeleted as varchar(max))
		from inserted),--tek string haline getirip Yeni Deger hanesine yazacak
		1,
		GETDATE()
)

select*from Categories 

insert into Categories (CategoryName,IsDeleted) values ('Alafortanfoni',0)
select*from LogTable

--update icin:---

create trigger Trigger_Categories_Update
on Categories for update
as 
insert into LogTable(TabloAdi,EskiDeger,YeniDeger,YapilanIslem,IslemTarihi)
values
(	'Categories',
	(select
		'CategoryID='+Cast(CategoryID as varchar(40))+
		',CategoryName='+CategoryName+
		',IsDeleted='+Cast(IsDeleted as varchar(10)) from deleted),
	(select
		'CategoryID='+Cast(CategoryID as varchar(40))+
		',CategoryName='+CategoryName+
	 ',IsDeleted='+Cast(IsDeleted as varchar(10)) from inserted) 
,2, GetDate())

select*from Categories
update Categories set CategoryName='HerhangiBirSey' where CategoryID=1
select*from LogTable

--Delete instead of 

Create trigger Trigger_Categories_DeleteInsteadOf
on Categories instead of Delete
as 
update Categories set IsDeleted=1 where CategoryID=(select CategoryID from deleted)

delete from Categories where CategoryID=9 --calisacak ama silmeyecek 
--Asagidaki kod calisinca northwind tablosundan artýk herhangi bir table drop edilemez: 
create Trigger Trigger_Northwind_NoTableDrop
on database for Drop_Table
as
rollback
raiserror('Tablo silme islemi yapilamaz',16,1)

Create table Deneme
(
ID int
)
drop table Deneme
--yeniden silme isleminin yapilabilmesi icin trigger disable edilebilir veya trigger objesi silinebilir.
disable trigger Trigger_Northwind_NoTableDrop on database 






























 

































