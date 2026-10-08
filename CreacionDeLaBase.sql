create database GestionDeEntradas
use GestionDeEntradas
go
create table organizador(
	id_organizador int identity,
	cuit varchar(30) not null,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	telefono varchar(30) not null,
	email varchar(30) not null,

	constraint pk_id_organizador primary key (id_organizador) 
);
go
create table evento(
	id_evento int identity, 
	nombre_evento varchar(30) not null, 
	fecha datetime not null, 
	hora_inicio varchar(20) not null,
	hora_fin varchar(20) not null,
	estado varchar (30) not null,

	constraint pk_id_evento primary key (id_evento),
	constraint check_estado check (estado IN ('ACTIVO','FINALIZADO'))
);
go