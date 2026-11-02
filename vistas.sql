USE GestionDeEntradas;
GO

-- vw_ocupacion_evento
-- Ocupación y cupo disponible de cada evento, según la regla 11.

CREATE VIEW vw_ocupacion_evento AS
SELECT ev.id_evento,
       ev.nombre_evento,
       ev.fecha,
       ev.estado                                        AS estado_evento,
       l.nombre_lugar,
       l.capacidad,
       ISNULL(oc.entradas_ocupadas, 0)                  AS entradas_ocupadas,
       l.capacidad - ISNULL(oc.entradas_ocupadas, 0)    AS cupo_disponible
FROM evento AS ev
INNER JOIN lugar AS l
    ON ev.id_lugar = l.id_lugar
LEFT JOIN (SELECT en.id_evento,
                  COUNT(*) AS entradas_ocupadas
           FROM entrada AS en
           INNER JOIN compra AS co
               ON en.id_compra = co.id_compra
           WHERE en.estado <> 'ANULADA'
             AND co.estado_pago <> 'CANCELADO'
           GROUP BY en.id_evento) AS oc
    ON oc.id_evento = ev.id_evento;
GO

-- vw_compras_detalle
-- Compras con su cliente, total histórico, monto vigente y monto anulado.

CREATE VIEW vw_compras_detalle AS
SELECT co.id_compra,
       co.fecha,
       c.id_cliente,
       c.nombre,
       c.apellido,
       c.email,
       co.estado_pago,
       co.total                     AS total_historico,
       v.monto_vigente,
       co.total - v.monto_vigente   AS monto_anulado
FROM compra AS co
INNER JOIN cliente AS c
    ON co.id_cliente = c.id_cliente
CROSS APPLY (SELECT dbo.fn_monto_vigente_compra(co.id_compra) AS monto_vigente) AS v;
GO

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