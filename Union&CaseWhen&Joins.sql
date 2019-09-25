use Northwind
-------------Union and Union All -----------------
select FirstName+' '+LastName FullName,Title from Employees union
select ContactName ,ContactTitle from Customers

--Region alani null olan sirketler
select CompanyName,ContactName,ContactTitle,[Address],City,Region,PostalCode,Country,Fax,null HomePage from Customers  where Region is null
union all
select CompanyName,ContactName,ContactTitle,[Address],City,Region,PostalCode,Country,Fax, HomePage from Suppliers
 where Region is null

 -------------------Case When---------------(if gibi)
 --1-Deger dinlemeli
 --Case degisken 
 --when deger1 then yapilacaklar1
 --when deger2 then yapilacaklar2
 --.....
 --else yapilacaklarN
 --end

 --Calisan tablomuzda calisanlarin isimlerini,soyisimlerini ve turkce unvanlarini listeleyiniz.
select 
	FirstName,
	LastName,
	--Title,
	(
		case Title
		when'Sales Representative' then 'Satis Temsilcisi'
		when 'Vice President,Sales' then 'Patron'
		when 'Sales Manager' then 'Satis Muduru'
		else 'Satis Koordinatöru'
		end
	) Unvan
from Employees

--2-Sartli Kullanim 
/*
case 
when kosul1 then yapilacaklar1
when kosul1 then yapilacaklar1
....
else yapilacaklarN
end
*/
--urunlerimden stogu;
--20'nin altinda olanlar icin 'Tedarikciden siparis et'
--100'un uzerinde olanlar icin 'Ýnidirim yap'
--digerleri icin 'null'
--uyarilarini veren sorgu

select
	ProductName,
	UnitsInStock,
	( 
	case
	when UnitsInStock<20 then 'Tedarikciden Siparis Et'
	when UnitsInStock>100 then 'Ýndirim yap' 	
	end
	) UyariMesaji
from Products

declare @Mesaj as varchar(50)
select @Mesaj=(Case 
	when UnitsInStock<20 
	then 'Ýndirim Yapilmali' 
	else 'Sorun Yok'
	end) 
 from Products where ProductID=40
 select @Mesaj

 --Fiyati 200 liranin ustunde olan urunler icin stok 3 un ustunde ise 
 --Fiyati 100 liranin ustunde olan urunler icin stok 6 in ustunde ise 
 --Fiyati 5 liranin ustunde olan urunler icin stok 10 un ustunde ise 
 --Fiyati 5 ve 5'in altinda olan urunler icin stok 10000000 un ustunde ise 
 --listele.

 select*
 from Products 
 where UnitsInStock>(case when UnitPrice>200 then 3
							when UnitPrice>100 then 6
							when UnitPrice>5 then 10
							else 10000000
							end)

---------------------------------JOIN-------------------------------
--Sadece iliskili tablolarda kullanilmaz...
--cross join
select*from Products,Categories
order by ProductID

select*from Products 
cross join Categories

--inner join
select*from Products,Categories 
where Products.CategoryID=Categories.CategoryID
order by ProductID

select*from Products p ,Categories c
where p.CategoryID=c.CategoryID
order by ProductID

select*from Products p 
inner join Categories c on p.CategoryID=c.CategoryID
order by ProductID

select*from Products p 
join Categories c on p.CategoryID=c.CategoryID
order by ProductID

select*from Products p 
join Categories c on p.CategoryID=c.CategoryID
join [Order Details] od on p.ProductID=od.ProductID
join Orders o on od.OrderID=o.OrderID
join Customers cu on o.CustomerID=cu.CustomerID

--left join
select*from Products p 
left join Categories c on p.CategoryID=c.CategoryID
order by ProductID

select*from Products p 
left join Categories c on p.CategoryID=c.CategoryID
left join [Order Details] od on p.ProductID=od.ProductID
left join Orders o on od.OrderID=o.OrderID
left join Customers cu on o.CustomerID=cu.CustomerID

--ustteki gibi bir durumda alttakine gitmek daha dogru olur
select*from Customers c 
join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on od.OrderID=o.OrderID
right join Products p on p.CategoryID=od.ProductID
left join Categories ca on p.CategoryID=ca.CategoryID

--right join

select*from Products p 
right join Categories c on p.CategoryID=c.CategoryID
order by ProductID

--full join
select*from Products p 
full join Categories c on p.CategoryID=c.CategoryID
order by ProductID

--self join 
--17.   Hangi çalýþaným hangi çalýþanýma rapor veriyor? 
select calisan.FirstName Calisan,
	mudur.FirstName Mudur
from Employees calisan
join Employees mudur on calisan.ReportsTo=mudur.EmployeeID

--Muduru olmayan calisanlar icin left join ile : 
select calisan.FirstName Calisan,
	mudur.FirstName Mudur
from Employees calisan
left join Employees mudur on calisan.ReportsTo=mudur.EmployeeID





















 

































