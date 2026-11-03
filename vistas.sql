use GestionDeEntradas;
go

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
select co.id_compra, co.fecha, co.estado_pago, c.nombre, c.apellido, co.total,
dbo.fn_monto_vigente_compra(co.id_compra) as monto_vigente,
co.total - dbo.fn_monto_vigente_compra(co.id_compra) as monto_anulado
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente;
go

--Vista 3: entradas que cumplen las tres condiciones de ingreso
create view vw_entradas_habilitadas as
select en.id_entrada, en.codigo, en.precio, ev.id_evento, ev.nombre_evento, ev.fecha,
ev.hora_inicio, l.nombre_lugar, co.id_compra, c.id_cliente,
c.nombre as nombre_cliente, c.apellido as apellido_cliente
from entrada as en
join compra as co
on en.id_compra = co.id_compra
join evento as ev
on en.id_evento = ev.id_evento
join lugar as l
on ev.id_lugar = l.id_lugar
join cliente as c
on co.id_cliente = c.id_cliente
where en.estado = 'HABILITADA'
and co.estado_pago = 'PAGADO'
and ev.estado = 'ACTIVO';
go

--Vista 4: recaudacion total por organizador
create view vw_recaudacion_organizador as
select o.id_organizador, o.nombre, o.apellido,
count(en.id_entrada) as entradas_vendidas,
sum(en.precio) as recaudacion
from organizador as o
join evento as e
on o.id_organizador = e.id_organizador
join entrada as en
on e.id_evento = en.id_evento
where en.estado <> 'ANULADA'
group by o.id_organizador, o.nombre, o.apellido;
go