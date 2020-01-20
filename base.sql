USE master
GO

SET DATEFORMAT dmy;
GO
/*
DROP DATABASE bd_Voluntariado
GO
*/
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'bd_Voluntariado'
)
CREATE DATABASE bd_Voluntariado
GO

use bd_Voluntariado
GO

-- Create a new table called 'Documento' in schema 'dbo'
IF OBJECT_ID('dbo.Documento', 'U') IS NOT NULL
DROP TABLE dbo.Documento
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Documento
(
	DocumentoId INT IDENTITY PRIMARY KEY,
	Nombre [char] (25) NOT NULL
);
GO

-- Create a new table called 'TipoUsuario' in schema 'dbo'
IF OBJECT_ID('dbo.TipoUsuario', 'U') IS NOT NULL
DROP TABLE dbo.TipoUsuario
GO
-- Create the table in the specified schema
CREATE TABLE dbo.TipoUsuario
(
	TipoId INT IDENTITY PRIMARY KEY,
	Cargo [char] (25) NOT NULL
);
GO

-- Create a new table called 'Persona' in schema 'dbo'
IF OBJECT_ID('dbo.Persona', 'U') IS NOT NULL
DROP TABLE dbo.Persona
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Persona
(
    PersonaId INT IDENTITY PRIMARY KEY,
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
	TipoUsuario INT NULL,
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Nro_Documento [char](16) NULL,
    DocumentoId INT FOREIGN KEY REFERENCES Documento(DocumentoId),
    Eliminado BIT DEFAULT 0,
);
GO

-- Create a new table called 'Voluntario' in schema 'dbo'
IF OBJECT_ID('dbo.Voluntario', 'U') IS NOT NULL
DROP TABLE dbo.Voluntario
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Voluntario
(
    VoluntarioId INT IDENTITY PRIMARY KEY,
    Eventos_Asist INT DEFAULT 0 NOT NULL, -- Contador de Eventos asistidos
	PersonaId INT FOREIGN KEY REFERENCES Persona(PersonaId),
    UbicacionId INT NOT NULL 
);
GO

-- Create a new table called 'Organizacion' in schema 'dbo'
IF OBJECT_ID('dbo.Organizacion', 'U') IS NOT NULL
DROP TABLE dbo.Organizacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Organizacion
(
    OrganizacionId INT IDENTITY PRIMARY KEY,
    RazonSocial [char](50) NOT NULL,
    RUC [char](11) NOT NULl,
    Direccion [char](80) NOT NULL,
    PersonaId INT FOREIGN KEY REFERENCES Persona(PersonaId),
    UbicacionId INT NOT NULL
);
GO

-- Create a new table called 'Anuncio' in schema 'dbo'
IF OBJECT_ID('dbo.Anuncio', 'U') IS NOT NULL
DROP TABLE dbo.Anuncio
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Anuncio
(
    AnuncioId INT IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Nombre [char](30) NOT NULL,
    CategoriaId INT NOT NULL, -- Llave Foranea de Categoria
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    Detalle [char](1000) NULL,
    CantParticip INT NULL,
    Eliminado BIT DEFAULT 0,
    -------Llaves Foraneas-----------e
    UbicacionId INT NOT NULL,
    OrganizacionId INT NOT NULL
);
GO

-- Create a new table called 'Categoria' in schema 'dbo'
IF OBJECT_ID('dbo.Categoria', 'U') IS NOT NULL
DROP TABLE dbo.CATEGORIA
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Categoria
(
    CategoriaId INT IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Categoria [char](30) NOT NULL,
);
GO

-- Create a new table called 'Evento' in schema 'dbo'
IF OBJECT_ID('dbo.Evento', 'U') IS NOT NULL
DROP TABLE dbo.Evento
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Evento
(
    EventoId INT IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Nombre [char](50) NOT NULL,
    Eliminado BIT DEFAULT 0,
  -------Llaves Foraneas-----------
    AnuncioId INT FOREIGN KEY REFERENCES Anuncio(AnuncioId)
);
GO

