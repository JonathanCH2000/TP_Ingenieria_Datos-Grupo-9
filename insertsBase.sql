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
(3, 3, 'Electro Night', '20260920', '23:00', '05:00', 'FINALIZADO'),
(4, 4, 'Jazz en la Trastienda', '20261010', '21:00', '23:00', 'ACTIVO'),
(5, 5, 'Festival Indie 2026', '20261114', '18:00', '23:59', 'ACTIVO'),
(6, 6, 'Opera Popular', '20261121', '20:00', '22:30', 'ACTIVO'),
(7, 7, 'Acustico Intimo', '20261128', '21:00', '22:30', 'ACTIVO'),
(8, 8, 'Tango Joven', '20261205', '21:30', '23:30', 'ACTIVO'),
(9, 9, 'Noche de Boleros', '20261212', '21:00', '23:00', 'ACTIVO'),
(1, 2, 'Gala Sinfonica', '20261219', '20:00', '22:00', 'ACTIVO');
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
(1, '2026-10-05T19:00:00', 25000.00, 'PENDIENTE'),
(6, '2026-10-12T22:30:00', 38000.00, 'PAGADO'),
(7, '2026-10-20T14:00:00', 18000.00, 'PAGADO'),
(8, '2026-10-22T20:15:00', 18000.00, 'PAGADO'),
(2, '2026-10-27T12:40:00', 52000.00, 'PENDIENTE');
GO


INSERT INTO entrada (id_compra, id_evento, codigo, precio, estado) VALUES
(1, 1, 'ENT-0001', 45000.00, 'UTILIZADA'),
(2, 1, 'ENT-0002', 45000.00, 'HABILITADA'),
(3, 2, 'ENT-0003', 28000.00, 'UTILIZADA'),
(4, 2, 'ENT-0004', 28000.00, 'ANULADA'),
(5, 3, 'ENT-0005', 32000.00, 'UTILIZADA'),
(6, 4, 'ENT-0006', 25000.00, 'HABILITADA'),
(7, 5, 'ENT-0007', 38000.00, 'HABILITADA'),
(8, 7, 'ENT-0008', 18000.00, 'HABILITADA'),
(9, 7, 'ENT-0009', 18000.00, 'HABILITADA'),
(10, 6, 'ENT-0010', 52000.00, 'HABILITADA');
GO

