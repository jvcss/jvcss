CREATE TABLE sample (
   id        bigserial PRIMARY KEY,
   lastname  varchar(20),
   firstname varchar(20)
);

CREATE TABLE sample1(
   user_id    bigserial PRIMARY KEY,
   sample_id  bigint REFERENCES sample,
   adddetails varchar(20)
);

CREATE TABLE sample2(
   id      bigserial PRIMARY KEY,
   user_id bigint REFERENCES sample1,
   value   varchar(10)
);

WITH data(firstname, lastname, adddetails, value) AS (
   VALUES 
      ('fai55', 'shaggk', 'ss', 'ss2')
    , ('fai56', 'XXaggk', 'xx', 'xx2')
       --  more?                      
   )
, ins1 AS (
   INSERT INTO sample (firstname, lastname)
   SELECT firstname, lastname          -- DISTINCT? see below
   FROM   data
   -- ON     CONFLICT DO NOTHING       -- UNIQUE constraint? see below
   RETURNING firstname, lastname, id AS sample_id
   )
, ins2 AS (
   INSERT INTO sample1 (sample_id, adddetails)
   SELECT ins1.sample_id, d.adddetails
   FROM   data d
   JOIN   ins1 USING (firstname, lastname)
   RETURNING sample_id, user_id
   )
INSERT INTO sample2 (user_id, value)
SELECT ins2.user_id, d.value
FROM   data d
JOIN   ins1 USING (firstname, lastname)
JOIN   ins2 USING (sample_id);