-- Drop the table if it already exists
IF OBJECT_ID('dbo.Tareas', 'U') IS NOT NULL
DROP TABLE dbo.Tareas
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Tareas
(
    TareasId INT IDENTITY PRIMARY KEY,
    Detalle char (150) NOT NULL
    );
GO

-- Create a new table called 'Evento_Participacion' in schema 'dbo'
IF OBJECT_ID('dbo.Evento_Participacion', 'U') IS NOT NULL
DROP TABLE dbo.Evento_Participacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Evento_Participacion
(
	  Id INT IDENTITY PRIMARY KEY,
      -------Llaves Foraneas-----------
      EventoId INT REFERENCES Evento,
      VoluntarioId INT REFERENCES Voluntario,
      TareaId INT REFERENCES Tareas
);
GO


-- Create a new table called 'Ubicacion' in schema 'dbo'
IF OBJECT_ID('dbo.Ubicacion', 'U') IS NOT NULL
DROP TABLE dbo.Ubicacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Ubicacion
(
    UbicacionId INT IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Departamento [char](30) NULL,
    Provincia [char](30) NULL,
    Distrito [char](30) NULL,
    Eliminado BIT DEFAULT 0
);
GO

-- Create a new table called 'Voluntario_Registrado' in schema 'dbo'
IF OBJECT_ID('dbo.Voluntario_Registrado', 'U') IS NOT NULL
DROP TABLE dbo.Voluntario_Registrado
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Voluntario_Registrado
(
      Id INT IDENTITY PRIMARY KEY,
      -------Llaves Foraneas-----------
      AnuncioId INT REFERENCES Anuncio,
      VoluntarioId INT REFERENCES Voluntario
);
GO

-- Persona
ALTER TABLE Persona
ADD FOREIGN KEY (TipoUsuario) REFERENCES TipoUsuario(TipoId);
-- Voluntario
ALTER TABLE Voluntario
ADD FOREIGN KEY (UbicacionId) REFERENCES Ubicacion(UbicacionId);

-- Organizacion
ALTER TABLE dbo.Organizacion
ADD FOREIGN KEY (UbicacionId) REFERENCES Ubicacion(UbicacionId);

-- Anuncio
ALTER TABLE dbo.Anuncio
ADD FOREIGN KEY (CategoriaId) REFERENCES Categoria(CategoriaId);
ALTER TABLE dbo.Anuncio
ADD FOREIGN KEY (UbicacionId) REFERENCES Ubicacion(UbicacionId);
ALTER TABLE dbo.Anuncio
ADD FOREIGN KEY (OrganizacionId) REFERENCES Organizacion(OrganizacionId);
go

/*
select * from Persona;
select * from Documento;
select * from Anuncio;
select * from Categoria;
select * from TipoUsuario;
select * from Voluntario;
select * from Organizacion;
select * from Evento;
select * from Evento_Participacion;
select * from Voluntario_Registrado;
select * from Ubicacion;
*/
go
--------------------------------------------------------------------------------------------------------------
-------------------------- INSERTAR DATOS EN LA BASE DE DATOS ------------------------------------------------
--------------------------------------------------------------------------------------------------------------
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Amazonas', 'Chachapoyas', 'Cheto')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Miraflores')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Ancon')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Ate')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Barranco')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Breña')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Carabayllo')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Chaclacayo')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Chorrillos')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Cieneguilla')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'El Agustino')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Independencia')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'La Molina')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Lince')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Lurigancho')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Puente Piedra')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Rimac')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'San Isidro')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'Ventanilla')
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Lima', 'Lima', 'San Juan de Miraflores')
GO
--------------------------------------------------------------------------------------------------------------

INSERT INTO Documento (Nombre) VALUES ('Dni')
GO
INSERT INTO Documento (Nombre) VALUES ('Carnet de Extranjeria')
GO
INSERT INTO Documento (Nombre) VALUES ('Pasaporte')
GO
--------------------------------------------------------------------------------------------------------------

