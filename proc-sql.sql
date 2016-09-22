create or replace function nroAutores(xcodlibro in number) return number
is
xnroAutores number;
begin
	select count(*) INTO xnroAutores
	from escrito_por
	where xcodlibro=codlibro
	group by codlibro;

	return xnroAutores;
end;

****************************************************************************

create or replace function numberToString(xnum in number) return varchar2
is
	xnumber_string varchar2(75);
begin
	xnumber_string := 'Null';
	IF xnum = 1 THEN xnumber_string := 'UNO'; END IF;
	IF xnum = 2 THEN xnumber_string := 'DOS'; END IF;
	IF xnum = 3 THEN xnumber_string := 'TRES'; END IF;
	IF xnum = 4 THEN xnumber_string := 'CUATRO'; END IF;
	IF xnum = 5 THEN xnumber_string := 'CINCO'; END IF;
	IF xnum = 6 THEN xnumber_string := 'SEIS'; END IF;
	IF xnum = 7 THEN xnumber_string := 'SIETE'; END IF;
	IF xnum = 8 THEN xnumber_string := 'OCHO'; END IF;
	IF xnum = 9 THEN xnumber_string := 'NUEVE'; END IF;
	IF xnum = 10 THEN xnumber_string := 'DIEZ'; END IF;
	IF xnum = 11 THEN xnumber_string := 'ONCE'; END IF;
	IF xnum = 12 THEN xnumber_string := 'DOCE'; END IF;
	IF xnum = 13 THEN xnumber_string := 'TRECE'; END IF;
	IF xnum = 14 THEN xnumber_string := 'CATORCE'; END IF;
	IF xnum = 15 THEN xnumber_string := 'QUINCE'; END IF;
	IF xnum = 16 THEN xnumber_string := 'DIEZ Y SEIS'; END IF;
	IF xnum = 17 THEN xnumber_string := 'DIEZ Y SIETE'; END IF;
	IF xnum = 18 THEN xnumber_string := 'DIEZ Y OCHO'; END IF;
	IF xnum = 19 THEN xnumber_string := 'DIEZ Y NUEVE'; END IF;
	IF xnum = 20 THEN xnumber_string := 'VEINTE'; END IF;
	IF xnum = 21 THEN xnumber_string := 'VEINTE Y UNO'; END IF;
	IF xnum = 22 THEN xnumber_string := 'VEINTE Y DOS'; END IF;
	IF xnum = 23 THEN xnumber_string := 'VEINTE Y TRES'; END IF;
	IF xnum = 24 THEN xnumber_string := 'VEINTE Y CUATRO'; END IF;
	IF xnum = 25 THEN xnumber_string := 'VEINTE Y CINCO'; END IF;
	IF xnum = 26 THEN xnumber_string := 'VEINTE Y SEIS'; END IF;
	IF xnum = 27 THEN xnumber_string := 'VEINTE Y SIETE'; END IF;
	IF xnum = 28 THEN xnumber_string := 'VEINTE Y OCHO'; END IF;
	IF xnum = 29 THEN xnumber_string := 'VEINTE Y NUEVE'; END IF;
	IF xnum = 30 THEN xnumber_string := 'TREINTA'; END IF;
	
	return xnumber_string;
end;

****************************************************************************

create or replace function nroPedidosLibros(xcodlibro in number) return number
is
	xnropedlibros number;
begin
	select count(*) INTO xnropedlibros
	from pedido_libros
	where xcodlibro=codlibro
	group by codlibro;
	return xnropedlibros;
end;

****************************************************************************

create or replace procedure clienteMayor(xcodlibro in number, xnombre out VARCHAR2, xedad out number)
is
begin
		select temp1.nombre, temp.edad INTO xnombre, xedad
		from
		(
		select max(temp.edad) edad
		from
		(
		select pl.codlibro, c.codcliente, trunc(months_between(sysdate, c.fecha_naci)/12) edad
		from cliente c, pedido_libros pl, pedido p
		where c.codcliente = p.codcliente and p.nropedido = pl.nropedido
		) temp
		where temp.codlibro=xcodlibro
		) temp,
		(
		select temp.codcliente, temp.edad, temp.nombre
		from
		(
		select pl.codlibro, c.codcliente, trunc(months_between(sysdate, c.fecha_naci)/12) edad, c.nombre
		from cliente c, pedido_libros pl, pedido p
		where c.codcliente = p.codcliente and p.nropedido = pl.nropedido
		) temp
		where temp.codlibro=xcodlibro
		) temp1
		where temp.edad=temp1.edad;
end;

**************************************************************

create or replace procedure ficha_libro(xcodlibro in number,  
   xtitulo out  varchar2,
   xautor_string out varchar2,
   xdir_almacen out varchar2,
   xnropedidos_string out varchar2,
   xcliente out varchar2,
   xedad out number)
is
begin

	IF nroAutores(xcodlibro) > 1 
	THEN
		select titulo INTO xtitulo from libro where xcodlibro=codlibro;
		select numberToString(nroAutores(xcodlibro)) INTO xautor_string from dual;
		select a.direccion INTO xdir_almacen from almacen a, libro l where l.nroalmacen=a.nroalmacen and xcodlibro=l.codlibro;
		select numberToString(nroPedidosLibros(xcodlibro)) INTO xnropedidos_string from dual;
		clienteMayor(xcodlibro, xcliente, xedad);

	ELSE
		select titulo INTO xtitulo from libro where xcodlibro=codlibro;

		select a.nombre INTO xautor_string 
		from escrito_por ep, autor a 
		where ep.codlibro=xcodlibro and ep.codautor=a.codautor;
		
		select a.direccion INTO xdir_almacen from almacen a, libro l where l.nroalmacen=a.nroalmacen and xcodlibro=l.codlibro;
		select numberToString(nroPedidosLibros(xcodlibro)) INTO xnropedidos_string from dual;
		clienteMayor(xcodlibro, xcliente, xedad);
	END IF;
end;


declare

   xcodlibro number;  
   xtitulo  varchar2(75);
   xautores_string varchar2(75);
   xdir_almacen  varchar2(50);
   xxnropedidos_string  varchar2(75);
   xcliente  varchar2(75);
   xedad  number;

begin 
xcodlibro := 2;
ficha_libro(xcodlibro , xtitulo ,
   xautores_string  ,
   xdir_almacen ,
   xxnropedidos_string,
   xcliente ,
   xedad );     
		dbms_output.put_line('CodLibro:	' || xcodlibro);
		dbms_output.put_line('Titulo:		' || xtitulo);
		dbms_output.put_line('Autor(es):	' || xautores_string);
		dbms_output.put_line('Almacen:	' || xdir_almacen);
		dbms_output.put_line('NroPedidos:	' || xxnropedidos_string);
		dbms_output.put_line('Cliente Mayor:	' || xcliente || '	Edad: '|| xedad);
end;


2.


create or replace procedure inser_libro(xcodlibro in number,xtitulo in varchar2,xanio number,xprecio in number, xstock in number, xcodeditorial in number, xnroalmacen in number)
is
begin
 insert into libro values(xcodlibro ,xtitulo ,xanio ,xprecio , xstock , xcodeditorial , xnroalmacen);
end;


select *
from libro

begin
 inser_libro(24 ,'El mundo de Sofia' , 1993 ,35 , 1 , 201 , 3);
 inser_libro(25 ,'Crepusculo' , 2002 ,5 , 40 , 200 , 1);
end;
