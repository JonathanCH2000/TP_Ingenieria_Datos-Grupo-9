/*LA IDEA DE ESTE ARCHIVO ES PODER CORRER TODO DE UNA A VER SI DA ERRORS O ALGO POR EL ESTILO*/

USE master;
GO

IF DB_ID('GestionDeEntradas') IS NOT NULL
BEGIN
    ALTER DATABASE GestionDeEntradas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GestionDeEntradas;
END
GO

CREATE DATABASE GestionDeEntradas;
GO
USE GestionDeEntradas;
GO

create table organizador(
    id_organizador int identity(1,1),
    cuit varchar(13) not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    telefono varchar(20) not null,
    email varchar(100) not null,

    constraint pk_organizador primary key (id_organizador),
    constraint uq_organizador_cuit unique (cuit),
    constraint uq_organizador_email unique (email),
    constraint ck_organizador_cuit
        check (cuit like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'),
    constraint ck_organizador_email check (email like '%_@_%._%')
);
GO

create table lugar(
    id_lugar int identity(1,1),
    nombre_lugar varchar(100) not null,
    direccion varchar(100) not null,
    capacidad int not null,

    constraint pk_lugar primary key (id_lugar),
    constraint ck_lugar_capacidad check (capacidad > 0)
);
GO

create table evento(
    id_evento int identity(1,1),
    id_organizador int not null,
    id_lugar int not null,
    nombre_evento varchar(100) not null,
    fecha date not null,
    hora_inicio time(0) not null,
    hora_fin time(0) not null,
    estado varchar(20) not null
        constraint df_evento_estado default 'ACTIVO',

    constraint pk_evento primary key (id_evento),
    constraint fk_evento_organizador foreign key (id_organizador)
        references organizador(id_organizador),
    constraint fk_evento_lugar foreign key (id_lugar)
        references lugar(id_lugar),
    constraint ck_evento_estado check (estado in ('ACTIVO','FINALIZADO')),
    constraint ck_evento_horario check (hora_fin > hora_inicio)
);
GO

create table cliente(
    id_cliente int identity(1,1),
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) not null,

    constraint pk_cliente primary key (id_cliente),
    constraint uq_cliente_email unique (email),
    constraint ck_cliente_email check (email like '%_@_%._%')
);
GO

create table compra(
    id_compra int identity(1,1),
    id_cliente int not null,
    fecha datetime not null
        constraint df_compra_fecha default getdate(),
    total decimal(12,2) not null
        constraint df_compra_total default 0,
    estado_pago varchar(20) not null
        constraint df_compra_estado_pago default 'PENDIENTE',

    constraint pk_compra primary key (id_compra),
    constraint fk_compra_cliente foreign key (id_cliente)
        references cliente(id_cliente),
    constraint ck_compra_total check (total >= 0),
    constraint ck_compra_estado_pago check (estado_pago in ('PENDIENTE','PAGADO','CANCELADO'))
);
GO

create table entrada(
    id_entrada int identity(1,1),
    id_compra int not null,
    id_evento int not null,
    codigo varchar(20) not null,
    precio decimal(10,2) not null,
    estado varchar(20) not null
        constraint df_entrada_estado default 'HABILITADA',

    constraint pk_entrada primary key (id_entrada),
    constraint fk_entrada_compra foreign key (id_compra)
        references compra(id_compra),
    constraint fk_entrada_evento foreign key (id_evento)
        references evento(id_evento),
    constraint uq_entrada_codigo unique (codigo),
    constraint ck_entrada_precio check (precio >= 0),
    constraint ck_entrada_estado check (estado in ('HABILITADA','UTILIZADA','ANULADA'))
);
GO

create trigger tr_entrada_recalcular_total
on entrada
after insert, update, delete
as
begin
    set nocount on;

    update c
    set total = isnull((select sum(e.precio)
                        from entrada e
                        where e.id_compra = c.id_compra), 0)
    from compra c
    where c.id_compra in (select id_compra from inserted
                          union
                          select id_compra from deleted);
end;
GO

USE GestionDeEntradas;
GO

INSERT INTO organizador (cuit, nombre, apellido, telefono, email) VALUES
('20-30123456-7', 'Martin', 'Gomez', '11-4523-1100', 'mgomez@produccionesmg.com'),
('27-28987654-3', 'Lucia', 'Fernandez', '11-4789-2200', 'lfernandez@lfeventos.com'),
('30-71234567-9', 'Diego', 'Ramirez', '11-5034-3300', 'dramirez@sonarte.com'),
('23-33445566-1', 'Carolina', 'Sosa', '11-6120-4400', 'csosa@escenasur.com'),
('20-29876543-2', 'Hernan', 'Castro', '11-4411-6600', 'hcastro@castrolive.com'),
('27-31222333-4', 'Julieta', 'Morales', '11-5522-7700', 'jmorales@jmeventos.com'),
('20-27666777-8', 'Ezequiel', 'Rojas', '11-6633-8800', 'erojas@rojasprod.com'),
('27-35888999-0', 'Micaela', 'Herrera', '11-3744-9900', 'mherrera@escenaviva.com'),
('30-70555444-6', 'Gaston', 'Vega', '11-4855-1010', 'gvega@vegashows.com'),
('20-25111222-5', 'Pablo', 'Ibarra', '11-3987-5500', 'pibarra@ibarrashows.com');
GO