INSERT INTO TipoUsuario (Cargo) values ('Administrador')
GO
INSERT INTO TipoUsuario (Cargo) values ('Organizacion')
GO
INSERT INTO TipoUsuario (Cargo) values ('Voluntario')
GO
--------------------------------------------------------------------------------------------------------------

INSERT INTO Persona VALUES ('Jose','Perez','Rivas',2,'jperez@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Maria','Paredes','Rosas',3,'mparedes@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Roberto','Custodio','Santos',3,'rcustodio@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Juan','Torres','Rivaguero',3,'jtorres@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Cesar','Salas','Becerra',3,'csalas@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Fernando','Herrera','Bejarano',3,'fherrera@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Luis','Cotrina','Plata',3,'jcotrina@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Ursula','Casas','Colon',3,'ucasa@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Milagros','Balta','Oro',3,'mbalta@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Ricardo','Mendoza','Farias',3,'rmendoza@gmail.com','987654321','12345678',1,0)
go
INSERT INTO Persona VALUES ('Jaen Marco','Sir','Espejo',1,'admin@admin.com','987654321','87654321',1,0)
go
--------------------------------------------------------------------------------------------------------------

INSERT INTO Organizacion VALUES ('Naciones Unidas','20201211101', 'Calle Lima 123',1,1)
GO
--------------------------------------------------------------------------------------------------------------

INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (2,2)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (3,3)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (4,4)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (5,5)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (6,6)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (7,7)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (8,8)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (9,9)
GO
INSERT INTO Voluntario (PersonaId, UbicacionId) VALUES (10,10)
GO
--------------------------------------------------------------------------------------------------------------
INSERT INTO Categoria (Categoria) values ('Limpieza')
GO
INSERT INTO Categoria (Categoria) values ('Construccion')
GO
INSERT INTO Categoria (Categoria) values ('Remodelacion')
GO
INSERT INTO Categoria (Categoria) values ('Alimentacion')
GO
INSERT INTO Categoria (Categoria) values ('Enseñanza')
GO
INSERT INTO Categoria (Categoria) values ('Rescate de animales')
GO
INSERT INTO Categoria (Categoria) values ('Apoyo a adultos mayores')
GO
INSERT INTO Categoria (Categoria) values ('Anfitrión o Promotor')
GO
--------------------------------------------------------------------------------------------------------------
--------------------------- CREANDO LOS PROCEDIMIENTOS ALMACENADOS -------------------------------------------
--------------------------------------------------------------------------------------------------------------
------ A N U N C I O ------
------ Insertar ------ (Insertar un nuevo anuncio)
-- Create a new stored procedure called 'usp_InsertAnuncio' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_InsertAnuncio'
)
DROP PROCEDURE dbo.usp_InsertAnuncio
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_InsertAnuncio 
    @nombre char (30),
    @categoria int,
    @fInicio DATE,
    @fFin DATE,
    @detalle char (1000),
    @cantidad int,
    @ubicacionId int,
    @organizacionId int
AS
    INSERT INTO Anuncio (Nombre, CategoriaId, FechaInicio, FechaFin, Detalle, CantParticip, UbicacionId, OrganizacionId)
                values (@nombre, @categoria, @fInicio, @fFin, @detalle, @cantidad, @ubicacionId, @organizacionId)
GO
-- Example
EXECUTE dbo.usp_InsertAnuncio 'Limpieza de playas', 1, '02/05/2019', '15/11/2019','Unete al voluntariado de limpieza de playas junto a la comunidad de Soy Voluntario

Durante muchos años los oceanos han servido de depositos para los desperdicios de las ciudades, lo que afecta la vida marina y nuestra salud.

Este año Soy Voluntario se vuelve a unir a esta campaña nacional de limpieza de playas organizada por L.O.O.P. y Conservamos por Naturaleza, con el objetivo de dejar una huella positiva en nuestro entorno; por ello, nos dirigiremos hacia Playa Choritos, en el distrito de Ventanilla.

