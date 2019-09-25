use Northwind

----------------AGGREGATE FUNCTIONS-----------------
/*
MAX
MIN
COUNT
SUM
AVG
*/

select max(UnitPrice) from Products
select min(UnitPrice) from Products
select avg(UnitPrice) from Products
select count(*) from Products
select count(ProductID) from Products
select count(Fax) from Customers
select SUM(UnitsInStock) as Stok from Products

--------Math Functions------------------

Select abs(-5)
select floor(3.001),FLOOR(7.999),FLOOR(-2.123)
select ceiling(3.001),ceiling(7.999),ceiling(-2.123)
select power(3,5)
select ROUND(5.2341,2)
select sqrt(16)
select ISNUMERIC('10'),ISNUMERIC('10A')

--UrUn fiyatlarini kusuratsiz olarak listeleyiniz.
select ProductName,FLOOR(UnitPrice) KusuratsizFiyat  from Products

--------String Functions------------------

select ASCII('a')
select char(98)
select charindex('i','Sinem')
select LEFT('SQL Server 2019',7)
select RIGHT('SQL Server 2019',7)
select LEN('SQL server 2019')
select Lower('SQL SERVER 2019')
select upper('sql server 2017')
select LTRIM('       sql server 2017')
select RTRIM('sql server 2017             ')
select NCHAR(12367)
select REPLACE('Wissen Akademie SQL Server 2017-Sinif 503','503','502')
select 'SQL Server' + SPACE(19)+'2019'
select SUBSTRING('SinemOzmen',6,Len('SinemOzmen'))

---------------------GROUP BY(Aitlik)-------------------------------
--kac adet urun satmisim 
select sum(quantity) from [Order Details]

--2017 cirom ne kadar ?
select Sum(od.UnitPrice*od.quantity*(1-od.Discount)) from [Order Details] od 
join orders o on o.OrderID=od.OrderID
where datepart(year,o.OrderDate)=1997

--Urunleri bana kazandirdigi miktarlar ile beraber listeleyiniz.

select p.ProductName , sum(od.unitprice*od.quantity*(1-od.discount)) UrununCirosu from Products p 
left join [Order Details] od on p.ProductID=od.ProductID
group by p.ProductID,p.ProductName

select p.ProductName,od.Quantity from Products p
join [Order Details] od on od.ProductID=p.ProductID
where od.Discount>0 and OrderID>11000
order by p.ProductName

 --Urunleri simdiye kadarki satis adetleriyle beraber listeleyiniz
 select p.ProductName , sum(quantity) as Adet from Products p
 left join [Order Details] od on p.ProductID=od.ProductID
 group by ProductName

--Ciroyu personel bazli gosteriniz.
select 
e.FirstName,
e.LastName,
sum(od.unitprice*od.quantity*(1-od.discount)) UrununCirosu 
from Employees e 
inner join Orders o on  e.EmployeeID =o.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
group by e.EmployeeID,e.FirstName,e.LastName,e.HomePhone

------------HAVING------------
--Grup by ile birlikte kullanilir.
--Ciroyu personel bazli gosteriniz.Ama cirosu 100000 ustunde olanlar gelsin

select 
e.FirstName,
e.LastName,
sum(od.unitprice*od.quantity*(1-od.discount)) UrununCirosu 
from Employees e 
inner join Orders o on  e.EmployeeID =o.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
group by e.EmployeeID,e.FirstName,e.LastName,e.HomePhone
having sum(od.unitprice*od.quantity*(1-od.discount)) >100000

--Id'si 5'ten buyuk olan calisanlarimin ulkeler bazinda 5 adetten fazla olan satis adeteri nelerdir?
--ulkelerin satis adetleri
--sadece personel id 5 uzerinde olacak
--ulkenin satisi 5 i gecmeli 

select o.EmployeeID,c.Country,sum(od.Quantity) Adet from Customers c 
join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on od.OrderID=o.OrderID
group by o.EmployeeID, c.Country
having o.EmployeeID>5 and sum(od.Quantity)>5

-- o.EmployeeID>5 group by yapilmadan da kisit olarak eklenebilir :
select o.EmployeeID,c.Country,sum(od.Quantity) Adet from Customers c 
join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on od.OrderID=o.OrderID
where o.EmployeeID>5 
group by o.EmployeeID, c.Country
having sum(od.Quantity)>5

--------------------------SubQuery--------------------------
--AMAÇ:Yeniden kullanma , Optimizasyon 

--Yazim yerine gore
--Select Clause
--Table Clause(from)
--Where Clause

--Bagimlilik turune gore 
--basic subQuery:disardaki sorgudan deger almaz
--correlated subquery:disardaki sorgudan deger alýr

--Nancy'nin aldigi siparisleri listeleyiniz.

select o.OrderID from  Orders o
join Employees e on e.EmployeeID=o.EmployeeID
where e.FirstName='Nancy'

select*from Employees
select*from Orders
--13*830 kez join þartý sorulur. 830 kez Nancy þartýný sorar.
select*from Orders where EmployeeID in 
(select EmployeeID from Employees where FirstName='Nancy')


select o.EmployeeID,c.Country,sum(od.Quantity) Adet from Customers c 
join(select OrderID,EmployeeID,CustomerID from Orders where EmployeeID>5) o on c.CustomerID=o.CustomerID/****/
join [Order Details] od on od.OrderID=o.OrderID
group by o.EmployeeID, c.Country
having sum(od.Quantity)>5

--Cirolarý personellere gore listeleyiniz.(AdSoyad,Ciro)
select
	o.EmployeeID,
	(select FirstName from Employees where EmployeeID=o.EmployeeID) Ad,
	(select  LastName from Employees where EmployeeID=o.EmployeeID) Soyad,
	sum(od.unitprice*od.quantity*(1-od.discount)) PersonelinCirosu
from Orders o 
	 join [Order Details] od on od.OrderID=o.OrderID
group by o.EmployeeID

---------------------Insert-Delete-Update----------------------------

Insert into Products values('Aladortanfoni',1,1,'Kelime Kelime',45,3,1,0,0)
Insert into Products values('Alaf',null,null,null,null,null,null,null,0)
Insert into Products(Discontinued,ProductName) values (0,'Fortan')

---------Update---------------------------
select*from Products where CategoryID=2
update Products set CategoryID=3 where CategoryID=2

update Products set ProductName='Þimdi ayvayý yedin.'

update Senetler set Tutar = 100

--Stogu 100'un uzerindeki urunlerde %10 indirim yap
--Stogu 50'nin uzerindekilerde %5 indirim yap
--stogu 20 nin altindakilerde %5 zam yap
--stogu 10 un altindakilerde %10 zam yap

select*from Products where UnitsInStock<20 or UnitsInStock>50
update Products set UnitPrice=(case
								when UnitsInStock>100 then UnitPrice*0.9
								when UnitsInStock>50 then UnitPrice*0.95
								when UnitsInStock>10 then UnitPrice*1.1
								when UnitsInStock<20 then UnitPrice*1.05
								end)
where UnitsInStock<20 or UnitsInStock>50

select*from Products where ProductID=1
update Products set UnitPrice=20,UnitsInStock=29,UnitsOnOrder=20 where ProductID=1

------------------TCL----------------------
begin tran 
commit tran
rollback tran 
------------------Delete---------
select*from Products where ProductID=80
Delete from Products where ProductID=80


























 

































