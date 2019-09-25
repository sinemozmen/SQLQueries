use Northwind
--Comment line
/* 
Comment Paragraph
*/

----T-SQL--------
--DML
--DDL
--TCL

--DML
--CRUD
--Select
--Insert
--Update
--Delete

-------Select-----
--Veriyi Result ekranina tasir.
--Sorgu sonucu olusan datanin atanmasinda kullanilir.

Select 5
Select 5+5

--alias
select 5 as Sonuc
select 5+5 Sonuc

select 'Alafortanfoni' Metin

select 'Sinem'+' '+'�zmen' AdSoyad
select 'Sinem'+' '+'�zmen' [Ad Soyad]

--Result ekrani CTRL+R

--select 'Sinem'+5 hata verir.Tipler arasinda convert ya da cast s�reci isletilmeli

--Cast - Convert
select 'Osman' + Cast(5 as varchar(5))
select 'Osman'+Convert(varchar(1),5)

select 'Osman' + Cast(5 as varchar(25))+'Alafortanfoni'
select 'Osman' + Cast(5 as char(25))+'Alafortanfoni'

--Degisken Deklerasyonu
--declare @degiskenAdi as degiskenTipi

declare @Sayi as int 
set @Sayi=5--sorgu i�inde kullanilmaz ilk deger atamasi olarak kullanilir
select @Sayi=6--sorguyla beraber atama yapmak i�in kullanilir.

--obje �zerinden data okuma
--from 
--select kolonAdi1,kolonAdi2,..... from DatabaseAdi.SchemaAdi.ObjeAdi
--select kolonAdi1...from TabloAdi
select ProductName from Northwind.dbo.Products
select ProductName from Northwind..Products--databasein altindaki t�m semalarda arar Products'i arar.

use Northwind
select ProductName from Products
select ProductName,UnitPrice from Products
select*from Products
select*,UnitPrice from Products
select*,UnitPrice*2 IkiKatFiyat from Products
select*,'Alafortanfoni' from Products

--where
--select...from ... where sartlar 
--<,>,!=,<>,<=,>=,=,between
--and, or 
--+,-,/,*,%,

-- stogu 100 den az olan �r�nleri listeleyiniz.
Select*from Products
Select*from Products where UnitsInStock<100

-- stogu 20 ile 40 arasinda olan �r�nleri listeleyiniz
select*from Products where UnitsInStock>=20 and UnitsInStock<=40
select*from Products where UnitsInStock between 20 and 40 

select*from Products where 5>4--s�rekli true verecek
--Id'si 10 olan �r�n hangisidir 
select*from Products where ProductID=10

--Id'si 10,5,3,25,30,50,23,45 olan �r�nleri listeleyiniz.

--select*from Products where ProductID=10 or ProductID=5 
select*from Products where ProductID in (10,5,3,25,30,50,23,45)

--Id'si 10,5,3,25,30,50,23,45 olmaan �r�nleri listeleyiniz.
--not
select*from Products where ProductID not in (10,5,3,25,30,50,23,45)

--Kargolanmamis siparislerin numalarini listeleyiniz.
--select*from Orders where ShippedDate=null seklinde yazilmaz.
select*from Orders where ShippedDate is null

--Kargolanmis siparislerin numalarini listeleyiniz
select*from Orders where ShippedDate is  not null

--Adi Nancy olan �alisanin bilgilerini listeleyiniz.
select*from Employees where FirstName='Nancy'

--like
--% : bos ya da herhangi bir karakter dizisi

--Adi North olan m�steri bilgilerini listeleyiniz.
select*from Customers where CompanyName like '%NoRtH%'

--Firma ismi A harfi ile baslayan m�sterileri listeleyiniz.
select*from customers where CompanyName like'A%'

--Firma ismi A harfi ile biten m�sterileri listeleyiniz.
select*from customers where CompanyName like'%A'

--Firma isimleri a harfi ile baslamayan m�sterileri listeleyiniz.
select*from customers where CompanyName not like'A%'

--_ :tek karakter yerine ge�er.Tek karakter olmasi zorunludur.

--Firma isimlerinde 3.Harfi e olan m�sterileri listeleyiniz.

select*from Customers where CompanyName like '__e%'

--Firma isimlerinde 3.Harfi e ya da a ya da r ya da g ya da t olan m�sterileri listeleyiniz.

--select*from Customers where CompanyName like '__e%'or CompanyName like '__a%'...

--[xyz] : i�indeki karakterlerden herhangi biri 
select*from Customers where CompanyName like '__[eargt]%'

--[^xyz] : i�indeki karakterlerden herhangi biri degil 
--Firma isimlerinde 3.Harfi e ya da a ya da r ya da g ya da t olan,5. harfi b,u,i olmayan m�sterileri listeleyiniz.
select*from Customers where CompanyName like '__[eargt]_[^bui]%'

--[a-d] : i�indeki araliktaki t�m harflerden biri 
--[^a-d] : i�indeki araliktaki harflerden biri degil

--a'dan f'ye kadar harfler ile baslayan �r�nleri listeleyiniz.
select*from Products where ProductName like '[a-f]%'

--Tarih s�re�leri 
--'2019-08-21' Tarih yazim sekli
--'2019' 01.01.2019'a gider
--'2019-08-21 12:37:00'

--GetDate() == DateTime.Now
select GETDATE()

--1996'da alinmis siparisleri listeleyiniz.
select*from Orders WHERE OrderDate between '1996' and '1996-12-31 23:59:59'

--DatePart(secici,tarih)
select*from Orders WHERE DatePart(YEAR,OrderDate)=1996
select*from Orders where Year(OrderDate)=1996

--DateDiff(secici,baslangicTarih,bitisTarih)
--�alisanlarimiz ka� yasinda ise girmisler
select FirstName,LastName, DATEDIFF(year,BirthDate,HireDate) IseBaslamaYasi
 from Employees 

--Ka� g�nd�r �greniyorsunuz ?
select DATEDIFF(day,'2019-06-26',GETDATE()) KursGunler

--Ka� yasindasin ?
select DATEDIFF(year,'1994-03-12',GETDATE())  YAS

--en pahali �r�n ka� dolar ? 
select max(unitprice) from Products

--Hangi �lkelere satis yapiyorum?Ka� �lkeye satis yapiyorum?
select distinct Country from Customers--distinc tekrarlari almaz, count'tan daha dogru sonu� verir.
select count(Country) from Customers 

select count(Fax),count(CustomerID) from Customers
--count null degerleri saymaz...
select count(*) from Customers--satirlari sayar

--database'de kayitli ilk 3 �alisanimi listeleyiniz.
select top 3 * from Employees

-----------------ORDER BY -------------------
--order by kolonAdi/alias ile verilen kolon adi asc,desc
--sorgu �alistiktan sonra olusan result siralanir

--�r�nleri fitayina g�re pahalidan ucuza siralayiniz.
select*from Products order by UnitPrice desc

--�r�nleri fitayina g�re ucuzdan pahaliya siralayiniz.
select UnitPrice UrunFiyati from Products order by UrunFiyati asc

--En son ise giren eleman kimdir ? 
select top 1 *from Employees order by HireDate desc

--En pahali kargoya sahip siparis ? 
select top 1 *from Orders order by Freight desc

--LONDON'daki m�sterilerimden isim siralamasina g�re ilk 3 tanesini listeleyiniz
select top 3*from Customers where City='london' order by CompanyName 








 

































