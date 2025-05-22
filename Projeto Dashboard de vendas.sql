-- (Query 1) Receita, leads, conversão e ticket médio mês a mês
-- Colunas: mês, leads (#), vendas (#), receita (k, R$), conversão (%), ticket médio (k, R$)

-- CORREÇÃO --

with
	leads as (
		select 
			date_trunc('month', visit_page_date)::date as visit_page_month,
			-- utilizando date_trunc para selecionar o mês e ::date para remover a hora.
			count (*) as visit_page_count
		from sales.funnel
		group by visit_page_month
		order by visit_page_count desc
	),
	payments as (
		select
			date_trunc('month', fun.paid_date)::date as paid_month,
			-- poderia usar também "extract(month from paid_date) as mes"
			count(fun.paid_date) as paid_count,
			sum(pro.price * (1+fun.discount)) as receita
		from sales.funnel as  fun
		left join sales.products as pro
			on fun.product_id = pro.product_id
		where fun.paid_date is not null
		group by paid_month
	)

select
	leads.visit_page_month as "Mês",
	leads.visit_page_count as "Leads",
	payments.paid_count as "vendas (#)",
	(payments.receita/1000) as "receita (k, R$)",
	(payments.paid_count::float/leads.visit_page_count::float) as "conversão (%)",
	(payments.receita/payments.paid_count/1000) as "ticket médio (k, R$)"
from leads
left join payments
	on leads.visit_page_month = paid_month

------------------------------------------------------------------------------------------------------


-- (Query 2) Estados que mais venderam
-- Colunas: país, estado, vendas (#)

select
	'Brazil' as país,
	cus.state as estado,
	count(fun.paid_date) as "Vendas(#)"
from sales.funnel as fun
left join sales.customers as cus
	on fun.customer_id = cus.customer_id
where fun.paid_date between '2021-08-01' and '2021-08-31'
group by país, estado
order by "Vendas(#)" desc
limit 5

-- (Query 3) Marcas que mais venderam no mês
-- Colunas: marca, vendas (#)

select 
	pro.brand as marca,
	count(fun.paid_date) as "vendas (#)"
from sales.products as pro
left join sales.funnel as fun
	on pro.product_id = fun.product_id
where paid_date between '2021-08-01' and '2021-08-31'
group by pro.brand
order by "vendas (#)" desc
limit 5


-- (Query 4) Lojas que mais venderam
-- Colunas: loja, vendas (#)

select 
	sto.store_name as loja,
	count(fun.paid_date) as "vendas (#)"
from sales.funnel as  fun
left join sales.stores as sto
	on fun.store_id = sto.store_id
where paid_date between '2021-08-01' and '2021-08-31'
group by loja
order by "vendas (#)" desc
limit 5


-- (Query 5) Dias da semana com maior número de visitas ao site
-- Colunas: dia_semana, dia da semana, visitas (#)

select 
	extract('dow' from visit_page_date) as dia_semana,
	case 
		when extract('dow' from visit_page_date)=0 then 'Domingo'
		when extract('dow' from visit_page_date)=1 then 'Segunda'
		when extract('dow' from visit_page_date)=2 then 'Terça'
		when extract('dow' from visit_page_date)=3 then 'Quarta'
		when extract('dow' from visit_page_date)=4 then 'Quinta'
		when extract('dow' from visit_page_date)=5 then 'Sexta'
		when extract('dow' from visit_page_date)=6 then 'Sábado' 
	else null end as "dia da semana",
	count(*) as "visitas (#)"
from sales.funnel
where visit_page_date between '2021-08-01' and '2021-08-31'
group by dia_semana
order by "visitas (#)" desc



