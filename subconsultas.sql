use GestionDeEntradas;
go

--Subconsulta 1: clientes cuyo ticket promedio supera el ticket promedio del sistema
select c.id_cliente, c.nombre, c.apellido, c.email,
count(co.id_compra) as cantidad_compras,
avg(co.total) as ticket_promedio
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
where co.estado_pago = 'PAGADO'
group by c.id_cliente, c.nombre, c.apellido, c.email
having avg(co.total) > (select avg(total) from compra where estado_pago = 'PAGADO')
order by ticket_promedio desc;
go

--Subconsulta 2: eventos que no registran ninguna entrada vendida
select e.id_evento, e.nombre_evento, e.fecha, e.estado, l.nombre_lugar
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
where not exists (select 1 from entrada as en where en.id_evento = e.id_evento)
order by e.fecha;
go

--Subconsulta 3: compras cuyo importe supera el promedio de ese mismo cliente
select c.id_cliente, c.nombre, c.apellido, co.id_compra, co.fecha, co.total, co.estado_pago
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente
where co.total > (select avg(co2.total) from compra as co2 where co2.id_cliente = co.id_cliente)
order by c.apellido, co.total desc;
go

--Subconsulta 4: entradas cuyo precio supera el precio promedio de todas las entradas
select en.id_entrada, en.codigo, en.precio, ev.nombre_evento, ev.fecha
from entrada as en
join evento as ev
on en.id_evento = ev.id_evento
where en.precio > (select avg(precio) from entrada)
order by en.precio desc;
go