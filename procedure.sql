/* 1*/
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

/* 2*/ 
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
     	SELECT "LA SUCURSAL NO EXISTE";
     END IF;
  END;
  ELSE 
  	SELECT 'VENDEDOR NO EXISTE';
  END IF;
END $$ 

/* 3*/
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

/* 4*/
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

/* 5*/
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
        END IF  ;
ELSE
      SELECT "nO EXISTE SUCURSAL" ;
END IF  ;
END $$