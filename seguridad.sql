use GestionDeEntradas;
go

if not exists (select name from sys.server_principals where name = 'login_admin')
	create login login_admin with password = 'Admin.2026';
if not exists (select name from sys.server_principals where name = 'login_vendedor')
	create login login_vendedor with password = 'Vendedor.2026';
if not exists (select name from sys.server_principals where name = 'login_analista')
	create login login_analista with password = 'Analista.2026';
go

create user usr_admin for login login_admin;
create user usr_vendedor for login login_vendedor;
create user usr_analista for login login_analista;
go

create role rol_administrador;
create role rol_vendedor;
create role rol_consulta;
go

alter role rol_administrador add member usr_admin;
alter role rol_vendedor add member usr_vendedor;
alter role rol_consulta add member usr_analista;
go

grant select, insert, update, delete on organizador to rol_administrador;
grant select, insert, update, delete on lugar to rol_administrador;
grant select, insert, update, delete on evento to rol_administrador;
grant select, insert, update, delete on cliente to rol_administrador;
grant select, insert, update, delete on compra to rol_administrador;
grant select, insert, update, delete on entrada to rol_administrador;
go

grant select on evento to rol_vendedor;
grant select on lugar to rol_vendedor;
grant select, insert, update on cliente to rol_vendedor;
grant select, insert, update, delete on compra to rol_vendedor;
grant select, insert, update, delete on entrada to rol_vendedor;
go

revoke delete on compra from rol_vendedor;
revoke delete on entrada from rol_vendedor;
go

grant select on evento to rol_consulta;
grant select on lugar to rol_consulta;
grant select on compra to rol_consulta;
grant select on entrada to rol_consulta;
grant select (id_organizador, nombre, apellido) on organizador to rol_consulta;
grant select (id_cliente, nombre, apellido) on cliente to rol_consulta;
go