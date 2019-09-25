use Northwind
--JOIN ORNEKLERI--
--1.	Tedarikçisinin posta kodu '33007' olan deniz ürünleri 'Seafood' hariç siparisler ile ilgilenmis çalgsanlargmgn ad, soyad, ev telefonu alanlargng getir
select distinct
	 e.FirstName,
	 e.LastName , 
	 e.HomePhone
from Employees e
	join Orders o on o.EmployeeId=e.EmployeeID
	join [Order Details] od on o.OrderID=o.OrderID
	join Products p on p.ProductID=od.ProductID
	join Categories c on c.CategoryID=p.CategoryID
	join Suppliers s on s.SupplierID=p.SupplierID
where s.PostalCode='33007' and c.CategoryName!='Seafood'

--2.	Region'u 'SP' olan müsterilerimin, Federal Shipping ile tasgnan ürünlerini kategorilerine göre sgralanmgs halini listeleyiniz.
	select distinct p.ProductName,ca.CategoryName from Customers c 
	join Orders o on c.CustomerID=o.CustomerID
	join Shippers s on s.ShipperID=o.ShipVia
	join [Order Details] od on od.OrderID=o.OrderID
	join Products p on p.ProductID=od.ProductID
	join Categories ca on ca.categoryID=p.CategoryID
	where Region='SP' and
	s.CompanyName='Federal Shipping'
	order by ca.CategoryName

--3.	Tedarik sehri Londra olan, kargo sirketinin 4. harfi e olan stogumda bulunan siparislerim nelerdir?
	select o.orderID from Orders o 
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	where ShipCity='London' and
	ShipName like '___e%' and
	p.UnitsInStock>0

--4.	Stogumdaki miktar 0-20 arasgnda ise %20 zam 20-40 arasgnda ise ayng fiyat 40-90 arasgnda ise yüzde 10 indirim 90 üzerinde ise yüzde 40 indirim yapsgn
	select ProductName,UnitsinStock,UnitPrice,
	(	case 
		when UnitsInStock between 0 and 20 then UnitPrice*1.2
		when UnitsInStock between 20 and 40 then UnitPrice
		when UnitsInStock between 40 and 90 then UnitPrice*0.9
		when UnitsInStock > 90 then UnitPrice*0.6
		end) YeniFiyat
	 from Products p

--5.	Stokta bulunan indirimsiz ürünleri adetleriyle birlikte listeleyiniz.
	select p.ProductName,p.UnitsinStock from [Order Details] od
	join Products p on p.ProductID=od.ProductID
	where Discount=0 and
	p.UnitsInStock>0

--6.	sehri Tacoma olan çalgsanlargmgn aldggg siparislerin listesi?
	select o.OrderID  from Employees e 
	join Orders o on o.EmployeeID=e.EmployeeID
	where e.City='Tacoma'

--7.	Stogu 20den fazla olan siparislerimin hangi kargo sirketleriyle teslim edildigini listeleyiniz
	select distinct s.CompanyName from [Order Details] od 
	join Orders o on o.OrderID=od.OrderID
	join Shippers s on s.ShipperID=o.ShipVia
	where Quantity>20

--8.	Stokta 40tan fazla olan ürünlerimin adlari ve kategori isimleri?
	select p.productname , c.CategoryName from products p 
	left join Categories c on p.categoryID=c.categoryID
	where p.UnitsInStock>40

	select p.productname , c.CategoryName from products p 
	inner join Categories c on p.categoryID=c.categoryID
	where p.UnitsInStock>40


--9.	Stokta olmayan ürünlerimin ve devamliligi olmayanlarin tedarikçilerinin telefon numaralarini listeleyiniz
	select s.Phone from Products p
	join Suppliers s on s.SupplierID=p.SupplierID
	where UnitsInStock=0 and Discontinued=1

--10.   Tasinan siparislerin hangi kargo firmasi ile tasindigini kargo firmasinin ismi ile belirtiniz.
	Select o.OrderID,s.CompanyName from Orders o
	join Shippers s on s.ShipperID=o.ShipVia 

--11.   Hiç satis yapilmamis müsterilerin isimlerini ve telefonlarini listeleyiniz.
	select distinct c.CompanyName,c.Phone from Customers c 
	left join Orders o on c.CustomerID=o.CustomerID
	where OrderDate is null

--12.   Indirimli gönderdigim siparislerdeki ürün adlarını, birim fiyatını ve indirim tutarını gösterin
	select p.ProductID,p.UnitPrice, p.UnitPrice*od.Discount as İndirimTutari from [Order Details] od
	left join Products p on od.ProductID=p.ProductID
	where Discount!=0

--13.   Amerikali toptancilardan alinmis olan urunleri gosteriniz...
	select p.ProductID,p.ProductName from products p 
	join Suppliers s on p.SupplierID=s.SupplierID
	where s.Country='USA'

