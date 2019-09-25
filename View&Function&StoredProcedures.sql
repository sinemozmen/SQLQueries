use Northwind
---------------------View---------------------------------------------
--Sorgunun saklanmis hali
--Raporlama icin surekli kullanilacak sorgularda
--Verinin guvenli paylasimi 
--Join yoksa insert icinde kullanilabilir
--Kolon tekrari yapilmamalidir
--Order by,top ile beraber kullanilmali
--icinde temp table kullanilmaz

create view VW_ViewIsmi
with encryption--(View i kitler.)
with schemabinding --(Sorgu icinde kullanilan tablolari korur.Schema yazilmasi zorunludur.
as
sorgu
with check option 


--Kargolanmamis urunler 

create view VW_KargoBekleyenler
with schemabinding 
as 
select OrderID,ShipCity,ShipCountry,ShipName from dbo.Orders
where ShippedDate is null 

select*from VM_KargoBekleyenler

--Uzak makinedeki server uzerinden personellerin cirolarinin cekilmesi.

create view VW_PersonelCirosu
with encryption
as 
select e.FirstName,e.LastName,sum(od.Quantity*od.UnitPrice*(1-od.Discount)) Ciro from Employees e
left join Orders o on e.EmployeeID=o.EmployeeID
join [Order Details] od on od.OrderID=o.OrderID
group by e.EmployeeID,e.FirstName,e.LastName

alter Schema Alafortanfoni Transfer dbo.VW_PersonelCirosu
--Kendi sistemine gectikten sonra ServerObjects->Linked Servives->New Linked Server-> Security -> erp olarak olusturulan 
--log in bilgilerini gir .

--Kendi sistemimizde 

select*from [176.43.149.228].Northwind.Alafortanfoni.VW_PersonelCirosu v
join Employees e on v.Ad=e.FirstName

--urunlerin cirosu 
create view Wissen_502.VW_UrunCirosu 
as
select 
	p.ProductName,
	sum(od.Quantity*od.UnitPrice*(1-od.Discount)) Ciro 
from Products p 
join [Order Details] od on p.ProductID=od.ProductID
group by p.ProductID,p.ProductName

--Kargolanmasi gecikmis siparislerin kac gün geciktikleri ile beraber listesi
create view VW_TeslimatiGecikmisler2
with schemabinding
as
select OrderID,
(case
 when ShippedDate is not null then datediff ( day, RequiredDate,ShippedDate)
 else  datediff ( day, RequiredDate,GetDate())
 end)Gecikme
 from dbo.Orders --schemabinding yapildigi icin schema(dbo) eklendi.
 where RequiredDate<ShippedDate or (RequiredDate<GetDate() and ShippedDate is null)
 
 select*from  VW_TeslimatiGecikmisler2



--En az satilan 3 urun
create view VW_EnAzSatilanUrun
as
select top  3 
od.ProductID,
sum(od.Quantity) Adet,
(select p.ProductName from Products p  where od.ProductID=p.ProductID) UrunAdi
from [Order Details] od  
group by od.ProductID
order by sum(od.Quantity) asc

select*from VW_EnAzSatilanUrun

--Kategorilerin cirolarinin dagilimini % oran olarak listeleyiniz.


create view VW_KategoriCiroOranDagilim
with schemabinding
as
Select 
c.CategoryName, 
round(sum(od.Quantity*od.UnitPrice*(1-od.Discount))/(select sum(od.Quantity*od.UnitPrice*(1-od.Discount)) from dbo.[Order Details] od)*100,2) Oran 
from
	 dbo.[Order Details] od
	join dbo.Products p on od.ProductID=p.ProductID
	right join dbo.Categories c on p.CategoryID=c.CategoryID
group by c.CategoryID,c.CategoryName

select*from VW_KategoriCiroOranDagilim


--1997 yili baz alinarak ayni satislarin 1998 yilinda da yapilacagi on gorulmustur.
--Bu durumda 1998 yilinda satislari ve stogu cikarildiginda urunlerden kacar adet daha tedarik edilmesi gerektigini listeleyiniz.
--(ilgili hedefe ulasmis olanlarin listelenmemesi gerekmektedir.)

select ProductID,Adet1997-Adet1998 SiparisAdedi from
	(select
		od.ProductID,	
		sum(od.Quantity)+
		(select UnitsinStock+UnitsOnOrder from Products where ProductID=od.ProductID) Adet1998,
		(select SatisAdedi
		from ( select
					od.ProductID,
					sum(od.Quantity) SatisAdedi
					from
					[Order Details] od 
					join Orders o on o.OrderID=od.OrderID
					where Year(o.OrderDate)='1997'
					group by od.ProductID) t 
		where ProductID=od.ProductID) Adet1997
		from [Order Details] od 
		join Orders o on o.OrderID=od.OrderID
		where Year(o.OrderDate)='1998'
		group by od.ProductID) t2
where Adet1997>Adet1998 or Adet1998 is null


--Query,Convert,Optimizer,Compile,Execute,Result
--Yorumlanan bir dilde yukaridaki adimlar izlenerek sira ile calisir.
--View'da Query,Convert,Optimizer,Compile adimlar hazir olarak bekler ve daha hizli calisir.
		

-----------------------Function-----------------------------------------
-- Geri donus zorunludur.
-- Sorgu icinde kullanilabilir.(Select clause)

create Function functionAdi
(
	@parametre1 tip,
	@parametre2 tip
)
returns donusTipi
as
begin
	kodlar
	return donusDegeri
end

--Verilen 2 metinsel ifadeyi , aralarinda 1 bosluk olacak sekilde birlestiren function yazin.

create Function Function_MetinBirlestir
(
	@Metin1 varchar(max),
	@Metin2 varchar(max)
)
returns varchar(max)
as
begin
	return  @Metin1+' '+ @Metin2
end

select dbo.Function_MetinBirlestir(FirstName,LastName) AdSoyad from Employees

--Metnin son kelimesini veren function 
select CHARINDEX('f','alafortanfoni',5)


create function Function_SonKelimeAl
(
	@Metin varchar(max)
)
returns varchar(max)
begin
	declare @Index as int = 0
	declare @TempIndex as int = 0
	set @Metin=TRIM(@Metin)
	while 5>4
	begin
		set	@TempIndex= CHARINDEX(' ',@Metin,@Index+1)--okuyamazsa temp index 0 olacak 
		if(@TempIndex>0)
			begin 
			set @Index=@TempIndex
			end
		else 
			begin
				break
			end
	end
	return substring(@Metin,@Index+1,Len(@Metin)-@Index)
end

select dbo.Function_SonKelimeAl('yeni bir hesap olustur ve sadece ilgili hesaba DB yetkisi ver.') 


-----------------------Stored Procedures--------------------------------
--Alt program gibidir.
--Geri donus sabit deger bazli olmaz.(result bazli olur.)
--Sorgu icinde kullanilmaz.

create procedure sp_ProcedureIsmi
(
	@Parameter1 Tip1,
	@Parameter2 Tip2
)
with encryption,recompile
as 
begin 
	sorgular...
end

--ID'si verilmis olan urunun toplam satis adetini veren sp

alter procedure sp_SatisAdedi
(
	 @ProductID as int
)
as
Begin
	select Sum(Quantity) SatisAdedi from [Order Details]
	where ProductID=@ProductID
	print 'Cavabi Result ekranina aktarildi.'
End

select sp_SatisAdedi(5) -- bu sekilde calistirilamaz

execute sp_SatisAdedi 5 
exec sp_SatisAdedi 5 
sp_SatisAdedi 5 


--Calisanlarin sadece ad,soyad ve yaslarini donen sp
create procedure sp_CalisanYas
as
begin
	select FirstName,LastName,DateDiff(year,Birthdate,GetDate()) Yas from Employees
end

sp_CalisanYas


--ID'si verilen kategorinin icinde bulunan urunlerin adini listeleyen sp 

create procedure sp_ProductByCategoryID
(
@categoryID int 
)
as
begin
	Select productName from Products p where p.CategoryID=@categoryID 
end

exec sp_ProductByCategoryID 1

--ProductName,UnitPrice,UnitsinStock degerlerini alýp Discontinued degerini default olarak 0 atayip insert islemi yapan sp
alter procedure sp_ProductInsert
(
	@ProductName nvarchar(40),
	@UnitPrice money,
	@UnitsinStock smallint,
	@Discontinued bit=0,
	@IslemYapanKullaniciID int = null 
)
as
begin
	insert into Products(ProductName,UnitPrice,UnitsInStock,Discontinued)
	values ( @ProductName,@UnitPrice,@UnitsinStock,@Discontinued)

	insert into LogTable(TabloAdi,YeniDeger,YapilanIslem,IslemTarihi,IslemYapanKullaniciID)
	values('Product',
	(select
		'ProductID='+CAST(ProductID as varchar(max))+
		',ProductName='+ProductName,
		',SupplierID='+Cast(SupplierID as varchar(max))+
		',CategoryID='+CAST(CategoryID as varchar(max))+
		',QuantityPerUnit='+(case when QuantityPerUnit is not null then CAST(QuantityPerUnit as varchar(max)) else 'null' end)+
		',UnitPrice='+CAST(UnitPrice as varchar(max))+
		',UnitsinStock='+CAST(UnitsinStock as varchar(max))+
		',UnitsonOrder='+CAST(UnitsOnOrder as varchar(max))+
		',ReorderLevel='+CAST(ReorderLevel as varchar(max))+
		',Discontinued='+CAST(Discontinued as varchar(max))

	from Products where ProductID=@@IDENTITY),
	1,GetDate())
end

exec sp_ProductInsert 'Domates',5,10

select*from Products
----------------------ID YAKALAMA-------------------------
@@Identity -- global degisken, sistem uzerindeki son girilen kaydin id sini verir.
scope_identity()-- scope icinde son olusan id  
ident_current('TabloIsmi')-- tabloya sorarak son olusan id 

--ID'si verilen urunu silen sp (IsDeleted True seklinde) 

alter procedure sp_DeleteByID
(
	@ProductID int
)
as
begin 
	delete from Products where ProductID=@ProductID
end

exec sp_DeletebyID 5

--CategoryName ve ProductName verilerini alip hem Categories hem de ona bagli vaziyette Products tablosuna insert yapan sp

create procedure sp_InsertCategoryandProduct
(
	 @CategoryName nvarchar(15),
	 @ProductName nvarchar(40),
	 @Discontinued bit =0
)
as
begin
	insert into Categories(CategoryName) values (@CategoryName) 
	insert into Products(ProductName,CategoryID,Discontinued) values (@ProductName,@@IDENTITY,@Discontinued)
	 --@@identity sistemde olusan son ID'yi verir 
	 -- trigger olsaydi trigger'dan gelen Id'yi vererek yanlis ID alinmis olur.
	 --Bu durumda scope_identity kullanacaktik.Eger ayni scope'ta da olmasaydi ident_current kullanilirdi.
end

exec sp_InsertCategoryandProduct 'Cikolata','Toblerone'