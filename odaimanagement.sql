--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.4
-- Dumped by pg_dump version 9.3.4
-- Started on 2014-10-16 14:39:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 3223 (class 1262 OID 16394)
-- Name: joomla; Type: DATABASE; Schema: -; Owner: -
--


--
-- TOC entry 281 (class 3079 OID 11750)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "plpgsql" WITH SCHEMA "pg_catalog";


--
-- TOC entry 3226 (class 0 OID 0)
-- Dependencies: 281
-- Name: EXTENSION "plpgsql"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "plpgsql" IS 'PL/pgSQL procedural language';


SET search_path = "public", pg_catalog;

--
-- TOC entry 294 (class 1255 OID 17513)
-- Name: soundex("text"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "soundex"("input" "text") RETURNS "text"
    LANGUAGE "plpgsql" IMMUTABLE STRICT COST 500
    AS $$
DECLARE
  soundex text = '';
  char text;
  symbol text;
  last_symbol text = '';
  pos int = 1;
BEGIN
  WHILE length(soundex) < 4 LOOP
    char = upper(substr(input, pos, 1));
    pos = pos + 1;
    CASE char
    WHEN '' THEN
      -- End of input string
      IF soundex = '' THEN
        RETURN '';
      ELSE
        RETURN rpad(soundex, 4, '0');
      END IF;
    WHEN 'B', 'F', 'P', 'V' THEN
      symbol = '1';
    WHEN 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' THEN
      symbol = '2';
    WHEN 'D', 'T' THEN
      symbol = '3';
    WHEN 'L' THEN
      symbol = '4';
    WHEN 'M', 'N' THEN
      symbol = '5';
    WHEN 'R' THEN
      symbol = '6';
    ELSE
      -- Not a consonant; no output, but next similar consonant will be re-recorded
      symbol = '';
    END CASE;

    IF soundex = '' THEN
      -- First character; only accept strictly English ASCII characters
      IF char ~>=~ 'A' AND char ~<=~ 'Z' THEN
        soundex = char;
        last_symbol = symbol;
      END IF;
    ELSIF last_symbol != symbol THEN
      soundex = soundex || symbol;
      last_symbol = symbol;
    END IF;
  END LOOP;

  RETURN soundex;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 171 (class 1259 OID 16397)
-- Name: odai_assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_assets" (
    "id" integer NOT NULL,
    "parent_id" bigint DEFAULT 0 NOT NULL,
    "lft" bigint DEFAULT 0 NOT NULL,
    "rgt" bigint DEFAULT 0 NOT NULL,
    "level" integer NOT NULL,
    "name" character varying(50) NOT NULL,
    "title" character varying(100) NOT NULL,
    "rules" character varying(5120) NOT NULL
);


--
-- TOC entry 3227 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."id" IS 'Primary Key';


--
-- TOC entry 3228 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."parent_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."parent_id" IS 'Nested set parent.';


--
-- TOC entry 3229 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."lft"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."lft" IS 'Nested set lft.';


--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."rgt"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."rgt" IS 'Nested set rgt.';


--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."level"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."level" IS 'The cached level in the nested tree.';


--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."name"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."name" IS 'The unique name for the asset.';


--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."title"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."title" IS 'The descriptive title for the asset.';


--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN "odai_assets"."rules"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_assets"."rules" IS 'JSON encoded access control.';


--
-- TOC entry 170 (class 1259 OID 16395)
-- Name: odai_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_assets_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 170
-- Name: odai_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_assets_id_seq" OWNED BY "odai_assets"."id";


--
-- TOC entry 172 (class 1259 OID 16413)
-- Name: odai_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_associations" (
    "id" bigint NOT NULL,
    "context" character varying(50) NOT NULL,
    "key" character(32) NOT NULL
);


--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 172
-- Name: COLUMN "odai_associations"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_associations"."id" IS 'A reference to the associated item.';


--
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 172
-- Name: COLUMN "odai_associations"."context"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_associations"."context" IS 'The context of the associated item.';


--
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 172
-- Name: COLUMN "odai_associations"."key"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_associations"."key" IS 'The key for the association computed from an md5 on associated ids.';


--
-- TOC entry 176 (class 1259 OID 16466)
-- Name: odai_banner_clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_banner_clients" (
    "id" integer NOT NULL,
    "name" character varying(255) DEFAULT ''::character varying NOT NULL,
    "contact" character varying(255) DEFAULT ''::character varying NOT NULL,
    "email" character varying(255) DEFAULT ''::character varying NOT NULL,
    "extrainfo" "text" NOT NULL,
    "state" smallint DEFAULT 0 NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "metakey" "text" NOT NULL,
    "own_prefix" smallint DEFAULT 0 NOT NULL,
    "metakey_prefix" character varying(255) DEFAULT ''::character varying NOT NULL,
    "purchase_type" smallint DEFAULT (-1) NOT NULL,
    "track_clicks" smallint DEFAULT (-1) NOT NULL,
    "track_impressions" smallint DEFAULT (-1) NOT NULL
);


--
-- TOC entry 175 (class 1259 OID 16464)
-- Name: odai_banner_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_banner_clients_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 175
-- Name: odai_banner_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_banner_clients_id_seq" OWNED BY "odai_banner_clients"."id";


--
-- TOC entry 177 (class 1259 OID 16488)
-- Name: odai_banner_tracks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_banner_tracks" (
    "track_date" timestamp without time zone NOT NULL,
    "track_type" bigint NOT NULL,
    "banner_id" bigint NOT NULL,
    "count" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 174 (class 1259 OID 16421)
-- Name: odai_banners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_banners" (
    "id" integer NOT NULL,
    "cid" bigint DEFAULT 0 NOT NULL,
    "type" bigint DEFAULT 0 NOT NULL,
    "name" character varying(255) DEFAULT ''::character varying NOT NULL,
    "alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "imptotal" bigint DEFAULT 0 NOT NULL,
    "impmade" bigint DEFAULT 0 NOT NULL,
    "clicks" bigint DEFAULT 0 NOT NULL,
    "clickurl" character varying(200) DEFAULT ''::character varying NOT NULL,
    "state" smallint DEFAULT 0 NOT NULL,
    "catid" bigint DEFAULT 0 NOT NULL,
    "description" "text" NOT NULL,
    "custombannercode" character varying(2048) NOT NULL,
    "sticky" smallint DEFAULT 0 NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "metakey" "text" NOT NULL,
    "params" "text" NOT NULL,
    "own_prefix" smallint DEFAULT 0 NOT NULL,
    "metakey_prefix" character varying(255) DEFAULT ''::character varying NOT NULL,
    "purchase_type" smallint DEFAULT (-1) NOT NULL,
    "track_clicks" smallint DEFAULT (-1) NOT NULL,
    "track_impressions" smallint DEFAULT (-1) NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "reset" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "created_by" bigint DEFAULT 0 NOT NULL,
    "created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "modified" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_by" bigint DEFAULT 0 NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL
);


--
-- TOC entry 173 (class 1259 OID 16419)
-- Name: odai_banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_banners_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 173
-- Name: odai_banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_banners_id_seq" OWNED BY "odai_banners"."id";


--
-- TOC entry 179 (class 1259 OID 16499)
-- Name: odai_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_categories" (
    "id" integer NOT NULL,
    "asset_id" bigint DEFAULT 0 NOT NULL,
    "parent_id" integer DEFAULT 0 NOT NULL,
    "lft" bigint DEFAULT 0 NOT NULL,
    "rgt" bigint DEFAULT 0 NOT NULL,
    "level" integer DEFAULT 0 NOT NULL,
    "path" character varying(255) DEFAULT ''::character varying NOT NULL,
    "extension" character varying(50) DEFAULT ''::character varying NOT NULL,
    "title" character varying(255) NOT NULL,
    "alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "note" character varying(255) DEFAULT ''::character varying NOT NULL,
    "description" "text" DEFAULT ''::"text" NOT NULL,
    "published" smallint DEFAULT 0 NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "access" bigint DEFAULT 0 NOT NULL,
    "params" "text" NOT NULL,
    "metadesc" character varying(1024) NOT NULL,
    "metakey" character varying(1024) NOT NULL,
    "metadata" character varying(2048) NOT NULL,
    "created_user_id" integer DEFAULT 0 NOT NULL,
    "created_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_user_id" integer DEFAULT 0 NOT NULL,
    "modified_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "hits" integer DEFAULT 0 NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL
);


--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 179
-- Name: COLUMN "odai_categories"."asset_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_categories"."asset_id" IS 'FK to the #__assets table.';


--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 179
-- Name: COLUMN "odai_categories"."metadesc"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_categories"."metadesc" IS 'The meta description for the page.';


--
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 179
-- Name: COLUMN "odai_categories"."metakey"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_categories"."metakey" IS 'The meta keywords for the page.';


--
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 179
-- Name: COLUMN "odai_categories"."metadata"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_categories"."metadata" IS 'JSON encoded metadata properties.';


--
-- TOC entry 178 (class 1259 OID 16497)
-- Name: odai_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 178
-- Name: odai_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_categories_id_seq" OWNED BY "odai_categories"."id";


--
-- TOC entry 181 (class 1259 OID 16538)
-- Name: odai_contact_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_contact_details" (
    "id" integer NOT NULL,
    "name" character varying(255) DEFAULT ''::character varying NOT NULL,
    "alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "con_position" character varying(255) DEFAULT NULL::character varying,
    "address" "text",
    "suburb" character varying(100) DEFAULT NULL::character varying,
    "state" character varying(100) DEFAULT NULL::character varying,
    "country" character varying(100) DEFAULT NULL::character varying,
    "postcode" character varying(100) DEFAULT NULL::character varying,
    "telephone" character varying(255) DEFAULT NULL::character varying,
    "fax" character varying(255) DEFAULT NULL::character varying,
    "misc" "text",
    "image" character varying(255) DEFAULT NULL::character varying,
    "email_to" character varying(255) DEFAULT NULL::character varying,
    "default_con" smallint DEFAULT 0 NOT NULL,
    "published" smallint DEFAULT 0 NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "params" "text" NOT NULL,
    "user_id" bigint DEFAULT 0 NOT NULL,
    "catid" bigint DEFAULT 0 NOT NULL,
    "access" bigint DEFAULT 0 NOT NULL,
    "mobile" character varying(255) DEFAULT ''::character varying NOT NULL,
    "webpage" character varying(255) DEFAULT ''::character varying NOT NULL,
    "sortname1" character varying(255) NOT NULL,
    "sortname2" character varying(255) NOT NULL,
    "sortname3" character varying(255) NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "created" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_by" integer DEFAULT 0 NOT NULL,
    "created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "modified" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_by" integer DEFAULT 0 NOT NULL,
    "metakey" "text" NOT NULL,
    "metadesc" "text" NOT NULL,
    "metadata" "text" NOT NULL,
    "featured" smallint DEFAULT 0 NOT NULL,
    "xreference" character varying(50) NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL,
    "hits" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 181
-- Name: COLUMN "odai_contact_details"."featured"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contact_details"."featured" IS 'Set if article is featured.';


--
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 181
-- Name: COLUMN "odai_contact_details"."xreference"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contact_details"."xreference" IS 'A reference to enable linkages to external data sets.';


--
-- TOC entry 180 (class 1259 OID 16536)
-- Name: odai_contact_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_contact_details_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 180
-- Name: odai_contact_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_contact_details_id_seq" OWNED BY "odai_contact_details"."id";


--
-- TOC entry 183 (class 1259 OID 16589)
-- Name: odai_content; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_content" (
    "id" integer NOT NULL,
    "asset_id" bigint DEFAULT 0 NOT NULL,
    "title" character varying(255) DEFAULT ''::character varying NOT NULL,
    "alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "introtext" "text" NOT NULL,
    "fulltext" "text" NOT NULL,
    "state" smallint DEFAULT 0 NOT NULL,
    "catid" bigint DEFAULT 0 NOT NULL,
    "created" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_by" bigint DEFAULT 0 NOT NULL,
    "created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "modified" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_by" bigint DEFAULT 0 NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "images" "text" NOT NULL,
    "urls" "text" NOT NULL,
    "attribs" character varying(5120) NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "metakey" "text" NOT NULL,
    "metadesc" "text" NOT NULL,
    "access" bigint DEFAULT 0 NOT NULL,
    "hits" bigint DEFAULT 0 NOT NULL,
    "metadata" "text" NOT NULL,
    "featured" smallint DEFAULT 0 NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "xreference" character varying(50) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 183
-- Name: COLUMN "odai_content"."asset_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_content"."asset_id" IS 'FK to the #__assets table.';


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 183
-- Name: COLUMN "odai_content"."featured"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_content"."featured" IS 'Set if article is featured.';


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 183
-- Name: COLUMN "odai_content"."language"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_content"."language" IS 'The language code for the article.';


--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 183
-- Name: COLUMN "odai_content"."xreference"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_content"."xreference" IS 'A reference to enable linkages to external data sets.';


--
-- TOC entry 184 (class 1259 OID 16627)
-- Name: odai_content_frontpage; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_content_frontpage" (
    "content_id" bigint DEFAULT 0 NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 182 (class 1259 OID 16587)
-- Name: odai_content_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_content_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 182
-- Name: odai_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_content_id_seq" OWNED BY "odai_content"."id";


--
-- TOC entry 185 (class 1259 OID 16634)
-- Name: odai_content_rating; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_content_rating" (
    "content_id" bigint DEFAULT 0 NOT NULL,
    "rating_sum" bigint DEFAULT 0 NOT NULL,
    "rating_count" bigint DEFAULT 0 NOT NULL,
    "lastip" character varying(50) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 16645)
-- Name: odai_content_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_content_types" (
    "type_id" integer NOT NULL,
    "type_title" character varying(255) DEFAULT ''::character varying NOT NULL,
    "type_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "table" character varying(255) DEFAULT ''::character varying NOT NULL,
    "rules" "text" NOT NULL,
    "field_mappings" "text" NOT NULL,
    "router" character varying(255) DEFAULT ''::character varying NOT NULL,
    "content_history_options" character varying(5120) DEFAULT NULL::character varying
);


--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 187
-- Name: COLUMN "odai_content_types"."content_history_options"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_content_types"."content_history_options" IS 'JSON string for com_contenthistory options';


--
-- TOC entry 186 (class 1259 OID 16643)
-- Name: odai_content_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_content_types_type_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 186
-- Name: odai_content_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_content_types_type_id_seq" OWNED BY "odai_content_types"."type_id";


--
-- TOC entry 188 (class 1259 OID 16660)
-- Name: odai_contentitem_tag_map; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_contentitem_tag_map" (
    "type_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "core_content_id" integer NOT NULL,
    "content_item_id" integer NOT NULL,
    "tag_id" integer NOT NULL,
    "tag_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "type_id" integer NOT NULL
);


--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN "odai_contentitem_tag_map"."core_content_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contentitem_tag_map"."core_content_id" IS 'PK from the core content table';


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN "odai_contentitem_tag_map"."content_item_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contentitem_tag_map"."content_item_id" IS 'PK from the content type table';


--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN "odai_contentitem_tag_map"."tag_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contentitem_tag_map"."tag_id" IS 'PK from the tag table';


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN "odai_contentitem_tag_map"."tag_date"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contentitem_tag_map"."tag_date" IS 'Date of most recent save for this tag-item';


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN "odai_contentitem_tag_map"."type_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_contentitem_tag_map"."type_id" IS 'PK from the content_type table';


--
-- TOC entry 189 (class 1259 OID 16672)
-- Name: odai_core_log_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_core_log_searches" (
    "search_term" character varying(128) DEFAULT ''::character varying NOT NULL,
    "hits" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 191 (class 1259 OID 16679)
-- Name: odai_extensions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_extensions" (
    "extension_id" integer NOT NULL,
    "name" character varying(100) NOT NULL,
    "type" character varying(20) NOT NULL,
    "element" character varying(100) NOT NULL,
    "folder" character varying(100) NOT NULL,
    "client_id" smallint NOT NULL,
    "enabled" smallint DEFAULT 1 NOT NULL,
    "access" bigint DEFAULT 1 NOT NULL,
    "protected" smallint DEFAULT 0 NOT NULL,
    "manifest_cache" "text" NOT NULL,
    "params" "text" NOT NULL,
    "custom_data" "text" DEFAULT ''::"text" NOT NULL,
    "system_data" "text" DEFAULT ''::"text" NOT NULL,
    "checked_out" integer DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "ordering" bigint DEFAULT 0,
    "state" bigint DEFAULT 0
);


--
-- TOC entry 190 (class 1259 OID 16677)
-- Name: odai_extensions_extension_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_extensions_extension_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 190
-- Name: odai_extensions_extension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_extensions_extension_id_seq" OWNED BY "odai_extensions"."extension_id";


--
-- TOC entry 193 (class 1259 OID 16702)
-- Name: odai_finder_filters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_filters" (
    "filter_id" integer NOT NULL,
    "title" character varying(255) NOT NULL,
    "alias" character varying(255) NOT NULL,
    "state" smallint DEFAULT 1 NOT NULL,
    "created" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_by" integer NOT NULL,
    "created_by_alias" character varying(255) NOT NULL,
    "modified" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_by" integer DEFAULT 0 NOT NULL,
    "checked_out" integer DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "map_count" integer DEFAULT 0 NOT NULL,
    "data" "text" NOT NULL,
    "params" "text"
);


--
-- TOC entry 192 (class 1259 OID 16700)
-- Name: odai_finder_filters_filter_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_finder_filters_filter_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 192
-- Name: odai_finder_filters_filter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_finder_filters_filter_id_seq" OWNED BY "odai_finder_filters"."filter_id";


--
-- TOC entry 195 (class 1259 OID 16720)
-- Name: odai_finder_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links" (
    "link_id" integer NOT NULL,
    "url" character varying(255) NOT NULL,
    "route" character varying(255) NOT NULL,
    "title" character varying(255) DEFAULT NULL::character varying,
    "description" character varying(255) DEFAULT NULL::character varying,
    "indexdate" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "md5sum" character varying(32) DEFAULT NULL::character varying,
    "published" smallint DEFAULT 1 NOT NULL,
    "state" integer DEFAULT 1,
    "access" integer DEFAULT 0,
    "language" character varying(8) DEFAULT ''::character varying NOT NULL,
    "publish_start_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_end_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "start_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "end_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "list_price" numeric(8,2) DEFAULT 0 NOT NULL,
    "sale_price" numeric(8,2) DEFAULT 0 NOT NULL,
    "type_id" bigint NOT NULL,
    "object" "bytea" NOT NULL
);


--
-- TOC entry 194 (class 1259 OID 16718)
-- Name: odai_finder_links_link_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_finder_links_link_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 194
-- Name: odai_finder_links_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_finder_links_link_id_seq" OWNED BY "odai_finder_links"."link_id";


--
-- TOC entry 196 (class 1259 OID 16749)
-- Name: odai_finder_links_terms0; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms0" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 197 (class 1259 OID 16756)
-- Name: odai_finder_links_terms1; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms1" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 16763)
-- Name: odai_finder_links_terms2; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms2" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 199 (class 1259 OID 16770)
-- Name: odai_finder_links_terms3; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms3" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 16777)
-- Name: odai_finder_links_terms4; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms4" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 16784)
-- Name: odai_finder_links_terms5; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms5" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 202 (class 1259 OID 16791)
-- Name: odai_finder_links_terms6; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms6" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 16798)
-- Name: odai_finder_links_terms7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms7" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 204 (class 1259 OID 16805)
-- Name: odai_finder_links_terms8; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms8" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 16812)
-- Name: odai_finder_links_terms9; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_terms9" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 16819)
-- Name: odai_finder_links_termsa; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_termsa" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 207 (class 1259 OID 16826)
-- Name: odai_finder_links_termsb; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_termsb" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 208 (class 1259 OID 16833)
-- Name: odai_finder_links_termsc; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_termsc" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 209 (class 1259 OID 16840)
-- Name: odai_finder_links_termsd; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_termsd" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 210 (class 1259 OID 16847)
-- Name: odai_finder_links_termse; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_termse" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 211 (class 1259 OID 16854)
-- Name: odai_finder_links_termsf; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_links_termsf" (
    "link_id" integer NOT NULL,
    "term_id" integer NOT NULL,
    "weight" numeric(8,2) NOT NULL
);


--
-- TOC entry 213 (class 1259 OID 16863)
-- Name: odai_finder_taxonomy; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_taxonomy" (
    "id" integer NOT NULL,
    "parent_id" integer DEFAULT 0 NOT NULL,
    "title" character varying(255) NOT NULL,
    "state" smallint DEFAULT 1 NOT NULL,
    "access" smallint DEFAULT 0 NOT NULL,
    "ordering" smallint DEFAULT 0 NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 16861)
-- Name: odai_finder_taxonomy_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_finder_taxonomy_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 212
-- Name: odai_finder_taxonomy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_finder_taxonomy_id_seq" OWNED BY "odai_finder_taxonomy"."id";


--
-- TOC entry 214 (class 1259 OID 16878)
-- Name: odai_finder_taxonomy_map; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_taxonomy_map" (
    "link_id" integer NOT NULL,
    "node_id" integer NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16887)
-- Name: odai_finder_terms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_terms" (
    "term_id" integer NOT NULL,
    "term" character varying(75) NOT NULL,
    "stem" character varying(75) NOT NULL,
    "common" smallint DEFAULT 0 NOT NULL,
    "phrase" smallint DEFAULT 0 NOT NULL,
    "weight" numeric(8,2) DEFAULT 0 NOT NULL,
    "soundex" character varying(75) NOT NULL,
    "links" integer DEFAULT 0 NOT NULL,
    "language" character varying(3) NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16902)
-- Name: odai_finder_terms_common; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_terms_common" (
    "term" character varying(75) NOT NULL,
    "language" character varying(3) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 16885)
-- Name: odai_finder_terms_term_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_finder_terms_term_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3265 (class 0 OID 0)
-- Dependencies: 215
-- Name: odai_finder_terms_term_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_finder_terms_term_id_seq" OWNED BY "odai_finder_terms"."term_id";


--
-- TOC entry 218 (class 1259 OID 16908)
-- Name: odai_finder_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_tokens" (
    "term" character varying(75) NOT NULL,
    "stem" character varying(75) NOT NULL,
    "common" smallint DEFAULT 0 NOT NULL,
    "phrase" smallint DEFAULT 0 NOT NULL,
    "weight" numeric(8,2) DEFAULT 1 NOT NULL,
    "context" smallint DEFAULT 2 NOT NULL,
    "language" character varying(3) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 16917)
-- Name: odai_finder_tokens_aggregate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_tokens_aggregate" (
    "term_id" integer NOT NULL,
    "map_suffix" character varying(1) NOT NULL,
    "term" character varying(75) NOT NULL,
    "stem" character varying(75) NOT NULL,
    "common" smallint DEFAULT 0 NOT NULL,
    "phrase" smallint DEFAULT 0 NOT NULL,
    "term_weight" numeric(8,2) NOT NULL,
    "context" smallint DEFAULT 2 NOT NULL,
    "context_weight" numeric(8,2) NOT NULL,
    "total_weight" numeric(8,2) NOT NULL,
    "language" character varying(3) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16927)
-- Name: odai_finder_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_finder_types" (
    "id" integer NOT NULL,
    "title" character varying(100) NOT NULL,
    "mime" character varying(100) NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16925)
-- Name: odai_finder_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_finder_types_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3266 (class 0 OID 0)
-- Dependencies: 220
-- Name: odai_finder_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_finder_types_id_seq" OWNED BY "odai_finder_types"."id";


--
-- TOC entry 223 (class 1259 OID 16937)
-- Name: odai_languages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_languages" (
    "lang_id" integer NOT NULL,
    "lang_code" character varying(7) NOT NULL,
    "title" character varying(50) NOT NULL,
    "title_native" character varying(50) NOT NULL,
    "sef" character varying(50) NOT NULL,
    "image" character varying(50) NOT NULL,
    "description" character varying(512) NOT NULL,
    "metakey" "text" NOT NULL,
    "metadesc" "text" NOT NULL,
    "sitename" character varying(1024) DEFAULT ''::character varying NOT NULL,
    "published" bigint DEFAULT 0 NOT NULL,
    "access" integer DEFAULT 0 NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 16935)
-- Name: odai_languages_lang_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_languages_lang_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3267 (class 0 OID 0)
-- Dependencies: 222
-- Name: odai_languages_lang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_languages_lang_id_seq" OWNED BY "odai_languages"."lang_id";


--
-- TOC entry 225 (class 1259 OID 16960)
-- Name: odai_menu; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_menu" (
    "id" integer NOT NULL,
    "menutype" character varying(24) NOT NULL,
    "title" character varying(255) NOT NULL,
    "alias" character varying(255) NOT NULL,
    "note" character varying(255) DEFAULT ''::character varying NOT NULL,
    "path" character varying(1024) DEFAULT ''::character varying NOT NULL,
    "link" character varying(1024) NOT NULL,
    "type" character varying(16) NOT NULL,
    "published" smallint DEFAULT 0 NOT NULL,
    "parent_id" integer DEFAULT 1 NOT NULL,
    "level" integer DEFAULT 0 NOT NULL,
    "component_id" integer DEFAULT 0 NOT NULL,
    "checked_out" integer DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "browserNav" smallint DEFAULT 0 NOT NULL,
    "access" bigint DEFAULT 0 NOT NULL,
    "img" character varying(255) DEFAULT ''::character varying NOT NULL,
    "template_style_id" integer DEFAULT 0 NOT NULL,
    "params" "text" DEFAULT ''::"text" NOT NULL,
    "lft" bigint DEFAULT 0 NOT NULL,
    "rgt" bigint DEFAULT 0 NOT NULL,
    "home" smallint DEFAULT 0 NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "client_id" smallint DEFAULT 0 NOT NULL
);


--
-- TOC entry 3268 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."menutype"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."menutype" IS 'The type of menu this item belongs to. FK to #__menu_types.menutype';


--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."title"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."title" IS 'The display title of the menu item.';


--
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."alias"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."alias" IS 'The SEF alias of the menu item.';


--
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."path"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."path" IS 'The computed path of the menu item based on the alias field.';


--
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."link"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."link" IS 'The actually link the menu item refers to.';


--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."type"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."type" IS 'The type of link: Component, URL, Alias, Separator';


--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."published"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."published" IS 'The published state of the menu link.';


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."parent_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."parent_id" IS 'The parent menu item in the menu tree.';


--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."level"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."level" IS 'The relative level in the tree.';


--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."component_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."component_id" IS 'FK to #__extensions.id';


--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."checked_out"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."checked_out" IS 'FK to #__users.id';


--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."checked_out_time"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."checked_out_time" IS 'The time the menu item was checked out.';


--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."browserNav"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."browserNav" IS 'The click behaviour of the link.';


--
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."access"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."access" IS 'The access level required to view the menu item.';


--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."img"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."img" IS 'The image of the menu item.';


--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."params"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."params" IS 'JSON encoded data for the menu item.';


--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."lft"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."lft" IS 'Nested set lft.';


--
-- TOC entry 3285 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."rgt"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."rgt" IS 'Nested set rgt.';


--
-- TOC entry 3286 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN "odai_menu"."home"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_menu"."home" IS 'Indicates if this menu item is the home or default page.';


--
-- TOC entry 224 (class 1259 OID 16958)
-- Name: odai_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_menu_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3287 (class 0 OID 0)
-- Dependencies: 224
-- Name: odai_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_menu_id_seq" OWNED BY "odai_menu"."id";


--
-- TOC entry 227 (class 1259 OID 16997)
-- Name: odai_menu_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_menu_types" (
    "id" integer NOT NULL,
    "menutype" character varying(24) NOT NULL,
    "title" character varying(48) NOT NULL,
    "description" character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 16995)
