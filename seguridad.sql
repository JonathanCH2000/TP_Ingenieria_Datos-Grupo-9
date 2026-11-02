USE GestionDeEntradas;
GO

CREATE ROLE rol_administrador;
CREATE ROLE rol_vendedor;
CREATE ROLE rol_consulta;
GO

CREATE USER usr_admin WITHOUT LOGIN;
CREATE USER usr_vendedor WITHOUT LOGIN;
CREATE USER usr_analista WITHOUT LOGIN;
GO

ALTER ROLE rol_administrador ADD MEMBER usr_admin;
ALTER ROLE rol_vendedor ADD MEMBER usr_vendedor;
ALTER ROLE rol_consulta ADD MEMBER usr_analista;
GO

GRANT CONTROL ON SCHEMA::dbo TO rol_administrador;
GO

GRANT SELECT ON dbo.evento TO rol_vendedor;
GRANT SELECT ON dbo.lugar TO rol_vendedor;
GRANT SELECT, INSERT, UPDATE ON dbo.cliente TO rol_vendedor;
GRANT SELECT ON dbo.compra TO rol_vendedor;
GRANT SELECT ON dbo.entrada TO rol_vendedor;
GRANT EXECUTE ON SCHEMA::dbo TO rol_vendedor;
GO

GRANT SELECT ON dbo.evento TO rol_consulta;
GRANT SELECT ON dbo.lugar TO rol_consulta;
GRANT SELECT ON dbo.compra TO rol_consulta;
GRANT SELECT ON dbo.entrada TO rol_consulta;
GRANT SELECT ON dbo.organizador (id_organizador, nombre, apellido) TO rol_consulta;
GRANT SELECT ON dbo.cliente (id_cliente, nombre, apellido) TO rol_consulta;
GO

REVOKE INSERT, UPDATE, DELETE ON dbo.compra FROM rol_vendedor;
REVOKE INSERT, UPDATE, DELETE ON dbo.entrada FROM rol_vendedor;
REVOKE INSERT, UPDATE, DELETE ON SCHEMA::dbo FROM rol_consulta;
GO