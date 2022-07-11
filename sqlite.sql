-- TCL
PRAGMA foreign_keys = ON;
PRAGMA foreign_keys;
--The command returns an integer value: 1: enable, 0: disabled.

-- DDL

CREATE TABLE IF NOT EXISTS  bandeiras (
  bandeira_id INTEGER PRIMARY KEY AUTOINCREMENT,
  bandeira TEXT NOT NULL
  -- temos 63 bandeiras e 14,500 cnpj; cada cnpj pode ter várias bandeiras diferentes
  -- primeiro criamos a tabela com 63 bandeiras para serem referenciadas
);
CREATE TABLE IF NOT EXISTS logradouros (
  regiao_sigla TEXt NOT NULL,
  regiao_uf TEXt NOT NULL,
  municipio_nome TEXt NOT NULL
);
CREATE TABLE IF NOT EXISTS revendedora (
  cnpj_revendedora INTEGER PRIMARY KEY,
  bandeira_revendedora TEXT NOT NULL,
  FOREIGN KEY (bandeira_revendedora) REFERENCES bandeiras (bandeira) ON UPDATE SET NULL ON DELETE SET NULL
);


-- DML

DROP TABLE if EXISTS bandeiras;
DROP TABLE if EXISTS logradouros;
DROP TABLE if EXISTS revendedora;
DROP TABLE if EXISTS sqlite_sequence;



-- DDL2
--INSERT INTO bandeiras (bandeira) VALUES ('PETROBRAS DISTRIBUIDORA S.A.');
-- fazer essa linha para 63 bandeiras

INSERT INTO revendedora (cnpj_revendedora, bandeira_revendedora)
VALUES (8215644000109, SELECT bandeira FROM bandeiras WHERE bandeira_id=1 );
-- fazer essa linha para cada cnpj e bandeira associada {buscada no csv DADOS}
--  SELECT bandeira FROM bandeiras WHERE bandeira='PETROBRAS DISTRIBUIDORA S.A.'




-- DQL

SELECT * from bandeiras

--SELECT bandeira FROM bandeiras WHERE bandeira='PETROBRAS DISTRIBUIDORA S.A.'







-- EXAMPLE
--example
CREATE TABLE if NOT EXISTS provedores (
  provedor_id integer PRIMARY KEY,
  provedor_name text NOT NULL,
  grupo_id integer NOT NULL,
  FOREIGN KEY (grupo_id) REFERENCES provedor_grupos (grupo_id) ON UPDATE SET NULL ON DELETE SET NULL
);

-- cada grupo de provedor pode ter um ou varios provedores
CREATE TABLE if NOT EXISTS provedor_grupos (
  grupo_id integer PRIMARY KEY,
  grupo_name text NOT NULL
);

INSERT INTO provedor_grupos (grupo_name) VALUES ('Domestic'),('Global'),('One-Time');

INSERT INTO provedores (provedor_name, grupo_id) VALUES ('HP', 3);