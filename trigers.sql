Triggers

	************************

CREATE OR REPLACE TRIGGER <nombre_trigger>
{BEFORE|AFTER} {DELETE|INSERT|UPDATE [OF col1, col2, ..., colN] [OR {DELETE|INSERT|UPDATE [OF col1, col2,...,colN]...]}
ON <nombre_tabla> 
[FOR EACH ROW [WHEN (<condicion>)]] 
DECLARE
   -- variables locales
 BEGIN
      -- Sentencias 
[EXCEPTION]
    -- Sentencias control de excepcion
END<nombre_trigger>;

CREATE OR REPLACE TRIGGER Tr2_historico_autor
AFTER UPDATE or DELETE ON AUTOR
FOR EACH ROW
DECLARE
BEGIN
 INSERT INTO HISTO_AUTOR   VALUES   (:OLD.codautor, :OLD.Nombre, :OLD.direccion, :OLD.Sexo, :OLD.Fecha_Naci, SYSDATE);
END ; 
 