Si estas interesado, te invitamos a unirte al equipo de voluntarios que pasara una jornada de limpieza de playa y concientizacion a los bañistas sobre la importancia de cuidar este ecosistema.', 20, 2, 1
GO

EXECUTE dbo.usp_InsertAnuncio 'Limpieza de calles', 1, '01/01/2019', '20/01/2019','Unete al voluntariado de limpieza de calles junto a la comunidad de Soy Voluntario

Durante muchos años los oceanos han servido de depositos para los desperdicios de las ciudades, lo que afecta la vida marina y nuestra salud.

Este año Soy Voluntario se vuelve a unir a esta campaña nacional de limpieza de playas organizada por L.O.O.P. y Conservamos por Naturaleza, con el objetivo de dejar una huella positiva en nuestro entorno; por ello, nos dirigiremos hacia Playa Choritos, en el distrito de Ventanilla.

Si estas interesado, te invitamos a unirte al equipo de voluntarios que pasara una jornada de limpieza de calles.', 30, 19, 1
GO

--------------------------------------------------------
------ Actualizar ------ (Actualizar un anuncio según su AnuncioId)
-- Create a new stored procedure called 'usp_UpdateAnucio' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_UpdateAnucio'
)
DROP PROCEDURE dbo.usp_UpdateAnucio
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_UpdateAnucio
    @id int,
    @nombre char (30),
    @categoria int,
    @fInicio DATE,
    @fFin DATE,
    @detalle char (1000),
    @cantidad int,
    @ubicacionId int
AS
    UPDATE Anuncio
    SET Nombre=@nombre, CategoriaId=@categoria, FechaInicio=@fInicio, FechaFin=@fFin, Detalle=@detalle, CantParticip=@cantidad, UbicacionId=@ubicacionId
	WHERE AnuncioId=@id
GO
-- Example
EXECUTE dbo.usp_UpdateAnucio 1,'Limpieza de Playa Choritos', 2, '01/03/2019', '12/05/2019','Unete al voluntariado de limpieza de playas junto a la comunidad de Soy Voluntario

Durante muchos años los oceanos han servido de depositos para los desperdicios de las ciudades, lo que afecta la vida marina y nuestra salud.

Este año Soy Voluntario se vuelve a unir a esta campaña nacional de limpieza de playas organizada por L.O.O.P. y Conservamos por Naturaleza, con el objetivo de dejar una huella positiva en nuestro entorno; por ello, nos dirigiremos hacia Playa Choritos, en el distrito de Ventanilla.

Si estas interesado, te invitamos a unirte al equipo de voluntarios que pasara una jornada de limpieza de playa y concientizacion a los bañistas sobre la importancia de cuidar este ecosistema.', 20, 2
GO

--------------------------------------------------------
------ Listar ------ (Listar todos los anuncios ACTIVOS)
-- Create a new stored procedure called 'usp_ListAnuncio' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListAnuncios'
)
DROP PROCEDURE dbo.usp_ListAnuncios
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListAnuncios
AS
SELECT a.AnuncioId, a.Nombre, c.Categoria, FechaInicio, FechaFin, Detalle, CantParticip, Distrito, Provincia, RazonSocial from Anuncio A 
INNER JOIN Organizacion O ON o.OrganizacionId=a.OrganizacionId
INNER JOIN Ubicacion U ON u.UbicacionId=a.UbicacionId
INNER JOIN Categoria C ON c.CategoriaId=a.CategoriaId
WHERE a.Eliminado=0 ORDER BY AnuncioId DESC 
GO
-- Example
EXECUTE dbo.usp_ListAnuncios
GO

