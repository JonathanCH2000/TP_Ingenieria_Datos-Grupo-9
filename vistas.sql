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