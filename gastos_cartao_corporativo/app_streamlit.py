import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.figure_factory as ff




### Importando os dados

## dados em https://drive.google.com/file/d/19_HAxk_4dcikni7fS-xZvMVGsstCxuaT/view?usp=share_link

### Limpando os dados

st.set_page_config(page_title="Gastos Cartões Corporativos", page_icon="💸", layout="wide"  )

#, layout="wide"

@st.cache
def get_data():

    data_id = pd.read_feather("feather_data_id")

    df = data_id.drop_duplicates(subset=["id"])
    
    ## Corrigindo palavras
    
    df["subelemento_despesa"] = df["subelemento_despesa"].str.replace("LOCAAÃO ", "LOCAÇÃO")
    
    df["subelemento_despesa"] = df["subelemento_despesa"].str.replace("ALIMENTAAÃO", "ALIMENTAÇÃO")
    
    return df
 
data = get_data()


########################



st.title("Gastos Cartão Corporativo 💸")




##TODO: Inserir imagem ilustrativa

## TODO: Paragrafo de atualização de novos gastos

SUBELEMENTOS = data["subelemento_despesa"].unique()

PRESIDENTES = ["Lula", "Dilma", "Temer", "Bolsonaro"]

ANOS = data["ano"].unique()



## Sidebar



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

