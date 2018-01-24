--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2018-01-24 07:37:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3188 (class 1262 OID 12938)
DROP DATABASE if exists monster_builder;
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE monster_builder WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


ALTER DATABASE monster_builder OWNER TO postgres;

\connect monster_builder

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3189 (class 1262 OID 12938)
-- Dependencies: 3188
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE monster_builder IS 'D&D 5e Monster Building Tool';


--
-- TOC entry 2 (class 3079 OID 12924)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3192 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3193 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 197 (class 1259 OID 24871)
-- Name: arm_armor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE arm_armor (
    guid_armor uuid NOT NULL,
    guid_armortype uuid NOT NULL,
    name_armor character varying(40) NOT NULL,
    armor_class integer NOT NULL,
    has_stealthdisadvantage boolean NOT NULL
);


ALTER TABLE arm_armor OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 24876)
-- Name: arm_lu_armortype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE arm_lu_armortype (
    guid_armortype uuid NOT NULL,
    name_armortype character varying(50) NOT NULL
);


ALTER TABLE arm_lu_armortype OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 24881)
-- Name: arm_rl_acmodifier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE arm_rl_acmodifier (
    guid_armor uuid NOT NULL,
    max_modifier integer NOT NULL,
    guid_abilityscore uuid NOT NULL
);


ALTER TABLE arm_rl_acmodifier OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 24886)
-- Name: arm_shield; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE arm_shield (
    guid_shield uuid NOT NULL,
    name_shield character varying(20) NOT NULL,
    armor_class integer NOT NULL
);


ALTER TABLE arm_shield OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 24891)
-- Name: com_abilityscore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_abilityscore (
    guid_abilityscore uuid NOT NULL,
    name_abilityscore character varying(50) NOT NULL
);


ALTER TABLE com_abilityscore OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 24896)
-- Name: com_cr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_cr (
    guid_cr uuid NOT NULL,
    rank_cr integer NOT NULL,
    name_cr character varying(3) NOT NULL,
    experience_points integer NOT NULL
);


ALTER TABLE com_cr OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 24901)
-- Name: com_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_language (
    guid_language uuid NOT NULL,
    name_language character varying(30) NOT NULL,
    name_script character varying(30) NOT NULL
);


ALTER TABLE com_language OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 24906)
-- Name: com_lu_armorclass; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_lu_armorclass (
    armor_class integer NOT NULL,
    guid_cr uuid NOT NULL
);


ALTER TABLE com_lu_armorclass OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 24911)
-- Name: com_lu_movement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_lu_movement (
    guid_movement uuid NOT NULL,
    name_movement character varying(30) NOT NULL
);


ALTER TABLE com_lu_movement OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 24916)
-- Name: com_lu_senses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_lu_senses (
    guid_sense uuid NOT NULL,
    name_sense character varying(30) NOT NULL
);


ALTER TABLE com_lu_senses OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 24921)
-- Name: com_lu_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_lu_skill (
    guid_skill uuid NOT NULL,
    name_skill character varying(30) NOT NULL
);


ALTER TABLE com_lu_skill OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 24926)
-- Name: com_protectionfromdamage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_protectionfromdamage (
    guid_protection uuid NOT NULL,
    name_protection character varying(10) NOT NULL
);


ALTER TABLE com_protectionfromdamage OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 24931)
-- Name: com_rl_abilityscore_modifier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_rl_abilityscore_modifier (
    value_abilityscore integer NOT NULL,
    value_abilityscore_modifier integer NOT NULL
);


ALTER TABLE com_rl_abilityscore_modifier OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 24936)
-- Name: com_rl_abilityscore_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_rl_abilityscore_skill (
    guid_abilityscore uuid NOT NULL,
    guid_skill uuid NOT NULL
);


ALTER TABLE com_rl_abilityscore_skill OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 24941)
-- Name: com_rl_monster_abilityscore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_rl_monster_abilityscore (
    guid_monster uuid NOT NULL,
    guid_abilityscore uuid NOT NULL,
    value_abilityscore integer NOT NULL
);


ALTER TABLE com_rl_monster_abilityscore OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24946)
-- Name: com_rl_monster_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_rl_monster_language (
    guid_monster uuid NOT NULL,
    guid_language uuid NOT NULL
);


ALTER TABLE com_rl_monster_language OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 24951)
-- Name: com_size; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE com_size (
    guid_size uuid NOT NULL,
    name_size character varying(15) NOT NULL,
    guid_die uuid NOT NULL
);


ALTER TABLE com_size OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24956)
-- Name: core_lu_cr_proficiency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE core_lu_cr_proficiency (
    proficiency_bonus integer NOT NULL,
    guid_cr uuid NOT NULL
);


ALTER TABLE core_lu_cr_proficiency OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24961)
-- Name: core_lu_defensive_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE core_lu_defensive_values (
    guid_cr uuid NOT NULL,
    ac integer NOT NULL,
    minimum_hp integer NOT NULL,
    maximum_hp integer NOT NULL
);


ALTER TABLE core_lu_defensive_values OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24966)
-- Name: core_lu_offensive_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE core_lu_offensive_values (
    guid_cr uuid NOT NULL,
    attack_bonus integer NOT NULL,
    save_dc integer NOT NULL,
    minimum_damage integer NOT NULL,
    maximum_damage integer NOT NULL
);


ALTER TABLE core_lu_offensive_values OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24971)
-- Name: custom_attack_dice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE custom_attack_dice (
    number_dice integer NOT NULL,
    guid_die uuid NOT NULL,
    guid_custom_attack uuid NOT NULL
);


ALTER TABLE custom_attack_dice OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24976)
-- Name: custom_weapon_attack; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE custom_weapon_attack (
    guid_custom_attack uuid NOT NULL,
    name_custom_attack character varying(50) NOT NULL,
    guid_damagetype uuid NOT NULL,
    guid_abilityscore uuid NOT NULL
);


ALTER TABLE custom_weapon_attack OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24981)
-- Name: dice_dice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE dice_dice (
    guid_die uuid NOT NULL,
    min_roll integer NOT NULL,
    max_roll integer NOT NULL,
    average_roll double precision NOT NULL,
    name_die character varying(3) NOT NULL
);


ALTER TABLE dice_dice OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24987)
-- Name: feature_lu_feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE feature_lu_feature (
    guid_feature uuid NOT NULL,
    name_feature character varying(30) NOT NULL,
    stat_modifier text,
    description_feature text
);


ALTER TABLE feature_lu_feature OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24995)
-- Name: feature_rl_monster_feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE feature_rl_monster_feature (
    guid_monster uuid NOT NULL,
    guid_feature uuid NOT NULL
);


ALTER TABLE feature_rl_monster_feature OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25000)
-- Name: hp_protection_cr_modifier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE hp_protection_cr_modifier (
    effective_hpmodifier double precision NOT NULL,
    guid_cr uuid NOT NULL,
    guid_protection uuid NOT NULL
);


ALTER TABLE hp_protection_cr_modifier OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25005)
-- Name: mon_lu_goodness; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_lu_goodness (
    guid_goodness uuid NOT NULL,
    name_morality character varying(30) NOT NULL
);


ALTER TABLE mon_lu_goodness OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25010)
-- Name: mon_lu_lawfulness; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_lu_lawfulness (
    guid_lawfulness uuid NOT NULL,
    name_lawfulness text NOT NULL
);


ALTER TABLE mon_lu_lawfulness OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25018)
-- Name: mon_lu_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_lu_type (
    guid_type uuid NOT NULL,
    name_type character varying(30) NOT NULL
);


ALTER TABLE mon_lu_type OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25023)
-- Name: mon_monster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_monster (
    guid_monster uuid NOT NULL,
    name_monster character varying(50),
    description_monster text,
    guid_size uuid,
    guid_alignment uuid,
    guid_type uuid,
    guid_cr uuid
);


ALTER TABLE mon_monster OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25031)
-- Name: mon_rl_alignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_alignment (
    guid_alignment uuid NOT NULL,
    name_alignment character varying(50) NOT NULL,
    guid_lawfulness uuid NOT NULL,
    guid_goodness uuid NOT NULL
);


ALTER TABLE mon_rl_alignment OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25036)
-- Name: mon_rl_monster_armor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_monster_armor (
    guid_monster uuid NOT NULL,
    guid_armor uuid NOT NULL,
    guid_shield uuid
);


ALTER TABLE mon_rl_monster_armor OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25041)
-- Name: mon_rl_monster_movement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_monster_movement (
    guid_monster uuid NOT NULL,
    guid_movement uuid NOT NULL,
    speed_movement integer NOT NULL
);


ALTER TABLE mon_rl_monster_movement OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25046)
-- Name: mon_rl_monster_senses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_monster_senses (
    guid_monster uuid NOT NULL,
    guid_sense uuid NOT NULL,
    distance_sense integer NOT NULL
);


ALTER TABLE mon_rl_monster_senses OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25051)
-- Name: mon_rl_monster_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_monster_skill (
    guid_monster uuid NOT NULL,
    guid_skill uuid NOT NULL
);


ALTER TABLE mon_rl_monster_skill OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25056)
-- Name: mon_rl_monster_weapon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_monster_weapon (
    guid_monster uuid NOT NULL,
    guid_weapon uuid NOT NULL
);


ALTER TABLE mon_rl_monster_weapon OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 25061)
-- Name: mon_rl_protection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mon_rl_protection (
    guid_damagetype uuid NOT NULL,
    guid_monster uuid NOT NULL,
    guid_protection uuid NOT NULL
);


ALTER TABLE mon_rl_protection OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25068)
-- Name: sysdiagrams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sysdiagrams (
    name character varying(128) NOT NULL,
    principal_id integer NOT NULL,
    diagram_id integer NOT NULL,
    version integer,
    definition bytea
);


ALTER TABLE sysdiagrams OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25066)
-- Name: sysdiagrams_diagram_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sysdiagrams_diagram_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sysdiagrams_diagram_id_seq OWNER TO postgres;

--
-- TOC entry 3194 (class 0 OID 0)
-- Dependencies: 234
-- Name: sysdiagrams_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sysdiagrams_diagram_id_seq OWNED BY sysdiagrams.diagram_id;


--
-- TOC entry 236 (class 1259 OID 25079)
-- Name: temp_monster_cr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE temp_monster_cr (
    guid_monster uuid NOT NULL,
    offensive_cr uuid,
    defensive_cr uuid
);


ALTER TABLE temp_monster_cr OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 25082)
-- Name: weap_lu_damagetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_lu_damagetype (
    guid_damagetype uuid NOT NULL,
    name_damagetype character varying(30) NOT NULL
);


ALTER TABLE weap_lu_damagetype OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25087)
-- Name: weap_lu_size_weapondice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_lu_size_weapondice (
    guid_size uuid NOT NULL,
    size_die_multiplier integer NOT NULL
);


ALTER TABLE weap_lu_size_weapondice OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 25092)
-- Name: weap_lu_skillrequired; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_lu_skillrequired (
    guid_skill uuid NOT NULL,
    name_skilllevel character varying(20) NOT NULL
);


ALTER TABLE weap_lu_skillrequired OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 25097)
-- Name: weap_lu_weaponreach; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_lu_weaponreach (
    guid_reach uuid NOT NULL,
    name_reach character varying(30) NOT NULL
);


ALTER TABLE weap_lu_weaponreach OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 25102)
-- Name: weap_lu_weapontrait; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_lu_weapontrait (
    guid_trait uuid NOT NULL,
    name_trait character varying(100) NOT NULL
);


ALTER TABLE weap_lu_weapontrait OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 25107)
-- Name: weap_lu_weapontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_lu_weapontype (
    guid_weapontype uuid NOT NULL,
    guid_skill uuid,
    guid_reach uuid,
    name_weapontype text NOT NULL
);


ALTER TABLE weap_lu_weapontype OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 25115)
-- Name: weap_rl_weapon_abilityscore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_rl_weapon_abilityscore (
    guid_abilityscore uuid NOT NULL,
    guid_weapon uuid NOT NULL
);


ALTER TABLE weap_rl_weapon_abilityscore OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 25120)
-- Name: weap_rl_weapon_weapontrait; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_rl_weapon_weapontrait (
    guid_trait uuid NOT NULL,
    guid_weapon uuid NOT NULL
);


ALTER TABLE weap_rl_weapon_weapontrait OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 25125)
-- Name: weap_weapon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE weap_weapon (
    guid_weapon uuid NOT NULL,
    guid_die uuid,
    guid_damagetype uuid,
    guid_weapontype uuid NOT NULL,
    number_damagedice integer NOT NULL,
    name_weapon character varying(50) NOT NULL
);


ALTER TABLE weap_weapon OWNER TO postgres;

--
-- TOC entry 2864 (class 2604 OID 25071)
-- Name: sysdiagrams diagram_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sysdiagrams ALTER COLUMN diagram_id SET DEFAULT nextval('sysdiagrams_diagram_id_seq'::regclass);


