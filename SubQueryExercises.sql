use Northwind
------------------------------------SubQuery Örnekleri-------------------------
--1- Chai ürününden toplam 50 adetten fazla siparis vermis müsterilerimin listesi nedir.
	select c.CustomerID,c.CompanyName,sum(od.Quantity) from Customers c 
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	where p.ProductName='Chai'
	group by c.CustomerID
	having Sum(od.Quantity)>50

	--SubQuery ile 
select
    o.CustomerID,
	(select CompanyName from Customers where CustomerID=o.CustomerID) CompanyName ,
	sum(od.Quantity) SumQuantity
from Orders o 
join(select
	 orderID,Quantity 
	 from [Order Details] 
	 where ProductID=(select ProductID 
					from Products 
					where ProductName='Chai')) od 
	 on o.OrderID=od.OrderID
	 group by o.CustomerID
	having Sum(od.Quantity)>50

--2- Siparisler tablosunda 4 ten az kaydi olan firmalar
select c.CustomerID,c.CompanyName from Customers c 
join Orders o on c.CustomerID=o.CustomerID
group by c.CustomerID,c.CompanyName
having count(o.OrderID)<4

select 
	CustomerID,
	(select CompanyName from Customers where CustomerID=o.CustomerID) CompanyName
from Orders o
group by CustomerID
having count(OrderID)<4

--3- Müsterilerin ilk gerçeklestirdikleri siparis tarihleri
	select o.CustomerID,
	(select c.CompanyName from Customers c  where o.CustomerID=c.CustomerID) CompanyName,
	min(o.OrderDate) IlkSiparis from  Orders o
	group by o.CustomerID
	

--4- 10249 Id li siparisi hangi müsteri almistir.
	select o.CustomerID,(select c.CompanyName from Customers c where o.CustomerID=c.CustomerID)
	from Orders o where o.OrderID=10249
	
--5- Ortalama satis miktarinin üzerine çikan satislarim hangileridir.

	--HOCANIN COZUMU
	select*from
	(select orderID,sum(UnitPrice*Quantity*(1-Discount)) ToplamTutar from [Order Details] 
	group by OrderID) t2
	where ToplamTutar>
	(select avg(ToplamTutar) from
	(select od.orderID,sum(od.UnitPrice*od.Quantity*(1-od.Discount)) ToplamTutar from [Order Details] od
	group by od.OrderID) t1)--temp db daha hýzlý çalýþýr.

	--BENİM:
		select orderID,od.OrderID,sum(od.Quantity*od.UnitPrice*(1-od.Discount)),(select avg(Quantity*UnitPrice*(1-Discount)) from [Order Details]) AVG from  [Order Details] od 
		group by od.OrderID,(od.Quantity*od.UnitPrice*(1-od.Discount))
		having sum(od.Quantity*od.UnitPrice*(1-od.Discount))>(select avg(Quantity*UnitPrice*(1-Discount)) from [Order Details])

--6- Çalisanlarimdan çalisan yas ortalamasinin üzerinde olan çalisanlarimi listeleyiniz.
	select*from Employees where DATEDIFF(year,BirthDate,GetDate())>(select avg(DATEDIFF(year,BirthDate,GetDate())) from Employees)

--7- En pahali üründen daha yüksek kargo ücreti olan siparisleri listeleyiniz.
	select orderID from orders where Freight >(select max(UnitPrice)from products )

--?8- Ortalama ürün fiyati 40 tan büyük olan kategorileri listeleyiniz
	select CategoryName from Categories where CategoryID in ( select CategoryID from Products group by CategoryID having Avg(Unitprice)>40)

	--HOCANIN COZUMU
	select
	CategoryID,
	(select CategoryName from Categories where CategoryID=p.CategoryID) categoryName ,
	avg(UnitPrice) ortalamatutar
	from Products p 
	 group by CategoryID 
	 having Avg(Unitprice)>40

--9- 50 siparisten fazla satis yapmis çalisanlarimi listeleyiniz

	select o.EmployeeID,
	count(o.EmployeeID) SiparisAdedi ,
	(select e.FirstName from Employees e where o.EmployeeID=e.EmployeeID ) Ad, 
	(select e.LastName from Employees e where o.EmployeeID=e.EmployeeID ) Soyad
	from Orders o group by o.EmployeeID having count(o.EmployeeID) >50

--10- Kategori adinin ilk harfi B ile D arasinda olan fiyati 30 liradan fazla olan ürünler
	select*from Products p 
	where p.CategoryID in ( select c.CategoryID from Categories c where c.CategoryName like '[b-d]%') and 
	p.UnitPrice>30
	--Category tablosundan birden fazla sutun istenseydi table clause ile cozulmeliydi.



--11- Hangi musterilerimin verdigi siparis toplam tutari 10000 den fazladir.
	select distinct c.CustomerID,c.CompanyName from  Customers c 
	join Orders o on c.CustomerID=o.CustomerID
	where o.OrderID in ( select od.OrderID from [Order Details] od group by od.OrderID having sum(od.Quantity*od.UnitPrice*(1-od.Discount))>10000 )

	--HOCANIN COZUMU
	select distinct
	(select CompanyName from Customers where CustomerID=o.CustomerID) CompanyNAme
	from Orders o where orderID in (
									select orderID from [Order Details] 
									group by OrderID
									having sum(Quantity*UnitPrice*(1-Discount))>10000)


--12- 01.01.1996 -01.01.1997 tarihleri arasinda en fazla hangü ürün satilmistir.
	
	select top 1 p.ProductID ,p.ProductName, sum(od.Quantity) Adet from Products p 
	join [Order Details] od on od.ProductID=p.ProductID
	where od.OrderID in ( select o.OrderID from Orders o where o.OrderDate between '01.01.1996' and '01.01.1997')
	group by p.ProductID,p.ProductName
	order by sum(od.Quantity) desc

	--WITH TABLECLAUSE
	select top 1 
		ProductID,
		(select ProductName from Products p where p.ProductID=od.ProductID) ProductName,
		sum(Quantity) SatisAdedi
		from [order Details] od
		where od.OrderID in
						(select OrderID from Orders where OrderDate between '1996' and '1997') 
		group by ProductID
		order by SatisAdedi desc

	
--13- Ürünlerin kendi fiyatlarinin tüm ürünlerin ortalama fiyatlarina oranini bulunuz.
	select p.ProductID,p.ProductName,p.UnitPrice/(select avg(UnitPrice) from Products )  Oran  from Products p 
	--her satýrda select ile sorgu calistirmamasi icin 
	declare @ortalama as Decimal (6,4)
	select @ortalama = avg(UnitPrice) from Products
	select p.ProductID,p.ProductName,p.UnitPrice/(@ortalama)  Oran  from Products p 

