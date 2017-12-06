--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE world_builder;
--
-- Name: world_builder; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE world_builder WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


ALTER DATABASE world_builder OWNER TO postgres;

\connect world_builder

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: world_builder; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE world_builder IS 'World building tool for Spring Web App';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: fn_create_entity(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_create_entity(param_start_year integer, param_entity_type character varying, param_primary_name_entity character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$

declare 
	
    var_guid_timeperiod uuid := uuid_generate_v4();	
    var_guid_entity uuid;

begin

	-- First the time period
	insert into timeperiod (
    	guid_timeperiod, 
        start_year
    )
    values (
    	var_guid_timeperiod,
    	param_start_year
    );
    
    -- Then the entity
    insert into entity_entity (
    	guid_entity,
        guid_timeperiod,
        guid_entitytype
    )
    select 
    	uuid_generate_v4() as guid_entity,
        var_guid_timeperiod,
        et.guid_entitytype
    from entity_lu_entitytype et
    where et.name_entitytype = param_entity_type
    returning guid_entity into var_guid_entity;
    
    -- now the detail time period
    var_guid_timeperiod := uuid_generate_v4();	
    
    insert into timeperiod (
    	guid_timeperiod, 
        start_year
    )
    values (
    	var_guid_timeperiod,
    	param_start_year
    );
    
    -- now the detail
    insert into entity_entitydetail (
    	guid_entity,
        guid_detailtype,
        guid_timeperiod,
        value_detail
    )
    select 
    	var_guid_entity,
        e_dt.guid_detailtype,
        var_guid_timeperiod,
        param_primary_name_entity
    from entity_lu_detailtype e_dt
    where name_detailtype = 'Name';
    
    return var_guid_entity;
    
end;

$$;


ALTER FUNCTION public.fn_create_entity(param_start_year integer, param_entity_type character varying, param_primary_name_entity character varying) OWNER TO postgres;

--
-- Name: fn_create_timeperiod(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_create_timeperiod(param_start_year integer) RETURNS uuid
    LANGUAGE plpgsql
    AS $$

declare 
	
    ret_guid_timeperiod uuid;	

begin

	-- First the time period
	insert into timeperiod (
    	guid_timeperiod, 
        start_year
    )
	select
    	uuid_generate_v4() as guid_timeperiod,
    	param_start_year
    returning guid_timeperiod into ret_guid_timeperiod;
    
	return ret_guid_timeperiod;
    
end;

$$;


ALTER FUNCTION public.fn_create_timeperiod(param_start_year integer) OWNER TO postgres;

--
-- Name: fn_generate_random_town(integer, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_generate_random_town(param_max_size integer, param_guid_entity uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$

declare 

ret_generated_town json;

begin

drop table if exists region_culture;
drop table if exists region_culture_religion;

create temporary table region_culture
(
	guid_region uuid,
    name_region varchar(100),
    guid_culture uuid,
    name_culture varchar(100),
    region_culture_affinity real,
    population_culture int
);
    
create temp table region_culture_religion
(
	guid_region uuid,
    name_region varchar(100),
    guid_culture uuid,
    name_culture varchar(100),
    region_culture_affinity real,
    population_culture int,
    guid_religion uuid,
    name_religion varchar(100),
    culture_religion_affinity real,
    population_religion int
);

insert into region_culture (
	guid_region,
	name_region,
	guid_culture,
	name_culture,
    region_culture_affinity
)
select
	region.guid_entity, 
    region.value_detail,
    region.guid_culture,
    cul.name_culture,
    region.region_culture_affinity
from (
    select
 		d.guid_entity,
    	d.value_detail,
    	c.guid_culture,
    	c.affinity as region_culture_affinity
    from conn_rl_entity_culture c
    join entity_entitydetail d
        on d.guid_entity = c.guid_entity
    where d.guid_entity = param_guid_entity	-- selected entity
    order by uuid_generate_v4()
	limit ((random() * 10) + 1)				-- limited as i cross-joined culture to region, real data will not be limited artificially
) region
join cul_culture cul
	on cul.guid_culture = region.guid_culture;
    
-- create culture population
with modified_affinity as (
    select 
        rc.guid_culture,
        rc.region_culture_affinity / total.sum as modified_affinity
    from region_culture rc
    cross join (
        select 
        	sum(rc.region_culture_affinity) as sum
        from region_culture rc
    ) total
) 
update region_culture rc
	set region_culture_affinity = modified_affinity.modified_affinity,
    	population_culture = param_max_size * modified_affinity.modified_affinity
from modified_affinity
where rc.guid_culture = modified_affinity.guid_culture;

-- pull in religion
insert into region_culture_religion (
    guid_region,
    name_region,
    guid_culture,
    name_culture,
    region_culture_affinity,
    population_culture,
    guid_religion,
    name_religion,
    culture_religion_affinity 
)
select
	rc.guid_region,
    rc.name_region, 
    rc.guid_culture,
    rc.name_culture,
    rc.region_culture_affinity,
    rc.population_culture,
    rel.guid_religion,
    rel.name_religion,
    cr.affinity
from region_culture rc
join conn_rl_culture_religion cr
	on cr.guid_culture = rc.guid_culture
join rel_religion rel
	on rel.guid_religion = cr.guid_religion;
   
-- update religious populations
with modified_affinity as (
    select 
        rc.guid_culture,
        rc.guid_religion,
        rc.culture_religion_affinity / total.sum as modified_affinity
    from region_culture_religion rc
    join (
        select 
            rcr.guid_culture,
            sum(rcr.culture_religion_affinity) as sum
        from region_culture_religion rcr
        group by rcr.guid_culture
    ) total
        on rc.guid_culture = total.guid_culture
) 
update region_culture_religion rcr
	set culture_religion_affinity = modified_affinity.modified_affinity,
    	population_religion = rcr.population_culture * modified_affinity.modified_affinity
from modified_affinity
where rcr.guid_culture = modified_affinity.guid_culture
	and rcr.guid_religion = modified_affinity.guid_religion;

-- Build JSON
with religions as (
    select
        guid_culture,
        json_agg (
            json_build_object (
                'guid_religion', rcr.guid_religion,
                'name_religion', rcr.name_religion,
                'population_religion', rcr.population_religion
            ) 
        ) religions
    from region_culture_religion rcr
    where population_religion > 0
    group by rcr.guid_culture--, rcr.guid_region--, rcr.guid_religion
),
cultures as (
    select 
		rcr.guid_region,    	
       	json_agg (
        	json_build_object (
                'guid_culture', rcr.guid_culture,
                'name_culture', rcr.name_culture,
                'population_culture', rcr.population_culture,
                'religions', religions
            )   
       	) cultures
    from religions r 
    join ( 
    	select distinct
        	guid_region,
        	guid_culture,
        	name_culture,
         	population_culture
        from region_culture_religion
        where population_culture > 0
    ) rcr
        on r.guid_culture = rcr.guid_culture
    group by rcr.guid_region
)
select 
	json_agg (
        json_build_object (
            'guid_region', rcr.guid_region,
            'name_region', rcr.name_region,
            'town_size', param_max_size,
            'cultures', c.cultures
        )
	)    
from cultures c
join (
	select distinct
    	guid_region, 
   		name_region
	from region_culture_religion rcr
) rcr
	on rcr.guid_region = c.guid_region
into ret_generated_town;

return ret_generated_town;

end;

$$;


ALTER FUNCTION public.fn_generate_random_town(param_max_size integer, param_guid_entity uuid) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: conn_lu_entityrelationshiptype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conn_lu_entityrelationshiptype (
    guid_entityrelationshiptype uuid NOT NULL,
    name_entityrelationshiptype character varying(100) NOT NULL
);


ALTER TABLE conn_lu_entityrelationshiptype OWNER TO postgres;

--
-- Name: conn_rl_culture_religion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conn_rl_culture_religion (
    affinity double precision NOT NULL,
    guid_religion uuid NOT NULL,
    guid_culture uuid NOT NULL,
    guid_timeperiod uuid NOT NULL
);


ALTER TABLE conn_rl_culture_religion OWNER TO postgres;

--
-- Name: conn_rl_entity_culture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conn_rl_entity_culture (
    affinity double precision NOT NULL,
    guid_entity uuid NOT NULL,
    guid_culture uuid NOT NULL,
    guid_timeperiod uuid NOT NULL
);


ALTER TABLE conn_rl_entity_culture OWNER TO postgres;

--
-- Name: conn_rl_entity_religion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conn_rl_entity_religion (
    affinity double precision NOT NULL,
    guid_entity uuid NOT NULL,
    guid_religion uuid NOT NULL,
    guid_timeperiod uuid NOT NULL
);


ALTER TABLE conn_rl_entity_religion OWNER TO postgres;

--
-- Name: cul_culture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cul_culture (
    guid_culture uuid NOT NULL,
    name_culture character varying(50) NOT NULL
);


ALTER TABLE cul_culture OWNER TO postgres;

--
-- Name: cul_culture_rl_hierarchy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cul_culture_rl_hierarchy (
    cultural_affinity integer NOT NULL,
    guid_parent_culture uuid NOT NULL,
    guid_culture uuid NOT NULL,
    guid_timeperiod uuid NOT NULL
);


ALTER TABLE cul_culture_rl_hierarchy OWNER TO postgres;

--
-- Name: cul_culturegroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cul_culturegroup (
    guid_culturegroup uuid NOT NULL,
    name_culturegroup integer NOT NULL
);


ALTER TABLE cul_culturegroup OWNER TO postgres;

--
-- Name: entity_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entity_entity (
    guid_entity uuid NOT NULL,
    guid_timeperiod uuid NOT NULL,
    guid_entitytype uuid NOT NULL
);


ALTER TABLE entity_entity OWNER TO postgres;

--
-- Name: entity_entitydetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entity_entitydetail (
    value_detail character varying(100) NOT NULL,
    guid_entity uuid NOT NULL,
    guid_timeperiod uuid NOT NULL,
    guid_detailtype uuid NOT NULL
);


ALTER TABLE entity_entitydetail OWNER TO postgres;

--
-- Name: entity_lu_detailtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entity_lu_detailtype (
    guid_detailtype uuid NOT NULL,
    name_detailtype character varying(50) NOT NULL
);


ALTER TABLE entity_lu_detailtype OWNER TO postgres;

--
-- Name: entity_lu_entitytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entity_lu_entitytype (
    guid_entitytype uuid NOT NULL,
    name_entitytype character varying(30) NOT NULL
);


ALTER TABLE entity_lu_entitytype OWNER TO postgres;

--
-- Name: entity_rl_entity_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entity_rl_entity_entity (
    parent_entity uuid NOT NULL,
    guid_entity uuid NOT NULL,
    guid_timeperiod uuid NOT NULL,
    guid_entityrelashionshiptype uuid NOT NULL
);


ALTER TABLE entity_rl_entity_entity OWNER TO postgres;

--
-- Name: TABLE entity_rl_entity_entity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE entity_rl_entity_entity IS 'Use this table to establish relationships, including war and peace';


--
-- Name: entity_rl_entitytype_detailtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entity_rl_entitytype_detailtype (
    guid_entitytype uuid NOT NULL,
    guid_detailtype uuid NOT NULL
);


ALTER TABLE entity_rl_entitytype_detailtype OWNER TO postgres;

--
-- Name: markov_datasource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_datasource (
    guid_source uuid NOT NULL,
    name_source character varying
);


ALTER TABLE markov_datasource OWNER TO postgres;

--
-- Name: markov_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_model (
    char1 character varying,
    char2 character varying,
    char3 character varying
);


ALTER TABLE markov_model OWNER TO postgres;

--
-- Name: markov_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_name (
    guid_name uuid NOT NULL,
    markov_name character varying NOT NULL,
    guid_source uuid,
    temp_name_sex character varying
);


ALTER TABLE markov_name OWNER TO postgres;

--
-- Name: markov_name_era; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_name_era (
    guid_era uuid NOT NULL,
    markov_name_era character varying
);


ALTER TABLE markov_name_era OWNER TO postgres;

--
-- Name: markov_name_gender; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_name_gender (
    guid_gender uuid NOT NULL,
    gender_distribution character varying,
    description_gender_distribution character varying
);


ALTER TABLE markov_name_gender OWNER TO postgres;

--
-- Name: markov_name_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_name_language (
    guid_language uuid NOT NULL,
    markov_name_language character varying
);


ALTER TABLE markov_name_language OWNER TO postgres;

--
-- Name: markov_output; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_output (
    markov_output character varying NOT NULL
);


ALTER TABLE markov_output OWNER TO postgres;

--
-- Name: markov_rl_name_era; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_rl_name_era (
    guid_era uuid NOT NULL,
    guid_name uuid NOT NULL
);


ALTER TABLE markov_rl_name_era OWNER TO postgres;

--
-- Name: markov_rl_name_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_rl_name_language (
    guid_name uuid NOT NULL,
    guid_language uuid
);


ALTER TABLE markov_rl_name_language OWNER TO postgres;

--
-- Name: markov_rl_name_language_era_frequency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_rl_name_language_era_frequency (
    guid_name uuid NOT NULL,
    guid_language uuid NOT NULL,
    guid_era uuid NOT NULL,
    frequency integer
);


ALTER TABLE markov_rl_name_language_era_frequency OWNER TO postgres;

--
-- Name: markov_subset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE markov_subset (
    name_id integer NOT NULL,
    name character varying,
    processed bit(1)
);


ALTER TABLE markov_subset OWNER TO postgres;

--
-- Name: markov_subset_name_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE markov_subset_name_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE markov_subset_name_id_seq OWNER TO postgres;

--
-- Name: markov_subset_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE markov_subset_name_id_seq OWNED BY markov_subset.name_id;


--
-- Name: rel_religion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE rel_religion (
    guid_religion uuid NOT NULL,
    name_religion character varying NOT NULL
);


ALTER TABLE rel_religion OWNER TO postgres;

--
-- Name: rel_religion_rl_hierarchy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE rel_religion_rl_hierarchy (
    religious_affinity integer NOT NULL,
    guid_parent_religion uuid NOT NULL,
    guid_religion uuid NOT NULL,
    guid_timeperiod uuid NOT NULL
);


ALTER TABLE rel_religion_rl_hierarchy OWNER TO postgres;

--
-- Name: timeperiod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE timeperiod (
    guid_timeperiod uuid NOT NULL,
    start_year integer NOT NULL,
    end_year integer
);


ALTER TABLE timeperiod OWNER TO postgres;

--
-- Name: timeperiod_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE timeperiod_event (
    guid_event uuid NOT NULL,
    guid_timeperiod uuid NOT NULL,
    guid_eventtype uuid NOT NULL,
    event_year integer NOT NULL,
    "parent_timePeriod" uuid
);


ALTER TABLE timeperiod_event OWNER TO postgres;

--
-- Name: timeperiod_eventtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE timeperiod_eventtype (
    guid_eventtype uuid NOT NULL,
    name_eventtype character varying(30) NOT NULL
);


ALTER TABLE timeperiod_eventtype OWNER TO postgres;

--
-- Name: markov_subset name_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_subset ALTER COLUMN name_id SET DEFAULT nextval('markov_subset_name_id_seq'::regclass);


--
-- Data for Name: conn_lu_entityrelationshiptype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('b82f61b0-c551-4d0e-96f9-52a752a3441c', 'Parent');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('2ad23453-fc8e-48e6-8e98-108c15bf07c3', 'Marriage');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('23c57cc0-0839-46b9-8b45-834c8fff3bc0', 'Citizenship');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('6f30eee0-c1bb-4d84-a1de-5304b08e4e56', 'Administrative Hierarchy');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('8dbc737f-e1e9-495a-8e4b-3d98a8741b66', 'Allegiance');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('f0073a7c-66f1-42f0-bf01-69a9153b29fe', 'Fealty');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('91da5c87-c7ea-40e9-8d90-d642a99c70f3', 'War');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('4f7fd69e-ecab-4dae-a1f6-58bb18b369ee', 'Love');
INSERT INTO conn_lu_entityrelationshiptype (guid_entityrelationshiptype, name_entityrelationshiptype) VALUES ('2b24e1b2-da52-45c4-9a17-259980910800', 'Hate');


--
-- Data for Name: conn_rl_culture_religion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '6294cca2-02d4-4248-9533-a570b51e1ade', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '98501149-8f19-481e-a990-e70261877a5e', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '46dc1251-3a43-408f-bd77-332bdff83211', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.68000000000000005, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.22, 'a51e7625-9188-4817-9b58-91467e68b50c', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.34999999999999998, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.029999999999999999, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'd827adae-575d-4787-ab8e-51b43b627c48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.91000000000000003, '6294cca2-02d4-4248-9533-a570b51e1ade', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '98501149-8f19-481e-a990-e70261877a5e', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '46dc1251-3a43-408f-bd77-332bdff83211', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.41999999999999998, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.032000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.46000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40999999999999998, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.041000000000000002, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00020000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '98501149-8f19-481e-a990-e70261877a5e', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '46dc1251-3a43-408f-bd77-332bdff83211', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '02f4a2a4-c53e-4083-901c-88677f6a545a', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'a51e7625-9188-4817-9b58-91467e68b50c', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0040000000000000001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '6294cca2-02d4-4248-9533-a570b51e1ade', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '98501149-8f19-481e-a990-e70261877a5e', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '46dc1251-3a43-408f-bd77-332bdff83211', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '02f4a2a4-c53e-4083-901c-88677f6a545a', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.47999999999999998, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '576225be-4bb7-4a72-9db7-456ff6290a5d', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.029999999999999999, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '553e1f35-b866-435f-813d-e9e1357ce102', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.52000000000000002, '6294cca2-02d4-4248-9533-a570b51e1ade', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.72999999999999998, '98501149-8f19-481e-a990-e70261877a5e', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.012, '46dc1251-3a43-408f-bd77-332bdff83211', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20999999999999999, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.14999999999999999, '02f4a2a4-c53e-4083-901c-88677f6a545a', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030999999999999999, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.53000000000000003, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '71cbccec-52a8-4689-9355-3e7c01c4c123', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'a51e7625-9188-4817-9b58-91467e68b50c', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0020999999999999999, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.042000000000000003, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00020000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.47999999999999998, '6294cca2-02d4-4248-9533-a570b51e1ade', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.052999999999999999, '46dc1251-3a43-408f-bd77-332bdff83211', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.23000000000000001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0025999999999999999, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.57999999999999996, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.60999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.105, '576225be-4bb7-4a72-9db7-456ff6290a5d', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00020000000000000001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.050000000000000003, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40500000000000003, '6294cca2-02d4-4248-9533-a570b51e1ade', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.91000000000000003, '98501149-8f19-481e-a990-e70261877a5e', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.26000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.24010000000000001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.080000000000000002, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00059999999999999995, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'a51e7625-9188-4817-9b58-91467e68b50c', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.105, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.1101, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00050000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '98501149-8f19-481e-a990-e70261877a5e', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.32000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.26100000000000001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.070000000000000007, '02f4a2a4-c53e-4083-901c-88677f6a545a', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00050000000000000001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.72999999999999998, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '71cbccec-52a8-4689-9355-3e7c01c4c123', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'a51e7625-9188-4817-9b58-91467e68b50c', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.109, '576225be-4bb7-4a72-9db7-456ff6290a5d', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.055, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40500000000000003, '6294cca2-02d4-4248-9533-a570b51e1ade', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.91000000000000003, '98501149-8f19-481e-a990-e70261877a5e', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.26000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.24010000000000001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.050000000000000003, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.70999999999999996, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'a51e7625-9188-4817-9b58-91467e68b50c', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.70999999999999996, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.111, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.121, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0080000000000000002, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.056399999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.60099999999999998, '46dc1251-3a43-408f-bd77-332bdff83211', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.25009999999999999, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'a51e7625-9188-4817-9b58-91467e68b50c', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.56000000000000005, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40500000000000003, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.432, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40200000000000002, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '6294cca2-02d4-4248-9533-a570b51e1ade', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '98501149-8f19-481e-a990-e70261877a5e', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '46dc1251-3a43-408f-bd77-332bdff83211', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '02f4a2a4-c53e-4083-901c-88677f6a545a', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.34999999999999998, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '71cbccec-52a8-4689-9355-3e7c01c4c123', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'a51e7625-9188-4817-9b58-91467e68b50c', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.029999999999999999, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '88dced47-1dfe-411f-ab5c-c8128342296c', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00050000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00089999999999999998, '02f4a2a4-c53e-4083-901c-88677f6a545a', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'a51e7625-9188-4817-9b58-91467e68b50c', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00069999999999999999, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00050000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '02f4a2a4-c53e-4083-901c-88677f6a545a', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '4fa0db88-70b4-4de9-843f-76a05488517f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '6294cca2-02d4-4248-9533-a570b51e1ade', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '98501149-8f19-481e-a990-e70261877a5e', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '46dc1251-3a43-408f-bd77-332bdff83211', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '71cbccec-52a8-4689-9355-3e7c01c4c123', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'a51e7625-9188-4817-9b58-91467e68b50c', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '0c552347-75de-453f-9467-fe5e2e0a15ef', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '98501149-8f19-481e-a990-e70261877a5e', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.002, '46dc1251-3a43-408f-bd77-332bdff83211', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.11, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.012, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'ed625c6f-aac7-4035-a87f-58897b1064be', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '98501149-8f19-481e-a990-e70261877a5e', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.002, '46dc1251-3a43-408f-bd77-332bdff83211', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.11, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.024, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.123, '6294cca2-02d4-4248-9533-a570b51e1ade', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.14499999999999999, '98501149-8f19-481e-a990-e70261877a5e', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.32100000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.02, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.055, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.32000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.34000000000000002, '71cbccec-52a8-4689-9355-3e7c01c4c123', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.35999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.34000000000000002, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.019, '576225be-4bb7-4a72-9db7-456ff6290a5d', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0080000000000000002, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0015, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '97088d37-c516-4448-a4d1-dc5fcb5547bc', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '6294cca2-02d4-4248-9533-a570b51e1ade', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '98501149-8f19-481e-a990-e70261877a5e', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '46dc1251-3a43-408f-bd77-332bdff83211', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '71cbccec-52a8-4689-9355-3e7c01c4c123', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '576225be-4bb7-4a72-9db7-456ff6290a5d', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0054999999999999997, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0054999999999999997, 'd049036f-effb-4c5c-9a39-01ce00213e50', '035c3a4f-9c27-4799-98b4-7831ce993b38', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '6294cca2-02d4-4248-9533-a570b51e1ade', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '46dc1251-3a43-408f-bd77-332bdff83211', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.66000000000000003, 'a51e7625-9188-4817-9b58-91467e68b50c', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '35026cab-a2dd-44a1-a988-b0eb869317f5', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'ced85788-6103-4859-bd11-5a7839c1bcee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '98501149-8f19-481e-a990-e70261877a5e', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '46dc1251-3a43-408f-bd77-332bdff83211', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65400000000000003, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '35026cab-a2dd-44a1-a988-b0eb869317f5', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'd049036f-effb-4c5c-9a39-01ce00213e50', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0060000000000000001, '6294cca2-02d4-4248-9533-a570b51e1ade', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0060000000000000001, '98501149-8f19-481e-a990-e70261877a5e', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0064999999999999997, '46dc1251-3a43-408f-bd77-332bdff83211', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0064999999999999997, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0089999999999999993, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0060000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, 'd049036f-effb-4c5c-9a39-01ce00213e50', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '6294cca2-02d4-4248-9533-a570b51e1ade', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '46dc1251-3a43-408f-bd77-332bdff83211', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40999999999999998, 'a51e7625-9188-4817-9b58-91467e68b50c', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '576225be-4bb7-4a72-9db7-456ff6290a5d', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '6fcea565-0684-4609-a40d-00fab6956c7f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '6294cca2-02d4-4248-9533-a570b51e1ade', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '98501149-8f19-481e-a990-e70261877a5e', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '46dc1251-3a43-408f-bd77-332bdff83211', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '35026cab-a2dd-44a1-a988-b0eb869317f5', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '6294cca2-02d4-4248-9533-a570b51e1ade', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '46dc1251-3a43-408f-bd77-332bdff83211', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '576225be-4bb7-4a72-9db7-456ff6290a5d', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '35026cab-a2dd-44a1-a988-b0eb869317f5', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '98501149-8f19-481e-a990-e70261877a5e', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '46dc1251-3a43-408f-bd77-332bdff83211', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0060000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.23400000000000001, 'd6884a2c-c3b8-48a0-8a3f-09399651901d', 'cb7d878c-2438-456a-addb-c48f095fb51d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00089999999999999998, '6294cca2-02d4-4248-9533-a570b51e1ade', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.080000000000000002, '98501149-8f19-481e-a990-e70261877a5e', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.070000000000000007, '46dc1251-3a43-408f-bd77-332bdff83211', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0050000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '728c2a8f-2671-4971-aaa7-b3b14ab4915a', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '98501149-8f19-481e-a990-e70261877a5e', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.02, '46dc1251-3a43-408f-bd77-332bdff83211', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.002, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '02f4a2a4-c53e-4083-901c-88677f6a545a', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00050000000000000001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0050000000000000001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.25, 'a51e7625-9188-4817-9b58-91467e68b50c', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00020000000000000001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0050000000000000001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.02, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '319a0575-3e41-40cf-8a84-0a0515db0079', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '98501149-8f19-481e-a990-e70261877a5e', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.029999999999999999, '46dc1251-3a43-408f-bd77-332bdff83211', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.44, '02f4a2a4-c53e-4083-901c-88677f6a545a', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.123, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'a51e7625-9188-4817-9b58-91467e68b50c', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '2c9356c4-1332-4f1a-893a-479da470378f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '6294cca2-02d4-4248-9533-a570b51e1ade', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '98501149-8f19-481e-a990-e70261877a5e', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00020000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '60a94125-a2bb-49cf-915e-38995e626e7e', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '98501149-8f19-481e-a990-e70261877a5e', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.029999999999999999, '46dc1251-3a43-408f-bd77-332bdff83211', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.44, '02f4a2a4-c53e-4083-901c-88677f6a545a', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.123, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'a51e7625-9188-4817-9b58-91467e68b50c', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '5e0614b3-c737-4171-8733-9a1210ba9f70', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '98501149-8f19-481e-a990-e70261877a5e', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65400000000000003, '46dc1251-3a43-408f-bd77-332bdff83211', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.001, '576225be-4bb7-4a72-9db7-456ff6290a5d', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '813d9513-7041-4ef9-9ca6-79ad395c4350', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0089999999999999993, '98501149-8f19-481e-a990-e70261877a5e', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.002, '46dc1251-3a43-408f-bd77-332bdff83211', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '71cbccec-52a8-4689-9355-3e7c01c4c123', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00089999999999999998, 'a51e7625-9188-4817-9b58-91467e68b50c', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, '576225be-4bb7-4a72-9db7-456ff6290a5d', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.84999999999999998, '97088d37-c516-4448-a4d1-dc5fcb5547bc', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0123, '6294cca2-02d4-4248-9533-a570b51e1ade', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0044999999999999997, '98501149-8f19-481e-a990-e70261877a5e', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.032099999999999997, '46dc1251-3a43-408f-bd77-332bdff83211', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, '02f4a2a4-c53e-4083-901c-88677f6a545a', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0014, '71cbccec-52a8-4689-9355-3e7c01c4c123', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0016000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0014, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.019, '576225be-4bb7-4a72-9db7-456ff6290a5d', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0015, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, '97088d37-c516-4448-a4d1-dc5fcb5547bc', '61baa2d0-fc92-4661-a6e7-c1085516b281', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0020999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00050000000000000001, '98501149-8f19-481e-a990-e70261877a5e', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00089999999999999998, '46dc1251-3a43-408f-bd77-332bdff83211', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.021000000000000001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0011999999999999999, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0014, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0016000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0014, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.019, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00080000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.014999999999999999, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '98501149-8f19-481e-a990-e70261877a5e', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '46dc1251-3a43-408f-bd77-332bdff83211', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.34999999999999998, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.34999999999999998, '71cbccec-52a8-4689-9355-3e7c01c4c123', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '576225be-4bb7-4a72-9db7-456ff6290a5d', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.010999999999999999, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '6294cca2-02d4-4248-9533-a570b51e1ade', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '46dc1251-3a43-408f-bd77-332bdff83211', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, '02f4a2a4-c53e-4083-901c-88677f6a545a', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'a51e7625-9188-4817-9b58-91467e68b50c', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '576225be-4bb7-4a72-9db7-456ff6290a5d', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '6a646ed4-05bc-4c55-8976-eba040ac081a', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.050000000000000003, '6294cca2-02d4-4248-9533-a570b51e1ade', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.050000000000000003, '98501149-8f19-481e-a990-e70261877a5e', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.050000000000000003, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.10000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, 'd049036f-effb-4c5c-9a39-01ce00213e50', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '98501149-8f19-481e-a990-e70261877a5e', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '46dc1251-3a43-408f-bd77-332bdff83211', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '576225be-4bb7-4a72-9db7-456ff6290a5d', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, '98501149-8f19-481e-a990-e70261877a5e', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.90000000000000002, '46dc1251-3a43-408f-bd77-332bdff83211', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '576225be-4bb7-4a72-9db7-456ff6290a5d', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00040000000000000002, '35026cab-a2dd-44a1-a988-b0eb869317f5', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '4dc42a11-61e0-44dd-8b48-49a8122ef259', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '6114f125-eb3d-45ac-8b03-9104600280dc', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '6294cca2-02d4-4248-9533-a570b51e1ade', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.29999999999999999, '98501149-8f19-481e-a990-e70261877a5e', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, '46dc1251-3a43-408f-bd77-332bdff83211', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.75, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '71cbccec-52a8-4689-9355-3e7c01c4c123', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.65000000000000002, 'a51e7625-9188-4817-9b58-91467e68b50c', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.050000000000000003, '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.59999999999999998, '576225be-4bb7-4a72-9db7-456ff6290a5d', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00020000000000000001, '35026cab-a2dd-44a1-a988-b0eb869317f5', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.69999999999999996, 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.20000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.5, '6294cca2-02d4-4248-9533-a570b51e1ade', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '98501149-8f19-481e-a990-e70261877a5e', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, '46dc1251-3a43-408f-bd77-332bdff83211', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.40000000000000002, 'd7cb694c-1d4b-4026-be73-359c13fd2800', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0001, '02f4a2a4-c53e-4083-901c-88677f6a545a', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '71cbccec-52a8-4689-9355-3e7c01c4c123', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, 'a51e7625-9188-4817-9b58-91467e68b50c', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.089999999999999997, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.01, '576225be-4bb7-4a72-9db7-456ff6290a5d', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.80000000000000004, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0060000000000000001, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.123, 'd6884a2c-c3b8-48a0-8a3f-09399651901d', '1f233121-bde3-4782-bc16-648cfed17f1f', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, '98501149-8f19-481e-a990-e70261877a5e', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, '46dc1251-3a43-408f-bd77-332bdff83211', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, '71cbccec-52a8-4689-9355-3e7c01c4c123', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'a51e7625-9188-4817-9b58-91467e68b50c', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, '74e912f0-36c2-4deb-b76a-dd14d1295a19', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '576225be-4bb7-4a72-9db7-456ff6290a5d', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.0030000000000000001, 'c3eae285-e265-4fd7-9ac0-75565fd52485', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (0.00029999999999999997, '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');
INSERT INTO conn_rl_culture_religion (affinity, guid_religion, guid_culture, guid_timeperiod) VALUES (1, '728c2a8f-2671-4971-aaa7-b3b14ab4915a', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '3d7d5114-6fd8-4f3c-8267-efd813fa19c5');


--
-- Data for Name: conn_rl_entity_culture; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.78289596736431122, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '035c3a4f-9c27-4799-98b4-7831ce993b38', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.68819111911579967, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '319a0575-3e41-40cf-8a84-0a0515db0079', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.58116295980289578, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.11879045842215419, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.50598964467644691, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '60a94125-a2bb-49cf-915e-38995e626e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.81220442662015557, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.072822683956474066, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.72213384648784995, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.37142588896676898, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '2c9356c4-1332-4f1a-893a-479da470378f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.2811321122571826, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '5e0614b3-c737-4171-8733-9a1210ba9f70', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.67719320300966501, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '1f233121-bde3-4782-bc16-648cfed17f1f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.17465856811031699, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '6114f125-eb3d-45ac-8b03-9104600280dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.051109833177179098, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '88dced47-1dfe-411f-ab5c-c8128342296c', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.36905032116919756, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '6fcea565-0684-4609-a40d-00fab6956c7f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.79592326283454895, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '4fa0db88-70b4-4de9-843f-76a05488517f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.95077742543071508, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'cb7d878c-2438-456a-addb-c48f095fb51d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.89475234737619758, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.24437711015343666, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.62325696274638176, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'ced85788-6103-4859-bd11-5a7839c1bcee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.2521282103843987, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.93848056765273213, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.70080472249537706, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41926513239741325, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.49481802713125944, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.31450419221073389, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '61baa2d0-fc92-4661-a6e7-c1085516b281', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.70053196139633656, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '6a646ed4-05bc-4c55-8976-eba040ac081a', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.31544878054410219, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.92018657503649592, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.90110456105321646, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '553e1f35-b866-435f-813d-e9e1357ce102', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.18927146773785353, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.79931080946698785, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'ed625c6f-aac7-4035-a87f-58897b1064be', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.32943576574325562, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.39180170418694615, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.6087885950691998, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.026952670887112617, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.08371221786364913, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.51973302522674203, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'd827adae-575d-4787-ab8e-51b43b627c48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.93510665278881788, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.99344797199591994, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '0c552347-75de-453f-9467-fe5e2e0a15ef', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.84881843067705631, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.22636645333841443, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.7459016339853406, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '813d9513-7041-4ef9-9ca6-79ad395c4350', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.073308073915541172, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '035c3a4f-9c27-4799-98b4-7831ce993b38', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.47364437766373158, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '319a0575-3e41-40cf-8a84-0a0515db0079', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.59411597298458219, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.74654718767851591, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.57954322174191475, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '60a94125-a2bb-49cf-915e-38995e626e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.015255382284522057, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.3047988242469728, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.72892163414508104, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.40951955504715443, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '2c9356c4-1332-4f1a-893a-479da470378f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41857109544798732, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '5e0614b3-c737-4171-8733-9a1210ba9f70', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.877866605296731, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '1f233121-bde3-4782-bc16-648cfed17f1f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.10924229072406888, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '6114f125-eb3d-45ac-8b03-9104600280dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.0070252725854516029, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '88dced47-1dfe-411f-ab5c-c8128342296c', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.14757566247135401, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '6fcea565-0684-4609-a40d-00fab6956c7f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.57477736752480268, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '4fa0db88-70b4-4de9-843f-76a05488517f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.89026235044002533, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'cb7d878c-2438-456a-addb-c48f095fb51d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.30882106395438313, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.08648734912276268, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.42269783047959208, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'ced85788-6103-4859-bd11-5a7839c1bcee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.15919110598042607, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.92471851641312242, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.9873885759152472, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.55900442879647017, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.49634347669780254, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.96528833638876677, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '61baa2d0-fc92-4661-a6e7-c1085516b281', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.3552009966224432, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '6a646ed4-05bc-4c55-8976-eba040ac081a', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.97798429615795612, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.0020786654204130173, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.95115571701899171, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '553e1f35-b866-435f-813d-e9e1357ce102', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.91693654842674732, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.67604284547269344, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'ed625c6f-aac7-4035-a87f-58897b1064be', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.01296438230201602, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.46112587163224816, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.22084086993709207, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.24804861098527908, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.074841513764113188, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.27985641220584512, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'd827adae-575d-4787-ab8e-51b43b627c48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.71897164732217789, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.74475878570228815, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '0c552347-75de-453f-9467-fe5e2e0a15ef', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.86372842593118548, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.044337701518088579, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.18614792311564088, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '813d9513-7041-4ef9-9ca6-79ad395c4350', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.322265749797225, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '035c3a4f-9c27-4799-98b4-7831ce993b38', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.6290833386592567, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '319a0575-3e41-40cf-8a84-0a0515db0079', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.8450654111802578, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.066918700002133846, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.11490613827481866, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '60a94125-a2bb-49cf-915e-38995e626e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.4022514820098877, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.073623999021947384, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.38370691286399961, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.26202494697645307, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '2c9356c4-1332-4f1a-893a-479da470378f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.83100004261359572, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '5e0614b3-c737-4171-8733-9a1210ba9f70', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.51270357053726912, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '1f233121-bde3-4782-bc16-648cfed17f1f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.012689509894698858, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '6114f125-eb3d-45ac-8b03-9104600280dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.98845816170796752, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '88dced47-1dfe-411f-ab5c-c8128342296c', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.62455239659175277, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '6fcea565-0684-4609-a40d-00fab6956c7f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.30472837900742888, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '4fa0db88-70b4-4de9-843f-76a05488517f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.28400263888761401, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'cb7d878c-2438-456a-addb-c48f095fb51d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.65378370182588696, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41876273741945624, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.90679087629541755, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'ced85788-6103-4859-bd11-5a7839c1bcee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.09986423933878541, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.27461242116987705, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.48493712861090899, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41609355481341481, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.71416134387254715, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.91889382665976882, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '61baa2d0-fc92-4661-a6e7-c1085516b281', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.33584621315822005, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '6a646ed4-05bc-4c55-8976-eba040ac081a', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.033359641674906015, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.37155758589506149, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.75596534973010421, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '553e1f35-b866-435f-813d-e9e1357ce102', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.54685241403058171, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.80156583059579134, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'ed625c6f-aac7-4035-a87f-58897b1064be', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.5704644275829196, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.30857477569952607, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.26757948845624924, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.82188346097245812, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.46513893362134695, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.43417308293282986, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'd827adae-575d-4787-ab8e-51b43b627c48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.099598843138664961, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.69402172276750207, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '0c552347-75de-453f-9467-fe5e2e0a15ef', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.04619819950312376, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.80635482119396329, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.54823412047699094, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '813d9513-7041-4ef9-9ca6-79ad395c4350', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.0685053626075387, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '035c3a4f-9c27-4799-98b4-7831ce993b38', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.19007724383845925, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '319a0575-3e41-40cf-8a84-0a0515db0079', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.67048553237691522, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'af937cb1-fc86-4613-a418-4666ffa4eca6', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.80245730374008417, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.6261728061363101, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '60a94125-a2bb-49cf-915e-38995e626e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41612994996830821, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '35db50ff-8b29-42f5-bf3b-44c3f982d838', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.61049593705683947, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'ebf1208f-33ce-4586-9933-ee2dcd905dc9', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.47725500864908099, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '4aaaaa8c-2153-49da-beea-df0cc3c6a13d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.035856430884450674, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '2c9356c4-1332-4f1a-893a-479da470378f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.47053298959508538, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '5e0614b3-c737-4171-8733-9a1210ba9f70', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.13986097229644656, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '1f233121-bde3-4782-bc16-648cfed17f1f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.37969681527465582, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '6114f125-eb3d-45ac-8b03-9104600280dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.083437714725732803, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '88dced47-1dfe-411f-ab5c-c8128342296c', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41987718688324094, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '6fcea565-0684-4609-a40d-00fab6956c7f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.47536357771605253, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '4fa0db88-70b4-4de9-843f-76a05488517f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.68577749142423272, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'cb7d878c-2438-456a-addb-c48f095fb51d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.14101395150646567, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.30092101497575641, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.67693872516974807, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'ced85788-6103-4859-bd11-5a7839c1bcee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.88309582229703665, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '590b9ce2-176e-42b5-9d2f-c3ad844d5314', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.95865300856530666, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'dff010e5-7daa-4e8c-b8af-9974aadb6b61', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.068663447629660368, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'bbe95f4e-15e7-42a5-96c2-df97b56f3315', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.95339784165844321, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '7e713bf0-5750-418a-99e8-3c564d5d4af2', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.82836359739303589, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.74615598656237125, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '61baa2d0-fc92-4661-a6e7-c1085516b281', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.41051975917071104, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '6a646ed4-05bc-4c55-8976-eba040ac081a', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.80796785186976194, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '98a96d68-df83-44d9-b0e0-bcd04613f1de', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.56302310200408101, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'ccd117db-a125-44d1-8424-d5ccd3c39c4d', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.079527464229613543, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '553e1f35-b866-435f-813d-e9e1357ce102', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.26343065313994884, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'a751fd26-cb26-4d6a-a627-e2def5659fba', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.49828783189877868, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'ed625c6f-aac7-4035-a87f-58897b1064be', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.5399293745867908, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '1ccae3bb-d478-44fb-9c23-87e6cccc95dc', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.055727056693285704, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'a1e09d8e-7c39-41b4-947f-d151fd9ba470', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.66230384679511189, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'acdc0ba3-a33a-4b15-ad41-df9478c5c898', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.13486005319282413, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.44478848110884428, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '9a35af6c-7885-4a6c-990f-263e22a7d7dd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.64712712727487087, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'd827adae-575d-4787-ab8e-51b43b627c48', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.95700454385951161, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'f333c0f8-b89b-4170-b4ff-c168d2d9d49f', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.46514632645994425, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '0c552347-75de-453f-9467-fe5e2e0a15ef', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.29412428429350257, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '53550b3c-8d6a-46cd-ad8c-1521360aa0bd', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.51943745464086533, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'ecde93fe-2974-487b-8908-bf8c5d7e6162', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');
INSERT INTO conn_rl_entity_culture (affinity, guid_entity, guid_culture, guid_timeperiod) VALUES (0.82152860565111041, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '813d9513-7041-4ef9-9ca6-79ad395c4350', '8e79825e-6ee3-4c99-bfd2-8794f62508ee');


--
-- Data for Name: conn_rl_entity_religion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.59389138827100396, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '46dc1251-3a43-408f-bd77-332bdff83211', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.96317466348409653, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '02f4a2a4-c53e-4083-901c-88677f6a545a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.74152366351336241, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '576225be-4bb7-4a72-9db7-456ff6290a5d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.15302232978865504, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '6294cca2-02d4-4248-9533-a570b51e1ade', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.71251307846978307, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.95100825652480125, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'a51e7625-9188-4817-9b58-91467e68b50c', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.98218241333961487, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.27923303283751011, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'd049036f-effb-4c5c-9a39-01ce00213e50', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.80440617259591818, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.27770480047911406, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '35026cab-a2dd-44a1-a988-b0eb869317f5', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.99525670148432255, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '71cbccec-52a8-4689-9355-3e7c01c4c123', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.32429658342152834, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.37206608150154352, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.16727177565917373, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.89847643161192536, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.80338811920955777, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.44827126385644078, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.97651209915056825, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'd6884a2c-c3b8-48a0-8a3f-09399651901d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.13584171887487173, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '728c2a8f-2671-4971-aaa7-b3b14ab4915a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.73638033168390393, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '98501149-8f19-481e-a990-e70261877a5e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.56797751598060131, 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.028844074811786413, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '46dc1251-3a43-408f-bd77-332bdff83211', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.30833088932558894, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '02f4a2a4-c53e-4083-901c-88677f6a545a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.61199210956692696, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '576225be-4bb7-4a72-9db7-456ff6290a5d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.50943948747590184, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '6294cca2-02d4-4248-9533-a570b51e1ade', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.6387905334122479, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.2139040706679225, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'a51e7625-9188-4817-9b58-91467e68b50c', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.32908882666379213, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.77681821910664439, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'd049036f-effb-4c5c-9a39-01ce00213e50', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.83935779379680753, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.6665209629572928, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '35026cab-a2dd-44a1-a988-b0eb869317f5', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.68308953335508704, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '71cbccec-52a8-4689-9355-3e7c01c4c123', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.62434189952909946, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.91306036477908492, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.77322443341836333, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.41203435882925987, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.79463416989892721, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.011158508714288473, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.18649541307240725, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'd6884a2c-c3b8-48a0-8a3f-09399651901d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.67368077300488949, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '728c2a8f-2671-4971-aaa7-b3b14ab4915a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.82380554545670748, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '98501149-8f19-481e-a990-e70261877a5e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.55855191871523857, '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.99906701827421784, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '46dc1251-3a43-408f-bd77-332bdff83211', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.13988153543323278, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '02f4a2a4-c53e-4083-901c-88677f6a545a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.46913915313780308, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '576225be-4bb7-4a72-9db7-456ff6290a5d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.30812788242474198, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '6294cca2-02d4-4248-9533-a570b51e1ade', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.071329711005091667, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.23092676652595401, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'a51e7625-9188-4817-9b58-91467e68b50c', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.46063730260357261, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.49323551403358579, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'd049036f-effb-4c5c-9a39-01ce00213e50', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.66662241751328111, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.699609131552279, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '35026cab-a2dd-44a1-a988-b0eb869317f5', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.73740078136324883, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '71cbccec-52a8-4689-9355-3e7c01c4c123', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.58601296367123723, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.88446969958022237, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.15722124138846993, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.67898342898115516, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.39882103214040399, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.92170009389519691, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.82186957215890288, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'd6884a2c-c3b8-48a0-8a3f-09399651901d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.60882089380174875, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '728c2a8f-2671-4971-aaa7-b3b14ab4915a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.25294838799163699, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '98501149-8f19-481e-a990-e70261877a5e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.12999845715239644, '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.88936606934294105, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '46dc1251-3a43-408f-bd77-332bdff83211', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.26301974430680275, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '02f4a2a4-c53e-4083-901c-88677f6a545a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.41058968333527446, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '576225be-4bb7-4a72-9db7-456ff6290a5d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.97756332997232676, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '6294cca2-02d4-4248-9533-a570b51e1ade', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.37013867683708668, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.66778167570009828, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'a51e7625-9188-4817-9b58-91467e68b50c', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.041022324934601784, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.74204184161499143, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'd049036f-effb-4c5c-9a39-01ce00213e50', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.90931191621348262, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'd7cb694c-1d4b-4026-be73-359c13fd2800', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.34022268978878856, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '35026cab-a2dd-44a1-a988-b0eb869317f5', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.42870957311242819, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '71cbccec-52a8-4689-9355-3e7c01c4c123', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.26980728143826127, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.18419985007494688, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '8519096f-9bc1-4668-b3ee-b931ea4f978e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.26114914426580071, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '74e912f0-36c2-4deb-b76a-dd14d1295a19', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.57915105251595378, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '508fccbf-4b7f-41f9-8fd5-6763769963bb', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.71906100027263165, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '4dc42a11-61e0-44dd-8b48-49a8122ef259', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.64240288501605392, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '97088d37-c516-4448-a4d1-dc5fcb5547bc', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.20841682888567448, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'd6884a2c-c3b8-48a0-8a3f-09399651901d', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.62772574229165912, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '728c2a8f-2671-4971-aaa7-b3b14ab4915a', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.47543856920674443, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '98501149-8f19-481e-a990-e70261877a5e', 'daa333f4-9434-40c5-9f01-7fd93f943b66');
INSERT INTO conn_rl_entity_religion (affinity, guid_entity, guid_religion, guid_timeperiod) VALUES (0.058608480263501406, 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', 'c3eae285-e265-4fd7-9ac0-75565fd52485', 'daa333f4-9434-40c5-9f01-7fd93f943b66');


--
-- Data for Name: cul_culture; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('035c3a4f-9c27-4799-98b4-7831ce993b38', 'Akaens');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('319a0575-3e41-40cf-8a84-0a0515db0079', 'Anmari');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('af937cb1-fc86-4613-a418-4666ffa4eca6', 'Ardian Islanders');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('4d8b83cc-f81c-4719-8c1b-f1f5d70e9a48', 'Asyrai');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('60a94125-a2bb-49cf-915e-38995e626e7e', 'Avélians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('35db50ff-8b29-42f5-bf3b-44c3f982d838', 'Central Corovians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('ebf1208f-33ce-4586-9933-ee2dcd905dc9', 'Dharavana');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('4aaaaa8c-2153-49da-beea-df0cc3c6a13d', 'Eastern Imperials');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('2c9356c4-1332-4f1a-893a-479da470378f', 'Glavians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('5e0614b3-c737-4171-8733-9a1210ba9f70', 'Hengaldans');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('1f233121-bde3-4782-bc16-648cfed17f1f', 'Igni');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('6114f125-eb3d-45ac-8b03-9104600280dc', 'Igyrian');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('88dced47-1dfe-411f-ab5c-c8128342296c', 'Imperial Anmari');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('6fcea565-0684-4609-a40d-00fab6956c7f', 'Imperial Asyrai');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('4fa0db88-70b4-4de9-843f-76a05488517f', 'Imperial Avélian');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('cb7d878c-2438-456a-addb-c48f095fb51d', 'Imperial Igni');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('e22ff4b7-1bc3-4530-bbb8-a4b266a3fef1', 'Imperial Igyrian');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('b5f64184-33ec-4bca-bca0-ac8f01b7a1f2', 'Imperial Jian');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('ced85788-6103-4859-bd11-5a7839c1bcee', 'Imperial Maghiri');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('590b9ce2-176e-42b5-9d2f-c3ad844d5314', 'Imperial Nuriani');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('dff010e5-7daa-4e8c-b8af-9974aadb6b61', 'Imperial Sarranids');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('bbe95f4e-15e7-42a5-96c2-df97b56f3315', 'Imperial Sudusi');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('7e713bf0-5750-418a-99e8-3c564d5d4af2', 'Imperial Turiq');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('2a4d5327-0b4a-4ecc-91aa-121f3efee6ee', 'Jian');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('61baa2d0-fc92-4661-a6e7-c1085516b281', 'Khûn');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('6a646ed4-05bc-4c55-8976-eba040ac081a', 'Maghiri');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('98a96d68-df83-44d9-b0e0-bcd04613f1de', 'Northern Corovians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('ccd117db-a125-44d1-8424-d5ccd3c39c4d', 'Nuriani');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('553e1f35-b866-435f-813d-e9e1357ce102', 'Orundians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('a751fd26-cb26-4d6a-a627-e2def5659fba', 'Sarranids');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('ed625c6f-aac7-4035-a87f-58897b1064be', 'Shar');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('1ccae3bb-d478-44fb-9c23-87e6cccc95dc', 'Sirenic Islanders');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('a1e09d8e-7c39-41b4-947f-d151fd9ba470', 'Southern Corovians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('acdc0ba3-a33a-4b15-ad41-df9478c5c898', 'Sternogoths');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('35cf80b5-47dc-4a4c-bab2-a604a26d5e7e', 'Stygians');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('9a35af6c-7885-4a6c-990f-263e22a7d7dd', 'Sudusi');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('d827adae-575d-4787-ab8e-51b43b627c48', 'Sunogoths');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('f333c0f8-b89b-4170-b4ff-c168d2d9d49f', 'Sykelian Islanders');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('0c552347-75de-453f-9467-fe5e2e0a15ef', 'Sylvans');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('53550b3c-8d6a-46cd-ad8c-1521360aa0bd', 'Tèneans');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('ecde93fe-2974-487b-8908-bf8c5d7e6162', 'Turiq');
INSERT INTO cul_culture (guid_culture, name_culture) VALUES ('813d9513-7041-4ef9-9ca6-79ad395c4350', 'Velki');


--
-- Data for Name: cul_culture_rl_hierarchy; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: cul_culturegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: entity_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO entity_entity (guid_entity, guid_timeperiod, guid_entitytype) VALUES ('e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', 'c3546da0-23c4-40e9-9a33-5131c14a5564', 'd3fb59e7-2d16-4632-bf41-1978fc0a4556');
INSERT INTO entity_entity (guid_entity, guid_timeperiod, guid_entitytype) VALUES ('37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', 'e8602d57-9767-49c2-a573-820d0edc41e2', 'd3fb59e7-2d16-4632-bf41-1978fc0a4556');
INSERT INTO entity_entity (guid_entity, guid_timeperiod, guid_entitytype) VALUES ('9f1f3800-5ccc-4dd7-a5f1-76af234c904e', 'c2d8242f-32c5-4287-a701-75f08c513de4', 'd3fb59e7-2d16-4632-bf41-1978fc0a4556');
INSERT INTO entity_entity (guid_entity, guid_timeperiod, guid_entitytype) VALUES ('e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '9d839051-f10d-4454-a1a8-2700593bed23', 'd3fb59e7-2d16-4632-bf41-1978fc0a4556');
INSERT INTO entity_entity (guid_entity, guid_timeperiod, guid_entitytype) VALUES ('bb4acd67-576b-433d-aabd-fa3b83759822', '7329cce1-62f7-41cf-ab6c-0e6b7e8a47fa', '3495413a-5891-42df-8c10-e1fde7a53b99');


--
-- Data for Name: entity_entitydetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO entity_entitydetail (value_detail, guid_entity, guid_timeperiod, guid_detailtype) VALUES ('Apulia', 'e8eba2a5-3d4d-4ef7-bc24-d51c6e1e0db4', '2d42f4dc-b906-40db-b09c-7250bfecb7b8', 'f678b3b6-c5b0-4214-89ff-d1fefee04c22');
INSERT INTO entity_entitydetail (value_detail, guid_entity, guid_timeperiod, guid_detailtype) VALUES ('Cisalpine Gaul', '37e1b71f-cf00-448d-a9bc-ff9ca3e08ea9', '24a9657b-c5db-4d86-903a-1bfda53b593a', 'f678b3b6-c5b0-4214-89ff-d1fefee04c22');
INSERT INTO entity_entitydetail (value_detail, guid_entity, guid_timeperiod, guid_detailtype) VALUES ('Transalpine Gaul', '9f1f3800-5ccc-4dd7-a5f1-76af234c904e', '411e75e9-6623-4980-a06f-b50bc2eec991', 'f678b3b6-c5b0-4214-89ff-d1fefee04c22');
INSERT INTO entity_entitydetail (value_detail, guid_entity, guid_timeperiod, guid_detailtype) VALUES ('Moesia', 'e45bfe32-829b-49b9-8fc4-d7f64b90faa1', '36c4bd74-3a01-4038-8def-e055fee3a420', 'f678b3b6-c5b0-4214-89ff-d1fefee04c22');
INSERT INTO entity_entitydetail (value_detail, guid_entity, guid_timeperiod, guid_detailtype) VALUES ('Lopermir', 'bb4acd67-576b-433d-aabd-fa3b83759822', '9d5b4c1f-0c74-4cf0-bbe1-32935145d209', 'f678b3b6-c5b0-4214-89ff-d1fefee04c22');


--
-- Data for Name: entity_lu_detailtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO entity_lu_detailtype (guid_detailtype, name_detailtype) VALUES ('f678b3b6-c5b0-4214-89ff-d1fefee04c22', 'Name');
INSERT INTO entity_lu_detailtype (guid_detailtype, name_detailtype) VALUES ('42b82950-fec1-48e9-9a11-166a0de21d75', 'Secondary Name');
INSERT INTO entity_lu_detailtype (guid_detailtype, name_detailtype) VALUES ('7dc23eb7-1163-4238-94d5-485c4edfa7e4', 'Tertiary Name');
INSERT INTO entity_lu_detailtype (guid_detailtype, name_detailtype) VALUES ('1cb0dace-558b-4369-b814-73c92de83754', 'Primary Title');
INSERT INTO entity_lu_detailtype (guid_detailtype, name_detailtype) VALUES ('daf1d4c1-e42f-4766-aaad-ec9037b9def3', 'Secondary Title');
INSERT INTO entity_lu_detailtype (guid_detailtype, name_detailtype) VALUES ('01c5139d-4d04-4d20-975c-81698d3f72f3', 'Description');


--
-- Data for Name: entity_lu_entitytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('d3fb59e7-2d16-4632-bf41-1978fc0a4556', 'Region');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('febf2480-6e5d-4c7d-89c4-38ec2c4ea991', 'State');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('a338d420-67c1-4b49-9732-2cedc85661f2', 'Territory');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('10e3039a-5e88-43ea-8a28-ef72afebe7a7', 'Person');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('076d0602-d27a-4be7-9b5f-6dad4503a04a', 'City');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('3495413a-5891-42df-8c10-e1fde7a53b99', 'Deity');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('603b88e8-fb3d-4588-9fc3-4ba6b0941fbd', 'Town');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('5ea6bfbf-b6d8-40c4-a7f5-89524b672aba', 'Village');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('1052ec74-cdc4-43e1-81f0-0e8b21812cba', 'Metropolis');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('f1b3600b-057c-4c25-b59a-8d4eaeddc984', 'Monster');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('1f85a9ec-ee69-4e2e-9368-c356020a2034', 'Kingdom');
INSERT INTO entity_lu_entitytype (guid_entitytype, name_entitytype) VALUES ('81aa6048-3cb9-4dbc-8ebd-a75cfca80c31', 'Empire');


--
-- Data for Name: entity_rl_entity_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: entity_rl_entitytype_detailtype; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_datasource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_model; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_name; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_name_era; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_name_gender; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_name_language; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_output; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO markov_output (markov_output) VALUES ('Lopermir');
INSERT INTO markov_output (markov_output) VALUES ('Elio');
INSERT INTO markov_output (markov_output) VALUES ('Teo');
INSERT INTO markov_output (markov_output) VALUES ('Mariminierina');
INSERT INTO markov_output (markov_output) VALUES ('Uxímo');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Déborgio');
INSERT INTO markov_output (markov_output) VALUES ('Frald');
INSERT INTO markov_output (markov_output) VALUES ('Ser');
INSERT INTO markov_output (markov_output) VALUES ('Albjørgilf');
INSERT INTO markov_output (markov_output) VALUES ('Bald');
INSERT INTO markov_output (markov_output) VALUES ('Tor');
INSERT INTO markov_output (markov_output) VALUES ('Olipargrio');
INSERT INTO markov_output (markov_output) VALUES ('Rosiv');
INSERT INTO markov_output (markov_output) VALUES ('Asta');
INSERT INTO markov_output (markov_output) VALUES ('Hención');
INSERT INTO markov_output (markov_output) VALUES ('Aurleina');
INSERT INTO markov_output (markov_output) VALUES ('Albjørg');
INSERT INTO markov_output (markov_output) VALUES ('Cebete');
INSERT INTO markov_output (markov_output) VALUES ('Romónie');
INSERT INTO markov_output (markov_output) VALUES ('Thoreantse');
INSERT INTO markov_output (markov_output) VALUES ('Idal');
INSERT INTO markov_output (markov_output) VALUES ('Cecian');
INSERT INTO markov_output (markov_output) VALUES ('Maj');
INSERT INTO markov_output (markov_output) VALUES ('Gren');
INSERT INTO markov_output (markov_output) VALUES ('Sabio');
INSERT INTO markov_output (markov_output) VALUES ('Adersta');
INSERT INTO markov_output (markov_output) VALUES ('Gel');
INSERT INTO markov_output (markov_output) VALUES ('Sabrosé');
INSERT INTO markov_output (markov_output) VALUES ('Pelasie');
INSERT INTO markov_output (markov_output) VALUES ('Fel');
INSERT INTO markov_output (markov_output) VALUES ('Bertela');
INSERT INTO markov_output (markov_output) VALUES ('Thora');
INSERT INTO markov_output (markov_output) VALUES ('Miroladio');
INSERT INTO markov_output (markov_output) VALUES ('Sathere');
INSERT INTO markov_output (markov_output) VALUES ('Karinidenida');
INSERT INTO markov_output (markov_output) VALUES ('Paberia');
INSERT INTO markov_output (markov_output) VALUES ('Ariamila');
INSERT INTO markov_output (markov_output) VALUES ('Abalda');
INSERT INTO markov_output (markov_output) VALUES ('Lea');
INSERT INTO markov_output (markov_output) VALUES ('Elianetin');
INSERT INTO markov_output (markov_output) VALUES ('Hil');
INSERT INTO markov_output (markov_output) VALUES ('Lor');
INSERT INTO markov_output (markov_output) VALUES ('Mirin');
INSERT INTO markov_output (markov_output) VALUES ('Fuel');
INSERT INTO markov_output (markov_output) VALUES ('Ilindelaia');
INSERT INTO markov_output (markov_output) VALUES ('Jovik');
INSERT INTO markov_output (markov_output) VALUES ('Iso');
INSERT INTO markov_output (markov_output) VALUES ('Jeste');
INSERT INTO markov_output (markov_output) VALUES ('Pelf');
INSERT INTO markov_output (markov_output) VALUES ('Eskuno');
INSERT INTO markov_output (markov_output) VALUES ('Anla');
INSERT INTO markov_output (markov_output) VALUES ('Angelm');
INSERT INTO markov_output (markov_output) VALUES ('Jona');
INSERT INTO markov_output (markov_output) VALUES ('Gudia');
INSERT INTO markov_output (markov_output) VALUES ('Tonin');
INSERT INTO markov_output (markov_output) VALUES ('Olindorindel');
INSERT INTO markov_output (markov_output) VALUES ('Ell');
INSERT INTO markov_output (markov_output) VALUES ('Sofildegorentina');
INSERT INTO markov_output (markov_output) VALUES ('Myri');
INSERT INTO markov_output (markov_output) VALUES ('Bas');
INSERT INTO markov_output (markov_output) VALUES ('Yese');
INSERT INTO markov_output (markov_output) VALUES ('Cirsio');
INSERT INTO markov_output (markov_output) VALUES ('Bensa');
INSERT INTO markov_output (markov_output) VALUES ('Rocolio');
INSERT INTO markov_output (markov_output) VALUES ('Jørne');
INSERT INTO markov_output (markov_output) VALUES ('Gotz');
INSERT INTO markov_output (markov_output) VALUES ('Ceckeniansena');
INSERT INTO markov_output (markov_output) VALUES ('Daldesto');
INSERT INTO markov_output (markov_output) VALUES ('Egoriolinorinina');
INSERT INTO markov_output (markov_output) VALUES ('Lupeu');
INSERT INTO markov_output (markov_output) VALUES ('Meliz');
INSERT INTO markov_output (markov_output) VALUES ('Mirinan');
INSERT INTO markov_output (markov_output) VALUES ('Corente');
INSERT INTO markov_output (markov_output) VALUES ('Tro');
INSERT INTO markov_output (markov_output) VALUES ('Prin');
INSERT INTO markov_output (markov_output) VALUES ('Petefaelona');
INSERT INTO markov_output (markov_output) VALUES ('Antasinor');
INSERT INTO markov_output (markov_output) VALUES ('Inguse');
INSERT INTO markov_output (markov_output) VALUES ('Gisto');
INSERT INTO markov_output (markov_output) VALUES ('Håvarethria');
INSERT INTO markov_output (markov_output) VALUES ('Lisalio');
INSERT INTO markov_output (markov_output) VALUES ('Ición');
INSERT INTO markov_output (markov_output) VALUES ('Reinelda');
INSERT INTO markov_output (markov_output) VALUES ('Egusa');
INSERT INTO markov_output (markov_output) VALUES ('Alvonio');
INSERT INTO markov_output (markov_output) VALUES ('Ragerelia');
INSERT INTO markov_output (markov_output) VALUES ('Everta');
INSERT INTO markov_output (markov_output) VALUES ('Serio');
INSERT INTO markov_output (markov_output) VALUES ('Nictefo');
INSERT INTO markov_output (markov_output) VALUES ('Serinicteferike');
INSERT INTO markov_output (markov_output) VALUES ('Indré');
INSERT INTO markov_output (markov_output) VALUES ('Margila');
INSERT INTO markov_output (markov_output) VALUES ('Rica');
INSERT INTO markov_output (markov_output) VALUES ('Gra');
INSERT INTO markov_output (markov_output) VALUES ('Asbetzaristhere');
INSERT INTO markov_output (markov_output) VALUES ('Aniera');
INSERT INTO markov_output (markov_output) VALUES ('Heline');
INSERT INTO markov_output (markov_output) VALUES ('Lorachor');
INSERT INTO markov_output (markov_output) VALUES ('Clejalvine');
INSERT INTO markov_output (markov_output) VALUES ('Ader');
INSERT INTO markov_output (markov_output) VALUES ('Tertuo');
INSERT INTO markov_output (markov_output) VALUES ('Helipio');
INSERT INTO markov_output (markov_output) VALUES ('Aug');
INSERT INTO markov_output (markov_output) VALUES ('Waldrundrainge');
INSERT INTO markov_output (markov_output) VALUES ('Maia');
INSERT INTO markov_output (markov_output) VALUES ('Agny');
INSERT INTO markov_output (markov_output) VALUES ('Oddy');
INSERT INTO markov_output (markov_output) VALUES ('Romer');
INSERT INTO markov_output (markov_output) VALUES ('Lucio');
INSERT INTO markov_output (markov_output) VALUES ('Marise');
INSERT INTO markov_output (markov_output) VALUES ('Pett');
INSERT INTO markov_output (markov_output) VALUES ('Viro');
INSERT INTO markov_output (markov_output) VALUES ('Cor');
INSERT INTO markov_output (markov_output) VALUES ('Pomeresueliann');
INSERT INTO markov_output (markov_output) VALUES ('Frilderikariste');
INSERT INTO markov_output (markov_output) VALUES ('Stebia');
INSERT INTO markov_output (markov_output) VALUES ('Sylver');
INSERT INTO markov_output (markov_output) VALUES ('Litz');
INSERT INTO markov_output (markov_output) VALUES ('Cruzkimino');
INSERT INTO markov_output (markov_output) VALUES ('Ernielia');
INSERT INTO markov_output (markov_output) VALUES ('Anicia');
INSERT INTO markov_output (markov_output) VALUES ('Ron');
INSERT INTO markov_output (markov_output) VALUES ('Elsano');
INSERT INTO markov_output (markov_output) VALUES ('Car');
INSERT INTO markov_output (markov_output) VALUES ('Jos');
INSERT INTO markov_output (markov_output) VALUES ('Hed');
INSERT INTO markov_output (markov_output) VALUES ('Wilicenra');
INSERT INTO markov_output (markov_output) VALUES ('Una');
INSERT INTO markov_output (markov_output) VALUES ('Alfonsarg');
INSERT INTO markov_output (markov_output) VALUES ('Oihano');
INSERT INTO markov_output (markov_output) VALUES ('Åsgelfigorteidimmirnter');
INSERT INTO markov_output (markov_output) VALUES ('Horethrocaris');
INSERT INTO markov_output (markov_output) VALUES ('Gone');
INSERT INTO markov_output (markov_output) VALUES ('Rosiannie');
INSERT INTO markov_output (markov_output) VALUES ('Elídaria');
INSERT INTO markov_output (markov_output) VALUES ('Cam');
INSERT INTO markov_output (markov_output) VALUES ('Domerio');
INSERT INTO markov_output (markov_output) VALUES ('Loulaulasia');
INSERT INTO markov_output (markov_output) VALUES ('Håkaid');
INSERT INTO markov_output (markov_output) VALUES ('Vaser');
INSERT INTO markov_output (markov_output) VALUES ('Gje');
INSERT INTO markov_output (markov_output) VALUES ('Hegelaurina');
INSERT INTO markov_output (markov_output) VALUES ('Gundressa');
INSERT INTO markov_output (markov_output) VALUES ('Vivire');
INSERT INTO markov_output (markov_output) VALUES ('Lihanzancionnilana');
INSERT INTO markov_output (markov_output) VALUES ('Sabiellenalenielomelaudia');
INSERT INTO markov_output (markov_output) VALUES ('Joelis');
INSERT INTO markov_output (markov_output) VALUES ('Mirga');
INSERT INTO markov_output (markov_output) VALUES ('Ingelenzazu');
INSERT INTO markov_output (markov_output) VALUES ('Don');
INSERT INTO markov_output (markov_output) VALUES ('Amedia');
INSERT INTO markov_output (markov_output) VALUES ('Car');
INSERT INTO markov_output (markov_output) VALUES ('Arcio');
INSERT INTO markov_output (markov_output) VALUES ('Valica');
INSERT INTO markov_output (markov_output) VALUES ('Sverdor');
INSERT INTO markov_output (markov_output) VALUES ('Saulaya');
INSERT INTO markov_output (markov_output) VALUES ('Beñaka');
INSERT INTO markov_output (markov_output) VALUES ('Eldelino');
INSERT INTO markov_output (markov_output) VALUES ('Xabla');
INSERT INTO markov_output (markov_output) VALUES ('Vicia');
INSERT INTO markov_output (markov_output) VALUES ('Dignasi');
INSERT INTO markov_output (markov_output) VALUES ('And');
INSERT INTO markov_output (markov_output) VALUES ('Rodor');
INSERT INTO markov_output (markov_output) VALUES ('Soro');
INSERT INTO markov_output (markov_output) VALUES ('Mer');
INSERT INTO markov_output (markov_output) VALUES ('Pauriciller');
INSERT INTO markov_output (markov_output) VALUES ('Vita');
INSERT INTO markov_output (markov_output) VALUES ('Mironsalda');
INSERT INTO markov_output (markov_output) VALUES ('Clenendveta');
INSERT INTO markov_output (markov_output) VALUES ('Ale');
INSERT INTO markov_output (markov_output) VALUES ('Louitt');
INSERT INTO markov_output (markov_output) VALUES ('Vítor');
INSERT INTO markov_output (markov_output) VALUES ('Litanilmonición');
INSERT INTO markov_output (markov_output) VALUES ('Guredore');
INSERT INTO markov_output (markov_output) VALUES ('Libekone');
INSERT INTO markov_output (markov_output) VALUES ('Sont');
INSERT INTO markov_output (markov_output) VALUES ('Sallo');
INSERT INTO markov_output (markov_output) VALUES ('Sustia');
INSERT INTO markov_output (markov_output) VALUES ('Gus');
INSERT INTO markov_output (markov_output) VALUES ('Agdalfrián');
INSERT INTO markov_output (markov_output) VALUES ('Cilia');
INSERT INTO markov_output (markov_output) VALUES ('Jes');
INSERT INTO markov_output (markov_output) VALUES ('Gis');
INSERT INTO markov_output (markov_output) VALUES ('Bjørga');
INSERT INTO markov_output (markov_output) VALUES ('Catrie');
INSERT INTO markov_output (markov_output) VALUES ('Aassesanne');
INSERT INTO markov_output (markov_output) VALUES ('Albjørgune');
INSERT INTO markov_output (markov_output) VALUES ('Gude');
INSERT INTO markov_output (markov_output) VALUES ('Mim');
INSERT INTO markov_output (markov_output) VALUES ('Bietor');
INSERT INTO markov_output (markov_output) VALUES ('Gilittind');
INSERT INTO markov_output (markov_output) VALUES ('Elindia');
INSERT INTO markov_output (markov_output) VALUES ('Sam');
INSERT INTO markov_output (markov_output) VALUES ('Turida');
INSERT INTO markov_output (markov_output) VALUES ('Johs');
INSERT INTO markov_output (markov_output) VALUES ('Åslaug');
INSERT INTO markov_output (markov_output) VALUES ('Ekal');
INSERT INTO markov_output (markov_output) VALUES ('Tald');
INSERT INTO markov_output (markov_output) VALUES ('Fátino');
INSERT INTO markov_output (markov_output) VALUES ('Perid');
INSERT INTO markov_output (markov_output) VALUES ('Arne');
INSERT INTO markov_output (markov_output) VALUES ('Johertagnvoritl');
INSERT INTO markov_output (markov_output) VALUES ('Crista');
INSERT INTO markov_output (markov_output) VALUES ('Elly');
INSERT INTO markov_output (markov_output) VALUES ('Oihe');
INSERT INTO markov_output (markov_output) VALUES ('Åge');
INSERT INTO markov_output (markov_output) VALUES ('Estritto');
INSERT INTO markov_output (markov_output) VALUES ('Jano');
INSERT INTO markov_output (markov_output) VALUES ('Krisbete');
INSERT INTO markov_output (markov_output) VALUES ('Gusta');
INSERT INTO markov_output (markov_output) VALUES ('Domanalesidalvida');
INSERT INTO markov_output (markov_output) VALUES ('Nohs');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Melin');
INSERT INTO markov_output (markov_output) VALUES ('Herva');
INSERT INTO markov_output (markov_output) VALUES ('Margnarel');
INSERT INTO markov_output (markov_output) VALUES ('Lucias');
INSERT INTO markov_output (markov_output) VALUES ('Prón');
INSERT INTO markov_output (markov_output) VALUES ('Valla');
INSERT INTO markov_output (markov_output) VALUES ('Carcia');
INSERT INTO markov_output (markov_output) VALUES ('Katz');
INSERT INTO markov_output (markov_output) VALUES ('Clacio');
INSERT INTO markov_output (markov_output) VALUES ('Toronto');
INSERT INTO markov_output (markov_output) VALUES ('Marlfren');
INSERT INTO markov_output (markov_output) VALUES ('Bruttenibio');
INSERT INTO markov_output (markov_output) VALUES ('Balvine');
INSERT INTO markov_output (markov_output) VALUES ('Bride');
INSERT INTO markov_output (markov_output) VALUES ('Hermonstin');
INSERT INTO markov_output (markov_output) VALUES ('Kare');
INSERT INTO markov_output (markov_output) VALUES ('Conictoro');
INSERT INTO markov_output (markov_output) VALUES ('Elma');
INSERT INTO markov_output (markov_output) VALUES ('Ern');
INSERT INTO markov_output (markov_output) VALUES ('Varia');
INSERT INTO markov_output (markov_output) VALUES ('Nekketana');
INSERT INTO markov_output (markov_output) VALUES ('Imelot');
INSERT INTO markov_output (markov_output) VALUES ('Clen');
INSERT INTO markov_output (markov_output) VALUES ('Ete');
INSERT INTO markov_output (markov_output) VALUES ('Amarmandor');
INSERT INTO markov_output (markov_output) VALUES ('Lina');
INSERT INTO markov_output (markov_output) VALUES ('Chertuan');
INSERT INTO markov_output (markov_output) VALUES ('Cay');
INSERT INTO markov_output (markov_output) VALUES ('Elsard');
INSERT INTO markov_output (markov_output) VALUES ('Sannhor');
INSERT INTO markov_output (markov_output) VALUES ('Aurin');
INSERT INTO markov_output (markov_output) VALUES ('Geifino');
INSERT INTO markov_output (markov_output) VALUES ('Car');
INSERT INTO markov_output (markov_output) VALUES ('Bitz');
INSERT INTO markov_output (markov_output) VALUES ('Esmundio');
INSERT INTO markov_output (markov_output) VALUES ('Marayetia');
INSERT INTO markov_output (markov_output) VALUES ('Jea');
INSERT INTO markov_output (markov_output) VALUES ('Ingerith');
INSERT INTO markov_output (markov_output) VALUES ('Hela');
INSERT INTO markov_output (markov_output) VALUES ('Gusthela');
INSERT INTO markov_output (markov_output) VALUES ('Anta');
INSERT INTO markov_output (markov_output) VALUES ('Edgalída');
INSERT INTO markov_output (markov_output) VALUES ('Reino');
INSERT INTO markov_output (markov_output) VALUES ('Pie');
INSERT INTO markov_output (markov_output) VALUES ('Calino');
INSERT INTO markov_output (markov_output) VALUES ('Torid');
INSERT INTO markov_output (markov_output) VALUES ('Fer');
INSERT INTO markov_output (markov_output) VALUES ('Isio');
INSERT INTO markov_output (markov_output) VALUES ('Lluinimia');
INSERT INTO markov_output (markov_output) VALUES ('Laug');
INSERT INTO markov_output (markov_output) VALUES ('Marste');
INSERT INTO markov_output (markov_output) VALUES ('Eskilegue');
INSERT INTO markov_output (markov_output) VALUES ('Arcè');
INSERT INTO markov_output (markov_output) VALUES ('Aun');
INSERT INTO markov_output (markov_output) VALUES ('Urta');
INSERT INTO markov_output (markov_output) VALUES ('Sigrilio');
INSERT INTO markov_output (markov_output) VALUES ('Moisce');
INSERT INTO markov_output (markov_output) VALUES ('Efigorianción');
INSERT INTO markov_output (markov_output) VALUES ('Arind');
INSERT INTO markov_output (markov_output) VALUES ('Øystenva');
INSERT INTO markov_output (markov_output) VALUES ('Augenja');
INSERT INTO markov_output (markov_output) VALUES ('Kjarca');
INSERT INTO markov_output (markov_output) VALUES ('Santine');
INSERT INTO markov_output (markov_output) VALUES ('Leontavilbjørn');
INSERT INTO markov_output (markov_output) VALUES ('Toreto');
INSERT INTO markov_output (markov_output) VALUES ('Bita');
INSERT INTO markov_output (markov_output) VALUES ('Catan');
INSERT INTO markov_output (markov_output) VALUES ('Ludelia');
INSERT INTO markov_output (markov_output) VALUES ('Love');
INSERT INTO markov_output (markov_output) VALUES ('Braza');
INSERT INTO markov_output (markov_output) VALUES ('Agurinegatzon');
INSERT INTO markov_output (markov_output) VALUES ('Magda');
INSERT INTO markov_output (markov_output) VALUES ('Janar');
INSERT INTO markov_output (markov_output) VALUES ('Stero');
INSERT INTO markov_output (markov_output) VALUES ('Joaquie');
INSERT INTO markov_output (markov_output) VALUES ('Sirt');
INSERT INTO markov_output (markov_output) VALUES ('Emia');
INSERT INTO markov_output (markov_output) VALUES ('Hor');
INSERT INTO markov_output (markov_output) VALUES ('Remián');
INSERT INTO markov_output (markov_output) VALUES ('Ber');
INSERT INTO markov_output (markov_output) VALUES ('Maurot');
INSERT INTO markov_output (markov_output) VALUES ('Birt');
INSERT INTO markov_output (markov_output) VALUES ('Margiomano');
INSERT INTO markov_output (markov_output) VALUES ('Fel');
INSERT INTO markov_output (markov_output) VALUES ('Rolf');
INSERT INTO markov_output (markov_output) VALUES ('Charía');
INSERT INTO markov_output (markov_output) VALUES ('Cardieribonino');
INSERT INTO markov_output (markov_output) VALUES ('Rosiel');
INSERT INTO markov_output (markov_output) VALUES ('Maresid');
INSERT INTO markov_output (markov_output) VALUES ('Kja');
INSERT INTO markov_output (markov_output) VALUES ('Ali');
INSERT INTO markov_output (markov_output) VALUES ('Justin');
INSERT INTO markov_output (markov_output) VALUES ('Linio');
INSERT INTO markov_output (markov_output) VALUES ('Toro');
INSERT INTO markov_output (markov_output) VALUES ('Mercellethana');
INSERT INTO markov_output (markov_output) VALUES ('Katrina');
INSERT INTO markov_output (markov_output) VALUES ('Amerunda');
INSERT INTO markov_output (markov_output) VALUES ('Robekkalo');
INSERT INTO markov_output (markov_output) VALUES ('Albeta');
INSERT INTO markov_output (markov_output) VALUES ('Remadiodeon');
INSERT INTO markov_output (markov_output) VALUES ('Sangelin');
INSERT INTO markov_output (markov_output) VALUES ('Aures');
INSERT INTO markov_output (markov_output) VALUES ('Nardadio');
INSERT INTO markov_output (markov_output) VALUES ('Adercadin');
INSERT INTO markov_output (markov_output) VALUES ('Antina');
INSERT INTO markov_output (markov_output) VALUES ('Lanta');
INSERT INTO markov_output (markov_output) VALUES ('Rebald');
INSERT INTO markov_output (markov_output) VALUES ('Kleja');
INSERT INTO markov_output (markov_output) VALUES ('Lourique');
INSERT INTO markov_output (markov_output) VALUES ('Ingjeridia');
INSERT INTO markov_output (markov_output) VALUES ('Sne');
INSERT INTO markov_output (markov_output) VALUES ('Oladna');
INSERT INTO markov_output (markov_output) VALUES ('Aagricass');
INSERT INTO markov_output (markov_output) VALUES ('Bert');
INSERT INTO markov_output (markov_output) VALUES ('Pasian');
INSERT INTO markov_output (markov_output) VALUES ('Camira');
INSERT INTO markov_output (markov_output) VALUES ('Álvinditz');
INSERT INTO markov_output (markov_output) VALUES ('Heinasa');
INSERT INTO markov_output (markov_output) VALUES ('Gabia');
INSERT INTO markov_output (markov_output) VALUES ('Vertaciligi');
INSERT INTO markov_output (markov_output) VALUES ('Pelaug');
INSERT INTO markov_output (markov_output) VALUES ('Valvine');
INSERT INTO markov_output (markov_output) VALUES ('Adegotea');
INSERT INTO markov_output (markov_output) VALUES ('Elejantavin');
INSERT INTO markov_output (markov_output) VALUES ('Nicianzaz');
INSERT INTO markov_output (markov_output) VALUES ('Paug');
INSERT INTO markov_output (markov_output) VALUES ('Grela');
INSERT INTO markov_output (markov_output) VALUES ('Carlor');
INSERT INTO markov_output (markov_output) VALUES ('Daga');
INSERT INTO markov_output (markov_output) VALUES ('Lazarthe');
INSERT INTO markov_output (markov_output) VALUES ('Alo');
INSERT INTO markov_output (markov_output) VALUES ('Vigno');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Conin');
INSERT INTO markov_output (markov_output) VALUES ('Borolleja');
INSERT INTO markov_output (markov_output) VALUES ('Bolio');
INSERT INTO markov_output (markov_output) VALUES ('Hild');
INSERT INTO markov_output (markov_output) VALUES ('Junda');
INSERT INTO markov_output (markov_output) VALUES ('Agne');
INSERT INTO markov_output (markov_output) VALUES ('Maja');
INSERT INTO markov_output (markov_output) VALUES ('Ola');
INSERT INTO markov_output (markov_output) VALUES ('Lucio');
INSERT INTO markov_output (markov_output) VALUES ('Joarpola');
INSERT INTO markov_output (markov_output) VALUES ('Forata');
INSERT INTO markov_output (markov_output) VALUES ('Isarina');
INSERT INTO markov_output (markov_output) VALUES ('Laug');
INSERT INTO markov_output (markov_output) VALUES ('Jorona');
INSERT INTO markov_output (markov_output) VALUES ('Dagro');
INSERT INTO markov_output (markov_output) VALUES ('Delin');
INSERT INTO markov_output (markov_output) VALUES ('Felsa');
INSERT INTO markov_output (markov_output) VALUES ('Adelidaristel');
INSERT INTO markov_output (markov_output) VALUES ('Elio');
INSERT INTO markov_output (markov_output) VALUES ('Segera');
INSERT INTO markov_output (markov_output) VALUES ('Estiamia');
INSERT INTO markov_output (markov_output) VALUES ('Ane');
INSERT INTO markov_output (markov_output) VALUES ('Aured');
INSERT INTO markov_output (markov_output) VALUES ('Lucia');
INSERT INTO markov_output (markov_output) VALUES ('Rosaber');
INSERT INTO markov_output (markov_output) VALUES ('Unn');
INSERT INTO markov_output (markov_output) VALUES ('Krisé');
INSERT INTO markov_output (markov_output) VALUES ('Alf');
INSERT INTO markov_output (markov_output) VALUES ('Børethe');
INSERT INTO markov_output (markov_output) VALUES ('Kårist');
INSERT INTO markov_output (markov_output) VALUES ('Kola');
INSERT INTO markov_output (markov_output) VALUES ('Maulayettelen');
INSERT INTO markov_output (markov_output) VALUES ('Hilda');
INSERT INTO markov_output (markov_output) VALUES ('Vicelaulcenn');
INSERT INTO markov_output (markov_output) VALUES ('Walipa');
INSERT INTO markov_output (markov_output) VALUES ('Elio');
INSERT INTO markov_output (markov_output) VALUES ('Evado');
INSERT INTO markov_output (markov_output) VALUES ('Ildorn');
INSERT INTO markov_output (markov_output) VALUES ('Fre');
INSERT INTO markov_output (markov_output) VALUES ('Johs');
INSERT INTO markov_output (markov_output) VALUES ('Elengencetronilio');
INSERT INTO markov_output (markov_output) VALUES ('Nicio');
INSERT INTO markov_output (markov_output) VALUES ('Jos');
INSERT INTO markov_output (markov_output) VALUES ('Raitoffera');
INSERT INTO markov_output (markov_output) VALUES ('Angunde');
INSERT INTO markov_output (markov_output) VALUES ('Aure');
INSERT INTO markov_output (markov_output) VALUES ('Jimia');
INSERT INTO markov_output (markov_output) VALUES ('Cor');
INSERT INTO markov_output (markov_output) VALUES ('Armianhild');
INSERT INTO markov_output (markov_output) VALUES ('Con');
INSERT INTO markov_output (markov_output) VALUES ('Toro');
INSERT INTO markov_output (markov_output) VALUES ('Vicara');
INSERT INTO markov_output (markov_output) VALUES ('Gune');
INSERT INTO markov_output (markov_output) VALUES ('Sveth');
INSERT INTO markov_output (markov_output) VALUES ('Tertiliot');
INSERT INTO markov_output (markov_output) VALUES ('Nubertolida');
INSERT INTO markov_output (markov_output) VALUES ('Pedia');
INSERT INTO markov_output (markov_output) VALUES ('Pil');
INSERT INTO markov_output (markov_output) VALUES ('Romuares');
INSERT INTO markov_output (markov_output) VALUES ('Gra');
INSERT INTO markov_output (markov_output) VALUES ('Knunnarte');
INSERT INTO markov_output (markov_output) VALUES ('Criber');
INSERT INTO markov_output (markov_output) VALUES ('Kyrise');
INSERT INTO markov_output (markov_output) VALUES ('Elvia');
INSERT INTO markov_output (markov_output) VALUES ('Asuelipri');
INSERT INTO markov_output (markov_output) VALUES ('Geif');
INSERT INTO markov_output (markov_output) VALUES ('Jaciod');
INSERT INTO markov_output (markov_output) VALUES ('Agare');
INSERT INTO markov_output (markov_output) VALUES ('Ira');
INSERT INTO markov_output (markov_output) VALUES ('Fer');
INSERT INTO markov_output (markov_output) VALUES ('Ele');
INSERT INTO markov_output (markov_output) VALUES ('Johamigoredelado');
INSERT INTO markov_output (markov_output) VALUES ('Borgelstavine');
INSERT INTO markov_output (markov_output) VALUES ('Nel');
INSERT INTO markov_output (markov_output) VALUES ('Silda');
INSERT INTO markov_output (markov_output) VALUES ('Ermel');
INSERT INTO markov_output (markov_output) VALUES ('Sigrune');
INSERT INTO markov_output (markov_output) VALUES ('Eus');
INSERT INTO markov_output (markov_output) VALUES ('Svena');
INSERT INTO markov_output (markov_output) VALUES ('Vibiely');
INSERT INTO markov_output (markov_output) VALUES ('Remí');
INSERT INTO markov_output (markov_output) VALUES ('Cla');
INSERT INTO markov_output (markov_output) VALUES ('Casti');
INSERT INTO markov_output (markov_output) VALUES ('Sebo');
INSERT INTO markov_output (markov_output) VALUES ('Lydiet');
INSERT INTO markov_output (markov_output) VALUES ('Fátibendac');
INSERT INTO markov_output (markov_output) VALUES ('Ata');
INSERT INTO markov_output (markov_output) VALUES ('Orla');
INSERT INTO markov_output (markov_output) VALUES ('Laudbjørne');
INSERT INTO markov_output (markov_output) VALUES ('Julgel');
INSERT INTO markov_output (markov_output) VALUES ('Anateira');
INSERT INTO markov_output (markov_output) VALUES ('Their');
INSERT INTO markov_output (markov_output) VALUES ('Liro');
INSERT INTO markov_output (markov_output) VALUES ('Pabiandoisbjørgio');
INSERT INTO markov_output (markov_output) VALUES ('Gilaria');
INSERT INTO markov_output (markov_output) VALUES ('Conición');
INSERT INTO markov_output (markov_output) VALUES ('Belio');
INSERT INTO markov_output (markov_output) VALUES ('Conif');
INSERT INTO markov_output (markov_output) VALUES ('Varolifana');
INSERT INTO markov_output (markov_output) VALUES ('Marlai');
INSERT INTO markov_output (markov_output) VALUES ('Noemelemilautz');
INSERT INTO markov_output (markov_output) VALUES ('Jorethern');
INSERT INTO markov_output (markov_output) VALUES ('Leor');
INSERT INTO markov_output (markov_output) VALUES ('Jimina');
INSERT INTO markov_output (markov_output) VALUES ('Eril');
INSERT INTO markov_output (markov_output) VALUES ('Sve');
INSERT INTO markov_output (markov_output) VALUES ('Xard');
INSERT INTO markov_output (markov_output) VALUES ('Dami');
INSERT INTO markov_output (markov_output) VALUES ('Mil');
INSERT INTO markov_output (markov_output) VALUES ('Ros');
INSERT INTO markov_output (markov_output) VALUES ('Fabro');
INSERT INTO markov_output (markov_output) VALUES ('Lid');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Esta');
INSERT INTO markov_output (markov_output) VALUES ('Nicarne');
INSERT INTO markov_output (markov_output) VALUES ('Tuldán');
INSERT INTO markov_output (markov_output) VALUES ('Sixto');
INSERT INTO markov_output (markov_output) VALUES ('Edga');
INSERT INTO markov_output (markov_output) VALUES ('Osar');
INSERT INTO markov_output (markov_output) VALUES ('Ena');
INSERT INTO markov_output (markov_output) VALUES ('Lino');
INSERT INTO markov_output (markov_output) VALUES ('Mabrio');
INSERT INTO markov_output (markov_output) VALUES ('Aagorgiñe');
INSERT INTO markov_output (markov_output) VALUES ('Danna');
INSERT INTO markov_output (markov_output) VALUES ('Elpia');
INSERT INTO markov_output (markov_output) VALUES ('Fri');
INSERT INTO markov_output (markov_output) VALUES ('Marine');
INSERT INTO markov_output (markov_output) VALUES ('Aarta');
INSERT INTO markov_output (markov_output) VALUES ('Nélio');
INSERT INTO markov_output (markov_output) VALUES ('Fren');
INSERT INTO markov_output (markov_output) VALUES ('Marin');
INSERT INTO markov_output (markov_output) VALUES ('Coneron');
INSERT INTO markov_output (markov_output) VALUES ('Ingre');
INSERT INTO markov_output (markov_output) VALUES ('Gud');
INSERT INTO markov_output (markov_output) VALUES ('Ingil');
INSERT INTO markov_output (markov_output) VALUES ('Kuridy');
INSERT INTO markov_output (markov_output) VALUES ('Vícolara');
INSERT INTO markov_output (markov_output) VALUES ('Gran');
INSERT INTO markov_output (markov_output) VALUES ('Calia');
INSERT INTO markov_output (markov_output) VALUES ('Daltel');
INSERT INTO markov_output (markov_output) VALUES ('Athanikono');
INSERT INTO markov_output (markov_output) VALUES ('Cel');
INSERT INTO markov_output (markov_output) VALUES ('Kari');
INSERT INTO markov_output (markov_output) VALUES ('Alia');
INSERT INTO markov_output (markov_output) VALUES ('Orly');
INSERT INTO markov_output (markov_output) VALUES ('Baudiviein');
INSERT INTO markov_output (markov_output) VALUES ('Amel');
INSERT INTO markov_output (markov_output) VALUES ('Aure');
INSERT INTO markov_output (markov_output) VALUES ('Eddy');
INSERT INTO markov_output (markov_output) VALUES ('Vicelio');
INSERT INTO markov_output (markov_output) VALUES ('Moniel');
INSERT INTO markov_output (markov_output) VALUES ('Eild');
INSERT INTO markov_output (markov_output) VALUES ('Gulca');
INSERT INTO markov_output (markov_output) VALUES ('Cata');
INSERT INTO markov_output (markov_output) VALUES ('Vita');
INSERT INTO markov_output (markov_output) VALUES ('Harta');
INSERT INTO markov_output (markov_output) VALUES ('Karinarcen');
INSERT INTO markov_output (markov_output) VALUES ('Joransa');
INSERT INTO markov_output (markov_output) VALUES ('Mimiljoffermunn');
INSERT INTO markov_output (markov_output) VALUES ('Bårelly');
INSERT INTO markov_output (markov_output) VALUES ('Cebermelly');
INSERT INTO markov_output (markov_output) VALUES ('Catte');
INSERT INTO markov_output (markov_output) VALUES ('Artiamiandridik');
INSERT INTO markov_output (markov_output) VALUES ('Ingvar');
INSERT INTO markov_output (markov_output) VALUES ('Ole');
INSERT INTO markov_output (markov_output) VALUES ('Eliosabikonstorinarper');
INSERT INTO markov_output (markov_output) VALUES ('Krind');
INSERT INTO markov_output (markov_output) VALUES ('Terida');
INSERT INTO markov_output (markov_output) VALUES ('Per');
INSERT INTO markov_output (markov_output) VALUES ('Chilo');
INSERT INTO markov_output (markov_output) VALUES ('Gun');
INSERT INTO markov_output (markov_output) VALUES ('Haline');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Julorede');
INSERT INTO markov_output (markov_output) VALUES ('Silo');
INSERT INTO markov_output (markov_output) VALUES ('Brinuel');
INSERT INTO markov_output (markov_output) VALUES ('Estofirimirane');
INSERT INTO markov_output (markov_output) VALUES ('Karmiror');
INSERT INTO markov_output (markov_output) VALUES ('Aquie');
INSERT INTO markov_output (markov_output) VALUES ('Karmelavirmuar');
INSERT INTO markov_output (markov_output) VALUES ('Roncianda');
INSERT INTO markov_output (markov_output) VALUES ('Torta');
INSERT INTO markov_output (markov_output) VALUES ('Petersena');
INSERT INTO markov_output (markov_output) VALUES ('Laza');
INSERT INTO markov_output (markov_output) VALUES ('Evadia');
INSERT INTO markov_output (markov_output) VALUES ('Magribeth');
INSERT INTO markov_output (markov_output) VALUES ('Lupert');
INSERT INTO markov_output (markov_output) VALUES ('Floídarían');
INSERT INTO markov_output (markov_output) VALUES ('Eiborka');
INSERT INTO markov_output (markov_output) VALUES ('Carg');
INSERT INTO markov_output (markov_output) VALUES ('Benild');
INSERT INTO markov_output (markov_output) VALUES ('Sira');
INSERT INTO markov_output (markov_output) VALUES ('Gera');
INSERT INTO markov_output (markov_output) VALUES ('Wini');
INSERT INTO markov_output (markov_output) VALUES ('Gund');
INSERT INTO markov_output (markov_output) VALUES ('Sus');
INSERT INTO markov_output (markov_output) VALUES ('Mistia');
INSERT INTO markov_output (markov_output) VALUES ('Digonedro');
INSERT INTO markov_output (markov_output) VALUES ('Caye');
INSERT INTO markov_output (markov_output) VALUES ('Ceftacolgar');
INSERT INTO markov_output (markov_output) VALUES ('Gistingva');
INSERT INTO markov_output (markov_output) VALUES ('Marachimaro');
INSERT INTO markov_output (markov_output) VALUES ('Marik');
INSERT INTO markov_output (markov_output) VALUES ('Flori');
INSERT INTO markov_output (markov_output) VALUES ('Bridistinda');
INSERT INTO markov_output (markov_output) VALUES ('Tansencio');
INSERT INTO markov_output (markov_output) VALUES ('Ren');
INSERT INTO markov_output (markov_output) VALUES ('Car');
INSERT INTO markov_output (markov_output) VALUES ('Necto');
INSERT INTO markov_output (markov_output) VALUES ('Cria');
INSERT INTO markov_output (markov_output) VALUES ('Adertefino');
INSERT INTO markov_output (markov_output) VALUES ('Fra');
INSERT INTO markov_output (markov_output) VALUES ('Øyvo');
INSERT INTO markov_output (markov_output) VALUES ('Dommanarleth');
INSERT INTO markov_output (markov_output) VALUES ('Eleminie');
INSERT INTO markov_output (markov_output) VALUES ('Armilio');
INSERT INTO markov_output (markov_output) VALUES ('Got');
INSERT INTO markov_output (markov_output) VALUES ('Ela');
INSERT INTO markov_output (markov_output) VALUES ('Lucildorly');
INSERT INTO markov_output (markov_output) VALUES ('Agustelaulixancke');
INSERT INTO markov_output (markov_output) VALUES ('Empid');
INSERT INTO markov_output (markov_output) VALUES ('Jual');
INSERT INTO markov_output (markov_output) VALUES ('Marrigon');
INSERT INTO markov_output (markov_output) VALUES ('Gilve');
INSERT INTO markov_output (markov_output) VALUES ('Thornhe');
INSERT INTO markov_output (markov_output) VALUES ('Christe');
INSERT INTO markov_output (markov_output) VALUES ('Kermodhillejanild');
INSERT INTO markov_output (markov_output) VALUES ('Aken');
INSERT INTO markov_output (markov_output) VALUES ('Lola');
INSERT INTO markov_output (markov_output) VALUES ('Adeleneris');
INSERT INTO markov_output (markov_output) VALUES ('Lovinacildoyettor');
INSERT INTO markov_output (markov_output) VALUES ('Tato');
INSERT INTO markov_output (markov_output) VALUES ('Pre');
INSERT INTO markov_output (markov_output) VALUES ('Aderiommy');
INSERT INTO markov_output (markov_output) VALUES ('Seve');
INSERT INTO markov_output (markov_output) VALUES ('Obdo');
INSERT INTO markov_output (markov_output) VALUES ('Forso');
INSERT INTO markov_output (markov_output) VALUES ('Juald');
INSERT INTO markov_output (markov_output) VALUES ('Fuelcelidolf');
INSERT INTO markov_output (markov_output) VALUES ('Jenisa');
INSERT INTO markov_output (markov_output) VALUES ('Ivannia');
INSERT INTO markov_output (markov_output) VALUES ('Gai');
INSERT INTO markov_output (markov_output) VALUES ('Edio');
INSERT INTO markov_output (markov_output) VALUES ('Eulina');
INSERT INTO markov_output (markov_output) VALUES ('Norin');
INSERT INTO markov_output (markov_output) VALUES ('Lupe');
INSERT INTO markov_output (markov_output) VALUES ('Josu');
INSERT INTO markov_output (markov_output) VALUES ('Helomanaletenessa');
INSERT INTO markov_output (markov_output) VALUES ('Ivana');
INSERT INTO markov_output (markov_output) VALUES ('Felana');
INSERT INTO markov_output (markov_output) VALUES ('Marry');
INSERT INTO markov_output (markov_output) VALUES ('Raghertina');
INSERT INTO markov_output (markov_output) VALUES ('Joaque');
INSERT INTO markov_output (markov_output) VALUES ('Ragno');
INSERT INTO markov_output (markov_output) VALUES ('Katte');
INSERT INTO markov_output (markov_output) VALUES ('Dida');
INSERT INTO markov_output (markov_output) VALUES ('Empe');
INSERT INTO markov_output (markov_output) VALUES ('Amun');
INSERT INTO markov_output (markov_output) VALUES ('Itzarna');
INSERT INTO markov_output (markov_output) VALUES ('Aarcesse');
INSERT INTO markov_output (markov_output) VALUES ('Anda');
INSERT INTO markov_output (markov_output) VALUES ('Jeanniansesa');
INSERT INTO markov_output (markov_output) VALUES ('Rosaudi');
INSERT INTO markov_output (markov_output) VALUES ('Rodonina');
INSERT INTO markov_output (markov_output) VALUES ('Bene');
INSERT INTO markov_output (markov_output) VALUES ('Annartze');
INSERT INTO markov_output (markov_output) VALUES ('Lucia');
INSERT INTO markov_output (markov_output) VALUES ('Cila');
INSERT INTO markov_output (markov_output) VALUES ('Mario');
INSERT INTO markov_output (markov_output) VALUES ('Sileirgrentorgrundredo');
INSERT INTO markov_output (markov_output) VALUES ('Mayo');
INSERT INTO markov_output (markov_output) VALUES ('Cridicrundro');
INSERT INTO markov_output (markov_output) VALUES ('Heigon');
INSERT INTO markov_output (markov_output) VALUES ('Antene');
INSERT INTO markov_output (markov_output) VALUES ('Godo');
INSERT INTO markov_output (markov_output) VALUES ('Cestanda');
INSERT INTO markov_output (markov_output) VALUES ('Elpio');
INSERT INTO markov_output (markov_output) VALUES ('Rosabiniethria');
INSERT INTO markov_output (markov_output) VALUES ('Sert');
INSERT INTO markov_output (markov_output) VALUES ('Eust');
INSERT INTO markov_output (markov_output) VALUES ('Jacad');
INSERT INTO markov_output (markov_output) VALUES ('Juanhillero');
INSERT INTO markov_output (markov_output) VALUES ('Maid');
INSERT INTO markov_output (markov_output) VALUES ('Graldori');
INSERT INTO markov_output (markov_output) VALUES ('Clarcent');
INSERT INTO markov_output (markov_output) VALUES ('Tormo');
INSERT INTO markov_output (markov_output) VALUES ('Role');
INSERT INTO markov_output (markov_output) VALUES ('Lucia');
INSERT INTO markov_output (markov_output) VALUES ('Lisa');
INSERT INTO markov_output (markov_output) VALUES ('Ven');
INSERT INTO markov_output (markov_output) VALUES ('Augunny');
INSERT INTO markov_output (markov_output) VALUES ('Cirarlicta');
INSERT INTO markov_output (markov_output) VALUES ('Agelistiaskonjansustaldo');
INSERT INTO markov_output (markov_output) VALUES ('Fer');
INSERT INTO markov_output (markov_output) VALUES ('Cilleck');
INSERT INTO markov_output (markov_output) VALUES ('Eskun');
INSERT INTO markov_output (markov_output) VALUES ('Micto');
INSERT INTO markov_output (markov_output) VALUES ('Aidua');
INSERT INTO markov_output (markov_output) VALUES ('Antiv');
INSERT INTO markov_output (markov_output) VALUES ('Helia');
INSERT INTO markov_output (markov_output) VALUES ('Grancio');
INSERT INTO markov_output (markov_output) VALUES ('Ascen');
INSERT INTO markov_output (markov_output) VALUES ('Albia');
INSERT INTO markov_output (markov_output) VALUES ('Ellemiancenaso');
INSERT INTO markov_output (markov_output) VALUES ('Milo');
INSERT INTO markov_output (markov_output) VALUES ('Cel');
INSERT INTO markov_output (markov_output) VALUES ('Ida');
INSERT INTO markov_output (markov_output) VALUES ('Jord');
INSERT INTO markov_output (markov_output) VALUES ('Sof');
INSERT INTO markov_output (markov_output) VALUES ('Ciparanad');
INSERT INTO markov_output (markov_output) VALUES ('Epif');
INSERT INTO markov_output (markov_output) VALUES ('Dano');
INSERT INTO markov_output (markov_output) VALUES ('Inge');
INSERT INTO markov_output (markov_output) VALUES ('Robieteraia');
INSERT INTO markov_output (markov_output) VALUES ('Urkuse');
INSERT INTO markov_output (markov_output) VALUES ('Wil');
INSERT INTO markov_output (markov_output) VALUES ('Ixon');
INSERT INTO markov_output (markov_output) VALUES ('Ida');
INSERT INTO markov_output (markov_output) VALUES ('Lilda');
INSERT INTO markov_output (markov_output) VALUES ('Monsa');
INSERT INTO markov_output (markov_output) VALUES ('Axelas');
INSERT INTO markov_output (markov_output) VALUES ('Torrar');
INSERT INTO markov_output (markov_output) VALUES ('Urtosiano');
INSERT INTO markov_output (markov_output) VALUES ('Laula');
INSERT INTO markov_output (markov_output) VALUES ('Akelencia');
INSERT INTO markov_output (markov_output) VALUES ('Balda');
INSERT INTO markov_output (markov_output) VALUES ('Lorio');
INSERT INTO markov_output (markov_output) VALUES ('Ive');
INSERT INTO markov_output (markov_output) VALUES ('Ild');
INSERT INTO markov_output (markov_output) VALUES ('Joa');
INSERT INTO markov_output (markov_output) VALUES ('Vicen');
INSERT INTO markov_output (markov_output) VALUES ('Bald');
INSERT INTO markov_output (markov_output) VALUES ('Eling');
INSERT INTO markov_output (markov_output) VALUES ('Antando');
INSERT INTO markov_output (markov_output) VALUES ('Pee');
INSERT INTO markov_output (markov_output) VALUES ('Caso');
INSERT INTO markov_output (markov_output) VALUES ('Jacenjamina');
INSERT INTO markov_output (markov_output) VALUES ('Balene');
INSERT INTO markov_output (markov_output) VALUES ('Octana');
INSERT INTO markov_output (markov_output) VALUES ('Mario');
INSERT INTO markov_output (markov_output) VALUES ('Clejano');
INSERT INTO markov_output (markov_output) VALUES ('Soffeck');
INSERT INTO markov_output (markov_output) VALUES ('Gøste');
INSERT INTO markov_output (markov_output) VALUES ('Ingenzazu');
INSERT INTO markov_output (markov_output) VALUES ('Erik');
INSERT INTO markov_output (markov_output) VALUES ('Livinta');
INSERT INTO markov_output (markov_output) VALUES ('Biro');
INSERT INTO markov_output (markov_output) VALUES ('Josenort');
INSERT INTO markov_output (markov_output) VALUES ('Caredvenne');
INSERT INTO markov_output (markov_output) VALUES ('Agunnimello');
INSERT INTO markov_output (markov_output) VALUES ('Hera');
INSERT INTO markov_output (markov_output) VALUES ('Lav');
INSERT INTO markov_output (markov_output) VALUES ('Tovertinhilanar');
INSERT INTO markov_output (markov_output) VALUES ('Sixas');
INSERT INTO markov_output (markov_output) VALUES ('Paulo');
INSERT INTO markov_output (markov_output) VALUES ('Jus');
INSERT INTO markov_output (markov_output) VALUES ('Edlen');
INSERT INTO markov_output (markov_output) VALUES ('Eulist');
INSERT INTO markov_output (markov_output) VALUES ('Nie');
INSERT INTO markov_output (markov_output) VALUES ('Lil');
INSERT INTO markov_output (markov_output) VALUES ('Modo');
INSERT INTO markov_output (markov_output) VALUES ('Here');
INSERT INTO markov_output (markov_output) VALUES ('Gai');
INSERT INTO markov_output (markov_output) VALUES ('Fristino');
INSERT INTO markov_output (markov_output) VALUES ('Palin');
INSERT INTO markov_output (markov_output) VALUES ('Bla');
INSERT INTO markov_output (markov_output) VALUES ('Ild');
INSERT INTO markov_output (markov_output) VALUES ('Teone');
INSERT INTO markov_output (markov_output) VALUES ('Nie');
INSERT INTO markov_output (markov_output) VALUES ('Empirgel');
INSERT INTO markov_output (markov_output) VALUES ('Edmunda');
INSERT INTO markov_output (markov_output) VALUES ('Antian');
INSERT INTO markov_output (markov_output) VALUES ('Aranda');
INSERT INTO markov_output (markov_output) VALUES ('Leo');
INSERT INTO markov_output (markov_output) VALUES ('Plio');
INSERT INTO markov_output (markov_output) VALUES ('Britane');
INSERT INTO markov_output (markov_output) VALUES ('Gaima');
INSERT INTO markov_output (markov_output) VALUES ('Ben');
INSERT INTO markov_output (markov_output) VALUES ('Iredisephemián');
INSERT INTO markov_output (markov_output) VALUES ('Tibetenet');
INSERT INTO markov_output (markov_output) VALUES ('Esto');
INSERT INTO markov_output (markov_output) VALUES ('Luderto');
INSERT INTO markov_output (markov_output) VALUES ('Tulaula');
INSERT INTO markov_output (markov_output) VALUES ('Ste');
INSERT INTO markov_output (markov_output) VALUES ('Alven');
INSERT INTO markov_output (markov_output) VALUES ('Vilian');
INSERT INTO markov_output (markov_output) VALUES ('Ain');
INSERT INTO markov_output (markov_output) VALUES ('Calligun');
INSERT INTO markov_output (markov_output) VALUES ('Julindelino');
INSERT INTO markov_output (markov_output) VALUES ('Godul');
INSERT INTO markov_output (markov_output) VALUES ('Magne');
INSERT INTO markov_output (markov_output) VALUES ('Mareditana');
INSERT INTO markov_output (markov_output) VALUES ('Mel');
INSERT INTO markov_output (markov_output) VALUES ('Leodulitte');
INSERT INTO markov_output (markov_output) VALUES ('Jeane');
INSERT INTO markov_output (markov_output) VALUES ('Món');
INSERT INTO markov_output (markov_output) VALUES ('Yesen');
INSERT INTO markov_output (markov_output) VALUES ('Solie');
INSERT INTO markov_output (markov_output) VALUES ('Ambria');
INSERT INTO markov_output (markov_output) VALUES ('Aurt');
INSERT INTO markov_output (markov_output) VALUES ('Catisaacis');
INSERT INTO markov_output (markov_output) VALUES ('Ludeof');
INSERT INTO markov_output (markov_output) VALUES ('Nicena');
INSERT INTO markov_output (markov_output) VALUES ('Agusandade');
INSERT INTO markov_output (markov_output) VALUES ('Div');
INSERT INTO markov_output (markov_output) VALUES ('Eve');
INSERT INTO markov_output (markov_output) VALUES ('Eves');
INSERT INTO markov_output (markov_output) VALUES ('Terna');
INSERT INTO markov_output (markov_output) VALUES ('Oloídimad');
INSERT INTO markov_output (markov_output) VALUES ('Ezequildolizarvano');
INSERT INTO markov_output (markov_output) VALUES ('Jaclio');
INSERT INTO markov_output (markov_output) VALUES ('Emiro');
INSERT INTO markov_output (markov_output) VALUES ('Gabrigno');
INSERT INTO markov_output (markov_output) VALUES ('Liz');
INSERT INTO markov_output (markov_output) VALUES ('Edvikke');
INSERT INTO markov_output (markov_output) VALUES ('Flogerdimparte');
INSERT INTO markov_output (markov_output) VALUES ('Elia');
INSERT INTO markov_output (markov_output) VALUES ('Aug');
INSERT INTO markov_output (markov_output) VALUES ('Enrisbjørdiv');
INSERT INTO markov_output (markov_output) VALUES ('Eilaurnsta');
INSERT INTO markov_output (markov_output) VALUES ('Elly');
INSERT INTO markov_output (markov_output) VALUES ('Naturi');
INSERT INTO markov_output (markov_output) VALUES ('Vale');
INSERT INTO markov_output (markov_output) VALUES ('Susanta');
INSERT INTO markov_output (markov_output) VALUES ('Odaria');
INSERT INTO markov_output (markov_output) VALUES ('Rubecid');
INSERT INTO markov_output (markov_output) VALUES ('Hubelaridegernar');
INSERT INTO markov_output (markov_output) VALUES ('Isabrony');
INSERT INTO markov_output (markov_output) VALUES ('Fedo');
INSERT INTO markov_output (markov_output) VALUES ('Baste');
INSERT INTO markov_output (markov_output) VALUES ('Balvilde');
INSERT INTO markov_output (markov_output) VALUES ('Ino');
INSERT INTO markov_output (markov_output) VALUES ('Bie');
INSERT INTO markov_output (markov_output) VALUES ('Ingvorund');
INSERT INTO markov_output (markov_output) VALUES ('Horjeliacila');
INSERT INTO markov_output (markov_output) VALUES ('Ala');
INSERT INTO markov_output (markov_output) VALUES ('Cle');
INSERT INTO markov_output (markov_output) VALUES ('Epitofin');
INSERT INTO markov_output (markov_output) VALUES ('Ángélino');
INSERT INTO markov_output (markov_output) VALUES ('Efino');
INSERT INTO markov_output (markov_output) VALUES ('Viscepar');
INSERT INTO markov_output (markov_output) VALUES ('Bet');
INSERT INTO markov_output (markov_output) VALUES ('Chure');
INSERT INTO markov_output (markov_output) VALUES ('Flo');
INSERT INTO markov_output (markov_output) VALUES ('Cecklaurt');
INSERT INTO markov_output (markov_output) VALUES ('Alen');
INSERT INTO markov_output (markov_output) VALUES ('Felia');
INSERT INTO markov_output (markov_output) VALUES ('Lucindelsario');
INSERT INTO markov_output (markov_output) VALUES ('Fabiñe');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Serne');
INSERT INTO markov_output (markov_output) VALUES ('Bas');
INSERT INTO markov_output (markov_output) VALUES ('Catandefia');
INSERT INTO markov_output (markov_output) VALUES ('San');
INSERT INTO markov_output (markov_output) VALUES ('Heris');
INSERT INTO markov_output (markov_output) VALUES ('Gøsti');
INSERT INTO markov_output (markov_output) VALUES ('Ele');
INSERT INTO markov_output (markov_output) VALUES ('Elia');
INSERT INTO markov_output (markov_output) VALUES ('Marne');
INSERT INTO markov_output (markov_output) VALUES ('Sustein');
INSERT INTO markov_output (markov_output) VALUES ('Thoana');
INSERT INTO markov_output (markov_output) VALUES ('Magno');
INSERT INTO markov_output (markov_output) VALUES ('Miricarilia');
INSERT INTO markov_output (markov_output) VALUES ('Elna');
INSERT INTO markov_output (markov_output) VALUES ('Hilizkaric');
INSERT INTO markov_output (markov_output) VALUES ('Sorac');
INSERT INTO markov_output (markov_output) VALUES ('Benildán');
INSERT INTO markov_output (markov_output) VALUES ('Espettantisaac');
INSERT INTO markov_output (markov_output) VALUES ('Rodo');
INSERT INTO markov_output (markov_output) VALUES ('Dildur');
INSERT INTO markov_output (markov_output) VALUES ('Esme');
INSERT INTO markov_output (markov_output) VALUES ('Elistell');
INSERT INTO markov_output (markov_output) VALUES ('Ber');
INSERT INTO markov_output (markov_output) VALUES ('Rosasid');
INSERT INTO markov_output (markov_output) VALUES ('Ino');
INSERT INTO markov_output (markov_output) VALUES ('Marina');
INSERT INTO markov_output (markov_output) VALUES ('Sata');
INSERT INTO markov_output (markov_output) VALUES ('Eug');
INSERT INTO markov_output (markov_output) VALUES ('Tor');
INSERT INTO markov_output (markov_output) VALUES ('Mita');
INSERT INTO markov_output (markov_output) VALUES ('Ricia');
INSERT INTO markov_output (markov_output) VALUES ('Egotenélina');
INSERT INTO markov_output (markov_output) VALUES ('Per');
INSERT INTO markov_output (markov_output) VALUES ('Lida');
INSERT INTO markov_output (markov_output) VALUES ('Karlavigoredriburone');
INSERT INTO markov_output (markov_output) VALUES ('Beraciarbandada');
INSERT INTO markov_output (markov_output) VALUES ('Vis');
INSERT INTO markov_output (markov_output) VALUES ('Emithe');
INSERT INTO markov_output (markov_output) VALUES ('Freana');
INSERT INTO markov_output (markov_output) VALUES ('Anstina');
INSERT INTO markov_output (markov_output) VALUES ('Leofra');
INSERT INTO markov_output (markov_output) VALUES ('Ale');
INSERT INTO markov_output (markov_output) VALUES ('Otte');
INSERT INTO markov_output (markov_output) VALUES ('Nictang');
INSERT INTO markov_output (markov_output) VALUES ('Humbris');
INSERT INTO markov_output (markov_output) VALUES ('Errando');
INSERT INTO markov_output (markov_output) VALUES ('Nerelio');
INSERT INTO markov_output (markov_output) VALUES ('Eilofelaldbraria');
INSERT INTO markov_output (markov_output) VALUES ('Maximilinicaspe');
INSERT INTO markov_output (markov_output) VALUES ('Clazu');
INSERT INTO markov_output (markov_output) VALUES ('Adentzaro');
INSERT INTO markov_output (markov_output) VALUES ('Gustilla');
INSERT INTO markov_output (markov_output) VALUES ('Nie');
INSERT INTO markov_output (markov_output) VALUES ('Eliancio');
INSERT INTO markov_output (markov_output) VALUES ('Thritasianuels');
INSERT INTO markov_output (markov_output) VALUES ('Geríanción');
INSERT INTO markov_output (markov_output) VALUES ('Unn');
INSERT INTO markov_output (markov_output) VALUES ('Rosart');
INSERT INTO markov_output (markov_output) VALUES ('Rene');
INSERT INTO markov_output (markov_output) VALUES ('Ingenalauro');
INSERT INTO markov_output (markov_output) VALUES ('Hugoña');
INSERT INTO markov_output (markov_output) VALUES ('Orisairso');
INSERT INTO markov_output (markov_output) VALUES ('Kolin');
INSERT INTO markov_output (markov_output) VALUES ('Nicora');
INSERT INTO markov_output (markov_output) VALUES ('Elv');
INSERT INTO markov_output (markov_output) VALUES ('Raidina');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Celisa');
INSERT INTO markov_output (markov_output) VALUES ('Mon');
INSERT INTO markov_output (markov_output) VALUES ('Gerne');
INSERT INTO markov_output (markov_output) VALUES ('Kentana');
INSERT INTO markov_output (markov_output) VALUES ('Hericia');
INSERT INTO markov_output (markov_output) VALUES ('Ovia');
INSERT INTO markov_output (markov_output) VALUES ('Toro');
INSERT INTO markov_output (markov_output) VALUES ('Oddvidiano');
INSERT INTO markov_output (markov_output) VALUES ('Sand');
INSERT INTO markov_output (markov_output) VALUES ('Hilcenil');
INSERT INTO markov_output (markov_output) VALUES ('Aslesaberíctora');
INSERT INTO markov_output (markov_output) VALUES ('Berthar');
INSERT INTO markov_output (markov_output) VALUES ('Remarna');
INSERT INTO markov_output (markov_output) VALUES ('Patavinia');
INSERT INTO markov_output (markov_output) VALUES ('Ola');
INSERT INTO markov_output (markov_output) VALUES ('Gualborfinacaca');
INSERT INTO markov_output (markov_output) VALUES ('Eilduli');
INSERT INTO markov_output (markov_output) VALUES ('Herad');
INSERT INTO markov_output (markov_output) VALUES ('Maco');
INSERT INTO markov_output (markov_output) VALUES ('Ara');
INSERT INTO markov_output (markov_output) VALUES ('Pelencia');
INSERT INTO markov_output (markov_output) VALUES ('Rosimina');
INSERT INTO markov_output (markov_output) VALUES ('Ibalderegardittia');
INSERT INTO markov_output (markov_output) VALUES ('Simethrine');
INSERT INTO markov_output (markov_output) VALUES ('Hentz');
INSERT INTO markov_output (markov_output) VALUES ('Rupif');
INSERT INTO markov_output (markov_output) VALUES ('Telaurna');
INSERT INTO markov_output (markov_output) VALUES ('Lino');
INSERT INTO markov_output (markov_output) VALUES ('Arneke');
INSERT INTO markov_output (markov_output) VALUES ('Gena');
INSERT INTO markov_output (markov_output) VALUES ('Vill');
INSERT INTO markov_output (markov_output) VALUES ('Ingrunocío');
INSERT INTO markov_output (markov_output) VALUES ('Dagres');
INSERT INTO markov_output (markov_output) VALUES ('Cato');
INSERT INTO markov_output (markov_output) VALUES ('Mar');
INSERT INTO markov_output (markov_output) VALUES ('Bibero');
INSERT INTO markov_output (markov_output) VALUES ('Irenta');
INSERT INTO markov_output (markov_output) VALUES ('Frino');
INSERT INTO markov_output (markov_output) VALUES ('Leonid');
INSERT INTO markov_output (markov_output) VALUES ('Domin');
INSERT INTO markov_output (markov_output) VALUES ('Nores');
INSERT INTO markov_output (markov_output) VALUES ('Kata');
INSERT INTO markov_output (markov_output) VALUES ('Natheiderg');
INSERT INTO markov_output (markov_output) VALUES ('Margela');
INSERT INTO markov_output (markov_output) VALUES ('Montine');
INSERT INTO markov_output (markov_output) VALUES ('Quisielmilly');
INSERT INTO markov_output (markov_output) VALUES ('Nie');
INSERT INTO markov_output (markov_output) VALUES ('Rafa');
INSERT INTO markov_output (markov_output) VALUES ('Rogelinn');
INSERT INTO markov_output (markov_output) VALUES ('Vibina');
INSERT INTO markov_output (markov_output) VALUES ('Kara');
INSERT INTO markov_output (markov_output) VALUES ('Eutimodo');
INSERT INTO markov_output (markov_output) VALUES ('Anto');
INSERT INTO markov_output (markov_output) VALUES ('Xabeten');
INSERT INTO markov_output (markov_output) VALUES ('Raquetasselia');
INSERT INTO markov_output (markov_output) VALUES ('Maida');
INSERT INTO markov_output (markov_output) VALUES ('Joharreodurnar');
INSERT INTO markov_output (markov_output) VALUES ('Edverne');
INSERT INTO markov_output (markov_output) VALUES ('Kritardia');
INSERT INTO markov_output (markov_output) VALUES ('Balv');
INSERT INTO markov_output (markov_output) VALUES ('Karry');
INSERT INTO markov_output (markov_output) VALUES ('Connionsa');
INSERT INTO markov_output (markov_output) VALUES ('Clen');
INSERT INTO markov_output (markov_output) VALUES ('Makoita');
INSERT INTO markov_output (markov_output) VALUES ('Pete');
INSERT INTO markov_output (markov_output) VALUES ('Ingre');
INSERT INTO markov_output (markov_output) VALUES ('Tora');
INSERT INTO markov_output (markov_output) VALUES ('Hedriso');
INSERT INTO markov_output (markov_output) VALUES ('Ermar');
INSERT INTO markov_output (markov_output) VALUES ('Sertor');
INSERT INTO markov_output (markov_output) VALUES ('Terika');
INSERT INTO markov_output (markov_output) VALUES ('Fulo');
INSERT INTO markov_output (markov_output) VALUES ('Heralda');
INSERT INTO markov_output (markov_output) VALUES ('Gotzonalderlementorbjørgid');
INSERT INTO markov_output (markov_output) VALUES ('Bengenciónielia');
INSERT INTO markov_output (markov_output) VALUES ('Pein');
INSERT INTO markov_output (markov_output) VALUES ('Torra');
INSERT INTO markov_output (markov_output) VALUES ('Damine');
INSERT INTO markov_output (markov_output) VALUES ('Vireddveif');
INSERT INTO markov_output (markov_output) VALUES ('Frete');
INSERT INTO markov_output (markov_output) VALUES ('Lorgard');
INSERT INTO markov_output (markov_output) VALUES ('Eutty');
INSERT INTO markov_output (markov_output) VALUES ('Aurel');
INSERT INTO markov_output (markov_output) VALUES ('Dorjan');
INSERT INTO markov_output (markov_output) VALUES ('Torindofid');
INSERT INTO markov_output (markov_output) VALUES ('Machaelia');
INSERT INTO markov_output (markov_output) VALUES ('Hulio');
INSERT INTO markov_output (markov_output) VALUES ('Joakoia');
INSERT INTO markov_output (markov_output) VALUES ('Elia');
INSERT INTO markov_output (markov_output) VALUES ('Ligrenckenteoncha');
INSERT INTO markov_output (markov_output) VALUES ('Agnes');
INSERT INTO markov_output (markov_output) VALUES ('Antián');
INSERT INTO markov_output (markov_output) VALUES ('Neklaullemilagra');
INSERT INTO markov_output (markov_output) VALUES ('Fri');
INSERT INTO markov_output (markov_output) VALUES ('Hag');
INSERT INTO markov_output (markov_output) VALUES ('Ade');
INSERT INTO markov_output (markov_output) VALUES ('Elma');
INSERT INTO markov_output (markov_output) VALUES ('Canstinda');
INSERT INTO markov_output (markov_output) VALUES ('Vega');
INSERT INTO markov_output (markov_output) VALUES ('Ras');
INSERT INTO markov_output (markov_output) VALUES ('Natilina');
INSERT INTO markov_output (markov_output) VALUES ('Toro');
INSERT INTO markov_output (markov_output) VALUES ('Xar');
INSERT INTO markov_output (markov_output) VALUES ('Jet');
INSERT INTO markov_output (markov_output) VALUES ('Geodia');
INSERT INTO markov_output (markov_output) VALUES ('Leo');
INSERT INTO markov_output (markov_output) VALUES ('Egura');
INSERT INTO markov_output (markov_output) VALUES ('Odd');
INSERT INTO markov_output (markov_output) VALUES ('Fellyn');
INSERT INTO markov_output (markov_output) VALUES ('Norino');
INSERT INTO markov_output (markov_output) VALUES ('Valfrina');
INSERT INTO markov_output (markov_output) VALUES ('Teo');
INSERT INTO markov_output (markov_output) VALUES ('Ruy');
INSERT INTO markov_output (markov_output) VALUES ('Jokim');
INSERT INTO markov_output (markov_output) VALUES ('Mathor');
INSERT INTO markov_output (markov_output) VALUES ('Viriandadny');
INSERT INTO markov_output (markov_output) VALUES ('Plia');
INSERT INTO markov_output (markov_output) VALUES ('Dagrid');
INSERT INTO markov_output (markov_output) VALUES ('Ceselinekaidio');
INSERT INTO markov_output (markov_output) VALUES ('Felipolauden');
INSERT INTO markov_output (markov_output) VALUES ('Kåreo');
INSERT INTO markov_output (markov_output) VALUES ('Antontina');
INSERT INTO markov_output (markov_output) VALUES ('Edventa');
INSERT INTO markov_output (markov_output) VALUES ('Agus');
INSERT INTO markov_output (markov_output) VALUES ('Ania');
INSERT INTO markov_output (markov_output) VALUES ('Reyn');
INSERT INTO markov_output (markov_output) VALUES ('Car');
INSERT INTO markov_output (markov_output) VALUES ('Sin');
INSERT INTO markov_output (markov_output) VALUES ('Reidundre');
INSERT INTO markov_output (markov_output) VALUES ('Cas');
INSERT INTO markov_output (markov_output) VALUES ('Prino');
INSERT INTO markov_output (markov_output) VALUES ('Celasian');
INSERT INTO markov_output (markov_output) VALUES ('Viburt');
INSERT INTO markov_output (markov_output) VALUES ('Vild');
INSERT INTO markov_output (markov_output) VALUES ('Belichillvia');
INSERT INTO markov_output (markov_output) VALUES ('Anbjørete');


--
-- Data for Name: markov_rl_name_era; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_rl_name_language; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_rl_name_language_era_frequency; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: markov_subset; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: rel_religion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('46dc1251-3a43-408f-bd77-332bdff83211', 'Akoptan Azarism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('02f4a2a4-c53e-4083-901c-88677f6a545a', 'Anmaric Paganism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('576225be-4bb7-4a72-9db7-456ff6290a5d', 'Asyric Paganism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('6294cca2-02d4-4248-9533-a570b51e1ade', 'Auxiliary Azarism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('f0ead29f-909b-44a7-8cca-0e09bbd3db0b', 'Corovian Pantheon');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('a51e7625-9188-4817-9b58-91467e68b50c', 'Cult of Muraq');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('1950bb93-bc3c-4119-9b5f-ea8fc2581be7', 'Dharam');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('d049036f-effb-4c5c-9a39-01ce00213e50', 'Dharmud');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('d7cb694c-1d4b-4026-be73-359c13fd2800', 'Gnosticism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('35026cab-a2dd-44a1-a988-b0eb869317f5', 'Igyrian Paganism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('71cbccec-52a8-4689-9355-3e7c01c4c123', 'Imperial Mysteries');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('2a4f5228-3b35-48e9-b5e6-2c189e59ecc0', 'Mazadin');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('8519096f-9bc1-4668-b3ee-b931ea4f978e', 'Oghdian Paganism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('74e912f0-36c2-4deb-b76a-dd14d1295a19', 'Sol Invictus');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('508fccbf-4b7f-41f9-8fd5-6763769963bb', 'Sylvan Paganism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('4dc42a11-61e0-44dd-8b48-49a8122ef259', 'Tenzinism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('97088d37-c516-4448-a4d1-dc5fcb5547bc', 'The Way');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('d6884a2c-c3b8-48a0-8a3f-09399651901d', 'Traditional Igni Religion');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('728c2a8f-2671-4971-aaa7-b3b14ab4915a', 'Traditional Sudusi Religion');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('98501149-8f19-481e-a990-e70261877a5e', 'Trinitarian Azarism');
INSERT INTO rel_religion (guid_religion, name_religion) VALUES ('c3eae285-e265-4fd7-9ac0-75565fd52485', 'Yehidism');


--
-- Data for Name: rel_religion_rl_hierarchy; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: timeperiod; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('c3546da0-23c4-40e9-9a33-5131c14a5564', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('2d42f4dc-b906-40db-b09c-7250bfecb7b8', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('e8602d57-9767-49c2-a573-820d0edc41e2', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('24a9657b-c5db-4d86-903a-1bfda53b593a', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('c2d8242f-32c5-4287-a701-75f08c513de4', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('411e75e9-6623-4980-a06f-b50bc2eec991', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('9d839051-f10d-4454-a1a8-2700593bed23', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('36c4bd74-3a01-4038-8def-e055fee3a420', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('3d7d5114-6fd8-4f3c-8267-efd813fa19c5', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('c4cdb7ed-a6cc-4acd-9249-c4c85118aaac', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('90a2270c-cc4f-4517-b9e6-d727dc6708f4', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('b21cffa9-65e5-43e6-be62-4ded9f3fc5b9', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('282695e6-2c5f-4b32-b28d-b1f1d265ed1c', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('daa333f4-9434-40c5-9f01-7fd93f943b66', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('8e79825e-6ee3-4c99-bfd2-8794f62508ee', 1, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('7329cce1-62f7-41cf-ab6c-0e6b7e8a47fa', 0, NULL);
INSERT INTO timeperiod (guid_timeperiod, start_year, end_year) VALUES ('9d5b4c1f-0c74-4cf0-bbe1-32935145d209', 0, NULL);


--
-- Data for Name: timeperiod_event; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: timeperiod_eventtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO timeperiod_eventtype (guid_eventtype, name_eventtype) VALUES ('91124661-c2f8-4fa1-8b12-bb544059f61e', 'War');
INSERT INTO timeperiod_eventtype (guid_eventtype, name_eventtype) VALUES ('eea8b16b-c1c3-41af-8681-dcf36d4eeed2', 'Demise');
INSERT INTO timeperiod_eventtype (guid_eventtype, name_eventtype) VALUES ('bb479c7b-cf56-4627-8e14-ca996571f1e7', 'Marriage');
INSERT INTO timeperiod_eventtype (guid_eventtype, name_eventtype) VALUES ('17baf457-707f-44b1-b0f8-f2fdbfe23217', 'Allegiance Change');
INSERT INTO timeperiod_eventtype (guid_eventtype, name_eventtype) VALUES ('57fb9cba-0f88-4ea0-b334-c61a57758f0b', 'Name Change');


--
-- Name: markov_subset_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('markov_subset_name_id_seq', 1, false);


--
-- Name: conn_lu_entityrelationshiptype conn_lu_entityrelationshiptype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_lu_entityrelationshiptype
    ADD CONSTRAINT conn_lu_entityrelationshiptype_pkey PRIMARY KEY (guid_entityrelationshiptype);


--
-- Name: conn_rl_culture_religion conn_rl_culture_religion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_culture_religion
    ADD CONSTRAINT conn_rl_culture_religion_pkey PRIMARY KEY (guid_religion, guid_culture, guid_timeperiod);


--
-- Name: conn_rl_entity_culture conn_rl_entity_culture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_culture
    ADD CONSTRAINT conn_rl_entity_culture_pkey PRIMARY KEY (guid_entity, guid_culture);


--
-- Name: conn_rl_entity_religion conn_rl_entity_religion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_religion
    ADD CONSTRAINT conn_rl_entity_religion_pkey PRIMARY KEY (guid_entity, guid_religion);


--
-- Name: cul_culture cul_culture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cul_culture
    ADD CONSTRAINT cul_culture_pkey PRIMARY KEY (guid_culture);


--
-- Name: cul_culture_rl_hierarchy cul_culture_rl_hierarchy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cul_culture_rl_hierarchy
    ADD CONSTRAINT cul_culture_rl_hierarchy_pkey PRIMARY KEY (guid_parent_culture, guid_culture, guid_timeperiod);


--
-- Name: cul_culturegroup cul_culturegroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cul_culturegroup
    ADD CONSTRAINT cul_culturegroup_pkey PRIMARY KEY (guid_culturegroup);


--
-- Name: entity_entity entity_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entity
    ADD CONSTRAINT entity_entity_pkey PRIMARY KEY (guid_entity);


--
-- Name: entity_entitydetail entity_entitydetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entitydetail
    ADD CONSTRAINT entity_entitydetail_pkey PRIMARY KEY (guid_entity, guid_timeperiod, guid_detailtype);


--
-- Name: entity_lu_detailtype entity_lu_detailtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_lu_detailtype
    ADD CONSTRAINT entity_lu_detailtype_pkey PRIMARY KEY (guid_detailtype);


--
-- Name: entity_lu_entitytype entity_lu_entitytype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_lu_entitytype
    ADD CONSTRAINT entity_lu_entitytype_pkey PRIMARY KEY (guid_entitytype);


--
-- Name: entity_rl_entity_entity entity_rl_entity_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entity_entity
    ADD CONSTRAINT entity_rl_entity_entity_pkey PRIMARY KEY (parent_entity, guid_entity, guid_timeperiod);


--
-- Name: entity_rl_entitytype_detailtype entity_rl_entitytype_detailtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entitytype_detailtype
    ADD CONSTRAINT entity_rl_entitytype_detailtype_pkey PRIMARY KEY (guid_entitytype, guid_detailtype);


--
-- Name: markov_name_era markov_name_era_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_name_era
    ADD CONSTRAINT markov_name_era_pkey PRIMARY KEY (guid_era);


--
-- Name: markov_name_language markov_name_language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_name_language
    ADD CONSTRAINT markov_name_language_pkey PRIMARY KEY (guid_language);


--
-- Name: markov_name markov_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_name
    ADD CONSTRAINT markov_name_pkey PRIMARY KEY (guid_name);


--
-- Name: markov_rl_name_era markov_rl_name_era_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_rl_name_era
    ADD CONSTRAINT markov_rl_name_era_pkey PRIMARY KEY (guid_era, guid_name);


--
-- Name: markov_rl_name_language_era_frequency markov_rl_name_language_era_frequency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_rl_name_language_era_frequency
    ADD CONSTRAINT markov_rl_name_language_era_frequency_pkey PRIMARY KEY (guid_name, guid_language, guid_era);


--
-- Name: markov_rl_name_language markov_rl_name_language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_rl_name_language
    ADD CONSTRAINT markov_rl_name_language_pkey PRIMARY KEY (guid_name);


--
-- Name: markov_datasource name_datasource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_datasource
    ADD CONSTRAINT name_datasource_pkey PRIMARY KEY (guid_source);


--
-- Name: markov_name_gender name_gender_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY markov_name_gender
    ADD CONSTRAINT name_gender_pkey PRIMARY KEY (guid_gender);


--
-- Name: rel_religion rel_religion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rel_religion
    ADD CONSTRAINT rel_religion_pkey PRIMARY KEY (guid_religion);


--
-- Name: rel_religion_rl_hierarchy rel_rl_religion_religion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rel_religion_rl_hierarchy
    ADD CONSTRAINT rel_rl_religion_religion_pkey PRIMARY KEY (guid_parent_religion, guid_religion, guid_timeperiod);


--
-- Name: timeperiod_event timeperiod_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod_event
    ADD CONSTRAINT timeperiod_event_pkey PRIMARY KEY (guid_event);


--
-- Name: timeperiod_eventtype timeperiod_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod_eventtype
    ADD CONSTRAINT timeperiod_eventtype_pkey PRIMARY KEY (guid_eventtype);


--
-- Name: timeperiod timeperiod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod
    ADD CONSTRAINT timeperiod_pkey PRIMARY KEY (guid_timeperiod);


--
-- Name: fki_fk_timeperiod_event_sub_timeperiod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_timeperiod_event_sub_timeperiod ON timeperiod_event USING btree ("parent_timePeriod");


--
-- Name: fki_rel_relgion_rl_hierarchy_guid_relgion_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_rel_relgion_rl_hierarchy_guid_relgion_fk ON rel_religion_rl_hierarchy USING btree (guid_religion);


--
-- Name: conn_rl_culture_religion conn_rl_culture_religion_guid_culture_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_culture_religion
    ADD CONSTRAINT conn_rl_culture_religion_guid_culture_fkey FOREIGN KEY (guid_culture) REFERENCES cul_culture(guid_culture);


--
-- Name: conn_rl_culture_religion conn_rl_culture_religion_guid_religion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_culture_religion
    ADD CONSTRAINT conn_rl_culture_religion_guid_religion_fkey FOREIGN KEY (guid_religion) REFERENCES rel_religion(guid_religion);


--
-- Name: conn_rl_culture_religion conn_rl_culture_religion_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_culture_religion
    ADD CONSTRAINT conn_rl_culture_religion_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: conn_rl_entity_culture conn_rl_entity_culture_guid_culture_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_culture
    ADD CONSTRAINT conn_rl_entity_culture_guid_culture_fkey FOREIGN KEY (guid_culture) REFERENCES cul_culture(guid_culture);


--
-- Name: conn_rl_entity_culture conn_rl_entity_culture_guid_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_culture
    ADD CONSTRAINT conn_rl_entity_culture_guid_entity_fkey FOREIGN KEY (guid_entity) REFERENCES entity_entity(guid_entity);


--
-- Name: conn_rl_entity_culture conn_rl_entity_culture_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_culture
    ADD CONSTRAINT conn_rl_entity_culture_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: conn_rl_entity_religion conn_rl_entity_religion_guid_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_religion
    ADD CONSTRAINT conn_rl_entity_religion_guid_entity_fkey FOREIGN KEY (guid_entity) REFERENCES entity_entity(guid_entity);


--
-- Name: conn_rl_entity_religion conn_rl_entity_religion_guid_religion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_religion
    ADD CONSTRAINT conn_rl_entity_religion_guid_religion_fkey FOREIGN KEY (guid_religion) REFERENCES rel_religion(guid_religion);


--
-- Name: conn_rl_entity_religion conn_rl_entity_religion_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conn_rl_entity_religion
    ADD CONSTRAINT conn_rl_entity_religion_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: cul_culture_rl_hierarchy cul_culture_rl_hierarchy_guid_culture_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cul_culture_rl_hierarchy
    ADD CONSTRAINT cul_culture_rl_hierarchy_guid_culture_fkey FOREIGN KEY (guid_culture) REFERENCES cul_culture(guid_culture);


--
-- Name: cul_culture_rl_hierarchy cul_culture_rl_hierarchy_guid_parent_culture_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cul_culture_rl_hierarchy
    ADD CONSTRAINT cul_culture_rl_hierarchy_guid_parent_culture_fkey FOREIGN KEY (guid_parent_culture) REFERENCES cul_culture(guid_culture);


--
-- Name: cul_culture_rl_hierarchy cul_culture_rl_hierarchy_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cul_culture_rl_hierarchy
    ADD CONSTRAINT cul_culture_rl_hierarchy_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: entity_entity entity_entity_guid_entitytype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entity
    ADD CONSTRAINT entity_entity_guid_entitytype_fkey FOREIGN KEY (guid_entitytype) REFERENCES entity_lu_entitytype(guid_entitytype);


--
-- Name: entity_entitydetail entity_entitydetail_guid_detailtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entitydetail
    ADD CONSTRAINT entity_entitydetail_guid_detailtype_fkey FOREIGN KEY (guid_detailtype) REFERENCES entity_lu_detailtype(guid_detailtype);


--
-- Name: entity_entitydetail entity_entitydetail_guid_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entitydetail
    ADD CONSTRAINT entity_entitydetail_guid_entity_fkey FOREIGN KEY (guid_entity) REFERENCES entity_entity(guid_entity);


--
-- Name: entity_entitydetail entity_entitydetail_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entitydetail
    ADD CONSTRAINT entity_entitydetail_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: entity_rl_entity_entity entity_rl_entity_entity_guid_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entity_entity
    ADD CONSTRAINT entity_rl_entity_entity_guid_entity_fkey FOREIGN KEY (guid_entity) REFERENCES entity_entity(guid_entity);


--
-- Name: entity_rl_entity_entity entity_rl_entity_entity_guid_entityrelashionshiptype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entity_entity
    ADD CONSTRAINT entity_rl_entity_entity_guid_entityrelashionshiptype_fkey FOREIGN KEY (guid_entityrelashionshiptype) REFERENCES conn_lu_entityrelationshiptype(guid_entityrelationshiptype);


--
-- Name: entity_rl_entity_entity entity_rl_entity_entity_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entity_entity
    ADD CONSTRAINT entity_rl_entity_entity_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: entity_rl_entity_entity entity_rl_entity_entity_parent_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entity_entity
    ADD CONSTRAINT entity_rl_entity_entity_parent_entity_fkey FOREIGN KEY (parent_entity) REFERENCES entity_entity(guid_entity);


--
-- Name: entity_rl_entitytype_detailtype entity_rl_entitytype_detailtype_guid_detailtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entitytype_detailtype
    ADD CONSTRAINT entity_rl_entitytype_detailtype_guid_detailtype_fkey FOREIGN KEY (guid_detailtype) REFERENCES entity_lu_detailtype(guid_detailtype);


--
-- Name: entity_rl_entitytype_detailtype entity_rl_entitytype_detailtype_guid_entitytype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_rl_entitytype_detailtype
    ADD CONSTRAINT entity_rl_entitytype_detailtype_guid_entitytype_fkey FOREIGN KEY (guid_entitytype) REFERENCES entity_lu_entitytype(guid_entitytype);


--
-- Name: entity_entity fk_entity_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entity
    ADD CONSTRAINT fk_entity_type FOREIGN KEY (guid_entitytype) REFERENCES entity_lu_entitytype(guid_entitytype);


--
-- Name: entity_entity fk_timeperiod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entity_entity
    ADD CONSTRAINT fk_timeperiod FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: timeperiod_event fk_timeperiod_event_sub_timeperiod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod_event
    ADD CONSTRAINT fk_timeperiod_event_sub_timeperiod FOREIGN KEY ("parent_timePeriod") REFERENCES timeperiod(guid_timeperiod);


--
-- Name: timeperiod_event fk_timeperiod_event_timeperiod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod_event
    ADD CONSTRAINT fk_timeperiod_event_timeperiod FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: timeperiod_event fk_timeperiod_event_timeperiod_eventtype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod_event
    ADD CONSTRAINT fk_timeperiod_event_timeperiod_eventtype FOREIGN KEY (guid_eventtype) REFERENCES timeperiod_eventtype(guid_eventtype);


--
-- Name: timeperiod fk_timeperiod_timeperiod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY timeperiod
    ADD CONSTRAINT fk_timeperiod_timeperiod FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: rel_religion_rl_hierarchy rel_relgion_rl_hierarchy_guid_relgion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rel_religion_rl_hierarchy
    ADD CONSTRAINT rel_relgion_rl_hierarchy_guid_relgion_fkey FOREIGN KEY (guid_religion) REFERENCES rel_religion(guid_religion);


--
-- Name: rel_religion_rl_hierarchy rel_rl_religion_religion_guid_timeperiod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rel_religion_rl_hierarchy
    ADD CONSTRAINT rel_rl_religion_religion_guid_timeperiod_fkey FOREIGN KEY (guid_timeperiod) REFERENCES timeperiod(guid_timeperiod);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