--
-- TOC entry 3135 (class 0 OID 24871)
-- Dependencies: 197
-- Data for Name: arm_armor; Type: TABLE DATA; Schema: public; Owner: postgres
--
/*
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('bc22c77c-47ce-4545-8e01-0dc50b181863', '017f6724-b3bb-47a9-866f-aa0f6b5ea615', 'Tatural Armor', 0, false);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('5671fbac-4ca1-40f7-a2ba-2ca169cfda74', 'f79ac52b-9051-4150-bd72-04685bafb2ec', 'Tplint', 17, true);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('28c85887-22a6-48fd-af47-3672826ca38b', '56932a77-ee68-4be6-a38d-3310856d9c40', 'Ttudded leather', 12, false);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('473b5e7e-8aa8-47c3-a277-40afaf1b8663', '56932a77-ee68-4be6-a38d-3310856d9c40', 'Teather', 11, false);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('4691e07a-52e1-4a67-8c76-5ce7be7e3c6e', '91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', 'Tide', 12, false);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('aec7ec59-d514-47be-868f-66d6d11dd8fa', '56932a77-ee68-4be6-a38d-3310856d9c40', 'Tadded', 11, true);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('709e9bd1-33dd-40c3-a768-73278de345a6', '91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', 'Tcale Mail', 14, true);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('e3380772-677d-47e0-8b12-84f4e131b787', '91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', 'Talf Plate', 15, true);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('3163b20f-aeae-48db-b63d-a72e4c956e9c', '91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', 'Treastplate', 14, false);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('f747896e-2497-4ac6-9fe9-afbc7647bcd8', 'f79ac52b-9051-4150-bd72-04685bafb2ec', 'Ting Mail', 14, true);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('ca6d4488-781d-4be6-8ce8-bc65496b4450', 'f79ac52b-9051-4150-bd72-04685bafb2ec', 'Thain Mail', 16, true);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('088f622d-e6c3-4ff4-af2a-cb002f8e1405', '91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', 'Thain Shirt', 13, false);
INSERT INTO arm_armor (guid_armor, guid_armortype, name_armor, armor_class, has_stealthdisadvantage) VALUES ('c9f77dd7-34f5-4292-9452-ef60a59413c3', 'f79ac52b-9051-4150-bd72-04685bafb2ec', 'Tlate', 18, true);


--
-- TOC entry 3136 (class 0 OID 24876)
-- Dependencies: 198
-- Data for Name: arm_lu_armortype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO arm_lu_armortype (guid_armortype, name_armortype) VALUES ('f79ac52b-9051-4150-bd72-04685bafb2ec', 'Teavy');
INSERT INTO arm_lu_armortype (guid_armortype, name_armortype) VALUES ('56932a77-ee68-4be6-a38d-3310856d9c40', 'Tight');
INSERT INTO arm_lu_armortype (guid_armortype, name_armortype) VALUES ('91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', 'Tedium');
INSERT INTO arm_lu_armortype (guid_armortype, name_armortype) VALUES ('017f6724-b3bb-47a9-866f-aa0f6b5ea615', 'Tatural');


--
-- TOC entry 3137 (class 0 OID 24881)
-- Dependencies: 199
-- Data for Name: arm_rl_acmodifier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('28c85887-22a6-48fd-af47-3672826ca38b', 0, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('473b5e7e-8aa8-47c3-a277-40afaf1b8663', 0, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('4691e07a-52e1-4a67-8c76-5ce7be7e3c6e', 2, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('aec7ec59-d514-47be-868f-66d6d11dd8fa', 0, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('709e9bd1-33dd-40c3-a768-73278de345a6', 2, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('e3380772-677d-47e0-8b12-84f4e131b787', 2, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('3163b20f-aeae-48db-b63d-a72e4c956e9c', 2, '6c49abc6-06f1-436a-a046-f50e9cc93808');
INSERT INTO arm_rl_acmodifier (guid_armor, max_modifier, guid_abilityscore) VALUES ('088f622d-e6c3-4ff4-af2a-cb002f8e1405', 2, '6c49abc6-06f1-436a-a046-f50e9cc93808');


--
-- TOC entry 3138 (class 0 OID 24886)
-- Dependencies: 200
-- Data for Name: arm_shield; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO arm_shield (guid_shield, name_shield, armor_class) VALUES ('1adc4be5-872e-40d2-91cf-e3c7a2757281', 'Thield', 2);


--
-- TOC entry 3139 (class 0 OID 24891)
-- Dependencies: 201
-- Data for Name: com_abilityscore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_abilityscore (guid_abilityscore, name_abilityscore) VALUES ('2d98bb55-6f0f-4d35-bcdc-01a405ce770f', 'Tisdom');
INSERT INTO com_abilityscore (guid_abilityscore, name_abilityscore) VALUES ('74ee66a4-deda-4660-9f4a-2d40becc0e77', 'Tonstitution');
INSERT INTO com_abilityscore (guid_abilityscore, name_abilityscore) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'Ttrength');
INSERT INTO com_abilityscore (guid_abilityscore, name_abilityscore) VALUES ('a8a91281-619e-43af-b32d-8ef14cc41151', 'Tntelligence');
INSERT INTO com_abilityscore (guid_abilityscore, name_abilityscore) VALUES ('d38c4a57-4c05-4eff-872f-d9c886ca558f', 'Tharisma');
INSERT INTO com_abilityscore (guid_abilityscore, name_abilityscore) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'Texterity');


--
-- TOC entry 3140 (class 0 OID 24896)
-- Dependencies: 202
-- Data for Name: com_cr; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('6798d7f1-d779-437c-9c99-000031c5d30c', 6, 'T', 450);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('f6d26cd6-f212-452b-a6f4-033cd3525d49', 28, 'T4', 62000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('8bb60024-59fa-46e0-921e-05f60dd26cdb', 34, 'T0', 155000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('b5f9abae-8b6e-43d0-b3c1-08b23907121a', 8, 'T', 1100);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('d8e93c9d-4553-4ce1-b30b-14c5822e4b22', 20, 'T6', 15000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('b997bbc4-0aed-4a32-acab-166134369f47', 31, 'T7', 105000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('ac3179be-938e-4819-9098-2106abdbb429', 22, 'T8', 20000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('e45b322e-a694-43a0-a42d-210b2fcf05f7', 1, 'T', 0);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('7faff7cc-8691-4b27-ae01-2606bafba93f', 15, 'T1', 7200);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('e58ab5bd-f7be-4989-bfd0-26840cf218f7', 24, 'T0', 25000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', 14, 'T0', 5900);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('a0e4ee68-87f0-433c-bfa6-2c834b382119', 30, 'T6', 90000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('9c3c55bc-5044-46e4-9bc4-3d2ebe317430', 21, 'T7', 18000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('6558423c-eb07-48dc-a694-3efdc36be41d', 32, 'T8', 120000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('32a77e7d-ade9-4461-8941-421809e379fc', 2, 'T/8', 25);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('fa7e2c4d-5fc6-41c1-83f6-442c7282950b', 12, 'T', 3900);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('584e036f-f640-4e76-937a-57fb7c9aad41', 5, 'T', 200);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('4fbabffc-b152-43cc-b361-5b03cb53c60d', 29, 'T5', 75000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('902e442e-5ac7-411a-9f77-6b8a12e58cdf', 23, 'T9', 22000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('7a06f521-598d-4736-9c7f-6e4d87c77a05', 4, 'T/2', 100);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('8caf6098-94d8-4d25-a19f-6edc5131d168', 18, 'T4', 11500);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('27de4a7f-8762-41d8-b6b9-6f1f1902de74', 25, 'T1', 33000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('9bc8da1e-a396-46ae-8884-758b0676c05a', 19, 'T5', 13000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', 13, 'T', 5000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', 33, 'T9', 135000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('2bd93716-3342-4160-891f-8cdbebdf885e', 27, 'T3', 50000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', 10, 'T', 2300);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('22e2f0ce-c357-4d4f-8668-bf4d85b3369c', 26, 'T2', 41000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('641fa88c-f7b3-4822-9136-d174b155e193', 9, 'T', 1800);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('12a0ccf5-11c7-44f4-a44f-e7729ee11bba', 11, 'T', 2900);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('54d4a58f-d22d-4c49-b16c-f40979f55207', 17, 'T3', 10000);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('7205de9d-e02b-4c83-bbc0-f6ede21434f6', 7, 'T', 700);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('864ed2cf-5aea-45a7-add2-f7228ea1e3f3', 16, 'T2', 8400);
INSERT INTO com_cr (guid_cr, rank_cr, name_cr, experience_points) VALUES ('2a7b6a97-4784-452f-936e-ff44d2cbc3ba', 3, 'T/4', 50);


--
-- TOC entry 3141 (class 0 OID 24901)
-- Dependencies: 203
-- Data for Name: com_language; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('bbca4bf6-f2aa-425d-b31e-2719a5a11ecb', 'Tlvish', 'Tlvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('24de5d90-3314-40d2-b725-27388161d9c5', 'Talfling', 'Tommon');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('3d904bac-cccf-42fd-8ca2-35813066a96e', 'Tndercommon', 'Tnderscript');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('ffa8126e-f845-4a56-b950-56a2fc2231f9', 'Trc', 'Twarvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('68336ea4-c5a6-478d-9a3b-717cbec7273c', 'Tylvan', 'Tlvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('e957ed0f-78b2-4428-8a51-78f72c40d702', 'Traconic', 'Traconic');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('cdc039b0-38b1-4578-a081-7960b9b09f49', 'Twarvish', 'Twarvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('d57871f8-2905-4d98-aa5a-8544f8cc1d14', 'Tiant', 'Twarvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('74dd4172-d496-48b0-878e-92856964dae1', 'Toblin', 'Twarvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('cf3aa67b-ac66-4fbd-a83d-93881ec3113f', 'Trimordial', 'Twarvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('9b578587-711a-4ab9-a09c-95a77bf28342', 'Tommon', 'Tommon');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('3b7fcac8-79c3-4e32-a5ec-c427e1518c74', 'Telestial', 'Telestial');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('56a41403-9e73-4174-908d-c9e03d49d4b8', 'Tnfernal', 'Tnfernal');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('9cace042-ced7-4fac-b71b-cc3fe2e30890', 'Tnomish', 'Twarvish');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('6ae5c857-6faa-4a6b-83de-d2e4fce8305a', 'Teep Speech', 'Tone');
INSERT INTO com_language (guid_language, name_language, name_script) VALUES ('f0804fe8-00f8-4d94-a21a-e09974a19afc', 'Tbyssal', 'Tnfernal');


--
-- TOC entry 3142 (class 0 OID 24906)
-- Dependencies: 204
-- Data for Name: com_lu_armorclass; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3143 (class 0 OID 24911)
-- Dependencies: 205
-- Data for Name: com_lu_movement; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_lu_movement (guid_movement, name_movement) VALUES ('66ad7c4f-8a55-4256-99a9-48152b0f4fcb', 'Talking');
INSERT INTO com_lu_movement (guid_movement, name_movement) VALUES ('474b0d21-87bf-4a7b-bd77-625293f1497a', 'Tlimbing');
INSERT INTO com_lu_movement (guid_movement, name_movement) VALUES ('84fe9cca-37e3-45b7-bda9-903c268a8a28', 'Twimming');
INSERT INTO com_lu_movement (guid_movement, name_movement) VALUES ('d4d08461-7a02-466e-9988-b68f44c06906', 'Turrowing');
INSERT INTO com_lu_movement (guid_movement, name_movement) VALUES ('f5420c6c-29be-4178-afaa-dab2710a67bd', 'Tlying');


--
-- TOC entry 3144 (class 0 OID 24916)
-- Dependencies: 206
-- Data for Name: com_lu_senses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_lu_senses (guid_sense, name_sense) VALUES ('373dc787-a970-465e-86f5-05ea95c53689', 'Tarkvision');
INSERT INTO com_lu_senses (guid_sense, name_sense) VALUES ('17b2ad71-e65a-4ef3-aabc-09e5d943153b', 'Tlindsight');
INSERT INTO com_lu_senses (guid_sense, name_sense) VALUES ('9b13aada-c519-4a0f-aaab-43002f8fd2d9', 'Truesight');
INSERT INTO com_lu_senses (guid_sense, name_sense) VALUES ('3c3890cb-3e8f-4ec4-88f5-f908c2259f12', 'Tremorsense');


--
-- TOC entry 3145 (class 0 OID 24921)
-- Dependencies: 207
-- Data for Name: com_lu_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('0994ad2c-3c16-4a28-9099-00e800b8a18e', 'Tnvestigation');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('591a52a7-a577-4fa7-915a-077cb6434b97', 'Tistory');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('c55ffa93-4ec6-465d-a607-3ca1a6e5c8dc', 'Tedicine');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('98afd2f4-dcb0-4ef9-9c22-4183e652de8a', 'Tersuasion');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('605fb05b-0adc-4d7d-ba63-46fb95bf3b7c', 'Terception');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('9f2451a2-35ef-433e-9f2f-63e6c5154004', 'Tthletics');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('af549fb6-6972-4fe1-b063-9743d82ce9e5', 'Tature');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('bf93e1a0-4445-4f0c-a2d2-9ab7bbfb395c', 'Ttealth');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('ef3db14f-370a-42ef-9515-acbc78fc657d', 'Turvival');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('c6769c24-53df-43ae-a696-b901493ccb5e', 'Teligion');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('340307f6-63c6-4f02-9417-d2a34677446d', 'Tntimidation');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('c7714643-aa68-4fc3-8ae5-dcf0307fdf47', 'Tnsight');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('ea6b363d-4d3e-4883-8b29-dcf9c71db876', 'Terformance');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('2e6c43f3-ddef-4dd8-9ab6-ef985e7018fb', 'Tnimal Handling');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('e9d9e738-38f5-44ef-b3fd-f4edc8b82d3c', 'Teception');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('d675676c-2312-4f81-97d1-f4fe6ced7ac3', 'Tleight of Hand');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('1084a24e-7746-4775-8f70-f7980c3514f4', 'Trcana');
INSERT INTO com_lu_skill (guid_skill, name_skill) VALUES ('dae0c6b2-9a75-42b1-abe9-f7bca37d7a65', 'Tcrobatics');


--
-- TOC entry 3146 (class 0 OID 24926)
-- Dependencies: 208
-- Data for Name: com_protectionfromdamage; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_protectionfromdamage (guid_protection, name_protection) VALUES ('2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6', 'Tesistance');
INSERT INTO com_protectionfromdamage (guid_protection, name_protection) VALUES ('78bc70a4-f0c3-4c6a-8745-b2b054099ce8', 'Tmmunity');


--
-- TOC entry 3147 (class 0 OID 24931)
-- Dependencies: 209
-- Data for Name: com_rl_abilityscore_modifier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (1, -5);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (2, -4);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (3, -4);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (4, -3);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (5, -3);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (6, -2);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (7, -2);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (8, -1);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (9, -1);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (10, 0);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (11, 0);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (12, 1);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (13, 1);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (14, 2);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (15, 2);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (16, 3);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (17, 3);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (18, 4);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (19, 4);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (20, 5);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (21, 5);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (22, 6);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (23, 6);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (24, 7);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (25, 7);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (26, 8);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (27, 8);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (28, 9);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (29, 9);
INSERT INTO com_rl_abilityscore_modifier (value_abilityscore, value_abilityscore_modifier) VALUES (30, 10);


--
-- TOC entry 3148 (class 0 OID 24936)
-- Dependencies: 210
-- Data for Name: com_rl_abilityscore_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('2d98bb55-6f0f-4d35-bcdc-01a405ce770f', 'c55ffa93-4ec6-465d-a607-3ca1a6e5c8dc');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('2d98bb55-6f0f-4d35-bcdc-01a405ce770f', '605fb05b-0adc-4d7d-ba63-46fb95bf3b7c');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('2d98bb55-6f0f-4d35-bcdc-01a405ce770f', 'ef3db14f-370a-42ef-9515-acbc78fc657d');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('2d98bb55-6f0f-4d35-bcdc-01a405ce770f', 'c7714643-aa68-4fc3-8ae5-dcf0307fdf47');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('2d98bb55-6f0f-4d35-bcdc-01a405ce770f', '2e6c43f3-ddef-4dd8-9ab6-ef985e7018fb');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '9f2451a2-35ef-433e-9f2f-63e6c5154004');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('a8a91281-619e-43af-b32d-8ef14cc41151', '0994ad2c-3c16-4a28-9099-00e800b8a18e');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('a8a91281-619e-43af-b32d-8ef14cc41151', '591a52a7-a577-4fa7-915a-077cb6434b97');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('a8a91281-619e-43af-b32d-8ef14cc41151', 'af549fb6-6972-4fe1-b063-9743d82ce9e5');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('a8a91281-619e-43af-b32d-8ef14cc41151', 'c6769c24-53df-43ae-a696-b901493ccb5e');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('a8a91281-619e-43af-b32d-8ef14cc41151', '1084a24e-7746-4775-8f70-f7980c3514f4');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('d38c4a57-4c05-4eff-872f-d9c886ca558f', '98afd2f4-dcb0-4ef9-9c22-4183e652de8a');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('d38c4a57-4c05-4eff-872f-d9c886ca558f', '340307f6-63c6-4f02-9417-d2a34677446d');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('d38c4a57-4c05-4eff-872f-d9c886ca558f', 'ea6b363d-4d3e-4883-8b29-dcf9c71db876');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('d38c4a57-4c05-4eff-872f-d9c886ca558f', 'e9d9e738-38f5-44ef-b3fd-f4edc8b82d3c');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'bf93e1a0-4445-4f0c-a2d2-9ab7bbfb395c');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'd675676c-2312-4f81-97d1-f4fe6ced7ac3');
INSERT INTO com_rl_abilityscore_skill (guid_abilityscore, guid_skill) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'dae0c6b2-9a75-42b1-abe9-f7bca37d7a65');


--
-- TOC entry 3149 (class 0 OID 24941)
-- Dependencies: 211
-- Data for Name: com_rl_monster_abilityscore; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3150 (class 0 OID 24946)
-- Dependencies: 212
-- Data for Name: com_rl_monster_language; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3151 (class 0 OID 24951)
-- Dependencies: 213
-- Data for Name: com_size; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO com_size (guid_size, name_size, guid_die) VALUES ('a4d28780-e894-4d7a-b065-1cb00ee01d80', 'Tmall', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307');
INSERT INTO com_size (guid_size, name_size, guid_die) VALUES ('5e6048f6-e0ec-4bb1-9065-2116230246ff', 'Targantuan', '61cb0fcd-7038-43e5-894f-a1a7a2cccce1');
INSERT INTO com_size (guid_size, name_size, guid_die) VALUES ('2ef6d926-9d94-46d6-9f4d-6b14321d7d2e', 'Tiny', '1ff5257c-1568-49c1-a656-088b4884efc0');
INSERT INTO com_size (guid_size, name_size, guid_die) VALUES ('c64a7d4b-30cd-4eee-a276-dbbde28daa21', 'Tedium', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8');
INSERT INTO com_size (guid_size, name_size, guid_die) VALUES ('5d0ff0c0-6053-476e-a423-df63946be45e', 'Targe', 'e01bf86f-0ff3-4cf7-897f-a185afb33c54');
INSERT INTO com_size (guid_size, name_size, guid_die) VALUES ('a9404107-c146-4e4f-ac83-f1b5df09bed7', 'Tuge', 'c4d1ecfa-f454-45cf-be70-cf784baf834f');


--
-- TOC entry 3152 (class 0 OID 24956)
-- Dependencies: 214
-- Data for Name: core_lu_cr_proficiency; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, '6798d7f1-d779-437c-9c99-000031c5d30c');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (7, 'f6d26cd6-f212-452b-a6f4-033cd3525d49');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (9, '8bb60024-59fa-46e0-921e-05f60dd26cdb');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, 'b5f9abae-8b6e-43d0-b3c1-08b23907121a');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (5, 'd8e93c9d-4553-4ce1-b30b-14c5822e4b22');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (8, 'b997bbc4-0aed-4a32-acab-166134369f47');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (6, 'ac3179be-938e-4819-9098-2106abdbb429');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, 'e45b322e-a694-43a0-a42d-210b2fcf05f7');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (4, '7faff7cc-8691-4b27-ae01-2606bafba93f');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (6, 'e58ab5bd-f7be-4989-bfd0-26840cf218f7');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (4, 'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (8, 'a0e4ee68-87f0-433c-bfa6-2c834b382119');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (6, '9c3c55bc-5044-46e4-9bc4-3d2ebe317430');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (8, '6558423c-eb07-48dc-a694-3efdc36be41d');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, '32a77e7d-ade9-4461-8941-421809e379fc');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (3, 'fa7e2c4d-5fc6-41c1-83f6-442c7282950b');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, '584e036f-f640-4e76-937a-57fb7c9aad41');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (8, '4fbabffc-b152-43cc-b361-5b03cb53c60d');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (6, '902e442e-5ac7-411a-9f77-6b8a12e58cdf');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, '7a06f521-598d-4736-9c7f-6e4d87c77a05');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (5, '8caf6098-94d8-4d25-a19f-6edc5131d168');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (7, '27de4a7f-8762-41d8-b6b9-6f1f1902de74');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (5, '9bc8da1e-a396-46ae-8884-758b0676c05a');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (4, 'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (9, '5c50c90f-1fc0-4c89-85b6-7e5890c42d2a');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (7, '2bd93716-3342-4160-891f-8cdbebdf885e');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (3, 'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (7, '22e2f0ce-c357-4d4f-8668-bf4d85b3369c');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (3, '641fa88c-f7b3-4822-9136-d174b155e193');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (3, '12a0ccf5-11c7-44f4-a44f-e7729ee11bba');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (5, '54d4a58f-d22d-4c49-b16c-f40979f55207');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, '7205de9d-e02b-4c83-bbc0-f6ede21434f6');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (4, '864ed2cf-5aea-45a7-add2-f7228ea1e3f3');
INSERT INTO core_lu_cr_proficiency (proficiency_bonus, guid_cr) VALUES (2, '2a7b6a97-4784-452f-936e-ff44d2cbc3ba');


--
-- TOC entry 3153 (class 0 OID 24961)
-- Dependencies: 215
-- Data for Name: core_lu_defensive_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('6798d7f1-d779-437c-9c99-000031c5d30c', 13, 86, 100);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('f6d26cd6-f212-452b-a6f4-033cd3525d49', 19, 536, 580);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('8bb60024-59fa-46e0-921e-05f60dd26cdb', 19, 806, 860);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('b5f9abae-8b6e-43d0-b3c1-08b23907121a', 14, 116, 130);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('d8e93c9d-4553-4ce1-b30b-14c5822e4b22', 18, 296, 310);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('b997bbc4-0aed-4a32-acab-166134369f47', 19, 671, 715);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('ac3179be-938e-4819-9098-2106abdbb429', 19, 326, 340);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('e45b322e-a694-43a0-a42d-210b2fcf05f7', 13, 1, 6);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('7faff7cc-8691-4b27-ae01-2606bafba93f', 17, 221, 235);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('e58ab5bd-f7be-4989-bfd0-26840cf218f7', 19, 356, 400);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', 17, 206, 220);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('a0e4ee68-87f0-433c-bfa6-2c834b382119', 19, 626, 670);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('9c3c55bc-5044-46e4-9bc4-3d2ebe317430', 19, 311, 325);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('6558423c-eb07-48dc-a694-3efdc36be41d', 19, 716, 760);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('32a77e7d-ade9-4461-8941-421809e379fc', 13, 7, 36);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('fa7e2c4d-5fc6-41c1-83f6-442c7282950b', 16, 176, 190);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('584e036f-f640-4e76-937a-57fb7c9aad41', 13, 71, 85);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('4fbabffc-b152-43cc-b361-5b03cb53c60d', 19, 581, 625);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('902e442e-5ac7-411a-9f77-6b8a12e58cdf', 19, 341, 355);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('7a06f521-598d-4736-9c7f-6e4d87c77a05', 13, 50, 70);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('8caf6098-94d8-4d25-a19f-6edc5131d168', 18, 266, 280);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('27de4a7f-8762-41d8-b6b9-6f1f1902de74', 19, 401, 445);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('9bc8da1e-a396-46ae-8884-758b0676c05a', 18, 281, 295);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', 16, 191, 205);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', 19, 761, 805);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('2bd93716-3342-4160-891f-8cdbebdf885e', 19, 491, 535);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', 15, 146, 160);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('22e2f0ce-c357-4d4f-8668-bf4d85b3369c', 19, 446, 490);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('641fa88c-f7b3-4822-9136-d174b155e193', 15, 131, 145);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('12a0ccf5-11c7-44f4-a44f-e7729ee11bba', 15, 161, 175);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('54d4a58f-d22d-4c49-b16c-f40979f55207', 18, 251, 265);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('7205de9d-e02b-4c83-bbc0-f6ede21434f6', 13, 101, 115);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('864ed2cf-5aea-45a7-add2-f7228ea1e3f3', 17, 236, 250);
INSERT INTO core_lu_defensive_values (guid_cr, ac, minimum_hp, maximum_hp) VALUES ('2a7b6a97-4784-452f-936e-ff44d2cbc3ba', 13, 36, 49);


--
-- TOC entry 3154 (class 0 OID 24966)
-- Dependencies: 216
-- Data for Name: core_lu_offensive_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('6798d7f1-d779-437c-9c99-000031c5d30c', 3, 13, 15, 20);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('f6d26cd6-f212-452b-a6f4-033cd3525d49', 12, 21, 195, 212);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('8bb60024-59fa-46e0-921e-05f60dd26cdb', 14, 23, 303, 320);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('b5f9abae-8b6e-43d0-b3c1-08b23907121a', 5, 14, 27, 32);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('d8e93c9d-4553-4ce1-b30b-14c5822e4b22', 9, 18, 99, 4);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('b997bbc4-0aed-4a32-acab-166134369f47', 13, 22, 249, 266);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('ac3179be-938e-4819-9098-2106abdbb429', 10, 19, 111, 116);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('e45b322e-a694-43a0-a42d-210b2fcf05f7', 3, 13, 0, 1);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('7faff7cc-8691-4b27-ae01-2606bafba93f', 8, 17, 69, 74);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('e58ab5bd-f7be-4989-bfd0-26840cf218f7', 10, 19, 123, 140);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', 7, 17, 63, 68);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('a0e4ee68-87f0-433c-bfa6-2c834b382119', 12, 21, 231, 248);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('9c3c55bc-5044-46e4-9bc4-3d2ebe317430', 10, 19, 105, 110);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('6558423c-eb07-48dc-a694-3efdc36be41d', 13, 22, 267, 284);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('32a77e7d-ade9-4461-8941-421809e379fc', 3, 13, 2, 3);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('fa7e2c4d-5fc6-41c1-83f6-442c7282950b', 7, 16, 51, 56);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('584e036f-f640-4e76-937a-57fb7c9aad41', 3, 13, 9, 14);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('4fbabffc-b152-43cc-b361-5b03cb53c60d', 12, 21, 213, 230);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('902e442e-5ac7-411a-9f77-6b8a12e58cdf', 10, 19, 117, 122);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('7a06f521-598d-4736-9c7f-6e4d87c77a05', 3, 13, 6, 8);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('8caf6098-94d8-4d25-a19f-6edc5131d168', 8, 18, 87, 92);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('27de4a7f-8762-41d8-b6b9-6f1f1902de74', 11, 20, 141, 158);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('9bc8da1e-a396-46ae-8884-758b0676c05a', 8, 18, 93, 98);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', 7, 16, 57, 62);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', 13, 22, 285, 302);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('2bd93716-3342-4160-891f-8cdbebdf885e', 11, 20, 177, 194);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', 6, 15, 39, 44);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('22e2f0ce-c357-4d4f-8668-bf4d85b3369c', 11, 20, 159, 176);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('641fa88c-f7b3-4822-9136-d174b155e193', 6, 15, 33, 38);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('12a0ccf5-11c7-44f4-a44f-e7729ee11bba', 6, 15, 45, 50);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('54d4a58f-d22d-4c49-b16c-f40979f55207', 8, 18, 81, 86);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('7205de9d-e02b-4c83-bbc0-f6ede21434f6', 4, 13, 21, 26);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('864ed2cf-5aea-45a7-add2-f7228ea1e3f3', 8, 17, 75, 80);
INSERT INTO core_lu_offensive_values (guid_cr, attack_bonus, save_dc, minimum_damage, maximum_damage) VALUES ('2a7b6a97-4784-452f-936e-ff44d2cbc3ba', 3, 13, 4, 5);


--
-- TOC entry 3155 (class 0 OID 24971)
-- Dependencies: 217
-- Data for Name: custom_attack_dice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3156 (class 0 OID 24976)
-- Dependencies: 218
-- Data for Name: custom_weapon_attack; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3157 (class 0 OID 24981)
-- Dependencies: 219
-- Data for Name: dice_dice; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('1ff5257c-1568-49c1-a656-088b4884efc0', 1, 4, 2.5, 'T4');
INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 1, 8, 4.5, 'T8');
INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 1, 6, 3.5, 'T6');
INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('e01bf86f-0ff3-4cf7-897f-a185afb33c54', 1, 10, 5.5, 'T10');
INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('61cb0fcd-7038-43e5-894f-a1a7a2cccce1', 1, 20, 10.5, 'T20');
INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('c4d1ecfa-f454-45cf-be70-cf784baf834f', 1, 12, 6.5, 'T12');
INSERT INTO dice_dice (guid_die, min_roll, max_roll, average_roll, name_die) VALUES ('bd31d66d-3731-45bb-88b2-dbf1acfa6e98', 1, 1, 1, 'T1');


--
-- TOC entry 3158 (class 0 OID 24987)
-- Dependencies: 220
-- Data for Name: feature_lu_feature; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('30f9a521-8284-4c02-b841-0317e53061f3', 'Tpellcasting', 'Tt''s complicated', 'Taries');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('9afb16b6-9cdf-4153-909b-077ac8190d2f', 'Tlemental Body', 'Tncrease the monster''s effective per-round damage by the amount noted in the trait', 'T creature that touchers the monster or hits it with a melee attack while within 5 feet of it takes damage.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('9f48748c-5e52-4c41-875e-0a2f635f6e94', 'Ttanding Leap', NULL, 'The monster''s long jump is up to 20 feet and its high jump is up to 10 feet, with or without a running start.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('05be75ff-2ca1-4985-a6a2-14499ff3fa8f', 'Thange Shape ', NULL, 'The monster magically polymorphs into a humanoid or beast that has a challenge rating no higher than its own, or back into its true form. It reverts to its true form if it dies. Any equipment it is wearing or carrying is absorbed or borne by the new form (the monster''s choice). In a new form, the monster retains its alignment, hit points, Hit Dice, ability to speak, proficiencies, Legendary Resistance (if any), lair actions (if any), and Intelligence, Wisdom, and Charisma scores, as well as this action. Its statistics and capabilities are otherwise replaced by those of the new form, except any class features or legendary actions of that form.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('2e0c7794-4152-4fb3-a26b-1ea70114fdf9', 'Tnnate Spellcasting', 'Tt''s complicated', 'Taries');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('e9acc141-9a59-40db-b2f8-1fab7334e1e0', 'Ttherworldly Perception', NULL, 'The monster can sense the presence of any creature within 30 feet of it that is invisible or on the Ethereal Plane. It can pinpoint such a creature that is moving. ');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('a829c160-0287-4853-9734-22831a64fe05', 'Teb Sense', NULL, 'Thile in contact with a web, the monster knows the exact location of any other creature in contact with the same web.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('0915b940-766a-4a50-a1d6-23e1e09e71de', 'Tunneler', NULL, 'The monster can burrow through solid rock at half its burrowing speed and leaves a tunnel in its wake.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('53fb9601-75cc-4736-bf3a-28db6d0fc8cc', 'Tejuvenation', NULL, 'Tf it has a phylactery, the destroyed monster gains a new body in 1d10 days, regaining all its hit points and becoming active again . The new body appears within 5 feet of the phylactery.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('95867524-4693-4a21-a40b-29016278ba47', 'Tevil Sight', NULL, 'Tagical darkness doesn''t impede the darkvision .');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('b1a47bb5-28e9-4445-af10-2905afd563b1', 'Tvoidance', 'Tncrease the monster''s effective AC by 1', 'Tf the monster is subjected to an effect that allows it to make a saving throw to take only half damage, it instead takes no damage if it succeeds on the saving throw, and only half damage if it fails.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('8d8df994-c416-46ed-b379-2d37bec7692a', 'Thadow Stealth', 'Tncrase the monster''s effective AC by 4', 'Thile in dim light or darkness, the monster can take the Hide action as a bonus action.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('dd08fff3-a64f-4275-9dd4-2de7ddc12032', 'Tncorporeal Movement', NULL, 'The monster can move through other creatures and objects as if they were difficult terrain. It takes 5 (1d10) force damage if it ends its turn inside an object.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('3d225974-3a90-4886-bf48-2e1b77c6279b', 'Tarry', 'Tncrease the monster''s effective AC by 1', 'The monster adds 6 to its AC against one melee attack that would hit it. To do so, the monster must see the attacker and be wield ing a melee weapon.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('dee3c8aa-ebc5-4c1e-90f5-32997fab4a3e', 'Tagic Resistance', 'Tncrease the monster''s effective AC by 2', 'The monster has advantage on saving throws against spells and other magical effects.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('a9e63834-7fd5-4f30-aee5-3630971b32c2', 'Trappler', NULL, 'The monster has advantage on attack rolls against any creature grappled by it.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('ef601ddf-5f61-4ca6-9f0e-379d62e6e34f', 'Tllusory Appearance', NULL, 'The monster covers itself and anything it is wearing or carrying with a magical illusion that makes her look like another creature of its general size and humanoid shape. The illusion ends if the hag takes a bonus action to end it or if it dies. The changes wrought by this effect fail to hold up to physical inspection. For example, the monster could appear to have smooth skin, but someone touching it would feel its rough flesh. Otherwise, a creature must take an action to visually inspect the illusion and succeed on a DC 20 Intelligence (Investigation) check to discern that the monster is disguised.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('dac1b195-5610-4dd0-90b9-3bfcc211dfb5', 'Tharge', 'Tncrease the monster''s damage on one attack by the amount noted in the trait', 'Tf the monster moves at least 30 feet straight toward a target and then hits it with a weapon attack on the same turn, the target takes an extra amount of damage.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('aa11d1bb-5086-4d27-90da-3ce6080249e8', 'Teen Senses', NULL, 'The monster has advantage on Wisdom (Perception) checks that rely on the chosen sense.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('8fe76edc-d704-4d65-aaf5-3d1138505a1d', 'Tlood Frenzy', 'Tncrease the monster''s effective attack bonus by 4', 'The monster has advantage on melee attack rolls against any creature that doesn''t have all its hit points.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('77b29aac-f4e4-49d1-8d61-3e7ee20e052f', 'Terrain Camouflage', NULL, 'The monster has advantage on Dexterity (Stealth) checks made to hide in native terrain.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('e4da0ca8-31fd-4279-8436-3ea5442a5a14', 'Tntimagic Susceptibility', NULL, 'The monster is incapacitated while in the area of an anti-magic field. If targeted by dispel magic, the monster must succeed on a Constitution saving throw against the caster''s spell save DC or fall unconscious for 1 minute.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('53c75262-a6ea-4071-8e4f-3efe7c92c750', 'Teb', 'Tncrease the monster''s effective AC by 1', 'Techarge 5-6. Ranged Weapon Attack: +5 to hit, range 30 ft. to 60 ft., one creature. Hit: The target is restrained by webbing. As an action, the restrained target can make a Strength check, bursting the webbing on a success. The webbing can also be attacked and destroyed (AC 10; hp 5; vulnerability to fire damage; immunity to bludgeoning, poison, and psychic damage).');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('cfff9e9d-4816-4edc-a2d2-3f3cec7d4196', 'Teactive ', NULL, 'The monster can take one reaction on every turn in a combat.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('41670e84-80eb-46c7-864a-44da8b87cc24', 'Tonstrict', 'Tncrease the monster''s effective AC by 1', 'Telee weapon attack, reach 5 ft., one creature the same size or smaller as the monster. The target is grappled if the monster isn''t already constricting a creature, and the target is restrained until this grapple ends.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('0a29f9dc-4b01-4902-8735-45701246a2d5', 'Tife Drain', NULL, 'The target must succeed on a Constitution saving throw or its hit point maximum is reduced by an amount equal to the damage taken. This reduction lasts until the target finishes a long rest. The target dies if this effect reduces its hit point maximum to 0. A humanoid slain by this attack rises 24 hours later as a zombie under the monster''s control, unless the humanoid is restored to life or its body is destroyed. The monster can have no more than twelve zombies under its control at one time.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('8e767ae1-2d4c-496b-b34d-465957ad2d16', 'Telentless', 'Tncrease the monster''s effective hit points based on the expected challenge rating: 1-4, 7 hp; 5-10, 14 hp; 11-16, 21 hp; 17 or higher, 28 hp', 'Tf the monster takes 14 damage or less that would reduce it to 0 hit points, it is reduced to 1 hit point instead.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('05752c2d-a1b4-4fa5-a8b5-47331efcaaff', 'Tiege Monster', NULL, 'The monster deals double damage to objects and structures.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('692e456a-ea87-4e32-abd9-4872580dcc7f', 'Tegendary Resistance', 'Tach per-day use of this trait increases the monster''s effective hit points based on the expected challenge rating: 1-4, 10 hp; 5-10, 20 hp; 11 or higher, 30 hp', 'Tf the monster fails a saving throw, it can choose to succeed instead.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('7735f1e6-cadd-480b-909d-4a5efab4fc73', 'Treath Weapon', 'Tor the purpose of determining effective damage output, assume the breath weapon hits two targets and that each target fails its saving throw', 'Taries');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('ab344948-f5f7-45cd-aefc-4b52a50e74e4', 'Tartial Advantage', 'Tncrease the effective damage of one attack per round by the amount gained from this trait', 'Tnce per turn, the monster can deal an extra 10 (3d6) damage to a creature it hits with a weapon attack if that creature is with in 5 feet of an ally of the monster that isn''t incapacitated.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('4d877060-ef5c-489c-b8bc-4d9cce46672a', 'Tharm', NULL, 'The monster targets one humanoid it can see within 30 feet of it. If the target can see the monster, the target must succeed on a Wisdom saving throw against this magic or be charmed by the monster. The charmed target regards the monster as a trusted friend to be heeded and protected. Although the target isn''t under the monster''s control, it takes the monster''s requests or actions in the most favorable way it can, and it is a willing target for some attacks. Each time the monster or the monster''s companions do anything harmful to the target, it can repeat the saving throw, ending the effect on itself on a success. Otherwise, the effect lasts 24 hours or until the monster is destroyed , is on a different plane of existence than the target, or takes a bonus action to end the effect.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('d647388b-3ea2-43df-a3f8-50a4083475a5', 'Teckless', NULL, 'Tt the start of its turn, the monster can gain advantage on all melee weapon attack rolls it makes during that turn, but attack rolls against it have advantage until the start of its next turn.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('6551d320-d66c-4518-aadb-522ee9ae5b05', 'Tounce', 'Tncrease the monster''s effective damage for 1 round by the amount it deals with the bonus action gained from this trait', 'Tf the monster moves at least 30 feet straight toward a creature and then hits it with a hand attack on the same turn, that target must succeed on a Strength saving throw or be knocked prone. If the target is prone, the monster can make one bite attack against it as a bonus action.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('a03e4d67-cd3e-4dc7-874c-5660894161b7', 'Tuperior Invisibility', 'Tncrease the monster''s effective AC by 2', 'Ts a bonus action, the monster can magically turn invisible until its concentration ends (as if concentrating on a spell). Any equipment the monster wears or carries is invisible with it.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('14bc11f9-12e6-4766-8d97-56adabf29264', 'Tamage Transfer', 'Touble the monster''s effective hit points. Add one-third of the monster''s hit points to its per-round damage', 'Thile attached to a creature, the monster takes only half the damage dealt to it (rounded down) and that creature takes the other half.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('bd26b280-292e-45fa-b510-5805b737a09b', 'Tey Ancestry', NULL, 'The monster has advantage on saving throws against being charmed, and magic can''t put the monster to sleep');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('df21a834-ae4d-4417-89d4-5998cbd5b02f', 'Turn Resistance', NULL, 'The monster has advantage on saving throws against any effect that turns undead.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('7a4f4298-a4da-4800-8c58-65d712a0476b', 'Tlippery', NULL, 'The monster has advantage on ability checks and saving throws made to escape a grapple.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('60e16183-52be-4174-85c3-6d28ac271e17', 'Tamage Absorption', NULL, 'Thenever the monster is subjected to elemental or other damage, it takes no damage and instead regains a number of hit poin ts equal to the damage damage dealt');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('4b03c5c0-fc6e-4dde-a57d-6d8bd1111a1b', 'Tlyby', NULL, 'The monster doesn''t provoke an opportunity attack when it flies out of an enemy''s reach.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('2ef2cca7-7570-4091-9538-70519a13a7c9', 'Two Heads', NULL, 'The monster has advantage on Wisdom (Perception) checks and on saving throws against being blinded, charmed, deafened, frightened, stunned, and knocked unconscious.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('ca21462d-5e3e-4e21-be3c-71812ff616c4', 'Teath Burst', 'Tncrease the monster''s effective damage output for 1 round by the amount noted in the trait and assume it affects two creatures', 'Then the monster dies, it explodes in a burst. Each creature within 10 feet of it must make a DC 11 Dexterity saving throw, taking damage on a failed save, or half as much damage on a successful one. ');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('b16f22d1-2de4-4b02-860a-727540411fd2', 'Tegeneration', 'Tncrease the monster''s effective hit points by 3x the number of hit points the monster regenerates each round', 'The monster regains 10 hit points at the start of its turn if it has at least 1 hit point');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('52196e12-ae94-4629-be26-7305665a8e5d', 'Turprise Attack', 'Tncrease the monster''s effective damage for 1 round by the amount noted in the trait', 'Tf the monster surprises a creature and hits it with an attack during the first round of combat, the target takes extra damage from the attack.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('45014478-4fff-4894-b31a-74c6b75d1f1a', 'Teel', NULL, 'The monster pulls each creature grappled by it up to 25 feet straight toward it.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('59c09360-9d7e-4efb-9d38-775d78dbbeca', 'Tlind Senses', NULL, 'The monster can sense without the usual equipment to do so.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('7d8b1451-3dcc-4e70-b62c-7fa2939ec6af', 'Tteadfast', NULL, 'The monster can''t be frightened while it can see an allied creature within 30 feet of it.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('f8b2232e-a35e-40d3-8b74-866e0548a78d', 'Tllumination', NULL, 'The monster emits either dim light in a 15-foot radius, or bright light in a 15-foot radius and dim light for an additionnal 15 feet. It can switch between the options as an action');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('f339534d-a4eb-4cc6-822a-87cd84940df8', 'Trute', 'Tncrease the monster''s effective per-round damage by the amount noted in the trait', 'T melee weapon deals one extra die of its damage when the monster hits with it.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('a4183c7a-9266-4272-a796-89c20091f71e', 'Tmbusher', 'Tncrease the monster''s effective attack bonus by 1', 'The monster has advantage on attack rolls against any creature it has surprised.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('4d68fb24-bcb5-4835-9e9a-8d64edee4f28', 'Tcholocation', NULL, 'Tounts as blindsight, but the monster can''t use its blindsight while deafened.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('a8d05a66-3ccb-46b2-8951-8f6514de2c59', 'Teadership', NULL, 'Tor 1 minute, the monster can utter a special command or warning whenever a nonhostile creature that it can see within 30 feet of it makes an attack roll or a saving throw. The creature can add a d4 to its roll provided it can hear and understand the monster. A creature can benefit from only one Leadership die at a time. This effect ends if the monster is incapacitated');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('cc9de9f3-7fab-4c5a-bbec-94022879c507', 'Tedirect Attack', NULL, 'Then a creature the monster can see targets it with an attack, the monster chooses an ally within 5 feet of it. The two monster swap places, and the chosen monster becomes the target instead.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('67d0180f-d0fa-473b-83dc-96584cc1b787', 'Timicry', NULL, 'The monster has advantage on attack rolls against any creature it has surprised.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('b36420e4-5472-4f84-9502-98b87d7061c1', 'Tndead Fortitude', 'Tncrease the monster''s effective hit points based on the expected challenge rating: 1-4, 7 hp; 5-10, 14 hp; 11-16, 21 hp; 17 or higher, 28 hp', 'Tf damage reduces the monster to 0 hit points, it must make a Constitution saving throw with a DC of 5 +the damage taken, unless the damage is radiant or from a critical hit. On a success, the monster drops to 1 hit point instead.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('4ef3df01-0ea5-4486-9d6a-99e74f9632e2', 'Turn Immunity', NULL, 'The monster is immune to effects that turn undead.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('dd3e8563-1977-4611-9609-9bc417a1d229', 'Tounded Fury', 'Tncrease the monster''s damager for 1 round by the amount noted in the trait', 'Thile it has 10 hit points or fewer, the monster has advantage on attack rolls. In addition, it deals extra damage to any target it hits with a melee attack.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('3a2f0349-68ce-4a71-b9df-9c6298685156', 'Tabyrinthine Recall', NULL, 'The monster can perfectly recall any path it has traveled.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('b0687cb4-c034-4aa3-be07-9c6f677cb800', 'Thameleon Skin', NULL, 'The monster has advantage on Dexterity (Stealth) checks made to hide');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('2ec5fccc-7b7e-482a-9d82-9cc1bd165a19', 'Tnscrutable', NULL, 'The monster is immune to any effect that would sense its emotions or read its thoughts, as well as any divination spell that it refuses. Wisdom (Insight) checks made to ascertain the monster''s intentions or sincerity have disadvantage.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('75caca80-712a-4236-9ed8-9e8a7bd149d1', 'Tampage', 'Tncrase the monster effective per-round damage by 2', 'Then the monster reduces a creature to 0 hit points with a melee attack on its turn , the monster can take a bonus action to move up to half its speed and make a bite attack.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('44694480-c564-41cc-8b5c-a135d0ead9dc', 'Torrifying Visage', 'Tncrease the monster''s effective hit points by 25% if the monster is meant to face characters of 10th level or higher', 'Tach non-undead creature within 60 feet of the monster that can see her must succeed on a DC 13 Wisdom saving throw or be frightened for 1 minute. A frightened target can repeat the saving throw at the end of each of its turns, with disadvantage if the monster is within line of sight, ending the effect on itself on a success. If a target''s saving throw is successful or the effect ends for it, the target is immune to the monster''s Horrifying Visage for the next 24 hours.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('e2a75718-ccfd-4977-9aa6-a13a844523f2', 'Timble Escape', 'Tncrease the monster''s effective AC and effective attack bonus by 4 ( assuming the monster hits every round)', 'The monster can take the Disengage or Hide action as a bonus action on each of its turns.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('d437df8b-c4f0-4e8f-a26d-a921643c8382', 'Ture-Footed', NULL, 'The monster has advantage on Strength and Dexterity saving throws made against effects that would knock it prone.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('f4e738d8-1d85-4990-909b-ac68dbb4d3dd', 'Trightful Presence', 'Tncrease the monster''s effective hit points by 25% if the monster is meant to face characters of 10th level or higher', 'Tach creature of the monster''s choice that is within 120 feet of the monster and aware of it must succeed on a DC 18 Wisdom saving throw or become frightened for 1 minute. A creature can repeat the saving throw at the end of each of its turns, ending the effect on itself on a success. If a creature''s saving throw is successful or the effect ends for it, the creature is immune to the monster''s Frightful Presence for the next 24 hours.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('0ffb37a5-fcab-4c7c-a055-b2b000baa96e', 'Tnvisibility', NULL, 'The monster magically turns invisible until it attacks or uses offensive abilities or until its concentration ends (as if concentrating on a spell) . Any equipment the monster wears or carries is invisible with it');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('9d6b0cee-6b35-4c12-81cd-b2ca7a924c49', 'Tsychic Defense', 'Tpply the monster''s Wisdom modifier to its actual AC if the monsterits wearing armor or wielding a shield', 'Thile the monster is wearing no armor and wielding no shield , its AC includes its Wisdom modifier.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('fd5efee9-f5f4-47be-a8f3-b781fefcc65b', 'Talse Appearance', NULL, 'Thile the monster remains motion less, it is indistinguishable from an inanimate statue.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('2bcbcaaa-1fb1-466c-9105-ba55d4d35da3', 'Ttherealness', NULL, 'The monster enters the Ethereal Plane from the Material Plane, or vice versa. It is visible on the Material Plane while it is in the Border Ethereal, and viae versa, yet it can''t affect or be affected by anything on the other plane.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('d11940bb-c202-4625-95a8-bd37ca4b17d8', 'Tossession', 'Touble the monster''s effective hit points.', 'Techarge 6. One humanoid that the monster can see within 5 feet of it must succeed on a Charisma saving throw or be possessed by the monster; the monster then disappears, and the target is incapacitated and loses control of its body. The monster now controls the body but doesn''t deprive the target of awareness. The monster can''t be targeted by any attack, spell, or other effect, except ones that turn undead, and it retains its alignment, Intelligence, Wisdom, Charisma, and immunities and resistances. It otherwise uses the possessed target''s statistics, but doesn''t gain access to the target''s knowledge, class features, or proficiencies. The possession lasts until the body drops to 0 hit points, the monster ends it as a bonus action, or the monster is turned or forced out by an effect like the dispel evil and good spell. When the possession ends, the monster reappears in an unoccupied space within 5 feet of the body. The target is immune to this monster''s Possession for 24 hours after succeeding on the saving throw or after the possession ends.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('9976567f-01c1-4a16-ae3a-c0fbe7c180de', 'Twallow ', 'Tssume the monster swallows one creature and deals 2 rounds of acid damage to it', 'The monster makes one bite attack against a Medium or smaller target it is grappling. If the attack hits, the target is also swallowed, and the grapple ends. While swallowed, the target is blinded and restrained, it has total cover against attacks and other effects outside the behir, and it takes acid damage at the start of each of the monster''s turns. A monster can have only one creature swallowed at a time. If the monster takes 30 damage or more on a single turn from the swallowed creature, the monster must succeed on a Constitution saving throw at the end of that turn or regurgitate the creature, which falls prone in a space within 10 feet of the monster. If the monster dies, a swallowed creature is no longer restrained by it and can escape from the corpse by using 15 feet of movement, exiting prone.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('adf9c94b-d914-4a8f-807d-c10cb584ad21', 'Told Breath ', NULL, 'The monster can hold its breath for 15 minutes');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('bc70adbb-f678-4a5c-8a19-c31b749f84bd', 'Thapechanger', NULL, 'The monster can use its action to polymorph into a beast form that resembles a bat (speed 10ft. fly 40ft.), a centipede (40ft., climb 40ft.), or a toad (40ft., swi m 40ft.), or back into its true form. Its statistics are the same in each form, except for the speed changes noted. Any equipment it is wearing or carrying transforms along with it.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('149fb57a-07a6-43bd-bd23-c77245c1a7f8', 'Tead Thoughts', NULL, 'The monster magically reads the surface thoughts of one creature within 60 feet of it. The effect can penetrate barriers, but 3 feet of wood or dirt, 2 feet of stone, 2 inches of metal, or a thin layer of lead blocks it. While the target is in range, the monster can continue reading its thoughts, as long as the monster''s concentration isn''t broken (as if concentrating on a spell). While reading the target''s mind, the monster has advantage on Wisdom (Insight) and Charisma (Deception, Intimidation, and Persuasion) checks against the target.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('5d87e207-2f3a-49f4-b995-ca3dd00193cf', 'Tmorphous', NULL, 'The monster can move through a space as narrow as 1 inch wide without squeezing.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('04889176-5ade-4562-82e2-cb65c31857fa', 'Tunlight Sensitivity', NULL, 'Thile in sunlight, the monster has disadvantage on attack rolls, as well as on Wisdom (Perception) checks that rely on sight.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('b8c9215f-835e-40d9-8fd2-d0c829c0b8c6', 'Tack Tactics', 'Tncrease the monster''s effective attack bonus by 1', 'The monster has advantage on an attack roll against a creature if at least one of the monster''s allies is within 5 feet of the creature and the ally isn''t incapacitated.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('6d3a40c1-020a-4a18-bb9a-d4afe7450e2c', 'Tiendish Blessing', 'Tpply the monster''s Charisma modifier to its actual AC', 'The AC of the monster includes its Charisma bonus');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('6fc90019-918f-40da-a35d-dbb820fe10c8', 'Ttench', 'Tncrease the monster''s effective AC by 1', 'Tny creature that starts its turn within 10 feet of the monster must succeed on a Constitution saving throw or be poisoned until the start of its next turn. On a successful saving throw, the creature is immune to the monster''s stench for 24 hours');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('d68056ce-3ce5-420d-8b4c-de862e865522', 'Tight Sensitivity', NULL, 'Thile in bright light, the monster has disadvantage on attack rolls, as well as on Wisdom (Perception) checks that rely on sight.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('e60a08c9-e1ca-4bbc-9660-dee6757a8e7f', 'Teb Walker', NULL, 'The monster ignores movement restrictions caused by webbing.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('4951cd97-c003-4bec-9624-df41a051ad82', 'Tagic Weapons', NULL, 'The monster''s weapons are magical');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('95810ae3-50ab-4b32-abd0-e8f5447143b7', 'Tggressive', 'Tncrease the monster''s effective per-round damage output by 2', 'Ts a bonus action, the monster can move up to its speed toward a hostile creature that it can see.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('d95de4d6-0343-4502-aae2-e94d9c5846d3', 'Tnlarge', 'Tncrease the monster''s effective per-round damage by the amount noted in the trait', 'Techarges after a Short or Long Rest. For 1 minute, the monster magically increases in size, along with anything it is wearing or carrying. While enlarged, the monster is Large, doubles its damage dice on Strength-based weapon attacks, and makes Strength checks and Strength saving throws with advantage. If the monster lacks the room to become Large, it attains the maximum size possible in the space available .');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('599f94ac-6f75-454e-9a66-ea8f5385825d', 'Teleport', NULL, 'The monster magically teleports, along with any equipment it is wearing or carrying, up to 120 feet to an unoccupied space it can see.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('de814fa5-9616-40b8-8e1f-eb3e503aff0a', 'Tmmutable Form', NULL, 'The monster is immune to any spell or effect that would alter its form.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('770dd8f1-e33e-4700-ad8a-ebbf0494dd6c', 'Tngelic Weapons', 'Tncrease the monster''s effective per-round damage by the amount noted in the trait', 'The monster''s weapon attacks are magical. When the monster hits with any weapon, the weapon deals an extra amount of damage.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('98bb740b-c6cf-4de0-9213-f45f6aff247a', 'Tive', 'Tncrease the monster''s effective per-round damage by the amount noted in the trait', 'Tf the monster is flying and dives at least 30 feet straight toward a target and then hits it with a melee weapon attack, the attack deals extra damage to the target.');
INSERT INTO feature_lu_feature (guid_feature, name_feature, stat_modifier, description_feature) VALUES ('2b6271d3-fbaa-45bf-9838-fa138e9097f5', 'Tpider Climb', NULL, 'The monster can climb difficult surfaces, including upside down on ceilings, without needing to make an ability check.');


--
-- TOC entry 3159 (class 0 OID 24995)
-- Dependencies: 221
-- Data for Name: feature_rl_monster_feature; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3160 (class 0 OID 25000)
-- Dependencies: 222
-- Data for Name: hp_protection_cr_modifier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '6798d7f1-d779-437c-9c99-000031c5d30c', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '6798d7f1-d779-437c-9c99-000031c5d30c', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, 'f6d26cd6-f212-452b-a6f4-033cd3525d49', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, 'f6d26cd6-f212-452b-a6f4-033cd3525d49', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '8bb60024-59fa-46e0-921e-05f60dd26cdb', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '8bb60024-59fa-46e0-921e-05f60dd26cdb', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, 'b5f9abae-8b6e-43d0-b3c1-08b23907121a', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, 'b5f9abae-8b6e-43d0-b3c1-08b23907121a', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, 'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, 'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, 'b997bbc4-0aed-4a32-acab-166134369f47', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, 'b997bbc4-0aed-4a32-acab-166134369f47', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, 'ac3179be-938e-4819-9098-2106abdbb429', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, 'ac3179be-938e-4819-9098-2106abdbb429', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '7faff7cc-8691-4b27-ae01-2606bafba93f', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '7faff7cc-8691-4b27-ae01-2606bafba93f', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, 'e58ab5bd-f7be-4989-bfd0-26840cf218f7', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, 'e58ab5bd-f7be-4989-bfd0-26840cf218f7', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, 'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, 'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, 'a0e4ee68-87f0-433c-bfa6-2c834b382119', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, 'a0e4ee68-87f0-433c-bfa6-2c834b382119', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '9c3c55bc-5044-46e4-9bc4-3d2ebe317430', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '9c3c55bc-5044-46e4-9bc4-3d2ebe317430', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '6558423c-eb07-48dc-a694-3efdc36be41d', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '6558423c-eb07-48dc-a694-3efdc36be41d', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '32a77e7d-ade9-4461-8941-421809e379fc', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '32a77e7d-ade9-4461-8941-421809e379fc', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, 'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, 'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '584e036f-f640-4e76-937a-57fb7c9aad41', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '584e036f-f640-4e76-937a-57fb7c9aad41', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '4fbabffc-b152-43cc-b361-5b03cb53c60d', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '4fbabffc-b152-43cc-b361-5b03cb53c60d', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '902e442e-5ac7-411a-9f77-6b8a12e58cdf', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '902e442e-5ac7-411a-9f77-6b8a12e58cdf', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '7a06f521-598d-4736-9c7f-6e4d87c77a05', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '7a06f521-598d-4736-9c7f-6e4d87c77a05', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '8caf6098-94d8-4d25-a19f-6edc5131d168', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '8caf6098-94d8-4d25-a19f-6edc5131d168', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '27de4a7f-8762-41d8-b6b9-6f1f1902de74', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '27de4a7f-8762-41d8-b6b9-6f1f1902de74', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '9bc8da1e-a396-46ae-8884-758b0676c05a', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '9bc8da1e-a396-46ae-8884-758b0676c05a', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, 'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, 'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '2bd93716-3342-4160-891f-8cdbebdf885e', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '2bd93716-3342-4160-891f-8cdbebdf885e', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, 'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, 'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1, '22e2f0ce-c357-4d4f-8668-bf4d85b3369c', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '22e2f0ce-c357-4d4f-8668-bf4d85b3369c', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '641fa88c-f7b3-4822-9136-d174b155e193', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '641fa88c-f7b3-4822-9136-d174b155e193', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '12a0ccf5-11c7-44f4-a44f-e7729ee11bba', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '12a0ccf5-11c7-44f4-a44f-e7729ee11bba', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '54d4a58f-d22d-4c49-b16c-f40979f55207', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '54d4a58f-d22d-4c49-b16c-f40979f55207', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '7205de9d-e02b-4c83-bbc0-f6ede21434f6', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '7205de9d-e02b-4c83-bbc0-f6ede21434f6', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.25, '864ed2cf-5aea-45a7-add2-f7228ea1e3f3', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (1.5, '864ed2cf-5aea-45a7-add2-f7228ea1e3f3', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '2a7b6a97-4784-452f-936e-ff44d2cbc3ba', '2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6');
INSERT INTO hp_protection_cr_modifier (effective_hpmodifier, guid_cr, guid_protection) VALUES (2, '2a7b6a97-4784-452f-936e-ff44d2cbc3ba', '78bc70a4-f0c3-4c6a-8745-b2b054099ce8');


--
-- TOC entry 3161 (class 0 OID 25005)
-- Dependencies: 223
-- Data for Name: mon_lu_goodness; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO mon_lu_goodness (guid_goodness, name_morality) VALUES ('50cc979c-1442-4938-8e35-2ec30adde6b4', 'Teutral');
INSERT INTO mon_lu_goodness (guid_goodness, name_morality) VALUES ('800eb61f-dde0-495f-bc95-d334328d1a82', 'Tvil');
INSERT INTO mon_lu_goodness (guid_goodness, name_morality) VALUES ('8c71e0af-ba6a-4cd2-8769-f9288233252a', 'Tood');


--
-- TOC entry 3162 (class 0 OID 25010)
-- Dependencies: 224
-- Data for Name: mon_lu_lawfulness; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO mon_lu_lawfulness (guid_lawfulness, name_lawfulness) VALUES ('464e7a1f-f891-4816-9924-0eba5980e544', 'Tawful');
INSERT INTO mon_lu_lawfulness (guid_lawfulness, name_lawfulness) VALUES ('b55bfef1-aa91-42a1-86fe-6ede3a698a85', 'Teutral');
INSERT INTO mon_lu_lawfulness (guid_lawfulness, name_lawfulness) VALUES ('d0f4ae17-7ae8-4ca7-9226-7096b3f63110', 'Thaotic');


--
-- TOC entry 3163 (class 0 OID 25018)
-- Dependencies: 225
-- Data for Name: mon_lu_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('68b1298e-1aab-43ec-aeb9-0ca086735378', 'Tumanoid');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('c35a5d91-705e-4454-a4a1-1cd9d2fc49e2', 'Tlemental');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('0f2028ab-892e-42c4-b1e6-232ce584ac88', 'Tberration');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('edb50140-b3f7-4ee9-9219-43b23e027b38', 'Tiant');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('102e0311-6789-44b5-9540-682c3fe23f7e', 'Telestial');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('a18d12fa-ac21-4a2a-b263-71b5d24d13a2', 'Teast');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('75b43273-854c-47e0-b0ab-746ad75ba08e', 'Tndead');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('ccb2668c-28d4-4692-b8d2-8324a0e2f60b', 'Tiend');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('f77010b5-9608-46e8-bdb6-83b84829e80f', 'Tlant');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('6f4567af-dafc-44f3-b6e0-86669a5303f5', 'Tragon');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('29b80bad-aef0-43f1-baae-8e76849f42c9', 'Tey');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('e9bfa601-598d-4fcf-b502-91f0b284a994', 'Toze');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('fcba4d7b-bc4f-4f59-950d-a06868362f64', 'Tonstrosity');
INSERT INTO mon_lu_type (guid_type, name_type) VALUES ('706b76b8-a5f8-44d4-a93d-fcf92d1ded7d', 'Tonstruct');


--
-- TOC entry 3164 (class 0 OID 25023)
-- Dependencies: 226
-- Data for Name: mon_monster; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3165 (class 0 OID 25031)
-- Dependencies: 227
-- Data for Name: mon_rl_alignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('a2be9be6-b848-4981-b3ee-12ba0ed18baf', 'Tawful Evil', '464e7a1f-f891-4816-9924-0eba5980e544', '800eb61f-dde0-495f-bc95-d334328d1a82');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('5a88c224-a341-470a-a14c-29be5b0b086b', 'Teutral Good', 'b55bfef1-aa91-42a1-86fe-6ede3a698a85', '8c71e0af-ba6a-4cd2-8769-f9288233252a');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('d7cf6701-c4aa-4317-b22e-2a15657f4617', 'Tawful Good', '464e7a1f-f891-4816-9924-0eba5980e544', '8c71e0af-ba6a-4cd2-8769-f9288233252a');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('3220825c-09a1-42b7-baed-3157392c5248', 'True Neutral', 'b55bfef1-aa91-42a1-86fe-6ede3a698a85', '50cc979c-1442-4938-8e35-2ec30adde6b4');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('4ce16b80-7f50-4385-af3a-6433fbcee5bc', 'Thaotic Evil', 'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', '800eb61f-dde0-495f-bc95-d334328d1a82');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('3f25ee9f-9cb3-4f1b-a8fc-a315ebda648b', 'Thaotic Good', 'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', '8c71e0af-ba6a-4cd2-8769-f9288233252a');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('892edc67-d60d-4906-ae68-cbd01d293cae', 'Thaotic Neutral', 'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', '50cc979c-1442-4938-8e35-2ec30adde6b4');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('cff1fee0-17fc-4826-92ef-d3a1553287a8', 'Tawful Neutral', '464e7a1f-f891-4816-9924-0eba5980e544', '50cc979c-1442-4938-8e35-2ec30adde6b4');
INSERT INTO mon_rl_alignment (guid_alignment, name_alignment, guid_lawfulness, guid_goodness) VALUES ('c57508b3-8ef1-4d70-b85f-d96367874094', 'Teutral Evil', 'b55bfef1-aa91-42a1-86fe-6ede3a698a85', '800eb61f-dde0-495f-bc95-d334328d1a82');


--
-- TOC entry 3166 (class 0 OID 25036)
-- Dependencies: 228
-- Data for Name: mon_rl_monster_armor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3167 (class 0 OID 25041)
-- Dependencies: 229
-- Data for Name: mon_rl_monster_movement; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3168 (class 0 OID 25046)
-- Dependencies: 230
-- Data for Name: mon_rl_monster_senses; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3169 (class 0 OID 25051)
-- Dependencies: 231
-- Data for Name: mon_rl_monster_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3170 (class 0 OID 25056)
-- Dependencies: 232
-- Data for Name: mon_rl_monster_weapon; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3171 (class 0 OID 25061)
-- Dependencies: 233
-- Data for Name: mon_rl_protection; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3173 (class 0 OID 25068)
-- Dependencies: 235
-- Data for Name: sysdiagrams; Type: TABLE DATA; Schema: public; Owner: postgres
--
*/
INSERT INTO sysdiagrams (name, principal_id, diagram_id, version, definition) VALUES ('Monster_Builder_DB_Diagram', 1, 1, 1, '\xd0cf11e0a1b11ae1000000000000000000000000000000003e000300feff0900060000000000000000000000020000000100000000000000001000007100000001000000feffffff000000000000000074000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdffffff73000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b000000feffffff1d0000001e0000001f000000200000002100000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002e0000002f000000300000003100000032000000330000003400000035000000360000003700000038000000390000003a0000003b0000003c0000003d0000003e0000003f000000400000004100000042000000430000004400000045000000460000004700000048000000490000004a0000004b0000004c0000004d0000004e0000004f000000500000005100000052000000530000005400000055000000560000005700000058000000590000005a0000005b0000005c0000005d0000005e0000005f000000600000006100000062000000630000006400000065000000660000006700000068000000690000006a0000006b0000006c0000006d0000006e0000006f00000070000000fefffffffeffffffb7000000fefffffffdffffff760000007700000078000000790000007a0000007b0000007c0000007d0000007e0000007f0000008000000052006f006f007400200045006e00740072007900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016000500ffffffffffffffff0200000000000000000000000000000000000000000000000000000000000000307509fa4a2dd30172000000800e0000000000006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000201ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000200000012330000000000006f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040002010100000004000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000001c00000053a9000000000000010043006f006d0070004f0062006a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012000201ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005f00000000000000000434000a1e500c05000080990000000f00ffff3200000099000000007d0000a16e0000da4700006b210200e62e0100243bfeff3aa3ffffde805b10f195d011b0a000aa00bdcb5c000008003000000000020000030000003c006b0000000900000000000000d9e6b0e91c81d011ad5100a0c90f5739f43b7f847f61c74385352986e1d552f8a0327db2d86295428d98273c25a2da2d00002800430000000000000053444dd2011fd1118e63006097d2df4834c9d2777977d811907000065b840d9c00002800430000000000000051444dd2011fd1118e63006097d2df4834c9d2777977d811907000065b840d9c990000001c32000000ff01009a01563f00003400a50900000700008001000000a4020000008000000900008053636847726964005254ffff8499000061726d5f41726d6f7200000000003800a50900000700008002000000b2020000008000001000008053636847726964005254ffff4cb3000061726d5f6c755f41726d6f725479706500008000a50900000700008003000000520000000180000057000080436f6e74726f6c003560ffffbea6000052656c6174696f6e736869702027464b5f61726d5f41726d6f725f61726d5f6c755f41726d6f725479706527206265747765656e202761726d5f6c755f41726d6f72547970652720616e64202761726d5f41726d6f72270000002800b50100000700008004000000310000006d00000002800000436f6e74726f6c007b62ffffb9ad000000003c00a50900000700008005000000b402000000800000110000805363684772696400a678ffffdc9b000061726d5f726c5f41434d6f64696669657200000000008400a50900000700008006000000520000000180000059000080436f6e74726f6c00f06dffff21a0000052656c6174696f6e736869702027464b5f5f61726d5f726c5f41435f5f677569645f5f5f353542464239343827206265747765656e202761726d5f41726d6f722720616e64202761726d5f726c5f41434d6f6469666965722700000000002800b50100000700008007000000310000006f00000002800000436f6e74726f6c00fd6cffff67a2000000003c00a50900000700008008000000ba020000008000001400008053636847726964005254ffff0285000061726d5f726c5f4d6f6e737465725f41726d6f7200008400a5090000070000800900000052000000018000005c000080436f6e74726f6c003560ffff9b8d000052656c6174696f6e736869702027464b5f5f61726d5f726c5f4d6f5f5f677569645f5f5f313346314635454227206265747765656e202761726d5f41726d6f722720616e64202761726d5f726c5f4d6f6e737465725f41726d6f722700002800b5010000070000800a000000310000006f00000002800000436f6e74726f6c007b62ffff4394000000003400a5090000070000800b000000a6020000008000000a00008053636847726964005254ffff8070000061726d5f536869656c64000000008800a5090000070000800c00000052000000018000005d000080436f6e74726f6c003560ffff1d79000052656c6174696f6e736869702027464b5f5f61726d5f726c5f4d6f5f5f677569645f5f5f313246444431423227206265747765656e202761726d5f536869656c642720616e64202761726d5f726c5f4d6f6e737465725f41726d6f722703000000002800b5010000070000800d000000310000006f00000002800000436f6e74726f6c00754effffc17f000000003800a5090000070000800e000000b202000000800000100000805363684772696400c4a5fffff6540000636f6d5f4162696c69747953636f726500008800a5090000070000800f000000620000000180000060000080436f6e74726f6c00a584ffff425b000052656c6174696f6e736869702027464b5f5f61726d5f726c5f41435f5f677569645f5f5f353443423935304627206265747765656e2027636f6d5f4162696c69747953636f72652720616e64202761726d5f726c5f41434d6f6469666965722700002800b50100000700008010000000310000006f00000002800000436f6e74726f6c000379ffff906b000000003000a509000007000080110000009e020000008000000600008053636847726964005084feff1a9a0000636f6d5f4352640000003400a50900000700008012000000aa020000008000000c0000805363684772696400fe2fffff34080000636f6d5f4c616e677561676500003c00a50900000700008013000000b4020000008000001100008053636847726964007a96fefff4b00000636f6d5f6c755f41726d6f72436c6173736d6f7200008000a50900000700008014000000620000000180000056000080436f6e74726f6c00c990feff07a5000052656c6174696f6e736869702027464b5f5f636f6d5f6c755f41725f5f677569645f5f5f353645384537414227206265747765656e2027636f6d5f43522720616e642027636f6d5f6c755f41726d6f72436c61737327000000002800b50100000700008015000000310000006f00000002800000436f6e74726f6c008285feff88af000000003800a50900000700008016000000b0020000008000000f0000805363684772696400400cffff0af6ffff636f6d5f6c755f4d6f76656d656e746500003800a50900000700008017000000ac020000008000000d00008053636847726964002842ffff9ccdffff636f6d5f6c755f53656e7365736e746500003400a50900000700008018000000aa020000008000000c0000805363684772696400b25dffff964b0000636f6d5f6c755f536b696c6c00004000a50900000700008019000000c2020000008000001800008053636847726964002672feffa6590000636f6d5f50726f74656374696f6e46726f6d44616d61676500004400a5090000070000801a000000ca020000008000001c0000805363684772696400c4a5ffffb42d0000636f6d5f726c5f4162696c69747953636f72655f4d6f64696669657200004400a5090000070000801b000000c4020000008000001900008053636847726964007081ffff964b0000636f6d5f726c5f4162696c69747953636f72655f536b696c6c00000000009000a5090000070000801c000000620000000180000068000080436f6e74726f6c000e9bffffcb4e000052656c6174696f6e736869702027464b5f5f636f6d5f726c5f41625f5f677569645f5f5f364344383238434127206265747765656e2027636f6d5f4162696c69747953636f72652720616e642027636f6d5f726c5f4162696c69747953636f72655f536b696c6c2700002800b5010000070000801d000000310000006f00000002800000436f6e74726f6c00a39effffdd54000000008c00a5090000070000801e000000520000000180000064000080436f6e74726f6c005077ffffaf4e000052656c6174696f6e736869702027464b5f5f636f6d5f726c5f41625f5f677569645f5f5f364443433444303327206265747765656e2027636f6d5f6c755f536b696c6c2720616e642027636f6d5f726c5f4162696c69747953636f72655f536b696c6c2700002800b5010000070000801f000000310000006f00000002800000436f6e74726f6c009773fffff550000000004400a50900000700008020000000c8020000008000001b0000805363684772696400c4a5ffffde3f0000636f6d5f726c5f4d6f6e737465725f4162696c69747953636f7265000000a000a50900000700008021000000520000000180000076000080436f6e74726f6c00a7b1ffff0034000052656c6174696f6e736869702027464b5f5f636f6d5f726c5f4d6f5f5f76616c75655f5f303738433146303627206265747765656e2027636f6d5f726c5f4162696c69747953636f72655f4d6f6469666965722720616e642027636f6d5f726c5f4d6f6e737465725f4162696c69747953636f726527000000002800b50100000700008022000000310000006f00000002800000436f6e74726f6c00ff9fffffa03a000000009400a5090000070000802300000052000000018000006a000080436f6e74726f6c00a7b1ffff7748000052656c6174696f6e736869702027464b5f5f636f6d5f726c5f4d6f5f5f677569645f5f5f303639374641434427206265747765656e2027636f6d5f4162696c69747953636f72652720616e642027636f6d5f726c5f4d6f6e737465725f4162696c69747953636f726527000000002800b50100000700008024000000310000006f00000002800000436f6e74726f6c00edb3fffffe4e000000004000a50900000700008025000000c0020000008000001700008053636847726964005254ffff60090000636f6d5f726c5f4d6f6e737465725f4c616e67756167650000008c00a50900000700008026000000520000000180000062000080436f6e74726f6c009c49ffff790c000052656c6174696f6e736869702027464b5f5f636f6d5f726c5f4d6f5f5f677569645f5f5f304632443430434527206265747765656e2027636f6d5f4c616e67756167652720616e642027636f6d5f726c5f4d6f6e737465725f4c616e677561676527536b00002800b50100000700008027000000310000006f00000002800000436f6e74726f6c00a145ffffbf0e000000003000a50900000700008028000000a2020000008000000800008053636847726964007a96feff220b0000636f6d5f53697a6500004000a50900000700008029000000be02000000800000160000805363684772696400a4a8feffdc9b0000636f72655f6c755f43525f50726f66696369656e6379000000008400a5090000070000802a00000052000000018000005b000080436f6e74726f6c65ee9dfeff8b9f000052656c6174696f6e736869702027464b5f5f636f72655f6c755f435f5f677569645f5f5f354637453244414327206265747765656e2027636f6d5f43522720616e642027636f72655f6c755f43525f50726f66696369656e6379272700002800b5010000070000802b000000310000006f00000002800000436f6e74726f6c00619afeffd1a1000000004000a5090000070000802c000000c2020000008000001800008053636847726964002672fefff4b00000636f72655f6c755f446566656e736976655f56616c75657300008800a5090000070000802d00000062000000018000005d000080436f6e74726f6c00747efeff07a5000052656c6174696f6e736869702027464b5f5f636f72655f6c755f445f5f677569645f5f5f353943353534353627206265747765656e2027636f6d5f43522720616e642027636f72655f6c755f446566656e736976655f56616c7565732703000000002800b5010000070000802e000000310000006f00000002800000436f6e74726f6c65c776feffd7ac000000004000a5090000070000802f000000c20200000080000018000080536368477269640038bafeff52800000636f72655f6c755f4f6666656e736976655f56616c75657300008800a5090000070000803000000062000000018000005d000080436f6e74726f6c00c990feff1b8f000052656c6174696f6e736869702027464b5f5f636f72655f6c755f4f5f5f677569645f5f5f354341314331303127206265747765656e2027636f6d5f43522720616e642027636f72655f6c755f4f6666656e736976655f56616c7565732703000000002800b50100000700008031000000310000006f00000002800000436f6e74726f6c006badfeffae93000000003c00a50900000700008032000000b6020000008000001200008053636847726964002672feff48f4ffff637573746f6d5f41747461636b5f446963656f7200003c00a50900000700008033000000ba02000000800000140000805363684772696400d24dfeff1cf3ffff637573746f6d5f576561706f6e5f41747461636b00008c00a50900000700008034000000620000000180000063000080436f6e74726f6c007067feff85feffff52656c6174696f6e736869702027464b5f5f637573746f6d5f57655f5f677569645f5f5f363334454245393027206265747765656e2027636f6d5f4162696c69747953636f72652720616e642027637573746f6d5f576561706f6e5f41747461636b273f00002800b50100000700008035000000310000006f00000002800000436f6e74726f6c005126fffffefdffff00009000a50900000700008036000000520000000180000065000080436f6e74726f6c007067feff8df8ffff52656c6174696f6e736869702027464b5f5f637573746f6d5f41745f5f677569645f5f5f363731463446373427206265747765656e2027637573746f6d5f576561706f6e5f41747461636b2720616e642027637573746f6d5f41747461636b5f44696365276c6c2700002800b50100000700008037000000310000006f00000002800000436f6e74726f6c003c64feffd3faffff00003400a50900000700008038000000a4020000008000000900008053636847726964007a96fefff0f1ffff646963655f4469636500000000008400a5090000070000803900000052000000018000005a000080436f6e74726f6c00c48bfeff8df8ffff52656c6174696f6e736869702027464b5f5f637573746f6d5f41745f5f677569645f5f5f363632423242334227206265747765656e2027646963655f446963652720616e642027637573746f6d5f41747461636b5f4469636527000000002800b5010000070000803a000000310000006f00000002800000436f6e74726f6c009088feff22f8ffff00007800a5090000070000803b000000520000000180000050000080436f6e74726f6c005da2feff2effffff52656c6174696f6e736869702027464b5f5f636f6d5f53697a655f5f677569645f445f5f363946424243314627206265747765656e2027646963655f446963652720616e642027636f6d5f53697a652700002800b5010000070000803c000000310000006f00000002800000436f6e74726f6c009d90feffb806000000003c00a5090000070000803d000000b6020000008000001200008053636847726964005254ffff72bbffff666561747572655f6c755f46656174757265636b00004400a5090000070000803e000000c6020000008000001a00008053636847726964655254ffffe2d2ffff666561747572655f726c5f4d6f6e737465725f46656174757265000000009400a5090000070000803f00000052000000018000006b000080436f6e74726f6c003560ffff5fc6ffff52656c6174696f6e736869702027464b5f5f666561747572655f725f5f677569645f5f5f304235434146454127206265747765656e2027666561747572655f6c755f466561747572652720616e642027666561747572655f726c5f4d6f6e737465725f46656174757265270000002800b50100000700008040000000310000006f00000002800000436f6e74726f6c002e4fffff53cdffff00004400a50900000700008041000000c4020000008000001900008053636847726964652672feffd06b000068705f50726f74656374696f6e5f43525f4d6f64696669657200000000008800a5090000070000804200000062000000018000005e000080436f6e74726f6c00257efeff6974000052656c6174696f6e736869702027464b5f5f68705f50726f7465635f5f677569645f5f5f343938454543384427206265747765656e2027636f6d5f43522720616e64202768705f50726f74656374696f6e5f43525f4d6f64696669657227000000002800b50100000700008043000000310000006f00000002800000436f6e74726f6c004f80feff478e000000009800a50900000700008044000000520000000180000070000080436f6e74726f6c00097efefff25f000052656c6174696f6e736869702027464b5f5f68705f50726f7465635f5f677569645f5f5f344138333130433627206265747765656e2027636f6d5f50726f74656374696f6e46726f6d44616d6167652720616e64202768705f50726f74656374696f6e5f43525f4d6f6469666965722700002800b50100000700008045000000310000006f00000002800000436f6e74726f6c00bd6cfeffce66000000003800a50900000700008046000000b0020000008000000f0000805363684772696400ece7feff0e1f00006d6f6e5f6c755f476f6f646e6573736500003c00a50900000700008047000000b402000000800000110000805363684772696400400cffff8c0a00006d6f6e5f6c755f4c617766756c6e65737300000000003400a50900000700008048000000a8020000008000000b0000805363684772696400a678ffff340800006d6f6e5f6c755f547970656e00003400a50900000700008049000000a8020000008000000b0000805363684772696400fe2fffffa2e5ffff6d6f6e5f4d6f6e737465726e00008000a5090000070000804a000000620000000180000055000080436f6e74726f6c65293dffff7df7ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f4d6f6e73745f5f677569645f5f5f303144333435423027206265747765656e20276d6f6e5f6c755f547970652720616e6420276d6f6e5f4d6f6e737465722700000000002800b5010000070000804b000000310000006f00000002800000436f6e74726f6c00f35fffff2d03000000007c00a5090000070000804c000000620000000180000052000080436f6e74726f6c0018b0feff13f8ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f4d6f6e73745f5f677569645f5f5f374645414644334527206265747765656e2027636f6d5f53697a652720616e6420276d6f6e5f4d6f6e7374657227000000002800b5010000070000804d000000310000006f00000002800000436f6e74726f6c6550f1feff87fdffff00009000a5090000070000804e000000620000000180000065000080436f6e74726f6c009c49ffffe7e9ffff52656c6174696f6e736869702027464b5f5f636f6d5f726c5f4d6f5f5f677569645f5f5f303541334436393427206265747765656e20276d6f6e5f4d6f6e737465722720616e642027636f6d5f726c5f4d6f6e737465725f4162696c69747953636f72652700000000002800b5010000070000804f000000310000006f00000002800000436f6e74726f6c00763effff1c45000000008c00a50900000700008050000000620000000180000064000080436f6e74726f6c009c49ffff17d6ffff52656c6174696f6e736869702027464b5f5f666561747572655f725f5f677569645f5f5f304136383842423127206265747765656e20276d6f6e5f4d6f6e737465722720616e642027666561747572655f726c5f4d6f6e737465725f466561747572652700002800b50100000700008051000000310000006f00000002800000436f6e74726f6c009352ffffcddfffff00008c00a50900000700008052000000620000000180000061000080436f6e74726f6c004b3bffff81f7ffff52656c6174696f6e736869702027464b5f5f636f6d5f726c5f4d6f5f5f677569645f5f5f304533393143393527206265747765656e20276d6f6e5f4d6f6e737465722720616e642027636f6d5f726c5f4d6f6e737465725f4c616e67756167652700000000002800b50100000700008053000000310000006f00000002800000436f6e74726f6c007839ffff9206000000008800a5090000070000805400000062000000018000005e000080436f6e74726f6c009c49ffff6bedffff52656c6174696f6e736869702027464b5f5f61726d5f726c5f4d6f5f5f677569645f5f5f313230394144373927206265747765656e20276d6f6e5f4d6f6e737465722720616e64202761726d5f726c5f4d6f6e737465725f41726d6f7227000000002800b50100000700008055000000310000006f00000002800000436f6e74726f6c00253dfffffe3f000000007800a50900000700008056000000620000000180000050000080436f6e74726f6c00819cfeff7df7ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f4d6f6e73745f5f677569645f5f5f303243373639453927206265747765656e2027636f6d5f43522720616e6420276d6f6e5f4d6f6e737465722700002800b50100000700008057000000310000006f00000002800000436f6e74726f6c0025eefeffd84a000000003800a50900000700008058000000b202000000800000100000805363684772696465867bfeff8c0a00006d6f6e5f726c5f416c69676e6d656e7400008400a5090000070000805900000062000000018000005a000080436f6e74726f6c002495feff13f8ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f4d6f6e73745f5f677569645f5f5f303044463231373727206265747765656e20276d6f6e5f726c5f416c69676e6d656e742720616e6420276d6f6e5f4d6f6e7374657227000000002800b5010000070000805a000000310000006f00000002800000436f6e74726f6c00d6e3feff5101000000008800a5090000070000805b000000520000000180000060000080436f6e74726f6c002495feff8b09000052656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f416c5f5f677569645f5f5f323733394434383927206265747765656e20276d6f6e5f6c755f4c617766756c6e6573732720616e6420276d6f6e5f726c5f416c69676e6d656e742700002800b5010000070000805c000000310000006f00000002800000436f6e74726f6c002ec8feff2009000000008800a5090000070000805d00000062000000018000005e000080436f6e74726f6c002495fefff515000052656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f416c5f5f677569645f5f5f323832444638433227206265747765656e20276d6f6e5f6c755f476f6f646e6573732720616e6420276d6f6e5f726c5f416c69676e6d656e7427742700002800b5010000070000805e000000310000006f00000002800000436f6e74726f6c00d8bafeff6e15000000004000a5090000070000805f000000c002000000800000170000805363684772696400b4b6feffc8ceffff6d6f6e5f726c5f4d6f6e737465725f4d6f76656d656e740000009000a50900000700008060000000620000000180000065000080436f6e74726f6c0052d0feffd9d7ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f314136394539353027206265747765656e2027636f6d5f6c755f4d6f76656d656e742720616e6420276d6f6e5f726c5f4d6f6e737465725f4d6f76656d656e74276c6c2700002800b50100000700008061000000310000006f00000002800000436f6e74726f6c658eeffeff36e4ffff00008c00a50900000700008062000000620000000180000061000080436f6e74726f6c0052d0feffd9d7ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f313937354335313727206265747765656e20276d6f6e5f4d6f6e737465722720616e6420276d6f6e5f726c5f4d6f6e737465725f4d6f76656d656e7427006e0000002800b50100000700008063000000310000006f00000002800000436f6e74726f6c006d01ffffc4ddffff00004000a50900000700008064000000bc020000008000001500008053636847726964005821ffffc2b6ffff6d6f6e5f726c5f4d6f6e737465725f53656e7365730d000000008c00a509000007000080650000005a0000000180000061000080436f6e74726f6c00a539ffff5bbfffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f313639393538364327206265747765656e2027636f6d5f6c755f53656e7365732720616e6420276d6f6e5f726c5f4d6f6e737465725f53656e736573276f726500002800b50100000700008066000000310000006f00000002800000436f6e74726f6c00cf3bffffc1c9ffff00008800a5090000070000806700000062000000018000005f000080436f6e74726f6c00572dffff5bbfffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f313541353334333327206265747765656e20276d6f6e5f4d6f6e737465722720616e6420276d6f6e5f726c5f4d6f6e737465725f53656e736573272700002800b50100000700008068000000310000006f00000002800000436f6e74726f6c006d31ffff41d7ffff00003c00a50900000700008069000000ba02000000800000140000805363684772696400b25dffffc05d00006d6f6e5f726c5f4d6f6e737465725f536b696c6c00008800a5090000070000806a00000052000000018000005f000080436f6e74726f6c009569ffffe251000052656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f323035374343443027206265747765656e2027636f6d5f6c755f536b696c6c2720616e6420276d6f6e5f726c5f4d6f6e737465725f536b696c6c272700002800b5010000070000806b000000310000006f00000002800000436f6e74726f6c009057ffffaa58000000008800a5090000070000806c00000062000000018000005e000080436f6e74726f6c009c49ffffa9ebffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f314636334138393727206265747765656e20276d6f6e5f4d6f6e737465722720616e6420276d6f6e5f726c5f4d6f6e737465725f536b696c6c27000000002800b5010000070000806d000000310000006f00000002800000436f6e74726f6c00c23dffff1344000000004000a5090000070000806e000000bc02000000800000150000805363684772696400a4a8feff0e1f00006d6f6e5f726c5f4d6f6e737465725f576561706f6e61676500008800a5090000070000806f00000062000000018000005f000080436f6e74726f6c002dc2fefff7f7ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f314239333137423327206265747765656e20276d6f6e5f4d6f6e737465722720616e6420276d6f6e5f726c5f4d6f6e737465725f576561706f6e270000002800b50100000700008070000000310000006f00000002800000436f6e74726f6c00a5e0feffa21d000000003c00a50900000700008071000000b4020000008000001100008053636847726964002672feff8e4400006d6f6e5f726c5f50726f74656374696f6e5af01e00009000a50900000700008072000000520000000180000068000080436f6e74726f6c00097efeff274d000052656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f50725f5f677569645f5f5f313842364142303827206265747765656e2027636f6d5f50726f74656374696f6e46726f6d44616d6167652720616e6420276d6f6e5f726c5f50726f74656374696f6e2700002800b50100000700008073000000310000006f00000002800000436f6e74726f6c004f80feffef53000000008400a5090000070000807400000062000000018000005b000080436f6e74726f6c00c48bfefff7f7ffff52656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f50725f5f677569645f5f5f313743323836434627206265747765656e20276d6f6e5f4d6f6e737465722720616e6420276d6f6e5f726c5f50726f74656374696f6e270000002800b50100000700008075000000310000006f00000002800000436f6e74726f6c0066cbfeff5c3c000000003800a50900000700008076000000b0020000008000000f0000805363684772696400f2fffeff8cbfffff54454d505f4d6f6e737465725f43526500003c00a50900000700008077000000b6020000008000001200008053636847726964002672feff64320000776561705f6c755f44616d61676554797065000000008c00a50900000700008078000000520000000180000062000080436f6e74726f6c00097efeffb038000052656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f50725f5f677569645f5f5f313643453632393627206265747765656e2027776561705f6c755f44616d616765547970652720616e6420276d6f6e5f726c5f50726f74656374696f6e276e0000002800b50100000700008079000000310000006f00000002800000436f6e74726f6c00a66cfeff503f000000009000a5090000070000807a000000620000000180000065000080436f6e74726f6c00d159feff05feffff52656c6174696f6e736869702027464b5f5f637573746f6d5f57655f5f677569645f5f5f363235413941353727206265747765656e2027776561705f6c755f44616d616765547970652720616e642027637573746f6d5f576561706f6e5f41747461636b276f6e2700002800b5010000070000807b000000310000006f00000002800000436f6e74726f6c00fb5bfeff3727000000004000a5090000070000807c000000c0020000008000001700008053636847726964007a96feff3a200000776561705f6c755f53697a655f576561706f6e446963650000008800a5090000070000807d00000052000000018000005e000080436f6e74726f6c005da2feffbf13000052656c6174696f6e736869702027464b5f5f776561705f6c755f535f5f677569645f5f5f374430453930393327206265747765656e2027636f6d5f53697a652720616e642027776561705f6c755f53697a655f576561706f6e4469636527000000002800b5010000070000807e000000310000006f00000002800000436f6e74726f6c009d90feffd91a000000004000a5090000070000807f000000bc02000000800000150000805363684772696400b8c0ffff983a0000776561705f6c755f536b696c6c526571756972656475657300003c00a50900000700008080000000b802000000800000130000805363684772696400f295ffff92d7ffff776561705f6c755f576561706f6e52656163686f00003c00a50900000700008081000000b80200000080000013000080536368477269640062ccfeffd4feffff776561705f6c755f576561706f6e54726169746c00003c00a50900000700008082000000b6020000008000001200008053636847726964009ebcffff54240000776561705f6c755f576561706f6e54797065000000009000a50900000700008083000000520000000180000066000080436f6e74726f6c00b7bfffff3d2f000052656c6174696f6e736869702027464b5f5f776561705f6c755f575f5f677569645f5f5f353133303045353527206265747765656e2027776561705f6c755f536b696c6c52657175697265642720616e642027776561705f6c755f576561706f6e54797065276c2700002800b50100000700008084000000310000006f00000002800000436f6e74726f6c00fdc1ffff9e35000000008c00a50900000700008085000000620000000180000064000080436f6e74726f6c0023aeffffdeddffff52656c6174696f6e736869702027464b5f5f776561705f6c755f575f5f677569645f5f5f353232343332384527206265747765656e2027776561705f6c755f576561706f6e52656163682720616e642027776561705f6c755f576561706f6e547970652700002800b50100000700008086000000310000006f00000002800000436f6e74726f6c00dba2ffff2303000000004400a50900000700008087000000c8020000008000001b0000805363684772696400fa9cffff80700000776561705f726c5f576561706f6e5f4162696c69747953636f72650000009400a5090000070000808800000062000000018000006a000080436f6e74726f6c00f9a8ffff425b000052656c6174696f6e736869702027464b5f5f776561705f726c5f575f5f677569645f5f5f373933444646414627206265747765656e2027636f6d5f4162696c69747953636f72652720616e642027776561705f726c5f576561706f6e5f4162696c69747953636f726527696600002800b50100000700008089000000310000006f00000002800000436f6e74726f6c000c9fffffec69000000004400a5090000070000808a000000c6020000008000001a000080536368477269646562ccfefffe100000776561705f726c5f576561706f6e5f576561706f6e5472616974650000009400a5090000070000808b00000052000000018000006c000080436f6e74726f6c0045d8feff2005000052656c6174696f6e736869702027464b5f5f776561705f726c5f575f5f677569645f5f5f373536443645434227206265747765656e2027776561705f6c755f576561706f6e54726169742720616e642027776561705f726c5f576561706f6e5f576561706f6e54726169742700002800b5010000070000808c000000310000006f00000002800000436f6e74726f6c0040c6feffc00b000000003400a5090000070000808d000000a8020000008000000b0000805363684772696400a4a8feffee020000776561705f576561706f6e6e00008400a5090000070000808e00000062000000018000005c000080436f6e74726f6c6542c2feff0713000052656c6174696f6e736869702027464b5f5f776561705f576561705f5f677569645f5f5f373239313032323027206265747765656e2027776561705f6c755f576561706f6e547970652720616e642027776561705f576561706f6e2700002800b5010000070000808f000000310000006f00000002800000436f6e74726f6c00b540ffffb41a000000007c00a50900000700008090000000620000000180000053000080436f6e74726f6c005ca0feff8df8ffff52656c6174696f6e736869702027464b5f5f776561705f576561705f5f677569645f5f5f373041384239414527206265747765656e2027646963655f446963652720616e642027776561705f576561706f6e277200002800b50100000700008091000000310000006f00000002800000436f6e74726f6c00628dfeff3afeffff00008400a5090000070000809200000062000000018000005c000080436f6e74726f6c00c48bfeffff0b000052656c6174696f6e736869702027464b5f5f776561705f576561705f5f677569645f5f5f373139434444453727206265747765656e2027776561705f6c755f44616d616765547970652720616e642027776561705f576561706f6e2700002800b50100000700008093000000310000006f00000002800000436f6e74726f6c0037a2feff2924000000008800a5090000070000809400000052000000018000005f000080436f6e74726f6c6587b4feff7d12000052656c6174696f6e736869702027464b5f5f6d6f6e5f726c5f4d6f5f5f677569645f5f5f314338373342454327206265747765656e2027776561705f576561706f6e2720616e6420276d6f6e5f726c5f4d6f6e737465725f576561706f6e270000002800b50100000700008095000000310000006f00000002800000436f6e74726f6c0099a2feffe419000000008c00a50900000700008096000000620000000180000064000080436f6e74726f6c0042c2feffb70a000052656c6174696f6e736869702027464b5f5f776561705f726c5f575f5f677569645f5f5f373636313933303427206265747765656e2027776561705f576561706f6e2720616e642027776561705f726c5f576561706f6e5f576561706f6e54726169742700002800b50100000700008097000000310000006f00000002800000436f6e74726f6c00edcbfeffa60b000000009000a50900000700008098000000620000000180000065000080436f6e74726f6c0042c2feffeb12000052656c6174696f6e736869702027464b5f5f776561705f726c5f575f5f677569645f5f5f374133323233453827206265747765656e2027776561705f576561706f6e2720616e642027776561705f726c5f576561706f6e5f4162696c69747953636f726527276c2700002800b50100000700008099000000310000006f00000002800000436f6e74726f6c00af1cffff7b430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002143341208000000ca1a0000f50f0000785634120700000014010000610072006d005f00410072006d006f0072000000d7d6563fdcdb5b3feae9693f0000803f0000803fd7d6563fdcdb5b3feae9693f0000803fcccc3440000000000000f03f00000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f03f000000000000000044b6a7640000000000000000e4b8a7646425a8646068a61e6068a61e02000000020000000000000000000000f01c1711000000000200000000000000cdcccc3f000000003333b3416666a6c1cdcccc3f00000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900004401000098010000140100005406000058020000680100005802000000030000100200000000000001000000ca1a0000f50f000000000000050000000500000002000000020000001c010000d809000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000005c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000a000000610072006d005f00410072006d006f00720000002143341208000000ca1a000003090000785634120700000014010000610072006d005f006c0075005f00410072006d006f00720054007900700065000000803f0000803fd0cf4f3fd7d6563fe6e5653f0000803fcdcccc4000000041cdcccc40cdcc0c419a999940cdcccc40cdcccc4000008040cdcccc40cdcccc40cdcc4c4000008040cdcccc40cdcccc4000008040000080409a999940cdcc4c400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900004401000098010000140100005406000058020000680100005802000000030000100200000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000d809000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f00000011000000610072006d005f006c0075005f00410072006d006f0072005400790070006500000002000b00cc61ffff4cb30000cc61ffff79a900000000000002000000f0f0f000000000000000000000000000000000000100000004000000000000007b62ffffb9ad000079120000530100003200000001000002000079120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611d0046004b005f00610072006d005f00410072006d006f0072005f00610072006d005f006c0075005f00410072006d006f00720054007900700065002143341208000000ca1a0000540b0000785634120700000014010000610072006d005f0072006c005f00410043004d006f006400690066006900650072000000000000a09999f93f0000006066a67040000000c0cccc3440000000000000f03f00000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f03f000000000000000044b6a7640000000000000000e4b8a7646425a864a869a61ea869a61e02000000020000000000000000000000d80c0109000000000200000000000000cdcccc3f000000003333b3416666a6c1cdcccc3f00000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f00000012000000610072006d005f0072006c005f00410043004d006f00640069006600690065007200000002000b001c6fffffb8a10000a678ffffb8a100000000000002000000f0f0f00000000000000000000000000000000000010000000700000000000000fd6cffff67a2000062120000530100001800000001000002000062120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00610072006d005f0072006c005f00410043005f005f0067007500690064005f005f005f00350035004200460042003900340038002143341208000000ca1a0000540b0000785634120700000014010000610072006d005f0072006c005f004d006f006e0073007400650072005f00410072006d006f00720000000000080000000000000000000000100000000300000003000000040000000400000000000000000000001000000000000000000000000100000004000000000000003200000069000000050000000300000005000000ecffffff000000004b00000069000000040000000300000005000000f0ffffff000000001000000069000000000000000000000006000000f0ffffff00000000100000006c000000010000000000000007000000f0ffffff00000000100000009a00000002000000000000000300000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900004401000098010000140100005406000058020000680100005802000000030000100200000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000d809000000000000010000007b1700009709000000000000030000000300000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007200000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f00000015000000610072006d005f0072006c005f004d006f006e0073007400650072005f00410072006d006f007200000002000b00cc61ffff84990000cc61ffff569000000000000002000000f0f0f00000000000000000000000000000000000010000000a000000000000007b62ffff4394000079120000530100003200000001000002000079120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00610072006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f00310033004600310046003500450042002143341208000000ca1a0000540b0000785634120700000014010000610072006d005f0053006800690065006c00640000000000000000000000000000000000000000000000000000000000d8c25266d8c25266e0c25266e0c25266e8c25266e8c25266f0c25266f0c25266f8c25266f8c2526600c3526600c3526610c3526610c3526618c3526618c3526620c3526620c3526628c3526628c3526630c3526630c3526638c3526638c3526640c3526640c3526648c3526648c3526650c3526650c3526658c3526658c3526660c3526660c3526668c3526668c3526670c3526670c3526678c3526678c3526680c3526680c3526688c3526688c3526690c3526690c3526698c3526698c3000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900004401000098010000140100005406000058020000680100005802000000030000100200000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000d809000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000005e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000b000000610072006d005f0053006800690065006c006400000002000b00cc61ffffd47b0000cc61ffff028500000000000002000000f0f0f00000000000000000000000000000000000010000000d00000000000000754effffc17f0000a81200005301000032000000010000020000a8120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00610072006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f00310032004600440044003100420032002143341208000000ca1a00000309000078563412070000001401000063006f006d005f004100620069006c00690074007900530063006f00720065000000803f0000803fd7d6563fdcdb5b3feae9693f0000803f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001100000063006f006d005f004100620069006c00690074007900530063006f0072006500000004000b00e6b0fffff95d0000e6b0ffff926d00002086ffff926d00002086ffffdc9b00000000000002000000f0f0f000000000000000000000000000000000000100000010000000000000000379ffff906b000079120000530100003200000001000002000079120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00610072006d005f0072006c005f00410043005f005f0067007500690064005f005f005f00350034004300420039003500300046002143341208000000ca1a0000a40d000078563412070000001401000063006f006d005f004300520000000000030000001900000050eecb1e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a0000a40d000000000000040000000400000002000000020000001c0100006c0c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000005600000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000700000063006f006d005f004300520000002143341208000000ca1a0000540b000078563412070000001401000063006f006d005f004c0061006e00670075006100670065000000720061006d002000460069006c00650073002000280078003800360029002f004d006900630072006f0073006f00660074002000530051004c0020005300650072007600650072002f003100330030002f0054006f006f006c0073002f00420069006e006e002f004d0061006e006100670065006d0065006e007400530074007500640069006f002f004900440045002f00500072006900760061007400650041007300730065006d0062006c006900650073002f00440061007400610043006f006c006c006500630074006f00720073002f00000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006200000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000d00000063006f006d005f004c0061006e006700750061006700650000002143341208000000ca1a00000309000078563412070000001401000063006f006d005f006c0075005f00410072006d006f00720043006c00610073007300000069006c00650073002000280078003800360029002f004d006900630072006f0073006f00660074002000530051004c0020005300650072007600650072002f003100330030002f0054006f006f006c0073002f00420069006e006e002f004d0061006e006100670065006d0065006e007400530074007500640069006f002f004900440045002f00500072006900760061007400650041007300730065006d0062006c006900650073002f00440061007400610043006f006c006c006500630074006f00720073002f00000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000a80c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001200000063006f006d005f006c0075005f00410072006d006f00720043006c00610073007300000004000b006092feffbea700006092feffd9ae0000f4a3feffd9ae0000f4a3fefff4b000000200000002000000f0f0f000000000000000000000000000000000000100000015000000000000008285feff88af000079120000530100003200000001000002000079120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f006c0075005f00410072005f005f0067007500690064005f005f005f00350036004500380045003700410042002143341208000000ca1a00000309000078563412070000001401000063006f006d005f006c0075005f004d006f00760065006d0065006e00740000000000000000000000000000000000000000d097400000004033b38540000000000000f03f00000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f03f000000000000000044b6a7640000000000000000e4b8a7646425a864a0a0f508a0a0f508020000000200000000000000000000009812010900000000020000000000000000000000000000009a992d449a992dc40000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006800000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001000000063006f006d005f006c0075005f004d006f00760065006d0065006e00740000002143341208000000ca1a00000309000078563412070000001401000063006f006d005f006c0075005f00530065006e00730065007300000061006d002000460069006c00650073002000280078003800360029002f004d006900630072006f0073006f00660074002000530051004c0020005300650072007600650072002f003100330030002f0054006f006f006c0073002f00420069006e006e002f004d0061006e006100670065006d0065006e007400530074007500640069006f002f004900440045002f0043006f006d006d006f006e0045007800740065006e00730069006f006e0073002f0050006c006100740066006f0072006d002f004400650062007500670067006500000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006400000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000e00000063006f006d005f006c0075005f00530065006e0073006500730000002143341208000000ca1a00000309000078563412070000001401000063006f006d005f006c0075005f0053006b0069006c006c00000000000000000000000000000000a09999f93f000000a099597040000000c0cccc3440000000000000f03f00000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f03f000000000000000044b6a7640000000000000000e4b8a7646425a864183e0109183e010902000000020000000000000000000000f01c1711000000000200000000000000cdcccc3f000000003333b3416666a6c1cdcccc3f00000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000a80c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006200000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000d00000063006f006d005f006c0075005f0053006b0069006c006c0000002143341208000000ca1a00000309000078563412070000001401000063006f006d005f00500072006f00740065006300740069006f006e00460072006f006d00440061006d006100670065000000653f000000000900000018df671278de6712000000000c00000000000000000000000000000004000000e4dc6712a8dc67123491531bdc90531bb4a45f1a50a45f1a0000000003000000b88c5f1a788c5f1ab8f3671274f367124c34730210347302a4702e1860702e18fcf2e411bcf2e4114cf26712f8f1671294d41b013cd41b01e4d15f1ab0d15f1a704be411a84ae41134d11b01f0d01b01a49b0215489b0215347b9102f87a910218f36712a8f26712f891a81a8491a81af4c9000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a00000309000000000000020000000200000002000000020000001c0100006c0c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001900000063006f006d005f00500072006f00740065006300740069006f006e00460072006f006d00440061006d0061006700650000002143341208000000ca1a00000309000078563412070000001401000063006f006d005f0072006c005f004100620069006c00690074007900530063006f00720065005f004d006f0064006900660069006500720000003440000000000000f03f00000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f03f000000000000000044b6a7640000000000000000e4b8a7646425a86458fe201158fe201102000000020000000000000000000000d80c0109000000000200000000000000cdcccc3f000000003333b3416666a6c1cdcccc3f00000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000008200000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001d00000063006f006d005f0072006c005f004100620069006c00690074007900530063006f00720065005f004d006f0064006900660069006500720000002143341208000000ca1a00000309000078563412070000001401000063006f006d005f0072006c005f004100620069006c00690074007900530063006f00720065005f0053006b0069006c006c000000000000c0cccc3440000000000000f03f00000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f03f000000000000000044b6a7640000000000000000e4b8a7646425a8643808af1e3808af1e0200000002000000000000000000000010372511000000000200000000000000cdcccc3f000000003333b3416666a6c1cdcccc3f00000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001a00000063006f006d005f0072006c005f004100620069006c00690074007900530063006f00720065005f0053006b0069006c006c00000004000b00c4a5ffffa6590000f49dffffa6590000f49dffff465000003a9cffff465000000000000002000000f0f0f00000000000000000000000000000000000010000001d00000000000000a39effffdd540000bf1200005301000038000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f00410062005f005f0067007500690064005f005f005f003600430044003800320038004300410002000b007c78ffff465000007081ffff465000000000000002000000f0f0f00000000000000000000000000000000000010000001f000000000000009773fffff5500000bf1200005301000032000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f00410062005f005f0067007500690064005f005f005f00360044004300430034004400300033002143341208000000ca1a0000540b000078563412070000001401000063006f006d005f0072006c005f004d006f006e0073007400650072005f004100620069006c00690074007900530063006f007200650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700009709000000000000030000000300000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000008000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001c00000063006f006d005f0072006c005f004d006f006e0073007400650072005f004100620069006c00690074007900530063006f0072006500000002000b003eb3ffffb73600003eb3ffffde3f00000000000002000000f0f0f00000000000000000000000000000000000010000002200000000000000ff9fffffa03a000090120000530100003200000001000002000090120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f004d006f005f005f00760061006c00750065005f005f003000370038004300310046003000360002000b003eb3fffff65400003eb3ffff324b00000000000002000000f0f0f00000000000000000000000000000000000010000002400000000000000edb3fffffe4e0000d61200005301000037000000010000020000d6120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f00300036003900370046004100430044002143341208000000ca1a00000309000078563412070000001401000063006f006d005f0072006c005f004d006f006e0073007400650072005f004c0061006e0067007500610067006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007800000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001800000063006f006d005f0072006c005f004d006f006e0073007400650072005f004c0061006e0067007500610067006500000002000b00c84affff100e00005254ffff100e00000000000002000000f0f0f00000000000000000000000000000000000010000002700000000000000a145ffffbf0e0000bf1200005301000038000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f00300046003200440034003000430045002143341208000000ca1a0000540b000078563412070000001401000063006f006d005f00530069007a006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000005a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000900000063006f006d005f00530069007a00650000002143341208000000ca1a00000309000078563412070000001401000063006f00720065005f006c0075005f00430052005f00500072006f00660069006300690065006e00630079000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000a80c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007600000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001700000063006f00720065005f006c0075005f00430052005f00500072006f00660069006300690065006e0063007900000002000b001a9ffeff22a10000a4a8feff22a100000200000002000000f0f0f00000000000000000000000000000000000010000002b00000000000000619afeffd1a100004b12000053010000360000000100000200004b120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f00720065005f006c0075005f0043005f005f0067007500690064005f005f005f00350046003700450032004400410043002143341208000000ca1a0000a40d000078563412070000001401000063006f00720065005f006c0075005f0044006500660065006e0073006900760065005f00560061006c0075006500730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a0000a40d000000000000040000000400000002000000020000001c0100006c0c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001900000063006f00720065005f006c0075005f0044006500660065006e0073006900760065005f00560061006c00750065007300000004000b009e90feffbea700009e90feffd9ae0000a07ffeffd9ae0000a07ffefff4b000000200000002000000f0f0f00000000000000000000000000000000000010000002e00000000000000c776feffd7ac00001d12000053010000360000000100000200001d120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f00720065005f006c0075005f0044005f005f0067007500690064005f005f005f00350039004300350035003400350036002143341208000000ca1a0000f50f000078563412070000001401000063006f00720065005f006c0075005f004f006600660065006e0073006900760065005f00560061006c0075006500730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a0000f50f000000000000050000000500000002000000020000001c010000a80c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001900000063006f00720065005f006c0075005f004f006600660065006e0073006900760065005f00560061006c00750065007300000004000b006092feff1a9a00006092feffff920000b2c7feffff920000b2c7feff479000000200000002000000f0f0f000000000000000000000000000000000000100000031000000000000006badfeffae93000062120000530100003500000001000002000062120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f00720065005f006c0075005f004f005f005f0067007500690064005f005f005f00350043004100310043003100300031002143341208000000ca1a0000540b000078563412070000001401000063007500730074006f006d005f00410074007400610063006b005f00440069006300650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001300000063007500730074006f006d005f00410074007400610063006b005f00440069006300650000002143341208000000ca1a0000a40d000078563412070000001401000063007500730074006f006d005f0057006500610070006f006e005f00410074007400610063006b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000a40d000000000000040000000400000002000000020000001c010000580b000000000000010000007b1700009709000000000000030000000300000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007200000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001500000063007500730074006f006d005f0057006500610070006f006e005f00410074007400610063006b00000004000b00c4a5ffff8c5500003a93ffff8c5500003a93ffff000000009c68feff000000000000000002000000f0f0f000000000000000000000000000000000000100000035000000000000005126fffffefdffffed1200005301000035000000010000020000ed120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063007500730074006f006d005f00570065005f005f0067007500690064005f005f005f003600330034004500420045003900300002000b009c68feff24faffff2672feff24faffff0000000002000000f0f0f000000000000000000000000000000000000100000037000000000000003c64feffd3faffff4b12000053010000320000000100000200004b120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063007500730074006f006d005f00410074005f005f0067007500690064005f005f005f00360037003100460034004600370034002143341208000000ca1a0000f50f000078563412070000001401000064006900630065005f00440069006300650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000f50f000000000000050000000500000002000000020000001c010000580b000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000005c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000a00000064006900630065005f004400690063006500000002000b007a96feff24fafffff08cfeff24faffff0000000002000000f0f0f00000000000000000000000000000000000010000003a000000000000009088feff22f8ffff4b12000053010000320000000100000200004b120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063007500730074006f006d005f00410074005f005f0067007500690064005f005f005f003600360032004200320042003300420002000b00f4a3feffe5010000f4a3feff220b00000000000002000000f0f0f00000000000000000000000000000000000010000003c000000000000009d90feffb8060000a8120000530100003d000000010000020000a8120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f00530069007a0065005f005f0067007500690064005f0044005f005f00360039004600420042004300310046002143341208000000ca1a0000a40d000078563412070000001401000066006500610074007500720065005f006c0075005f0046006500610074007500720065000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000a40d000000000000040000000400000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001300000066006500610074007500720065005f006c0075005f00460065006100740075007200650000002143341208000000ca1a00000309000078563412070000001401000066006500610074007500720065005f0072006c005f004d006f006e0073007400650072005f004600650061007400750072006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001b00000066006500610074007500720065005f0072006c005f004d006f006e0073007400650072005f004600650061007400750072006500000002000b00cc61ffff16c9ffffcc61ffffe2d2ffff0000000002000000f0f0f000000000000000000000000000000000000100000040000000000000002e4fffff53cdffffef1100005301000032000000010000020000ef110000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0066006500610074007500720065005f0072005f005f0067007500690064005f005f005f00300042003500430041004600450041002143341208000000ca1a0000540b0000785634120700000014010000680070005f00500072006f00740065006300740069006f006e005f00430052005f004d006f006400690066006900650072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c0100006c0c000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001a000000680070005f00500072006f00740065006300740069006f006e005f00430052005f004d006f00640069006600690065007200000004000b009e90feff1a9a00009e90feffff920000a07ffeffff920000a07ffeff247700000000000002000000f0f0f000000000000000000000000000000000000100000043000000000000004f80feff478e000034120000530100003400000001000002000034120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00680070005f00500072006f007400650063005f005f0067007500690064005f005f005f003400390038004500450043003800440002000b00a07ffeffa9620000a07ffeffd06b00000000000002000000f0f0f00000000000000000000000000000000000010000004500000000000000bd6cfeffce66000034120000530100003500000001000002000034120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00680070005f00500072006f007400650063005f005f0067007500690064005f005f005f00340041003800330031003000430036002143341208000000ca1a0000030900007856341207000000140100006d006f006e005f006c0075005f0047006f006f0064006e006500730073000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006800000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000100000006d006f006e005f006c0075005f0047006f006f0064006e0065007300730000002143341208000000ca1a0000030900007856341207000000140100006d006f006e005f006c0075005f004c0061007700660075006c006e00650073007300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000120000006d006f006e005f006c0075005f004c0061007700660075006c006e0065007300730000002143341208000000ca1a0000030900007856341207000000140100006d006f006e005f006c0075005f005400790070006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000c0000006d006f006e005f006c0075005f00540079007000650000002143341208000000ca1a0000961400007856341207000000140100006d006f006e005f004d006f006e007300740065007200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c0000003400000000000000000000008333000038190000000000002d010000090000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00009614000000000000070000000700000002000000020000001c010000580b000000000000010000007b1700000e0e000000000000050000000500000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000c0000006d006f006e005f004d006f006e007300740065007200000004000b002086ffff340800002086ffff2f050000a43effff2f050000a43effff38faffff0000000002000000f0f0f00000000000000000000000000000000000010000004b00000000000000f35fffff2d030000ed1200005301000031000000010000020000ed120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003000310044003300340035004200300004000b0044b1feffb80b0000a1f0feffb80b0000a1f0feff8ef9fffffe2fffff8ef9ffff0000000002000000f0f0f00000000000000000000000000000000000010000004d0000000000000050f1feff87fdffff03130000530100003600000001000002000003130000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003700460045004100460044003300450004000b00c84affff7eebffffe451ffff7eebffffe451ffffba450000c4a5ffffba4500000000000002000000f0f0f00000000000000000000000000000000000010000004f00000000000000763effff1c450000bf1200005301000035000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003000350041003300440036003900340004000b00c84affffbce9ffffe451ffffbce9ffffe451ffff92d7ffff5254ffff92d7ffff0000000002000000f0f0f000000000000000000000000000000000000100000051000000000000009352ffffcddfffffc11100005301000040000000010000020000c1110000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0066006500610074007500720065005f0072005f005f0067007500690064005f005f005f003000410036003800380042004200310004000b00e23cffff38faffffe23cffffe3050000cc61ffffe3050000cc61ffff600900000000000002000000f0f0f000000000000000000000000000000000000100000053000000000000007839ffff92060000a81200005301000035000000010000020000a8120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003000450033003900310043003900350004000b00c84affff02efffff7c50ffff02efffff7c50ffffde8a00005254ffffde8a00000000000002000000f0f0f00000000000000000000000000000000000010000005500000000000000253dfffffe3f0000a81200005301000034000000010000020000a8120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f00610072006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100320030003900410044003700390004000b00189efeff1a9a0000189efeff294a00009430ffff294a00009430ffff38faffff0000000002000000f0f0f0000000000000000000000000000000000001000000570000000000000025eefeffd84a0000ed1200005301000034000000010000020000ed120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f00300032004300370036003900450039002143341208000000ca1a0000a40d00007856341207000000140100006d006f006e005f0072006c005f0041006c00690067006e006d0065006e0074000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000a40d000000000000040000000400000002000000020000001c010000500d000000000000010000007b1700009709000000000000030000000300000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006a00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000110000006d006f006e005f0072006c005f0041006c00690067006e006d0065006e007400000004000b005096feff220b000027e3feff220b000027e3feff8ef9fffffe2fffff8ef9ffff0000000002000000f0f0f00000000000000000000000000000000000010000005a00000000000000d6e3feff51010000ed1200005301000033000000010000020000ed120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003000300044004600320031003700370002000b00400cffff220b00005096feff220b00000000000002000000f0f0f00000000000000000000000000000000000010000005c000000000000002ec8feff2009000034120000530100003200000001000002000034120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f0041006c005f005f0067007500690064005f005f005f003200370033003900440034003800390004000b00ece7feffa41f00001ebffeffa41f00001ebffeff701700005096feff701700000000000002000000f0f0f00000000000000000000000000000000000010000005e00000000000000d8bafeff6e1500004b120000530100003c0000000100000200004b120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f0041006c005f005f0067007500690064005f005f005f00320038003200440046003800430032002143341208000000ca1a0000540b00007856341207000000140100006d006f006e005f0072006c005f004d006f006e0073007400650072005f004d006f00760065006d0065006e00740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000047864a008c009c008c009c0038009e1e38009e1e0080e71e0070b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007800000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000180000006d006f006e005f0072006c005f004d006f006e0073007400650072005f004d006f00760065006d0065006e007400000004000b00400cffffa0f6ffffdfeefeffa0f6ffffdfeefeff54d9ffff7ed1feff54d9ffff0000000002000000f0f0f000000000000000000000000000000000000100000061000000000000008eeffeff36e4ffffbf1200005301000034000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100410036003900450039003500300004000b00fe2fffff38e6ffffbe00ffff38e6ffffbe00ffff54d9ffff7ed1feff54d9ffff0000000002000000f0f0f000000000000000000000000000000000000100000063000000000000006d01ffffc4ddffffbf1200005301000032000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f00310039003700350043003500310037002143341208000000ca1a0000540b00007856341207000000140100006d006f006e005f0072006c005f004d006f006e0073007400650072005f00530065006e0073006500730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007400000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000160000006d006f006e005f0072006c005f004d006f006e0073007400650072005f00530065006e00730065007300000003000b002842ffff32ceffff203bffff32ceffff203bffff16c2ffff0000000002000000f0f0f00000000000000000000000000000000000010000006600000000000000cf3bffffc1c9ffffbf1200005301000034000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100360039003900350038003600430004000b00783dffffa2e5ffff783dffff43d9ffffd22effff43d9ffffd22effff16c2ffff0000000002000000f0f0f000000000000000000000000000000000000100000068000000000000006d31ffff41d7ffffbf1200005301000032000000010000020000bf120000530100000200000000000500008008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f00310035004100350033003400330033002143341208000000ca1a0000030900007856341207000000140100006d006f006e005f0072006c005f004d006f006e0073007400650072005f0053006b0069006c006c000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900004401000098010000140100005406000058020000680100005802000000030000100200000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000d809000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007200000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000150000006d006f006e005f0072006c005f004d006f006e0073007400650072005f0053006b0069006c006c00000002000b002c6bffff995400002c6bffffc05d00000000000002000000f0f0f00000000000000000000000000000000000010000006b000000000000009057ffffaa580000ed1200005301000034000000010000020000ed12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003200300035003700430043004400300004000b00c84affff40edffff3051ffff40edffff3051ffff70620000b25dffff706200000000000002000000f0f0f00000000000000000000000000000000000010000006d00000000000000c23dffff13440000bf1200005301000044000000010000020000bf12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f00310046003600330041003800390037002143341208000000b51a0000030900007856341207000000140100006d006f006e005f0072006c005f004d006f006e0073007400650072005f0057006500610070006f006e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000b51a00000309000000000000020000000200000002000000020000001c010000380d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007400000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000160000006d006f006e005f0072006c005f004d006f006e0073007400650072005f0057006500610070006f006e00000004000b00fe2fffff8ef9ffffacf9feff8ef9ffffacf9feffa41f000059c3feffa41f00000000000002000000f0f0f00000000000000000000000000000000000010000007000000000000000a5e0feffa21d0000a81200005301000045000000010000020000a812000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f00310042003900330031003700420033002143341208000000ca1a0000540b00007856341207000000140100006d006f006e005f0072006c005f00500072006f00740065006300740069006f006e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c0100006c0c000000000000010000007b1700009709000000000000030000000300000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006c00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f000000120000006d006f006e005f0072006c005f00500072006f00740065006300740069006f006e00000002000b00a07ffeffa6590000a07ffeffe24f00000000000002000000f0f0f000000000000000000000000000000000000100000073000000000000004f80feffef5300004b12000053010000340000000100000200004b12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f00500072005f005f0067007500690064005f005f005f003100380042003600410042003000380004000b00fe2fffff8ef9ffff77defeff8ef9ffff77defeff24450000f08cfeff244500000000000002000000f0f0f0000000000000000000000000000000000001000000750000000000000066cbfeff5c3c000062120000530100003f0000000100000200006212000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f00500072005f005f0067007500690064005f005f005f00310037004300320038003600430046002143341208000000ca1a0000540b0000785634120700000014010000540045004d0050005f004d006f006e0073007400650072005f00430052000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000540b000000000000030000000300000002000000020000001c010000500d000000000000010000007b170000e502000000000000000000000000000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006800000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f00000010000000540045004d0050005f004d006f006e0073007400650072005f004300520000002143341208000000ca1a00000309000078563412070000001401000077006500610070005f006c0075005f00440061006d00610067006500540079007000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b000078090000d800000008010000c00000005406000098010000f000000098010000040200005c0100000000000001000000ca1a00000309000000000000020000000200000002000000020000001c0100006c0c000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001300000077006500610070005f006c0075005f00440061006d006100670065005400790070006500000002000b00a07ffeff673b0000a07ffeff8e4400000000000002000000f0f0f00000000000000000000000000000000000010000007900000000000000a66cfeff503f00004b12000053010000320000000100000200004b12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f00500072005f005f0067007500690064005f005f005f003100360043004500360032003900360004000b00a07ffeff64320000a07ffeff952a00004c5bfeff952a00004c5bfeffc00000000000000002000000f0f0f00000000000000000000000000000000000010000007b00000000000000fb5bfeff372700001a13000053010000350000000100000200001a13000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0063007500730074006f006d005f00570065005f005f0067007500690064005f005f005f00360032003500410039004100350037002143341208000000ca1a00000309000078563412070000001401000077006500610070005f006c0075005f00530069007a0065005f0057006500610070006f006e004400690063006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007800000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001800000077006500610070005f006c0075005f00530069007a0065005f0057006500610070006f006e004400690063006500000002000b00f4a3feff76160000f4a3feff3a2000000200000002000000f0f0f00000000000000000000000000000000000010000007e000000000000009d90feffd91a0000a81200005301000034000000010000020000a812000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f006c0075005f0053005f005f0067007500690064005f005f005f00370044003000450039003000390033002143341208000000ca1a00000309000078563412070000001401000077006500610070005f006c0075005f0053006b0069006c006c005200650071007500690072006500640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007400000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001600000077006500610070005f006c0075005f0053006b0069006c006c005200650071007500690072006500640000002143341208000000ca1a00000309000078563412070000001401000077006500610070005f006c0075005f0057006500610070006f006e00520065006100630068000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001400000077006500610070005f006c0075005f0057006500610070006f006e005200650061006300680000002143341208000000ca1a00000309000078563412070000001401000077006500610070005f006c0075005f0057006500610070006f006e00540072006100690074000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700002005000000000000010000000100000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001400000077006500610070005f006c0075005f0057006500610070006f006e005400720061006900740000002143341208000000ca1a0000a40d000078563412070000001401000077006500610070005f006c0075005f0057006500610070006f006e00540079007000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a0000a40d000000000000040000000400000002000000020000001c010000500d000000000000010000007b1700009709000000000000030000000300000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001300000077006500610070005f006c0075005f0057006500610070006f006e005400790070006500000002000b004ec1ffff983a00004ec1fffff83100000000000002000000f0f0f00000000000000000000000000000000000010000008400000000000000fdc1ffff9e350000ed1200005301000032000000010000020000ed12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f006c0075005f0057005f005f0067007500690064005f005f005f003500310033003000300045003500350004000b00baafffff95e0ffffbaafffff7402000034bdffff7402000034bdffff542400000000000002000000f0f0f00000000000000000000000000000000000010000008600000000000000dba2ffff23030000ed1200005301000032000000010000020000ed12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f006c0075005f0057005f005f0067007500690064005f005f005f00350032003200340033003200380045002143341208000000ca1a00000309000078563412070000001401000077006500610070005f0072006c005f0057006500610070006f006e005f004100620069006c00690074007900530063006f00720065000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000008000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001c00000077006500610070005f0072006c005f0057006500610070006f006e005f004100620069006c00690074007900530063006f0072006500000004000b00a8b2fffff95d0000a8b2ffff466e000074aaffff466e000074aaffff807000000000000002000000f0f0f000000000000000000000000000000000000100000089000000000000000c9fffffec690000ed1200005301000033000000010000020000ed12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f00370039003300440046004600410046002143341208000000ca1a00000309000078563412070000001401000077006500610070005f0072006c005f0057006500610070006f006e005f0057006500610070006f006e00540072006100690074000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000c1140000000000002d010000070000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00000309000000000000020000000200000002000000020000001c010000500d000000000000010000007b1700005c07000000000000020000000200000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000007e00000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000001b00000077006500610070005f0072006c005f0057006500610070006f006e005f0057006500610070006f006e0054007200610069007400000002000b00dcd9feffd7070000dcd9fefffe1000000000000002000000f0f0f00000000000000000000000000000000000010000008c0000000000000040c6feffc00b0000ed1200005301000032000000010000020000ed12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f00370035003600440036004500430042002143341208000000ca1a00004612000078563412070000001401000077006500610070005f0057006500610070006f006e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000005000000540000002c0000002c0000002c00000034000000000000000000000083330000fc160000000000002d010000080000000c000000070000001c010000940b0000780900001c020000a0020000d401000054060000f003000064020000f0030000040500006c0300000000000001000000ca1a00004612000000000000060000000600000002000000020000001c010000580b000000000000010000007b170000d30b000000000000040000000400000002000000020000001c010000940b000001000000000000007b170000e502000000000000000000000000000002000000020000001c010000940b00000000000000000000ac3e00002622000000000000000000000d00000004000000040000001c010000940b0000b00d00007008000078563412040000006000000001000000010000000b000000000000000100000002000000030000000400000005000000060000000700000008000000090000000a00000004000000640062006f0000000c00000077006500610070005f0057006500610070006f006e00000004000b009ebcffffea2400000640ffffea2400000640ffff821400006ec3feff821400000000000002000000f0f0f00000000000000000000000000000000000010000008f00000000000000b540ffffb41a00004913000053010000320000000100000200004913000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0057006500610070005f005f0067007500690064005f005f005f003700320039003100300032003200300004000b0044b1feff24faffff88a1feff24faffff88a1feffb80b0000a4a8feffb80b00000000000002000000f0f0f00000000000000000000000000000000000010000009100000000000000628dfeff3afeffff7713000053010000340000000100000200007713000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0057006500610070005f005f0067007500690064005f005f005f003700300041003800420039004100450004000b00f08cfeff1437000088a1feff1437000088a1feff7a0d0000a4a8feff7a0d00000000000002000000f0f0f0000000000000000000000000000000000001000000930000000000000037a2feff292400008e130000530100003a0000000100000200008e13000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0057006500610070005f005f0067007500690064005f005f005f003700310039004300440044004500370002000b001eb6feff341500001eb6feff0e1f00000000000002000000f0f0f0000000000000000000000000000000000001000000950000000000000099a2feffe4190000d61200005301000037000000010000020000d612000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100430038003700330042004500430004000b006ec3feff4e0c00003ecbfeff4e0c00003ecbfeffae15000062ccfeffae1500000000000002000000f0f0f00000000000000000000000000000000000010000009700000000000000edcbfeffa60b0000bf1200005301000032000000010000020000bf12000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f003700360036003100390033003000340004000b006ec3feff821400003430ffff821400003430ffff16710000fa9cffff167100000000000002000000f0f0f00000000000000000000000000000000000010000009900000000000000af1cffff7b430000d61200005301000032000000010000020000d612000053010000020000000000ffffff0008000080010000001500010000009001b0300100065461686f6d611e0046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f0037004100330032003200330045003800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000fefffffffeffffff0400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002e0000002f000000300000003100000032000000330000003400000035000000360000003700000038000000fefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0100feff030a0000ffffffff00000000000000000000000000000000170000004d6963726f736f66742044445320466f726d20322e300010000000456d626564646564204f626a6563740000000000f439b271000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010003000000000000000c0000000b0000004e61bc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000dbe6b0e91c81d011ad5100a0c90f573900000200402b07fa4a2dd301020200001048450000000000000000000000000000000000c80100004400610074006100200053006f0075007200630065003d0048004f004c0059002d00480049005000480045004f00540048005c00530051004c0045005800500052004500530053003b0049006e0069007400690061006c00200043006100740061006c006f0067003d004d006f006e0073007400650072005f004200750069006c006400650072003b0049006e00740065006700720061007400650064002000530065006300750072006900740079003d0054007200750065003b004d0075006c007400690070006c00650041006300740069007600650052006500730075006c00740053006500740073003d00460061006c00730065003b0054007200750073007400530065000300440064007300530074007200650061006d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000160002000300000006000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000075000000f38300000000000053006300680065006d00610020005500440056002000440065006600610075006c0074000000000000000000000000000000000000000000000000000000000026000200ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000020000001600000000000000440053005200450046002d0053004300480045004d0041002d0043004f004e00540045004e0054005300000000000000000000000000000000000000000000002c0002010500000007000000ffffffff000000000000000000000000000000000000000000000000000000000000000000000000030000005a0d00000000000053006300680065006d00610020005500440056002000440065006600610075006c007400200050006f007300740020005600360000000000000000000000000036000200ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000003900000012000000000000008100000082000000830000008400000085000000860000008700000088000000890000008a0000008b0000008c0000008d0000008e0000008f000000900000009100000092000000930000009400000095000000960000009700000098000000990000009a0000009b0000009c0000009d0000009e0000009f000000a0000000a1000000a2000000a3000000a4000000a5000000a6000000a7000000a8000000a9000000aa000000ab000000ac000000ad000000ae000000af000000b0000000b1000000b2000000b3000000b4000000b5000000b6000000feffffffb8000000b9000000ba000000bb000000bc000000bd000000feffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0c000000243bfeff3aa3ffff0100260000007300630068005f006c006100620065006c0073005f00760069007300690062006c0065000000010000000b0000001e000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000010000000100000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003500320030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000020000000200000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003500320030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000000300000003000000000000004c000000011f0c5e01000000640062006f00000046004b005f00610072006d005f00410072006d006f0072005f00610072006d005f006c0075005f00410072006d006f007200540079007000650000000000000000000000c4020000000004000000040000000300000008000000012cce1e402cce1e0000000000000000ad070000000000050000000500000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000000600000006000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00610072006d005f0072006c005f00410043005f005f0067007500690064005f005f005f003500350042004600420039003400380000000000000000000000c40200000000070000000700000006000000080000000122ce1e8022ce1e0000000000000000ad070000000000080000000800000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003500320030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000000900000009000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00610072006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100330046003100460035004500420000000000000000000000c402000000000a0000000a00000009000000080000000128ce1e0028ce1e0000000000000000ad0700000000000b0000000b00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003500320030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000000c0000000c000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00610072006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100320046004400440031004200320000000000000000000000c402000000000d0000000d0000000c000000080000000127ce1ec027ce1e0000000000000000ad0700000000000e0000000e00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000000f0000000f000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00610072006d005f0072006c005f00410043005f005f0067007500690064005f005f005f003500340043004200390035003000460000000000000000000000c4020000000010000000100000000f000000080000000127ce1e8027ce1e0000000000000000ad070000000000110000001100000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003100380030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000120000001200000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000130000001300000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003200340030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000001400000014000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f006c0075005f00410072005f005f0067007500690064005f005f005f003500360045003800450037004100420000000000000000000000c40200000000150000001500000014000000080000000122ce1e4022ce1e0000000000000000ad070000000000160000001600000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000170000001700000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000180000001800000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003200340030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000190000001900000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003100380030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000001a0000001a00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000001b0000001b00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000001c0000001c000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f00410062005f005f0067007500690064005f005f005f003600430044003800320038004300410000000000000000000000c402000000001d0000001d0000001c000000080000000127ce1e4027ce1e0000000000000000ad0700000000001e0000001e000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f00410062005f005f0067007500690064005f005f005f003600440043004300340044003000330000000000000000000000c402000000001f0000001f0000001e000000080000000122ce1e0022ce1e0000000000000000ad070000000000200000002000000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000002100000021000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f004d006f005f005f00760061006c00750065005f005f003000370038004300310046003000360000000000000000000000c40200000000220000002200000021000000080000000127ce1e0027ce1e0000000000000000ad0700000000002300000023000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003000360039003700460041004300440000000000000000000000c40200000000240000002400000023000000080000000121ce1ec021ce1e0000000000000000ad070000000000250000002500000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000002600000026000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003000460032004400340030004300450000000000000000000000c40200000000270000002700000026000000080000000121ce1e8021ce1e0000000000000000ad070000000000280000002800000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000290000002900000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003200340030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000002a0000002a000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f00720065005f006c0075005f0043005f005f0067007500690064005f005f005f003500460037004500320044004100430000000000000000000000c402000000002b0000002b0000002a000000080000000126ce1ec026ce1e0000000000000000ad0700000000002c0000002c00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003100380030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000002d0000002d000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f00720065005f006c0075005f0044005f005f0067007500690064005f005f005f003500390043003500350034003500360000000000000000000000c402000000002e0000002e0000002d000000080000000126ce1e8026ce1e0000000000000000ad0700000000002f0000002f00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003200340030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000003000000030000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f00720065005f006c0075005f004f005f005f0067007500690064005f005f005f003500430041003100430031003000310000000000000000000000c40200000000310000003100000030000000080000000125ce1e8025ce1e0000000000000000ad070000000000320000003200000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000330000003300000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900300034000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000003400000034000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063007500730074006f006d005f00570065005f005f0067007500690064005f005f005f003600330034004500420045003900300000000000000000000000c40200000000350000003500000034000000080000000126ce1e4026ce1e0000000000000000ad0700000000003600000036000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063007500730074006f006d005f00410074005f005f0067007500690064005f005f005f003600370031004600340046003700340000000000000000000000c40200000000370000003700000036000000080000000124ce1e0024ce1e0000000000000000ad070000000000380000003800000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900300034000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000003900000039000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063007500730074006f006d005f00410074005f005f0067007500690064005f005f005f003600360032004200320042003300420000000000000000000000c402000000003a0000003a00000039000000080000000121ce1e4021ce1e0000000000000000ad0700000000003b0000003b000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f00530069007a0065005f005f0067007500690064005f0044005f005f003600390046004200420043003100460000000000000000000000c402000000003c0000003c0000003b000000080000000125ce1e4025ce1e0000000000000000ad0700000000003d0000003d00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000003e0000003e00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000003f0000003f000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0066006500610074007500720065005f0072005f005f0067007500690064005f005f005f003000420035004300410046004500410000000000000000000000c4020000000040000000400000003f000000080000000121ce1e0021ce1e0000000000000000ad070000000000410000004100000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003100380030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000004200000042000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00680070005f00500072006f007400650063005f005f0067007500690064005f005f005f003400390038004500450043003800440000000000000000000000c40200000000430000004300000042000000080000000123ce1ec023ce1e0000000000000000ad0700000000004400000044000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00680070005f00500072006f007400650063005f005f0067007500690064005f005f005f003400410038003300310030004300360000000000000000000000c40200000000450000004500000044000000080000000123ce1e8023ce1e0000000000000000ad070000000000460000004600000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000470000004700000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000480000004800000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000490000004900000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900300034000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000004a0000004a000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003000310044003300340035004200300000000000000000000000c402000000004b0000004b0000004a000000080000000128ce1ec028ce1e0000000000000000ad0700000000004c0000004c000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003700460045004100460044003300450000000000000000000000c402000000004d0000004d0000004c000000080000000125ce1e0025ce1e0000000000000000ad0700000000004e0000004e000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003000350041003300440036003900340000000000000000000000c402000000004f0000004f0000004e000000080000000128ce1e8028ce1e0000000000000000ad0700000000005000000050000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0066006500610074007500720065005f0072005f005f0067007500690064005f005f005f003000410036003800380042004200310000000000000000000000c40200000000510000005100000050000000080000000123ce1e4023ce1e0000000000000000ad0700000000005200000052000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063006f006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003000450033003900310043003900350000000000000000000000c40200000000530000005300000052000000080000000128ce1e4028ce1e0000000000000000ad0700000000005400000054000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f00610072006d005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100320030003900410044003700390000000000000000000000c40200000000550000005500000054000000080000000123ce1e0023ce1e0000000000000000ad0700000000005600000056000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003000320043003700360039004500390000000000000000000000c40200000000570000005700000056000000080000000126ce1e0026ce1e0000000000000000ad070000000000580000005800000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000005900000059000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f004d006f006e00730074005f005f0067007500690064005f005f005f003000300044004600320031003700370000000000000000000000c402000000005a0000005a00000059000000080000000124ce1e4024ce1e0000000000000000ad0700000000005b0000005b000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f0041006c005f005f0067007500690064005f005f005f003200370033003900440034003800390000000000000000000000c402000000005c0000005c0000005b000000080000000124ce1ec024ce1e0000000000000000ad0700000000005d0000005d000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f0041006c005f005f0067007500690064005f005f005f003200380032004400460038004300320000000000000000000000c402000000005e0000005e0000005d000000080000000124ce1e8024ce1e0000000000000000ad0700000000005f0000005f00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000006000000060000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100410036003900450039003500300000000000000000000000c40200000000610000006100000060000000080000000122ce1ec022ce1e0000000000000000ad0700000000006200000062000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100390037003500430035003100370000000000000000000000c40200000000630000006300000062000000080000000125ce1ec025ce1e0000000000000000ad070000000000640000006400000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000006500000065000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100360039003900350038003600430000000000000000000000c4020000000066000000660000006500000008000000011ece1e001ece1e0000000000000000ad0700000000006700000067000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100350041003500330034003300330000000000000000000000c40200000000680000006800000067000000080000000119ce1e4019ce1e0000000000000000ad070000000000690000006900000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003500320030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000006a0000006a000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003200300035003700430043004400300000000000000000000000c402000000006b0000006b0000006a00000008000000011bce1e001bce1e0000000000000000ad0700000000006c0000006c000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100460036003300410038003900370000000000000000000000c402000000006d0000006d0000006c00000008000000011dce1ec01dce1e0000000000000000ad0700000000006e0000006e00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003300380034000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000006f0000006f000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100420039003300310037004200330000000000000000000000c4020000000070000000700000006f000000080000000119ce1e8019ce1e0000000000000000ad070000000000710000007100000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003100380030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000007200000072000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f00500072005f005f0067007500690064005f005f005f003100380042003600410042003000380000000000000000000000c40200000000730000007300000072000000080000000120ce1e8020ce1e0000000000000000ad0700000000007400000074000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f00500072005f005f0067007500690064005f005f005f003100370043003200380036004300460000000000000000000000c40200000000750000007500000074000000080000000120ce1e4020ce1e0000000000000000ad070000000000760000007600000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000770000007700000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003100380030000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000007800000078000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f00500072005f005f0067007500690064005f005f005f003100360043004500360032003900360000000000000000000000c4020000000079000000790000007800000008000000011fce1e401fce1e0000000000000000ad0700000000007a0000007a000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0063007500730074006f006d005f00570065005f005f0067007500690064005f005f005f003600320035004100390041003500370000000000000000000000c402000000007b0000007b0000007a00000008000000011fce1ec01fce1e0000000000000000ad0700000000007c0000007c00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000007d0000007d000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f006c0075005f0053005f005f0067007500690064005f005f005f003700440030004500390030003900330000000000000000000000c402000000007e0000007e0000007d00000008000000011ece1ec01ece1e0000000000000000ad0700000000007f0000007f00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000800000008000000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000810000008100000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c0032003100360030000000820000008200000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000008300000083000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f006c0075005f0057005f005f0067007500690064005f005f005f003500310033003000300045003500350000000000000000000000c4020000000084000000840000008300000008000000011ece1e401ece1e0000000000000000ad0700000000008500000085000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f006c0075005f0057005f005f0067007500690064005f005f005f003500320032003400330032003800450000000000000000000000c4020000000086000000860000008500000008000000011dce1e801dce1e0000000000000000ad070000000000870000008700000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000008800000088000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f003700390033004400460046004100460000000000000000000000c4020000000089000000890000008800000008000000011cce1e001cce1e0000000000000000ad0700000000008a0000008a00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0033003400300038000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000008b0000008b000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f003700350036004400360045004300420000000000000000000000c402000000008c0000008c0000008b00000008000000011dce1e401dce1e0000000000000000ad0700000000008d0000008d00000000000000000000000000000000000000d00200000600280000004100630074006900760065005400610062006c00650056006900650077004d006f006400650000000100000008000400000031000000200000005400610062006c00650056006900650077004d006f00640065003a00300000000100000008003a00000034002c0030002c003200380034002c0030002c0032003900360034002c0031002c0032003400320034002c0035002c0031003600320030000000200000005400610062006c00650056006900650077004d006f00640065003a00310000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900300034000000200000005400610062006c00650056006900650077004d006f00640065003a00320000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00330000000100000008001e00000032002c0030002c003200380034002c0030002c0032003900360034000000200000005400610062006c00650056006900650077004d006f00640065003a00340000000100000008003e00000034002c0030002c003200380034002c0030002c0032003900360034002c00310032002c0033003500300034002c00310031002c00320031003600300000008e0000008e000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f0057006500610070005f005f0067007500690064005f005f005f003700320039003100300032003200300000000000000000000000c402000000008f0000008f0000008e000000080000000120ce1e0020ce1e0000000000000000ad0700000000009000000090000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f0057006500610070005f005f0067007500690064005f005f005f003700300041003800420039004100450000000000000000000000c40200000000910000009100000090000000080000000119ce1e0019ce1e0000000000000000ad0700000000009200000092000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f0057006500610070005f005f0067007500690064005f005f005f003700310039004300440044004500370000000000000000000000c4020000000093000000930000009200000008000000011ace1ec01ace1e0000000000000000ad0700000000009400000094000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f006d006f006e005f0072006c005f004d006f005f005f0067007500690064005f005f005f003100430038003700330042004500430000000000000000000000c4020000000095000000950000009400000008000000011dce1e001dce1e0000000000000000ad0700000000009600000096000000000000004e000000011f0c5e01000000640062006f00000046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f003700360036003100390033003000340000000000000000000000c4020000000097000000970000009600000008000000011cce1e801cce1e0000000000000000ad0700000000009800000098000000000000004e000000011eff7301000000640062006f00000046004b005f005f0077006500610070005f0072006c005f0057005f005f0067007500690064005f005f005f003700410033003200320033004500380000000000000000000000c40200000000990000009900000098000000080000000119ce1ec019ce1e0000000000000000ad07000000000009010000060000000100000005000000730000006a0000000900000001000000080000002c0000002d0000000300000002000000010000002c0000002d0000000c0000000b000000080000002d0000002c0000000f0000000e00000005000000250000002c0000001c0000000e0000001b0000006600000067000000230000000e000000200000002c0000002d000000340000000e000000330000005800000083000000880000000e000000870000002b0000002c0000001400000011000000130000002f0000002c0000002a00000011000000290000006f000000680000002d000000110000002c000000290000002c00000030000000110000002f0000002e0000002d000000420000001100000041000000280000002d00000056000000110000004900000056000000010000002600000012000000250000006b0000006600000060000000160000005f000000580000007b00000065000000170000006400000058000000570000001e000000180000001b00000067000000660000006a00000018000000690000002d0000002c0000004400000019000000410000002d0000002c0000007200000019000000710000002c0000002d000000210000001a000000200000002d0000002c0000004c0000002800000049000000590000009a0000007d000000280000007c0000002d0000002c0000003600000033000000320000006f0000006a000000390000003800000032000000720000006b0000003b00000038000000280000002d0000002c00000090000000380000008d00000073000000740000003f0000003d0000003e0000002d0000002c0000005d000000460000005800000058000000830000005b000000470000005800000058000000590000004a00000048000000490000002c000000310000004e00000049000000200000006b0000006a00000050000000490000003e00000065000000660000005200000049000000250000002b0000002c000000540000004900000008000000770000006a00000062000000490000005f000000580000007b0000006700000049000000640000002c0000002d0000006c000000490000006900000071000000660000006f000000490000006e0000009a000000590000007400000049000000710000009a00000059000000590000005800000049000000590000009a0000007800000077000000710000002d0000002c0000007a00000077000000330000002c0000002d00000092000000770000008d000000670000007a000000830000007f00000082000000000000000f00000085000000800000008200000057000000000000008b000000810000008a0000002d0000002c0000008e000000820000008d0000005800000093000000940000008d0000006e0000002d0000002c000000960000008d0000008a0000007700000066000000980000008d000000870000009300000058000000000000000000000000000000007200760065007200430065007200740069006600690063006100740065003d0054007200750065003b005000610063006b00650074002000530069007a0065003d0034003000390036003b004100700070006c00690063006100740069006f006e0020004e0061006d0065003d0022004d006900630072006f0073006f00660074002000530051004c00200053006500720076006500720020004d0061006e006100670065006d0065006e0074002000530074007500640069006f002200000000800500360000004d006f006e0073007400650072005f004200750069006c006400650072005f00440042005f004400690061006700720061006d000000000226001800000077006500610070005f0057006500610070006f006e00000008000000640062006f000000000226003600000077006500610070005f0072006c005f0057006500610070006f006e005f0057006500610070006f006e0054007200610069007400000008000000640062006f000000000226003800000077006500610070005f0072006c005f0057006500610070006f006e005f004100620069006c00690074007900530063006f0072006500000008000000640062006f000000000226002600000077006500610070005f006c0075005f0057006500610070006f006e005400790070006500000008000000640062006f000000000226002800000077006500610070005f006c0075005f0057006500610070006f006e0054007200610069007400000008000000640062006f000000000226002800000077006500610070005f006c0075005f0057006500610070006f006e0052006500610063006800000008000000640062006f000000000226002c00000077006500610070005f006c0075005f0053006b0069006c006c0052006500710075006900720065006400000008000000640062006f000000000226003000000077006500610070005f006c0075005f00530069007a0065005f0057006500610070006f006e004400690063006500000008000000640062006f000000000226002600000077006500610070005f006c0075005f00440061006d006100670065005400790070006500000008000000640062006f0000000002260020000000540045004d0050005f004d006f006e0073007400650072005f0043005200000008000000640062006f00000000022600240000006d006f006e005f0072006c005f00500072006f00740065006300740069006f006e00000008000000640062006f000000000226002c0000006d006f006e005f0072006c005f004d006f006e0073007400650072005f0057006500610070006f006e00000008000000640062006f000000000226002a0000006d006f006e005f0072006c005f004d006f006e0073007400650072005f0053006b0069006c006c00000008000000640062006f000000000226002c0000006d006f006e005f0072006c005f004d006f006e0073007400650072005f00530065006e00730065007300000008000000640062006f00000000022600300000006d006f006e005f0072006c005f004d006f006e0073007400650072005f004d006f00760065006d0065006e007400000008000000640062006f00000000022600220000006d006f006e005f0072006c005f0041006c00690067006e006d0065006e007400000008000000640062006f00000000022600180000006d006f006e005f004d006f006e007300740065007200000008000000640062006f00000000022600180000006d006f006e005f006c0075005f005400790070006500000008000000640062006f00000000022600240000006d006f006e005f006c0075005f004c0061007700660075006c006e00650073007300000008000000640062006f00000000022600200000006d006f006e005f006c0075005f0047006f006f0064006e00650073007300000008000000640062006f0000000002260034000000680070005f00500072006f00740065006300740069006f006e005f00430052005f004d006f00640069006600690065007200000008000000640062006f000000000226003600000066006500610074007500720065005f0072006c005f004d006f006e0073007400650072005f004600650061007400750072006500000008000000640062006f000000000226002600000066006500610074007500720065005f006c0075005f004600650061007400750072006500000008000000640062006f000000000226001400000064006900630065005f004400690063006500000008000000640062006f000000000226002a00000063007500730074006f006d005f0057006500610070006f006e005f00410074007400610063006b00000008000000640062006f000000000226002600000063007500730074006f006d005f00410074007400610063006b005f004400690063006500000008000000640062006f000000000226003200000063006f00720065005f006c0075005f004f006600660065006e0073006900760065005f00560061006c00750065007300000008000000640062006f000000000226003200000063006f00720065005f006c0075005f0044006500660065006e0073006900760065005f00560061006c00750065007300000008000000640062006f000000000226002e00000063006f00720065005f006c0075005f00430052005f00500072006f00660069006300690065006e0063007900000008000000640062006f000000000226001200000063006f006d005f00530069007a006500000008000000640062006f000000000226003000000063006f006d005f0072006c005f004d006f006e0073007400650072005f004c0061006e0067007500610067006500000008000000640062006f000000000226003800000063006f006d005f0072006c005f004d006f006e0073007400650072005f004100620069006c00690074007900530063006f0072006500000008000000640062006f000000000226003400000063006f006d005f0072006c005f004100620069006c00690074007900530063006f00720065005f0053006b0069006c006c00000008000000640062006f000000000226003a00000063006f006d005f0072006c005f004100620069006c00690074007900530063006f00720065005f004d006f00640069006600690065007200000008000000640062006f000000000226003200000063006f006d005f00500072006f00740065006300740069006f006e00460072006f006d00440061006d00610067006500000008000000640062006f000000000226001a00000063006f006d005f006c0075005f0053006b0069006c006c00000008000000640062006f000000000226001c00000063006f006d005f006c0075005f00530065006e00730065007300000008000000640062006f000000000226002000000063006f006d005f006c0075005f004d006f00760065006d0065006e007400000008000000640062006f000000000226002400000063006f006d005f006c0075005f00410072006d006f00720043006c00610073007300000008000000640062006f000000000226001a00000063006f006d005f004c0061006e0067007500610067006500000008000000640062006f000000000226000e00000063006f006d005f0043005200000008000000640062006f000000000226002200000063006f006d005f004100620069006c00690074007900530063006f0072006500000008000000640062006f0000000002260016000000610072006d005f0053006800690065006c006400000008000000640062006f000000000226002a000000610072006d005f0072006c005f004d006f006e0073007400650072005f00410072006d006f007200000008000000640062006f0000000002260024000000610072006d005f0072006c005f00410043004d006f00640069006600690065007200000008000000640062006f0000000002260022000000610072006d005f006c0075005f00410072006d006f0072005400790070006500000008000000640062006f0000000002240014000000610072006d005f00410072006d006f007200000008000000640062006f00000001000000d68509b3bb6bf2459ab8371664f0327008004e0000007b00310036003300340043004400440037002d0030003800380038002d0034003200450033002d0039004600410032002d004200360044003300320035003600330042003900310044007d0000000000000000000000000000000000000000000000000000000000000000000000000000000000010003000000000000000c0000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000062885214');


