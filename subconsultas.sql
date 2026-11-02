-- Subconsulta 1
-- Clientes cuyo gasto confirmado supera el gasto promedio
-- por cliente del sistema.

SELECT c.id_cliente,
       c.nombre,
       c.apellido,
       c.email,
       SUM(co.total) AS gasto_total
FROM cliente AS c
INNER JOIN compra AS co
    ON c.id_cliente = co.id_cliente
WHERE co.estado_pago = 'PAGADO'
GROUP BY c.id_cliente, c.nombre, c.apellido, c.email
HAVING SUM(co.total) > (
        SELECT AVG(gastos.gasto)
        FROM (SELECT SUM(total) AS gasto
              FROM compra
              WHERE estado_pago = 'PAGADO'
              GROUP BY id_cliente) AS gastos
      )
ORDER BY gasto_total DESC;