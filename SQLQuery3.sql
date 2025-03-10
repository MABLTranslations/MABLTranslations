CREATE DATABASE TiendaOnlineReto1;
GO

USE TiendaOnlineReto1;

CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    Telefono NVARCHAR(20),
    Direccion NVARCHAR(255)
);

CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio > 0),
    Stock INT NOT NULL CHECK (Stock >= 0)
);

CREATE TABLE Pedidos (
    PedidoID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaPedido DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(50) CHECK (Estado IN ('Pendiente', 'Enviado', 'Entregado', 'Cancelado')),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID) ON DELETE CASCADE
);

CREATE TABLE DetallesPedidos (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario > 0),
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID) ON DELETE CASCADE,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID) ON DELETE CASCADE
);

INSERT INTO Clientes (Nombre, Apellido, Email, Telefono, Direccion)
VALUES
    ('Juan', 'Pérez', 'juan.perez@email.com', '555-1234', 'Calle Mayor 123, Madrid'),
    ('Ana', 'Gómez', 'ana.gomez@email.com', '555-5678', 'Avenida Central 45, Barcelona');

INSERT INTO Productos (Nombre, Descripcion, Precio, Stock)
VALUES
    ('Cuaderno A5', 'Cuaderno rayado 80 hojas', 2.50, 100),
    ('Lápiz HB', 'Lápiz de grafito con goma', 0.75, 200),
    ('Mochila Escolar', 'Mochila con compartimentos', 25.99, 50);

INSERT INTO Pedidos (ClienteID, Estado)
VALUES
    (1, 'Pendiente'),
    (2, 'Enviado');

INSERT INTO DetallesPedidos (PedidoID, ProductoID, Cantidad, PrecioUnitario)
VALUES
    (1, 1, 2, 2.50),  -- Juan compró 2 cuadernos
    (1, 2, 3, 0.75),  -- Juan compró 3 lápices
    (2, 3, 1, 25.99); -- Ana compró 1 mochila

SELECT p.PedidoID, c.Nombre + ' ' + c.Apellido AS Cliente, p.FechaPedido, p.Estado,
       pr.Nombre AS Producto, d.Cantidad, d.PrecioUnitario
FROM Pedidos p
JOIN Clientes c ON p.ClienteID = c.ClienteID
JOIN DetallesPedidos d ON p.PedidoID = d.PedidoID
JOIN Productos pr ON d.ProductoID = pr.ProductoID;

SELECT Nombre, Stock
FROM Productos
WHERE Stock < 10;

UPDATE Pedidos
SET Estado = 'Entregado'
WHERE PedidoID = 1;

DELETE FROM Clientes WHERE ClienteID = 2;