--------------------------------------------------------
------ Listar ------ (Listar todos los anuncios)
-- Create a new stored procedure called 'usp_ListAnuncios_All' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListAnuncios_All'
)
DROP PROCEDURE dbo.usp_ListAnuncios_All
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListAnuncios_All
AS
SELECT a.AnuncioId,a.Nombre, c.Categoria, FechaInicio, FechaFin, Detalle, CantParticip, Distrito, Provincia, RazonSocial, a.Eliminado from Anuncio A 
INNER JOIN Organizacion O ON o.OrganizacionId=a.OrganizacionId
INNER JOIN Ubicacion U ON u.UbicacionId=a.UbicacionId
INNER JOIN Categoria C ON c.CategoriaId=a.CategoriaId
ORDER BY AnuncioId DESC 
GO
-- Example
EXECUTE dbo.usp_ListAnuncios_All
GO

--------------------------------------------------------
------ Ver ------ (Ver un anuncio segun el AnuncioId que envíes de parametro)
-- Create a new stored procedure called 'usp_VerAnuncio' in schema 'dbo'
IF EXISTS (
SELECT *	
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_VerAnuncio'
)
DROP PROCEDURE dbo.usp_VerAnuncio
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_VerAnuncio
(
	@id INT
)
AS
SELECT a.AnuncioId, A.Nombre, c.Categoria, FechaInicio, FechaFin, Detalle, CantParticip, Distrito, Provincia, RazonSocial from Anuncio A 
INNER JOIN Organizacion O ON o.OrganizacionId=a.OrganizacionId
INNER JOIN Ubicacion U ON u.UbicacionId=a.UbicacionId
INNER JOIN Categoria C ON c.CategoriaId=a.CategoriaId
where AnuncioId=@id
GO
-- Example
EXECUTE dbo.usp_VerAnuncio 1
GO

------ Listar por Categoria ------ (Ver anuncios por categorias)
-- Create a new stored procedure called 'usp_ListAnuncio_Categoria' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListAnuncio_Categoria'
)
DROP PROCEDURE dbo.usp_ListAnuncio_Categoria
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListAnuncio_Categoria
(
	@id int-- El Id de Categoria
)
AS
SELECT a.AnuncioId, a.Nombre, c.Categoria, FechaInicio, FechaFin, Detalle, CantParticip, Distrito, Provincia, RazonSocial from Anuncio A 
INNER JOIN Organizacion O ON o.OrganizacionId=a.OrganizacionId
INNER JOIN Ubicacion U ON u.UbicacionId=a.UbicacionId
INNER JOIN Categoria C ON c.CategoriaId=a.CategoriaId
WHERE a.CategoriaId=@id ORDER BY AnuncioId ASC 
GO
-- Example
EXECUTE dbo.usp_ListAnuncio_Categoria 1
GO

--------------------------------------------------------
------ Eliminar ------ (Cambiar el campo Eliminado de 0 a 1)
-- Create a new stored procedure called 'usp_EliminarAnuncio' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_EliminarAnuncio'
)
DROP PROCEDURE dbo.usp_EliminarAnuncio
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_EliminarAnuncio
(
	@id INT
)
AS
	UPDATE Anuncio
	SET Eliminado=1 WHERE AnuncioId=@id
GO
/*
-- Example
EXECUTE dbo.usp_EliminarAnuncio 1
GO
EXECUTE dbo.usp_ListAnuncios_All
GO
----------------------------------------------------
UPDATE Anuncio SET Eliminado=0 WHERE AnuncioId=1
GO
EXECUTE dbo.usp_ListAnuncios_All
GO
*/
-----------------------------------
--------- CATEGORIA ---------------
--------- Listar Categorías ------ (Listar las categorÍas)
-- Create a new stored procedure called 'usp_ListCategoria' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListCategoria'
)
DROP PROCEDURE dbo.usp_ListCategoria
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListCategoria
AS
SELECT CategoriaId, Categoria FROM Categoria
GO
-- Example
EXECUTE dbo.usp_ListCategoria
GO