-- Name: odai_menu_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_menu_types_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3288 (class 0 OID 0)
-- Dependencies: 226
-- Name: odai_menu_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_menu_types_id_seq" OWNED BY "odai_menu_types"."id";


--
-- TOC entry 229 (class 1259 OID 17008)
-- Name: odai_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_messages" (
    "message_id" integer NOT NULL,
    "user_id_from" bigint DEFAULT 0 NOT NULL,
    "user_id_to" bigint DEFAULT 0 NOT NULL,
    "folder_id" smallint DEFAULT 0 NOT NULL,
    "date_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "state" smallint DEFAULT 0 NOT NULL,
    "priority" smallint DEFAULT 0 NOT NULL,
    "subject" character varying(255) DEFAULT ''::character varying NOT NULL,
    "message" "text" NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 17025)
-- Name: odai_messages_cfg; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_messages_cfg" (
    "user_id" bigint DEFAULT 0 NOT NULL,
    "cfg_name" character varying(100) DEFAULT ''::character varying NOT NULL,
    "cfg_value" character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 17006)
-- Name: odai_messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_messages_message_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3289 (class 0 OID 0)
-- Dependencies: 228
-- Name: odai_messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_messages_message_id_seq" OWNED BY "odai_messages"."message_id";


--
-- TOC entry 232 (class 1259 OID 17035)
-- Name: odai_modules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_modules" (
    "id" integer NOT NULL,
    "asset_id" bigint DEFAULT 0 NOT NULL,
    "title" character varying(100) DEFAULT ''::character varying NOT NULL,
    "note" character varying(255) DEFAULT ''::character varying NOT NULL,
    "content" "text" DEFAULT ''::"text" NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "position" character varying(50) DEFAULT ''::character varying NOT NULL,
    "checked_out" integer DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "published" smallint DEFAULT 0 NOT NULL,
    "module" character varying(50) DEFAULT NULL::character varying,
    "access" bigint DEFAULT 0 NOT NULL,
    "showtitle" smallint DEFAULT 1 NOT NULL,
    "params" "text" NOT NULL,
    "client_id" smallint DEFAULT 0 NOT NULL,
    "language" character varying(7) NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 17033)
-- Name: odai_modules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_modules_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3290 (class 0 OID 0)
-- Dependencies: 231
-- Name: odai_modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_modules_id_seq" OWNED BY "odai_modules"."id";


--
-- TOC entry 233 (class 1259 OID 17062)
-- Name: odai_modules_menu; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_modules_menu" (
    "moduleid" bigint DEFAULT 0 NOT NULL,
    "menuid" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 17071)
-- Name: odai_newsfeeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_newsfeeds" (
    "catid" bigint DEFAULT 0 NOT NULL,
    "id" integer NOT NULL,
    "name" character varying(100) DEFAULT ''::character varying NOT NULL,
    "alias" character varying(100) DEFAULT ''::character varying NOT NULL,
    "link" character varying(200) DEFAULT ''::character varying NOT NULL,
    "published" smallint DEFAULT 0 NOT NULL,
    "numarticles" bigint DEFAULT 1 NOT NULL,
    "cache_time" bigint DEFAULT 3600 NOT NULL,
    "checked_out" integer DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "rtl" smallint DEFAULT 0 NOT NULL,
    "access" bigint DEFAULT 0 NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "params" "text" NOT NULL,
    "created" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_by" integer DEFAULT 0 NOT NULL,
    "created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "modified" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_by" integer DEFAULT 0 NOT NULL,
    "metakey" "text" NOT NULL,
    "metadesc" "text" NOT NULL,
    "metadata" "text" NOT NULL,
    "xreference" character varying(50) NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "description" "text" NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL,
    "hits" bigint DEFAULT 0 NOT NULL,
    "images" "text" NOT NULL
);


--
-- TOC entry 3291 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "odai_newsfeeds"."xreference"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_newsfeeds"."xreference" IS 'A reference to enable linkages to external data sets.';


--
-- TOC entry 234 (class 1259 OID 17069)
-- Name: odai_newsfeeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_newsfeeds_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3292 (class 0 OID 0)
-- Dependencies: 234
-- Name: odai_newsfeeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_newsfeeds_id_seq" OWNED BY "odai_newsfeeds"."id";


--
-- TOC entry 280 (class 1259 OID 18971)
-- Name: odai_odai_apis; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_odai_apis" (
    "id" integer NOT NULL,
    "name" character varying(45) DEFAULT ''::character varying NOT NULL,
    "state" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 279 (class 1259 OID 18969)
-- Name: odai_odai_apis_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_odai_apis_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3293 (class 0 OID 0)
-- Dependencies: 279
-- Name: odai_odai_apis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_odai_apis_id_seq" OWNED BY "odai_odai_apis"."id";


--
-- TOC entry 278 (class 1259 OID 18949)
-- Name: odai_odai_datasources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_odai_datasources" (
    "id" integer NOT NULL,
    "name" character varying(45) DEFAULT ''::character varying NOT NULL,
    "state" bigint DEFAULT 0 NOT NULL,
    "jndiname" character varying(45) DEFAULT ''::character varying NOT NULL,
    "drivername" character varying(45) DEFAULT ''::character varying NOT NULL,
    "driverclass" character varying(45) DEFAULT ''::character varying NOT NULL,
    "connectionurl" character varying(100) DEFAULT ''::character varying NOT NULL,
    "user" character varying(45) DEFAULT ''::character varying NOT NULL,
    "password" character varying(45) DEFAULT ''::character varying NOT NULL,
    "vdb_id" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 277 (class 1259 OID 18947)
-- Name: odai_odai_datasources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_odai_datasources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 277
-- Name: odai_odai_datasources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_odai_datasources_id_seq" OWNED BY "odai_odai_datasources"."id";


--
-- TOC entry 276 (class 1259 OID 18931)
-- Name: odai_odai_resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_odai_resources" (
    "id" integer NOT NULL,
    "name" character varying(45) DEFAULT ''::character varying NOT NULL,
    "state" bigint DEFAULT 0 NOT NULL,
    "jndiname" character varying(45) DEFAULT ''::character varying NOT NULL,
    "resfile" character varying(80) DEFAULT ''::character varying NOT NULL,
    "vdb_id" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 275 (class 1259 OID 18929)
-- Name: odai_odai_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_odai_resources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3295 (class 0 OID 0)
-- Dependencies: 275
-- Name: odai_odai_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_odai_resources_id_seq" OWNED BY "odai_odai_resources"."id";


--
-- TOC entry 274 (class 1259 OID 18920)
-- Name: odai_odai_vdbs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_odai_vdbs" (
    "id" integer NOT NULL,
    "name" character varying(45) DEFAULT ''::character varying NOT NULL,
    "vdbfile" character varying(45) DEFAULT ''::character varying NOT NULL,
    "state" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 273 (class 1259 OID 18918)
-- Name: odai_odai_vdbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_odai_vdbs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3296 (class 0 OID 0)
-- Dependencies: 273
-- Name: odai_odai_vdbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_odai_vdbs_id_seq" OWNED BY "odai_odai_vdbs"."id";


--
-- TOC entry 237 (class 1259 OID 17111)
-- Name: odai_overrider; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_overrider" (
    "id" integer NOT NULL,
    "constant" character varying(255) NOT NULL,
    "string" "text" NOT NULL,
    "file" character varying(255) NOT NULL
);


--
-- TOC entry 3297 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN "odai_overrider"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_overrider"."id" IS 'Primary Key';


--
-- TOC entry 236 (class 1259 OID 17109)
-- Name: odai_overrider_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_overrider_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3298 (class 0 OID 0)
-- Dependencies: 236
-- Name: odai_overrider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_overrider_id_seq" OWNED BY "odai_overrider"."id";


--
-- TOC entry 239 (class 1259 OID 17122)
-- Name: odai_postinstall_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_postinstall_messages" (
    "postinstall_message_id" integer NOT NULL,
    "extension_id" bigint DEFAULT 700 NOT NULL,
    "title_key" character varying(255) DEFAULT ''::character varying NOT NULL,
    "description_key" character varying(255) DEFAULT ''::character varying NOT NULL,
    "action_key" character varying(255) DEFAULT ''::character varying NOT NULL,
    "language_extension" character varying(255) DEFAULT 'com_postinstall'::character varying NOT NULL,
    "language_client_id" smallint DEFAULT 1 NOT NULL,
    "type" character varying(10) DEFAULT 'link'::character varying NOT NULL,
    "action_file" character varying(255) DEFAULT ''::character varying,
    "action" character varying(255) DEFAULT ''::character varying,
    "condition_file" character varying(255) DEFAULT NULL::character varying,
    "condition_method" character varying(255) DEFAULT NULL::character varying,
    "version_introduced" character varying(255) DEFAULT '3.2.0'::character varying NOT NULL,
    "enabled" smallint DEFAULT 1 NOT NULL
);


--
-- TOC entry 3299 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."extension_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."extension_id" IS 'FK to jos_extensions';


--
-- TOC entry 3300 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."title_key"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."title_key" IS 'Lang key for the title';


--
-- TOC entry 3301 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."description_key"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."description_key" IS 'Lang key for description';


--
-- TOC entry 3302 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."language_extension"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."language_extension" IS 'Extension holding lang keys';


--
-- TOC entry 3303 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."type"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."type" IS 'Message type - message, link, action';


--
-- TOC entry 3304 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."action_file"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."action_file" IS 'RAD URI to the PHP file containing action method';


--
-- TOC entry 3305 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."action"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."action" IS 'Action method name or URL';


--
-- TOC entry 3306 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."condition_file"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."condition_file" IS 'RAD URI to file holding display condition method';


--
-- TOC entry 3307 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."condition_method"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."condition_method" IS 'Display condition method, must return boolean';


--
-- TOC entry 3308 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN "odai_postinstall_messages"."version_introduced"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_postinstall_messages"."version_introduced" IS 'Version when this message was introduced';


--
-- TOC entry 238 (class 1259 OID 17120)
-- Name: odai_postinstall_messages_postinstall_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_postinstall_messages_postinstall_message_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3309 (class 0 OID 0)
-- Dependencies: 238
-- Name: odai_postinstall_messages_postinstall_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_postinstall_messages_postinstall_message_id_seq" OWNED BY "odai_postinstall_messages"."postinstall_message_id";


--
-- TOC entry 241 (class 1259 OID 17146)
-- Name: odai_redirect_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_redirect_links" (
    "id" integer NOT NULL,
    "old_url" character varying(255) NOT NULL,
    "new_url" character varying(255) NOT NULL,
    "referer" character varying(150) NOT NULL,
    "comment" character varying(255) NOT NULL,
    "hits" bigint DEFAULT 0 NOT NULL,
    "published" smallint NOT NULL,
    "created_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_date" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 17144)
-- Name: odai_redirect_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_redirect_links_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3310 (class 0 OID 0)
-- Dependencies: 240
-- Name: odai_redirect_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_redirect_links_id_seq" OWNED BY "odai_redirect_links"."id";


--
-- TOC entry 242 (class 1259 OID 17161)
-- Name: odai_schemas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_schemas" (
    "extension_id" bigint NOT NULL,
    "version_id" character varying(20) NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 17166)
-- Name: odai_session; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_session" (
    "session_id" character varying(200) DEFAULT ''::character varying NOT NULL,
    "client_id" smallint DEFAULT 0 NOT NULL,
    "guest" smallint DEFAULT 1,
    "time" character varying(14) DEFAULT ''::character varying,
    "data" "text",
    "userid" bigint DEFAULT 0,
    "username" character varying(150) DEFAULT ''::character varying
);


--
-- TOC entry 245 (class 1259 OID 17184)
-- Name: odai_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_tags" (
    "id" integer NOT NULL,
    "parent_id" bigint DEFAULT 0 NOT NULL,
    "lft" bigint DEFAULT 0 NOT NULL,
    "rgt" bigint DEFAULT 0 NOT NULL,
    "level" integer DEFAULT 0 NOT NULL,
    "path" character varying(255) DEFAULT ''::character varying NOT NULL,
    "title" character varying(255) NOT NULL,
    "alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "note" character varying(255) DEFAULT ''::character varying NOT NULL,
    "description" "text" DEFAULT ''::"text" NOT NULL,
    "published" smallint DEFAULT 0 NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "access" bigint DEFAULT 0 NOT NULL,
    "params" "text" NOT NULL,
    "metadesc" character varying(1024) NOT NULL,
    "metakey" character varying(1024) NOT NULL,
    "metadata" character varying(2048) NOT NULL,
    "created_user_id" integer DEFAULT 0 NOT NULL,
    "created_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "modified_user_id" integer DEFAULT 0 NOT NULL,
    "modified_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "images" "text" NOT NULL,
    "urls" "text" NOT NULL,
    "hits" integer DEFAULT 0 NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 17182)
-- Name: odai_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_tags_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3311 (class 0 OID 0)
-- Dependencies: 244
-- Name: odai_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_tags_id_seq" OWNED BY "odai_tags"."id";


--
-- TOC entry 247 (class 1259 OID 17224)
-- Name: odai_template_styles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_template_styles" (
    "id" integer NOT NULL,
    "template" character varying(50) DEFAULT ''::character varying NOT NULL,
    "client_id" smallint DEFAULT 0 NOT NULL,
    "home" character varying(7) DEFAULT '0'::character varying NOT NULL,
    "title" character varying(255) DEFAULT ''::character varying NOT NULL,
    "params" "text" NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 17222)
-- Name: odai_template_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_template_styles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3312 (class 0 OID 0)
-- Dependencies: 246
-- Name: odai_template_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_template_styles_id_seq" OWNED BY "odai_template_styles"."id";


--
-- TOC entry 249 (class 1259 OID 17241)
-- Name: odai_ucm_base; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_ucm_base" (
    "ucm_id" integer NOT NULL,
    "ucm_item_id" bigint NOT NULL,
    "ucm_type_id" bigint NOT NULL,
    "ucm_language_id" bigint NOT NULL
);


--
-- TOC entry 248 (class 1259 OID 17239)
-- Name: odai_ucm_base_ucm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_ucm_base_ucm_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3313 (class 0 OID 0)
-- Dependencies: 248
-- Name: odai_ucm_base_ucm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_ucm_base_ucm_id_seq" OWNED BY "odai_ucm_base"."ucm_id";


--
-- TOC entry 251 (class 1259 OID 17252)
-- Name: odai_ucm_content; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_ucm_content" (
    "core_content_id" integer NOT NULL,
    "core_type_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "core_title" character varying(255) NOT NULL,
    "core_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "core_body" "text" NOT NULL,
    "core_state" smallint DEFAULT 0 NOT NULL,
    "core_checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "core_checked_out_user_id" bigint DEFAULT 0 NOT NULL,
    "core_access" bigint DEFAULT 0 NOT NULL,
    "core_params" "text" NOT NULL,
    "core_featured" smallint DEFAULT 0 NOT NULL,
    "core_metadata" "text" NOT NULL,
    "core_created_user_id" bigint DEFAULT 0 NOT NULL,
    "core_created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "core_created_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "core_modified_user_id" bigint DEFAULT 0 NOT NULL,
    "core_modified_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "core_language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "core_publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "core_publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "core_content_item_id" bigint DEFAULT 0 NOT NULL,
    "asset_id" bigint DEFAULT 0 NOT NULL,
    "core_images" "text" NOT NULL,
    "core_urls" "text" NOT NULL,
    "core_hits" bigint DEFAULT 0 NOT NULL,
    "core_version" bigint DEFAULT 1 NOT NULL,
    "core_ordering" bigint DEFAULT 0 NOT NULL,
    "core_metakey" "text" NOT NULL,
    "core_metadesc" "text" NOT NULL,
    "core_catid" bigint DEFAULT 0 NOT NULL,
    "core_xreference" character varying(50) DEFAULT ''::character varying NOT NULL,
    "core_type_id" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 250 (class 1259 OID 17250)
-- Name: odai_ucm_content_core_content_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_ucm_content_core_content_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3314 (class 0 OID 0)
-- Dependencies: 250
-- Name: odai_ucm_content_core_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_ucm_content_core_content_id_seq" OWNED BY "odai_ucm_content"."core_content_id";


--
-- TOC entry 253 (class 1259 OID 17300)
-- Name: odai_ucm_history; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_ucm_history" (
    "version_id" integer NOT NULL,
    "ucm_item_id" integer NOT NULL,
    "ucm_type_id" integer NOT NULL,
    "version_note" character varying(255) DEFAULT ''::character varying NOT NULL,
    "save_date" timestamp with time zone DEFAULT '1970-01-01 00:00:00+01'::timestamp with time zone NOT NULL,
    "editor_user_id" integer DEFAULT 0 NOT NULL,
    "character_count" integer DEFAULT 0 NOT NULL,
    "sha1_hash" character varying(50) DEFAULT ''::character varying NOT NULL,
    "version_data" "text" NOT NULL,
    "keep_forever" smallint DEFAULT 0 NOT NULL
);


--
-- TOC entry 3315 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN "odai_ucm_history"."version_note"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_ucm_history"."version_note" IS 'Optional version name';


--
-- TOC entry 3316 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN "odai_ucm_history"."character_count"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_ucm_history"."character_count" IS 'Number of characters in this version.';


--
-- TOC entry 3317 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN "odai_ucm_history"."sha1_hash"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_ucm_history"."sha1_hash" IS 'SHA1 hash of the version_data column.';


--
-- TOC entry 3318 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN "odai_ucm_history"."version_data"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_ucm_history"."version_data" IS 'json-encoded string of version data';


--
-- TOC entry 3319 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN "odai_ucm_history"."keep_forever"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_ucm_history"."keep_forever" IS '0=auto delete; 1=keep';


--
-- TOC entry 252 (class 1259 OID 17298)
-- Name: odai_ucm_history_version_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_ucm_history_version_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3320 (class 0 OID 0)
-- Dependencies: 252
-- Name: odai_ucm_history_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_ucm_history_version_id_seq" OWNED BY "odai_ucm_history"."version_id";


--
-- TOC entry 257 (class 1259 OID 17340)
-- Name: odai_update_sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_update_sites" (
    "update_site_id" integer NOT NULL,
    "name" character varying(100) DEFAULT ''::character varying,
    "type" character varying(20) DEFAULT ''::character varying,
    "location" "text" NOT NULL,
    "enabled" bigint DEFAULT 0,
    "last_check_timestamp" bigint DEFAULT 0,
    "extra_query" character varying(1000) DEFAULT ''::character varying
);


--
-- TOC entry 3321 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE "odai_update_sites"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "odai_update_sites" IS 'Update Sites';


--
-- TOC entry 258 (class 1259 OID 17354)
-- Name: odai_update_sites_extensions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_update_sites_extensions" (
    "update_site_id" bigint DEFAULT 0 NOT NULL,
    "extension_id" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 3322 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE "odai_update_sites_extensions"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "odai_update_sites_extensions" IS 'Links extensions to update sites';


--
-- TOC entry 256 (class 1259 OID 17338)
-- Name: odai_update_sites_update_site_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_update_sites_update_site_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3323 (class 0 OID 0)
-- Dependencies: 256
-- Name: odai_update_sites_update_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_update_sites_update_site_id_seq" OWNED BY "odai_update_sites"."update_site_id";


--
-- TOC entry 255 (class 1259 OID 17319)
-- Name: odai_updates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_updates" (
    "update_id" integer NOT NULL,
    "update_site_id" bigint DEFAULT 0,
    "extension_id" bigint DEFAULT 0,
    "name" character varying(100) DEFAULT ''::character varying,
    "description" "text" NOT NULL,
    "element" character varying(100) DEFAULT ''::character varying,
    "type" character varying(20) DEFAULT ''::character varying,
    "folder" character varying(20) DEFAULT ''::character varying,
    "client_id" smallint DEFAULT 0,
    "version" character varying(32) DEFAULT ''::character varying,
    "data" "text" DEFAULT ''::"text" NOT NULL,
    "detailsurl" "text" NOT NULL,
    "infourl" "text" NOT NULL,
    "extra_query" character varying(1000) DEFAULT ''::character varying
);


--
-- TOC entry 3324 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE "odai_updates"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "odai_updates" IS 'Available Updates';


--
-- TOC entry 254 (class 1259 OID 17317)
-- Name: odai_updates_update_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_updates_update_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3325 (class 0 OID 0)
-- Dependencies: 254
-- Name: odai_updates_update_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_updates_update_id_seq" OWNED BY "odai_updates"."update_id";


--
-- TOC entry 265 (class 1259 OID 17416)
-- Name: odai_user_keys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_user_keys" (
    "id" integer NOT NULL,
    "user_id" character varying(255) NOT NULL,
    "token" character varying(255) NOT NULL,
    "series" character varying(255) NOT NULL,
    "invalid" smallint NOT NULL,
    "time" character varying(200) NOT NULL,
    "uastring" character varying(255) NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 17414)
-- Name: odai_user_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_user_keys_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3326 (class 0 OID 0)
-- Dependencies: 264
-- Name: odai_user_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_user_keys_id_seq" OWNED BY "odai_user_keys"."id";


--
-- TOC entry 267 (class 1259 OID 17430)
-- Name: odai_user_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_user_notes" (
    "id" integer NOT NULL,
    "user_id" integer DEFAULT 0 NOT NULL,
    "catid" integer DEFAULT 0 NOT NULL,
    "subject" character varying(100) DEFAULT ''::character varying NOT NULL,
    "body" "text" NOT NULL,
    "state" smallint DEFAULT 0 NOT NULL,
    "checked_out" integer DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_user_id" integer DEFAULT 0 NOT NULL,
    "created_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_user_id" integer NOT NULL,
    "modified_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "review_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 17428)
-- Name: odai_user_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_user_notes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3327 (class 0 OID 0)
-- Dependencies: 266
-- Name: odai_user_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_user_notes_id_seq" OWNED BY "odai_user_notes"."id";


--
-- TOC entry 268 (class 1259 OID 17453)
-- Name: odai_user_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_user_profiles" (
    "user_id" bigint NOT NULL,
    "profile_key" character varying(100) NOT NULL,
    "profile_value" character varying(255) NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 3328 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE "odai_user_profiles"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "odai_user_profiles" IS 'Simple user profile storage table';


--
-- TOC entry 261 (class 1259 OID 17378)
-- Name: odai_user_usergroup_map; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_user_usergroup_map" (
    "user_id" bigint DEFAULT 0 NOT NULL,
    "group_id" bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 3329 (class 0 OID 0)
-- Dependencies: 261
-- Name: COLUMN "odai_user_usergroup_map"."user_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_user_usergroup_map"."user_id" IS 'Foreign Key to #__users.id';


--
-- TOC entry 3330 (class 0 OID 0)
-- Dependencies: 261
-- Name: COLUMN "odai_user_usergroup_map"."group_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_user_usergroup_map"."group_id" IS 'Foreign Key to #__usergroups.id';


--
-- TOC entry 260 (class 1259 OID 17363)
-- Name: odai_usergroups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_usergroups" (
    "id" integer NOT NULL,
    "parent_id" bigint DEFAULT 0 NOT NULL,
    "lft" bigint DEFAULT 0 NOT NULL,
    "rgt" bigint DEFAULT 0 NOT NULL,
    "title" character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 3331 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN "odai_usergroups"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_usergroups"."id" IS 'Primary Key';


--
-- TOC entry 3332 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN "odai_usergroups"."parent_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_usergroups"."parent_id" IS 'Adjacency List Reference Id';


--
-- TOC entry 3333 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN "odai_usergroups"."lft"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_usergroups"."lft" IS 'Nested set lft.';


--
-- TOC entry 3334 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN "odai_usergroups"."rgt"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_usergroups"."rgt" IS 'Nested set rgt.';


--
-- TOC entry 259 (class 1259 OID 17361)
-- Name: odai_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_usergroups_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3335 (class 0 OID 0)
-- Dependencies: 259
-- Name: odai_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_usergroups_id_seq" OWNED BY "odai_usergroups"."id";


--
-- TOC entry 263 (class 1259 OID 17387)
-- Name: odai_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_users" (
    "id" integer NOT NULL,
    "name" character varying(255) DEFAULT ''::character varying NOT NULL,
    "username" character varying(150) DEFAULT ''::character varying NOT NULL,
    "email" character varying(100) DEFAULT ''::character varying NOT NULL,
    "password" character varying(100) DEFAULT ''::character varying NOT NULL,
    "block" smallint DEFAULT 0 NOT NULL,
    "sendEmail" smallint DEFAULT 0,
    "registerDate" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "lastvisitDate" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "activation" character varying(100) DEFAULT ''::character varying NOT NULL,
    "params" "text" NOT NULL,
    "lastResetTime" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "resetCount" bigint DEFAULT 0 NOT NULL,
    "otpKey" character varying(1000) DEFAULT ''::character varying NOT NULL,
    "otep" character varying(1000) DEFAULT ''::character varying NOT NULL,
    "requireReset" smallint DEFAULT 0
);


--
-- TOC entry 3336 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN "odai_users"."lastResetTime"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_users"."lastResetTime" IS 'Date of last password reset';


--
-- TOC entry 3337 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN "odai_users"."resetCount"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_users"."resetCount" IS 'Count of password resets since lastResetTime';


--
-- TOC entry 3338 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN "odai_users"."requireReset"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_users"."requireReset" IS 'Require user to reset password on next login';


--
-- TOC entry 262 (class 1259 OID 17385)
-- Name: odai_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3339 (class 0 OID 0)
-- Dependencies: 262
-- Name: odai_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_users_id_seq" OWNED BY "odai_users"."id";


--
-- TOC entry 270 (class 1259 OID 17461)
-- Name: odai_viewlevels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_viewlevels" (
    "id" integer NOT NULL,
    "title" character varying(100) DEFAULT ''::character varying NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "rules" character varying(5120) NOT NULL
);


--
-- TOC entry 3340 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN "odai_viewlevels"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_viewlevels"."id" IS 'Primary Key';


--
-- TOC entry 3341 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN "odai_viewlevels"."rules"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_viewlevels"."rules" IS 'JSON encoded access control.';


--
-- TOC entry 269 (class 1259 OID 17459)
-- Name: odai_viewlevels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_viewlevels_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3342 (class 0 OID 0)
-- Dependencies: 269
-- Name: odai_viewlevels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_viewlevels_id_seq" OWNED BY "odai_viewlevels"."id";


--
-- TOC entry 272 (class 1259 OID 17476)
-- Name: odai_weblinks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "odai_weblinks" (
    "id" integer NOT NULL,
    "catid" bigint DEFAULT 0 NOT NULL,
    "title" character varying(250) DEFAULT ''::character varying NOT NULL,
    "alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "url" character varying(250) DEFAULT ''::character varying NOT NULL,
    "description" "text" NOT NULL,
    "hits" bigint DEFAULT 0 NOT NULL,
    "state" smallint DEFAULT 0 NOT NULL,
    "checked_out" bigint DEFAULT 0 NOT NULL,
    "checked_out_time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "ordering" bigint DEFAULT 0 NOT NULL,
    "access" bigint DEFAULT 1 NOT NULL,
    "params" "text" NOT NULL,
    "language" character varying(7) DEFAULT ''::character varying NOT NULL,
    "created" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "created_by" integer DEFAULT 0 NOT NULL,
    "created_by_alias" character varying(255) DEFAULT ''::character varying NOT NULL,
    "modified" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "modified_by" integer DEFAULT 0 NOT NULL,
    "metakey" "text" NOT NULL,
    "metadesc" "text" NOT NULL,
    "metadata" "text" NOT NULL,
    "featured" smallint DEFAULT 0 NOT NULL,
    "xreference" character varying(50) NOT NULL,
    "publish_up" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "publish_down" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    "version" bigint DEFAULT 1 NOT NULL,
    "images" "text" NOT NULL
);


--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN "odai_weblinks"."featured"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_weblinks"."featured" IS 'Set if link is featured.';


