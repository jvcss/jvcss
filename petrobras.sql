CREATE TABLE dados (
  id_dados SERIAL PRIMARY KEY,
  regiao_sigla varchar NOT NULL,
  regiao_uf varchar NOT NULL,
  municipio_nome varchar NOT NULL,
  revendedora varchar NOT NULL,
  cnpj varchar NOT NULL,
  produto varchar NOT NULL,
  data_coleta datetime NOT NULL,
  valor_venda varchar,
  valor_compra varchar,
  unidade_de_medida varchar NOT NULL,
  bandeira varchar NOT NULL,
  crescimento_medio varchar NOT NULL
);

----"\1"-- DML
----"\1"-- DO $$ DECLARE
----    rec RECORD;
----BEGIN
----    FOR rec IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
----        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(rec.tablename) || ' CASCADE';
----    END LOOP;
----END $$;
------- DELETE enumerador
-------DROP TYPE users;
----
----
------ DDL
----
----CREATE TABLE IF NOT EXISTS "bandeiras" (
----  "bandeira" VARCHAR PRIMARY KEY
----);
----
----CREATE TABLE "revendedora" (
----  "cnpj_revendedora" VARCHAR PRIMARY KEY,
----  "bandeira" VARCHAR -- se referencia a tabela bandeiras 
----);
----
----ALTER TABLE "revendedora" ADD FOREIGN KEY ("bandeira") REFERENCES "bandeiras" ("bandeira");
----
----
----
----- DDL INSERT
--INSERT into bandeiras(bandeira)VALUES ('PETROBRAS DISTRIBUIDORA S.A.');
--
--INSERT into revendedora (cnpj_revendedora, bandeira)
--VALUES('123456', 
--    (SELECT bandeira FROM bandeiras WHERE bandeira='PETROBRAS DISTRIBUIDORA S.A.')
--);
--
--
--