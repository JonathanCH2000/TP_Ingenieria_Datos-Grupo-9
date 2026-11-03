USE GestionDeEntradas;
GO

--Vista 1: ocupacion de cada evento segun la capacidad del lugar
create view vw_ocupacion_evento as
select e.id_evento, e.nombre_evento, e.fecha, l.nombre_lugar, l.capacidad,
       count(en.id_entrada) as entradas_vendidas,
       l.capacidad - count(en.id_entrada) as cupo_disponible
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
left join entrada as en
on e.id_evento = en.id_evento and en.estado <> 'ANULADA'
group by e.id_evento, e.nombre_evento, e.fecha, l.nombre_lugar, l.capacidad;
go

--Vista 2: compras con el cliente y el monto que sigue vigente
create view vw_compras_detalle as
select co.id_compra, co.fecha, co.estado_pago, c.nombre, c.apellido,
       co.total,
       dbo.fn_monto_vigente_compra(co.id_compra) as monto_vigente,
       co.total - dbo.fn_monto_vigente_compra(co.id_compra) as monto_anulado
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente;
go

-- vw_entradas_habilitadas
-- Entradas que cumplen las tres condiciones de ingreso.

CREATE VIEW vw_entradas_habilitadas AS
SELECT en.id_entrada,
       en.codigo,
       en.precio,
       ev.id_evento,
       ev.nombre_evento,
       ev.fecha,
       ev.hora_inicio,
       l.nombre_lugar,
       co.id_compra,
       c.id_cliente,
       c.nombre    AS nombre_cliente,
       c.apellido  AS apellido_cliente
FROM entrada AS en
INNER JOIN compra AS co
    ON en.id_compra = co.id_compra
INNER JOIN evento AS ev
    ON en.id_evento = ev.id_evento
INNER JOIN lugar AS l
    ON ev.id_lugar = l.id_lugar
INNER JOIN cliente AS c
    ON co.id_cliente = c.id_cliente
WHERE en.estado    = 'HABILITADA'
  AND co.estado_pago = 'PAGADO'
  AND ev.estado    = 'ACTIVO';
GO

-- vw_recaudacion_organizador
-- Facturación acumulada por organizador, considerando únicamente ventas confirmadas.

CREATE VIEW vw_recaudacion_organizador AS
SELECT o.id_organizador,
       o.cuit,
       o.nombre,
       o.apellido,
       COUNT(DISTINCT ev.id_evento)           AS eventos_organizados,
       ISNULL(SUM(vt.entradas_vendidas), 0)   AS entradas_vendidas,
       ISNULL(SUM(vt.recaudacion), 0)         AS recaudacion
FROM organizador AS o
LEFT JOIN evento AS ev
    ON ev.id_organizador = o.id_organizador
LEFT JOIN (SELECT en.id_evento,
                  COUNT(*)       AS entradas_vendidas,
                  SUM(en.precio) AS recaudacion
           FROM entrada AS en
           INNER JOIN compra AS co
               ON en.id_compra = co.id_compra
           WHERE co.estado_pago = 'PAGADO'
             AND en.estado <> 'ANULADA'
           GROUP BY en.id_evento) AS vt
    ON vt.id_evento = ev.id_evento
GROUP BY o.id_organizador, o.cuit, o.nombre, o.apellido;
GO