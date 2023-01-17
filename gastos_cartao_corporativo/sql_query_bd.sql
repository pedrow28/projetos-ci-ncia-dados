WITH inflacao1 AS (
  SELECT
    ano,
    mes,
    indice / 2085.68 as indice_ajustado
  FROM `basedosdados.br_ibge_ipca.mes_brasil`
  where ano >= 2003
  order by ano desc, mes desc
),
inflacao2 AS (
  SELECT
    ano,
    mes,
    indice,
    6474.09/indice  as indice_ajustado
  FROM `basedosdados.br_ibge_ipca.mes_brasil`
  where ano >= 2003
  order by ano desc, mes desc
),
despesas as (
  SELECT 
    ano,
    EXTRACT(MONTH FROM data_pagamento) as mes_despesa,
    valor
    FROM `basedosdados.br_sgp_informacao.despesas_cartao_corporativo` as despesas
)
SELECT
  a.*,
  inflacao1.indice_ajustado,
  inflacao2.indice_ajustado as indice_hist_ajustado,
  despesas.valor / inflacao1.indice_ajustado as valor_ajustado,
  despesas.valor * inflacao2.indice_ajustado as valor_hist_ajustado,
FROM despesas
INNER JOIN inflacao1 on inflacao1.ano = despesas.ano and inflacao1.mes = despesas.mes_despesa
INNER JOIN inflacao2 on inflacao2.ano = despesas.ano and inflacao2.mes = despesas.mes_despesa
INNER JOIN `basedosdados.br_sgp_informacao.despesas_cartao_corporativo` a on a.ano = despesas.ano and EXTRACT(MONTH FROM a.data_pagamento) = despesas.mes_despesa and a.valor = despesas.valor
order by valor_hist_ajustado desc