--
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN "odai_weblinks"."xreference"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "odai_weblinks"."xreference" IS 'A reference to enable linkages to external data sets.';


--
-- TOC entry 271 (class 1259 OID 17474)
-- Name: odai_weblinks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "odai_weblinks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3345 (class 0 OID 0)
-- Dependencies: 271
-- Name: odai_weblinks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "odai_weblinks_id_seq" OWNED BY "odai_weblinks"."id";


--
-- TOC entry 2214 (class 2604 OID 16400)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_assets" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_assets_id_seq"'::"regclass");


--
-- TOC entry 2248 (class 2604 OID 16469)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_banner_clients" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_banner_clients_id_seq"'::"regclass");


--
-- TOC entry 2218 (class 2604 OID 16424)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_banners" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_banners_id_seq"'::"regclass");


--
-- TOC entry 2261 (class 2604 OID 16502)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_categories_id_seq"'::"regclass");


--
-- TOC entry 2283 (class 2604 OID 16541)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_contact_details" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_contact_details_id_seq"'::"regclass");


--
-- TOC entry 2318 (class 2604 OID 16592)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_content" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_content_id_seq"'::"regclass");


--
-- TOC entry 2344 (class 2604 OID 16648)
-- Name: type_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_content_types" ALTER COLUMN "type_id" SET DEFAULT "nextval"('"odai_content_types_type_id_seq"'::"regclass");


--
-- TOC entry 2354 (class 2604 OID 16682)
-- Name: extension_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_extensions" ALTER COLUMN "extension_id" SET DEFAULT "nextval"('"odai_extensions_extension_id_seq"'::"regclass");


--
-- TOC entry 2364 (class 2604 OID 16705)
-- Name: filter_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_finder_filters" ALTER COLUMN "filter_id" SET DEFAULT "nextval"('"odai_finder_filters_filter_id_seq"'::"regclass");


--
-- TOC entry 2372 (class 2604 OID 16723)
-- Name: link_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_finder_links" ALTER COLUMN "link_id" SET DEFAULT "nextval"('"odai_finder_links_link_id_seq"'::"regclass");


--
-- TOC entry 2387 (class 2604 OID 16866)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_finder_taxonomy" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_finder_taxonomy_id_seq"'::"regclass");


--
-- TOC entry 2392 (class 2604 OID 16890)
-- Name: term_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_finder_terms" ALTER COLUMN "term_id" SET DEFAULT "nextval"('"odai_finder_terms_term_id_seq"'::"regclass");


--
-- TOC entry 2405 (class 2604 OID 16930)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_finder_types" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_finder_types_id_seq"'::"regclass");


--
-- TOC entry 2406 (class 2604 OID 16940)
-- Name: lang_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_languages" ALTER COLUMN "lang_id" SET DEFAULT "nextval"('"odai_languages_lang_id_seq"'::"regclass");


--
-- TOC entry 2411 (class 2604 OID 16963)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_menu" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_menu_id_seq"'::"regclass");


--
-- TOC entry 2430 (class 2604 OID 17000)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_menu_types" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_menu_types_id_seq"'::"regclass");


--
-- TOC entry 2432 (class 2604 OID 17011)
-- Name: message_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_messages" ALTER COLUMN "message_id" SET DEFAULT "nextval"('"odai_messages_message_id_seq"'::"regclass");


--
-- TOC entry 2443 (class 2604 OID 17038)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_modules" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_modules_id_seq"'::"regclass");


--
-- TOC entry 2462 (class 2604 OID 17075)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_newsfeeds" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_newsfeeds_id_seq"'::"regclass");


--
-- TOC entry 2669 (class 2604 OID 18974)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_odai_apis" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_odai_apis_id_seq"'::"regclass");


--
-- TOC entry 2659 (class 2604 OID 18952)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_odai_datasources" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_odai_datasources_id_seq"'::"regclass");


--
-- TOC entry 2653 (class 2604 OID 18934)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_odai_resources" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_odai_resources_id_seq"'::"regclass");


--
-- TOC entry 2649 (class 2604 OID 18923)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_odai_vdbs" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_odai_vdbs_id_seq"'::"regclass");


--
-- TOC entry 2484 (class 2604 OID 17114)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_overrider" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_overrider_id_seq"'::"regclass");


--
-- TOC entry 2485 (class 2604 OID 17125)
-- Name: postinstall_message_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_postinstall_messages" ALTER COLUMN "postinstall_message_id" SET DEFAULT "nextval"('"odai_postinstall_messages_postinstall_message_id_seq"'::"regclass");


--
-- TOC entry 2499 (class 2604 OID 17149)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_redirect_links" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_redirect_links_id_seq"'::"regclass");


--
-- TOC entry 2509 (class 2604 OID 17187)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_tags" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_tags_id_seq"'::"regclass");


--
-- TOC entry 2532 (class 2604 OID 17227)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_template_styles" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_template_styles_id_seq"'::"regclass");


--
-- TOC entry 2537 (class 2604 OID 17244)
-- Name: ucm_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_ucm_base" ALTER COLUMN "ucm_id" SET DEFAULT "nextval"('"odai_ucm_base_ucm_id_seq"'::"regclass");


--
-- TOC entry 2538 (class 2604 OID 17255)
-- Name: core_content_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_ucm_content" ALTER COLUMN "core_content_id" SET DEFAULT "nextval"('"odai_ucm_content_core_content_id_seq"'::"regclass");


--
-- TOC entry 2562 (class 2604 OID 17303)
-- Name: version_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_ucm_history" ALTER COLUMN "version_id" SET DEFAULT "nextval"('"odai_ucm_history_version_id_seq"'::"regclass");


--
-- TOC entry 2580 (class 2604 OID 17343)
-- Name: update_site_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_update_sites" ALTER COLUMN "update_site_id" SET DEFAULT "nextval"('"odai_update_sites_update_site_id_seq"'::"regclass");


--
-- TOC entry 2569 (class 2604 OID 17322)
-- Name: update_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_updates" ALTER COLUMN "update_id" SET DEFAULT "nextval"('"odai_updates_update_id_seq"'::"regclass");


--
-- TOC entry 2610 (class 2604 OID 17419)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_user_keys" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_user_keys_id_seq"'::"regclass");


--
-- TOC entry 2611 (class 2604 OID 17433)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_user_notes" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_user_notes_id_seq"'::"regclass");


--
-- TOC entry 2588 (class 2604 OID 17366)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_usergroups" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_usergroups_id_seq"'::"regclass");


--
-- TOC entry 2595 (class 2604 OID 17390)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_users" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_users_id_seq"'::"regclass");


--
-- TOC entry 2625 (class 2604 OID 17464)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_viewlevels" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_viewlevels_id_seq"'::"regclass");


--
-- TOC entry 2628 (class 2604 OID 17479)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_weblinks" ALTER COLUMN "id" SET DEFAULT "nextval"('"odai_weblinks_id_seq"'::"regclass");


