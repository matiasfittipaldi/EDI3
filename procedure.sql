/* 1 Bien*/
DELIMITER $$
CREATE PROCEDURE CrearCliente(NomN VARCHAR(45), ApeN VARCHAR(45	), DirN VARCHAR (45), DNIN VARCHAR (45)) 
BEGIN
  if EXISTS (SELECT * from cliente WHERE DNI = DNIN) THEN
	 UPDATE cliente
     SET Nombre = NomN, Apellido = ApeN, Direccion = DirN
     WHERE DNIN = DNI; 
   ELSE
     INSERT into cliente  (Nombre, Apellido, Direccion, DNI, idCliente)  VALUES (NomN, ApeN,DirN,DNIN,1500);
   END IF;
END
END $$

/* 2 BIEN*/ 
DELIMITER $$
CREATE PROCEDURE Asignar(DNIN VARCHAR (45), NombreN VARCHAR(45))
BEGIN
  if (EXISTS (SELECT * from vendedor WHERE DNI = DNIN)) THEN
  BEGIN
  	if (EXISTS (SELECT * from sucursal s where nombreN = s.Nombre)) THEN
    BEGIN
		DECLARE myidvendedor INT ;
        DECLARE myidsucursal INT ;
        SET myidvendedor = (SELECT idVendedor FROM vendedor where DNI = DNIN);
        SET myidsucursal = (select idSucursal FROM sucursal where Nombre = nombreN LIMIT 1);
      if not EXISTS(SELECT * from vendedorsucursal where myidvendedor = idVendedor AND myidsucursal = idSucursal) THEN
      	INSERT into vendedorsucursal VALUES (2099,myidsucursal,myidvendedor);
      ELSE 
      	SELECT 'la sucursal tiene vendedor';
  	  END IF;
     END;
     ELSE
     	SELECT 'LA SUCURSAL NO EXISTE';
     END IF;
  END;
  ELSE 
  	SELECT 'VENDEDOR NO EXISTE';
  END IF;
END $$ 

/* 3 Con Correccion*/
DELIMITER $$
CREATE PROCEDURE Agregar(myVenta VARCHAR(45), myProducto VARCHAR (45), myCant VARCHAR(45), mySuc VARCHAR (45))
BEGIN
DECLARE myidproducto INT ;
if ((SELECT st.Cantidad FROM stock st INNER JOIN producto pr ON (pr.idProducto = st.idProducto) WHERE pr.Nombre = myProducto and st.idSucursal = mySuc) > myCant) THEN
		SET myidproducto = (SELECT idProducto FROM producto WHERE Nombre = myProducto);
				SELECT myidproducto; 
                INSERT INTO item (cantidad,idItem,idProducto,idVenta)
                VALUES (myCant,2022,myidproducto,myVenta);
				UPDATE stock SET Cantidad = Cantidad - myCant;
    ELSE
            	SELECT "STOCK INSUFICIENTE";
   	END IF ;
END$$

-- Falta validar que el producto exista en la sucursal
DELIMITER $$
CREATE PROCEDURE Agregar(myVenta VARCHAR(45), myProducto VARCHAR (45), myCant VARCHAR(45), mySuc VARCHAR (45))
BEGIN
DECLARE myidproducto INT ;
if exists (SELECT st.Cantidad FROM scursal s INNER JOIN stock st ON s.idSucursal = st.idSucursal INNER JOIN producto p on p.idProducto = st.idProducto WHERE p.Nombre = myProducto) THEN
	if ((SELECT st.Cantidad FROM stock st INNER JOIN producto pr ON (pr.idProducto = st.idProducto) WHERE pr.Nombre = myProducto and st.idSucursal = mySuc) > myCant) THEN
		SET myidproducto = (SELECT idProducto FROM producto WHERE Nombre = myProducto);

		INSERT INTO item (cantidad,idItem,idProducto,idVenta) VALUES (myCant,2022,myidproducto,myVenta);
		UPDATE stock SET Cantidad = Cantidad - myCant;
	ELSE
		SELECT 'STOCK INSUFICIENTE';
	END IF ;
ELSE
		SELECT 'PRODUCTO NO EXISTE EN SUCURSAL INSUFICIENTE';
	END IF ;
END$$

/* 4  Con Correccion*/
DELIMITER $$
CREATE PROCEDURE Actualizar(porcentaje INT) 
BEGIN
	IF EXISTS (SELECT p.*, SUM(i.cantidad) tot FROM item i 
               INNER JOIN producto p ON (i.idProducto = p.idProducto)
               GROUP by i.idProducto
               HAVING tot > 10 
              ) THEN
	  	UPDATE producto p SET p.Precio = (p.Precio + porcentaje * p.Precio / 100);
	END IF;
END $$

-- El SP anterior no es correcto porque solo se esta consultado por si existe algun producto que halla vendido mas de 10 unidade y en caso de que asi sea se actualizan todo los producto
-- Lo que se quiere es que solo se actualicen los productos que tiene mas de 1o ventas por lo que hay que hacer un update con un WHERE. Este WHERE tiene que filtrar los productos por cantidad de ventas 
DELIMITER &&
create procedure Actualizar(porcentaje int )
begin
update producto p 
set p.Precio = (p.Precio + porcentaje * p.Precio / 100)
where
	(select sum(i.cantidad) from venta v 
	inner join item i on v.iditems=i.iditem where
	i.idproducto=p.idproducto) > 10;
end &&

/* 5 Bien pero con error de sintaxis*/
DELIMITER $$
CREATE PROCEDURE Stock(mystock varchar(45),mysuc varchar (45),cantidad int)
BEGIN
IF EXISTS ( SELECT s.* FROM sucursal s WHERE s.Nombre = mysuc ) THEN  
BEGIN
	DECLARE myidsuc INT ;
	SET myidsuc = (SELECT s.idSucursal from sucursal s WHERE s.Nombre = mysuc);
		IF EXISTS ( SELECT s.* FROM stock INNER JOIN producto p ON (p.idProducto = stock.idProducto) WHERE p.Nombre LIKE myprod ) THEN 
			UPDATE stock SET stock.Cantidad = mystock ;
        ELSE
          INSERT INTO stock VALUES (mystock,1001,2020,myidsuc);
        END IF;
END;
ELSE
      SELECT 'NO EXISTE SUCURSAL' ;
END IF;
END $$