-----------------------------------
------ O R G A N I Z A C I O N E S ------
------ Listar ------ (Listar las organizaciones ACTIVAS)
-- Create a new stored procedure called 'usp_ListOrganizaciones' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListOrganizaciones'
)
DROP PROCEDURE dbo.usp_ListOrganizaciones
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListOrganizaciones
AS
SELECT o.OrganizacionId, RazonSocial, RUC, Nombre 'Responsable', Ape_Paterno 'Apellido', Correo, Telefono, Direccion, Distrito FROM Organizacion o
INNER JOIN Persona p ON o.PersonaId=p.PersonaId
INNER JOIN Ubicacion U ON u.UbicacionId=o.UbicacionId
WHERE p.Eliminado=0 ORDER BY OrganizacionId DESC
GO
-- Example
EXECUTE dbo.usp_ListOrganizaciones
GO

------ Listar ------ (Listar todas las organizaciones)
-- Create a new stored procedure called 'usp_ListOrganizaciones_All' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListOrganizaciones_All'
)
DROP PROCEDURE dbo.usp_ListOrganizaciones_All
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListOrganizaciones_All
AS
SELECT o.OrganizacionId, RazonSocial, RUC, Nombre 'Responsable', Ape_Paterno 'Apellido', Correo, Telefono, Direccion, Distrito, p.Eliminado FROM Organizacion o
INNER JOIN Persona p ON o.PersonaId=p.PersonaId
INNER JOIN Ubicacion U ON u.UbicacionId=o.UbicacionId
ORDER BY OrganizacionId DESC
GO
-- Example
EXECUTE dbo.usp_ListOrganizaciones_All
GO

------ Insertar ------ (Insertar una nueva persona y una organizacion con el id de la persona creada)
-- Create a new stored procedure called 'usp_InsertOrganizacion' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_InsertOrganizacion'
)
DROP PROCEDURE dbo.usp_InsertOrganizacion
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_InsertOrganizacion
(
	@nombre char (30),
    @aPaterno char (30),
    @aMaterno char (30),
    @correo char (50),
    @telefono char (14),
    @ndocumento char (16),
	@documId int,
	@razonSocial char (50),
	@ruc char (11),
	@direccion char (80),
	@ubicacionId int
)
AS
	BEGIN
	INSERT INTO Persona (Nombre,Ape_Paterno,Ape_Materno,Correo,Telefono,Nro_Documento,DocumentoId,TipoUsuario)
			VALUES (@nombre,@aPaterno,@aMaterno,@correo,@telefono,@ndocumento,@documId,2)
	INSERT INTO Organizacion (PersonaId,RazonSocial,RUC,Direccion,UbicacionId)
			VALUES (SCOPE_IDENTITY(),@razonSocial,@ruc,@direccion,@ubicacionId)
	END
GO

-- Example
EXECUTE dbo.usp_InsertOrganizacion 'Julio','Albino','Polo','jalbino@gmail.com','369258147','14725836',1,'Movistar','20100017491','Calle Dean Valdivia 148',18
GO

------ Ver Organizacion por Id ------ (Ver una Organizacion por Id)
-- Create a new stored procedure called 'usp_VerOrganizacion' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_VerOrganizacion'
)
DROP PROCEDURE dbo.usp_VerOrganizacion
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_VerOrganizacion
(
	@id int
)
AS
SELECT o.OrganizacionId, RazonSocial, RUC, Nombre 'Responsable', Ape_Paterno 'Apellido', Correo, Telefono, Direccion, Distrito, p.Eliminado FROM Organizacion o
INNER JOIN Persona p ON o.PersonaId=p.PersonaId
INNER JOIN Ubicacion U ON u.UbicacionId=o.UbicacionId
WHERE o.OrganizacionId=@id
ORDER BY OrganizacionId ASC
GO
-- Example
EXECUTE dbo.usp_VerOrganizacion 1
GO

------ Actualizar ------ (Actualizar una organizacion)
-- Create a new stored procedure called 'usp_UpdateOrganizacion' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_UpdateOrganizacion'
)
DROP PROCEDURE dbo.usp_UpdateOrganizacion
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_UpdateOrganizacion
(
	@id int,
	@razonSocial char (50),
	@ruc char (11),
	@direccion char (80),
	@ubicacionId int
)
AS
	UPDATE Organizacion SET RazonSocial=@razonSocial, RUC=@ruc, Direccion=@direccion, UbicacionId=@ubicacionId
	WHERE OrganizacionId=@id
