/* 
 * Copyright 2014 Internet Corporation for Assigned Names and Numbers.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Developed by Sinodun IT (www.sinodun.com)
 */

-----------------
--  DSC SCHEMA --
-----------------

--
-- Name: version; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.version (
    version integer
);

--
-- Name: internal_version; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.internal_version (
    serial integer,
    script character varying(255),
    description character varying(255),
    applied timestamp with time zone
);

--
-- Name: server; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.server
(
  id serial NOT NULL,
  name character varying(255) NOT NULL,
  display_name character varying(255)  NOT NULL,
  description character varying(255)
)
WITH (
  OIDS=FALSE
);

--
-- Name: node; Type: TABLE; Schema: dsc; 
--
--TODO(asap): Just have server_id, name and group
CREATE TABLE dsc.node
(
  id serial NOT NULL,
  server_id integer NOT NULL,
  name character varying(255) NOT NULL,
  city character varying(255),
  state character varying(255),
  country character varying(255),
  region character varying(255) NOT NULL
)
WITH (
  OIDS=FALSE
);

--
-- Name: geo; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.geo
(
  id serial NOT NULL,
  name character varying(255) NOT NULL,
  country_code char(2) NOT NULL
)
WITH (
  OIDS=FALSE
);

--
-- Name: dataset; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.dataset
(
  id serial NOT NULL,
  name character varying(255) NOT NULL
)
WITH (
  OIDS=FALSE
);

--
-- Name: visible_plot; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.visible_plot
(
  id serial NOT NULL, 
  name character varying(255) NOT NULL	,
  display_category character varying(255),
  display_name character varying(255),
  title character varying(255),
  description character varying(255)
)
WITH (
  OIDS=FALSE
);

--
-- Name: dataset_visible_plot; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.dataset_visible_plot
(
  visible_plot_id integer NOT NULL,
  dataset_id integer NOT NULL
)
WITH (
  OIDS=FALSE
);

--
-- Name: plot; Type: VIEW; Schema: dsc; 
-- This view is used for backwards compatibility and to provide an interface
-- into the new dataset and visible plots tables since there is now a 
-- many to many relationship between them. When the front end code is 
-- refactored it can be replaced by a cleaner view!
--
CREATE VIEW dsc.plot AS
(
	SELECT ROW_NUMBER() OVER(ORDER BY name) AS id, * FROM
	(
		SELECT
			vp.name,
			vp.display_category AS ddcategory,
			vp.display_name AS ddname,
			vp.title,
			vp.description,
			(SELECT dataset_id FROM dataset_visible_plot WHERE dsc.dataset_visible_plot.visible_plot_id=vp.id LIMIT 1) AS plot_id,
			(SELECT ARRAY(SELECT dataset_id FROM dataset_visible_plot WHERE dsc.dataset_visible_plot.visible_plot_id=vp.id)) AS dataset_id
		FROM
			dsc.visible_plot AS vp
		UNION
		SELECT
			name,
			'' AS ddcategory,
			'' AS ddname,
			'' AS title,
			'' AS description,
			id AS plot_id,
			ARRAY[id] AS dataset_id
		FROM
			dataset
		WHERE
			dsc.dataset.name NOT IN (SELECT name FROM dsc.visible_plot)
	)
	AS x
);

--
-- Name: query_classification; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.query_classification (
    id serial NOT NULL,
    name character varying(255),
    title character varying(255)
);

--
-- Name: iana_lookup; Type: TABLE; Schema: dsc; 
--
CREATE TABLE dsc.iana_lookup
(
  registry character varying(255)  NOT NULL,
  value integer NOT NULL,
  name character varying(255) NOT NULL,
  description character varying(255)
)
WITH (
  OIDS=FALSE
);

--
-- Name: data; Type: TABLE; Schema: dsc; 
--
--TODO(refactor): Strictly don't need the server_id here. 
CREATE TABLE dsc.data
(
  starttime timestamp with time zone NOT NULL,
  server_id integer NOT NULL,
  node_id integer NOT NULL,
  plot_id integer NOT NULL,
  key1 character varying(255) NOT NULL,
  key2 character varying(255) NOT NULL,
  value integer NOT NULL
)
WITH (
  OIDS=FALSE
);

--
-- Name: pk_server, uniq_server; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE ONLY dsc.server
  ADD CONSTRAINT pk_server PRIMARY KEY (id),
  ADD CONSTRAINT uniq_server UNIQUE (name);

