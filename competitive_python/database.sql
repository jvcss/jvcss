-- **********************************************
--- DCL – Data Control Language
--- DELETE EVERY TABLE

DO $$ DECLARE
    rec RECORD;
BEGIN
    FOR rec IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(rec.tablename) || ' CASCADE';
    END LOOP;
END $$;
--- DELETE enumerador
DROP TYPE users;



-- **********************************************
-- CREATE       -- DDL – Data Definition Language
/*
CREATE TYPE users AS ENUM ('funcionarios', 'alunos', 'professores');
CREATE TABLE dados(
  dados_id_user SERIAL PRIMARY KEY,
  dado_nome varchar,
  dado_telefone varchar,
  dado_endereco varchar
);
CREATE TABLE areas_conhecimento (
  area_conhecimento_id SERIAL PRIMARY KEY,
  descricao_area varchar
);
CREATE TABLE funcionarios (
  funcionario_id SERIAL PRIMARY KEY,
  dados_id_funcionarios  int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE
  -- link para dados dados_id_user
);
CREATE TABLE alunos (
  aluno_id SERIAL PRIMARY KEY,
  dados_id_alunos int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE professores (
  professor_id SERIAL PRIMARY KEY,
  dados_id_professores int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE usuario (
  usuario_id SERIAL PRIMARY KEY,
  -- table usuario_id onde tipo == users
  tipo_usuario users,
  inicio_locacao_dia date DEFAULT (now()),
  fim_locacao_dia date DEFAULT (now()+ INTERVAL '7 DAY')
);
CREATE TABLE editora (
  editora_id SERIAL PRIMARY KEY,
  dados_id_editora int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE
  --"titulos" varchar, -- editora tem uma tabela nova de livros, ou seja, só um filtro e não uma input
);
CREATE TABLE autor (
  autor_id  serial PRIMARY KEY,
  dados_id_autor int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE 
  -- CRIANDO UM dados_id associamos ao dados ID das tabela
  -- isso permite consulta concatenada
);
CREATE TABLE livro (
  livro_id serial PRIMARY KEY, -- implicit primary key constraint
  livro_nome VARCHAR NOT NULL,
  autor_id int REFERENCES autor (autor_id) ON UPDATE CASCADE,
  -- existe um autor principal, mas também é um filtro na tabela de relação autores por livros
  editora_id int REFERENCES editora (editora_id) ON UPDATE CASCADE
  livro_id_areas_conhecimento int REFERENCES areas_conhecimento (area_conhecimento_id) ON UPDATE CASCADE
  -- valor_monetario numeric NOT NULL DEFAULT 0
  -- conteudo BLOB NOT NULL -- podemos salvar livros inteiros como imagens em um retrato e ir cortando blocos para fazer paginas 
);
CREATE TABLE exemplares (
  exemplar_id SERIAL PRIMARY KEY,
  locador_id_usuario INT REFERENCES usuario (usuario_id), -- link para usuario id
  exemplar_id_livro INT REFERENCES livro (livro_id) ON UPDATE CASCADE ON DELETE CASCADE,
  -- cada exemplar tem um id, para locar deve-se verificar o filtro de quantidades já locadas desse exemplar_id
  unidades int
);
CREATE TABLE autor_por_livro (
  livro_id int REFERENCES livro (livro_id) ON UPDATE CASCADE ON DELETE CASCADE,
  -- retira as linhas com id desse livro caso o livro seja removido da tabela de livros
  autor_id int REFERENCES autor (autor_id) ON UPDATE CASCADE ON DELETE CASCADE,
  --retira essa referencia de autor (+1) caso o mesmo seja deletado da tabela de autores
  contagem_autores numeric NOT NULL DEFAULT 1,--conta autores cada nova linha é um autor a mais para um mesmo livro
  CONSTRAINT autor_livro_pkey PRIMARY KEY (livro_id,autor_id)-- explicit pk
);

*/

-- **********************************************
-- DQL – Data Query Language

--- INSERT
--INSERT INTO dados(dado_nome, dado_telefone, dado_endereco) VALUES('joao', '6298', 'rua asa')
/* see DML example (1)
--- TABLE TO ALL ADDRESSES FOR EVERONE: funcionarios, alunos, professores,editoras,autores
--- no metter who is, if it's here we can seach by it's ID
 _______________________________________________
|ID | DADO_NOME | DADO_TELEFONE | DADO_ENDEREÇO|
|---|-----------|---------------|--------------|
| 1 | joao      | 6298          | rua asa      |
|---|-----------|---------------|--------------|
|___|___________|_______________|______________|
*/


-- **********************************************
-- DML – Data Manipulation Language

--- SHOW       

--SELECT * FROM dados
--SELECT * FROM autor


-- Recursivity seach concatenade to grab joao's dados(table)
-- that's the gimmick valid for the entire relationship between datas since now
/* see DQL example (1)
SELECT
    * -- pega todo conteudo de dados
FROM
    dados
WHERE
    dados_id_user IN -- this can also be "NOT IN", "EXISTS, an operator like "=", "<", and others.
    (
    SELECT
        dados_id_autor
    FROM
        autor
    WHERE
        autor_id = 1
    )
*/

