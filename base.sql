USE master
GO

SET DATEFORMAT dmy;
GO

--drop database bd_Voluntariado
--GO

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

-- Create a new table called 'Administrador' in schema 'dbo'
IF OBJECT_ID('dbo.Administrador', 'U') IS NOT NULL
DROP TABLE dbo.Administrador
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Administrador
(
    AdministradorId INT IDENTITY PRIMARY KEY,
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Documento [char](16) NULL,
    Tipo_Documento [char](30) NULL,
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
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Eventos_Asist INT DEFAULT 0 NOT NULL,
    -- Contador de Eventos asistidos
    Eliminado BIT DEFAULT 0,
    DocumentoId INT NOT NULL,
    UbicacionId INT NOT NULL
);
GO

-- Create a new table called 'Documento' in schema 'dbo'
IF OBJECT_ID('dbo.Documento', 'U') IS NOT NULL
DROP TABLE dbo.Documento
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Documento
(
    DocumentoId INT IDENTITY PRIMARY KEY,
    Nombre [char] (16) NOT NULL
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
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Direccion [char](80) NOT NULL,
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
    Documento [char](16) NULL,
    Tipo_Documento [char](30) NULL,
    Eliminado BIT DEFAULT 0,
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
    AnuncioId INT IDENTITY PRIMARY KEY,
    -- IDENTITY PRIMARY KEY column
    Nombre [char](30) NOT NULL,
    Categoria [char](25) NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    Detalle [char](1000) NULL,
    CantParticip INT NULL,
    Eliminado BIT DEFAULT 0,
    -------Llaves Foraneas-----------
    UbicacionId INT NOT NULL,
    OrganizacionId INT NOT NULL
);
GO

-- Create a new table called 'Evento' in schema 'dbo'
IF OBJECT_ID('dbo.Evento', 'U') IS NOT NULL
DROP TABLE dbo.Evento
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Evento
(
    EventoId INT IDENTITY PRIMARY KEY,
    -- IDENTITY PRIMARY KEY column
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
    Detalle char (30) NOT NULL
);
GO

-- Create a new table called 'Evento_Participacion' in schema 'dbo'
IF OBJECT_ID('dbo.Evento_Participacion', 'U') IS NOT NULL
DROP TABLE dbo.Evento_Participacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Evento_Participacion
(
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
    UbicacionId INT IDENTITY PRIMARY KEY,
    -- IDENTITY PRIMARY KEY column
    Departamento [char](30) NULL,
    Provincia [char](30) NULL,
    Distrito [char](30) NULL,
    Eliminado BIT DEFAULT 0
);
GO

-- Create a new table called 'Calif_Voluntario' in schema 'dbo'
IF OBJECT_ID('dbo.Calif_Voluntario', 'U') IS NOT NULL
DROP TABLE dbo.Calif_Voluntario
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Calif_Voluntario
(
    Calif_VoluntarioId INT IDENTITY PRIMARY KEY,
    -- IDENTITY PRIMARY KEY column
    Detalle INT NOT NULL,
    -- Hacer un constraint para restringir que solo entren valores de 0-10
    Comentario [char](200) NOT NULL,
    -------Llaves Foraneas-----------
    VoluntarioId INT FOREIGN KEY REFERENCES Voluntario(VoluntarioId),
    OrganizacionId INT FOREIGN KEY REFERENCES Organizacion(OrganizacionId),
    EventoId INT FOREIGN KEY REFERENCES Evento(EventoId)
    /*Falta detallar las referencias del FK*/
);
GO

-- Create a new table called 'Calif_Organizacion' in schema 'dbo'
IF OBJECT_ID('dbo.Calif_Organizacion', 'U') IS NOT NULL
DROP TABLE dbo.Calif_Organizacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Calif_Organizacion
(
    Calif_OrganizacionId INT IDENTITY PRIMARY KEY,
    -- IDENTITY PRIMARY KEY column
    Detalle INT NOT NULL,
    -- Hacer un constraint para restringir que solo entren valores de 0-10
    Comentario [char](200) NOT NULL,
    -------Llaves Foraneas-----------
    OrganizacionId INT FOREIGN KEY REFERENCES Organizacion(OrganizacionId),
    VoluntarioId INT FOREIGN KEY REFERENCES Voluntario(VoluntarioId),
    EventoId INT FOREIGN KEY REFERENCES Evento(EventoId)
    /*Falta detallar las referencias del FK*/
);
GO

-- Voluntario
ALTER TABLE Voluntario
ADD FOREIGN KEY (UbicacionId) REFERENCES Ubicacion(UbicacionId);
ALTER TABLE Voluntario
ADD FOREIGN KEY (DocumentoId) REFERENCES Documento(DocumentoId);

