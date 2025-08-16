-- Primeiramente criei a tabela Time onde contém todos os times que participaram da copa do mundo de clubes
-- Esta tabela atua como um 'dicionário' para os times, por isso o ID é a chave primária (PRIMARY KEY) e o Nome_Time é único (UNIQUE).
CREATE TABLE Time
(
id INT PRIMARY KEY, -- O campo 'id' é a chave primária, garantindo que cada time tenha um identificador único.
Nome_Time NVARCHAR(50) NOT NULL UNIQUE, -- O nome do time é obrigatório (NOT NULL) e não pode se repetir (UNIQUE).
País NVARCHAR(50) NOT NULL, -- O país do time é um campo obrigatório.
Confederacao NVARCHAR(50) NOT NULL -- A confederação do time é um campo obrigatório.
)


-- Tabela Jogos, que contém todos os jogos do mundial de clubes, organizados por Fase de Grupos, Oitavas, Semifinal e Final.
-- As chaves estrangeiras (FOREIGN KEY) conectam esta tabela à tabela 'Time', permitindo a criação de relacionamentos.
CREATE TABLE Jogos
(
ID_Jogo INT PRIMARY KEY, -- O identificador único de cada jogo.
Data DATE NOT NULL, -- Coluna para armazenar a data da partida.
Hora TIME NOT NULL, -- Coluna para armazenar a hora da partida.
Estadio NVARCHAR(50) NOT NULL, -- O nome do estádio é obrigatório.
Time_One_ID INT NOT NULL, -- Chave estrangeira para o ID do primeiro time, obrigatória.
Gols_Time_One tinyint NOT NULL, -- O número de gols é um valor pequeno (TINYINT) e obrigatório.
Time_Two_ID INT NOT NULL, -- Chave estrangeira para o ID do segundo time, obrigatória.
Gols_Time_Two tinyint NOT NULL, -- O número de gols é um valor pequeno (TINYINT) e obrigatório.
Vencedor_ID INT NULL, -- Chave estrangeira para o ID do vencedor. Pode ser nula, pois empates não têm vencedor.
Fase NVARCHAR(50) NOT NULL, -- A fase da competição é um campo obrigatório.
Grupo char(1) NULL, -- O grupo pode ser nulo para as fases de mata-mata.

FOREIGN KEY (Time_One_ID) REFERENCES Time(id), -- A chave estrangeira conecta o Time 1 com a tabela 'Time'.
FOREIGN KEY (Time_Two_ID) REFERENCES Time(id), -- A chave estrangeira conecta o Time 2 com a tabela 'Time'.
FOREIGN KEY (Vencedor_ID) REFERENCES Time(id) -- A chave estrangeira conecta o Vencedor com a tabela 'Time'.
)


-- Tabela Gols, que registra os gols marcados, o time e a partida correspondente.
CREATE TABLE Gols
(
ID_Gol INT PRIMARY KEY, -- O ID do gol é a chave primária e identifica cada gol de forma única.
ID_Jogo INT NOT NULL,
ID_Time INT NULL,
Nome_Jogador NVARCHAR(50) NULL,
Minuto_Gol tinyint NULL, -- O minuto do gol é um valor pequeno (TINYINT) e pode ser nulo.
Gol_Contra bit NULL -- O tipo de dado 'bit' é ideal para valores lógicos (TRUE/FALSE) e otimiza o armazenamento.
)


-- PARTE 2 - A Tabela Temporária foi criada para facilitar a importação de dados, pois o SQL Server aceita valores em formato de texto.

-- A criação de tabelas temporárias com tipo de dado NVARCHAR(50) em todas as colunas é necessária para importar
-- os dados brutos sem erros. Em seguida, a limpeza e conversão são feitas para as tabelas originais.


CREATE TABLE Jogos_Temp
(
ID_Jogo NVARCHAR(50),
Data NVARCHAR(50),
Hora NVARCHAR(50),
Estadio NVARCHAR(50),
Time_One_ID NVARCHAR(50),
Gols_Time_One NVARCHAR(50),
Time_Two_ID NVARCHAR(50),
Gols_Time_Two NVARCHAR(50),
Vencedor_ID NVARCHAR(50),
Fase NVARCHAR(50),
Grupo NVARCHAR(50)
)


