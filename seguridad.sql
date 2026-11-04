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
grant select, insert, update on compra to rol_vendedor;
grant select, insert, update on entrada to rol_vendedor;
go

deny delete on compra to rol_vendedor;
deny delete on entrada to rol_vendedor;
go

grant select on evento to rol_consulta;
grant select on lugar to rol_consulta;
grant select on compra to rol_consulta;
grant select on entrada to rol_consulta;
grant select (id_organizador, nombre, apellido) on organizador to rol_consulta;
grant select (id_cliente, nombre, apellido) on cliente to rol_consulta;
go

-- Permisos sobre las vistas
grant select on vw_ocupacion_evento to rol_vendedor;
grant select on vw_entradas_habilitadas to rol_vendedor;
go

grant select on vw_ocupacion_evento to rol_consulta;
grant select on vw_compras_detalle to rol_consulta;
grant select on vw_entradas_habilitadas to rol_consulta;
grant select on vw_recaudacion_organizador to rol_consulta;
go

-- Permisos sobre funciones y procedimientos
grant execute on dbo.fn_monto_vigente_compra to rol_vendedor;
grant execute on dbo.fn_cupo_disponible_evento to rol_vendedor;
grant execute on dbo.fn_puede_ingresar to rol_vendedor;
grant execute on dbo.registrar_compra to rol_vendedor;
grant execute on dbo.registrar_ingreso to rol_vendedor;
go

grant execute on dbo.fn_total_calculado_compra to rol_administrador;
grant execute on dbo.validar_cupo_eventos to rol_administrador;
grant execute on dbo.cancelar_compras_evento to rol_administrador;
go