--
-- TOC entry 3174 (class 0 OID 25079)
-- Dependencies: 236
-- Data for Name: temp_monster_cr; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3175 (class 0 OID 25082)
-- Dependencies: 237
-- Data for Name: weap_lu_damagetype; Type: TABLE DATA; Schema: public; Owner: postgres
--
/*
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('2709fd0a-c030-4290-ba76-3d73e5477726', 'Tadiant');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('99a54ee7-bd10-437c-b09a-468f9c98f301', 'Tecrotic');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('3a1a49f6-88dc-4d72-98ad-50a513efccec', 'Tludgeoning');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('92e7e998-feb1-4152-b744-6f0b416c3493', 'Tlashing');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('3d7578c1-d5a9-433d-bbd8-76ab6166e6ea', 'Tightning');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('c265c3b8-b1b8-4cba-ab6d-8844fea83e9c', 'Told');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('9620adc9-c1f8-43e3-900f-9a83c881291d', 'Tire');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('c89d508f-9557-46e2-b037-9c99d954e2cc', 'Toison');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('6e7cb455-5e2f-4419-a525-9f9f1fa7bf5c', 'Torce');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('175fbca2-0919-47b6-88b7-ba1a22880a6d', 'Thunder');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('88018808-853f-41df-872a-c37df135a51d', 'Tcid');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('fb41f73b-deef-4cf8-b0ad-dc952284c234', 'Tiercing');
INSERT INTO weap_lu_damagetype (guid_damagetype, name_damagetype) VALUES ('39500d27-976d-487d-baa0-eff64dcc7fbd', 'Tsychic');


--
-- TOC entry 3176 (class 0 OID 25087)
-- Dependencies: 238
-- Data for Name: weap_lu_size_weapondice; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_lu_size_weapondice (guid_size, size_die_multiplier) VALUES ('a4d28780-e894-4d7a-b065-1cb00ee01d80', 1);
INSERT INTO weap_lu_size_weapondice (guid_size, size_die_multiplier) VALUES ('5e6048f6-e0ec-4bb1-9065-2116230246ff', 4);
INSERT INTO weap_lu_size_weapondice (guid_size, size_die_multiplier) VALUES ('2ef6d926-9d94-46d6-9f4d-6b14321d7d2e', 1);
INSERT INTO weap_lu_size_weapondice (guid_size, size_die_multiplier) VALUES ('c64a7d4b-30cd-4eee-a276-dbbde28daa21', 1);
INSERT INTO weap_lu_size_weapondice (guid_size, size_die_multiplier) VALUES ('5d0ff0c0-6053-476e-a423-df63946be45e', 2);
INSERT INTO weap_lu_size_weapondice (guid_size, size_die_multiplier) VALUES ('a9404107-c146-4e4f-ac83-f1b5df09bed7', 3);


--
-- TOC entry 3177 (class 0 OID 25092)
-- Dependencies: 239
-- Data for Name: weap_lu_skillrequired; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_lu_skillrequired (guid_skill, name_skilllevel) VALUES ('4c205a9f-503e-416a-92f0-9f598bbf7f15', 'Timple');
INSERT INTO weap_lu_skillrequired (guid_skill, name_skilllevel) VALUES ('7104d202-4ca3-45d2-9c30-eb31894d3a52', 'Tartial');


--
-- TOC entry 3178 (class 0 OID 25097)
-- Dependencies: 240
-- Data for Name: weap_lu_weaponreach; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_lu_weaponreach (guid_reach, name_reach) VALUES ('2bd15ddb-2765-4433-8002-0fb80f1289bc', 'Tanged');
INSERT INTO weap_lu_weaponreach (guid_reach, name_reach) VALUES ('434fb0a8-b9b7-4dda-acbc-984b12f2c9fd', 'Telee');


--
-- TOC entry 3179 (class 0 OID 25102)
-- Dependencies: 241
-- Data for Name: weap_lu_weapontrait; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('e915bf4a-0b59-45e3-8086-074c874c4f7a', 'Teach');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('7359aa0d-2e9f-4f97-9ea5-126b09dd82b8', 'Tmmunition (range 25/100)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('7a8be51f-f543-4942-9585-14fdec3fb04c', 'Tmmunition (range 80/320)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', 'Teavy');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', 'Toading');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('2b40ddae-84e2-4e8a-b935-52384d3e82fd', 'Tersitile (1d10)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', 'Thrown (range 20/60)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('ee72411c-44b2-49f0-94ce-7fa89bcd018f', 'Thrown (range 5/15)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('c44fd3ff-53ac-4317-87cc-8f260d95362d', 'Tmmunition (range 100/400)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', 'Tinesse');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('74dc2e9c-618f-4fbb-8ce7-98e1aff82989', 'Thrown (range 30/120)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', 'Tight');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('fa6c7360-1928-4f89-a03f-c45641b26861', 'Tmmunition (range 150/600)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('33104808-7332-49d7-8484-d22cc3c5f6bc', 'Tpecial');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', 'Two-handed');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('ae941ebd-4a84-44ef-8909-d84351a125c9', 'Tersitile (1d8)');
INSERT INTO weap_lu_weapontrait (guid_trait, name_trait) VALUES ('d68eaf40-d77b-43a1-94aa-f9583ce3b47c', 'Tmmunition (range 30/120)');


--
-- TOC entry 3180 (class 0 OID 25107)
-- Dependencies: 242
-- Data for Name: weap_lu_weapontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_lu_weapontype (guid_weapontype, guid_skill, guid_reach, name_weapontype) VALUES ('a1d546e2-6fef-4ea0-bee8-2e0b86931559', '4c205a9f-503e-416a-92f0-9f598bbf7f15', '2bd15ddb-2765-4433-8002-0fb80f1289bc', 'Timple Ranged');
INSERT INTO weap_lu_weapontype (guid_weapontype, guid_skill, guid_reach, name_weapontype) VALUES ('95a8beda-1efc-4b5f-aa66-346c93c5023d', '4c205a9f-503e-416a-92f0-9f598bbf7f15', '434fb0a8-b9b7-4dda-acbc-984b12f2c9fd', 'Timple Melee');
INSERT INTO weap_lu_weapontype (guid_weapontype, guid_skill, guid_reach, name_weapontype) VALUES ('93f486b6-c2a0-40d1-9da4-63cad316b763', '7104d202-4ca3-45d2-9c30-eb31894d3a52', '2bd15ddb-2765-4433-8002-0fb80f1289bc', 'Tartial Ranged');
INSERT INTO weap_lu_weapontype (guid_weapontype, guid_skill, guid_reach, name_weapontype) VALUES ('fab735a6-8c18-486a-a058-c6bf42884512', '7104d202-4ca3-45d2-9c30-eb31894d3a52', '434fb0a8-b9b7-4dda-acbc-984b12f2c9fd', 'Tartial Melee');


--
-- TOC entry 3181 (class 0 OID 25115)
-- Dependencies: 243
-- Data for Name: weap_rl_weapon_abilityscore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'fd25a437-79b3-47ce-b7a0-04b7aa40c061');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '1cfcd5a0-60df-43c5-99c8-152caeb08a6c');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '6e439074-d840-4ef7-a61b-1bb8402f3a9d');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '15e826d7-591d-4550-979b-25df20fec7a7');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'cbcdb66c-2985-40a7-a4f2-317d3b10e224');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '1af9dba1-261f-47a0-ae91-349766bb5846');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'd900f107-d4f5-48cb-b23f-3ea977f4502b');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '9f49f128-f692-4f76-84de-53a32db82b3c');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'f6953406-2767-4c4d-9c6b-597344b8162f');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '80e1e0f5-70e3-4eb6-897d-59ae929539a1');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '3a1accd9-9305-4501-ae82-6211b36f96d8');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '349c6055-11fb-4100-9fef-68328cb14d2a');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'c6fa2adf-1887-433b-9ee9-71a296a4fc1e');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'a9b8343d-ae8f-4bc7-baf5-74c36fe5cfa3');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '7dab5339-bc4c-4141-b5e6-7d3f420d6396');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'ebf21478-2150-4d74-a547-a1bd7001106f');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'a30ecf65-6cdc-4133-a9d5-a29feb674d9b');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '8786c3e4-1169-4132-8389-a9471318003c');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '82a08381-8847-4362-a221-ae01fb9a5f3e');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '61978a5d-c69e-4466-9048-be0c50abf97f');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '5a2fb915-4d8c-4a25-b3dd-d029d9266219');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '6569316a-fc7a-40e6-b93e-d72d28d92aa0');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '02de9c62-da40-499b-9a76-da49ad8eeb0d');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '30039481-56bb-4ec4-a578-de7289d634ae');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '33eb22b3-67e6-42f4-954b-e473840826b2');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', '5c6241a0-716a-430a-8854-f7b5c8ce74e8');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'd27ab717-2f71-4b66-b67d-f86822b630db');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', 'be84879a-bc83-4746-90fe-fe4c413fdb76');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '4c82364c-f6e6-492d-8f59-22579051aa8c');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '613297ea-ac74-40ef-bd79-2c3ad858a9f2');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'f3496bec-3de1-453b-b0e6-317f99401ecd');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '4d49c0b3-53ba-47f5-9c61-5d3da6c6f375');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '349c6055-11fb-4100-9fef-68328cb14d2a');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '6c318ddd-2dc2-4e5d-87d1-9621afdadf02');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '5a2fb915-4d8c-4a25-b3dd-d029d9266219');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '02de9c62-da40-499b-9a76-da49ad8eeb0d');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '8c558f4c-f4a9-4cd5-a52a-de21a9009154');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', '0e337194-078c-4f99-a339-e7e311a2bdc4');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'd27ab717-2f71-4b66-b67d-f86822b630db');
INSERT INTO weap_rl_weapon_abilityscore (guid_abilityscore, guid_weapon) VALUES ('6c49abc6-06f1-436a-a046-f50e9cc93808', 'be84879a-bc83-4746-90fe-fe4c413fdb76');


--
-- TOC entry 3182 (class 0 OID 25120)
-- Dependencies: 244
-- Data for Name: weap_rl_weapon_weapontrait; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('e915bf4a-0b59-45e3-8086-074c874c4f7a', '58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('e915bf4a-0b59-45e3-8086-074c874c4f7a', '7dab5339-bc4c-4141-b5e6-7d3f420d6396');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('e915bf4a-0b59-45e3-8086-074c874c4f7a', 'a30ecf65-6cdc-4133-a9d5-a29feb674d9b');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('e915bf4a-0b59-45e3-8086-074c874c4f7a', '61978a5d-c69e-4466-9048-be0c50abf97f');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('e915bf4a-0b59-45e3-8086-074c874c4f7a', '5a2fb915-4d8c-4a25-b3dd-d029d9266219');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7359aa0d-2e9f-4f97-9ea5-126b09dd82b8', '8c558f4c-f4a9-4cd5-a52a-de21a9009154');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7a8be51f-f543-4942-9585-14fdec3fb04c', '4c82364c-f6e6-492d-8f59-22579051aa8c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7a8be51f-f543-4942-9585-14fdec3fb04c', 'f3496bec-3de1-453b-b0e6-317f99401ecd');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '9f49f128-f692-4f76-84de-53a32db82b3c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '80e1e0f5-70e3-4eb6-897d-59ae929539a1');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '4d49c0b3-53ba-47f5-9c61-5d3da6c6f375');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '7dab5339-bc4c-4141-b5e6-7d3f420d6396');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '6c318ddd-2dc2-4e5d-87d1-9621afdadf02');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', 'a30ecf65-6cdc-4133-a9d5-a29feb674d9b');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('8ced51fc-d785-40f7-8d88-2cbd93939634', '8786c3e4-1169-4132-8389-a9471318003c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', 'f3496bec-3de1-453b-b0e6-317f99401ecd');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', '6c318ddd-2dc2-4e5d-87d1-9621afdadf02');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', '8c558f4c-f4a9-4cd5-a52a-de21a9009154');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', '0e337194-078c-4f99-a339-e7e311a2bdc4');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('2b40ddae-84e2-4e8a-b935-52384d3e82fd', '15e826d7-591d-4550-979b-25df20fec7a7');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('2b40ddae-84e2-4e8a-b935-52384d3e82fd', '1af9dba1-261f-47a0-ae91-349766bb5846');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('2b40ddae-84e2-4e8a-b935-52384d3e82fd', 'f6953406-2767-4c4d-9c6b-597344b8162f');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', 'fd25a437-79b3-47ce-b7a0-04b7aa40c061');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', '6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', '3a1accd9-9305-4501-ae82-6211b36f96d8');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', '82a08381-8847-4362-a221-ae01fb9a5f3e');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', '02de9c62-da40-499b-9a76-da49ad8eeb0d');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d9e00792-a5cc-4136-b9ba-650c19b4af67', '5c6241a0-716a-430a-8854-f7b5c8ce74e8');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('ee72411c-44b2-49f0-94ce-7fa89bcd018f', '1cfcd5a0-60df-43c5-99c8-152caeb08a6c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('c44fd3ff-53ac-4317-87cc-8f260d95362d', '6c318ddd-2dc2-4e5d-87d1-9621afdadf02');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', '6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', '349c6055-11fb-4100-9fef-68328cb14d2a');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', '5a2fb915-4d8c-4a25-b3dd-d029d9266219');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', '02de9c62-da40-499b-9a76-da49ad8eeb0d');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', 'd27ab717-2f71-4b66-b67d-f86822b630db');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('a8075fec-9f18-4f66-bf36-962eedee2fb6', 'be84879a-bc83-4746-90fe-fe4c413fdb76');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('74dc2e9c-618f-4fbb-8ce7-98e1aff82989', '6e439074-d840-4ef7-a61b-1bb8402f3a9d');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', '6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', 'd900f107-d4f5-48cb-b23f-3ea977f4502b');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', '3a1accd9-9305-4501-ae82-6211b36f96d8');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', '349c6055-11fb-4100-9fef-68328cb14d2a');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', '33eb22b3-67e6-42f4-954b-e473840826b2');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', '0e337194-078c-4f99-a339-e7e311a2bdc4');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', '5c6241a0-716a-430a-8854-f7b5c8ce74e8');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7e3888e5-4326-4c30-be4f-9c6e631b350a', 'd27ab717-2f71-4b66-b67d-f86822b630db');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('fa6c7360-1928-4f89-a03f-c45641b26861', '4d49c0b3-53ba-47f5-9c61-5d3da6c6f375');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('33104808-7332-49d7-8484-d22cc3c5f6bc', '1cfcd5a0-60df-43c5-99c8-152caeb08a6c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('33104808-7332-49d7-8484-d22cc3c5f6bc', '61978a5d-c69e-4466-9048-be0c50abf97f');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '4c82364c-f6e6-492d-8f59-22579051aa8c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', 'f3496bec-3de1-453b-b0e6-317f99401ecd');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '9f49f128-f692-4f76-84de-53a32db82b3c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '80e1e0f5-70e3-4eb6-897d-59ae929539a1');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '4d49c0b3-53ba-47f5-9c61-5d3da6c6f375');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '7dab5339-bc4c-4141-b5e6-7d3f420d6396');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '6c318ddd-2dc2-4e5d-87d1-9621afdadf02');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', 'ebf21478-2150-4d74-a547-a1bd7001106f');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', 'a30ecf65-6cdc-4133-a9d5-a29feb674d9b');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', '8786c3e4-1169-4132-8389-a9471318003c');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('ae941ebd-4a84-44ef-8909-d84351a125c9', 'fd25a437-79b3-47ce-b7a0-04b7aa40c061');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('ae941ebd-4a84-44ef-8909-d84351a125c9', 'c6fa2adf-1887-433b-9ee9-71a296a4fc1e');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('ae941ebd-4a84-44ef-8909-d84351a125c9', '82a08381-8847-4362-a221-ae01fb9a5f3e');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d68eaf40-d77b-43a1-94aa-f9583ce3b47c', '613297ea-ac74-40ef-bd79-2c3ad858a9f2');
INSERT INTO weap_rl_weapon_weapontrait (guid_trait, guid_weapon) VALUES ('d68eaf40-d77b-43a1-94aa-f9583ce3b47c', '0e337194-078c-4f99-a339-e7e311a2bdc4');


--
-- TOC entry 3183 (class 0 OID 25125)
-- Dependencies: 245
-- Data for Name: weap_weapon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('fd25a437-79b3-47ce-b7a0-04b7aa40c061', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tpear');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('1cfcd5a0-60df-43c5-99c8-152caeb08a6c', NULL, NULL, '93f486b6-c2a0-40d1-9da4-63cad316b763', 0, 'Tet');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0', 'e01bf86f-0ff3-4cf7-897f-a185afb33c54', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tike');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('6e439074-d840-4ef7-a61b-1bb8402f3a9d', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tavelin');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('4c82364c-f6e6-492d-8f59-22579051aa8c', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, 'Thortbow');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('15e826d7-591d-4550-979b-25df20fec7a7', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', '3a1a49f6-88dc-4d72-98ad-50a513efccec', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tarhammer');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('613297ea-ac74-40ef-bd79-2c3ad858a9f2', '1ff5257c-1568-49c1-a656-088b4884efc0', '3a1a49f6-88dc-4d72-98ad-50a513efccec', 'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, 'Tling');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb', '1ff5257c-1568-49c1-a656-088b4884efc0', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tagger');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('cbcdb66c-2985-40a7-a4f2-317d3b10e224', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', '3a1a49f6-88dc-4d72-98ad-50a513efccec', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tace');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('f3496bec-3de1-453b-b0e6-317f99401ecd', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, 'Trossbow, Light');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('1af9dba1-261f-47a0-ae91-349766bb5846', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tongsword');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('d900f107-d4f5-48cb-b23f-3ea977f4502b', '1ff5257c-1568-49c1-a656-088b4884efc0', '3a1a49f6-88dc-4d72-98ad-50a513efccec', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tlub');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('9f49f128-f692-4f76-84de-53a32db82b3c', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', '3a1a49f6-88dc-4d72-98ad-50a513efccec', 'fab735a6-8c18-486a-a058-c6bf42884512', 2, 'Taul');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('f6953406-2767-4c4d-9c6b-597344b8162f', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tattleaxe');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('80e1e0f5-70e3-4eb6-897d-59ae929539a1', 'c4d1ecfa-f454-45cf-be70-cf784baf834f', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Treataxe');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('4d49c0b3-53ba-47f5-9c61-5d3da6c6f375', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '93f486b6-c2a0-40d1-9da4-63cad316b763', 1, 'Tongbow');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('3a1accd9-9305-4501-ae82-6211b36f96d8', '1ff5257c-1568-49c1-a656-088b4884efc0', '3a1a49f6-88dc-4d72-98ad-50a513efccec', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tight Hammer');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('349c6055-11fb-4100-9fef-68328cb14d2a', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Thortsword');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('c6fa2adf-1887-433b-9ee9-71a296a4fc1e', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', '3a1a49f6-88dc-4d72-98ad-50a513efccec', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tuarterstaff');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('a9b8343d-ae8f-4bc7-baf5-74c36fe5cfa3', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', '3a1a49f6-88dc-4d72-98ad-50a513efccec', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tlail');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('7dab5339-bc4c-4141-b5e6-7d3f420d6396', 'e01bf86f-0ff3-4cf7-897f-a185afb33c54', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Talberd');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('6c318ddd-2dc2-4e5d-87d1-9621afdadf02', 'e01bf86f-0ff3-4cf7-897f-a185afb33c54', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '93f486b6-c2a0-40d1-9da4-63cad316b763', 1, 'Trossbow, heavy');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('ebf21478-2150-4d74-a547-a1bd7001106f', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', '3a1a49f6-88dc-4d72-98ad-50a513efccec', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Treatclub');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('a30ecf65-6cdc-4133-a9d5-a29feb674d9b', 'e01bf86f-0ff3-4cf7-897f-a185afb33c54', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tlaive');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('8786c3e4-1169-4132-8389-a9471318003c', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 2, 'Treatsword');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('82a08381-8847-4362-a221-ae01fb9a5f3e', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Trident');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('61978a5d-c69e-4466-9048-be0c50abf97f', 'c4d1ecfa-f454-45cf-be70-cf784baf834f', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tance');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('5a2fb915-4d8c-4a25-b3dd-d029d9266219', '1ff5257c-1568-49c1-a656-088b4884efc0', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Thip');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('6569316a-fc7a-40e6-b93e-d72d28d92aa0', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Torningstar');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('02de9c62-da40-499b-9a76-da49ad8eeb0d', '1ff5257c-1568-49c1-a656-088b4884efc0', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, 'Tart');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('8c558f4c-f4a9-4cd5-a52a-de21a9009154', 'bd31d66d-3731-45bb-88b2-dbf1acfa6e98', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '93f486b6-c2a0-40d1-9da4-63cad316b763', 1, 'Tlowgun');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('30039481-56bb-4ec4-a578-de7289d634ae', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tar Pick');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('33eb22b3-67e6-42f4-954b-e473840826b2', '1ff5257c-1568-49c1-a656-088b4884efc0', '92e7e998-feb1-4152-b744-6f0b416c3493', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tickle');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('0e337194-078c-4f99-a339-e7e311a2bdc4', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', '93f486b6-c2a0-40d1-9da4-63cad316b763', 1, 'Trossbow, hand');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('5c6241a0-716a-430a-8854-f7b5c8ce74e8', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', '92e7e998-feb1-4152-b744-6f0b416c3493', '95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, 'Tandaxe');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('d27ab717-2f71-4b66-b67d-f86822b630db', '04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', '92e7e998-feb1-4152-b744-6f0b416c3493', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tcimitar');
INSERT INTO weap_weapon (guid_weapon, guid_die, guid_damagetype, guid_weapontype, number_damagedice, name_weapon) VALUES ('be84879a-bc83-4746-90fe-fe4c413fdb76', '32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 'fb41f73b-deef-4cf8-b0ad-dc952284c234', 'fab735a6-8c18-486a-a058-c6bf42884512', 1, 'Tapier');

*/
--
-- TOC entry 3195 (class 0 OID 0)
-- Dependencies: 234
-- Name: sysdiagrams_diagram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sysdiagrams_diagram_id_seq', 1, true);


