-- **********************************************
-- CREATE       -- DDL – Data Definition Language
/*
-- CREATE       -- DDL – Data Definition Language
CREATE TABLE "dados"(
  "dados_id_user" SERIAL PRIMARY KEY,
  "dado_nome" varchar,
  "dado_telefone" varchar,
  "dado_endereco" varchar
);
CREATE TABLE "areas_conhecimento" (
  "codigo_area_conhecimento" SERIAL PRIMARY KEY,
  "descricao_area" varchar
);


/*CREATE TABLE "funcionarios" (
  "codigo_funcionario" SERIAL PRIMARY KEY,
  "dados_id"  int REFERENCES dados (dados_id_user) ON DELETE CASCADE -- link para dados dados_id_user
);
CREATE TABLE "alunos" (
  "codigo_aluno" SERIAL PRIMARY KEY,
  "dados_id" int REFERENCES dados (dados_id_user) ON DELETE CASCADE
);
CREATE TABLE "professores" (
  "codigo_professor" SERIAL PRIMARY KEY,
  "dados_id" int REFERENCES dados (dados_id_user) ON DELETE CASCADE
);
CREATE TABLE "usuario" (
  "usuario_id" SERIAL PRIMARY KEY,
  "tipo" varchar,--link um para vários, tipo pode ser id_funcionario/_aluno/_professor
  "inicio_locacao_dia" date DEFAULT (now()),
  "fim_locacao_dia" date DEFAULT (now()+ INTERVAL '7 DAY')
);ALTER TABLE `usuario` ADD FOREIGN KEY (`tipo`, `tipo`, `tipo`) REFERENCES `users` (`aluno`, `professor`, `funcionario`);

CREATE TABLE "exemplares" (
  "exemplar_id" SERIAL PRIMARY KEY,
  "locador_id_usuario" INT REFERENCES usuario (usuario_id), -- link para usuario id
  "exemplar_id_livro" varchar,
  -- cada exemplar tem um id, para locar deve-se verificar o filtro de quantidades já locadas desse exemplar_id
  "unidades" INTEGER
);*/
CREATE TABLE "editora" (
  "editora_id" SERIAL PRIMARY KEY,
  --"titulos" varchar, -- editora tem uma tabela nova de livros, ou seja, só um filtro e não uma input
  "dados_id" int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE autor (
  autor_id  serial PRIMARY KEY,
  dados_id  int REFERENCES dados (dados_id_user) ON UPDATE CASCADE ON DELETE CASCADE 
  -- CRIANDO UM dados_id associamos ao dados ID das tabela
  -- isso permite consulta concatenada
);
CREATE TABLE livro (
  livro_id serial PRIMARY KEY, -- implicit primary key constraint
  livro_nome VARCHAR NOT NULL,
  autor_id int REFERENCES autor (autor_id) ON UPDATE CASCADE
  -- existe um autor principal, mas também é um filtro na tabela de relação autores por livros
  editora_id int REFERENCES editora (editora_id) ON UPDATE CASCADE
  -- valor_monetario numeric NOT NULL DEFAULT 0
  -- conteudo BLOB NOT NULL -- podemos salvar livros inteiros como imagens em um retrato e ir cortando blocos para fazer paginas 
);
CREATE TABLE autor_por_livro (
  livro_id int REFERENCES livro (livro_id) ON UPDATE CASCADE ON DELETE CASCADE,
  -- retira as linhas com id desse livro caso o livro seja removido da tabela de livros
  autor_id int REFERENCES autor (autor_id) ON UPDATE CASCADE ON DELETE CASCADE,
  --retira essa referencia de autor (+1) caso o mesmo seja deletado da tabela de autores
  contagem_autores numeric NOT NULL DEFAULT 1,--conta autores cada nova linha é um autor a mais para um mesmo livro
  CONSTRAINT autor_livro_pkey PRIMARY KEY (livro_id,autor_id)-- explicit pk
);

--ALTER TABLE `editora` ADD FOREIGN KEY (`dados_id`) REFERENCES `dados` (`dados_id_user`);
--ALTER TABLE `autor` ADD FOREIGN KEY (`dados_id`) REFERENCES `dados` (`dados_id_user`);

*/

-- **********************************************
-- DQL – Data Query Language

--- INSERT

--INSERT INTO autor (autor_nome) VALUES ('victor'),('andrezza')
--INSERT INTO livro (livro_nome,autor_id) VALUES ('O Idiota',1), ('Pequeno Principe',1), ('O Processo',2)
--INSERT INTO autor_por_livro (livro_id, autor_id) VALUES (1,1)(2,1)


-- **********************************************
-- DML – Data Manipulation Language

--- SHOW       

--SELECT * FROM autor
--SELECT * FROM livro
--SELECT * FROM autor_por_livro
--SELECT livro_id FROM autor_por_livro WHERE autor_id = 1

/*
SELECT
    * -- seleciona o mesmo livro para vários autores
FROM
    autor
WHERE
    autor_id IN -- this can also be "NOT IN", "EXISTS, an operator like "=", "<", and others.
    (
    SELECT
        autor_id
    FROM
        autor_por_livro
    WHERE
        livro_id = 2
    )
*/

/*SELECT
    * -- seleciona o mesmo autor para vários livros
FROM
    livro
WHERE
    livro_id IN -- this can also be "NOT IN", "EXISTS, an operator like "=", "<", and others.
    (
    SELECT
        livro_id
    FROM
        autor_por_livro
    WHERE
        autor_id = 1
    )*/



-- **********************************************
-- DCL – Data Control Language

--- CLEAR 

-- TRUNCATE TABLE autor_por_livro

--- DELETE

/*
DO $$ DECLARE
    rec RECORD;
BEGIN
    -- if the schema you operate on is not "current", you will want to
    -- replace current_schema() in query with 'schematodeletetablesfrom'
    -- *and* update the generate 'DROP...' accordingly.
    FOR rec IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(rec.tablename) || ' CASCADE';
    END LOOP;
END $$;
*/
