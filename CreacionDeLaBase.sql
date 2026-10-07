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