--
-- TOC entry 2866 (class 2606 OID 24875)
-- Name: arm_armor pk__arm_armo__34a2d127f5baba27; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_armor
    ADD CONSTRAINT pk__arm_armo__34a2d127f5baba27 PRIMARY KEY (guid_armor);


--
-- TOC entry 2870 (class 2606 OID 24885)
-- Name: arm_rl_acmodifier pk__arm_rl_a__dc9c14277601af68; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_rl_acmodifier
    ADD CONSTRAINT pk__arm_rl_a__dc9c14277601af68 PRIMARY KEY (guid_armor, guid_abilityscore);


--
-- TOC entry 2872 (class 2606 OID 24890)
-- Name: arm_shield pk__arm_shie__27b11815c39e1f73; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_shield
    ADD CONSTRAINT pk__arm_shie__27b11815c39e1f73 PRIMARY KEY (guid_shield);


--
-- TOC entry 2874 (class 2606 OID 24895)
-- Name: com_abilityscore pk__com_abil__83ec500f6e24c5d9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_abilityscore
    ADD CONSTRAINT pk__com_abil__83ec500f6e24c5d9 PRIMARY KEY (guid_abilityscore);


--
-- TOC entry 2876 (class 2606 OID 24900)
-- Name: com_cr pk__com_cr__a73fe9a72590b126; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_cr
    ADD CONSTRAINT pk__com_cr__a73fe9a72590b126 PRIMARY KEY (guid_cr);