INSERT INTO lugar (nombre_lugar, direccion, capacidad) VALUES
('Estadio Luna Park', 'Av. Madero 420, CABA', 8000),
('Teatro Gran Rex', 'Av. Corrientes 857, CABA', 3300),
('Niceto Club', 'Niceto Vega 5510, CABA', 1000),
('La Trastienda', 'Balcarce 460, CABA', 700),
('Teatro Coliseo', 'M. T. de Alvear 1125, CABA', 1700),
('Usina del Arte', 'Agustin Caffarena 1, CABA', 1200),
('Sala Palermo Mini', 'Gorriti 4800, CABA', 3),
('Club Cultural Matienzo', 'Pringles 1249, CABA', 300),
('Teatro Maipo', 'Esmeralda 443, CABA', 700),
('Teatro Opera', 'Av. Corrientes 860, CABA', 2000);
GO

INSERT INTO evento (id_organizador, id_lugar, nombre_evento, fecha, hora_inicio, hora_fin, estado) VALUES
(1, 1, 'Rock en el Luna', '20260815', '21:00', '23:30', 'FINALIZADO'),
(2, 2, 'Stand Up Noche de Risas', '20260905', '20:30', '22:30', 'FINALIZADO'),
(3, 3, 'Electro Night', '20260920', '20:00', '23:59', 'FINALIZADO'),
(4, 4, 'Jazz en la Trastienda', '20261010', '21:00', '23:00', 'FINALIZADO'),
(5, 5, 'Festival Indie 2026', '20261205', '18:00', '23:59', 'ACTIVO'),
(6, 6, 'Opera Popular', '20261212', '20:00', '22:30', 'ACTIVO'),
(7, 7, 'Acustico Intimo', '20261219', '21:00', '22:30', 'ACTIVO'),
(8, 8, 'Tango Joven', '20261228', '21:30', '23:30', 'ACTIVO'),
(9, 9, 'Noche de Boleros', '20270109', '21:00', '23:00', 'ACTIVO'),
(1, 2, 'Gala Sinfonica', '20270116', '20:00', '22:00', 'ACTIVO');
GO

INSERT INTO cliente (nombre, apellido, email) VALUES
('Juan', 'Perez', 'jperez@gmail.com'),
('Maria', 'Lopez', 'mlopez@gmail.com'),
('Santiago', 'Garcia', 'sgarcia@hotmail.com'),
('Valentina', 'Martinez', 'vmartinez@gmail.com'),
('Tomas', 'Rodriguez', 'trodriguez@yahoo.com'),
('Camila', 'Alvarez', 'calvarez@gmail.com'),
('Nicolas', 'Torres', 'ntorres@outlook.com'),
('Sofia', 'Romero', 'sromero@gmail.com'),
('Joaquin', 'Acosta', 'jacosta@gmail.com'),
('Florencia', 'Medina', 'fmedina@gmail.com');
GO

INSERT INTO compra (id_cliente, fecha, total, estado_pago) VALUES
(1, '2026-07-20T10:15:00', 45000.00, 'PAGADO'),
(2, '2026-07-25T18:40:00', 45000.00, 'PAGADO'),
(3, '2026-08-20T09:30:00', 28000.00, 'PAGADO'),
(4, '2026-08-28T21:10:00', 28000.00, 'CANCELADO'),
(5, '2026-09-01T16:45:00', 32000.00, 'PAGADO'),
(1, '2026-10-05T19:00:00', 25000.00, 'PAGADO'),
(6, '2026-10-12T22:30:00', 38000.00, 'PAGADO'),
(7, '2026-10-20T14:00:00', 18000.00, 'PAGADO'),
(8, '2026-10-22T20:15:00', 18000.00, 'PAGADO'),
(2, '2026-10-27T12:40:00', 52000.00, 'PENDIENTE'),
(1, '2026-10-29T11:20:00', 42000.00, 'PAGADO'),
(1, '2026-10-30T18:05:00', 22000.00, 'PAGADO');
GO

INSERT INTO entrada (id_compra, id_evento, codigo, precio, estado) VALUES
(1, 1, 'ENT-0001', 45000.00, 'UTILIZADA'),
(2, 1, 'ENT-0002', 45000.00, 'HABILITADA'),
(3, 2, 'ENT-0003', 28000.00, 'UTILIZADA'),
(4, 2, 'ENT-0004', 28000.00, 'ANULADA'),
(5, 3, 'ENT-0005', 32000.00, 'UTILIZADA'),
(6, 4, 'ENT-0006', 25000.00, 'UTILIZADA'),
(7, 5, 'ENT-0007', 38000.00, 'HABILITADA'),
(8, 7, 'ENT-0008', 18000.00, 'HABILITADA'),
(9, 7, 'ENT-0009', 18000.00, 'HABILITADA'),
(10, 6, 'ENT-0010', 52000.00, 'HABILITADA'),
(11, 5, 'ENT-0011', 42000.00, 'HABILITADA'),
(12, 8, 'ENT-0012', 22000.00, 'HABILITADA');
GO

-- FUNCIONES (pendiente)

-- VISTAS (pendiente)

-- STORED PROCEDURES (pendiente)

-- TRIGGERS (pendiente)

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

SELECT DB_NAME() AS base_actual;
GO