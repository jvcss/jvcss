
-- CREATE       -- DDL – Data Definition Language
/*
CREATE TABLE autor (
  autor_id  serial PRIMARY KEY,
  autor_nome VARCHAR NOT NULL
);

CREATE TABLE livro (
  livro_id serial PRIMARY KEY,-- implicit primary key constraint
  livro_nome VARCHAR NOT NULL,
  autor_id int REFERENCES autor (autor_id) ON UPDATE CASCADE ON DELETE CASCADE
  -- price numeric NOT NULL DEFAULT 0
);

CREATE TABLE autor_por_livro (
  livro_id int REFERENCES livro (livro_id) ON UPDATE CASCADE,
  autor_id int REFERENCES autor (autor_id) ON UPDATE CASCADE ON DELETE CASCADE,
  contagem_autores numeric NOT NULL DEFAULT 1,
  CONSTRAINT autor_livro_pkey PRIMARY KEY (livro_id,autor_id)-- explicit pk
);
*/




-- INSERT       -- DQl – Data Query Language

--INSERT INTO autor (autor_nome) VALUES ('victor'),('andrezza')
--INSERT INTO livro (livro_nome,autor_id) VALUES ('O Idiota',1), ('Pequeno Principe',1), ('O Processo',2)
--INSERT INTO autor_por_livro (livro_id, autor_id) VALUES (1,1)(2,1)




--SHOW       -- DML – Data Manipulation Language

--SELECT * FROM autor
--SELECT * FROM livro
--SELECT * FROM autor_por_livro
--SELECT livro_id FROM autor_por_livro WHERE autor_id = 1




-- DCL – Data Control Language

-- CLEAR 

-- TRUNCATE TABLE autor_por_livro




-- DELETE       

/*
DO $$ DECLARE
    r RECORD;
BEGIN
    -- if the schema you operate on is not "current", you will want to
    -- replace current_schema() in query with 'schematodeletetablesfrom'
    -- *and* update the generate 'DROP...' accordingly.
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;
*/


-- DDL
/*
CREATE TABLE "livro" (
  "codigo_livro" SERIAL PRIMARY KEY,
  "livro_nome" varchar,
  "autores" varchar,
  "editora" varchar,
  "area_livro" varchar
);
CREATE TABLE "autores_por_livro"(
  "livro" PRIMARY key REFERENCES livro ("codigo_livro") 
)
CREATE TABLE "autor" (
  "codigo_autor" SERIAL PRIMARY KEY,
  "livros" varchar,
  "nome_autor" varchar,
  "telefone_autor" varchar,
  "endereco_autor" varchar
);
CREATE TABLE "editora" (
  "id" SERIAL PRIMARY KEY,
  "titulos" varchar,
  "nome_editora" varchar,
  "telefone_editora" varchar,
  "endereco_editora" varchar
);
CREATE TABLE "areas_conhecimento" (
  "codigo_area_conhecimento" SERIAL PRIMARY KEY,
  "descricao_area" varchar
);

CREATE TABLE "funcionarios" (
  "codigo_funcionario" SERIAL PRIMARY KEY,
  "dados" varchar/*link to dados codigo_dados*/
);
CREATE TABLE "alunos" (
  "codigo_aluno" SERIAL PRIMARY KEY,
  "dados" varchar/*link to dados codigo_dados*/
);
CREATE TABLE "professores" (
  "codigo_professor" SERIAL PRIMARY KEY,
  "dados" varchar/*link to dados codigo_dados*/
);
CREATE TABLE "users" (
  "user_id" SERIAL PRIMARY KEY,
  "aluno" varchar,
  "professor" varchar,
  "funcionario" varchar
);
CREATE TABLE "usuario" (
  "codigo" SERIAL PRIMARY KEY,
  "tipo" varchar,
  "inicio_locacao_dia" date DEFAULT (now()),
  "fim_locacao_dia" date DEFAULT (now()+ INTERVAL '7 DAY')
);
CREATE TABLE "exemplares" (
  "codigo_exemplar" SERIAL PRIMARY KEY,
  "locador_user" varchar,
  "exemplar" varchar,
  "unidades" INTEGER
);
CREATE TABLE "dados"(
  "codigo_dados" SERIAL PRIMARY KEY,
  "dado_nome" varchar,
  "dado_telefone" varchar,
  "dado_endereco" varchar
);

*/
