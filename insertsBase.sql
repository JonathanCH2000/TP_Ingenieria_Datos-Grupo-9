use GestionDeEntradas;
go

insert into organizador (cuit, nombre, apellido, telefono, email) values
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
go

insert into lugar (nombre_lugar, direccion, capacidad) values
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
go

insert into evento (id_organizador, id_lugar, nombre_evento, fecha, hora_inicio, hora_fin, estado) values
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
go

insert into cliente (nombre, apellido, email) values
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
go

insert into compra (id_cliente, fecha, total, estado_pago) values
(1, '20260720 10:15:00', 45000.00, 'PAGADO'),
(2, '20260725 18:40:00', 45000.00, 'PAGADO'),
(3, '20260820 09:30:00', 28000.00, 'PAGADO'),
(4, '20260828 21:10:00', 28000.00, 'CANCELADO'),
(5, '20260901 16:45:00', 32000.00, 'PAGADO'),
(1, '20261005 19:00:00', 25000.00, 'PAGADO'),
(6, '20261012 22:30:00', 38000.00, 'PAGADO'),
(7, '20261020 14:00:00', 18000.00, 'PAGADO'),
(8, '20261022 20:15:00', 18000.00, 'PAGADO'),
(2, '20261027 12:40:00', 52000.00, 'PENDIENTE'),
(1, '20261029 11:20:00', 42000.00, 'PAGADO'),
(1, '20261030 18:05:00', 22000.00, 'PAGADO');
go

insert into entrada (id_compra, id_evento, codigo, precio, estado) values
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
go