--14.   Speedy Express ile tasinmis olan siparisleri gosteriniz...
	select*from orders o 
	join Shippers s on o.ShipVia=s.ShipperID
	where s.CompanyName='Speedy Express'

--15.   Federal Shipping ile tasinmis ve Nancy'nin almis oldugu siparisleri gosteriniz...
	select*from Orders o 
	join Shippers s on o.ShipVia=s.ShipperID
	join Employees e on o.EmployeeID=e.EmployeeID
	where s.CompanyName='Federal Shipping' and
	e.FirstName='Nancy'
	

--16.   Web sayfasi olan tedarikçilerimden hangi ürünleri tedarik ediyorum?
	select p.ProductID,p.ProductName from Suppliers s 
	left join Products p on s.SupplierID=p.SupplierID
	where s.HomePage is not null 

--17.   Hangi çalisanim hangi çalisanima rapor veriyor? 
	select calisan.FirstName Calisan,
		mudur.FirstName Mudur
	from Employees calisan
	join Employees mudur on calisan.ReportsTo=mudur.EmployeeID

--18.   Dogu konumundaki bölgeleri listeleyin
		select  * from Territories t
		join Region r on t.RegionID=r.RegionID
		where r.RegionDescription='Eastern' 

--20.   Konumu 'Eastern' olan müsterilerimin, federal shipping ile tasgnan ürünlerini
--kategorilere göre sıralayınız.
	select distinct p.ProductID,p.ProductName,ca.CategoryName from Territories t
		join Region r on t.RegionID=r.RegionID
	    join EmployeeTerritories et on et.TerritoryID=t.TerritoryID
	    join Employees e on et.EmployeeID=e.EmployeeID
	    join Orders o on o.EmployeeID=e.EmployeeID
		join Customers c on c.CustomerID=o.CustomerID
	    join Shippers s on s.ShipperID=o.ShipVia
	    join  [Order Details] od on od.OrderID=o.OrderID
	    join Products p on od.ProductID=p.ProductID
		join Categories ca on ca.CategoryID=p.CategoryID
		where r.RegionDescription='Eastern' and
		s.CompanyName='Federal Shipping'
		order by ca.CategoryName
		
--21.   Tedarik sehri londra olan, kargo sirketinin  4. harfi e olan stogumda bulunan ve birim fiyatg 3 - 100 arasgnda olan siparislerim nelerdir? 

	select distinct o.OrderID from Orders o 
	join Shippers s on s.ShipperID=o.ShipVia
	join [Order Details] od on od.OrderID=o.OrderID
	join Products p on p.ProductID=od.ProductID
	join Suppliers su on su.SupplierID=p.SupplierID
	where su.City='London' and s.CompanyName like '___e%' and p.UnitsInStock>0 and p.UnitPrice between 3 and 100


--22.   sehri tacoma olan çalisanlarimin aldigi siparislerin listesi?
		select  o.OrderID from Employees e
		join Orders o on o.EmployeeID=e.EmployeeID
		where e.City='Tacoma'

--23.   Satisi durdurulmus ve ayni zamanda stogu kalmamis ürünlerimin tedarikçilerinin isimlerini ve telefon numaralarini listeleyiniz.
		select s.CompanyName,s.Phone from  Products p 
		join Suppliers s on p.SupplierID=s.SupplierID
		where p.Discontinued=1 and
		p.UnitsInStock = 0

--24.   New York sehrinden sorumlu çalisan(lar)im kim?
		select distinct e.EmployeeID from Territories t
		join EmployeeTerritories et on et.TerritoryID=t.TerritoryID
		join Employees e on e.EmployeeID=et.EmployeeID
		where t.TerritoryDescription='new york'
		

--25.   1 Ocak 1998 tarihinden sonra siparis veren müsterilerimin isimlerini artan olarak siralayiniz.
		select distinct c.CompanyName from Orders o 
	    join Customers c on c.CustomerID=o.CustomerID
		where o.OrderDate>'1998-01-01'
		order by c.CompanyName

--26.	CHAI ürününü hangi müsterilere satmisim?
		select distinct c.CustomerID from [Order Details] od
		join Products p on p.ProductID=od.ProductID
		join Orders o on o.OrderID=od.OrderID
		join Customers c on c.CustomerID=o.CustomerID
		where p.ProductName='Chai'

--27.	10248 ID'li siparisimle hangi çalisanim ilgilenmistir?
		select e.EmployeeID from Orders o
		join Employees e on e.EmployeeID=o.EmployeeID
		where o.OrderID=10248

--28.   sisede satilan ürünlerimi siparis ile gönderdigim ülkeler hangileridir?
		select distinct o.ShipCountry from Products p 
		join [Order Details] od on p.ProductID=od.ProductID
		join Orders o on o.OrderID=od.OrderID
		where QuantityPerUnit like'%bottle%'