--
-- TOC entry 3109 (class 0 OID 16397)
-- Dependencies: 171
-- Data for Name: odai_assets; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_assets" VALUES (2, 1, 1, 2, 1, 'com_admin', 'com_admin', '{}');
INSERT INTO "odai_assets" VALUES (3, 1, 3, 6, 1, 'com_banners', 'com_banners', '{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (4, 1, 7, 8, 1, 'com_cache', 'com_cache', '{"core.admin":{"7":1},"core.manage":{"7":1}}');
INSERT INTO "odai_assets" VALUES (5, 1, 9, 10, 1, 'com_checkin', 'com_checkin', '{"core.admin":{"7":1},"core.manage":{"7":1}}');
INSERT INTO "odai_assets" VALUES (6, 1, 11, 12, 1, 'com_config', 'com_config', '{}');
INSERT INTO "odai_assets" VALUES (7, 1, 13, 16, 1, 'com_contact', 'com_contact', '{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[],"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (8, 1, 17, 20, 1, 'com_content', 'com_content', '{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":{"3":1},"core.delete":[],"core.edit":{"4":1},"core.edit.state":{"5":1},"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (9, 1, 21, 22, 1, 'com_cpanel', 'com_cpanel', '{}');
INSERT INTO "odai_assets" VALUES (10, 1, 23, 24, 1, 'com_installer', 'com_installer', '{"core.admin":[],"core.manage":{"7":0},"core.delete":{"7":0},"core.edit.state":{"7":0}}');
INSERT INTO "odai_assets" VALUES (11, 1, 25, 26, 1, 'com_languages', 'com_languages', '{"core.admin":{"7":1},"core.manage":[],"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (12, 1, 27, 28, 1, 'com_login', 'com_login', '{}');
INSERT INTO "odai_assets" VALUES (13, 1, 29, 30, 1, 'com_mailto', 'com_mailto', '{}');
INSERT INTO "odai_assets" VALUES (14, 1, 31, 32, 1, 'com_massmail', 'com_massmail', '{}');
INSERT INTO "odai_assets" VALUES (15, 1, 33, 34, 1, 'com_media', 'com_media', '{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":{"3":1},"core.delete":{"5":1}}');
INSERT INTO "odai_assets" VALUES (16, 1, 35, 36, 1, 'com_menus', 'com_menus', '{"core.admin":{"7":1},"core.manage":[],"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (17, 1, 37, 38, 1, 'com_messages', 'com_messages', '{"core.admin":{"7":1},"core.manage":{"7":1}}');
INSERT INTO "odai_assets" VALUES (18, 1, 39, 70, 1, 'com_modules', 'com_modules', '{"core.admin":{"7":1},"core.manage":[],"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (19, 1, 71, 74, 1, 'com_newsfeeds', 'com_newsfeeds', '{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[],"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (20, 1, 75, 76, 1, 'com_plugins', 'com_plugins', '{"core.admin":{"7":1},"core.manage":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (21, 1, 77, 78, 1, 'com_redirect', 'com_redirect', '{"core.admin":{"7":1},"core.manage":[]}');
INSERT INTO "odai_assets" VALUES (22, 1, 79, 80, 1, 'com_search', 'com_search', '{"core.admin":{"7":1},"core.manage":{"6":1}}');
INSERT INTO "odai_assets" VALUES (23, 1, 81, 82, 1, 'com_templates', 'com_templates', '{"core.admin":{"7":1},"core.manage":[],"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (24, 1, 83, 86, 1, 'com_users', 'com_users', '{"core.admin":{"7":1},"core.manage":[],"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (25, 1, 87, 90, 1, 'com_weblinks', 'com_weblinks', '{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":{"3":1},"core.delete":[],"core.edit":{"4":1},"core.edit.state":{"5":1},"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (26, 1, 91, 92, 1, 'com_wrapper', 'com_wrapper', '{}');
INSERT INTO "odai_assets" VALUES (27, 8, 18, 19, 2, 'com_content.category.2', 'Uncategorised', '{"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[],"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (28, 3, 4, 5, 2, 'com_banners.category.3', 'Uncategorised', '{"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (29, 7, 14, 15, 2, 'com_contact.category.4', 'Uncategorised', '{"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[],"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (30, 19, 72, 73, 2, 'com_newsfeeds.category.5', 'Uncategorised', '{"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[],"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (31, 25, 88, 89, 2, 'com_weblinks.category.6', 'Uncategorised', '{"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[],"core.edit.own":[]}');
INSERT INTO "odai_assets" VALUES (32, 24, 84, 85, 1, 'com_users.category.7', 'Uncategorised', '{"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (33, 1, 93, 94, 1, 'com_finder', 'com_finder', '{"core.admin":{"7":1},"core.manage":{"6":1}}');
INSERT INTO "odai_assets" VALUES (34, 1, 95, 96, 1, 'com_joomlaupdate', 'com_joomlaupdate', '{"core.admin":[],"core.manage":[],"core.delete":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (35, 1, 97, 98, 1, 'com_tags', 'com_tags', '{"core.admin":[],"core.manage":[],"core.manage":[],"core.delete":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (36, 1, 99, 100, 1, 'com_contenthistory', 'com_contenthistory', '{}');
INSERT INTO "odai_assets" VALUES (37, 1, 101, 102, 1, 'com_ajax', 'com_ajax', '{}');
INSERT INTO "odai_assets" VALUES (38, 1, 103, 104, 1, 'com_postinstall', 'com_postinstall', '{}');
INSERT INTO "odai_assets" VALUES (39, 18, 40, 41, 2, 'com_modules.module.1', 'Main Menu', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (40, 18, 42, 43, 2, 'com_modules.module.2', 'Login', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (41, 18, 44, 45, 2, 'com_modules.module.3', 'Popular Articles', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (42, 18, 46, 47, 2, 'com_modules.module.4', 'Recently Added Articles', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (43, 18, 48, 49, 2, 'com_modules.module.8', 'Toolbar', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (44, 18, 50, 51, 2, 'com_modules.module.9', 'Quick Icons', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (45, 18, 52, 53, 2, 'com_modules.module.10', 'Logged-in Users', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (46, 18, 54, 55, 2, 'com_modules.module.12', 'Admin Menu', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (47, 18, 56, 57, 2, 'com_modules.module.13', 'Admin Submenu', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (48, 18, 58, 59, 2, 'com_modules.module.14', 'User Status', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (49, 18, 60, 61, 2, 'com_modules.module.15', 'Title', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (50, 18, 62, 63, 2, 'com_modules.module.16', 'Login Form', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (51, 18, 64, 65, 2, 'com_modules.module.17', 'Breadcrumbs', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (52, 18, 66, 67, 2, 'com_modules.module.79', 'Multilanguage status', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (53, 18, 68, 69, 2, 'com_modules.module.86', 'Joomla Version', '{"core.delete":[],"core.edit":[],"core.edit.state":[]}');
INSERT INTO "odai_assets" VALUES (1, 0, 0, 107, 0, 'root.1', 'Root Asset', '{"core.login.site":{"6":1,"2":1},"core.login.admin":{"6":1},"core.login.offline":{"6":1},"core.admin":{"8":1},"core.manage":{"7":1},"core.create":{"6":1,"3":1},"core.delete":{"6":1},"core.edit":{"6":1,"4":1},"core.edit.state":{"6":1,"5":1},"core.edit.own":{"6":1,"3":1}}');
INSERT INTO "odai_assets" VALUES (54, 1, 105, 106, 1, 'com_odaienv', 'odaienv', '{"core.admin":[],"core.manage":[],"core.create":[],"core.delete":[],"core.edit":[],"core.edit.state":[]}');


--
-- TOC entry 3346 (class 0 OID 0)
-- Dependencies: 170
-- Name: odai_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_assets_id_seq"', 54, true);


--
-- TOC entry 3110 (class 0 OID 16413)
-- Dependencies: 172
-- Data for Name: odai_associations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3114 (class 0 OID 16466)
-- Dependencies: 176
-- Data for Name: odai_banner_clients; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3347 (class 0 OID 0)
-- Dependencies: 175
-- Name: odai_banner_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_banner_clients_id_seq"', 1, false);


--
-- TOC entry 3115 (class 0 OID 16488)
-- Dependencies: 177
-- Data for Name: odai_banner_tracks; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3112 (class 0 OID 16421)
-- Dependencies: 174
-- Data for Name: odai_banners; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3348 (class 0 OID 0)
-- Dependencies: 173
-- Name: odai_banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_banners_id_seq"', 1, false);


--
-- TOC entry 3117 (class 0 OID 16499)
-- Dependencies: 179
-- Data for Name: odai_categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_categories" VALUES (1, 0, 0, 0, 13, 0, '', 'system', 'ROOT', 'root', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{}', '', '', '{}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);
INSERT INTO "odai_categories" VALUES (2, 27, 1, 1, 2, 1, 'uncategorised', 'com_content', 'Uncategorised', 'uncategorised', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{"category_layout":"","image":""}', '', '', '{"author":"","robots":""}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);
INSERT INTO "odai_categories" VALUES (3, 28, 1, 3, 4, 1, 'uncategorised', 'com_banners', 'Uncategorised', 'uncategorised', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{"category_layout":"","image":""}', '', '', '{"author":"","robots":""}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);
INSERT INTO "odai_categories" VALUES (4, 29, 1, 5, 6, 1, 'uncategorised', 'com_contact', 'Uncategorised', 'uncategorised', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{"category_layout":"","image":""}', '', '', '{"author":"","robots":""}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);
INSERT INTO "odai_categories" VALUES (5, 30, 1, 7, 8, 1, 'uncategorised', 'com_newsfeeds', 'Uncategorised', 'uncategorised', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{"category_layout":"","image":""}', '', '', '{"author":"","robots":""}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);
INSERT INTO "odai_categories" VALUES (6, 31, 1, 9, 10, 1, 'uncategorised', 'com_weblinks', 'Uncategorised', 'uncategorised', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{"category_layout":"","image":""}', '', '', '{"author":"","robots":""}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);
INSERT INTO "odai_categories" VALUES (7, 32, 1, 11, 12, 1, 'uncategorised', 'com_users', 'Uncategorised', 'uncategorised', '', '', 1, 0, '1970-01-01 00:00:00', 1, '{"category_layout":"","image":""}', '', '', '{"author":"","robots":""}', 42, '2011-01-01 00:00:01', 0, '1970-01-01 00:00:00', 0, '*', 1);


--
-- TOC entry 3349 (class 0 OID 0)
-- Dependencies: 178
-- Name: odai_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_categories_id_seq"', 1, false);


--
-- TOC entry 3119 (class 0 OID 16538)
-- Dependencies: 181
-- Data for Name: odai_contact_details; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3350 (class 0 OID 0)
-- Dependencies: 180
-- Name: odai_contact_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_contact_details_id_seq"', 1, false);


--
-- TOC entry 3121 (class 0 OID 16589)
-- Dependencies: 183
-- Data for Name: odai_content; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3122 (class 0 OID 16627)
-- Dependencies: 184
-- Data for Name: odai_content_frontpage; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3351 (class 0 OID 0)
-- Dependencies: 182
-- Name: odai_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_content_id_seq"', 1, false);


--
-- TOC entry 3123 (class 0 OID 16634)
-- Dependencies: 185
-- Data for Name: odai_content_rating; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3125 (class 0 OID 16645)
-- Dependencies: 187
-- Data for Name: odai_content_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_content_types" VALUES (1, 'Article', 'com_content.article', '{"special":{"dbtable":"#__content","key":"id","type":"Content","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"state","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"introtext", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"attribs", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"urls", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "core_xreference":"xreference", "asset_id":"asset_id"}, "special":{"fulltext":"fulltext"}}', 'ContentHelperRoute::getArticleRoute', '{"formFile":"administrator\/components\/com_content\/models\/forms\/article.xml", "hideFields":["asset_id","checked_out","checked_out_time","version"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits"],"convertToInt":["publish_up", "publish_down", "featured", "ordering"],"displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}');
INSERT INTO "odai_content_types" VALUES (2, 'Weblink', 'com_weblinks.weblink', '{"special":{"dbtable":"#__weblinks","key":"id","type":"Weblink","prefix":"WeblinksTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"state","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"description", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"urls", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "core_xreference":"xreference", "asset_id":"null"}, "special":{}}', 'WeblinksHelperRoute::getWeblinkRoute', '{"formFile":"administrator\/components\/com_weblinks\/models\/forms\/weblink.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","featured","images"], "ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits"], "convertToInt":["publish_up", "publish_down", "featured", "ordering"], "displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}');
INSERT INTO "odai_content_types" VALUES (3, 'Contact', 'com_contact.contact', '{"special":{"dbtable":"#__contact_details","key":"id","type":"Contact","prefix":"ContactTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"name","core_state":"published","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"address", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"image", "core_urls":"webpage", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "core_xreference":"xreference", "asset_id":"null"}, "special":{"con_position":"con_position","suburb":"suburb","state":"state","country":"country","postcode":"postcode","telephone":"telephone","fax":"fax","misc":"misc","email_to":"email_to","default_con":"default_con","user_id":"user_id","mobile":"mobile","sortname1":"sortname1","sortname2":"sortname2","sortname3":"sortname3"}}', 'ContactHelperRoute::getContactRoute', '{"formFile":"administrator\/components\/com_contact\/models\/forms\/contact.xml","hideFields":["default_con","checked_out","checked_out_time","version","xreference"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits"],"convertToInt":["publish_up", "publish_down", "featured", "ordering"], "displayLookup":[ {"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ] }');
INSERT INTO "odai_content_types" VALUES (4, 'Newsfeed', 'com_newsfeeds.newsfeed', '{"special":{"dbtable":"#__newsfeeds","key":"id","type":"Newsfeed","prefix":"NewsfeedsTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"name","core_state":"published","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"description", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"link", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "core_xreference":"xreference", "asset_id":"null"}, "special":{"numarticles":"numarticles","cache_time":"cache_time","rtl":"rtl"}}', 'NewsfeedsHelperRoute::getNewsfeedRoute', '{"formFile":"administrator\/components\/com_newsfeeds\/models\/forms\/newsfeed.xml","hideFields":["asset_id","checked_out","checked_out_time","version"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits"],"convertToInt":["publish_up", "publish_down", "featured", "ordering"],"displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}');
INSERT INTO "odai_content_types" VALUES (5, 'User', 'com_users.user', '{"special":{"dbtable":"#__users","key":"id","type":"User","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"name","core_state":"null","core_alias":"username","core_created_time":"registerdate","core_modified_time":"lastvisitDate","core_body":"null", "core_hits":"null","core_publish_up":"null","core_publish_down":"null","access":"null", "core_params":"params", "core_featured":"null", "core_metadata":"null", "core_language":"null", "core_images":"null", "core_urls":"null", "core_version":"null", "core_ordering":"null", "core_metakey":"null", "core_metadesc":"null", "core_catid":"null", "core_xreference":"null", "asset_id":"null"}, "special":{}}', 'UsersHelperRoute::getUserRoute', '');
INSERT INTO "odai_content_types" VALUES (6, 'Article Category', 'com_content.category', '{"special":{"dbtable":"#__categories","key":"id","type":"Category","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "core_xreference":"null", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}', 'ContentHelperRoute::getCategoryRoute', '{"formFile":"administrator\/components\/com_categories\/models\/forms\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}');
INSERT INTO "odai_content_types" VALUES (7, 'Contact Category', 'com_contact.category', '{"special":{"dbtable":"#__categories","key":"id","type":"Category","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "core_xreference":"null", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}', 'ContactHelperRoute::getCategoryRoute', '{"formFile":"administrator\/components\/com_categories\/models\/forms\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}');
INSERT INTO "odai_content_types" VALUES (8, 'Newsfeeds Category', 'com_newsfeeds.category', '{"special":{"dbtable":"#__categories","key":"id","type":"Category","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "core_xreference":"null", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}', 'NewsfeedsHelperRoute::getCategoryRoute', '{"formFile":"administrator\/components\/com_categories\/models\/forms\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}');
INSERT INTO "odai_content_types" VALUES (9, 'Weblinks Category', 'com_weblinks.category', '{"special":{"dbtable":"#__categories","key":"id","type":"Category","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "core_xreference":"null", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}', 'WeblinksHelperRoute::getCategoryRoute', '{"formFile":"administrator\/components\/com_categories\/models\/forms\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}');
INSERT INTO "odai_content_types" VALUES (10, 'Tag', 'com_tags.tag', '{"special":{"dbtable":"#__tags","key":"tag_id","type":"Tag","prefix":"TagsTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"urls", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"null", "core_xreference":"null", "asset_id":"null"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path"}}', 'TagsHelperRoute::getTagRoute', '{"formFile":"administrator\/components\/com_tags\/models\/forms\/tag.xml", "hideFields":["checked_out","checked_out_time","version", "lft", "rgt", "level", "path", "urls", "publish_up", "publish_down"],"ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"}, {"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}]}');
INSERT INTO "odai_content_types" VALUES (11, 'Banner', 'com_banners.banner', '{"special":{"dbtable":"#__banners","key":"id","type":"Banner","prefix":"BannersTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"name","core_state":"published","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"description", "core_hits":"null","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"link", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "core_xreference":"null", "asset_id":"null"}, "special":{"imptotal":"imptotal", "impmade":"impmade", "clicks":"clicks", "clickurl":"clickurl", "custombannercode":"custombannercode", "cid":"cid", "purchase_type":"purchase_type", "track_impressions":"track_impressions", "track_clicks":"track_clicks"}}', '', '{"formFile":"administrator\/components\/com_banners\/models\/forms\/banner.xml", "hideFields":["checked_out","checked_out_time","version", "reset"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "imptotal", "impmade", "reset"], "convertToInt":["publish_up", "publish_down", "ordering"], "displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}, {"sourceColumn":"cid","targetTable":"#__banner_clients","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}');
INSERT INTO "odai_content_types" VALUES (12, 'Banners Category', 'com_banners.category', '{"special":{"dbtable":"#__categories","key":"id","type":"Category","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "core_xreference":"null", "asset_id":"asset_id"}, "special": {"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}', '', '{"formFile":"administrator\/components\/com_categories\/models\/forms\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"], "convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}');
INSERT INTO "odai_content_types" VALUES (13, 'Banner Client', 'com_banners.client', '{"special":{"dbtable":"#__banner_clients","key":"id","type":"Client","prefix":"BannersTable"}}', '', '', '', '{"formFile":"administrator\/components\/com_banners\/models\/forms\/client.xml", "hideFields":["checked_out","checked_out_time"], "ignoreChanges":["checked_out", "checked_out_time"], "convertToInt":[], "displayLookup":[]}');
INSERT INTO "odai_content_types" VALUES (14, 'User Notes', 'com_users.note', '{"special":{"dbtable":"#__user_notes","key":"id","type":"Note","prefix":"UsersTable"}}', '', '', '', '{"formFile":"administrator\/components\/com_users\/models\/forms\/note.xml", "hideFields":["checked_out","checked_out_time", "publish_up", "publish_down"],"ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time"], "convertToInt":["publish_up", "publish_down"],"displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}, {"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}]}');
INSERT INTO "odai_content_types" VALUES (15, 'User Notes Category', 'com_users.category', '{"special":{"dbtable":"#__categories","key":"id","type":"Category","prefix":"JTable","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"JTable","config":"array()"}}', '', '{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "core_xreference":"null", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}', '', '{"formFile":"administrator\/components\/com_categories\/models\/forms\/category.xml", "hideFields":["checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"], "convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}');


--
-- TOC entry 3352 (class 0 OID 0)
-- Dependencies: 186
-- Name: odai_content_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_content_types_type_id_seq"', 10000, false);


--
-- TOC entry 3126 (class 0 OID 16660)
-- Dependencies: 188
-- Data for Name: odai_contentitem_tag_map; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3127 (class 0 OID 16672)
-- Dependencies: 189
-- Data for Name: odai_core_log_searches; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3129 (class 0 OID 16679)
-- Dependencies: 191
-- Data for Name: odai_extensions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_extensions" VALUES (103, 'Joomla! Platform', 'library', 'joomla', '', 0, 1, 1, 1, '{"name":"Joomla! Platform","type":"library","creationDate":"2008","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"http:\/\/www.joomla.org","version":"13.1","description":"LIB_JOOMLA_XML_DESCRIPTION","group":""}', '{"mediaversion":"a8fdc9a9c8b8664f94d20aac1d24f1f3"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (5, 'com_cache', 'component', 'com_cache', '', 1, 1, 1, 1, '{"name":"com_cache","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CACHE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (7, 'com_checkin', 'component', 'com_checkin', '', 1, 1, 1, 1, '{"name":"com_checkin","type":"component","creationDate":"Unknown","author":"Joomla! Project","copyright":"(C) 2005 - 2008 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CHECKIN_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (9, 'com_cpanel', 'component', 'com_cpanel', '', 1, 1, 1, 1, '{"name":"com_cpanel","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CPANEL_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (10, 'com_installer', 'component', 'com_installer', '', 1, 1, 1, 1, '{"name":"com_installer","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_INSTALLER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (12, 'com_login', 'component', 'com_login', '', 1, 1, 1, 1, '{"name":"com_login","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_LOGIN_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (14, 'com_menus', 'component', 'com_menus', '', 1, 1, 1, 1, '{"name":"com_menus","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_MENUS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (15, 'com_messages', 'component', 'com_messages', '', 1, 1, 1, 1, '{"name":"com_messages","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_MESSAGES_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (18, 'com_plugins', 'component', 'com_plugins', '', 1, 1, 1, 1, '{"name":"com_plugins","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_PLUGINS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (19, 'com_search', 'component', 'com_search', '', 1, 1, 1, 0, '{"name":"com_search","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_SEARCH_XML_DESCRIPTION","group":""}', '{"enabled":"0","show_date":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (20, 'com_templates', 'component', 'com_templates', '', 1, 1, 1, 1, '{"name":"com_templates","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_TEMPLATES_XML_DESCRIPTION","group":""}', '{"template_positions_display":"0","upload_limit":"2","image_formats":"gif,bmp,jpg,jpeg,png","source_formats":"txt,less,ini,xml,js,php,css","font_formats":"woff,ttf,otf","compressed_formats":"zip"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (308, 'mod_quickicon', 'module', 'mod_quickicon', '', 1, 1, 1, 1, '{"name":"mod_quickicon","type":"module","creationDate":"Nov 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_QUICKICON_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (309, 'mod_status', 'module', 'mod_status', '', 1, 1, 1, 0, '{"name":"mod_status","type":"module","creationDate":"Feb 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_STATUS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (11, 'com_languages', 'component', 'com_languages', '', 1, 1, 1, 1, '{"name":"com_languages","type":"component","creationDate":"2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_LANGUAGES_XML_DESCRIPTION","group":""}', '{"administrator":"en-GB","site":"en-GB"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (24, 'com_redirect', 'component', 'com_redirect', '', 1, 1, 0, 1, '{"name":"com_redirect","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_REDIRECT_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (27, 'com_finder', 'component', 'com_finder', '', 1, 1, 0, 0, '{"name":"com_finder","type":"component","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_FINDER_XML_DESCRIPTION","group":""}', '{"show_description":"1","description_length":255,"allow_empty_query":"0","show_url":"1","show_advanced":"1","expand_advanced":"0","show_date_filters":"0","highlight_terms":"1","opensearch_name":"","opensearch_description":"","batch_size":"50","memory_table_limit":30000,"title_multiplier":"1.7","text_multiplier":"0.7","meta_multiplier":"1.2","path_multiplier":"2.0","misc_multiplier":"0.3","stemmer":"snowball"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (28, 'com_joomlaupdate', 'component', 'com_joomlaupdate', '', 1, 1, 0, 1, '{"name":"com_joomlaupdate","type":"component","creationDate":"February 2012","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_JOOMLAUPDATE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (30, 'com_contenthistory', 'component', 'com_contenthistory', '', 1, 1, 1, 0, '{"name":"com_contenthistory","type":"component","creationDate":"May 2013","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"COM_CONTENTHISTORY_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (31, 'com_ajax', 'component', 'com_ajax', '', 1, 1, 1, 0, '{"name":"com_ajax","type":"component","creationDate":"August 2013","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"COM_AJAX_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (32, 'com_postinstall', 'component', 'com_postinstall', '', 1, 1, 1, 1, '{"name":"com_postinstall","type":"component","creationDate":"September 2013","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"COM_POSTINSTALL_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (101, 'SimplePie', 'library', 'simplepie', '', 0, 1, 1, 1, '{"name":"SimplePie","type":"library","creationDate":"2004","author":"SimplePie","copyright":"Copyright (c) 2004-2009, Ryan Parman and Geoffrey Sneddon","authorEmail":"","authorUrl":"http:\/\/simplepie.org\/","version":"1.2","description":"LIB_SIMPLEPIE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (104, 'IDNA Convert', 'library', 'idna_convert', '', 0, 1, 1, 1, '{"name":"IDNA Convert","type":"library","creationDate":"2004","author":"phlyLabs","copyright":"2004-2011 phlyLabs Berlin, http:\/\/phlylabs.de","authorEmail":"phlymail@phlylabs.de","authorUrl":"http:\/\/phlylabs.de","version":"0.8.0","description":"LIB_IDNA_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (201, 'mod_articles_latest', 'module', 'mod_articles_latest', '', 0, 1, 1, 0, '{"name":"mod_articles_latest","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LATEST_NEWS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (204, 'mod_breadcrumbs', 'module', 'mod_breadcrumbs', '', 0, 1, 1, 1, '{"name":"mod_breadcrumbs","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_BREADCRUMBS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (208, 'mod_login', 'module', 'mod_login', '', 0, 1, 1, 1, '{"name":"mod_login","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LOGIN_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (212, 'mod_related_items', 'module', 'mod_related_items', '', 0, 1, 1, 0, '{"name":"mod_related_items","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_RELATED_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (215, 'mod_syndicate', 'module', 'mod_syndicate', '', 0, 1, 1, 1, '{"name":"mod_syndicate","type":"module","creationDate":"May 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_SYNDICATE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (219, 'mod_wrapper', 'module', 'mod_wrapper', '', 0, 1, 1, 0, '{"name":"mod_wrapper","type":"module","creationDate":"October 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_WRAPPER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (222, 'mod_languages', 'module', 'mod_languages', '', 0, 1, 1, 1, '{"name":"mod_languages","type":"module","creationDate":"February 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LANGUAGES_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (302, 'mod_latest', 'module', 'mod_latest', '', 1, 1, 1, 0, '{"name":"mod_latest","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LATEST_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (307, 'mod_popular', 'module', 'mod_popular', '', 1, 1, 1, 0, '{"name":"mod_popular","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_POPULAR_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (213, 'mod_search', 'module', 'mod_search', '', 0, 1, 1, 0, '{"name":"mod_search","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_SEARCH_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (312, 'mod_toolbar', 'module', 'mod_toolbar', '', 1, 1, 1, 1, '{"name":"mod_toolbar","type":"module","creationDate":"Nov 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_TOOLBAR_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (316, 'mod_tags_popular', 'module', 'mod_tags_popular', '', 0, 1, 1, 0, '{"name":"mod_tags_popular","type":"module","creationDate":"January 2013","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.1.0","description":"MOD_TAGS_POPULAR_XML_DESCRIPTION","group":""}', '{"maximum":"5","timeframe":"alltime","owncache":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (400, 'plg_authentication_gmail', 'plugin', 'gmail', 'authentication', 0, 0, 1, 0, '{"name":"plg_authentication_gmail","type":"plugin","creationDate":"February 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_GMAIL_XML_DESCRIPTION","group":""}', '{"applysuffix":"0","suffix":"","verifypeer":"1","user_blacklist":""}', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (403, 'plg_content_contact', 'plugin', 'contact', 'content', 0, 1, 1, 0, '{"name":"plg_content_contact","type":"plugin","creationDate":"January 2014","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.2","description":"PLG_CONTENT_CONTACT_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (406, 'plg_content_loadmodule', 'plugin', 'loadmodule', 'content', 0, 1, 1, 0, '{"name":"plg_content_loadmodule","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_LOADMODULE_XML_DESCRIPTION","group":""}', '{"style":"xhtml"}', '', '', 0, '2011-09-18 15:22:50', 0, 0);
INSERT INTO "odai_extensions" VALUES (409, 'plg_content_vote', 'plugin', 'vote', 'content', 0, 1, 1, 0, '{"name":"plg_content_vote","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_VOTE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 6, 0);
INSERT INTO "odai_extensions" VALUES (411, 'plg_editors_none', 'plugin', 'none', 'editors', 0, 1, 1, 1, '{"name":"plg_editors_none","type":"plugin","creationDate":"August 2004","author":"Unknown","copyright":"","authorEmail":"N\/A","authorUrl":"","version":"3.0.0","description":"PLG_NONE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 2, 0);
INSERT INTO "odai_extensions" VALUES (413, 'plg_editors-xtd_article', 'plugin', 'article', 'editors-xtd', 0, 1, 1, 1, '{"name":"plg_editors-xtd_article","type":"plugin","creationDate":"October 2009","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_ARTICLE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (414, 'plg_editors-xtd_image', 'plugin', 'image', 'editors-xtd', 0, 1, 1, 0, '{"name":"plg_editors-xtd_image","type":"plugin","creationDate":"August 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_IMAGE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 2, 0);
INSERT INTO "odai_extensions" VALUES (415, 'plg_editors-xtd_pagebreak', 'plugin', 'pagebreak', 'editors-xtd', 0, 1, 1, 0, '{"name":"plg_editors-xtd_pagebreak","type":"plugin","creationDate":"August 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_EDITORSXTD_PAGEBREAK_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 3, 0);
INSERT INTO "odai_extensions" VALUES (418, 'plg_search_contacts', 'plugin', 'contacts', 'search', 0, 1, 1, 0, '{"name":"plg_search_contacts","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEARCH_CONTACTS_XML_DESCRIPTION","group":""}', '{"search_limit":"50","search_content":"1","search_archived":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (421, 'plg_search_weblinks', 'plugin', 'weblinks', 'search', 0, 1, 1, 0, '{"name":"plg_search_weblinks","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEARCH_WEBLINKS_XML_DESCRIPTION","group":""}', '{"search_limit":"50","search_content":"1","search_archived":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (424, 'plg_system_cache', 'plugin', 'cache', 'system', 0, 0, 1, 1, '{"name":"plg_system_cache","type":"plugin","creationDate":"February 2007","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CACHE_XML_DESCRIPTION","group":""}', '{"browsercache":"0","cachetime":"15"}', '', '', 0, '1970-01-01 00:00:00', 9, 0);
INSERT INTO "odai_extensions" VALUES (426, 'plg_system_log', 'plugin', 'log', 'system', 0, 1, 1, 1, '{"name":"plg_system_log","type":"plugin","creationDate":"April 2007","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_LOG_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 5, 0);
INSERT INTO "odai_extensions" VALUES (429, 'plg_system_sef', 'plugin', 'sef', 'system', 0, 1, 1, 0, '{"name":"plg_system_sef","type":"plugin","creationDate":"December 2007","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEF_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 8, 0);
INSERT INTO "odai_extensions" VALUES (1, 'com_mailto', 'component', 'com_mailto', '', 0, 1, 1, 1, '{"name":"com_mailto","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_MAILTO_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (2, 'com_wrapper', 'component', 'com_wrapper', '', 0, 1, 1, 1, '{"name":"com_wrapper","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_WRAPPER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (3, 'com_admin', 'component', 'com_admin', '', 1, 1, 1, 1, '{"name":"com_admin","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_ADMIN_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (4, 'com_banners', 'component', 'com_banners', '', 1, 1, 1, 0, '{"name":"com_banners","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_BANNERS_XML_DESCRIPTION","group":""}', '{"purchase_type":"3","track_impressions":"0","track_clicks":"0","metakey_prefix":"","save_history":"1","history_limit":5}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (6, 'com_categories', 'component', 'com_categories', '', 1, 1, 1, 1, '{"name":"com_categories","type":"component","creationDate":"December 2007","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CATEGORIES_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (434, 'plg_extension_joomla', 'plugin', 'joomla', 'extension', 0, 1, 1, 1, '{"name":"plg_extension_joomla","type":"plugin","creationDate":"May 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_EXTENSION_JOOMLA_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (435, 'plg_content_joomla', 'plugin', 'joomla', 'content', 0, 1, 1, 0, '{"name":"plg_content_joomla","type":"plugin","creationDate":"November 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_JOOMLA_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (436, 'plg_system_languagecode', 'plugin', 'languagecode', 'system', 0, 0, 1, 0, '{"name":"plg_system_languagecode","type":"plugin","creationDate":"November 2011","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_LANGUAGECODE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 10, 0);
INSERT INTO "odai_extensions" VALUES (440, 'plg_system_highlight', 'plugin', 'highlight', 'system', 0, 1, 1, 0, '{"name":"plg_system_highlight","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_HIGHLIGHT_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 7, 0);
INSERT INTO "odai_extensions" VALUES (443, 'plg_finder_contacts', 'plugin', 'contacts', 'finder', 0, 1, 1, 0, '{"name":"plg_finder_contacts","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_CONTACTS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 2, 0);
INSERT INTO "odai_extensions" VALUES (446, 'plg_finder_weblinks', 'plugin', 'weblinks', 'finder', 0, 1, 1, 0, '{"name":"plg_finder_weblinks","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_WEBLINKS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 5, 0);
INSERT INTO "odai_extensions" VALUES (450, 'plg_twofactorauth_yubikey', 'plugin', 'yubikey', 'twofactorauth', 0, 0, 1, 0, '{"name":"plg_twofactorauth_yubikey","type":"plugin","creationDate":"September 2013","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"PLG_TWOFACTORAUTH_YUBIKEY_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (504, 'hathor', 'template', 'hathor', '', 1, 1, 1, 0, '{"name":"hathor","type":"template","creationDate":"May 2010","author":"Andrea Tarr","copyright":"Copyright (C) 2005 - 2014 Open Source Matters, Inc. All rights reserved.","authorEmail":"hathor@tarrconsulting.com","authorUrl":"http:\/\/www.tarrconsulting.com","version":"3.0.0","description":"TPL_HATHOR_XML_DESCRIPTION","group":""}', '{"showSiteName":"0","colourChoice":"0","boldText":"0"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (507, 'isis', 'template', 'isis', '', 1, 1, 1, 0, '{"name":"isis","type":"template","creationDate":"3\/30\/2012","author":"Kyle Ledbetter","copyright":"Copyright (C) 2005 - 2014 Open Source Matters, Inc. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"","version":"1.0","description":"TPL_ISIS_XML_DESCRIPTION","group":""}', '{"templateColor":"","logoFile":""}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (8, 'com_contact', 'component', 'com_contact', '', 1, 1, 1, 0, '{"name":"com_contact","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CONTACT_XML_DESCRIPTION","group":""}', '{"show_contact_category":"hide","save_history":"1","history_limit":10,"show_contact_list":"0","presentation_style":"sliders","show_name":"1","show_position":"1","show_email":"0","show_street_address":"1","show_suburb":"1","show_state":"1","show_postcode":"1","show_country":"1","show_telephone":"1","show_mobile":"1","show_fax":"1","show_webpage":"1","show_misc":"1","show_image":"1","image":"","allow_vcard":"0","show_articles":"0","show_profile":"0","show_links":"0","linka_name":"","linkb_name":"","linkc_name":"","linkd_name":"","linke_name":"","contact_icons":"0","icon_address":"","icon_email":"","icon_telephone":"","icon_mobile":"","icon_fax":"","icon_misc":"","show_headings":"1","show_position_headings":"1","show_email_headings":"0","show_telephone_headings":"1","show_mobile_headings":"0","show_fax_headings":"0","allow_vcard_headings":"0","show_suburb_headings":"1","show_state_headings":"1","show_country_headings":"1","show_email_form":"1","show_email_copy":"1","banned_email":"","banned_subject":"","banned_text":"","validate_session":"1","custom_reply":"0","redirect":"","show_category_crumb":"0","metakey":"","metadesc":"","robots":"","author":"","rights":"","xreference":""}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (13, 'com_media', 'component', 'com_media', '', 1, 1, 0, 1, '{"name":"com_media","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_MEDIA_XML_DESCRIPTION","group":""}', '{"upload_extensions":"bmp,csv,doc,gif,ico,jpg,jpeg,odg,odp,ods,odt,pdf,png,ppt,swf,txt,xcf,xls,BMP,CSV,DOC,GIF,ICO,JPG,JPEG,ODG,ODP,ODS,ODT,PDF,PNG,PPT,SWF,TXT,XCF,XLS","upload_maxsize":"10","file_path":"images","image_path":"images","restrict_uploads":"1","allowed_media_usergroup":"3","check_mime":"1","image_extensions":"bmp,gif,jpg,png","ignore_extensions":"","upload_mime":"image\/jpeg,image\/gif,image\/png,image\/bmp,application\/x-shockwave-flash,application\/msword,application\/excel,application\/pdf,application\/powerpoint,text\/plain,application\/x-zip","upload_mime_illegal":"text\/html"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (16, 'com_modules', 'component', 'com_modules', '', 1, 1, 1, 1, '{"name":"com_modules","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_MODULES_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (17, 'com_newsfeeds', 'component', 'com_newsfeeds', '', 1, 1, 1, 0, '{"name":"com_newsfeeds","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_NEWSFEEDS_XML_DESCRIPTION","group":""}', '{"newsfeed_layout":"_:default","save_history":"1","history_limit":5,"show_feed_image":"1","show_feed_description":"1","show_item_description":"1","feed_character_count":"0","feed_display_order":"des","float_first":"right","float_second":"right","show_tags":"1","category_layout":"_:default","show_category_title":"1","show_description":"1","show_description_image":"1","maxLevel":"-1","show_empty_categories":"0","show_subcat_desc":"1","show_cat_items":"1","show_cat_tags":"1","show_base_description":"1","maxLevelcat":"-1","show_empty_categories_cat":"0","show_subcat_desc_cat":"1","show_cat_items_cat":"1","filter_field":"1","show_pagination_limit":"1","show_headings":"1","show_articles":"0","show_link":"1","show_pagination":"1","show_pagination_results":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (21, 'com_weblinks', 'component', 'com_weblinks', '', 1, 1, 1, 0, '{"name":"com_weblinks","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\n\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_WEBLINKS_XML_DESCRIPTION","group":""}', '{"target":"0","save_history":"1","history_limit":5,"count_clicks":"1","icons":1,"link_icons":"","float_first":"right","float_second":"right","show_tags":"1","category_layout":"_:default","show_category_title":"1","show_description":"1","show_description_image":"1","maxLevel":"-1","show_empty_categories":"0","show_subcat_desc":"1","show_cat_num_links":"1","show_cat_tags":"1","show_base_description":"1","maxLevelcat":"-1","show_empty_categories_cat":"0","show_subcat_desc_cat":"1","show_cat_num_links_cat":"1","filter_field":"1","show_pagination_limit":"1","show_headings":"0","show_link_description":"1","show_link_hits":"1","show_pagination":"2","show_pagination_results":"1","show_feed_link":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (22, 'com_content', 'component', 'com_content', '', 1, 1, 0, 1, '{"name":"com_content","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CONTENT_XML_DESCRIPTION","group":""}', '{"article_layout":"_:default","show_title":"1","link_titles":"1","show_intro":"1","show_category":"1","link_category":"1","show_parent_category":"0","link_parent_category":"0","show_author":"1","link_author":"0","show_create_date":"0","show_modify_date":"0","show_publish_date":"1","show_item_navigation":"1","show_vote":"0","show_readmore":"1","show_readmore_title":"1","readmore_limit":"100","show_icons":"1","show_print_icon":"1","show_email_icon":"1","show_hits":"1","show_noauth":"0","show_publishing_options":"1","show_article_options":"1","save_history":"1","history_limit":10,"show_urls_images_frontend":"0","show_urls_images_backend":"1","targeta":0,"targetb":0,"targetc":0,"float_intro":"left","float_fulltext":"left","category_layout":"_:blog","show_category_title":"0","show_description":"0","show_description_image":"0","maxLevel":"1","show_empty_categories":"0","show_no_articles":"1","show_subcat_desc":"1","show_cat_num_articles":"0","show_base_description":"1","maxLevelcat":"-1","show_empty_categories_cat":"0","show_subcat_desc_cat":"1","show_cat_num_articles_cat":"1","num_leading_articles":"1","num_intro_articles":"4","num_columns":"2","num_links":"4","multi_column_order":"0","show_subcategory_content":"0","show_pagination_limit":"1","filter_field":"hide","show_headings":"1","list_show_date":"0","date_format":"","list_show_hits":"1","list_show_author":"1","orderby_pri":"order","orderby_sec":"rdate","order_date":"published","show_pagination":"2","show_pagination_results":"1","show_feed_link":"1","feed_summary":"0"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (211, 'mod_random_image', 'module', 'mod_random_image', '', 0, 1, 1, 0, '{"name":"mod_random_image","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_RANDOM_IMAGE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (25, 'com_users', 'component', 'com_users', '', 1, 1, 0, 1, '{"name":"com_users","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_USERS_XML_DESCRIPTION","group":""}', '{"allowUserRegistration":"1","new_usertype":"2","guest_usergroup":"9","sendpassword":"1","useractivation":"1","mail_to_admin":"0","captcha":"","frontend_userparams":"1","site_language":"0","change_login_name":"0","reset_count":"10","reset_time":"1","minimum_length":"4","minimum_integers":"0","minimum_symbols":"0","minimum_uppercase":"0","save_history":"1","history_limit":5,"mailSubjectPrefix":"","mailBodySuffix":""}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (29, 'com_tags', 'component', 'com_tags', '', 1, 1, 1, 1, '{"name":"com_tags","type":"component","creationDate":"December 2013","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.1.0","description":"COM_TAGS_XML_DESCRIPTION","group":""}', '{"tag_layout":"_:default","save_history":"1","history_limit":5,"show_tag_title":"0","tag_list_show_tag_image":"0","tag_list_show_tag_description":"0","tag_list_image":"","show_tag_num_items":"0","tag_list_orderby":"title","tag_list_orderby_direction":"ASC","show_headings":"0","tag_list_show_date":"0","tag_list_show_item_image":"0","tag_list_show_item_description":"0","tag_list_item_maximum_characters":0,"return_any_or_all":"1","include_children":"0","maximum":200,"tag_list_language_filter":"all","tags_layout":"_:default","all_tags_orderby":"title","all_tags_orderby_direction":"ASC","all_tags_show_tag_image":"0","all_tags_show_tag_descripion":"0","all_tags_tag_maximum_characters":20,"all_tags_show_tag_hits":"0","filter_field":"1","show_pagination_limit":"1","show_pagination":"2","show_pagination_results":"1","tag_field_ajax_mode":"1","show_feed_link":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (100, 'PHPMailer', 'library', 'phpmailer', '', 0, 1, 1, 1, '{"name":"PHPMailer","type":"library","creationDate":"2001","author":"PHPMailer","copyright":"(c) 2001-2003, Brent R. Matzelle, (c) 2004-2009, Andy Prevost. All Rights Reserved., (c) 2010-2013, Jim Jagielski. All Rights Reserved.","authorEmail":"jimjag@gmail.com","authorUrl":"https:\/\/github.com\/PHPMailer\/PHPMailer","version":"5.2.6","description":"LIB_PHPMAILER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (102, 'phputf8', 'library', 'phputf8', '', 0, 1, 1, 1, '{"name":"phputf8","type":"library","creationDate":"2006","author":"Harry Fuecks","copyright":"Copyright various authors","authorEmail":"hfuecks@gmail.com","authorUrl":"http:\/\/sourceforge.net\/projects\/phputf8","version":"0.5","description":"LIB_PHPUTF8_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (105, 'FOF', 'library', 'fof', '', 0, 1, 1, 1, '{"name":"FOF","type":"library","creationDate":"2014-03-09 12:54:48","author":"Nicholas K. Dionysopoulos \/ Akeeba Ltd","copyright":"(C)2011-2014 Nicholas K. Dionysopoulos","authorEmail":"nicholas@akeebabackup.com","authorUrl":"https:\/\/www.akeebabackup.com","version":"2.2.1","description":"LIB_FOF_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (106, 'PHPass', 'library', 'phpass', '', 0, 1, 1, 1, '{"name":"PHPass","type":"library","creationDate":"2004-2006","author":"Solar Designer","copyright":"","authorEmail":"solar@openwall.com","authorUrl":"http:\/\/www.openwall.com\/phpass\/","version":"0.3","description":"LIB_PHPASS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (200, 'mod_articles_archive', 'module', 'mod_articles_archive', '', 0, 1, 1, 0, '{"name":"mod_articles_archive","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters.\n\t\tAll rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_ARCHIVE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (202, 'mod_articles_popular', 'module', 'mod_articles_popular', '', 0, 1, 1, 0, '{"name":"mod_articles_popular","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_POPULAR_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (203, 'mod_banners', 'module', 'mod_banners', '', 0, 1, 1, 0, '{"name":"mod_banners","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_BANNERS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (205, 'mod_custom', 'module', 'mod_custom', '', 0, 1, 1, 1, '{"name":"mod_custom","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_CUSTOM_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (206, 'mod_feed', 'module', 'mod_feed', '', 0, 1, 1, 0, '{"name":"mod_feed","type":"module","creationDate":"July 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FEED_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (207, 'mod_footer', 'module', 'mod_footer', '', 0, 1, 1, 0, '{"name":"mod_footer","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FOOTER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (209, 'mod_menu', 'module', 'mod_menu', '', 0, 1, 1, 1, '{"name":"mod_menu","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_MENU_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (210, 'mod_articles_news', 'module', 'mod_articles_news', '', 0, 1, 1, 0, '{"name":"mod_articles_news","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_NEWS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (214, 'mod_stats', 'module', 'mod_stats', '', 0, 1, 1, 0, '{"name":"mod_stats","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_STATS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (216, 'mod_users_latest', 'module', 'mod_users_latest', '', 0, 1, 1, 0, '{"name":"mod_users_latest","type":"module","creationDate":"December 2009","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_USERS_LATEST_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (217, 'mod_weblinks', 'module', 'mod_weblinks', '', 0, 1, 1, 0, '{"name":"mod_weblinks","type":"module","creationDate":"July 2009","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_WEBLINKS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (218, 'mod_whosonline', 'module', 'mod_whosonline', '', 0, 1, 1, 0, '{"name":"mod_whosonline","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_WHOSONLINE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (220, 'mod_articles_category', 'module', 'mod_articles_category', '', 0, 1, 1, 0, '{"name":"mod_articles_category","type":"module","creationDate":"February 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_CATEGORY_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (221, 'mod_articles_categories', 'module', 'mod_articles_categories', '', 0, 1, 1, 0, '{"name":"mod_articles_categories","type":"module","creationDate":"February 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_CATEGORIES_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (223, 'mod_finder', 'module', 'mod_finder', '', 0, 1, 0, 0, '{"name":"mod_finder","type":"module","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FINDER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (300, 'mod_custom', 'module', 'mod_custom', '', 1, 1, 1, 1, '{"name":"mod_custom","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_CUSTOM_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (301, 'mod_feed', 'module', 'mod_feed', '', 1, 1, 1, 0, '{"name":"mod_feed","type":"module","creationDate":"July 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FEED_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (303, 'mod_logged', 'module', 'mod_logged', '', 1, 1, 1, 0, '{"name":"mod_logged","type":"module","creationDate":"January 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LOGGED_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (304, 'mod_login', 'module', 'mod_login', '', 1, 1, 1, 1, '{"name":"mod_login","type":"module","creationDate":"March 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LOGIN_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (305, 'mod_menu', 'module', 'mod_menu', '', 1, 1, 1, 0, '{"name":"mod_menu","type":"module","creationDate":"March 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_MENU_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (310, 'mod_submenu', 'module', 'mod_submenu', '', 1, 1, 1, 0, '{"name":"mod_submenu","type":"module","creationDate":"Feb 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_SUBMENU_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (311, 'mod_title', 'module', 'mod_title', '', 1, 1, 1, 0, '{"name":"mod_title","type":"module","creationDate":"Nov 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_TITLE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (313, 'mod_multilangstatus', 'module', 'mod_multilangstatus', '', 1, 1, 1, 0, '{"name":"mod_multilangstatus","type":"module","creationDate":"September 2011","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_MULTILANGSTATUS_XML_DESCRIPTION","group":""}', '{"cache":"0"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (314, 'mod_version', 'module', 'mod_version', '', 1, 1, 1, 0, '{"name":"mod_version","type":"module","creationDate":"January 2012","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_VERSION_XML_DESCRIPTION","group":""}', '{"format":"short","product":"1","cache":"0"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (315, 'mod_stats_admin', 'module', 'mod_stats_admin', '', 1, 1, 1, 0, '{"name":"mod_stats_admin","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_STATS_XML_DESCRIPTION","group":""}', '{"serverinfo":"0","siteinfo":"0","counter":"0","increase":"0","cache":"1","cache_time":"900","cachemode":"static"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (317, 'mod_tags_similar', 'module', 'mod_tags_similar', '', 0, 1, 1, 0, '{"name":"mod_tags_similar","type":"module","creationDate":"January 2013","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.1.0","description":"MOD_TAGS_SIMILAR_XML_DESCRIPTION","group":""}', '{"maximum":"5","matchtype":"any","owncache":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (401, 'plg_authentication_joomla', 'plugin', 'joomla', 'authentication', 0, 1, 1, 1, '{"name":"plg_authentication_joomla","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_AUTH_JOOMLA_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (402, 'plg_authentication_ldap', 'plugin', 'ldap', 'authentication', 0, 0, 1, 0, '{"name":"plg_authentication_ldap","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_LDAP_XML_DESCRIPTION","group":""}', '{"host":"","port":"389","use_ldapV3":"0","negotiate_tls":"0","no_referrals":"0","auth_method":"bind","base_dn":"","search_string":"","users_dn":"","username":"admin","password":"bobby7","ldap_fullname":"fullName","ldap_email":"mail","ldap_uid":"uid"}', '', '', 0, '1970-01-01 00:00:00', 3, 0);
INSERT INTO "odai_extensions" VALUES (404, 'plg_content_emailcloak', 'plugin', 'emailcloak', 'content', 0, 1, 1, 0, '{"name":"plg_content_emailcloak","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_EMAILCLOAK_XML_DESCRIPTION","group":""}', '{"mode":"1"}', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (407, 'plg_content_pagebreak', 'plugin', 'pagebreak', 'content', 0, 1, 1, 0, '{"name":"plg_content_pagebreak","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_PAGEBREAK_XML_DESCRIPTION","group":""}', '{"title":"1","multipage_toc":"1","showall":"1"}', '', '', 0, '1970-01-01 00:00:00', 4, 0);
INSERT INTO "odai_extensions" VALUES (408, 'plg_content_pagenavigation', 'plugin', 'pagenavigation', 'content', 0, 1, 1, 0, '{"name":"plg_content_pagenavigation","type":"plugin","creationDate":"January 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_PAGENAVIGATION_XML_DESCRIPTION","group":""}', '{"position":"1"}', '', '', 0, '1970-01-01 00:00:00', 5, 0);
INSERT INTO "odai_extensions" VALUES (410, 'plg_editors_codemirror', 'plugin', 'codemirror', 'editors', 0, 1, 1, 1, '{"name":"plg_editors_codemirror","type":"plugin","creationDate":"28 March 2011","author":"Marijn Haverbeke","copyright":"","authorEmail":"N\/A","authorUrl":"","version":"3.15","description":"PLG_CODEMIRROR_XML_DESCRIPTION","group":""}', '{"lineNumbers":"1","lineWrapping":"1","matchTags":"1","matchBrackets":"1","marker-gutter":"1","autoCloseTags":"1","autoCloseBrackets":"1","autoFocus":"1","theme":"default","tabmode":"indent"}', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (412, 'plg_editors_tinymce', 'plugin', 'tinymce', 'editors', 0, 1, 1, 0, '{"name":"plg_editors_tinymce","type":"plugin","creationDate":"2005-2013","author":"Moxiecode Systems AB","copyright":"Moxiecode Systems AB","authorEmail":"N\/A","authorUrl":"tinymce.moxiecode.com","version":"4.0.22","description":"PLG_TINY_XML_DESCRIPTION","group":""}', '{"mode":"1","skin":"0","mobile":"0","entity_encoding":"raw","lang_mode":"1","text_direction":"ltr","content_css":"1","content_css_custom":"","relative_urls":"1","newlines":"0","invalid_elements":"script,applet,iframe","extended_elements":"","html_height":"550","html_width":"750","resizing":"1","element_path":"1","fonts":"1","paste":"1","searchreplace":"1","insertdate":"1","colors":"1","table":"1","smilies":"1","hr":"1","link":"1","media":"1","print":"1","directionality":"1","fullscreen":"1","alignment":"1","visualchars":"1","visualblocks":"1","nonbreaking":"1","template":"1","blockquote":"1","wordcount":"1","advlist":"1","autosave":"1","contextmenu":"1","inlinepopups":"1","custom_plugin":"","custom_button":""}', '', '', 0, '1970-01-01 00:00:00', 3, 0);
INSERT INTO "odai_extensions" VALUES (416, 'plg_editors-xtd_readmore', 'plugin', 'readmore', 'editors-xtd', 0, 1, 1, 0, '{"name":"plg_editors-xtd_readmore","type":"plugin","creationDate":"March 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_READMORE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 4, 0);
INSERT INTO "odai_extensions" VALUES (417, 'plg_search_categories', 'plugin', 'categories', 'search', 0, 1, 1, 0, '{"name":"plg_search_categories","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEARCH_CATEGORIES_XML_DESCRIPTION","group":""}', '{"search_limit":"50","search_content":"1","search_archived":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (419, 'plg_search_content', 'plugin', 'content', 'search', 0, 1, 1, 0, '{"name":"plg_search_content","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEARCH_CONTENT_XML_DESCRIPTION","group":""}', '{"search_limit":"50","search_content":"1","search_archived":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (420, 'plg_search_newsfeeds', 'plugin', 'newsfeeds', 'search', 0, 1, 1, 0, '{"name":"plg_search_newsfeeds","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEARCH_NEWSFEEDS_XML_DESCRIPTION","group":""}', '{"search_limit":"50","search_content":"1","search_archived":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (422, 'plg_system_languagefilter', 'plugin', 'languagefilter', 'system', 0, 0, 1, 1, '{"name":"plg_system_languagefilter","type":"plugin","creationDate":"July 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_LANGUAGEFILTER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (423, 'plg_system_p3p', 'plugin', 'p3p', 'system', 0, 1, 1, 0, '{"name":"plg_system_p3p","type":"plugin","creationDate":"September 2010","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_P3P_XML_DESCRIPTION","group":""}', '{"headers":"NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"}', '', '', 0, '1970-01-01 00:00:00', 2, 0);
INSERT INTO "odai_extensions" VALUES (425, 'plg_system_debug', 'plugin', 'debug', 'system', 0, 1, 1, 0, '{"name":"plg_system_debug","type":"plugin","creationDate":"December 2006","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_DEBUG_XML_DESCRIPTION","group":""}', '{"profile":"1","queries":"1","memory":"1","language_files":"1","language_strings":"1","strip-first":"1","strip-prefix":"","strip-suffix":""}', '', '', 0, '1970-01-01 00:00:00', 4, 0);
INSERT INTO "odai_extensions" VALUES (427, 'plg_system_redirect', 'plugin', 'redirect', 'system', 0, 0, 1, 1, '{"name":"plg_system_redirect","type":"plugin","creationDate":"April 2009","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_REDIRECT_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 6, 0);
INSERT INTO "odai_extensions" VALUES (428, 'plg_system_remember', 'plugin', 'remember', 'system', 0, 1, 1, 1, '{"name":"plg_system_remember","type":"plugin","creationDate":"April 2007","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_REMEMBER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 7, 0);
INSERT INTO "odai_extensions" VALUES (430, 'plg_system_logout', 'plugin', 'logout', 'system', 0, 1, 1, 1, '{"name":"plg_system_logout","type":"plugin","creationDate":"April 2009","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_LOGOUT_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 3, 0);
INSERT INTO "odai_extensions" VALUES (431, 'plg_user_contactcreator', 'plugin', 'contactcreator', 'user', 0, 0, 1, 0, '{"name":"plg_user_contactcreator","type":"plugin","creationDate":"August 2009","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTACTCREATOR_XML_DESCRIPTION","group":""}', '{"autowebpage":"","category":"34","autopublish":"0"}', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (432, 'plg_user_joomla', 'plugin', 'joomla', 'user', 0, 1, 1, 0, '{"name":"plg_user_joomla","type":"plugin","creationDate":"December 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2009 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_USER_JOOMLA_XML_DESCRIPTION","group":""}', '{"strong_passwords":"1","autoregister":"1"}', '', '', 0, '1970-01-01 00:00:00', 2, 0);
INSERT INTO "odai_extensions" VALUES (433, 'plg_user_profile', 'plugin', 'profile', 'user', 0, 0, 1, 0, '{"name":"plg_user_profile","type":"plugin","creationDate":"January 2008","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_USER_PROFILE_XML_DESCRIPTION","group":""}', '{"register-require_address1":"1","register-require_address2":"1","register-require_city":"1","register-require_region":"1","register-require_country":"1","register-require_postal_code":"1","register-require_phone":"1","register-require_website":"1","register-require_favoritebook":"1","register-require_aboutme":"1","register-require_tos":"1","register-require_dob":"1","profile-require_address1":"1","profile-require_address2":"1","profile-require_city":"1","profile-require_region":"1","profile-require_country":"1","profile-require_postal_code":"1","profile-require_phone":"1","profile-require_website":"1","profile-require_favoritebook":"1","profile-require_aboutme":"1","profile-require_tos":"1","profile-require_dob":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (437, 'plg_quickicon_joomlaupdate', 'plugin', 'joomlaupdate', 'quickicon', 0, 1, 1, 1, '{"name":"plg_quickicon_joomlaupdate","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_QUICKICON_JOOMLAUPDATE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (438, 'plg_quickicon_extensionupdate', 'plugin', 'extensionupdate', 'quickicon', 0, 1, 1, 1, '{"name":"plg_quickicon_extensionupdate","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_QUICKICON_EXTENSIONUPDATE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (439, 'plg_captcha_recaptcha', 'plugin', 'recaptcha', 'captcha', 0, 0, 1, 0, '{"name":"plg_captcha_recaptcha","type":"plugin","creationDate":"December 2011","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CAPTCHA_RECAPTCHA_XML_DESCRIPTION","group":""}', '{"public_key":"","private_key":"","theme":"clean"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (441, 'plg_content_finder', 'plugin', 'finder', 'content', 0, 0, 1, 0, '{"name":"plg_content_finder","type":"plugin","creationDate":"December 2011","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_FINDER_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (442, 'plg_finder_categories', 'plugin', 'categories', 'finder', 0, 1, 1, 0, '{"name":"plg_finder_categories","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_CATEGORIES_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 1, 0);
INSERT INTO "odai_extensions" VALUES (444, 'plg_finder_content', 'plugin', 'content', 'finder', 0, 1, 1, 0, '{"name":"plg_finder_content","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_CONTENT_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 3, 0);
INSERT INTO "odai_extensions" VALUES (445, 'plg_finder_newsfeeds', 'plugin', 'newsfeeds', 'finder', 0, 1, 1, 0, '{"name":"plg_finder_newsfeeds","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_NEWSFEEDS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 4, 0);
INSERT INTO "odai_extensions" VALUES (447, 'plg_finder_tags', 'plugin', 'tags', 'finder', 0, 1, 1, 0, '{"name":"plg_finder_tags","type":"plugin","creationDate":"February 2013","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_TAGS_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (448, 'plg_twofactorauth_totp', 'plugin', 'totp', 'twofactorauth', 0, 0, 1, 0, '{"name":"plg_twofactorauth_totp","type":"plugin","creationDate":"August 2013","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"PLG_TWOFACTORAUTH_TOTP_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (449, 'plg_authentication_cookie', 'plugin', 'cookie', 'authentication', 0, 1, 1, 0, '{"name":"plg_authentication_cookie","type":"plugin","creationDate":"July 2013","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_AUTH_COOKIE_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (451, 'plg_search_tags', 'plugin', 'tags', 'search', 0, 1, 1, 0, '{"name":"plg_search_tags","type":"plugin","creationDate":"March 2014","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEARCH_TAGS_XML_DESCRIPTION","group":""}', '{"search_limit":"50","show_tagged_items":"1"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (503, 'beez3', 'template', 'beez3', '', 0, 1, 1, 0, '{"name":"beez3","type":"template","creationDate":"25 November 2009","author":"Angie Radtke","copyright":"Copyright (C) 2005 - 2014 Open Source Matters, Inc. All rights reserved.","authorEmail":"a.radtke@derauftritt.de","authorUrl":"http:\/\/www.der-auftritt.de","version":"3.1.0","description":"TPL_BEEZ3_XML_DESCRIPTION","group":""}', '{"wrapperSmall":"53","wrapperLarge":"72","sitetitle":"","sitedescription":"","navposition":"center","templatecolor":"nature"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (506, 'protostar', 'template', 'protostar', '', 0, 1, 1, 0, '{"name":"protostar","type":"template","creationDate":"4\/30\/2012","author":"Kyle Ledbetter","copyright":"Copyright (C) 2005 - 2014 Open Source Matters, Inc. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"","version":"1.0","description":"TPL_PROTOSTAR_XML_DESCRIPTION","group":""}', '{"templateColor":"","logoFile":"","googleFont":"1","googleFontName":"Open+Sans","fluidContainer":"0"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (600, 'English (United Kingdom)', 'language', 'en-GB', '', 0, 1, 1, 1, '{"name":"English (United Kingdom)","type":"language","creationDate":"2013-03-07","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.3.1","description":"en-GB site language","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (601, 'English (United Kingdom)', 'language', 'en-GB', '', 1, 1, 1, 1, '{"name":"English (United Kingdom)","type":"language","creationDate":"2013-03-07","author":"Joomla! Project","copyright":"Copyright (C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.3.1","description":"en-GB administrator language","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (700, 'files_joomla', 'file', 'joomla', '', 0, 1, 1, 1, '{"name":"files_joomla","type":"file","creationDate":"June 2014","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.3.1","description":"FILES_JOOMLA_XML_DESCRIPTION","group":""}', '', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (23, 'com_config', 'component', 'com_config', '', 1, 1, 0, 1, '{"name":"com_config","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2005 - 2014 Open Source Matters. All rights reserved.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_CONFIG_XML_DESCRIPTION","group":""}', '{"filters":{"1":{"filter_type":"NH","filter_tags":"","filter_attributes":""},"9":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"6":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"7":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"2":{"filter_type":"NH","filter_tags":"","filter_attributes":""},"3":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"4":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"5":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"8":{"filter_type":"NONE","filter_tags":"","filter_attributes":""}}}', '', '', 0, '1970-01-01 00:00:00', 0, 0);
INSERT INTO "odai_extensions" VALUES (10002, 'odaienv', 'component', 'com_odaienv', '', 1, 1, 0, 0, '{"name":"Odaienv","type":"component","creationDate":"2014-07-07","author":"Luca Gioppo","copyright":"Copyright (C) 2014 Luca Gioppo. All rights reserved.","authorEmail":"info@example.com","authorUrl":"http:\/\/www.example.com","version":"1.0","description":"","group":""}', '{"endpoint":"http:\/\/194.116.109.5:8080\/client\/api","domid":"ebd7fb49-7aff-4897-aee2-e51f22ab22b8","zoneid":"ffa01bab-94f9-4606-86fa-f312dc1a5ba8","api_key":"Ur9STWwyu88Ua4v7fDq8Q1G2V5lfjL79vQIUevkzn3hhPaBI6mr6IIiKjIwN24OcOFpJOoSyNZXMglZ18gDEgw","secret_key":"Fq4MagOZHCMPOgqUq-6eltVKqlp82yx0SsrJHLzgEMwhK_KT_ZbSHrtpm8DwaZ9FA4CW4I0wIdhKrijCWri5Nw","jboss_user":"admin","jboss_pwd":"JBP1234","jboss_dom":"domain","jboss_srg":"JBS1234","file_cript_key":"FCK1234"}', '', '', 0, '1970-01-01 00:00:00', 0, 0);


--
-- TOC entry 3353 (class 0 OID 0)
-- Dependencies: 190
-- Name: odai_extensions_extension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_extensions_extension_id_seq"', 10002, true);


--
-- TOC entry 3131 (class 0 OID 16702)
-- Dependencies: 193
-- Data for Name: odai_finder_filters; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3354 (class 0 OID 0)
-- Dependencies: 192
-- Name: odai_finder_filters_filter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_finder_filters_filter_id_seq"', 1, false);


--
-- TOC entry 3133 (class 0 OID 16720)
-- Dependencies: 195
-- Data for Name: odai_finder_links; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 194
-- Name: odai_finder_links_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_finder_links_link_id_seq"', 1, false);


--
-- TOC entry 3134 (class 0 OID 16749)
-- Dependencies: 196
-- Data for Name: odai_finder_links_terms0; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3135 (class 0 OID 16756)
-- Dependencies: 197
-- Data for Name: odai_finder_links_terms1; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3136 (class 0 OID 16763)
-- Dependencies: 198
-- Data for Name: odai_finder_links_terms2; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3137 (class 0 OID 16770)
-- Dependencies: 199
-- Data for Name: odai_finder_links_terms3; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3138 (class 0 OID 16777)
-- Dependencies: 200
-- Data for Name: odai_finder_links_terms4; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3139 (class 0 OID 16784)
-- Dependencies: 201
-- Data for Name: odai_finder_links_terms5; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3140 (class 0 OID 16791)
-- Dependencies: 202
-- Data for Name: odai_finder_links_terms6; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3141 (class 0 OID 16798)
-- Dependencies: 203
-- Data for Name: odai_finder_links_terms7; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3142 (class 0 OID 16805)
-- Dependencies: 204
-- Data for Name: odai_finder_links_terms8; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3143 (class 0 OID 16812)
-- Dependencies: 205
-- Data for Name: odai_finder_links_terms9; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3144 (class 0 OID 16819)
-- Dependencies: 206
-- Data for Name: odai_finder_links_termsa; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3145 (class 0 OID 16826)
-- Dependencies: 207
-- Data for Name: odai_finder_links_termsb; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3146 (class 0 OID 16833)
-- Dependencies: 208
-- Data for Name: odai_finder_links_termsc; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3147 (class 0 OID 16840)
-- Dependencies: 209
-- Data for Name: odai_finder_links_termsd; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3148 (class 0 OID 16847)
-- Dependencies: 210
-- Data for Name: odai_finder_links_termse; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3149 (class 0 OID 16854)
-- Dependencies: 211
-- Data for Name: odai_finder_links_termsf; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3151 (class 0 OID 16863)
-- Dependencies: 213
-- Data for Name: odai_finder_taxonomy; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_finder_taxonomy" VALUES (1, 0, 'ROOT', 0, 0, 0);


--
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 212
-- Name: odai_finder_taxonomy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_finder_taxonomy_id_seq"', 1, false);


--
-- TOC entry 3152 (class 0 OID 16878)
-- Dependencies: 214
-- Data for Name: odai_finder_taxonomy_map; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3154 (class 0 OID 16887)
-- Dependencies: 216
-- Data for Name: odai_finder_terms; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3155 (class 0 OID 16902)
-- Dependencies: 217
-- Data for Name: odai_finder_terms_common; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_finder_terms_common" VALUES ('a', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('about', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('after', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('ago', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('all', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('am', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('an', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('and', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('ani', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('any', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('are', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('aren''t', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('as', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('at', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('be', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('but', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('by', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('for', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('from', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('get', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('go', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('how', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('if', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('in', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('into', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('is', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('isn''t', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('it', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('its', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('me', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('more', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('most', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('must', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('my', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('new', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('no', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('none', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('not', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('noth', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('nothing', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('of', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('off', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('often', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('old', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('on', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('onc', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('once', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('onli', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('only', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('or', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('other', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('our', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('ours', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('out', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('over', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('page', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('she', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('should', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('small', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('so', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('some', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('than', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('thank', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('that', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('the', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('their', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('theirs', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('them', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('then', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('there', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('these', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('they', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('this', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('those', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('thus', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('time', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('times', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('to', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('too', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('true', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('under', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('until', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('up', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('upon', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('use', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('user', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('users', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('veri', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('version', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('very', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('via', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('want', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('was', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('way', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('were', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('what', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('when', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('where', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('whi', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('which', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('who', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('whom', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('whose', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('why', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('wide', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('will', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('with', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('within', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('without', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('would', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('yes', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('yet', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('you', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('your', 'en');
INSERT INTO "odai_finder_terms_common" VALUES ('yours', 'en');


--
-- TOC entry 3357 (class 0 OID 0)
-- Dependencies: 215
-- Name: odai_finder_terms_term_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_finder_terms_term_id_seq"', 1, false);


--
-- TOC entry 3156 (class 0 OID 16908)
-- Dependencies: 218
-- Data for Name: odai_finder_tokens; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3157 (class 0 OID 16917)
-- Dependencies: 219
-- Data for Name: odai_finder_tokens_aggregate; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3159 (class 0 OID 16927)
-- Dependencies: 221
-- Data for Name: odai_finder_types; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3358 (class 0 OID 0)
-- Dependencies: 220
-- Name: odai_finder_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_finder_types_id_seq"', 1, false);


--
-- TOC entry 3161 (class 0 OID 16937)
-- Dependencies: 223
-- Data for Name: odai_languages; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_languages" VALUES (1, 'en-GB', 'English (UK)', 'English (UK)', 'en', 'en', '', '', '', '', 1, 1, 1);


--
-- TOC entry 3359 (class 0 OID 0)
-- Dependencies: 222
-- Name: odai_languages_lang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_languages_lang_id_seq"', 1, false);


--
-- TOC entry 3163 (class 0 OID 16960)
-- Dependencies: 225
-- Data for Name: odai_menu; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_menu" VALUES (12, 'menu', 'com_messages_read', 'Read Private Message', '', 'Messaging/Read Private Message', 'index.php?option=com_messages', 'component', 0, 10, 2, 15, 0, '1970-01-01 00:00:00', 0, 0, 'class:messages-read', 0, '', 20, 21, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (10, 'menu', 'com_messages', 'Messaging', '', 'Messaging', 'index.php?option=com_messages', 'component', 0, 1, 1, 15, 0, '1970-01-01 00:00:00', 0, 0, 'class:messages', 0, '', 17, 22, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (18, 'menu', 'com_weblinks', 'Weblinks', '', 'Weblinks', 'index.php?option=com_weblinks', 'component', 0, 1, 1, 21, 0, '1970-01-01 00:00:00', 0, 0, 'class:weblinks', 0, '', 33, 38, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (21, 'menu', 'com_finder', 'Smart Search', '', 'Smart Search', 'index.php?option=com_finder', 'component', 0, 1, 1, 27, 0, '1970-01-01 00:00:00', 0, 0, 'class:finder', 0, '', 39, 40, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (22, 'menu', 'com_joomlaupdate', 'Joomla! Update', '', 'Joomla! Update', 'index.php?option=com_joomlaupdate', 'component', 1, 1, 1, 28, 0, '1970-01-01 00:00:00', 0, 0, 'class:joomlaupdate', 0, '', 41, 42, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (3, 'menu', 'com_banners', 'Banners', '', 'Banners/Banners', 'index.php?option=com_banners', 'component', 0, 2, 2, 4, 0, '1970-01-01 00:00:00', 0, 0, 'class:banners', 0, '', 2, 3, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (4, 'menu', 'com_banners_categories', 'Categories', '', 'Banners/Categories', 'index.php?option=com_categories&extension=com_banners', 'component', 0, 2, 2, 6, 0, '1970-01-01 00:00:00', 0, 0, 'class:banners-cat', 0, '', 4, 5, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (5, 'menu', 'com_banners_clients', 'Clients', '', 'Banners/Clients', 'index.php?option=com_banners&view=clients', 'component', 0, 2, 2, 4, 0, '1970-01-01 00:00:00', 0, 0, 'class:banners-clients', 0, '', 6, 7, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (6, 'menu', 'com_banners_tracks', 'Tracks', '', 'Banners/Tracks', 'index.php?option=com_banners&view=tracks', 'component', 0, 2, 2, 4, 0, '1970-01-01 00:00:00', 0, 0, 'class:banners-tracks', 0, '', 8, 9, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (2, 'menu', 'com_banners', 'Banners', '', 'Banners', 'index.php?option=com_banners', 'component', 0, 1, 1, 4, 0, '1970-01-01 00:00:00', 0, 0, 'class:banners', 0, '', 1, 10, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (8, 'menu', 'com_contact', 'Contacts', '', 'Contacts/Contacts', 'index.php?option=com_contact', 'component', 0, 7, 2, 8, 0, '1970-01-01 00:00:00', 0, 0, 'class:contact', 0, '', 12, 13, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (9, 'menu', 'com_contact_categories', 'Categories', '', 'Contacts/Categories', 'index.php?option=com_categories&extension=com_contact', 'component', 0, 7, 2, 6, 0, '1970-01-01 00:00:00', 0, 0, 'class:contact-cat', 0, '', 14, 15, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (7, 'menu', 'com_contact', 'Contacts', '', 'Contacts', 'index.php?option=com_contact', 'component', 0, 1, 1, 8, 0, '1970-01-01 00:00:00', 0, 0, 'class:contact', 0, '', 11, 16, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (23, 'main', 'com_tags', 'Tags', '', 'Tags', 'index.php?option=com_tags', 'component', 0, 1, 1, 29, 0, '1970-01-01 00:00:00', 0, 1, 'class:tags', 0, '', 43, 44, 0, '', 1);
INSERT INTO "odai_menu" VALUES (14, 'menu', 'com_newsfeeds_feeds', 'Feeds', '', 'News Feeds/Feeds', 'index.php?option=com_newsfeeds', 'component', 0, 13, 2, 17, 0, '1970-01-01 00:00:00', 0, 0, 'class:newsfeeds', 0, '', 24, 25, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (15, 'menu', 'com_newsfeeds_categories', 'Categories', '', 'News Feeds/Categories', 'index.php?option=com_categories&extension=com_newsfeeds', 'component', 0, 13, 2, 6, 0, '1970-01-01 00:00:00', 0, 0, 'class:newsfeeds-cat', 0, '', 26, 27, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (24, 'main', 'com_postinstall', 'Post-installation messages', '', 'Post-installation messages', 'index.php?option=com_postinstall', 'component', 0, 1, 1, 32, 0, '1970-01-01 00:00:00', 0, 1, 'class:postinstall', 0, '', 45, 46, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (13, 'menu', 'com_newsfeeds', 'News Feeds', '', 'News Feeds', 'index.php?option=com_newsfeeds', 'component', 0, 1, 1, 17, 0, '1970-01-01 00:00:00', 0, 0, 'class:newsfeeds', 0, '', 23, 28, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (16, 'menu', 'com_redirect', 'Redirect', '', 'Redirect', 'index.php?option=com_redirect', 'component', 0, 1, 1, 24, 0, '1970-01-01 00:00:00', 0, 0, 'class:redirect', 0, '', 29, 30, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (17, 'menu', 'com_search', 'Basic Search', '', 'Basic Search', 'index.php?option=com_search', 'component', 0, 1, 1, 19, 0, '1970-01-01 00:00:00', 0, 0, 'class:search', 0, '', 31, 32, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (19, 'menu', 'com_weblinks_links', 'Links', '', 'Weblinks/Links', 'index.php?option=com_weblinks', 'component', 0, 18, 2, 21, 0, '1970-01-01 00:00:00', 0, 0, 'class:weblinks', 0, '', 34, 35, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (20, 'menu', 'com_weblinks_categories', 'Categories', '', 'Weblinks/Categories', 'index.php?option=com_categories&extension=com_weblinks', 'component', 0, 18, 2, 6, 0, '1970-01-01 00:00:00', 0, 0, 'class:weblinks-cat', 0, '', 36, 37, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (1, '', 'Menu_Item_Root', 'root', '', '', '', '', 1, 0, 0, 0, 0, '1970-01-01 00:00:00', 0, 0, '', 0, '', 0, 55, 0, '*', 0);
INSERT INTO "odai_menu" VALUES (11, 'menu', 'com_messages_add', 'New Private Message', '', 'Messaging/New Private Message', 'index.php?option=com_messages&task=message.add', 'component', 0, 10, 2, 15, 0, '1970-01-01 00:00:00', 0, 0, 'class:messages-add', 0, '', 18, 19, 0, '*', 1);
INSERT INTO "odai_menu" VALUES (101, 'mainmenu', 'Home', 'home', '', 'home', 'index.php?option=com_content&view=featured', 'component', 1, 1, 1, 22, 0, '1970-01-01 00:00:00', 0, 1, '', 0, '{"featured_categories":[""],"layout_type":"blog","num_leading_articles":"1","num_intro_articles":"3","num_columns":"3","num_links":"0","multi_column_order":"1","orderby_pri":"","orderby_sec":"front","order_date":"","show_pagination":"2","show_pagination_results":"1","show_title":"","link_titles":"","show_intro":"","info_block_position":"","show_category":"","link_category":"","show_parent_category":"","link_parent_category":"","show_author":"","link_author":"","show_create_date":"","show_modify_date":"","show_publish_date":"","show_item_navigation":"","show_vote":"","show_readmore":"","show_readmore_title":"","show_icons":"","show_print_icon":"","show_email_icon":"","show_hits":"","show_noauth":"","show_feed_link":"1","feed_summary":"","menu-anchor_title":"","menu-anchor_css":"","menu_image":"","menu_text":1,"page_title":"","show_page_heading":1,"page_heading":"","pageclass_sfx":"","menu-meta_description":"","menu-meta_keywords":"","robots":"","secure":0}', 47, 48, 1, '*', 0);
INSERT INTO "odai_menu" VALUES (108, 'main', 'Odaienv', 'odaienv', '', 'odaienv', 'index.php?option=com_odaienv', 'component', 0, 1, 1, 10002, 0, '1970-01-01 00:00:00', 0, 1, 'class:component', 0, '', 53, 54, 0, '', 1);


--
-- TOC entry 3360 (class 0 OID 0)
-- Dependencies: 224
-- Name: odai_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_menu_id_seq"', 108, true);


--
-- TOC entry 3165 (class 0 OID 16997)
-- Dependencies: 227
-- Data for Name: odai_menu_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_menu_types" VALUES (1, 'mainmenu', 'Main Menu', 'The main menu for the site');


--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 226
-- Name: odai_menu_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_menu_types_id_seq"', 1, false);


--
-- TOC entry 3167 (class 0 OID 17008)
-- Dependencies: 229
-- Data for Name: odai_messages; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3168 (class 0 OID 17025)
-- Dependencies: 230
-- Data for Name: odai_messages_cfg; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 228
-- Name: odai_messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_messages_message_id_seq"', 1, false);


--
-- TOC entry 3170 (class 0 OID 17035)
-- Dependencies: 232
-- Data for Name: odai_modules; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_modules" VALUES (1, 55, 'Main Menu', '', '', 1, 'position-7', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_menu', 1, 1, '{"menutype":"mainmenu","startLevel":"0","endLevel":"0","showAllChildren":"0","tag_id":"","class_sfx":"","window_open":"","layout":"","moduleclass_sfx":"_menu","cache":"1","cache_time":"900","cachemode":"itemid"}', 0, '*');
INSERT INTO "odai_modules" VALUES (2, 56, 'Login', '', '', 1, 'login', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_login', 1, 1, '', 1, '*');
INSERT INTO "odai_modules" VALUES (3, 57, 'Popular Articles', '', '', 3, 'cpanel', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_popular', 3, 1, '{"count":"5","catid":"","user_id":"0","layout":"_:default","moduleclass_sfx":"","cache":"0","automatic_title":"1"}', 1, '*');
INSERT INTO "odai_modules" VALUES (4, 58, 'Recently Added Articles', '', '', 4, 'cpanel', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_latest', 3, 1, '{"count":"5","ordering":"c_dsc","catid":"","user_id":"0","layout":"_:default","moduleclass_sfx":"","cache":"0","automatic_title":"1"}', 1, '*');
INSERT INTO "odai_modules" VALUES (8, 59, 'Toolbar', '', '', 1, 'toolbar', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_toolbar', 3, 1, '', 1, '*');
INSERT INTO "odai_modules" VALUES (9, 60, 'Quick Icons', '', '', 1, 'icon', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_quickicon', 3, 1, '', 1, '*');
INSERT INTO "odai_modules" VALUES (10, 61, 'Logged-in Users', '', '', 2, 'cpanel', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_logged', 3, 1, '{"count":"5","name":"1","layout":"_:default","moduleclass_sfx":"","cache":"0","automatic_title":"1"}', 1, '*');
INSERT INTO "odai_modules" VALUES (12, 62, 'Admin Menu', '', '', 1, 'menu', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_menu', 3, 1, '{"layout":"","moduleclass_sfx":"","shownew":"1","showhelp":"1","cache":"0"}', 1, '*');
INSERT INTO "odai_modules" VALUES (13, 63, 'Admin Submenu', '', '', 1, 'submenu', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_submenu', 3, 1, '', 1, '*');
INSERT INTO "odai_modules" VALUES (14, 64, 'User Status', '', '', 2, 'status', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_status', 3, 1, '', 1, '*');
INSERT INTO "odai_modules" VALUES (15, 65, 'Title', '', '', 1, 'title', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_title', 3, 1, '', 1, '*');
INSERT INTO "odai_modules" VALUES (16, 66, 'Login Form', '', '', 7, 'position-7', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_login', 1, 1, '{"greeting":"1","name":"0"}', 0, '*');
INSERT INTO "odai_modules" VALUES (17, 67, 'Breadcrumbs', '', '', 1, 'position-2', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_breadcrumbs', 1, 1, '{"moduleclass_sfx":"","showHome":"1","homeText":"","showComponent":"1","separator":"","cache":"1","cache_time":"900","cachemode":"itemid"}', 0, '*');
INSERT INTO "odai_modules" VALUES (79, 68, 'Multilanguage status', '', '', 1, 'status', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 'mod_multilangstatus', 3, 1, '{"layout":"_:default","moduleclass_sfx":"","cache":"0"}', 1, '*');
INSERT INTO "odai_modules" VALUES (86, 69, 'Joomla Version', '', '', 1, 'footer', 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 1, 'mod_version', 3, 1, '{"format":"short","product":"1","layout":"_:default","moduleclass_sfx":"","cache":"0"}', 1, '*');


--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 231
-- Name: odai_modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_modules_id_seq"', 87, false);


--
-- TOC entry 3171 (class 0 OID 17062)
-- Dependencies: 233
-- Data for Name: odai_modules_menu; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_modules_menu" VALUES (1, 0);
INSERT INTO "odai_modules_menu" VALUES (2, 0);
INSERT INTO "odai_modules_menu" VALUES (3, 0);
INSERT INTO "odai_modules_menu" VALUES (4, 0);
INSERT INTO "odai_modules_menu" VALUES (6, 0);
INSERT INTO "odai_modules_menu" VALUES (7, 0);
INSERT INTO "odai_modules_menu" VALUES (8, 0);
INSERT INTO "odai_modules_menu" VALUES (9, 0);
INSERT INTO "odai_modules_menu" VALUES (10, 0);
INSERT INTO "odai_modules_menu" VALUES (12, 0);
INSERT INTO "odai_modules_menu" VALUES (13, 0);
INSERT INTO "odai_modules_menu" VALUES (14, 0);
INSERT INTO "odai_modules_menu" VALUES (15, 0);
INSERT INTO "odai_modules_menu" VALUES (16, 0);
INSERT INTO "odai_modules_menu" VALUES (17, 0);
INSERT INTO "odai_modules_menu" VALUES (79, 0);
INSERT INTO "odai_modules_menu" VALUES (86, 0);


--
-- TOC entry 3173 (class 0 OID 17071)
-- Dependencies: 235
-- Data for Name: odai_newsfeeds; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 234
-- Name: odai_newsfeeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_newsfeeds_id_seq"', 1, false);


--
-- TOC entry 3218 (class 0 OID 18971)
-- Dependencies: 280
-- Data for Name: odai_odai_apis; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 279
-- Name: odai_odai_apis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_odai_apis_id_seq"', 1, false);


--
-- TOC entry 3216 (class 0 OID 18949)
-- Dependencies: 278
-- Data for Name: odai_odai_datasources; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 277
-- Name: odai_odai_datasources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_odai_datasources_id_seq"', 1, false);


--
-- TOC entry 3214 (class 0 OID 18931)
-- Dependencies: 276
-- Data for Name: odai_odai_resources; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 275
-- Name: odai_odai_resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_odai_resources_id_seq"', 1, false);


--
-- TOC entry 3212 (class 0 OID 18920)
-- Dependencies: 274
-- Data for Name: odai_odai_vdbs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 273
-- Name: odai_odai_vdbs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_odai_vdbs_id_seq"', 1, false);


--
-- TOC entry 3175 (class 0 OID 17111)
-- Dependencies: 237
-- Data for Name: odai_overrider; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 236
-- Name: odai_overrider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_overrider_id_seq"', 1, false);


--
-- TOC entry 3177 (class 0 OID 17122)
-- Dependencies: 239
-- Data for Name: odai_postinstall_messages; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_postinstall_messages" VALUES (1, 700, 'PLG_TWOFACTORAUTH_TOTP_POSTINSTALL_TITLE', 'PLG_TWOFACTORAUTH_TOTP_POSTINSTALL_BODY', 'PLG_TWOFACTORAUTH_TOTP_POSTINSTALL_ACTION', 'plg_twofactorauth_totp', 1, 'action', 'site://plugins/twofactorauth/totp/postinstall/actions.php', 'twofactorauth_postinstall_action', 'site://plugins/twofactorauth/totp/postinstall/actions.php', 'twofactorauth_postinstall_condition', '3.2.0', 1);
INSERT INTO "odai_postinstall_messages" VALUES (2, 700, 'COM_CPANEL_MSG_EACCELERATOR_TITLE', 'COM_CPANEL_MSG_EACCELERATOR_BODY', 'COM_CPANEL_MSG_EACCELERATOR_BUTTON', 'com_cpanel', 1, 'action', 'admin://components/com_admin/postinstall/eaccelerator.php', 'admin_postinstall_eaccelerator_action', 'admin://components/com_admin/postinstall/eaccelerator.php', 'admin_postinstall_eaccelerator_condition', '3.2.0', 1);
INSERT INTO "odai_postinstall_messages" VALUES (3, 700, 'COM_CPANEL_WELCOME_BEGINNERS_TITLE', 'COM_CPANEL_WELCOME_BEGINNERS_MESSAGE', '', 'com_cpanel', 1, 'message', '', '', '', '', '3.2.0', 1);
INSERT INTO "odai_postinstall_messages" VALUES (4, 700, 'COM_CPANEL_MSG_PHPVERSION_TITLE', 'COM_CPANEL_MSG_PHPVERSION_BODY', '', 'com_cpanel', 1, 'message', '', '', 'admin://components/com_admin/postinstall/phpversion.php', 'admin_postinstall_phpversion_condition', '3.2.2', 1);


--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 238
-- Name: odai_postinstall_messages_postinstall_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_postinstall_messages_postinstall_message_id_seq"', 4, true);


--
-- TOC entry 3179 (class 0 OID 17146)
-- Dependencies: 241
-- Data for Name: odai_redirect_links; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 240
-- Name: odai_redirect_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_redirect_links_id_seq"', 1, false);


--
-- TOC entry 3180 (class 0 OID 17161)
-- Dependencies: 242
-- Data for Name: odai_schemas; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_schemas" VALUES (700, '3.3.0-2014-04-02');


--
-- TOC entry 3181 (class 0 OID 17166)
-- Dependencies: 243
-- Data for Name: odai_session; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_session" VALUES ('3mbj2m4bnn6ljmlkm5aickekr1', 1, 0, '1413456042', '__default|a:8:{s:15:"session.counter";i:56;s:19:"session.timer.start";i:1413453340;s:18:"session.timer.last";i:1413456040;s:17:"session.timer.now";i:1413456041;s:22:"session.client.browser";s:102:"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36";s:8:"registry";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":3:{s:11:"application";O:8:"stdClass":1:{s:4:"lang";s:5:"en-GB";}s:13:"com_installer";O:8:"stdClass":5:{s:7:"message";s:0:"";s:17:"extension_message";s:0:"";s:12:"redirect_url";s:0:"";s:8:"warnings";O:8:"stdClass":1:{s:8:"ordercol";N;}s:6:"manage";O:8:"stdClass":4:{s:6:"filter";O:8:"stdClass":5:{s:6:"search";s:0:"";s:9:"client_id";s:0:"";s:6:"status";s:0:"";s:4:"type";s:0:"";s:5:"group";s:0:"";}s:8:"ordercol";s:4:"name";s:9:"orderdirn";s:3:"asc";s:10:"limitstart";s:1:"0";}}s:6:"global";O:8:"stdClass":1:{s:4:"list";O:8:"stdClass":1:{s:5:"limit";i:0;}}}}s:4:"user";O:5:"JUser":27:{s:9:"\0\0\0isRoot";b:1;s:2:"id";s:2:"70";s:4:"name";s:10:"Super User";s:8:"username";s:5:"admin";s:5:"email";s:16:"admin@opendai.eu";s:8:"password";s:60:"$2y$10$swxJbh.v9KB8kTxL8qsZVeFYTzJTCRXJhYzgVjV5TlqniAkFdoRHC";s:14:"password_clear";s:0:"";s:5:"block";s:1:"0";s:9:"sendEmail";s:1:"1";s:12:"registerDate";s:19:"2014-07-07 12:51:51";s:13:"lastvisitDate";s:19:"2014-10-16 09:55:12";s:10:"activation";s:1:"0";s:6:"params";s:0:"";s:6:"groups";a:1:{i:8;s:1:"8";}s:5:"guest";i:0;s:13:"lastResetTime";s:19:"1970-01-01 00:00:00";s:10:"resetCount";s:1:"0";s:12:"requireReset";s:1:"0";s:10:"\0\0\0_params";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":0:{}}s:14:"\0\0\0_authGroups";a:2:{i:0;i:1;i:1;i:8;}s:14:"\0\0\0_authLevels";a:5:{i:0;i:1;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:6;}s:15:"\0\0\0_authActions";N;s:12:"\0\0\0_errorMsg";N;s:10:"\0\0\0_errors";a:0:{}s:3:"aid";i:0;s:6:"otpKey";s:0:"";s:4:"otep";s:0:"";}s:13:"session.token";s:32:"161c8799eec9c0281f29ed43f34ee64a";}', 70, 'admin');
INSERT INTO "odai_session" VALUES ('fbho389knjq1jh8kbs1400uev2', 1, 1, '1413453177', '__default|a:8:{s:15:"session.counter";i:1;s:19:"session.timer.start";i:1413453173;s:18:"session.timer.last";i:1413453173;s:17:"session.timer.now";i:1413453173;s:22:"session.client.browser";s:102:"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36";s:8:"registry";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":0:{}}s:4:"user";O:5:"JUser":25:{s:9:"\0\0\0isRoot";N;s:2:"id";i:0;s:4:"name";N;s:8:"username";N;s:5:"email";N;s:8:"password";N;s:14:"password_clear";s:0:"";s:5:"block";N;s:9:"sendEmail";i:0;s:12:"registerDate";N;s:13:"lastvisitDate";N;s:10:"activation";N;s:6:"params";N;s:6:"groups";a:1:{i:0;s:1:"9";}s:5:"guest";i:1;s:13:"lastResetTime";N;s:10:"resetCount";N;s:12:"requireReset";N;s:10:"\0\0\0_params";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":0:{}}s:14:"\0\0\0_authGroups";N;s:14:"\0\0\0_authLevels";a:3:{i:0;i:1;i:1;i:1;i:2;i:5;}s:15:"\0\0\0_authActions";N;s:12:"\0\0\0_errorMsg";N;s:10:"\0\0\0_errors";a:0:{}s:3:"aid";i:0;}s:13:"session.token";s:32:"a78a80a27598d91258d5c3e60eaec5e1";}', 0, '');
INSERT INTO "odai_session" VALUES ('onm63d5jocta37o033b92tgen3', 1, 1, '1413453200', '__default|a:8:{s:15:"session.counter";i:1;s:19:"session.timer.start";i:1413453198;s:18:"session.timer.last";i:1413453198;s:17:"session.timer.now";i:1413453198;s:22:"session.client.browser";s:102:"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36";s:8:"registry";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":0:{}}s:4:"user";O:5:"JUser":25:{s:9:"\0\0\0isRoot";N;s:2:"id";i:0;s:4:"name";N;s:8:"username";N;s:5:"email";N;s:8:"password";N;s:14:"password_clear";s:0:"";s:5:"block";N;s:9:"sendEmail";i:0;s:12:"registerDate";N;s:13:"lastvisitDate";N;s:10:"activation";N;s:6:"params";N;s:6:"groups";a:1:{i:0;s:1:"9";}s:5:"guest";i:1;s:13:"lastResetTime";N;s:10:"resetCount";N;s:12:"requireReset";N;s:10:"\0\0\0_params";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":0:{}}s:14:"\0\0\0_authGroups";N;s:14:"\0\0\0_authLevels";a:3:{i:0;i:1;i:1;i:1;i:2;i:5;}s:15:"\0\0\0_authActions";N;s:12:"\0\0\0_errorMsg";N;s:10:"\0\0\0_errors";a:0:{}s:3:"aid";i:0;}s:13:"session.token";s:32:"866e54083a7e1ec2805a8fbc00feb43a";}', 0, '');
INSERT INTO "odai_session" VALUES ('ihle30jl7s8fi891vd6j6nvn04', 0, 0, '1413453313', '__default|a:8:{s:15:"session.counter";i:5;s:19:"session.timer.start";i:1413453242;s:18:"session.timer.last";i:1413453311;s:17:"session.timer.now";i:1413453312;s:22:"session.client.browser";s:102:"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36";s:8:"registry";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":2:{s:5:"users";O:8:"stdClass":1:{s:5:"login";O:8:"stdClass":1:{s:4:"form";O:8:"stdClass":2:{s:6:"return";s:20:"index.php?Itemid=101";s:4:"data";a:0:{}}}}s:13:"rememberLogin";b:1;}}s:4:"user";O:5:"JUser":27:{s:9:"\0\0\0isRoot";b:1;s:2:"id";s:2:"70";s:4:"name";s:10:"Super User";s:8:"username";s:5:"admin";s:5:"email";s:16:"admin@opendai.eu";s:8:"password";s:60:"$2y$10$swxJbh.v9KB8kTxL8qsZVeFYTzJTCRXJhYzgVjV5TlqniAkFdoRHC";s:14:"password_clear";s:0:"";s:5:"block";s:1:"0";s:9:"sendEmail";s:1:"1";s:12:"registerDate";s:19:"2014-07-07 12:51:51";s:13:"lastvisitDate";s:19:"2014-07-07 12:53:23";s:10:"activation";s:1:"0";s:6:"params";s:0:"";s:6:"groups";a:1:{i:8;s:1:"8";}s:5:"guest";i:0;s:13:"lastResetTime";s:19:"1970-01-01 00:00:00";s:10:"resetCount";s:1:"0";s:12:"requireReset";s:1:"0";s:10:"\0\0\0_params";O:24:"Joomla\Registry\Registry":1:{s:7:"\0\0\0data";O:8:"stdClass":0:{}}s:14:"\0\0\0_authGroups";a:2:{i:0;i:1;i:1;i:8;}s:14:"\0\0\0_authLevels";a:5:{i:0;i:1;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:6;}s:15:"\0\0\0_authActions";N;s:12:"\0\0\0_errorMsg";N;s:10:"\0\0\0_errors";a:0:{}s:3:"aid";i:0;s:6:"otpKey";s:0:"";s:4:"otep";s:0:"";}s:13:"session.token";s:32:"47cf52a74bdf114d3261f99580efbde8";}', 70, 'admin');


--
-- TOC entry 3183 (class 0 OID 17184)
-- Dependencies: 245
-- Data for Name: odai_tags; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_tags" VALUES (1, 0, 0, 1, 0, '', 'ROOT', 'root', '', '', 1, 0, '1970-01-01 00:00:00', 1, '', '', '', '', 42, '2011-01-01 00:00:01', '', 0, '1970-01-01 00:00:00', '', '', 0, '*', 1, '1970-01-01 00:00:00', '1970-01-01 00:00:00');


--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 244
-- Name: odai_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_tags_id_seq"', 1, false);


--
-- TOC entry 3185 (class 0 OID 17224)
-- Dependencies: 247
-- Data for Name: odai_template_styles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_template_styles" VALUES (4, 'beez3', 0, '0', 'Beez3 - Default', '{"wrapperSmall":"53","wrapperLarge":"72","logo":"images\/joomla_black.gif","sitetitle":"Joomla!","sitedescription":"Open Source Content Management","navposition":"left","templatecolor":"personal","html5":"0"}');
INSERT INTO "odai_template_styles" VALUES (5, 'hathor', 1, '0', 'Hathor - Default', '{"showSiteName":"0","colourChoice":"","boldText":"0"}');
INSERT INTO "odai_template_styles" VALUES (7, 'protostar', 0, '1', 'protostar - Default', '{"templateColor":"","logoFile":"","googleFont":"1","googleFontName":"Open+Sans","fluidContainer":"0"}');
INSERT INTO "odai_template_styles" VALUES (8, 'isis', 1, '1', 'isis - Default', '{"templateColor":"","logoFile":""}');


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 246
-- Name: odai_template_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_template_styles_id_seq"', 9, false);


--
-- TOC entry 3187 (class 0 OID 17241)
-- Dependencies: 249
-- Data for Name: odai_ucm_base; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 248
-- Name: odai_ucm_base_ucm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_ucm_base_ucm_id_seq"', 1, false);


--
-- TOC entry 3189 (class 0 OID 17252)
-- Dependencies: 251
-- Data for Name: odai_ucm_content; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 250
-- Name: odai_ucm_content_core_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_ucm_content_core_content_id_seq"', 1, false);


--
-- TOC entry 3191 (class 0 OID 17300)
-- Dependencies: 253
-- Data for Name: odai_ucm_history; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 252
-- Name: odai_ucm_history_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_ucm_history_version_id_seq"', 1, false);


--
-- TOC entry 3195 (class 0 OID 17340)
-- Dependencies: 257
-- Data for Name: odai_update_sites; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_update_sites" VALUES (1, 'Joomla Core', 'collection', 'http://update.joomla.org/core/list.xml', 1, 1413455127, '');
INSERT INTO "odai_update_sites" VALUES (2, 'Joomla Extension Directory', 'collection', 'http://update.joomla.org/jed/list.xml', 1, 1413455127, '');
INSERT INTO "odai_update_sites" VALUES (3, 'Accredited Joomla! Translations', 'collection', 'http://update.joomla.org/language/translationlist_3.xml', 1, 1413455127, '');


--
-- TOC entry 3196 (class 0 OID 17354)
-- Dependencies: 258
-- Data for Name: odai_update_sites_extensions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_update_sites_extensions" VALUES (1, 700);
INSERT INTO "odai_update_sites_extensions" VALUES (2, 700);
INSERT INTO "odai_update_sites_extensions" VALUES (3, 600);


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 256
-- Name: odai_update_sites_update_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_update_sites_update_site_id_seq"', 1, false);


--
-- TOC entry 3193 (class 0 OID 17319)
-- Dependencies: 255
-- Data for Name: odai_updates; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_updates" VALUES (604, 1, 700, 'Joomla', '', 'joomla', 'file', '', 0, '3.3.6', '', 'http://update.joomla.org/core/sts/extension_sts.xml', '', '');
INSERT INTO "odai_updates" VALUES (605, 3, 0, 'Malay', '', 'pkg_ms-MY', 'package', '', 0, '3.3.1.1', '', 'http://update.joomla.org/language/details3/ms-MY_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (606, 3, 0, 'Romanian', '', 'pkg_ro-RO', 'package', '', 0, '3.3.3.1', '', 'http://update.joomla.org/language/details3/ro-RO_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (607, 3, 0, 'Flemish', '', 'pkg_nl-BE', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/nl-BE_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (608, 3, 0, 'Chinese Traditional', '', 'pkg_zh-TW', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/zh-TW_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (609, 3, 0, 'French', '', 'pkg_fr-FR', 'package', '', 0, '3.3.6.2', '', 'http://update.joomla.org/language/details3/fr-FR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (610, 3, 0, 'Galician', '', 'pkg_gl-ES', 'package', '', 0, '3.3.1.2', '', 'http://update.joomla.org/language/details3/gl-ES_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (611, 3, 0, 'German', '', 'pkg_de-DE', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/de-DE_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (612, 3, 0, 'Greek', '', 'pkg_el-GR', 'package', '', 0, '3.3.3.1', '', 'http://update.joomla.org/language/details3/el-GR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (613, 3, 0, 'Japanese', '', 'pkg_ja-JP', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/ja-JP_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (614, 3, 0, 'Hebrew', '', 'pkg_he-IL', 'package', '', 0, '3.1.1.1', '', 'http://update.joomla.org/language/details3/he-IL_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (615, 3, 0, 'EnglishAU', '', 'pkg_en-AU', 'package', '', 0, '3.3.1.1', '', 'http://update.joomla.org/language/details3/en-AU_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (616, 3, 0, 'EnglishUS', '', 'pkg_en-US', 'package', '', 0, '3.3.1.1', '', 'http://update.joomla.org/language/details3/en-US_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (617, 3, 0, 'Hungarian', '', 'pkg_hu-HU', 'package', '', 0, '3.3.3.1', '', 'http://update.joomla.org/language/details3/hu-HU_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (618, 3, 0, 'Afrikaans', '', 'pkg_af-ZA', 'package', '', 0, '3.2.0.2', '', 'http://update.joomla.org/language/details3/af-ZA_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (619, 3, 0, 'Arabic Unitag', '', 'pkg_ar-AA', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/ar-AA_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (620, 3, 0, 'Belarusian', '', 'pkg_be-BY', 'package', '', 0, '3.2.1.1', '', 'http://update.joomla.org/language/details3/be-BY_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (621, 3, 0, 'Bulgarian', '', 'pkg_bg-BG', 'package', '', 0, '3.3.0.1', '', 'http://update.joomla.org/language/details3/bg-BG_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (622, 3, 0, 'Catalan', '', 'pkg_ca-ES', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/ca-ES_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (623, 3, 0, 'Chinese Simplified', '', 'pkg_zh-CN', 'package', '', 0, '3.3.1.1', '', 'http://update.joomla.org/language/details3/zh-CN_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (624, 3, 0, 'Croatian', '', 'pkg_hr-HR', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/hr-HR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (625, 3, 0, 'Czech', '', 'pkg_cs-CZ', 'package', '', 0, '3.3.6.2', '', 'http://update.joomla.org/language/details3/cs-CZ_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (626, 3, 0, 'Danish', '', 'pkg_da-DK', 'package', '', 0, '3.3.5.1', '', 'http://update.joomla.org/language/details3/da-DK_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (627, 3, 0, 'Dutch', '', 'pkg_nl-NL', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/nl-NL_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (628, 3, 0, 'Estonian', '', 'pkg_et-EE', 'package', '', 0, '3.3.4.1', '', 'http://update.joomla.org/language/details3/et-EE_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (629, 3, 0, 'Italian', '', 'pkg_it-IT', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/it-IT_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (630, 3, 0, 'Korean', '', 'pkg_ko-KR', 'package', '', 0, '3.2.3.1', '', 'http://update.joomla.org/language/details3/ko-KR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (631, 3, 0, 'Latvian', '', 'pkg_lv-LV', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/lv-LV_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (632, 3, 0, 'Macedonian', '', 'pkg_mk-MK', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/mk-MK_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (633, 3, 0, 'Norwegian Bokmal', '', 'pkg_nb-NO', 'package', '', 0, '3.2.2.1', '', 'http://update.joomla.org/language/details3/nb-NO_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (634, 3, 0, 'Persian', '', 'pkg_fa-IR', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/fa-IR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (635, 3, 0, 'Polish', '', 'pkg_pl-PL', 'package', '', 0, '3.3.4.1', '', 'http://update.joomla.org/language/details3/pl-PL_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (636, 3, 0, 'Portuguese', '', 'pkg_pt-PT', 'package', '', 0, '3.3.3.1', '', 'http://update.joomla.org/language/details3/pt-PT_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (637, 3, 0, 'Russian', '', 'pkg_ru-RU', 'package', '', 0, '3.3.3.1', '', 'http://update.joomla.org/language/details3/ru-RU_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (638, 3, 0, 'Slovak', '', 'pkg_sk-SK', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/sk-SK_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (639, 3, 0, 'Swedish', '', 'pkg_sv-SE', 'package', '', 0, '3.3.3.3', '', 'http://update.joomla.org/language/details3/sv-SE_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (640, 3, 0, 'Syriac', '', 'pkg_sy-IQ', 'package', '', 0, '3.3.4.1', '', 'http://update.joomla.org/language/details3/sy-IQ_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (641, 3, 0, 'Tamil', '', 'pkg_ta-IN', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/ta-IN_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (642, 3, 0, 'Thai', '', 'pkg_th-TH', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/th-TH_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (643, 3, 0, 'Turkish', '', 'pkg_tr-TR', 'package', '', 0, '3.3.5.1', '', 'http://update.joomla.org/language/details3/tr-TR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (644, 3, 0, 'Ukrainian', '', 'pkg_uk-UA', 'package', '', 0, '3.3.3.15', '', 'http://update.joomla.org/language/details3/uk-UA_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (645, 3, 0, 'Uyghur', '', 'pkg_ug-CN', 'package', '', 0, '3.3.0.1', '', 'http://update.joomla.org/language/details3/ug-CN_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (646, 3, 0, 'Albanian', '', 'pkg_sq-AL', 'package', '', 0, '3.1.1.1', '', 'http://update.joomla.org/language/details3/sq-AL_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (647, 3, 0, 'Portuguese Brazil', '', 'pkg_pt-BR', 'package', '', 0, '3.0.2.1', '', 'http://update.joomla.org/language/details3/pt-BR_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (648, 3, 0, 'Serbian Latin', '', 'pkg_sr-YU', 'package', '', 0, '3.3.4.1', '', 'http://update.joomla.org/language/details3/sr-YU_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (649, 3, 0, 'Spanish', '', 'pkg_es-ES', 'package', '', 0, '3.3.4.1', '', 'http://update.joomla.org/language/details3/es-ES_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (650, 3, 0, 'Bosnian', '', 'pkg_bs-BA', 'package', '', 0, '3.3.3.1', '', 'http://update.joomla.org/language/details3/bs-BA_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (651, 3, 0, 'Serbian Cyrillic', '', 'pkg_sr-RS', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/sr-RS_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (652, 3, 0, 'Vietnamese', '', 'pkg_vi-VN', 'package', '', 0, '3.2.1.1', '', 'http://update.joomla.org/language/details3/vi-VN_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (653, 3, 0, 'Bahasa Indonesia', '', 'pkg_id-ID', 'package', '', 0, '3.3.0.2', '', 'http://update.joomla.org/language/details3/id-ID_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (654, 3, 0, 'Finnish', '', 'pkg_fi-FI', 'package', '', 0, '3.3.4.1', '', 'http://update.joomla.org/language/details3/fi-FI_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (655, 3, 0, 'Swahili', '', 'pkg_sw-KE', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/sw-KE_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (656, 3, 0, 'Montenegrin', '', 'pkg_srp-ME', 'package', '', 0, '3.3.1.1', '', 'http://update.joomla.org/language/details3/srp-ME_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (657, 3, 0, 'EnglishCA', '', 'pkg_en-CA', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/en-CA_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (658, 3, 0, 'FrenchCA', '', 'pkg_fr-CA', 'package', '', 0, '3.3.6.1', '', 'http://update.joomla.org/language/details3/fr-CA_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (659, 3, 0, 'Welsh', '', 'pkg_cy-GB', 'package', '', 0, '3.3.0.1', '', 'http://update.joomla.org/language/details3/cy-GB_details.xml', '', '');
INSERT INTO "odai_updates" VALUES (660, 3, 0, 'Sinhala', '', 'pkg_si-LK', 'package', '', 0, '3.3.1.1', '', 'http://update.joomla.org/language/details3/si-LK_details.xml', '', '');


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 254
-- Name: odai_updates_update_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_updates_update_id_seq"', 660, true);


--
-- TOC entry 3203 (class 0 OID 17416)
-- Dependencies: 265
-- Data for Name: odai_user_keys; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 264
-- Name: odai_user_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_user_keys_id_seq"', 1, false);


--
-- TOC entry 3205 (class 0 OID 17430)
-- Dependencies: 267
-- Data for Name: odai_user_notes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 266
-- Name: odai_user_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_user_notes_id_seq"', 1, false);


--
-- TOC entry 3206 (class 0 OID 17453)
-- Dependencies: 268
-- Data for Name: odai_user_profiles; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3199 (class 0 OID 17378)
-- Dependencies: 261
-- Data for Name: odai_user_usergroup_map; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_user_usergroup_map" VALUES (70, 8);


--
-- TOC entry 3198 (class 0 OID 17363)
-- Dependencies: 260
-- Data for Name: odai_usergroups; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_usergroups" VALUES (1, 0, 1, 18, 'Public');
INSERT INTO "odai_usergroups" VALUES (2, 1, 8, 15, 'Registered');
INSERT INTO "odai_usergroups" VALUES (3, 2, 9, 14, 'Author');
INSERT INTO "odai_usergroups" VALUES (4, 3, 10, 13, 'Editor');
INSERT INTO "odai_usergroups" VALUES (5, 4, 11, 12, 'Publisher');
INSERT INTO "odai_usergroups" VALUES (6, 1, 4, 7, 'Manager');
INSERT INTO "odai_usergroups" VALUES (7, 6, 5, 6, 'Administrator');
INSERT INTO "odai_usergroups" VALUES (8, 1, 16, 17, 'Super Users');
INSERT INTO "odai_usergroups" VALUES (9, 1, 2, 3, 'Guest');


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 259
-- Name: odai_usergroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_usergroups_id_seq"', 1, false);


--
-- TOC entry 3201 (class 0 OID 17387)
-- Dependencies: 263
-- Data for Name: odai_users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_users" VALUES (70, 'Super User', 'admin', 'admin@opendai.eu', '$2y$10$swxJbh.v9KB8kTxL8qsZVeFYTzJTCRXJhYzgVjV5TlqniAkFdoRHC', 0, 1, '2014-07-07 12:51:51', '2014-10-16 09:55:45', '0', '', '1970-01-01 00:00:00', 0, '', '', 0);


--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 262
-- Name: odai_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_users_id_seq"', 1, false);


--
-- TOC entry 3208 (class 0 OID 17461)
-- Dependencies: 270
-- Data for Name: odai_viewlevels; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "odai_viewlevels" VALUES (1, 'Public', 0, '[1]');
INSERT INTO "odai_viewlevels" VALUES (2, 'Registered', 1, '[6,2,8]');
INSERT INTO "odai_viewlevels" VALUES (3, 'Special', 2, '[6,3,8]');
INSERT INTO "odai_viewlevels" VALUES (5, 'Guest', 0, '[9]');
INSERT INTO "odai_viewlevels" VALUES (6, 'Super Users', 0, '[8]');


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 269
-- Name: odai_viewlevels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_viewlevels_id_seq"', 7, false);


--
-- TOC entry 3210 (class 0 OID 17476)
-- Dependencies: 272
-- Data for Name: odai_weblinks; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 271
-- Name: odai_weblinks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"odai_weblinks_id_seq"', 1, false);


--
-- TOC entry 2673 (class 2606 OID 16410)
-- Name: odai_assets_idx_asset_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_assets"
    ADD CONSTRAINT "odai_assets_idx_asset_name" UNIQUE ("name");


--
-- TOC entry 2677 (class 2606 OID 16408)
-- Name: odai_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_assets"
    ADD CONSTRAINT "odai_assets_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2679 (class 2606 OID 16417)
-- Name: odai_associations_idx_context_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_associations"
    ADD CONSTRAINT "odai_associations_idx_context_id" PRIMARY KEY ("context", "id");


--
-- TOC entry 2691 (class 2606 OID 16485)
-- Name: odai_banner_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_banner_clients"
    ADD CONSTRAINT "odai_banner_clients_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2696 (class 2606 OID 16493)
-- Name: odai_banner_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_banner_tracks"
    ADD CONSTRAINT "odai_banner_tracks_pkey" PRIMARY KEY ("track_date", "track_type", "banner_id");


--
-- TOC entry 2687 (class 2606 OID 16458)
-- Name: odai_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_banners"
    ADD CONSTRAINT "odai_banners_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2705 (class 2606 OID 16528)
-- Name: odai_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_categories"
    ADD CONSTRAINT "odai_categories_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2715 (class 2606 OID 16578)
-- Name: odai_contact_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_contact_details"
    ADD CONSTRAINT "odai_contact_details_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2727 (class 2606 OID 16633)
-- Name: odai_content_frontpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_content_frontpage"
    ADD CONSTRAINT "odai_content_frontpage_pkey" PRIMARY KEY ("content_id");


--
-- TOC entry 2725 (class 2606 OID 16618)
-- Name: odai_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_content"
    ADD CONSTRAINT "odai_content_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2729 (class 2606 OID 16642)
-- Name: odai_content_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_content_rating"
    ADD CONSTRAINT "odai_content_rating_pkey" PRIMARY KEY ("content_id");


--
-- TOC entry 2732 (class 2606 OID 16658)
-- Name: odai_content_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_content_types"
    ADD CONSTRAINT "odai_content_types_pkey" PRIMARY KEY ("type_id");


--
-- TOC entry 2744 (class 2606 OID 16696)
-- Name: odai_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_extensions"
    ADD CONSTRAINT "odai_extensions_pkey" PRIMARY KEY ("extension_id");


--
-- TOC entry 2746 (class 2606 OID 16717)
-- Name: odai_finder_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_filters"
    ADD CONSTRAINT "odai_finder_filters_pkey" PRIMARY KEY ("filter_id");


--
-- TOC entry 2754 (class 2606 OID 16742)
-- Name: odai_finder_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links"
    ADD CONSTRAINT "odai_finder_links_pkey" PRIMARY KEY ("link_id");


--
-- TOC entry 2758 (class 2606 OID 16753)
-- Name: odai_finder_links_terms0_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms0"
    ADD CONSTRAINT "odai_finder_links_terms0_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2762 (class 2606 OID 16760)
-- Name: odai_finder_links_terms1_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms1"
    ADD CONSTRAINT "odai_finder_links_terms1_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2766 (class 2606 OID 16767)
-- Name: odai_finder_links_terms2_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms2"
    ADD CONSTRAINT "odai_finder_links_terms2_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2770 (class 2606 OID 16774)
-- Name: odai_finder_links_terms3_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms3"
    ADD CONSTRAINT "odai_finder_links_terms3_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2774 (class 2606 OID 16781)
-- Name: odai_finder_links_terms4_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms4"
    ADD CONSTRAINT "odai_finder_links_terms4_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2778 (class 2606 OID 16788)
-- Name: odai_finder_links_terms5_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms5"
    ADD CONSTRAINT "odai_finder_links_terms5_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2782 (class 2606 OID 16795)
-- Name: odai_finder_links_terms6_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms6"
    ADD CONSTRAINT "odai_finder_links_terms6_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2786 (class 2606 OID 16802)
-- Name: odai_finder_links_terms7_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms7"
    ADD CONSTRAINT "odai_finder_links_terms7_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2790 (class 2606 OID 16809)
-- Name: odai_finder_links_terms8_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms8"
    ADD CONSTRAINT "odai_finder_links_terms8_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2794 (class 2606 OID 16816)
-- Name: odai_finder_links_terms9_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_terms9"
    ADD CONSTRAINT "odai_finder_links_terms9_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2798 (class 2606 OID 16823)
-- Name: odai_finder_links_termsa_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_termsa"
    ADD CONSTRAINT "odai_finder_links_termsa_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2802 (class 2606 OID 16830)
-- Name: odai_finder_links_termsb_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_termsb"
    ADD CONSTRAINT "odai_finder_links_termsb_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2806 (class 2606 OID 16837)
-- Name: odai_finder_links_termsc_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_termsc"
    ADD CONSTRAINT "odai_finder_links_termsc_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2810 (class 2606 OID 16844)
-- Name: odai_finder_links_termsd_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_termsd"
    ADD CONSTRAINT "odai_finder_links_termsd_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2814 (class 2606 OID 16851)
-- Name: odai_finder_links_termse_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_termse"
    ADD CONSTRAINT "odai_finder_links_termse_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2818 (class 2606 OID 16858)
-- Name: odai_finder_links_termsf_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_links_termsf"
    ADD CONSTRAINT "odai_finder_links_termsf_pkey" PRIMARY KEY ("link_id", "term_id");


--
-- TOC entry 2829 (class 2606 OID 16882)
-- Name: odai_finder_taxonomy_map_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_taxonomy_map"
    ADD CONSTRAINT "odai_finder_taxonomy_map_pkey" PRIMARY KEY ("link_id", "node_id");


--
-- TOC entry 2824 (class 2606 OID 16872)
-- Name: odai_finder_taxonomy_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_taxonomy"
    ADD CONSTRAINT "odai_finder_taxonomy_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2833 (class 2606 OID 16898)
-- Name: odai_finder_terms_idx_term; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_terms"
    ADD CONSTRAINT "odai_finder_terms_idx_term" UNIQUE ("term");


--
-- TOC entry 2836 (class 2606 OID 16896)
-- Name: odai_finder_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_terms"
    ADD CONSTRAINT "odai_finder_terms_pkey" PRIMARY KEY ("term_id");


--
-- TOC entry 2844 (class 2606 OID 16932)
-- Name: odai_finder_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_types"
    ADD CONSTRAINT "odai_finder_types_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2846 (class 2606 OID 16934)
-- Name: odai_finder_types_title; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_finder_types"
    ADD CONSTRAINT "odai_finder_types_title" UNIQUE ("title");


--
-- TOC entry 2849 (class 2606 OID 16953)
-- Name: odai_languages_idx_image; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_languages"
    ADD CONSTRAINT "odai_languages_idx_image" UNIQUE ("image");


--
-- TOC entry 2851 (class 2606 OID 16955)
-- Name: odai_languages_idx_langcode; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_languages"
    ADD CONSTRAINT "odai_languages_idx_langcode" UNIQUE ("lang_code");


--
-- TOC entry 2854 (class 2606 OID 16951)
-- Name: odai_languages_idx_sef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_languages"
    ADD CONSTRAINT "odai_languages_idx_sef" UNIQUE ("sef");


--
-- TOC entry 2856 (class 2606 OID 16949)
-- Name: odai_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_languages"
    ADD CONSTRAINT "odai_languages_pkey" PRIMARY KEY ("lang_id");


--
-- TOC entry 2859 (class 2606 OID 16988)
-- Name: odai_menu_idx_client_id_parent_id_alias_language; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_menu"
    ADD CONSTRAINT "odai_menu_idx_client_id_parent_id_alias_language" UNIQUE ("client_id", "parent_id", "alias", "language");


--
-- TOC entry 2866 (class 2606 OID 16986)
-- Name: odai_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_menu"
    ADD CONSTRAINT "odai_menu_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2868 (class 2606 OID 17005)
-- Name: odai_menu_types_idx_menutype; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_menu_types"
    ADD CONSTRAINT "odai_menu_types_idx_menutype" UNIQUE ("menutype");


--
-- TOC entry 2870 (class 2606 OID 17003)
-- Name: odai_menu_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_menu_types"
    ADD CONSTRAINT "odai_menu_types_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2875 (class 2606 OID 17032)
-- Name: odai_messages_cfg_idx_user_var_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_messages_cfg"
    ADD CONSTRAINT "odai_messages_cfg_idx_user_var_name" UNIQUE ("user_id", "cfg_name");


--
-- TOC entry 2872 (class 2606 OID 17023)
-- Name: odai_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_messages"
    ADD CONSTRAINT "odai_messages_pkey" PRIMARY KEY ("message_id");


--
-- TOC entry 2882 (class 2606 OID 17068)
-- Name: odai_modules_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_modules_menu"
    ADD CONSTRAINT "odai_modules_menu_pkey" PRIMARY KEY ("moduleid", "menuid");


--
-- TOC entry 2879 (class 2606 OID 17058)
-- Name: odai_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_modules"
    ADD CONSTRAINT "odai_modules_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2891 (class 2606 OID 17101)
-- Name: odai_newsfeeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_newsfeeds"
    ADD CONSTRAINT "odai_newsfeeds_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2998 (class 2606 OID 18978)
-- Name: odai_odai_apis_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_odai_apis"
    ADD CONSTRAINT "odai_odai_apis_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2996 (class 2606 OID 18963)
-- Name: odai_odai_datasources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_odai_datasources"
    ADD CONSTRAINT "odai_odai_datasources_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2994 (class 2606 OID 18941)
-- Name: odai_odai_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_odai_resources"
    ADD CONSTRAINT "odai_odai_resources_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2992 (class 2606 OID 18928)
-- Name: odai_odai_vdbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_odai_vdbs"
    ADD CONSTRAINT "odai_odai_vdbs_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2893 (class 2606 OID 17119)
-- Name: odai_overrider_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_overrider"
    ADD CONSTRAINT "odai_overrider_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2895 (class 2606 OID 17143)
-- Name: odai_postinstall_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_postinstall_messages"
    ADD CONSTRAINT "odai_postinstall_messages_pkey" PRIMARY KEY ("postinstall_message_id");


--
-- TOC entry 2898 (class 2606 OID 17159)
-- Name: odai_redirect_links_idx_link_old; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_redirect_links"
    ADD CONSTRAINT "odai_redirect_links_idx_link_old" UNIQUE ("old_url");


--
-- TOC entry 2900 (class 2606 OID 17157)
-- Name: odai_redirect_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_redirect_links"
    ADD CONSTRAINT "odai_redirect_links_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2902 (class 2606 OID 17165)
-- Name: odai_schemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_schemas"
    ADD CONSTRAINT "odai_schemas_pkey" PRIMARY KEY ("extension_id", "version_id");


--
-- TOC entry 2904 (class 2606 OID 17179)
-- Name: odai_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_session"
    ADD CONSTRAINT "odai_session_pkey" PRIMARY KEY ("session_id");


--
-- TOC entry 2915 (class 2606 OID 17214)
-- Name: odai_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_tags"
    ADD CONSTRAINT "odai_tags_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2919 (class 2606 OID 17236)
-- Name: odai_template_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_template_styles"
    ADD CONSTRAINT "odai_template_styles_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2739 (class 2606 OID 16666)
-- Name: odai_uc_ItemnameTagid; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_contentitem_tag_map"
    ADD CONSTRAINT "odai_uc_ItemnameTagid" UNIQUE ("type_alias", "content_item_id", "tag_id");


--
-- TOC entry 2921 (class 2606 OID 17246)
-- Name: odai_ucm_base_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_ucm_base"
    ADD CONSTRAINT "odai_ucm_base_pkey" PRIMARY KEY ("ucm_id");


--
-- TOC entry 2937 (class 2606 OID 17285)
-- Name: odai_ucm_content_idx_type_alias_item_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_ucm_content"
    ADD CONSTRAINT "odai_ucm_content_idx_type_alias_item_id" UNIQUE ("core_type_alias", "core_content_item_id");


--
-- TOC entry 2939 (class 2606 OID 17283)
-- Name: odai_ucm_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_ucm_content"
    ADD CONSTRAINT "odai_ucm_content_pkey" PRIMARY KEY ("core_content_id");


--
-- TOC entry 2944 (class 2606 OID 17314)
-- Name: odai_ucm_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_ucm_history"
    ADD CONSTRAINT "odai_ucm_history_pkey" PRIMARY KEY ("version_id");


--
-- TOC entry 2950 (class 2606 OID 17360)
-- Name: odai_update_sites_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_update_sites_extensions"
    ADD CONSTRAINT "odai_update_sites_extensions_pkey" PRIMARY KEY ("update_site_id", "extension_id");


--
-- TOC entry 2948 (class 2606 OID 17353)
-- Name: odai_update_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_update_sites"
    ADD CONSTRAINT "odai_update_sites_pkey" PRIMARY KEY ("update_site_id");


--
-- TOC entry 2946 (class 2606 OID 17337)
-- Name: odai_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_updates"
    ADD CONSTRAINT "odai_updates_pkey" PRIMARY KEY ("update_id");


--
-- TOC entry 2968 (class 2606 OID 17424)
-- Name: odai_user_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_user_keys"
    ADD CONSTRAINT "odai_user_keys_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2970 (class 2606 OID 17426)
-- Name: odai_user_keys_series; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_user_keys"
    ADD CONSTRAINT "odai_user_keys_series" UNIQUE ("series");


--
-- TOC entry 2974 (class 2606 OID 17450)
-- Name: odai_user_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_user_notes"
    ADD CONSTRAINT "odai_user_notes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2976 (class 2606 OID 17458)
-- Name: odai_user_profiles_idx_user_id_profile_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_user_profiles"
    ADD CONSTRAINT "odai_user_profiles_idx_user_id_profile_key" UNIQUE ("user_id", "profile_key");


--
-- TOC entry 2959 (class 2606 OID 17384)
-- Name: odai_user_usergroup_map_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_user_usergroup_map"
    ADD CONSTRAINT "odai_user_usergroup_map_pkey" PRIMARY KEY ("user_id", "group_id");


--
-- TOC entry 2954 (class 2606 OID 17374)
-- Name: odai_usergroups_idx_usergroup_parent_title_lookup; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_usergroups"
    ADD CONSTRAINT "odai_usergroups_idx_usergroup_parent_title_lookup" UNIQUE ("parent_id", "title");


--
-- TOC entry 2957 (class 2606 OID 17372)
-- Name: odai_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_usergroups"
    ADD CONSTRAINT "odai_usergroups_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2964 (class 2606 OID 17409)
-- Name: odai_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_users"
    ADD CONSTRAINT "odai_users_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2978 (class 2606 OID 17473)
-- Name: odai_viewlevels_idx_assetgroup_title_lookup; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_viewlevels"
    ADD CONSTRAINT "odai_viewlevels_idx_assetgroup_title_lookup" UNIQUE ("title");


--
-- TOC entry 2980 (class 2606 OID 17471)
-- Name: odai_viewlevels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_viewlevels"
    ADD CONSTRAINT "odai_viewlevels_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2990 (class 2606 OID 17504)
-- Name: odai_weblinks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "odai_weblinks"
    ADD CONSTRAINT "odai_weblinks_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2841 (class 1259 OID 16924)
-- Name: _odai_finder_tokens_aggregate_keyword_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "_odai_finder_tokens_aggregate_keyword_id" ON "odai_finder_tokens_aggregate" USING "btree" ("term_id");


--
-- TOC entry 2674 (class 1259 OID 16411)
-- Name: odai_assets_idx_lft_rgt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_assets_idx_lft_rgt" ON "odai_assets" USING "btree" ("lft", "rgt");


--
-- TOC entry 2675 (class 1259 OID 16412)
-- Name: odai_assets_idx_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_assets_idx_parent_id" ON "odai_assets" USING "btree" ("parent_id");


--
-- TOC entry 2680 (class 1259 OID 16418)
-- Name: odai_associations_idx_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_associations_idx_key" ON "odai_associations" USING "btree" ("key");


--
-- TOC entry 2688 (class 1259 OID 16487)
-- Name: odai_banner_clients_idx_metakey_prefix; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banner_clients_idx_metakey_prefix" ON "odai_banner_clients" USING "btree" ("metakey_prefix");


--
-- TOC entry 2689 (class 1259 OID 16486)
-- Name: odai_banner_clients_idx_own_prefix; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banner_clients_idx_own_prefix" ON "odai_banner_clients" USING "btree" ("own_prefix");


--
-- TOC entry 2692 (class 1259 OID 16496)
-- Name: odai_banner_tracks_idx_banner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banner_tracks_idx_banner_id" ON "odai_banner_tracks" USING "btree" ("banner_id");


--
-- TOC entry 2693 (class 1259 OID 16494)
-- Name: odai_banner_tracks_idx_track_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banner_tracks_idx_track_date" ON "odai_banner_tracks" USING "btree" ("track_date");


--
-- TOC entry 2694 (class 1259 OID 16495)
-- Name: odai_banner_tracks_idx_track_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banner_tracks_idx_track_type" ON "odai_banner_tracks" USING "btree" ("track_type");


--
-- TOC entry 2681 (class 1259 OID 16462)
-- Name: odai_banners_idx_banner_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banners_idx_banner_catid" ON "odai_banners" USING "btree" ("catid");


--
-- TOC entry 2682 (class 1259 OID 16463)
-- Name: odai_banners_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banners_idx_language" ON "odai_banners" USING "btree" ("language");


--
-- TOC entry 2683 (class 1259 OID 16461)
-- Name: odai_banners_idx_metakey_prefix; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banners_idx_metakey_prefix" ON "odai_banners" USING "btree" ("metakey_prefix");


--
-- TOC entry 2684 (class 1259 OID 16460)
-- Name: odai_banners_idx_own_prefix; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banners_idx_own_prefix" ON "odai_banners" USING "btree" ("own_prefix");


--
-- TOC entry 2685 (class 1259 OID 16459)
-- Name: odai_banners_idx_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_banners_idx_state" ON "odai_banners" USING "btree" ("state");


--
-- TOC entry 2697 (class 1259 OID 16529)
-- Name: odai_categories_cat_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_cat_idx" ON "odai_categories" USING "btree" ("extension", "published", "access");


--
-- TOC entry 2698 (class 1259 OID 16530)
-- Name: odai_categories_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_idx_access" ON "odai_categories" USING "btree" ("access");


--
-- TOC entry 2699 (class 1259 OID 16534)
-- Name: odai_categories_idx_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_idx_alias" ON "odai_categories" USING "btree" ("alias");


--
-- TOC entry 2700 (class 1259 OID 16531)
-- Name: odai_categories_idx_checkout; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_idx_checkout" ON "odai_categories" USING "btree" ("checked_out");


--
-- TOC entry 2701 (class 1259 OID 16535)
-- Name: odai_categories_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_idx_language" ON "odai_categories" USING "btree" ("language");


--
-- TOC entry 2702 (class 1259 OID 16533)
-- Name: odai_categories_idx_left_right; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_idx_left_right" ON "odai_categories" USING "btree" ("lft", "rgt");


--
-- TOC entry 2703 (class 1259 OID 16532)
-- Name: odai_categories_idx_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_categories_idx_path" ON "odai_categories" USING "btree" ("path");


--
-- TOC entry 2706 (class 1259 OID 16579)
-- Name: odai_contact_details_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_access" ON "odai_contact_details" USING "btree" ("access");


--
-- TOC entry 2707 (class 1259 OID 16582)
-- Name: odai_contact_details_idx_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_catid" ON "odai_contact_details" USING "btree" ("catid");


--
-- TOC entry 2708 (class 1259 OID 16580)
-- Name: odai_contact_details_idx_checkout; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_checkout" ON "odai_contact_details" USING "btree" ("checked_out");


--
-- TOC entry 2709 (class 1259 OID 16583)
-- Name: odai_contact_details_idx_createdby; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_createdby" ON "odai_contact_details" USING "btree" ("created_by");


--
-- TOC entry 2710 (class 1259 OID 16584)
-- Name: odai_contact_details_idx_featured_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_featured_catid" ON "odai_contact_details" USING "btree" ("featured", "catid");


--
-- TOC entry 2711 (class 1259 OID 16585)
-- Name: odai_contact_details_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_language" ON "odai_contact_details" USING "btree" ("language");


--
-- TOC entry 2712 (class 1259 OID 16581)
-- Name: odai_contact_details_idx_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_state" ON "odai_contact_details" USING "btree" ("published");


--
-- TOC entry 2713 (class 1259 OID 16586)
-- Name: odai_contact_details_idx_xreference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contact_details_idx_xreference" ON "odai_contact_details" USING "btree" ("xreference");


--
-- TOC entry 2716 (class 1259 OID 16619)
-- Name: odai_content_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_access" ON "odai_content" USING "btree" ("access");


--
-- TOC entry 2717 (class 1259 OID 16622)
-- Name: odai_content_idx_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_catid" ON "odai_content" USING "btree" ("catid");


--
-- TOC entry 2718 (class 1259 OID 16620)
-- Name: odai_content_idx_checkout; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_checkout" ON "odai_content" USING "btree" ("checked_out");


--
-- TOC entry 2719 (class 1259 OID 16623)
-- Name: odai_content_idx_createdby; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_createdby" ON "odai_content" USING "btree" ("created_by");


--
-- TOC entry 2720 (class 1259 OID 16624)
-- Name: odai_content_idx_featured_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_featured_catid" ON "odai_content" USING "btree" ("featured", "catid");


--
-- TOC entry 2721 (class 1259 OID 16625)
-- Name: odai_content_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_language" ON "odai_content" USING "btree" ("language");


--
-- TOC entry 2722 (class 1259 OID 16621)
-- Name: odai_content_idx_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_state" ON "odai_content" USING "btree" ("state");


--
-- TOC entry 2723 (class 1259 OID 16626)
-- Name: odai_content_idx_xreference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_idx_xreference" ON "odai_content" USING "btree" ("xreference");


--
-- TOC entry 2730 (class 1259 OID 16659)
-- Name: odai_content_types_idx_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_content_types_idx_alias" ON "odai_content_types" USING "btree" ("type_alias");


--
-- TOC entry 2733 (class 1259 OID 16671)
-- Name: odai_contentitem_tag_map_idx_core_content_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contentitem_tag_map_idx_core_content_id" ON "odai_contentitem_tag_map" USING "btree" ("core_content_id");


--
-- TOC entry 2734 (class 1259 OID 16668)
-- Name: odai_contentitem_tag_map_idx_date_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contentitem_tag_map_idx_date_id" ON "odai_contentitem_tag_map" USING "btree" ("tag_date", "tag_id");


--
-- TOC entry 2735 (class 1259 OID 16669)
-- Name: odai_contentitem_tag_map_idx_tag; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contentitem_tag_map_idx_tag" ON "odai_contentitem_tag_map" USING "btree" ("tag_id");


--
-- TOC entry 2736 (class 1259 OID 16667)
-- Name: odai_contentitem_tag_map_idx_tag_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contentitem_tag_map_idx_tag_type" ON "odai_contentitem_tag_map" USING "btree" ("tag_id", "type_id");


--
-- TOC entry 2737 (class 1259 OID 16670)
-- Name: odai_contentitem_tag_map_idx_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_contentitem_tag_map_idx_type" ON "odai_contentitem_tag_map" USING "btree" ("type_id");


--
-- TOC entry 2740 (class 1259 OID 16697)
-- Name: odai_extensions_element_clientid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_extensions_element_clientid" ON "odai_extensions" USING "btree" ("element", "client_id");


--
-- TOC entry 2741 (class 1259 OID 16698)
-- Name: odai_extensions_element_folder_clientid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_extensions_element_folder_clientid" ON "odai_extensions" USING "btree" ("element", "folder", "client_id");


--
-- TOC entry 2742 (class 1259 OID 16699)
-- Name: odai_extensions_extension; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_extensions_extension" ON "odai_extensions" USING "btree" ("type", "element", "folder", "client_id");


--
-- TOC entry 2747 (class 1259 OID 16745)
-- Name: odai_finder_links_idx_md5; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_idx_md5" ON "odai_finder_links" USING "btree" ("md5sum");


--
-- TOC entry 2748 (class 1259 OID 16747)
-- Name: odai_finder_links_idx_published_list; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_idx_published_list" ON "odai_finder_links" USING "btree" ("published", "state", "access", "publish_start_date", "publish_end_date", "list_price");


--
-- TOC entry 2749 (class 1259 OID 16748)
-- Name: odai_finder_links_idx_published_sale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_idx_published_sale" ON "odai_finder_links" USING "btree" ("published", "state", "access", "publish_start_date", "publish_end_date", "sale_price");


--
-- TOC entry 2750 (class 1259 OID 16744)
-- Name: odai_finder_links_idx_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_idx_title" ON "odai_finder_links" USING "btree" ("title");


--
-- TOC entry 2751 (class 1259 OID 16743)
-- Name: odai_finder_links_idx_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_idx_type" ON "odai_finder_links" USING "btree" ("type_id");


--
-- TOC entry 2752 (class 1259 OID 16746)
-- Name: odai_finder_links_idx_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_idx_url" ON "odai_finder_links" USING "btree" ("substr"(("url")::"text", 0, 76));


--
-- TOC entry 2755 (class 1259 OID 16755)
-- Name: odai_finder_links_terms0_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms0_idx_link_term_weight" ON "odai_finder_links_terms0" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2756 (class 1259 OID 16754)
-- Name: odai_finder_links_terms0_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms0_idx_term_weight" ON "odai_finder_links_terms0" USING "btree" ("term_id", "weight");


--
-- TOC entry 2759 (class 1259 OID 16762)
-- Name: odai_finder_links_terms1_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms1_idx_link_term_weight" ON "odai_finder_links_terms1" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2760 (class 1259 OID 16761)
-- Name: odai_finder_links_terms1_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms1_idx_term_weight" ON "odai_finder_links_terms1" USING "btree" ("term_id", "weight");


--
-- TOC entry 2763 (class 1259 OID 16769)
-- Name: odai_finder_links_terms2_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms2_idx_link_term_weight" ON "odai_finder_links_terms2" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2764 (class 1259 OID 16768)
-- Name: odai_finder_links_terms2_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms2_idx_term_weight" ON "odai_finder_links_terms2" USING "btree" ("term_id", "weight");


--
-- TOC entry 2767 (class 1259 OID 16776)
-- Name: odai_finder_links_terms3_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms3_idx_link_term_weight" ON "odai_finder_links_terms3" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2768 (class 1259 OID 16775)
-- Name: odai_finder_links_terms3_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms3_idx_term_weight" ON "odai_finder_links_terms3" USING "btree" ("term_id", "weight");


--
-- TOC entry 2771 (class 1259 OID 16783)
-- Name: odai_finder_links_terms4_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms4_idx_link_term_weight" ON "odai_finder_links_terms4" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2772 (class 1259 OID 16782)
-- Name: odai_finder_links_terms4_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms4_idx_term_weight" ON "odai_finder_links_terms4" USING "btree" ("term_id", "weight");


--
-- TOC entry 2775 (class 1259 OID 16790)
-- Name: odai_finder_links_terms5_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms5_idx_link_term_weight" ON "odai_finder_links_terms5" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2776 (class 1259 OID 16789)
-- Name: odai_finder_links_terms5_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms5_idx_term_weight" ON "odai_finder_links_terms5" USING "btree" ("term_id", "weight");


--
-- TOC entry 2779 (class 1259 OID 16797)
-- Name: odai_finder_links_terms6_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms6_idx_link_term_weight" ON "odai_finder_links_terms6" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2780 (class 1259 OID 16796)
-- Name: odai_finder_links_terms6_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms6_idx_term_weight" ON "odai_finder_links_terms6" USING "btree" ("term_id", "weight");


--
-- TOC entry 2783 (class 1259 OID 16804)
-- Name: odai_finder_links_terms7_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms7_idx_link_term_weight" ON "odai_finder_links_terms7" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2784 (class 1259 OID 16803)
-- Name: odai_finder_links_terms7_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms7_idx_term_weight" ON "odai_finder_links_terms7" USING "btree" ("term_id", "weight");


--
-- TOC entry 2787 (class 1259 OID 16811)
-- Name: odai_finder_links_terms8_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms8_idx_link_term_weight" ON "odai_finder_links_terms8" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2788 (class 1259 OID 16810)
-- Name: odai_finder_links_terms8_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms8_idx_term_weight" ON "odai_finder_links_terms8" USING "btree" ("term_id", "weight");


--
-- TOC entry 2791 (class 1259 OID 16818)
-- Name: odai_finder_links_terms9_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms9_idx_link_term_weight" ON "odai_finder_links_terms9" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2792 (class 1259 OID 16817)
-- Name: odai_finder_links_terms9_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_terms9_idx_term_weight" ON "odai_finder_links_terms9" USING "btree" ("term_id", "weight");


--
-- TOC entry 2795 (class 1259 OID 16825)
-- Name: odai_finder_links_termsa_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsa_idx_link_term_weight" ON "odai_finder_links_termsa" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2796 (class 1259 OID 16824)
-- Name: odai_finder_links_termsa_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsa_idx_term_weight" ON "odai_finder_links_termsa" USING "btree" ("term_id", "weight");


--
-- TOC entry 2799 (class 1259 OID 16832)
-- Name: odai_finder_links_termsb_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsb_idx_link_term_weight" ON "odai_finder_links_termsb" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2800 (class 1259 OID 16831)
-- Name: odai_finder_links_termsb_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsb_idx_term_weight" ON "odai_finder_links_termsb" USING "btree" ("term_id", "weight");


--
-- TOC entry 2803 (class 1259 OID 16839)
-- Name: odai_finder_links_termsc_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsc_idx_link_term_weight" ON "odai_finder_links_termsc" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2804 (class 1259 OID 16838)
-- Name: odai_finder_links_termsc_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsc_idx_term_weight" ON "odai_finder_links_termsc" USING "btree" ("term_id", "weight");


--
-- TOC entry 2807 (class 1259 OID 16846)
-- Name: odai_finder_links_termsd_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsd_idx_link_term_weight" ON "odai_finder_links_termsd" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2808 (class 1259 OID 16845)
-- Name: odai_finder_links_termsd_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsd_idx_term_weight" ON "odai_finder_links_termsd" USING "btree" ("term_id", "weight");


--
-- TOC entry 2811 (class 1259 OID 16853)
-- Name: odai_finder_links_termse_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termse_idx_link_term_weight" ON "odai_finder_links_termse" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2812 (class 1259 OID 16852)
-- Name: odai_finder_links_termse_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termse_idx_term_weight" ON "odai_finder_links_termse" USING "btree" ("term_id", "weight");


--
-- TOC entry 2815 (class 1259 OID 16860)
-- Name: odai_finder_links_termsf_idx_link_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsf_idx_link_term_weight" ON "odai_finder_links_termsf" USING "btree" ("link_id", "term_id", "weight");


--
-- TOC entry 2816 (class 1259 OID 16859)
-- Name: odai_finder_links_termsf_idx_term_weight; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_links_termsf_idx_term_weight" ON "odai_finder_links_termsf" USING "btree" ("term_id", "weight");


--
-- TOC entry 2819 (class 1259 OID 16876)
-- Name: odai_finder_taxonomy_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_access" ON "odai_finder_taxonomy" USING "btree" ("access");


--
-- TOC entry 2820 (class 1259 OID 16877)
-- Name: odai_finder_taxonomy_idx_parent_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_idx_parent_published" ON "odai_finder_taxonomy" USING "btree" ("parent_id", "state", "access");


--
-- TOC entry 2826 (class 1259 OID 16883)
-- Name: odai_finder_taxonomy_map_link_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_map_link_id" ON "odai_finder_taxonomy_map" USING "btree" ("link_id");


--
-- TOC entry 2827 (class 1259 OID 16884)
-- Name: odai_finder_taxonomy_map_node_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_map_node_id" ON "odai_finder_taxonomy_map" USING "btree" ("node_id");


--
-- TOC entry 2821 (class 1259 OID 16875)
-- Name: odai_finder_taxonomy_ordering; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_ordering" ON "odai_finder_taxonomy" USING "btree" ("ordering");


--
-- TOC entry 2822 (class 1259 OID 16873)
-- Name: odai_finder_taxonomy_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_parent_id" ON "odai_finder_taxonomy" USING "btree" ("parent_id");


--
-- TOC entry 2825 (class 1259 OID 16874)
-- Name: odai_finder_taxonomy_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_taxonomy_state" ON "odai_finder_taxonomy" USING "btree" ("state");


--
-- TOC entry 2837 (class 1259 OID 16907)
-- Name: odai_finder_terms_common_idx_lang; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_terms_common_idx_lang" ON "odai_finder_terms_common" USING "btree" ("language");


--
-- TOC entry 2838 (class 1259 OID 16906)
-- Name: odai_finder_terms_common_idx_word_lang; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_terms_common_idx_word_lang" ON "odai_finder_terms_common" USING "btree" ("term", "language");


--
-- TOC entry 2830 (class 1259 OID 16901)
-- Name: odai_finder_terms_idx_soundex_phrase; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_terms_idx_soundex_phrase" ON "odai_finder_terms" USING "btree" ("soundex", "phrase");


--
-- TOC entry 2831 (class 1259 OID 16900)
-- Name: odai_finder_terms_idx_stem_phrase; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_terms_idx_stem_phrase" ON "odai_finder_terms" USING "btree" ("stem", "phrase");


--
-- TOC entry 2834 (class 1259 OID 16899)
-- Name: odai_finder_terms_idx_term_phrase; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_terms_idx_term_phrase" ON "odai_finder_terms" USING "btree" ("term", "phrase");


--
-- TOC entry 2842 (class 1259 OID 16923)
-- Name: odai_finder_tokens_aggregate_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_tokens_aggregate_token" ON "odai_finder_tokens_aggregate" USING "btree" ("term");


--
-- TOC entry 2839 (class 1259 OID 16916)
-- Name: odai_finder_tokens_idx_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_tokens_idx_context" ON "odai_finder_tokens" USING "btree" ("context");


--
-- TOC entry 2840 (class 1259 OID 16915)
-- Name: odai_finder_tokens_idx_word; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_finder_tokens_idx_word" ON "odai_finder_tokens" USING "btree" ("term");


--
-- TOC entry 2847 (class 1259 OID 16957)
-- Name: odai_languages_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_languages_idx_access" ON "odai_languages" USING "btree" ("access");


--
-- TOC entry 2852 (class 1259 OID 16956)
-- Name: odai_languages_idx_ordering; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_languages_idx_ordering" ON "odai_languages" USING "btree" ("ordering");


--
-- TOC entry 2857 (class 1259 OID 16992)
-- Name: odai_menu_idx_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_menu_idx_alias" ON "odai_menu" USING "btree" ("alias");


--
-- TOC entry 2860 (class 1259 OID 16989)
-- Name: odai_menu_idx_componentid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_menu_idx_componentid" ON "odai_menu" USING "btree" ("component_id", "menutype", "published", "access");


--
-- TOC entry 2861 (class 1259 OID 16994)
-- Name: odai_menu_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_menu_idx_language" ON "odai_menu" USING "btree" ("language");


--
-- TOC entry 2862 (class 1259 OID 16991)
-- Name: odai_menu_idx_left_right; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_menu_idx_left_right" ON "odai_menu" USING "btree" ("lft", "rgt");


--
-- TOC entry 2863 (class 1259 OID 16990)
-- Name: odai_menu_idx_menutype; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_menu_idx_menutype" ON "odai_menu" USING "btree" ("menutype");


--
-- TOC entry 2864 (class 1259 OID 16993)
-- Name: odai_menu_idx_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_menu_idx_path" ON "odai_menu" USING "btree" ("path");


--
-- TOC entry 2873 (class 1259 OID 17024)
-- Name: odai_messages_useridto_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_messages_useridto_state" ON "odai_messages" USING "btree" ("user_id_to", "state");


--
-- TOC entry 2876 (class 1259 OID 17061)
-- Name: odai_modules_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_modules_idx_language" ON "odai_modules" USING "btree" ("language");


--
-- TOC entry 2877 (class 1259 OID 17060)
-- Name: odai_modules_newsfeeds; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_modules_newsfeeds" ON "odai_modules" USING "btree" ("module", "published");


--
-- TOC entry 2880 (class 1259 OID 17059)
-- Name: odai_modules_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_modules_published" ON "odai_modules" USING "btree" ("published", "access");


--
-- TOC entry 2883 (class 1259 OID 17102)
-- Name: odai_newsfeeds_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_access" ON "odai_newsfeeds" USING "btree" ("access");


--
-- TOC entry 2884 (class 1259 OID 17105)
-- Name: odai_newsfeeds_idx_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_catid" ON "odai_newsfeeds" USING "btree" ("catid");


--
-- TOC entry 2885 (class 1259 OID 17103)
-- Name: odai_newsfeeds_idx_checkout; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_checkout" ON "odai_newsfeeds" USING "btree" ("checked_out");


--
-- TOC entry 2886 (class 1259 OID 17106)
-- Name: odai_newsfeeds_idx_createdby; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_createdby" ON "odai_newsfeeds" USING "btree" ("created_by");


--
-- TOC entry 2887 (class 1259 OID 17107)
-- Name: odai_newsfeeds_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_language" ON "odai_newsfeeds" USING "btree" ("language");


--
-- TOC entry 2888 (class 1259 OID 17104)
-- Name: odai_newsfeeds_idx_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_state" ON "odai_newsfeeds" USING "btree" ("published");


--
-- TOC entry 2889 (class 1259 OID 17108)
-- Name: odai_newsfeeds_idx_xreference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_newsfeeds_idx_xreference" ON "odai_newsfeeds" USING "btree" ("xreference");


--
-- TOC entry 2896 (class 1259 OID 17160)
-- Name: odai_redirect_links_idx_link_modifed; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_redirect_links_idx_link_modifed" ON "odai_redirect_links" USING "btree" ("modified_date");


--
-- TOC entry 2905 (class 1259 OID 17181)
-- Name: odai_session_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_session_time" ON "odai_session" USING "btree" ("time");


--
-- TOC entry 2906 (class 1259 OID 17180)
-- Name: odai_session_userid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_session_userid" ON "odai_session" USING "btree" ("userid");


--
-- TOC entry 2907 (class 1259 OID 17215)
-- Name: odai_tags_cat_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_cat_idx" ON "odai_tags" USING "btree" ("published", "access");


--
-- TOC entry 2908 (class 1259 OID 17216)
-- Name: odai_tags_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_idx_access" ON "odai_tags" USING "btree" ("access");


--
-- TOC entry 2909 (class 1259 OID 17220)
-- Name: odai_tags_idx_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_idx_alias" ON "odai_tags" USING "btree" ("alias");


--
-- TOC entry 2910 (class 1259 OID 17217)
-- Name: odai_tags_idx_checkout; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_idx_checkout" ON "odai_tags" USING "btree" ("checked_out");


--
-- TOC entry 2911 (class 1259 OID 17221)
-- Name: odai_tags_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_idx_language" ON "odai_tags" USING "btree" ("language");


--
-- TOC entry 2912 (class 1259 OID 17219)
-- Name: odai_tags_idx_left_right; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_idx_left_right" ON "odai_tags" USING "btree" ("lft", "rgt");


--
-- TOC entry 2913 (class 1259 OID 17218)
-- Name: odai_tags_idx_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_tags_idx_path" ON "odai_tags" USING "btree" ("path");


--
-- TOC entry 2916 (class 1259 OID 17238)
-- Name: odai_template_styles_idx_home; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_template_styles_idx_home" ON "odai_template_styles" USING "btree" ("home");


--
-- TOC entry 2917 (class 1259 OID 17237)
-- Name: odai_template_styles_idx_template; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_template_styles_idx_template" ON "odai_template_styles" USING "btree" ("template");


--
-- TOC entry 2922 (class 1259 OID 17247)
-- Name: odai_ucm_base_ucm_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_base_ucm_item_id" ON "odai_ucm_base" USING "btree" ("ucm_item_id");


--
-- TOC entry 2923 (class 1259 OID 17249)
-- Name: odai_ucm_base_ucm_language_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_base_ucm_language_id" ON "odai_ucm_base" USING "btree" ("ucm_language_id");


--
-- TOC entry 2924 (class 1259 OID 17248)
-- Name: odai_ucm_base_ucm_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_base_ucm_type_id" ON "odai_ucm_base" USING "btree" ("ucm_type_id");


--
-- TOC entry 2925 (class 1259 OID 17287)
-- Name: odai_ucm_content_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_access" ON "odai_ucm_content" USING "btree" ("core_access");


--
-- TOC entry 2926 (class 1259 OID 17288)
-- Name: odai_ucm_content_idx_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_alias" ON "odai_ucm_content" USING "btree" ("core_alias");


--
-- TOC entry 2927 (class 1259 OID 17293)
-- Name: odai_ucm_content_idx_content_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_content_type" ON "odai_ucm_content" USING "btree" ("core_type_alias");


--
-- TOC entry 2928 (class 1259 OID 17295)
-- Name: odai_ucm_content_idx_core_checked_out_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_core_checked_out_user_id" ON "odai_ucm_content" USING "btree" ("core_checked_out_user_id");


--
-- TOC entry 2929 (class 1259 OID 17296)
-- Name: odai_ucm_content_idx_core_created_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_core_created_user_id" ON "odai_ucm_content" USING "btree" ("core_created_user_id");


--
-- TOC entry 2930 (class 1259 OID 17294)
-- Name: odai_ucm_content_idx_core_modified_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_core_modified_user_id" ON "odai_ucm_content" USING "btree" ("core_modified_user_id");


--
-- TOC entry 2931 (class 1259 OID 17297)
-- Name: odai_ucm_content_idx_core_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_core_type_id" ON "odai_ucm_content" USING "btree" ("core_type_id");


--
-- TOC entry 2932 (class 1259 OID 17292)
-- Name: odai_ucm_content_idx_created_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_created_time" ON "odai_ucm_content" USING "btree" ("core_created_time");


--
-- TOC entry 2933 (class 1259 OID 17289)
-- Name: odai_ucm_content_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_language" ON "odai_ucm_content" USING "btree" ("core_language");


--
-- TOC entry 2934 (class 1259 OID 17291)
-- Name: odai_ucm_content_idx_modified_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_modified_time" ON "odai_ucm_content" USING "btree" ("core_modified_time");


--
-- TOC entry 2935 (class 1259 OID 17290)
-- Name: odai_ucm_content_idx_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_idx_title" ON "odai_ucm_content" USING "btree" ("core_title");


--
-- TOC entry 2940 (class 1259 OID 17286)
-- Name: odai_ucm_content_tag_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_content_tag_idx" ON "odai_ucm_content" USING "btree" ("core_state", "core_access");


--
-- TOC entry 2941 (class 1259 OID 17316)
-- Name: odai_ucm_history_idx_save_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_history_idx_save_date" ON "odai_ucm_history" USING "btree" ("save_date");


--
-- TOC entry 2942 (class 1259 OID 17315)
-- Name: odai_ucm_history_idx_ucm_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_ucm_history_idx_ucm_item_id" ON "odai_ucm_history" USING "btree" ("ucm_type_id", "ucm_item_id");


--
-- TOC entry 2966 (class 1259 OID 17427)
-- Name: odai_user_keys_idx_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_user_keys_idx_user_id" ON "odai_user_keys" USING "btree" ("user_id");


--
-- TOC entry 2971 (class 1259 OID 17452)
-- Name: odai_user_notes_idx_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_user_notes_idx_category_id" ON "odai_user_notes" USING "btree" ("catid");


--
-- TOC entry 2972 (class 1259 OID 17451)
-- Name: odai_user_notes_idx_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_user_notes_idx_user_id" ON "odai_user_notes" USING "btree" ("user_id");


--
-- TOC entry 2951 (class 1259 OID 17376)
-- Name: odai_usergroups_idx_usergroup_adjacency_lookup; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_usergroups_idx_usergroup_adjacency_lookup" ON "odai_usergroups" USING "btree" ("parent_id");


--
-- TOC entry 2952 (class 1259 OID 17377)
-- Name: odai_usergroups_idx_usergroup_nested_set_lookup; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_usergroups_idx_usergroup_nested_set_lookup" ON "odai_usergroups" USING "btree" ("lft", "rgt");


--
-- TOC entry 2955 (class 1259 OID 17375)
-- Name: odai_usergroups_idx_usergroup_title_lookup; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_usergroups_idx_usergroup_title_lookup" ON "odai_usergroups" USING "btree" ("title");


--
-- TOC entry 2960 (class 1259 OID 17413)
-- Name: odai_users_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_users_email" ON "odai_users" USING "btree" ("email");


--
-- TOC entry 2961 (class 1259 OID 17411)
-- Name: odai_users_idx_block; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_users_idx_block" ON "odai_users" USING "btree" ("block");


--
-- TOC entry 2962 (class 1259 OID 17410)
-- Name: odai_users_idx_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_users_idx_name" ON "odai_users" USING "btree" ("name");


--
-- TOC entry 2965 (class 1259 OID 17412)
-- Name: odai_users_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_users_username" ON "odai_users" USING "btree" ("username");


--
-- TOC entry 2981 (class 1259 OID 17505)
-- Name: odai_weblinks_idx_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_access" ON "odai_weblinks" USING "btree" ("access");


--
-- TOC entry 2982 (class 1259 OID 17508)
-- Name: odai_weblinks_idx_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_catid" ON "odai_weblinks" USING "btree" ("catid");


--
-- TOC entry 2983 (class 1259 OID 17506)
-- Name: odai_weblinks_idx_checkout; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_checkout" ON "odai_weblinks" USING "btree" ("checked_out");


--
-- TOC entry 2984 (class 1259 OID 17509)
-- Name: odai_weblinks_idx_createdby; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_createdby" ON "odai_weblinks" USING "btree" ("created_by");


--
-- TOC entry 2985 (class 1259 OID 17510)
-- Name: odai_weblinks_idx_featured_catid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_featured_catid" ON "odai_weblinks" USING "btree" ("featured", "catid");


--
-- TOC entry 2986 (class 1259 OID 17511)
-- Name: odai_weblinks_idx_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_language" ON "odai_weblinks" USING "btree" ("language");


--
-- TOC entry 2987 (class 1259 OID 17507)
-- Name: odai_weblinks_idx_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_state" ON "odai_weblinks" USING "btree" ("state");


--
-- TOC entry 2988 (class 1259 OID 17512)
-- Name: odai_weblinks_idx_xreference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "odai_weblinks_idx_xreference" ON "odai_weblinks" USING "btree" ("xreference");


--
-- TOC entry 3000 (class 2606 OID 18964)
-- Name: odai_odai_datasources_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_odai_datasources"
    ADD CONSTRAINT "odai_odai_datasources_fkey" FOREIGN KEY ("vdb_id") REFERENCES "odai_odai_vdbs"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2999 (class 2606 OID 18942)
-- Name: odai_odai_resources_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "odai_odai_resources"
    ADD CONSTRAINT "odai_odai_resources_fkey" FOREIGN KEY ("vdb_id") REFERENCES "odai_odai_vdbs"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3225 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
REVOKE ALL ON SCHEMA "public" FROM "postgres";
GRANT ALL ON SCHEMA "public" TO "postgres";
GRANT ALL ON SCHEMA "public" TO PUBLIC;


-- Completed on 2014-10-16 14:39:36

--
-- PostgreSQL database dump complete
--

