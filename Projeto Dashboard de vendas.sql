-- (Query 1) Receita, leads, conversão e ticket médio mês a mês
-- Colunas: mês, leads (#), vendas (#), receita (k, R$), conversão (%), ticket médio (k, R$)


-- Mês e Leads

select
	extract(month from paid_date) as mes, 
	count(visit_page_date) as Contagem_Leads
from sales.funnel
where (extract(month from paid_date)) is not null
group by extract(month from paid_date)
order by mes 

-- Vendas

select 
	--pro.price as "Preço",
	--ABS(fun.discount) as "Desconto",
	extract(month from fun.paid_date) as mes, 
	count(fun.visit_page_date) as contagem_Leads,
	pro.price - (pro.price * ABS(fun.discount)) as venda_valor
from sales.products as pro
left join sales.funnel as fun
on pro.product_id = fun.product_id
where (extract(month from paid_date)) is not null
group by mes, venda_valor
order by mes








-- (Query 2) Estados que mais venderam
-- Colunas: país, estado, vendas (#)


-- (Query 3) Marcas que mais venderam no mês
-- Colunas: marca, vendas (#)


-- (Query 4) Lojas que mais venderam
-- Colunas: loja, vendas (#)


-- (Query 5) Dias da semana com maior número de visitas ao site
-- Colunas: dia_semana, dia da semana, visitas (#)
