SELECT concat(nombre, ' ', apellido) AS nombre 
FROM persona

•	INTERVALO DE TIEMPO EN AÑOS
SELECT nombre, year(curdate())-year(fecha_nac)  edad
FROM persona

•	OBTENER DATOS DE FECHA
SELECT now()                                               //selecciona la fecha y hora actuales
SELECT year(now())                                   //selecciona el año
SELECT month(now())                              //selecciona el mes
SELECT day(now())                                  //selecciona el día
SELECT time(now())                               //selecciona la hora
SELECT last_day(now())                       //selecciona el último día del mes

•	CONVERSION DE UNA CADENA A MINUSCULAS O MAYUSCULAS
SELECT lower(nombre), nombre                        //upper para mayúsculas
FROM persona

•	FUNCIONES MIN, MAX, AVG, SUM Y COUNT
SELECT nombre, min(year(curdate())-year(fecha_nac)) edad
FROM persona

SELECT nombre, max(year(curdate())-year(fecha_nac)) edad
FROM persona

SELECT avg(duracion) prom
FROM ceremonia

SELECT sum(costo)
FROM recibo r
WHERE month(r.fecha)=7

SELECT year(r.fecha) año, count(*) nro
FROM recibo r
WHERE year(r.fecha)=2016 

•	REEMPLAZO DE CARACTERES
SELECT nombre
FROM persona
WHERE nombre like 'A%'

SELECT nombre
FROM persona
WHERE nombre like '_A%'