CREATE TABLE Gols_Temp
(
ID_Gol NVARCHAR(50),
ID_Jogo NVARCHAR(50), 
ID_Time NVARCHAR(50), 
Nome_Jogador NVARCHAR(50),
Minuto_Gol NVARCHAR(50),
Gol_Contra NVARCHAR(50)
)


-- Este comando 'INSERT INTO ... SELECT' insere e converte os dados da tabela temporária para a tabela final de 'Jogos'.
-- A função TRY_CAST é usada para converter os dados de texto para o formato correto, retornando NULL em caso de erro.
-- O bloco CASE é usado para tratar valores específicos, como '0', e convertê-los para NULL, se necessário.

INSERT INTO Jogos (ID_Jogo,Data,Hora,Estadio,Time_One_ID,Gols_Time_One,Time_Two_ID,Gols_Time_Two,Vencedor_ID,Fase,Grupo)
SELECT

ID_Jogo = TRY_CAST (ID_Jogo AS INT),
Data = TRY_CAST (Data AS DATE),
Hora = TRY_CAST (Hora AS TIME),
Estadio = TRY_CAST (Estadio AS nvarchar(50)),
Time_One_ID = TRY_CAST (Time_One_ID AS INT),
Gols_Time_One = TRY_CAST (Gols_Time_One AS INT),
Time_Two_ID = TRY_CAST (Time_Two_ID AS INT),
Gols_Time_Two = TRY_CAST (Gols_Time_Two AS tinyint),
Vencedor_ID = CASE
                    WHEN TRY_CAST(Vencedor_ID AS INT) = 0 THEN NULL -- Se o vencedor for 0, o valor é convertido para NULL (indicando empate).
                    ELSE TRY_CAST(Vencedor_ID AS INT) -- Caso contrário, o ID do vencedor é inserido.
                  END,
Fase,
Grupo = TRY_CAST(NULLIF(Grupo, '') AS char(1))

FROM
Jogos_Temp


-- Conversão da tabela 'Gols_Temp' para a tabela final 'Gols'.
-- O TRY_CAST é usado para a conversão segura.
-- A cláusula CASE é usada para tratar valores indesejados e convertê-los para NULL (como IDs de 0 ou nomes de jogador em branco).

INSERT INTO Gols (ID_Gol,ID_Jogo,ID_Time,Nome_Jogador,Minuto_Gol,Gol_Contra)
SELECT
ID_Gol = TRY_CAST(ID_Gol AS INT),
ID_Jogo = TRY_CAST(ID_Jogo AS INT),
ID_Time = 
            CASE
            WHEN TRY_CAST(ID_Time AS tinyint) = 0 THEN NULL
            ELSE TRY_CAST(ID_Time AS tinyint)
            END,
Nome_Jogador =
            CASE
            WHEN TRY_CAST(Nome_Jogador AS nvarchar(50)) = ' ' THEN NULL
            ELSE TRY_CAST(Nome_Jogador AS nvarchar(50))
            END,
Minuto_Gol = 
            CASE
            WHEN TRY_CAST(Minuto_Gol AS tinyint) = 0 THEN NULL
            ELSE TRY_CAST(Minuto_Gol AS tinyint)
            END,
                
Gol_Contra = TRY_CAST(Gol_Contra AS bit)
FROM
Gols_Temp


