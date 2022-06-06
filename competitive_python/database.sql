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