--
-- TOC entry 2878 (class 2606 OID 24905)
-- Name: com_language pk__com_lang__2e15b36cf2af8b24; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_language
    ADD CONSTRAINT pk__com_lang__2e15b36cf2af8b24 PRIMARY KEY (guid_language);


--
-- TOC entry 2880 (class 2606 OID 24910)
-- Name: com_lu_armorclass pk__com_lu_a__a73fe9a7907f4aab; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_lu_armorclass
    ADD CONSTRAINT pk__com_lu_a__a73fe9a7907f4aab PRIMARY KEY (guid_cr);


--
-- TOC entry 2882 (class 2606 OID 24915)
-- Name: com_lu_movement pk__com_lu_m__309c977ead073562; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_lu_movement
    ADD CONSTRAINT pk__com_lu_m__309c977ead073562 PRIMARY KEY (guid_movement);


--
-- TOC entry 2886 (class 2606 OID 24925)
-- Name: com_lu_skill pk__com_lu_s__65d5cef10974e2e9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_lu_skill
    ADD CONSTRAINT pk__com_lu_s__65d5cef10974e2e9 PRIMARY KEY (guid_skill);


--
-- TOC entry 2884 (class 2606 OID 24920)
-- Name: com_lu_senses pk__com_lu_s__b53d0d39cb07a3f6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_lu_senses
    ADD CONSTRAINT pk__com_lu_s__b53d0d39cb07a3f6 PRIMARY KEY (guid_sense);


