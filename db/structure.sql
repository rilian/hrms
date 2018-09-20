SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: action_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE action_points (
    id integer NOT NULL,
    person_id integer NOT NULL,
    value text,
    is_completed boolean DEFAULT false NOT NULL,
    perform_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: action_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE action_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE action_points_id_seq OWNED BY action_points.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachments (
    id integer NOT NULL,
    person_id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file_id character varying,
    file_filename character varying,
    file_size integer,
    file_content_type character varying,
    updated_by_id integer,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: dayoffs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE dayoffs (
    id integer NOT NULL,
    person_id integer NOT NULL,
    type character varying,
    notes text,
    days integer DEFAULT 1 NOT NULL,
    start_on date,
    end_on date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    updated_by_id integer,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: dayoffs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dayoffs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dayoffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dayoffs_id_seq OWNED BY dayoffs.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    entity_type character varying NOT NULL,
    entity_id integer NOT NULL,
    params jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    action character varying DEFAULT ''::character varying NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE expenses (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    type character varying DEFAULT 'Other'::character varying NOT NULL,
    notes text DEFAULT ''::text NOT NULL,
    amount integer NOT NULL,
    recorded_on date,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE expenses_id_seq OWNED BY expenses.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notes (
    id integer NOT NULL,
    person_id integer NOT NULL,
    type character varying DEFAULT 'Other'::character varying NOT NULL,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE people (
    id integer NOT NULL,
    name character varying NOT NULL,
    city character varying,
    phone character varying,
    skype character varying,
    linkedin character varying,
    primary_tech character varying,
    english character varying,
    day_of_birth date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying,
    updated_by_id integer,
    status character varying DEFAULT 'n/a'::character varying NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    action_points_count integer DEFAULT 0,
    attachments_count integer DEFAULT 0,
    notes_count integer DEFAULT 0,
    expected_salary character varying,
    start_date date,
    source character varying,
    vacation_override integer,
    photo_id character varying,
    photo_filename character varying,
    photo_size integer,
    photo_content_type character varying,
    skills text,
    finish_date date,
    current_position character varying,
    signed_nda boolean DEFAULT false NOT NULL,
    salary_type character varying,
    employee_id character varying,
    last_one_on_one_meeting_at date,
    last_performance_review_at date,
    next_performance_review_at date,
    github character varying,
    personal_email character varying,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: project_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE project_notes (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    value text,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: project_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_notes_id_seq OWNED BY project_notes.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id bigint NOT NULL,
    name character varying,
    description text,
    status character varying DEFAULT 'active'::character varying NOT NULL,
    started_at date,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    project_notes_count integer DEFAULT 0,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE searches (
    id integer NOT NULL,
    query character varying,
    path character varying,
    ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE searches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE searches_id_seq OWNED BY searches.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_type character varying,
    taggable_id integer,
    tagger_type character varying,
    tagger_id integer,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notifications_enabled boolean DEFAULT true NOT NULL,
    updated_by_id integer,
    hide_tags character varying[] DEFAULT '{}'::character varying[],
    hide_statuses character varying[] DEFAULT '{}'::character varying[],
    has_access_to_finances boolean DEFAULT false,
    has_access_to_events boolean DEFAULT false,
    has_access_to_users boolean DEFAULT false,
    employee_notifications_enabled boolean DEFAULT false,
    has_access_to_expenses boolean DEFAULT false,
    has_access_to_dayoffs boolean DEFAULT false,
    has_access_to_performance boolean DEFAULT false,
    updated_by_name character varying,
    created_by_name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: vacancies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vacancies (
    id integer NOT NULL,
    project character varying,
    role character varying,
    description text,
    updated_by_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tag character varying,
    status character varying DEFAULT 'open'::character varying
);


--
-- Name: vacancies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vacancies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vacancies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vacancies_id_seq OWNED BY vacancies.id;


--
-- Name: action_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY action_points ALTER COLUMN id SET DEFAULT nextval('action_points_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: dayoffs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dayoffs ALTER COLUMN id SET DEFAULT nextval('dayoffs_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY expenses ALTER COLUMN id SET DEFAULT nextval('expenses_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: project_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_notes ALTER COLUMN id SET DEFAULT nextval('project_notes_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: vacancies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacancies ALTER COLUMN id SET DEFAULT nextval('vacancies_id_seq'::regclass);


--
-- Name: action_points action_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY action_points
    ADD CONSTRAINT action_points_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: dayoffs dayoffs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dayoffs
    ADD CONSTRAINT dayoffs_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: project_notes project_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_notes
    ADD CONSTRAINT project_notes_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: searches searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vacancies vacancies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacancies
    ADD CONSTRAINT vacancies_pkey PRIMARY KEY (id);


--
-- Name: index_action_points_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_action_points_on_person_id ON action_points USING btree (person_id);


--
-- Name: index_attachments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_person_id ON attachments USING btree (person_id);


--
-- Name: index_dayoffs_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dayoffs_on_person_id ON dayoffs USING btree (person_id);


--
-- Name: index_events_on_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_entity_id ON events USING btree (entity_id);


--
-- Name: index_events_on_entity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_entity_type ON events USING btree (entity_type);


--
-- Name: index_events_on_params; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_params ON events USING gin (params);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON events USING btree (user_id);


--
-- Name: index_expenses_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_expenses_on_person_id ON expenses USING btree (person_id);


--
-- Name: index_notes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_person_id ON notes USING btree (person_id);


--
-- Name: index_people_on_action_points_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_action_points_count ON people USING btree (action_points_count);


--
-- Name: index_people_on_attachments_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_attachments_count ON people USING btree (attachments_count);


--
-- Name: index_people_on_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_is_deleted ON people USING btree (is_deleted);


--
-- Name: index_people_on_notes_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_notes_count ON people USING btree (notes_count);


--
-- Name: index_people_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_status ON people USING btree (status);


--
-- Name: index_project_notes_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_notes_on_project_id ON project_notes USING btree (project_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_tag_id ON taggings USING btree (taggable_id, taggable_type, tag_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20151203230043'),
('20151206022806'),
('20151206041810'),
('20151213225759'),
('20160101195429'),
('20160130095024'),
('20160130133849'),
('20160205211842'),
('20160205211843'),
('20160205211844'),
('20160205211845'),
('20160207151033'),
('20160229151543'),
('20160318215647'),
('20160328185638'),
('20160404074238'),
('20160418145542'),
('20160614201155'),
('20160614201434'),
('20160616191545'),
('20160619204703'),
('20160623212429'),
('20160626123050'),
('20160627093617'),
('20160627151119'),
('20160628085818'),
('20160629141248'),
('20160701123126'),
('20160707095608'),
('20160707154815'),
('20160802171123'),
('20160803122523'),
('20160804084846'),
('20160804165139'),
('20160816094539'),
('20161215134733'),
('20161222094814'),
('20161222171351'),
('20170613134756'),
('20170614153545'),
('20170615073837'),
('20170707082100'),
('20170707114658'),
('20170724171851'),
('20170801114924'),
('20170803155139'),
('20171122062431'),
('20171124182544'),
('20171124182837'),
('20171218111352'),
('20171219190759'),
('20180319174634'),
('20180614152142'),
('20180621092446'),
('20180816132516'),
('20180906111340'),
('20180910114353'),
('20180910115613'),
('20180915071848'),
('20180918073529');


