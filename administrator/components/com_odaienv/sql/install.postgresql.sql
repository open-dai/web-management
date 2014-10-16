CREATE TABLE "#__odai_vdbs"
(
  "id" serial NOT NULL,
  "name" character varying(45) NOT NULL DEFAULT ''::character varying,
  "vdbfile" character varying(45) NOT NULL DEFAULT ''::character varying,
  "state" bigint NOT NULL DEFAULT 0,
  CONSTRAINT "#__odai_vdbs_pkey" PRIMARY KEY (id)
);

CREATE TABLE "#__odai_resources"
(
  "id" serial NOT NULL,
  "name" character varying(45) NOT NULL DEFAULT ''::character varying,
  "state" bigint NOT NULL DEFAULT 0,
  "jndiname" character varying(45) NOT NULL DEFAULT ''::character varying,
  "resfile" character varying(80) NOT NULL DEFAULT ''::character varying,
  "vdb_id" bigint NOT NULL DEFAULT 0,
  CONSTRAINT "#__odai_resources_pkey" PRIMARY KEY (id),
  CONSTRAINT "#__odai_resources_fkey" FOREIGN KEY (vdb_id)
      REFERENCES "#__odai_vdbs" (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "#__odai_datasources"
(
  "id" serial NOT NULL,
  "name" character varying(45) NOT NULL DEFAULT ''::character varying,
  "state" bigint NOT NULL DEFAULT 0,
  "jndiname" character varying(45) NOT NULL DEFAULT ''::character varying,
  "drivername" character varying(45) NOT NULL DEFAULT ''::character varying,
  "driverclass" character varying(45) NOT NULL DEFAULT ''::character varying,
  "connectionurl" character varying(100) NOT NULL DEFAULT ''::character varying,
  "user" character varying(45) NOT NULL DEFAULT ''::character varying,
  "password" character varying(45) NOT NULL DEFAULT ''::character varying,
  "vdb_id" bigint NOT NULL DEFAULT 0,
  CONSTRAINT "#__odai_datasources_pkey" PRIMARY KEY (id),
  CONSTRAINT "#__odai_datasources_fkey" FOREIGN KEY (vdb_id)
      REFERENCES "#__odai_vdbs" (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "#__odai_apis"
(
  "id" serial NOT NULL,
  "name" character varying(45) NOT NULL DEFAULT ''::character varying,
  "state" bigint NOT NULL DEFAULT 0,
  CONSTRAINT "#__odai_apis_pkey" PRIMARY KEY (id)
);