-- Esta consulta retorna a visão completa de todos os jogos, com os nomes dos times em vez de IDs.
-- Os comandos INNER JOIN e LEFT JOIN são usados para combinar dados das tabelas 'Jogos' e 'Time'.
-- O bloco CASE é usado para converter os valores de 'Vencedor' e 'Grupo' em textos mais descritivos.

    SELECT
         J.ID_Jogo,
         J.Data,
         J.Hora,
         J.Estadio,
         one.Nome_Time AS 'Time_One',
         J.Gols_Time_One,
         two.Nome_Time AS 'Time_Two',
         J.Gols_Time_Two,
         -- Bloco CASE para Vencedor
         CASE
             WHEN v.Nome_Time IS NULL THEN 'Empate' -- Se o Vencedor_ID for nulo, a partida foi um empate.
             ELSE v.Nome_Time 
         END AS 'Vencedor',
         J.Fase,
         -- Bloco CASE para Grupo
         CASE
             WHEN j.Grupo IS NULL THEN 'Mata-mata' -- Se o Grupo for nulo, a partida é de uma fase eliminatória.
             ELSE j.Grupo 
         END AS 'Grupo'
     
    FROM
        Jogos AS j
    INNER JOIN Time AS one ON (J.Time_One_ID = one.id) -- Conecta o ID do Time 1 para obter o nome.
    INNER JOIN Time AS two ON (J.Time_Two_ID = two.id) -- Conecta o ID do Time 2 para obter o nome.
    LEFT JOIN Time AS v ON (J.Vencedor_ID = v.id) -- Conecta o ID do vencedor. LEFT JOIN mantém todas as partidas, mesmo se não houver vencedor (empate).


-- Esta consulta retorna os gols contra e suas quantidades, incluindo a fase da competição.
-- O comando GROUP BY é usado para agregar os resultados por jogador e o comando HAVING filtra os grupos com Gol_Contra = 1.

SELECT
    J.ID_Jogo,
    T.Nome_Time,
    G.Nome_Jogador,
    COUNT(G.Gol_Contra) AS QTD_Gol_Contra,
    one.Nome_Time AS 'Time One',
    J.Gols_Time_One,
    two.Nome_Time AS 'Time Two',
    J.Gols_Time_Two,
    J.Fase
FROM
    Gols AS G

INNER JOIN Time AS T ON G.ID_Time = T.id
INNER JOIN Jogos AS J ON G.ID_Jogo = J.ID_Jogo
INNER JOIN Time AS one ON (J.Time_One_ID = one.id)
INNER JOIN Time AS two ON (J.Time_Two_ID = two.id)


GROUP BY
G.Gol_Contra,
G.Nome_Jogador,
T.Nome_Time,
J.Fase,
one.Nome_Time,
J.Gols_Time_One,
two.Nome_Time,
J.Gols_Time_Two,
J.ID_Jogo

HAVING
Gol_Contra = 1 -- A cláusula HAVING filtra apenas os registros onde Gol_Contra é 1 (verdadeiro).

ORDER BY
QTD_Gol_Contra Desc


-- Esta consulta retorna a quantidade de gols de cada jogador em todas as fases da competição.
-- A cláusula GROUP BY é fundamental para agregar o número total de gols de cada jogador.

SELECT
    T.Nome_Time,
    G.Nome_Jogador,
    COUNT(G.Minuto_Gol) AS Gols, -- COUNT(G.Minuto_Gol) conta o número de gols marcados.
    one.Nome_Time AS 'Time One',
    J.Gols_Time_One,
    two.Nome_Time AS 'Time Two',
    J.Gols_Time_Two,
    J.Fase
FROM
    Gols AS G

INNER JOIN Time AS T ON G.ID_Time = T.id
INNER JOIN Jogos AS J ON G.ID_Jogo = J.ID_Jogo
INNER JOIN Time AS one ON (J.Time_One_ID = one.id)
INNER JOIN Time AS two ON (J.Time_Two_ID = two.id)

GROUP BY
G.Nome_Jogador,
T.Nome_Time,
one.Nome_Time,
J.Gols_Time_One,
two.Nome_Time,
J.Gols_Time_Two,
J.Fase


ORDER BY
Gols DESC


-- Esta consulta calcula a quantidade de vitórias por time.
-- A cláusula WITH cria uma 'Common Table Expression' (CTE) para simplificar a consulta e torná-la mais legível.