--29.	Agustos aygnda teslim edilen siparislerimdeki ürünlerden kategorisi içecekler olanlarin,
--ürün isimlerini, teslim tarihini ve hangi sehre teslim edildigini kargo ücretine göre ters sirali sekilde listeleyiniz.
		select p.ProductName,o.ShippedDate,o.ShipCity,o.Freight from Orders o
		join [Order Details] od on od.OrderID=o.OrderID
		join Products p on p.ProductID=od.ProductID
		join Categories c on p.CategoryID=c.CategoryID
		where datepart(month,o.ShippedDate)=8 and
		c.CategoryName='Beverages'
	    order by o.Freight desc

--30.	Speedy Express ile tasgnan tedarikçilerimden pazarlama müdürleriyle iletisime geçtigim,
--Steven Buchahan adlg çalgsangma rapor veren çalgsanlargmgn ilgilendigi,
--Amerika'ya gönderdigim siparislerimin ürünlerinin kategorileri nelerdir?


select c.CategoryName from Employees calisan
join Employees mudur on calisan.ReportsTo=mudur.EmployeeID
join Orders o on o.EmployeeID=calisan.EmployeeID--çalgsanlargn ilgilendigi
join Shippers s on s.ShipperID=o.ShipVia
join [Order Details] od on od.OrderID=o.OrderID
join Products p on p.ProductID=od.ProductID
join Suppliers su on p.SupplierID=su.SupplierID
join Categories c on p.CategoryID=c.CategoryID
where 
mudur.FirstName='Steven' and 
mudur.LastName='Buchahan' and 
s.CompanyName='Speedy Express' and
su.ContactTitle ='Marketing Manager' and
o.ShipCountry='USA'


--31.	Meksikali müsterilerimden sirket sahibi ile iletisime geçtigim,
--kargo ücreti 30 dolargn altgnda olan siparislerle hangi çalisanlarim ilgilenmistir?
	select o.OrderID,e.EmployeeID from Customers c
	join Orders o on o.CustomerID=c.CustomerID
	join Employees e on e.EmployeeID=o.EmployeeID
	where c.Country='Mexico'and
	c.ContactTitle='owner' and
	o.Freight<30

--32.	Seafood ürünlerinden siparis gönderdigim müsterilerim kimlerdir?
	select distinct cu.CustomerID from Categories c
	join Products p on p.CategoryID=c.CategoryID
	join [Order Details] od on od.ProductID=p.ProductID
	join Orders o on o.OrderID=od.OrderID
	join Customers cu on cu.CustomerID=o.CustomerID
	where c.CategoryName='Seafood' and
	o.ShippedDate is not null
	
--33.	Doktora yapmamgs kadgn çalgsanlargmgn ilgilendigi siparislerin,
--gönderildigi müsterilerimden iletisime geçtigim kisilerin isimleri ve sehirleri nelerdir?
select distinct c.ContactName,c.City from Employees e
join Orders o on e.EmployeeID=o.EmployeeID
join Customers c on c.CustomerID=o.CustomerID
where e.TitleOfCourtesy in ('Ms.','Mrs') and e.TitleOfCourtesy!='Dr.'

--------------Union - Union All
--34.	Hangi sirketlerle çalisiyorum => hem suppliers hem customers hem de shippers

select CompanyName as Sirketler from Suppliers union
select CompanyName as Sirketler from Customers union
select CompanyName as Sirketler from Shippers

--35.	Hangi insanlarla çalisiyorum => hem customers hem suppliers hem Employees
select contactname from Customers union
select contactname from Suppliers union 
select CONCAT(firstname,' ',LastName) from Employees

--------------Case-When
--36.	içecekler kategorisinden siparis veren müsterilerimin ürün adi sirket isimlerini 
--tedarikçi sirket ismini kargo ücretini ve eger kargo ücreti 20 den az ise 'ucuz',
--20-40 aralgggnda ise 'orta', 40 dan büyük ise 'pahali' yazacak sekilde listeleyiniz. 
--(kolon isimleri müsteri sirketi, ürün adg, tedarikçinin sirketi, kargo ücreti, ücret degerlendirmesi)	
	select cu.CompanyName,p.ProductName,s.CompanyName,o.Freight,
	( 
	  case 
	  when o.Freight<20 then 'Ucuz'
	   when o.Freight between 20 and 40 then 'Orta'
	   when o.Freight>40 then 'Pahali'
	  end
	) Degerlendirme
	
	from Categories c
	join Products p on p.CategoryID=c.CategoryID
	join [Order Details] od on od.ProductID=p.ProductID
	join Orders o on o.OrderID=od.OrderID
	join Customers cu on cu.CustomerID=o.CustomerID
	join Suppliers s on s.SupplierID=p.SupplierID
	where c.CategoryName='Beverages'