--
-- TOC entry 2888 (class 2606 OID 24930)
-- Name: com_protectionfromdamage pk__com_prot__2283826e3a900b34; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_protectionfromdamage
    ADD CONSTRAINT pk__com_prot__2283826e3a900b34 PRIMARY KEY (guid_protection);


--
-- TOC entry 2892 (class 2606 OID 24940)
-- Name: com_rl_abilityscore_skill pk__com_rl_a__85b10ce0b425f32a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_abilityscore_skill
    ADD CONSTRAINT pk__com_rl_a__85b10ce0b425f32a PRIMARY KEY (guid_abilityscore, guid_skill);


--
-- TOC entry 2890 (class 2606 OID 24935)
-- Name: com_rl_abilityscore_modifier pk__com_rl_a__dcee16dbd24389ae; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_abilityscore_modifier
    ADD CONSTRAINT pk__com_rl_a__dcee16dbd24389ae PRIMARY KEY (value_abilityscore);


--
-- TOC entry 2894 (class 2606 OID 24945)
-- Name: com_rl_monster_abilityscore pk__com_rl_m__d403cd5f744047ce; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_abilityscore
    ADD CONSTRAINT pk__com_rl_m__d403cd5f744047ce PRIMARY KEY (guid_monster, guid_abilityscore);