-- Organizacion
ALTER TABLE dbo.Organizacion
ADD FOREIGN KEY (UbicacionId) REFERENCES Ubicacion(UbicacionId);

-- Anuncio
ALTER TABLE dbo.Anuncio
ADD FOREIGN KEY (UbicacionId) REFERENCES Ubicacion(UbicacionId);
ALTER TABLE dbo.Anuncio
ADD FOREIGN KEY (OrganizacionId) REFERENCES Organizacion(OrganizacionId);
go

/*
select * from Anuncio;
select * from Voluntario;
select * from Administrador;
select * from Evento;
select * from Evento_Participacion;
select * from Organizacion;
select * from Ubicacion;
select * from Calif_Organizacion;
select * from Calif_Voluntario;
*/
go

-- INSERTAR DATOS EN LA BASE DE DATOS

INSERT INTO Ubicacion
    (Departamento, Provincia, Distrito)
VALUES
    ('Amazonas', 'Chachapoyas', 'Cheto')
GO
INSERT INTO Ubicacion
    (Departamento, Provincia, Distrito)
VALUES
    ('Lima', 'Lima', 'Miraflores')
GO
INSERT INTO Ubicacion
    (Departamento, Provincia, Distrito)
VALUES
    ('Amazonas', 'Chachapoyas', 'Cheto')
GO
INSERT INTO Ubicacion
    (Departamento, Provincia, Distrito)
VALUES
    ('Amazonas', 'Chachapoyas', 'Cheto')
GO
INSERT INTO Ubicacion
    (Departamento, Provincia, Distrito)
VALUES
    ('Amazonas', 'Chachapoyas', 'Cheto')
GO

INSERT INTO Organizacion
VALUES
    ('Naciones Unidas', '20201211101', 'v@nu.org', '01-201530', 'Calle Lima 123', 'Julia', 'Reina', 'del Bosque', '12345678', 'DNI', 0, 1)
GO


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
    @categoria char (25),
    @fInicio DATE,
    @fFin DATE,
    @detalle char (1000),
    @cantidad int,
    @ubicacionId int,
    @organizacionId int
AS
INSERT INTO Anuncio
    (Nombre, Categoria, FechaInicio, FechaFin, Detalle, CantParticip, UbicacionId, OrganizacionId)
values
    (@nombre, @categoria, @fInicio, @fFin, @detalle, @cantidad, @ubicacionId, @organizacionId)
GO
-- Example
EXECUTE dbo.usp_InsertAnuncio 'Limpieza de playas', 'Limpieza', '02/05/2019', '15/11/2019','Únete al voluntariado de limpieza de playas junto a la comunidad de Soy Voluntario

Durante muchos años los océanos han servido de depósitos para los desperdicios de las ciudades, lo que afecta la vida marina y nuestra salud.

Este año Soy Voluntario se vuelve a unir a esta campaña nacional de limpieza de playas organizada por L.O.O.P. y Conservamos por Naturaleza, con el objetivo de dejar una huella positiva en nuestro entorno; por ello, nos dirigiremos hacia Playa Choritos, en el distrito de Ventanilla.

Si estas interesado, te invitamos a unirte al equipo de voluntarios que pasará una jornada de limpieza de playa y concientización a los bañistas sobre la importancia de cuidar este ecosistema.', 20, 2, 1
GO

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
SELECT *
FROM Anuncio
ORDER BY AnuncioId DESC
GO
-- Example
EXECUTE dbo.usp_ListAnuncios
GO

---
--FALTA HACER ESTE PROCEDIMIENTO
---
-- Create a new stored procedure called 'usp_ListAnuncio' in schema 'dbo'
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
    @id int
)
AS
select A.Nombre, Categoria, FechaInicio, FechaFin, Detalle, CantParticip, Provincia, RazonSocial
from Anuncio A
    INNER JOIN Organizacion O ON o.OrganizacionId=a.OrganizacionId
    INNER JOIN Ubicacion U ON u.UbicacionId=a.UbicacionId
where AnuncioId=@id
GO
-- Example
EXECUTE dbo.usp_VerAnuncio 1
GO

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
SELECT *
FROM Organizacion
ORDER BY OrganizacionId DESC
GO
-- Example
EXECUTE dbo.usp_ListOrganizaciones
GO

--insert into Voluntario values ('Jose','Perez','Manrique','correo@gmail.com','987654321','12345678','DNI',)
go

select A.Nombre, Categoria, FechaInicio, FechaFin, Detalle, CantParticip, Provincia, RazonSocial
from Anuncio A
    INNER JOIN Organizacion O ON o.OrganizacionId=a.OrganizacionId
    INNER JOIN Ubicacion U ON u.UbicacionId=a.UbicacionId
where AnuncioId=2
