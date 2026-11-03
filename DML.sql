use GestionDeEntradas;
go

-- ORGANIZADORES

insert into organizador (cuit, nombre, apellido, telefono, email)
values
('20-12345678-6', 'Martin', 'Lopez', '1155551001', 'martin@gmail.com'),
('27-23456789-0', 'Laura', 'Perez', '1155551002', 'laura@gmail.com'),
('20-34567890-8', 'Diego', 'Gomez', '1155551003', 'diego@egmail.com'),
('27-45678901-4', 'Carolina', 'Diaz', '1155551004', 'carolina@gmail.com'),
('20-56789012-5', 'Pablo', 'Torres', '1155551005', 'pablo@gmail.com');
go

-- LUGARES

insert into lugar (nombre_lugar, direccion, capacidad)
values
('Teatro Sonrisas', 'Av. Corrientes 1500', 500),
('Estadio de la B', 'Av. Libertador 2500', 5000),
('Centro Cultural', 'Av. San Juan 800', 300),
('Salon de eventos Victor', 'Av. Santa Fe 3200', 200),
('Auditorio Municipal', 'Belgrano 450', 800);
go

-- EVENTOS

insert into evento (id_organizador, id_lugar, nombre_evento, fecha, hora_inicio, hora_fin, estado)
values
(1, 1, 'Noche de Rock', '20261110', '20:00', '23:00', 'ACTIVO'),
(1, 2, 'Festival de Musica', '20261115', '16:00', '23:00', 'ACTIVO'),
(2, 3, 'Feria del Libro', '20261120', '10:00', '18:00', 'ACTIVO'),
(3, 1, 'Obra de Teatro', '20261010', '19:00', '21:00', 'FINALIZADO'),
(4, 4, 'Charla de Tecnologia', '20261125', '17:00', '20:00', 'ACTIVO');
go

--CLIENTES

insert into cliente (nombre, apellido, email)
values
('Juan', 'Garcia', 'juan@gmail.com'),
('Ana', 'Martinez', 'ana@gmail.com'),
('Lucas', 'Fernandez', 'lucas@gmail.com'),
('Sofia', 'Rodriguez', 'sofia@gmail.com'),
('Pedro', 'Sanchez', 'pedro@gmail.com');
go

--COMPRAS

insert into compra (id_cliente, fecha, total, estado_pago)
values
(1, '20261015', 30000, 'PAGADO'),
(1, '20261016', 25000, 'PAGADO'),
(1, '20261017', 5000, 'PENDIENTE'),
(2, '20261018', 50000, 'PAGADO'),
(2, '20261019', 15000, 'CANCELADO'),
(3, '20261005', 24000, 'PAGADO'),
(4, '20261020', 25000, 'PENDIENTE'),
(4, '20261021', 5000, 'PAGADO');
go

--ENTRADAS

insert into entrada (id_compra, id_evento, codigo, precio, estado)
values
(1, 1, 'ENT001', 15000, 'HABILITADA'),
(1, 1, 'ENT002', 15000, 'HABILITADA'),
(2, 2, 'ENT003', 25000, 'HABILITADA'),
(3, 3, 'ENT004', 5000, 'ANULADA'),
(4, 2, 'ENT005', 25000, 'HABILITADA'),
(4, 2, 'ENT006', 25000, 'HABILITADA'),
(5, 1, 'ENT007', 15000, 'ANULADA'),
(6, 4, 'ENT008', 12000, 'UTILIZADA'),
(6, 4, 'ENT009', 12000, 'UTILIZADA'),
(7, 2, 'ENT010', 25000, 'ANULADA'),
(8, 3, 'ENT011', 5000, 'HABILITADA');
go