--
-- Name: pk_nodes, fk_nodes_servers, uniq_nodes; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE ONLY dsc.node
  ADD CONSTRAINT pk_node PRIMARY KEY (id),
  ADD CONSTRAINT fk_node_server FOREIGN KEY (server_id) REFERENCES dsc.server (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT uniq_node UNIQUE(server_id, name);

--
-- Name: pk_dataset, uniq_dataset_name; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE ONLY dsc.dataset
  ADD CONSTRAINT pk_dataset PRIMARY KEY (id),
  ADD CONSTRAINT uniq_dataset_name UNIQUE (name);

--
-- Name: pk_visible_plot, uniq_visible_plot_name; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE ONLY dsc.visible_plot
  ADD CONSTRAINT pk_visible_plot PRIMARY KEY (id),
  ADD CONSTRAINT uniq_visible_plot_name UNIQUE (name);

--
-- Name: dsc_pk_geo; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE ONLY dsc.geo
  ADD CONSTRAINT pk_geo PRIMARY KEY (name);

--
-- Name: pk_il; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE ONLY dsc.iana_lookup
  ADD CONSTRAINT pk_il PRIMARY KEY (registry , value , name );

--
-- Name: pk_data, fk_data_node, fk_data_plot; Type: CONSTRAINT; Schema: dsc; 
--
ALTER TABLE dsc.data
  ADD CONSTRAINT pk_data PRIMARY KEY (server_id, node_id, plot_id, starttime, key1, key2),
  ADD CONSTRAINT fk_data_node FOREIGN KEY (node_id) REFERENCES dsc.node (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT fk_data_plot FOREIGN KEY (plot_id) REFERENCES dsc.dataset(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;

/*
--
-- Name: idx_data; Type: INDEX; Schema: dsc; 
--
CREATE INDEX idx_data
  ON dsc.data
  USING btree
  (plot_id COLLATE pg_catalog."default" );
*/

--
-- Name: fn_dsc_data_insert_trigger; Type: FUNCTION; Schema: dsc; 
--
CREATE OR REPLACE FUNCTION dsc.fn_dsc_data_insert_trigger()
RETURNS TRIGGER AS $$
DECLARE
    server TEXT;
    plot TEXT;
    tbl_nm TEXT;
    ins_sql TEXT;
BEGIN
    SELECT name INTO STRICT server FROM dsc.server WHERE id = new.server_id;
    SELECT name INTO STRICT plot FROM dsc.dataset WHERE id = new.plot_id;
    tbl_nm := 'data_' || server || '_' || plot || '_' || to_char(NEW.starttime, 'YYYY_MM');
    ins_sql := 
        'INSERT INTO dsc.'|| tbl_nm
        || ' (starttime, server_id, node_id, plot_id, key1, key2, value) VALUES'
        || ' ('
        || quote_literal(NEW.starttime) || ','
        || NEW.server_id || ','
        || NEW.node_id || ','
        || NEW.plot_id || ','
        || quote_literal(NEW.key1) || ','
        || quote_literal(NEW.key2) || ','
        || NEW.value
        || ')'
        ;
    EXECUTE ins_sql; 
    RETURN NULL;
EXCEPTION
    WHEN undefined_table THEN
        RAISE WARNING 'dsc data has not been inserted due to undefined partition --> %', tbl_nm;
        RETURN NULL;
END
$$
LANGUAGE 'plpgsql' ;

--
-- Name: dsc_data_insert_trigger; Type: TRIGGER; Schema: dsc; 
--
CREATE TRIGGER dsc_data_insert_trigger
    BEFORE INSERT ON dsc.data
    FOR EACH ROW EXECUTE PROCEDURE dsc.fn_dsc_data_insert_trigger();

--
-- Name: unique_source_summary_function(integer, integer, timestamp with time zone, timestamp with time zone, text); Type: FUNCTION; Schema: dsc; 
--
CREATE FUNCTION unique_source_summary_function(integer, integer, timestamp with time zone, timestamp with time zone, text) RETURNS TABLE(x character varying, y bigint)
    LANGUAGE plpgsql
    AS $_$
BEGIN
return query SELECT 
				key1 as x, 
				count(key2) AS y 
				FROM dsc.data as d 
				WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) 
				GROUP BY x 
			UNION 
			SELECT 
				'IPv6/64' as x, 
				count(*) as y from (SELECT substring(key2 FROM '(^([0-9a-f]{1,4}:{0,1}[0-9a-f]{0,4}:{0,1}[0-9a-f]{0,4}:{0,1}[0-9a-f]{0,4}))') as subnet 
				FROM dsc.data as d 
				WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND key1='IPv6' AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY subnet) AS sq 
				ORDER BY y DESC;
END
$_$;