--
-- TOC entry 2896 (class 2606 OID 24950)
-- Name: com_rl_monster_language pk__com_rl_m__eedc53697ef2c48f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_language
    ADD CONSTRAINT pk__com_rl_m__eedc53697ef2c48f PRIMARY KEY (guid_monster, guid_language);


--
-- TOC entry 2898 (class 2606 OID 24955)
-- Name: com_size pk__com_size__689769921b0f7794; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_size
    ADD CONSTRAINT pk__com_size__689769921b0f7794 PRIMARY KEY (guid_size);


--
-- TOC entry 2900 (class 2606 OID 24960)
-- Name: core_lu_cr_proficiency pk__core_lu___a73fe9a756d67fee; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY core_lu_cr_proficiency
    ADD CONSTRAINT pk__core_lu___a73fe9a756d67fee PRIMARY KEY (guid_cr);


--
-- TOC entry 2902 (class 2606 OID 24965)
-- Name: core_lu_defensive_values pk__core_lu___a73fe9a76c95e6e3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY core_lu_defensive_values
    ADD CONSTRAINT pk__core_lu___a73fe9a76c95e6e3 PRIMARY KEY (guid_cr);


--
-- TOC entry 2904 (class 2606 OID 24970)
-- Name: core_lu_offensive_values pk__core_lu___a73fe9a7ffdd80e9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY core_lu_offensive_values
    ADD CONSTRAINT pk__core_lu___a73fe9a7ffdd80e9 PRIMARY KEY (guid_cr);


