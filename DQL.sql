use GestionDeEntradas;
go

--Eventos activos y el lugar de realizacion.

select e.id_evento, e.nombre_evento, e.fecha,e.hora_inicio,e.hora_fin, l.nombre_lugar, l.direccion
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
where e.estado = 'ACTIVO'
order by e.fecha, e.hora_inicio;
go

--Contacto del organizador de un evento
select e.nombre_evento, o.nombre, o.apellido,o.telefono, o.email
from evento as e
join organizador as o
on e.id_organizador = o.id_organizador
go

--Consultar las compras
select id_compra, fecha, total, estado_pago
from compra
order by fecha desc;
go

-- Muestra las compras pendientes y los datos del cliente
select co.id_compra, co.fecha, co.total,c.nombre, c.apellido, c.email, co.estado_pago
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente
where co.estado_pago = 'PENDIENTE'
order by co.fecha;
go


--Entradas utilizadas de un evento.
select e.id_evento, e.nombre_evento, count(en.id_entrada) as entradas_utilizadas
from entrada as en
join evento as e
on en.id_evento = e.id_evento
where en.estado = 'UTILIZADA'
group by e.id_evento, e.nombre_evento;
go

--Recaudacion por evento
select e.id_evento, e.nombre_evento, count(en.id_entrada) as entradas_vendidas, sum(en.precio) as recaudacion
from evento as e
join entrada as en
on e.id_evento = en.id_evento
join compra as co
on en.id_compra = co.id_compra
where co.estado_pago = 'PAGADO' and en.estado <> 'ANULADA'
group by e.id_evento, e.nombre_evento
order by recaudacion desc;
go

--Clientes frecuentes (mas de dos compras pagadas)
select c.id_cliente, c.nombre, c.apellido, c.email, count(co.id_compra) as compras_pagadas
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
where co.estado_pago = 'PAGADO'
group by c.id_cliente, c.nombre, c.apellido, c.email
having count(co.id_compra) > 2;
go