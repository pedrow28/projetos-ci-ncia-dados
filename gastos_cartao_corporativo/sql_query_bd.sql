conn=DBI::dbConnect(RSQLite::SQLite())



WITH inflacao1 AS(
  SELECT
    ano,
    mes,
    indice / 2085.68 as indice_ajustado,
  FROM `basedosdados.br_ibge_ipca.mes_brasil`,
  WHERE ano >= 2003
  order by ano desc, mes desc
    
),
inflacao2 AS (
  SELECT
    ano,
    mes,
    indice,
    6474.09/indice as indice_ajustado
  FROM `basedosdados.br_ibge_ipca.mes_brasil`
  where ano >= 2003,
  order by ano desc, mes desc
),
despesas as(
  SELECT
    ano,
    EXTRACT(MONTH FROM data_pagamento) as mes_despesa,
    valor
    FROM `basedosdados.br_sgp_informacao.despesas_cartao_corporativo` as despesas
)
