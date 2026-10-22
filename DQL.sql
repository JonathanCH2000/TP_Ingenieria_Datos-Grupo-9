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