--
-- TOC entry 2906 (class 2606 OID 24975)
-- Name: custom_attack_dice pk__custom_a__a04e28cd79955e18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_attack_dice
    ADD CONSTRAINT pk__custom_a__a04e28cd79955e18 PRIMARY KEY (guid_die, guid_custom_attack);


--
-- TOC entry 2908 (class 2606 OID 24980)
-- Name: custom_weapon_attack pk__custom_w__629cd860b13803cf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_weapon_attack
    ADD CONSTRAINT pk__custom_w__629cd860b13803cf PRIMARY KEY (guid_custom_attack);


--
-- TOC entry 2910 (class 2606 OID 24985)
-- Name: dice_dice pk__dice_dic__b667e54b9fad349f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dice_dice
    ADD CONSTRAINT pk__dice_dic__b667e54b9fad349f PRIMARY KEY (guid_die);


--
-- TOC entry 2915 (class 2606 OID 24999)
-- Name: feature_rl_monster_feature pk__feature___157e45b93cc41d92; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_rl_monster_feature
    ADD CONSTRAINT pk__feature___157e45b93cc41d92 PRIMARY KEY (guid_monster, guid_feature);


--
-- TOC entry 2913 (class 2606 OID 24994)
-- Name: feature_lu_feature pk__feature___3bcc02f9ba89bb70; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_lu_feature
    ADD CONSTRAINT pk__feature___3bcc02f9ba89bb70 PRIMARY KEY (guid_feature);


--
-- TOC entry 2917 (class 2606 OID 25004)
-- Name: hp_protection_cr_modifier pk__hp_prote__5517d1812f271b46; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hp_protection_cr_modifier
    ADD CONSTRAINT pk__hp_prote__5517d1812f271b46 PRIMARY KEY (guid_cr, guid_protection);


--
-- TOC entry 2919 (class 2606 OID 25009)
-- Name: mon_lu_goodness pk__mon_lu_g__ca94af5c4ba063a5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_lu_goodness
    ADD CONSTRAINT pk__mon_lu_g__ca94af5c4ba063a5 PRIMARY KEY (guid_goodness);


--
-- TOC entry 2921 (class 2606 OID 25017)
-- Name: mon_lu_lawfulness pk__mon_lu_l__5e599fc081d08b13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_lu_lawfulness
    ADD CONSTRAINT pk__mon_lu_l__5e599fc081d08b13 PRIMARY KEY (guid_lawfulness);


--
-- TOC entry 2923 (class 2606 OID 25022)
-- Name: mon_lu_type pk__mon_lu_t__14f8d5f335df1077; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_lu_type
    ADD CONSTRAINT pk__mon_lu_t__14f8d5f335df1077 PRIMARY KEY (guid_type);


--
-- TOC entry 2925 (class 2606 OID 25030)
-- Name: mon_monster pk__mon_mons__3c3d085fed6554fe; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_monster
    ADD CONSTRAINT pk__mon_mons__3c3d085fed6554fe PRIMARY KEY (guid_monster);


--
-- TOC entry 2927 (class 2606 OID 25035)
-- Name: mon_rl_alignment pk__mon_rl_a__ca53457079114d0a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_alignment
    ADD CONSTRAINT pk__mon_rl_a__ca53457079114d0a PRIMARY KEY (guid_alignment);


--
-- TOC entry 2937 (class 2606 OID 25060)
-- Name: mon_rl_monster_weapon pk__mon_rl_m__12e13961dd73bb2a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_weapon
    ADD CONSTRAINT pk__mon_rl_m__12e13961dd73bb2a PRIMARY KEY (guid_monster, guid_weapon);


--
-- TOC entry 2935 (class 2606 OID 25055)
-- Name: mon_rl_monster_skill pk__mon_rl_m__3a6054b0fd8220cf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_skill
    ADD CONSTRAINT pk__mon_rl_m__3a6054b0fd8220cf PRIMARY KEY (guid_monster, guid_skill);


--
-- TOC entry 2933 (class 2606 OID 25050)
-- Name: mon_rl_monster_senses pk__mon_rl_m__866cc469689b8aae; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_senses
    ADD CONSTRAINT pk__mon_rl_m__866cc469689b8aae PRIMARY KEY (guid_monster, guid_sense);


--
-- TOC entry 2931 (class 2606 OID 25045)
-- Name: mon_rl_monster_movement pk__mon_rl_m__fe36ddcdd755d0b8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_movement
    ADD CONSTRAINT pk__mon_rl_m__fe36ddcdd755d0b8 PRIMARY KEY (guid_monster, guid_movement);


--
-- TOC entry 2939 (class 2606 OID 25065)
-- Name: mon_rl_protection pk__mon_rl_p__bef41cc9c2e90d21; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_protection
    ADD CONSTRAINT pk__mon_rl_p__bef41cc9c2e90d21 PRIMARY KEY (guid_damagetype, guid_monster);


--
-- TOC entry 2941 (class 2606 OID 25077)
-- Name: sysdiagrams pk__sysdiagr__c2b05b61bf5f6d4a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sysdiagrams
    ADD CONSTRAINT pk__sysdiagr__c2b05b61bf5f6d4a PRIMARY KEY (diagram_id);


--
-- TOC entry 2954 (class 2606 OID 25114)
-- Name: weap_lu_weapontype pk__weap_lu___16c9dc1b61b3aa5b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_weapontype
    ADD CONSTRAINT pk__weap_lu___16c9dc1b61b3aa5b PRIMARY KEY (guid_weapontype);


--
-- TOC entry 2944 (class 2606 OID 25086)
-- Name: weap_lu_damagetype pk__weap_lu___5d37cc4c6b20f7bb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_damagetype
    ADD CONSTRAINT pk__weap_lu___5d37cc4c6b20f7bb PRIMARY KEY (guid_damagetype);


--
-- TOC entry 2946 (class 2606 OID 25091)
-- Name: weap_lu_size_weapondice pk__weap_lu___68976992b7f9f1c4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_size_weapondice
    ADD CONSTRAINT pk__weap_lu___68976992b7f9f1c4 PRIMARY KEY (guid_size);


--
-- TOC entry 2950 (class 2606 OID 25101)
-- Name: weap_lu_weaponreach pk__weap_lu___8b8df346ff1d0bfe; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_weaponreach
    ADD CONSTRAINT pk__weap_lu___8b8df346ff1d0bfe PRIMARY KEY (guid_reach);


--
-- TOC entry 2952 (class 2606 OID 25106)
-- Name: weap_lu_weapontrait pk__weap_lu___c6a502e48b6d3c73; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_weapontrait
    ADD CONSTRAINT pk__weap_lu___c6a502e48b6d3c73 PRIMARY KEY (guid_trait);


--
-- TOC entry 2948 (class 2606 OID 25096)
-- Name: weap_lu_skillrequired pk__weap_lu___cb5a6203cdda361f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_skillrequired
    ADD CONSTRAINT pk__weap_lu___cb5a6203cdda361f PRIMARY KEY (guid_skill);


--
-- TOC entry 2956 (class 2606 OID 25119)
-- Name: weap_rl_weapon_abilityscore pk__weap_rl___ad3061317ea14965; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_rl_weapon_abilityscore
    ADD CONSTRAINT pk__weap_rl___ad3061317ea14965 PRIMARY KEY (guid_abilityscore, guid_weapon);


--
-- TOC entry 2958 (class 2606 OID 25124)
-- Name: weap_rl_weapon_weapontrait pk__weap_rl___e87933dafefc75bf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_rl_weapon_weapontrait
    ADD CONSTRAINT pk__weap_rl___e87933dafefc75bf PRIMARY KEY (guid_trait, guid_weapon);


--
-- TOC entry 2960 (class 2606 OID 25129)
-- Name: weap_weapon pk__weap_wea__edc313e3a6ef0b17; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_weapon
    ADD CONSTRAINT pk__weap_wea__edc313e3a6ef0b17 PRIMARY KEY (guid_weapon);


--
-- TOC entry 2868 (class 2606 OID 24880)
-- Name: arm_lu_armortype pk_arm_lu_armortype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_lu_armortype
    ADD CONSTRAINT pk_arm_lu_armortype PRIMARY KEY (guid_armortype);


--
-- TOC entry 2929 (class 2606 OID 25040)
-- Name: mon_rl_monster_armor pk_mon_rl_monster_armor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_armor
    ADD CONSTRAINT pk_mon_rl_monster_armor PRIMARY KEY (guid_monster, guid_armor);


--
-- TOC entry 2942 (class 1259 OID 25078)
-- Name: uk_principal_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uk_principal_name ON sysdiagrams USING btree (principal_id, name);


--
-- TOC entry 2911 (class 1259 OID 24986)
-- Name: uq__dice_dic__0957e246b853ead1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq__dice_dic__0957e246b853ead1 ON dice_dice USING btree (name_die);


--
-- TOC entry 2962 (class 2606 OID 25135)
-- Name: arm_rl_acmodifier fk__arm_rl_ac__guid___54cb950f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_rl_acmodifier
    ADD CONSTRAINT fk__arm_rl_ac__guid___54cb950f FOREIGN KEY (guid_abilityscore) REFERENCES com_abilityscore(guid_abilityscore);


--
-- TOC entry 2963 (class 2606 OID 25140)
-- Name: arm_rl_acmodifier fk__arm_rl_ac__guid___55bfb948; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_rl_acmodifier
    ADD CONSTRAINT fk__arm_rl_ac__guid___55bfb948 FOREIGN KEY (guid_armor) REFERENCES arm_armor(guid_armor);


--
-- TOC entry 2990 (class 2606 OID 25275)
-- Name: mon_rl_monster_armor fk__arm_rl_mo__guid___1209ad79; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_armor
    ADD CONSTRAINT fk__arm_rl_mo__guid___1209ad79 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2991 (class 2606 OID 25280)
-- Name: mon_rl_monster_armor fk__arm_rl_mo__guid___12fdd1b2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_armor
    ADD CONSTRAINT fk__arm_rl_mo__guid___12fdd1b2 FOREIGN KEY (guid_shield) REFERENCES arm_shield(guid_shield);


--
-- TOC entry 2992 (class 2606 OID 25285)
-- Name: mon_rl_monster_armor fk__arm_rl_mo__guid___13f1f5eb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_armor
    ADD CONSTRAINT fk__arm_rl_mo__guid___13f1f5eb FOREIGN KEY (guid_armor) REFERENCES arm_armor(guid_armor);


--
-- TOC entry 2964 (class 2606 OID 25145)
-- Name: com_lu_armorclass fk__com_lu_ar__guid___56e8e7ab; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_lu_armorclass
    ADD CONSTRAINT fk__com_lu_ar__guid___56e8e7ab FOREIGN KEY (guid_cr) REFERENCES com_cr(guid_cr);


--
-- TOC entry 2965 (class 2606 OID 25150)
-- Name: com_rl_abilityscore_skill fk__com_rl_ab__guid___6cd828ca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_abilityscore_skill
    ADD CONSTRAINT fk__com_rl_ab__guid___6cd828ca FOREIGN KEY (guid_abilityscore) REFERENCES com_abilityscore(guid_abilityscore);


--
-- TOC entry 2966 (class 2606 OID 25155)
-- Name: com_rl_abilityscore_skill fk__com_rl_ab__guid___6dcc4d03; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_abilityscore_skill
    ADD CONSTRAINT fk__com_rl_ab__guid___6dcc4d03 FOREIGN KEY (guid_skill) REFERENCES com_lu_skill(guid_skill);


--
-- TOC entry 2967 (class 2606 OID 25160)
-- Name: com_rl_monster_abilityscore fk__com_rl_mo__guid___05a3d694; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_abilityscore
    ADD CONSTRAINT fk__com_rl_mo__guid___05a3d694 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2968 (class 2606 OID 25165)
-- Name: com_rl_monster_abilityscore fk__com_rl_mo__guid___0697facd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_abilityscore
    ADD CONSTRAINT fk__com_rl_mo__guid___0697facd FOREIGN KEY (guid_abilityscore) REFERENCES com_abilityscore(guid_abilityscore);


--
-- TOC entry 2970 (class 2606 OID 25175)
-- Name: com_rl_monster_language fk__com_rl_mo__guid___0e391c95; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_language
    ADD CONSTRAINT fk__com_rl_mo__guid___0e391c95 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2971 (class 2606 OID 25180)
-- Name: com_rl_monster_language fk__com_rl_mo__guid___0f2d40ce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_language
    ADD CONSTRAINT fk__com_rl_mo__guid___0f2d40ce FOREIGN KEY (guid_language) REFERENCES com_language(guid_language);


--
-- TOC entry 2969 (class 2606 OID 25170)
-- Name: com_rl_monster_abilityscore fk__com_rl_mo__value__078c1f06; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_rl_monster_abilityscore
    ADD CONSTRAINT fk__com_rl_mo__value__078c1f06 FOREIGN KEY (value_abilityscore) REFERENCES com_rl_abilityscore_modifier(value_abilityscore);


--
-- TOC entry 2972 (class 2606 OID 25185)
-- Name: com_size fk__com_size__guid_d__69fbbc1f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY com_size
    ADD CONSTRAINT fk__com_size__guid_d__69fbbc1f FOREIGN KEY (guid_die) REFERENCES dice_dice(guid_die);


--
-- TOC entry 2973 (class 2606 OID 25190)
-- Name: core_lu_cr_proficiency fk__core_lu_c__guid___5f7e2dac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY core_lu_cr_proficiency
    ADD CONSTRAINT fk__core_lu_c__guid___5f7e2dac FOREIGN KEY (guid_cr) REFERENCES com_cr(guid_cr);


--
-- TOC entry 2974 (class 2606 OID 25195)
-- Name: core_lu_defensive_values fk__core_lu_d__guid___59c55456; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY core_lu_defensive_values
    ADD CONSTRAINT fk__core_lu_d__guid___59c55456 FOREIGN KEY (guid_cr) REFERENCES com_cr(guid_cr);


--
-- TOC entry 2975 (class 2606 OID 25200)
-- Name: core_lu_offensive_values fk__core_lu_o__guid___5ca1c101; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY core_lu_offensive_values
    ADD CONSTRAINT fk__core_lu_o__guid___5ca1c101 FOREIGN KEY (guid_cr) REFERENCES com_cr(guid_cr);


--
-- TOC entry 2976 (class 2606 OID 25205)
-- Name: custom_attack_dice fk__custom_at__guid___662b2b3b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_attack_dice
    ADD CONSTRAINT fk__custom_at__guid___662b2b3b FOREIGN KEY (guid_die) REFERENCES dice_dice(guid_die);


--
-- TOC entry 2977 (class 2606 OID 25210)
-- Name: custom_attack_dice fk__custom_at__guid___671f4f74; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_attack_dice
    ADD CONSTRAINT fk__custom_at__guid___671f4f74 FOREIGN KEY (guid_custom_attack) REFERENCES custom_weapon_attack(guid_custom_attack);


--
-- TOC entry 2978 (class 2606 OID 25215)
-- Name: custom_weapon_attack fk__custom_we__guid___625a9a57; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_weapon_attack
    ADD CONSTRAINT fk__custom_we__guid___625a9a57 FOREIGN KEY (guid_damagetype) REFERENCES weap_lu_damagetype(guid_damagetype);


--
-- TOC entry 2979 (class 2606 OID 25220)
-- Name: custom_weapon_attack fk__custom_we__guid___634ebe90; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_weapon_attack
    ADD CONSTRAINT fk__custom_we__guid___634ebe90 FOREIGN KEY (guid_abilityscore) REFERENCES com_abilityscore(guid_abilityscore);


--
-- TOC entry 2980 (class 2606 OID 25225)
-- Name: feature_rl_monster_feature fk__feature_r__guid___0a688bb1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_rl_monster_feature
    ADD CONSTRAINT fk__feature_r__guid___0a688bb1 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2981 (class 2606 OID 25230)
-- Name: feature_rl_monster_feature fk__feature_r__guid___0b5cafea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_rl_monster_feature
    ADD CONSTRAINT fk__feature_r__guid___0b5cafea FOREIGN KEY (guid_feature) REFERENCES feature_lu_feature(guid_feature);


--
-- TOC entry 2982 (class 2606 OID 25235)
-- Name: hp_protection_cr_modifier fk__hp_protec__guid___498eec8d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hp_protection_cr_modifier
    ADD CONSTRAINT fk__hp_protec__guid___498eec8d FOREIGN KEY (guid_cr) REFERENCES com_cr(guid_cr);


--
-- TOC entry 2983 (class 2606 OID 25240)
-- Name: hp_protection_cr_modifier fk__hp_protec__guid___4a8310c6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hp_protection_cr_modifier
    ADD CONSTRAINT fk__hp_protec__guid___4a8310c6 FOREIGN KEY (guid_protection) REFERENCES com_protectionfromdamage(guid_protection);


--
-- TOC entry 2984 (class 2606 OID 25245)
-- Name: mon_monster fk__mon_monst__guid___00df2177; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_monster
    ADD CONSTRAINT fk__mon_monst__guid___00df2177 FOREIGN KEY (guid_alignment) REFERENCES mon_rl_alignment(guid_alignment);


--
-- TOC entry 2985 (class 2606 OID 25250)
-- Name: mon_monster fk__mon_monst__guid___01d345b0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_monster
    ADD CONSTRAINT fk__mon_monst__guid___01d345b0 FOREIGN KEY (guid_type) REFERENCES mon_lu_type(guid_type);


--
-- TOC entry 2986 (class 2606 OID 25255)
-- Name: mon_monster fk__mon_monst__guid___02c769e9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_monster
    ADD CONSTRAINT fk__mon_monst__guid___02c769e9 FOREIGN KEY (guid_cr) REFERENCES com_cr(guid_cr);


--
-- TOC entry 2987 (class 2606 OID 25260)
-- Name: mon_monster fk__mon_monst__guid___7feafd3e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_monster
    ADD CONSTRAINT fk__mon_monst__guid___7feafd3e FOREIGN KEY (guid_size) REFERENCES com_size(guid_size);


--
-- TOC entry 2988 (class 2606 OID 25265)
-- Name: mon_rl_alignment fk__mon_rl_al__guid___2739d489; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_alignment
    ADD CONSTRAINT fk__mon_rl_al__guid___2739d489 FOREIGN KEY (guid_lawfulness) REFERENCES mon_lu_lawfulness(guid_lawfulness);


--
-- TOC entry 2989 (class 2606 OID 25270)
-- Name: mon_rl_alignment fk__mon_rl_al__guid___282df8c2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_alignment
    ADD CONSTRAINT fk__mon_rl_al__guid___282df8c2 FOREIGN KEY (guid_goodness) REFERENCES mon_lu_goodness(guid_goodness);


--
-- TOC entry 2995 (class 2606 OID 25300)
-- Name: mon_rl_monster_senses fk__mon_rl_mo__guid___15a53433; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_senses
    ADD CONSTRAINT fk__mon_rl_mo__guid___15a53433 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2996 (class 2606 OID 25305)
-- Name: mon_rl_monster_senses fk__mon_rl_mo__guid___1699586c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_senses
    ADD CONSTRAINT fk__mon_rl_mo__guid___1699586c FOREIGN KEY (guid_sense) REFERENCES com_lu_senses(guid_sense);


--
-- TOC entry 2993 (class 2606 OID 25290)
-- Name: mon_rl_monster_movement fk__mon_rl_mo__guid___1975c517; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_movement
    ADD CONSTRAINT fk__mon_rl_mo__guid___1975c517 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2994 (class 2606 OID 25295)
-- Name: mon_rl_monster_movement fk__mon_rl_mo__guid___1a69e950; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_movement
    ADD CONSTRAINT fk__mon_rl_mo__guid___1a69e950 FOREIGN KEY (guid_movement) REFERENCES com_lu_movement(guid_movement);


--
-- TOC entry 2999 (class 2606 OID 25320)
-- Name: mon_rl_monster_weapon fk__mon_rl_mo__guid___1b9317b3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_weapon
    ADD CONSTRAINT fk__mon_rl_mo__guid___1b9317b3 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 3000 (class 2606 OID 25325)
-- Name: mon_rl_monster_weapon fk__mon_rl_mo__guid___1c873bec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_weapon
    ADD CONSTRAINT fk__mon_rl_mo__guid___1c873bec FOREIGN KEY (guid_weapon) REFERENCES weap_weapon(guid_weapon);


--
-- TOC entry 2997 (class 2606 OID 25310)
-- Name: mon_rl_monster_skill fk__mon_rl_mo__guid___1f63a897; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_skill
    ADD CONSTRAINT fk__mon_rl_mo__guid___1f63a897 FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 2998 (class 2606 OID 25315)
-- Name: mon_rl_monster_skill fk__mon_rl_mo__guid___2057ccd0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_monster_skill
    ADD CONSTRAINT fk__mon_rl_mo__guid___2057ccd0 FOREIGN KEY (guid_skill) REFERENCES com_lu_skill(guid_skill);


--
-- TOC entry 3001 (class 2606 OID 25330)
-- Name: mon_rl_protection fk__mon_rl_pr__guid___16ce6296; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_protection
    ADD CONSTRAINT fk__mon_rl_pr__guid___16ce6296 FOREIGN KEY (guid_damagetype) REFERENCES weap_lu_damagetype(guid_damagetype);


--
-- TOC entry 3002 (class 2606 OID 25335)
-- Name: mon_rl_protection fk__mon_rl_pr__guid___17c286cf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_protection
    ADD CONSTRAINT fk__mon_rl_pr__guid___17c286cf FOREIGN KEY (guid_monster) REFERENCES mon_monster(guid_monster);


--
-- TOC entry 3003 (class 2606 OID 25340)
-- Name: mon_rl_protection fk__mon_rl_pr__guid___18b6ab08; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mon_rl_protection
    ADD CONSTRAINT fk__mon_rl_pr__guid___18b6ab08 FOREIGN KEY (guid_protection) REFERENCES com_protectionfromdamage(guid_protection);


--
-- TOC entry 3004 (class 2606 OID 25345)
-- Name: weap_lu_size_weapondice fk__weap_lu_s__guid___7d0e9093; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_size_weapondice
    ADD CONSTRAINT fk__weap_lu_s__guid___7d0e9093 FOREIGN KEY (guid_size) REFERENCES com_size(guid_size);


--
-- TOC entry 3005 (class 2606 OID 25350)
-- Name: weap_lu_weapontype fk__weap_lu_w__guid___51300e55; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_weapontype
    ADD CONSTRAINT fk__weap_lu_w__guid___51300e55 FOREIGN KEY (guid_skill) REFERENCES weap_lu_skillrequired(guid_skill);


--
-- TOC entry 3006 (class 2606 OID 25355)
-- Name: weap_lu_weapontype fk__weap_lu_w__guid___5224328e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_lu_weapontype
    ADD CONSTRAINT fk__weap_lu_w__guid___5224328e FOREIGN KEY (guid_reach) REFERENCES weap_lu_weaponreach(guid_reach);


--
-- TOC entry 3009 (class 2606 OID 25370)
-- Name: weap_rl_weapon_weapontrait fk__weap_rl_w__guid___756d6ecb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_rl_weapon_weapontrait
    ADD CONSTRAINT fk__weap_rl_w__guid___756d6ecb FOREIGN KEY (guid_trait) REFERENCES weap_lu_weapontrait(guid_trait);


--
-- TOC entry 3010 (class 2606 OID 25375)
-- Name: weap_rl_weapon_weapontrait fk__weap_rl_w__guid___76619304; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_rl_weapon_weapontrait
    ADD CONSTRAINT fk__weap_rl_w__guid___76619304 FOREIGN KEY (guid_weapon) REFERENCES weap_weapon(guid_weapon);


--
-- TOC entry 3007 (class 2606 OID 25360)
-- Name: weap_rl_weapon_abilityscore fk__weap_rl_w__guid___793dffaf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_rl_weapon_abilityscore
    ADD CONSTRAINT fk__weap_rl_w__guid___793dffaf FOREIGN KEY (guid_abilityscore) REFERENCES com_abilityscore(guid_abilityscore);


--
-- TOC entry 3008 (class 2606 OID 25365)
-- Name: weap_rl_weapon_abilityscore fk__weap_rl_w__guid___7a3223e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_rl_weapon_abilityscore
    ADD CONSTRAINT fk__weap_rl_w__guid___7a3223e8 FOREIGN KEY (guid_weapon) REFERENCES weap_weapon(guid_weapon);


--
-- TOC entry 3011 (class 2606 OID 25380)
-- Name: weap_weapon fk__weap_weap__guid___70a8b9ae; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_weapon
    ADD CONSTRAINT fk__weap_weap__guid___70a8b9ae FOREIGN KEY (guid_die) REFERENCES dice_dice(guid_die);


--
-- TOC entry 3012 (class 2606 OID 25385)
-- Name: weap_weapon fk__weap_weap__guid___719cdde7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_weapon
    ADD CONSTRAINT fk__weap_weap__guid___719cdde7 FOREIGN KEY (guid_damagetype) REFERENCES weap_lu_damagetype(guid_damagetype);


--
-- TOC entry 3013 (class 2606 OID 25390)
-- Name: weap_weapon fk__weap_weap__guid___72910220; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weap_weapon
    ADD CONSTRAINT fk__weap_weap__guid___72910220 FOREIGN KEY (guid_weapontype) REFERENCES weap_lu_weapontype(guid_weapontype);


--
-- TOC entry 2961 (class 2606 OID 25130)
-- Name: arm_armor fk_arm_armor_arm_lu_armortype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY arm_armor
    ADD CONSTRAINT fk_arm_armor_arm_lu_armortype FOREIGN KEY (guid_armortype) REFERENCES arm_lu_armortype(guid_armortype);


--
-- TOC entry 3191 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-01-24 07:37:18

--
-- PostgreSQL database dump complete
--