GO
-- Example
EXECUTE dbo.usp_UpdateOrganizacion 2,'Entel','20100017491','Calle Dean Valdivia 148',18
GO

-----------------------------------
------ V O L U N T A R I O S ------
------ Listar ------ (Listar todos los voluntarios ACTIVOS)
-- Create a new stored procedure called 'usp_ListVoluntarios' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListVoluntarios'
)
DROP PROCEDURE dbo.usp_ListVoluntarios
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListVoluntarios
AS
SELECT v.VoluntarioId, p.Nombre, Ape_Paterno, Ape_Materno, Correo, Telefono, d.Nombre 'Tipo de Documento', Nro_Documento, Distrito from Voluntario v
INNER JOIN Persona p ON v.PersonaId=p.PersonaId 
INNER JOIN Documento d ON p.DocumentoId=d.DocumentoId
INNER JOIN Ubicacion U ON u.UbicacionId=v.UbicacionId
WHERE p.Eliminado=0 ORDER BY Ape_Paterno ASC
GO
-- Example
EXECUTE dbo.usp_ListVoluntarios
GO

------ Listar ------ (Listar todos los voluntarios)
-- Create a new stored procedure called 'usp_ListVoluntarios_All' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListVoluntarios_All'
)
DROP PROCEDURE dbo.usp_ListVoluntarios_All
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListVoluntarios_All
AS
SELECT v.VoluntarioId, p.Nombre, Ape_Paterno, Ape_Materno, Correo, Telefono, d.Nombre 'Tipo de Documento', Nro_Documento, Distrito, p.Eliminado from Voluntario v
INNER JOIN Persona p ON v.PersonaId=p.PersonaId 
INNER JOIN Documento d ON p.DocumentoId=d.DocumentoId
INNER JOIN Ubicacion U ON u.UbicacionId=v.UbicacionId
GO
-- Example
EXECUTE dbo.usp_ListVoluntarios_All
GO

------ Ver Voluntario ------ (Ver Voluntario por Id)
-- Create a new stored procedure called 'usp_ListVoluntarios_All' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_VerVoluntario'
)
DROP PROCEDURE dbo.usp_VerVoluntario
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_VerVoluntario
(
	@id int
)
AS
SELECT v.VoluntarioId, p.Nombre, Ape_Paterno, Ape_Materno, Correo, Telefono, d.Nombre 'Tipo de Documento', Nro_Documento, Distrito from Voluntario v
INNER JOIN Persona p ON v.PersonaId=p.PersonaId 
INNER JOIN Documento d ON p.DocumentoId=d.DocumentoId
INNER JOIN Ubicacion U ON u.UbicacionId=v.UbicacionId
WHERE VoluntarioId=@id
GO
-- Example
EXECUTE dbo.usp_VerVoluntario 6
GO

------ Insertar ------ (Insertar una nueva persona y un voluntario con el Id de la persona creada)
-- Create a new stored procedure called 'usp_InsertVoluntario' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_InsertVoluntario'
)
DROP PROCEDURE dbo.usp_InsertVoluntario
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_InsertVoluntario
(
	@nombre char (30),
    @aPaterno char (30),
    @aMaterno char (30),
    @correo char (50),
    @telefono char (14),
    @ndocumento char (16),
	@documId int,
	@ubicacionId int
)
AS
	BEGIN
	INSERT INTO Persona (Nombre,Ape_Paterno,Ape_Materno,Correo,Telefono,Nro_Documento,DocumentoId,TipoUsuario)
			VALUES (@nombre,@aPaterno,@aMaterno,@correo,@telefono,@ndocumento,@documId,3)
	INSERT INTO Voluntario (PersonaId,UbicacionId)
			VALUES (SCOPE_IDENTITY(),@ubicacionId)
	END