WITH VencedorAll AS (

    SELECT
        Time.Nome_Time AS Nome_Time,
        COUNT(Vencedor_ID) AS Quantidade_de_vitorias,
        Jogos.Fase AS Fase,
        Jogos.Grupo AS Grupo,
        Time.Confederacao AS Confederacao
        
    FROM
        Jogos
        INNER JOIN Time ON Jogos.Vencedor_ID = Time.id

    GROUP BY
            Nome_Time,
            Jogos.Fase,
            Jogos.Grupo,
            Time.Confederacao
 

            )
    SELECT 
        Nome_Time,
        Quantidade_de_vitorias,
        Fase,
        CASE
        WHEN Grupo IS NULL THEN 'Mata-Mata'
        ELSE Grupo END AS Grupo,
        Confederacao
        
    FROM
        VencedorAll
    WHERE
    Confederacao = 'UEFA (Europa)' -- Este filtro restringe a consulta a um grupo específico.
    ORDER BY
    Quantidade_de_vitorias DESC
   


-- Esta consulta calcula a quantidade total de gols para cada time, fase e grupo.
-- A cláusula UNION ALL combina as duas subconsultas para somar os gols,
-- independentemente de o time ser o 'Time_One' ou o 'Time_Two'.

WITH GolsPorTime AS (
    
    SELECT
        J.Time_One_ID AS TimeID,
        J.Gols_Time_One AS GolsMarcados,
        J.Fase,
        J.Grupo
    FROM
        Jogos AS J
  

    UNION ALL

    
    SELECT
        J.Time_Two_ID AS TimeID,
        J.Gols_Time_Two AS GolsMarcados,
        J.Fase,
        J.Grupo
    FROM
        Jogos AS J
   
)
SELECT
    T.Nome_Time,
    SUM(GolsPorTime.GolsMarcados) AS 'Gols',
    GolsPorTime.Fase,
    CASE
    WHEN GolsPorTime.Grupo IS NULL THEN 'Mata-Mata'
    ELSE GolsPorTime.Grupo END AS Grupo
FROM
    GolsPorTime
INNER JOIN
    Time AS T ON GolsPorTime.TimeID = T.id
GROUP BY
    T.Nome_Time,
    GolsPorTime.Fase,
    GolsPorTime.Grupo
ORDER BY
    'Gols' DESC,
    GolsPorTime.Grupo


-- Esta consulta retorna as partidas em que um time não sofreu gols.
-- A cláusula WHERE ID_JOGO IN (...) usa uma subconsulta para encontrar os IDs dos jogos
-- que atendem à condição de um time ter sofrido zero gols.

SELECT
         J.ID_Jogo,
         J.Data,
         J.Hora,
         J.Estadio,
         one.Nome_Time AS 'Time_One',
         J.Gols_Time_One,
         two.Nome_Time AS 'Time_Two',
         J.Gols_Time_Two,
         -- Bloco CASE para Vencedor
         CASE
             WHEN v.Nome_Time IS NULL THEN 'Empate'
             ELSE v.Nome_Time 
         END AS 'Vencedor',
         J.Fase,
         -- Bloco CASE para Grupo
         CASE
             WHEN j.Grupo IS NULL THEN 'Mata-mata'
             ELSE j.Grupo 
         END AS 'Grupo'
     
FROM
        Jogos AS j
    INNER JOIN Time AS one ON (J.Time_One_ID = one.id)
    INNER JOIN Time AS two ON (J.Time_Two_ID = two.id)
    LEFT JOIN Time AS v ON (J.Vencedor_ID = v.id)

WHERE
    ID_JOGO IN
    (
    SELECT
        ID_Jogo
    FROM
        Jogos
    WHERE
    (Gols_Time_One = 0 AND Gols_Time_Two >= 1) -- Encontra jogos onde o Time 1 não sofreu gols e o Time 2 marcou.
                        OR
    (Gols_Time_Two = 0 AND Gols_Time_One >= 1) -- Encontra jogos onde o Time 2 não sofreu gols e o Time 1 marcou.
                        OR
    Vencedor_ID IS NULL -- Inclui os jogos que foram empates.
    )
