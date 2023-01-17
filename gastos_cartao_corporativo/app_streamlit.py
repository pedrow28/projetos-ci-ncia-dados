import streamlit as st
import pandas as pd


### Importando os dados

## dados em https://drive.google.com/file/d/19_HAxk_4dcikni7fS-xZvMVGsstCxuaT/view?usp=share_link

### Limpando os dados

data = pd.read_feather("cleaned_feather_data")

st.title("Gastos Cartão Corporativo")

SUBELEMENTOS = data["subelemento_despesa"].unique()

PRESIDENTES = ["Lula", "Dilma", "Temer", "Bolsonaro"]

## Sidebar

with st.sidebar:
    st.selectbox(label = "Presidentes", options=PRESIDENTES)
    st.selectbox(label = "Tipo gasto", options=SUBELEMENTOS)

st.markdown("## Introdução")

"""
Nos últimos dias, repercutiu na mídia a divulgação do detalhamento de [gastos em cartões corporativos da 
Presidência da República](https://g1.globo.com/politica/noticia/2023/01/12/veja-a-lista-completa-de-gastos-do-cartao-corporativo-de-bolsonaro-liberada-pelo-governo-federal.ghtml).

Assim, no intuito de melhor organizar a pesquisa e visualização dos dados disponibilizados, este aplicativo
foi construído para sanear as informações e disponibilizar filtros e  visualizações mais acessíveis. 

## Alguns esclarecimentos

Antes, porém, alguns esclarecimentos sobre o tratamento dos dados e este aplicativo são necessários.

**A disponibilização dos dados do gasto do cartão corporativo foi possível por iniciativa da [Fiquem Sabendo](fiquemsabendo.com.br/quem-somos-contato),
agência de dados independentes e especializada na [Lei de Acesso à Informação (LAI)](https://www.gov.br/capes/pt-br/acesso-a-informacao/servico-de-informacao-ao-cidadao/sobre-a-lei-de-acesso-a-informacao).**

A Fiquem Sabendo, por meio do pedido de informação protocolo [00137.019649/2022-72](https://drive.google.com/file/d/1nLaRgJ4ynY4LoBNDDrEQXic3lzucqKPs/view),
recebeu da Secretaria-Geral da Presidência da República os dados dos gastos do cartão corporativo.
Com isso, os gastos dos ex-presidentes podem ser acessados [neste link](https://www.gov.br/secretariageral/pt-br/acesso-a-informacao/informacoes-classificadas-e-desclassificadas).


## Tratamento dos dados

Dado o grande período de tempo dos dados, qualquer comparação feita **deve levar em conta o ajuste dos preços
a partir da inflação do período**. 

Para este aplicativo, este ajuste foi feito utilizando uma [query](https://github.com/pedrow28/projetos-ciencia-dados/blob/main/gastos_cartao_corporativo/sql_query_bd.sql) 
em SQL desenvolvida na comunidade de programadores da [Base dos Dados](https://basedosdados.org/quem-somos), organização não-governamental e 
_open-source_ que atua para universalizar dados de qualidade.

Os índices de inflação utilizados para correção dos preços também foram buscados em repositório da Base dos Dados 
que pode ser acessado [aqui](https://basedosdados.org/dataset/br-ibge-ipca?bdm_table=mes_brasil).


"""

st.markdown("Visão geral dos gastos")