Para este aplicativo, este ajuste foi feito utilizando uma [query](https://github.com/pedrow28/projetos-ciencia-dados/blob/main/gastos_cartao_corporativo/nova_query.sql) 
em SQL desenvolvida na comunidade de programadores da [Base dos Dados](https://basedosdados.org/quem-somos), organização não-governamental e 
_open-source_ que atua para universalizar dados de qualidade.

Os índices de inflação utilizados para correção dos preços também foram buscados em repositório da Base dos Dados 
que pode ser acessado [aqui](https://basedosdados.org/dataset/br-ibge-ipca?bdm_table=mes_brasil).


"""

st.markdown("## Visão geral dos gastos")

"""

O gráfico abaixo apresenta a evolução geral dos gastos no cartão corpotativo entre 2003 e 2022. É possível passar o mouse em cima de cada
coluna para ver mais detalhes.

"""

### Querys para formatar a informacao

### query = f"presidente=='{presidente}' & subelemento_despesa=='{tipo_gasto}'"
### df_filtered = data.query(query)




sum_by_year = data.groupby(['ano', 'presidente']).valor_hist_ajustado.sum()





fig = px.bar(sum_by_year.reset_index(), x="ano",
             y="valor_hist_ajustado",
             color='presidente',
             title="Gastos do cartão corporativo entre 2003 e 2022 <br><sup> Valores atualizados pela inflação (R$)</sup>",
             labels={
                 "ano": "Ano",
                 "valor_hist_ajustado": "Valor ajustado pela inflação (R$)",
                 "presidente": "Presidente"
             })

fig.update_layout(yaxis=(dict(visible=True,
                              title="")))
st.plotly_chart(fig, use_container_width=True)

## TODO: formatar valores ()
## TODO: Layout gráfico


st.markdown("## Maiores gastos por presidente")

##TODO: fazer média por ano de mandato

left_column, right_column = st.columns(2)

with left_column:
    presidente_1 = st.selectbox(label = "Presidente", options=PRESIDENTES)
    

query_maiores_gastos = f"presidente == @presidente_1"

df_filtro_maiores_gastos = data.query(query_maiores_gastos)

maiores_gastos_presidente = df_filtro_maiores_gastos.groupby(['subelemento_despesa']).valor_hist_ajustado.sum().sort_values(ascending=True).tail()


fig2 = px.bar(maiores_gastos_presidente.reset_index(), y = "subelemento_despesa",
              x = "valor_hist_ajustado",
              title = f"Principais gastos - Presidente {presidente_1} <br><sup>Agrupados por subelemento de despesa</sup>",
              orientation="h",
              labels={
                 "valor_hist_ajustado": "Valor ajustado pela inflação (R$)",
                 "subelemento_despesa": "Tipo de despesa"
             })
fig2.update_layout(yaxis=(dict(title="")))
st.plotly_chart(fig2, use_container_width=True)

  

st.markdown("## Gastos por presidente e tipo de despesa")

left_column, right_column = st.columns(2)


with left_column:
    presidente_2 = st.multiselect(label = "Escolha um presidente", options=PRESIDENTES, default=PRESIDENTES)
    
with right_column:
    elemento_despesa1 = st.selectbox(label = "Escolha um tipo de despesa", options=sorted(SUBELEMENTOS))
    
query_filtro_presid_despesa = f"presidente == @presidente_2 & subelemento_despesa == @elemento_despesa1"

df_presid_despesa = data.query(query_filtro_presid_despesa)

## TODO: Mudar nomes variáveis

gastos_filtro_presid_elemento = df_presid_despesa.groupby(['ano', 'presidente']).valor_hist_ajustado.sum()

## TODO: colocar titulo com f string para indicar subelemento despesa

fig3 = px.bar(gastos_filtro_presid_elemento.reset_index(), x = "ano",
              y = "valor_hist_ajustado",
              color = "presidente")

st.plotly_chart(fig3, use_container_width=True)



st.markdown("## Comparação presidentes")

st.markdown("Os gráficos abaixo comparam os gastos, por ano, de dois presidentes em determinado tipo de despesa.")

left_column, right_column = st.columns(2)

with left_column:
    comp_presidente_1 = st.selectbox(label = "Presidente 1", options=PRESIDENTES)
    comp_despesa_1 = st.selectbox(label = "Despesa 1", options=sorted(SUBELEMENTOS))
    
    query_comparativo1 = f"presidente == @comp_presidente_1 & subelemento_despesa== @comp_despesa_1"
    
    df_comp1 = data.query(query_comparativo1)
    
    ## TODO: Melhorar isso aqui - puxar o valor final da média para imprimir
    
    ## TODO: Mudar para ficar com mesmo eixo y, utilizar funcao max entre Df comps 1 e 2
    
    grouped_comp1 = df_comp1.groupby(['ano']).valor_hist_ajustado.sum().reset_index()
    
    media1 = grouped_comp1.mean()
    
    ## TODO: descobrir como multistring para o titulo do grafico
    
    figcomp1 = px.bar(df_comp1.groupby(['ano']).valor_hist_ajustado.sum().reset_index(),
                      x="ano",
                      y="valor_hist_ajustado",
                      title = f"Gastos - Presidente {comp_presidente_1} com {comp_despesa_1}  <br><sup>A média foi de {media1}</sup>")

    st.plotly_chart(figcomp1, use_container_width=True) 

with right_column:
    comp_presidente_2 = st.selectbox(label = "Presidente 2", options=PRESIDENTES)
    comp_despesa_2 = st.selectbox(label = "Despesa 2", options=sorted(SUBELEMENTOS))
    
    query_comparativo2 = f"presidente == @comp_presidente_2 & subelemento_despesa == @comp_despesa_2"
    
    df_comp2 = data.query(query_comparativo2)
    
    figcomp2 = px.bar(df_comp2.groupby(['ano']).valor_hist_ajustado.sum().reset_index(),
                      x="ano",
                      y="valor_hist_ajustado",
                      title = f"Gastos - Presidente {comp_presidente_2} com {comp_despesa_2}")
    
## TODO: Adicionar labels nas colunas

## TODO: Customizar site

    st.plotly_chart(figcomp2, use_container_width=True) 
                                  
                                  
                            



st.markdown("## Informações técnicas")

"""
O presente aplicativo foi construído por meio da biblioteca [Streamlit](https://docs.streamlit.io/) da 
linguagem de programação [Python](https://www.python.org/) e hospedado por meio do [Heroku](https://www.heroku.com/).

O código completo pode ser encontrado [aqui](https://github.com/pedrow28/projetos-ciencia-dados/blob/main/gastos_cartao_corporativo/app_streamlit.py).

Encontrou algum erro ou possui alguma sugestão? Entre em [contato](mailto:pedrowilliamrd@gmail.com)!

"""

## TODO: inserie imagens para link linkedin e github


###### CÓDIGO FONTE 