GO

-- Example
EXECUTE dbo.usp_InsertVoluntario 'Rosario','Hernandez','Gomez','rhernandez@gmail.com','987321654','12378945',1,7
GO

----------------------------------------------
------------ PERSONA ------------------------
--------------------------------------------------------
------ Actualizar ------ (Actualizar una persona)
-- Create a new stored procedure called 'usp_UpdatePersona' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_UpdatePersona'
)
DROP PROCEDURE dbo.usp_UpdatePersona
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_UpdatePersona
(
	@id int,
	@nombre char (30),
	@aPaterno char (30),
   	@aMaterno char (30),
    @correo char (50),
    @telefono char (14),
    @ndocumento char (16),
	@documId int
)
AS
	UPDATE Persona SET Nombre=@nombre, Ape_Paterno=@aPaterno, Ape_Materno=@aMaterno, Correo=@correo, Telefono=@telefono, Nro_Documento=@ndocumento, DocumentoId=@documId
	WHERE PersonaId=@id
GO
-- Example
EXECUTE dbo.usp_UpdatePersona 13,'Jose','Hernandez','Gomez','rhernandez@gmail.com','987321654','987654321',2
GO

------ Eliminar -------- (Cambiar el estado de Eliminado)
-- Create a new stored procedure called 'usp_EliminarPersona' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_EliminarPersona'
)
DROP PROCEDURE dbo.usp_EliminarPersona
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_EliminarPersona
(
	@id INT
)
AS
	UPDATE Persona
	SET Eliminado=1 WHERE PersonaId=@id
GO
-- Example
/*
EXECUTE dbo.usp_EliminarPersona 2
GO
select * from Persona;
UPDATE Persona SET Eliminado=0 WHERE PersonaId=2
GO
select * from Persona;
*/
GO
------------ AGREGAR a tablas -----------------
------ Categoria -------- 
-- Create a new stored procedure called 'usp_NuevaCategoria' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_NuevaCategoria'
)
DROP PROCEDURE dbo.usp_NuevaCategoria
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_NuevaCategoria
(
	@categoria [char] (30)
)
AS
	INSERT INTO Categoria (Categoria) values (@categoria)
GO
-- Example
EXECUTE dbo.usp_NuevaCategoria 'Adopción de animales'
Go

------ Ubicacion -------- 
-- Create a new stored procedure called 'usp_NuevaUbicacion' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_NuevaUbicacion'
)
DROP PROCEDURE dbo.usp_NuevaUbicacion
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_NuevaUbicacion
(
	@departamento [char] (30),
	@provincia [char] (30),
	@distrito [char] (30)
)
AS
	INSERT INTO Ubicacion(Departamento,Provincia,Distrito) values (@departamento,@provincia,@distrito)
GO
-- Example
EXECUTE dbo.usp_NuevaUbicacion 'Lima','Lima','San Martin de Porres'
GO

------------- Mostrar Tipo Usuario --------------------
-- Create a new stored procedure called 'usp_TipoUsuario' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_TipoUsuario'
)
DROP PROCEDURE dbo.usp_TipoUsuario
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_TipoUsuario
AS
Select Nombre,Cargo from Persona P INNER JOIN TipoUsuario T ON p.TipoUsuario=t.TipoId
GO
-- Example
EXECUTE usp_TipoUsuario
GO
  
-------------------------------------------------------
    ---------------- LOGIN ----------------------
-- Create a new stored procedure called 'usp_LoginUsuario' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_LoginUsuario'
)
DROP PROCEDURE dbo.usp_LoginUsuario
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_LoginUsuario
(
	@correo [char] (50),
	@password [char] (16)
)
AS
	BEGIN
	SELECT Correo, Nro_Documento, TipoUsuario
	FROM Persona WHERE Correo=@correo AND Nro_Documento=@password
	END
GO
--Example
EXECUTE usp_ListVoluntarios
GO
EXECUTE usp_LoginUsuario 'mbalta@gmail.com','12345678'
GO