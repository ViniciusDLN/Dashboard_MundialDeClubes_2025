![Visão geral do Dashboard de Futebol](<https://imgur.com/a/yZxp7YD>)

**Dashboard de Análise do Mundial de Clubes 2025**

**Resumo do Projeto**

Este projeto é um estudo de caso prático focado na Análise e Visualização de Dados. O objetivo foi transformar dados brutos de um campeonato de futebol em um dashboard interativo no Power BI, que permite uma análise detalhada sobre o desempenho de times e jogadores.

A criação deste dashboard demonstrou a capacidade de realizar todo o ciclo de vida de um projeto de Business Intelligence, desde a extração e tratamento dos dados até a apresentação final.

**Ferramentas e Tecnologias**

**SQL Server**: Utilizado para a criação da base de dados, modelagem, limpeza e transformação dos dados.

**Power BI**: Ferramenta principal para a modelagem de dados, criação de métricas analíticas e visualização interativa.

**Linguagem DAX**: Essencial para a criação de métricas dinâmicas e cálculos avançados, como a contagem de vitórias, derrotas, empates e a média de gols.

**Metodologia**

**1. Aquisição e Tratamento de Dados (ETL)**

Os dados foram importados de um arquivo Excel para o SQL Server. Para garantir a integridade, foi necessário criar tabelas temporárias (Jogos_Temp, Gols_Temp) com formato de texto (NVARCHAR). Em seguida, utilizando a função TRY_CAST e cláusulas CASE no SQL, os dados foram convertidos para seus respectivos tipos (INT, DATE, TIME, BIT), eliminando valores nulos e garantindo a qualidade.

**2. Modelagem de Dados**

No Power BI, as tabelas (Jogos, Time, Gols) foram conectadas através de relacionamentos de chave primária e estrangeira (ID_Jogo, Time_One_ID, Time_Two_ID). Para que os filtros funcionassem corretamente para todos os times, foi criada uma tabela de dimensão (Time) e uma relação inativa, ativada por meio de funções DAX.

**3. Análise e Visualização**

A análise foi construída com base em métricas-chave do jogo de futebol. Utilizando a linguagem DAX, foram criadas as seguintes medidas:

**Totais**: TOTAL GOLS, TOTAL PARTIDAS

**Resultados**: Vitorias, Derrotas, Empates

**Média**: Média de Gols por Partida

O dashboard foi projetado com uma estética clean e com foco na usabilidade, permitindo que qualquer pessoa explore os dados de forma intuitiva.

**Destaques do Projeto**

**Análise Dinâmica**: As métricas se ajustam em tempo real aos filtros do usuário, permitindo uma análise por fase da competição, time ou jogador.

**Design**: Layout profissional com paleta de cores consistente e bordas arredondadas.

**SQL e DAX**: Demonstração prática da interconexão entre SQL para o tratamento dos dados e DAX para a inteligência analítica.

**Como Visualizar o Projeto**

Você pode ver a versão completa e interativa deste dashboard apenas manualmente.

**Autor**
Vinicus Lacerda