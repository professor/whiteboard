--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: course_numbers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE course_numbers (
    id integer NOT NULL,
    name character varying(255),
    number character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    short_name character varying(255)
);


--
-- Name: course_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE course_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE course_numbers_id_seq OWNED BY course_numbers.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    course_number_id integer,
    name character varying(255),
    number character varying(255),
    semester character varying(255),
    mini character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    primary_faculty_label character varying(255),
    secondary_faculty_label character varying(255),
    twiki_url character varying(255),
    remind_about_effort boolean,
    short_name character varying(255),
    year integer,
    configure_class_mailinglist boolean DEFAULT false,
    peer_evaluation_first_email date,
    peer_evaluation_second_email date,
    configure_teams_name_themselves boolean DEFAULT true,
    curriculum_url character varying(255),
    configure_course_twiki boolean DEFAULT false,
    is_configured boolean DEFAULT false,
    updated_by_user_id integer,
    configured_by_user_id integer,
    updating_email boolean,
    email character varying(255)
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: curriculum_comment_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE curriculum_comment_types (
    id integer NOT NULL,
    name character varying(255),
    background_color character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: curriculum_comment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE curriculum_comment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curriculum_comment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE curriculum_comment_types_id_seq OWNED BY curriculum_comment_types.id;


--
-- Name: curriculum_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE curriculum_comments (
    id integer NOT NULL,
    url character varying(255),
    semester character varying(255),
    year character varying(255),
    user_id integer,
    curriculum_comment_type_id integer,
    comment character varying(4000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    human_name character varying(255),
    notify_me boolean
);


--
-- Name: curriculum_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE curriculum_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curriculum_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE curriculum_comments_id_seq OWNED BY curriculum_comments.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: deliverable_attachment_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deliverable_attachment_versions (
    id integer NOT NULL,
    deliverable_id integer,
    submitter_id integer,
    submission_date timestamp without time zone,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    comment text
);


--
-- Name: deliverable_attachment_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliverable_attachment_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deliverable_attachment_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliverable_attachment_versions_id_seq OWNED BY deliverable_attachment_versions.id;


--
-- Name: deliverables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deliverables (
    id integer NOT NULL,
    name text,
    team_id integer,
    course_id integer,
    task_number character varying(255),
    creator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    feedback_comment text,
    feedback_file_name character varying(255),
    feedback_content_type character varying(255),
    feedback_file_size integer,
    feedback_updated_at timestamp without time zone
);


--
-- Name: deliverables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliverables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliverables_id_seq OWNED BY deliverables.id;


--
-- Name: effort_log_line_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE effort_log_line_items (
    id integer NOT NULL,
    effort_log_id integer,
    course_id integer,
    task_type_id integer,
    day1 double precision,
    day2 double precision,
    day3 double precision,
    day4 double precision,
    day5 double precision,
    day6 double precision,
    day7 double precision,
    sum double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer
);


--
-- Name: effort_log_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE effort_log_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: effort_log_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE effort_log_line_items_id_seq OWNED BY effort_log_line_items.id;


--
-- Name: effort_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE effort_logs (
    id integer NOT NULL,
    user_id integer,
    week_number integer,
    year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sum double precision
);


--
-- Name: effort_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE effort_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: effort_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE effort_logs_id_seq OWNED BY effort_logs.id;


--
-- Name: faculty_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faculty_assignments (
    course_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: individual_contribution_for_courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE individual_contribution_for_courses (
    id integer NOT NULL,
    individual_contribution_id integer,
    course_id integer,
    answer1 text,
    answer2 double precision,
    answer3 text,
    answer4 text,
    answer5 text
);


--
-- Name: individual_contribution_for_courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE individual_contribution_for_courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: individual_contribution_for_courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE individual_contribution_for_courses_id_seq OWNED BY individual_contribution_for_courses.id;


--
-- Name: individual_contributions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE individual_contributions (
    id integer NOT NULL,
    user_id integer,
    year integer,
    week_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: individual_contributions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE individual_contributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: individual_contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE individual_contributions_id_seq OWNED BY individual_contributions.id;


--
-- Name: page_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_attachments (
    id integer NOT NULL,
    page_id integer,
    user_id integer,
    "position" integer,
    is_active boolean DEFAULT true,
    readable_name character varying(255),
    page_attachment_file_name character varying(255),
    page_attachment_content_type character varying(255),
    page_attachment_file_size integer,
    page_attachment_updated_at timestamp without time zone
);


--
-- Name: page_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_attachments_id_seq OWNED BY page_attachments.id;


--
-- Name: page_comment_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_comment_types (
    id integer NOT NULL,
    name character varying(255),
    background_color character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: page_comment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_comment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_comment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_comment_types_id_seq OWNED BY page_comment_types.id;


--
-- Name: page_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_comments (
    id integer NOT NULL,
    user_id integer,
    page_id integer,
    page_comment_type_id integer,
    comment text,
    notify_me boolean,
    display_name character varying(255),
    semester character varying(255),
    year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: page_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_comments_id_seq OWNED BY page_comments.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    course_id integer,
    title character varying(255),
    "position" integer,
    indentation_level integer,
    is_task boolean,
    tab_one_contents text,
    tab_two_contents text,
    tab_three_contents text,
    task_duration integer,
    tab_one_email_from character varying(255),
    tab_one_email_subject character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tips_and_traps text,
    readings_and_resources text,
    faculty_notes text,
    updated_by_user_id integer,
    version integer,
    version_comments character varying(255),
    url character varying(255),
    is_editable_by_all boolean DEFAULT false,
    is_duplicated_page boolean DEFAULT false,
    is_viewable_by_all boolean DEFAULT true
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: peer_evaluation_learning_objectives; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peer_evaluation_learning_objectives (
    id integer NOT NULL,
    user_id integer,
    team_id integer,
    learning_objective character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: peer_evaluation_learning_objectives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE peer_evaluation_learning_objectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: peer_evaluation_learning_objectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE peer_evaluation_learning_objectives_id_seq OWNED BY peer_evaluation_learning_objectives.id;


--
-- Name: peer_evaluation_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peer_evaluation_reports (
    id integer NOT NULL,
    team_id integer,
    recipient_id integer,
    feedback text,
    email_date timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: peer_evaluation_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE peer_evaluation_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: peer_evaluation_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE peer_evaluation_reports_id_seq OWNED BY peer_evaluation_reports.id;


--
-- Name: peer_evaluation_reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peer_evaluation_reviews (
    id integer NOT NULL,
    team_id integer,
    author_id integer,
    recipient_id integer,
    question character varying(255),
    answer text,
    sequence_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: peer_evaluation_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE peer_evaluation_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: peer_evaluation_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE peer_evaluation_reviews_id_seq OWNED BY peer_evaluation_reviews.id;


--
-- Name: people_search_defaults; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people_search_defaults (
    id integer NOT NULL,
    user_id integer,
    student_staff_group character varying(255),
    program_group character varying(255),
    track_group character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: people_search_defaults_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_search_defaults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_search_defaults_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_search_defaults_id_seq OWNED BY people_search_defaults.id;


--
-- Name: presentation_feedback_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE presentation_feedback_answers (
    id integer NOT NULL,
    feedback_id integer,
    question_id integer,
    rating integer,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: presentation_feedback_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE presentation_feedback_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presentation_feedback_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE presentation_feedback_answers_id_seq OWNED BY presentation_feedback_answers.id;


--
-- Name: presentation_feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE presentation_feedbacks (
    id integer NOT NULL,
    evaluator_id integer,
    presentation_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: presentation_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE presentation_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presentation_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE presentation_feedbacks_id_seq OWNED BY presentation_feedbacks.id;


--
-- Name: presentation_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE presentation_questions (
    id integer NOT NULL,
    label character varying(255),
    text text,
    deleted boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: presentation_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE presentation_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presentation_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE presentation_questions_id_seq OWNED BY presentation_questions.id;


--
-- Name: presentations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE presentations (
    id integer NOT NULL,
    name character varying(255),
    description text,
    team_id integer,
    course_id integer,
    task_number character varying(255),
    creator_id integer,
    presentation_date date,
    user_id integer,
    feedback_email_sent boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: presentations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE presentations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presentations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE presentations_id_seq OWNED BY presentations.id;


--
-- Name: registrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE registrations (
    course_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rss_feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rss_feeds (
    id integer NOT NULL,
    title character varying(255),
    link character varying(255),
    publication_date timestamp without time zone,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rss_feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rss_feeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rss_feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rss_feeds_id_seq OWNED BY rss_feeds.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: scotty_dog_sayings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scotty_dog_sayings (
    id integer NOT NULL,
    saying text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: scotty_dog_sayings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scotty_dog_sayings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scotty_dog_sayings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scotty_dog_sayings_id_seq OWNED BY scotty_dog_sayings.id;


--
-- Name: sponsored_project_allocations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sponsored_project_allocations (
    id integer NOT NULL,
    sponsored_project_id integer,
    user_id integer,
    current_allocation integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_archived boolean DEFAULT false
);


--
-- Name: sponsored_project_allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sponsored_project_allocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sponsored_project_allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sponsored_project_allocations_id_seq OWNED BY sponsored_project_allocations.id;


--
-- Name: sponsored_project_efforts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sponsored_project_efforts (
    id integer NOT NULL,
    sponsored_project_allocation_id integer,
    year integer,
    month integer,
    actual_allocation integer,
    current_allocation integer,
    confirmed boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sponsored_project_efforts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sponsored_project_efforts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sponsored_project_efforts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sponsored_project_efforts_id_seq OWNED BY sponsored_project_efforts.id;


--
-- Name: sponsored_project_sponsors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sponsored_project_sponsors (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_archived boolean DEFAULT false
);


--
-- Name: sponsored_project_sponsors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sponsored_project_sponsors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sponsored_project_sponsors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sponsored_project_sponsors_id_seq OWNED BY sponsored_project_sponsors.id;


--
-- Name: sponsored_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sponsored_projects (
    id integer NOT NULL,
    name character varying(255),
    sponsor_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_archived boolean DEFAULT false
);


--
-- Name: sponsored_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sponsored_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sponsored_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sponsored_projects_id_seq OWNED BY sponsored_projects.id;


--
-- Name: strength_themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE strength_themes (
    id integer NOT NULL,
    theme character varying(255),
    brief_description character varying(255),
    long_description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: strength_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE strength_themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: strength_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE strength_themes_id_seq OWNED BY strength_themes.id;


--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suggestions (
    id integer NOT NULL,
    user_id integer,
    comment text,
    page character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email character varying(255)
);


--
-- Name: suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suggestions_id_seq OWNED BY suggestions.id;


--
-- Name: task_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task_types (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    is_staff boolean DEFAULT false,
    is_student boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: task_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE task_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE task_types_id_seq OWNED BY task_types.id;


--
-- Name: team_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_assignments (
    team_id integer,
    user_id integer
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    twiki_space character varying(255),
    tigris_space character varying(255),
    primary_faculty_id integer,
    secondary_faculty_id integer,
    livemeeting character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    section character varying(255),
    peer_evaluation_first_email date,
    peer_evaluation_second_email date,
    peer_evaluation_do_point_allocation boolean,
    course_id integer,
    updating_email boolean
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: user_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_versions (
    id integer NOT NULL,
    user_id integer,
    version integer,
    webiso_account character varying(255),
    email character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_staff boolean DEFAULT false,
    is_student boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    twiki_name character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    human_name character varying(255),
    image_uri character varying(255),
    graduation_year character varying(255),
    masters_program character varying(255),
    masters_track character varying(255),
    is_part_time boolean,
    is_adobe_connect_host boolean,
    effort_log_warning_email timestamp without time zone,
    is_active boolean,
    legal_first_name character varying(255),
    organization_name character varying(255),
    title character varying(255),
    work_city character varying(255),
    work_state character varying(255),
    work_country character varying(255),
    telephone1 character varying(255),
    skype character varying(255),
    tigris character varying(255),
    personal_email character varying(255),
    local_near_remote character varying(255),
    biography text,
    user_text text,
    office character varying(255),
    office_hours character varying(255),
    telephone1_label character varying(255),
    telephone2 character varying(255),
    telephone2_label character varying(255),
    telephone3 character varying(255),
    telephone3_label character varying(255),
    telephone4 character varying(255),
    telephone4_label character varying(255),
    updated_by_user_id bigint,
    is_alumnus boolean,
    pronunciation character varying(255),
    google_created timestamp without time zone,
    twiki_created timestamp without time zone,
    adobe_created timestamp without time zone,
    msdnaa_created timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    yammer_created timestamp without time zone,
    strength1_id integer,
    strength2_id integer,
    strength3_id integer,
    strength4_id integer,
    strength5_id integer,
    sponsored_project_effort_last_emailed timestamp without time zone,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    github character varying(255),
    course_tools_view character varying(255),
    remember_token character varying(255),
    remember_created_at timestamp without time zone,
    expires_at date,
    course_index_view character varying(255),
    linked_in character varying(255),
    facebook character varying(255),
    twitter character varying(255),
    google_plus character varying(255),
    people_search_first_accessed_at timestamp without time zone,
    is_profile_valid boolean
);


--
-- Name: user_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_versions_id_seq OWNED BY user_versions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    webiso_account character varying(255),
    email character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_staff boolean DEFAULT false,
    is_student boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    twiki_name character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    human_name character varying(255),
    image_uri character varying(255),
    graduation_year character varying(255),
    masters_program character varying(255),
    masters_track character varying(255),
    is_part_time boolean,
    is_adobe_connect_host boolean,
    effort_log_warning_email timestamp without time zone,
    is_active boolean,
    legal_first_name character varying(255),
    organization_name character varying(255),
    title character varying(255),
    work_city character varying(255),
    work_state character varying(255),
    work_country character varying(255),
    telephone1 character varying(255),
    skype character varying(255),
    tigris character varying(255),
    personal_email character varying(255),
    local_near_remote character varying(255),
    biography text,
    user_text text,
    office character varying(255),
    office_hours character varying(255),
    telephone1_label character varying(255),
    telephone2 character varying(255),
    telephone2_label character varying(255),
    telephone3 character varying(255),
    telephone3_label character varying(255),
    telephone4 character varying(255),
    telephone4_label character varying(255),
    updated_by_user_id integer,
    version integer,
    is_alumnus boolean,
    pronunciation character varying(255),
    google_created timestamp without time zone,
    twiki_created timestamp without time zone,
    adobe_created timestamp without time zone,
    msdnaa_created timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    yammer_created timestamp without time zone,
    strength1_id integer,
    strength2_id integer,
    strength3_id integer,
    strength4_id integer,
    strength5_id integer,
    sponsored_project_effort_last_emailed timestamp without time zone,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    github character varying(255),
    course_tools_view character varying(255),
    remember_token character varying(255),
    remember_created_at timestamp without time zone,
    expires_at date,
    course_index_view character varying(255),
    linked_in character varying(255),
    facebook character varying(255),
    twitter character varying(255),
    google_plus character varying(255),
    people_search_first_accessed_at timestamp without time zone,
    is_profile_valid boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
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
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    versioned_id integer,
    versioned_type character varying(255),
    user_id integer,
    user_type character varying(255),
    user_name character varying(255),
    modifications text,
    number integer,
    tag character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reverted_from integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY course_numbers ALTER COLUMN id SET DEFAULT nextval('course_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY curriculum_comment_types ALTER COLUMN id SET DEFAULT nextval('curriculum_comment_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY curriculum_comments ALTER COLUMN id SET DEFAULT nextval('curriculum_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverable_attachment_versions ALTER COLUMN id SET DEFAULT nextval('deliverable_attachment_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverables ALTER COLUMN id SET DEFAULT nextval('deliverables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY effort_log_line_items ALTER COLUMN id SET DEFAULT nextval('effort_log_line_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY effort_logs ALTER COLUMN id SET DEFAULT nextval('effort_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY individual_contribution_for_courses ALTER COLUMN id SET DEFAULT nextval('individual_contribution_for_courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY individual_contributions ALTER COLUMN id SET DEFAULT nextval('individual_contributions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY page_attachments ALTER COLUMN id SET DEFAULT nextval('page_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY page_comment_types ALTER COLUMN id SET DEFAULT nextval('page_comment_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY page_comments ALTER COLUMN id SET DEFAULT nextval('page_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY peer_evaluation_learning_objectives ALTER COLUMN id SET DEFAULT nextval('peer_evaluation_learning_objectives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY peer_evaluation_reports ALTER COLUMN id SET DEFAULT nextval('peer_evaluation_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY peer_evaluation_reviews ALTER COLUMN id SET DEFAULT nextval('peer_evaluation_reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people_search_defaults ALTER COLUMN id SET DEFAULT nextval('people_search_defaults_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY presentation_feedback_answers ALTER COLUMN id SET DEFAULT nextval('presentation_feedback_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY presentation_feedbacks ALTER COLUMN id SET DEFAULT nextval('presentation_feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY presentation_questions ALTER COLUMN id SET DEFAULT nextval('presentation_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY presentations ALTER COLUMN id SET DEFAULT nextval('presentations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_types ALTER COLUMN id SET DEFAULT nextval('project_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rss_feeds ALTER COLUMN id SET DEFAULT nextval('rss_feeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scotty_dog_sayings ALTER COLUMN id SET DEFAULT nextval('scotty_dog_sayings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sponsored_project_allocations ALTER COLUMN id SET DEFAULT nextval('sponsored_project_allocations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sponsored_project_efforts ALTER COLUMN id SET DEFAULT nextval('sponsored_project_efforts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sponsored_project_sponsors ALTER COLUMN id SET DEFAULT nextval('sponsored_project_sponsors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sponsored_projects ALTER COLUMN id SET DEFAULT nextval('sponsored_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY strength_themes ALTER COLUMN id SET DEFAULT nextval('strength_themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suggestions ALTER COLUMN id SET DEFAULT nextval('suggestions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_types ALTER COLUMN id SET DEFAULT nextval('task_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_versions ALTER COLUMN id SET DEFAULT nextval('user_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: course_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY course_numbers
    ADD CONSTRAINT course_numbers_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: curriculum_comment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY curriculum_comment_types
    ADD CONSTRAINT curriculum_comment_types_pkey PRIMARY KEY (id);


--
-- Name: curriculum_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY curriculum_comments
    ADD CONSTRAINT curriculum_comments_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: deliverable_attachment_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deliverable_attachment_versions
    ADD CONSTRAINT deliverable_attachment_versions_pkey PRIMARY KEY (id);


--
-- Name: deliverables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deliverables
    ADD CONSTRAINT deliverables_pkey PRIMARY KEY (id);


--
-- Name: effort_log_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY effort_log_line_items
    ADD CONSTRAINT effort_log_line_items_pkey PRIMARY KEY (id);


--
-- Name: effort_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY effort_logs
    ADD CONSTRAINT effort_logs_pkey PRIMARY KEY (id);


--
-- Name: individual_contribution_for_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY individual_contribution_for_courses
    ADD CONSTRAINT individual_contribution_for_courses_pkey PRIMARY KEY (id);


--
-- Name: individual_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY individual_contributions
    ADD CONSTRAINT individual_contributions_pkey PRIMARY KEY (id);


--
-- Name: page_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_attachments
    ADD CONSTRAINT page_attachments_pkey PRIMARY KEY (id);


--
-- Name: page_comment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_comment_types
    ADD CONSTRAINT page_comment_types_pkey PRIMARY KEY (id);


--
-- Name: page_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_comments
    ADD CONSTRAINT page_comments_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: peer_evaluation_learning_objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peer_evaluation_learning_objectives
    ADD CONSTRAINT peer_evaluation_learning_objectives_pkey PRIMARY KEY (id);


--
-- Name: peer_evaluation_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peer_evaluation_reports
    ADD CONSTRAINT peer_evaluation_reports_pkey PRIMARY KEY (id);


--
-- Name: peer_evaluation_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peer_evaluation_reviews
    ADD CONSTRAINT peer_evaluation_reviews_pkey PRIMARY KEY (id);


--
-- Name: people_search_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people_search_defaults
    ADD CONSTRAINT people_search_defaults_pkey PRIMARY KEY (id);


--
-- Name: presentation_feedback_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY presentation_feedback_answers
    ADD CONSTRAINT presentation_feedback_answers_pkey PRIMARY KEY (id);


--
-- Name: presentation_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY presentation_feedbacks
    ADD CONSTRAINT presentation_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: presentation_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY presentation_questions
    ADD CONSTRAINT presentation_questions_pkey PRIMARY KEY (id);


--
-- Name: presentations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY presentations
    ADD CONSTRAINT presentations_pkey PRIMARY KEY (id);

--
-- Name: rss_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rss_feeds
    ADD CONSTRAINT rss_feeds_pkey PRIMARY KEY (id);


--
-- Name: scotty_dog_sayings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scotty_dog_sayings
    ADD CONSTRAINT scotty_dog_sayings_pkey PRIMARY KEY (id);


--
-- Name: sponsored_project_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sponsored_project_allocations
    ADD CONSTRAINT sponsored_project_allocations_pkey PRIMARY KEY (id);


--
-- Name: sponsored_project_efforts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sponsored_project_efforts
    ADD CONSTRAINT sponsored_project_efforts_pkey PRIMARY KEY (id);


--
-- Name: sponsored_project_sponsors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sponsored_project_sponsors
    ADD CONSTRAINT sponsored_project_sponsors_pkey PRIMARY KEY (id);


--
-- Name: sponsored_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sponsored_projects
    ADD CONSTRAINT sponsored_projects_pkey PRIMARY KEY (id);


--
-- Name: strength_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY strength_themes
    ADD CONSTRAINT strength_themes_pkey PRIMARY KEY (id);


--
-- Name: suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: task_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_types
    ADD CONSTRAINT task_types_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: user_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_versions
    ADD CONSTRAINT user_versions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: by_evaluator_and_presentation; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX by_evaluator_and_presentation ON presentation_feedbacks USING btree (evaluator_id, presentation_id);


--
-- Name: by_feedback_and_question; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX by_feedback_and_question ON presentation_feedback_answers USING btree (feedback_id, question_id);


--
-- Name: index_courses_on_mini; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_on_mini ON courses USING btree (mini);


--
-- Name: index_courses_on_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_on_number ON courses USING btree (number);


--
-- Name: index_courses_on_semester; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_on_semester ON courses USING btree (semester);


--
-- Name: index_courses_on_twiki_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_on_twiki_url ON courses USING btree (twiki_url);


--
-- Name: index_courses_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_on_year ON courses USING btree (year);


--
-- Name: index_courses_people_on_course_id_and_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_courses_people_on_course_id_and_person_id ON faculty_assignments USING btree (course_id, user_id);


--
-- Name: index_curriculum_comments_on_semester; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_curriculum_comments_on_semester ON curriculum_comments USING btree (semester);


--
-- Name: index_curriculum_comments_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_curriculum_comments_on_url ON curriculum_comments USING btree (url);


--
-- Name: index_curriculum_comments_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_curriculum_comments_on_year ON curriculum_comments USING btree (year);


--
-- Name: index_effort_log_line_items_on_effort_log_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_effort_log_line_items_on_effort_log_id ON effort_log_line_items USING btree (effort_log_id);


--
-- Name: index_effort_logs_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_effort_logs_on_person_id ON effort_logs USING btree (user_id);


--
-- Name: index_effort_logs_on_week_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_effort_logs_on_week_number ON effort_logs USING btree (week_number);


--
-- Name: index_faculty_assignments_on_course_id_and_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_faculty_assignments_on_course_id_and_person_id ON faculty_assignments USING btree (course_id, user_id);


--
-- Name: index_individual_contribution_for_courses_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_individual_contribution_for_courses_on_course_id ON individual_contribution_for_courses USING btree (course_id);


--
-- Name: index_individual_contributions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_individual_contributions_on_user_id ON individual_contributions USING btree (user_id);


--
-- Name: index_individual_contributions_on_week_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_individual_contributions_on_week_number ON individual_contributions USING btree (week_number);


--
-- Name: index_individual_contributions_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_individual_contributions_on_year ON individual_contributions USING btree (year);


--
-- Name: index_page_attachments_on_is_active; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_attachments_on_is_active ON page_attachments USING btree (is_active);


--
-- Name: index_page_attachments_on_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_attachments_on_page_id ON page_attachments USING btree (page_id);


--
-- Name: index_page_attachments_on_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_attachments_on_position ON page_attachments USING btree ("position");


--
-- Name: index_page_comments_on_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_comments_on_page_id ON page_comments USING btree (page_id);


--
-- Name: index_page_comments_on_semester; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_comments_on_semester ON page_comments USING btree (semester);


--
-- Name: index_page_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_comments_on_user_id ON page_comments USING btree (user_id);


--
-- Name: index_page_comments_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_comments_on_year ON page_comments USING btree (year);


--
-- Name: index_pages_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_course_id ON pages USING btree (course_id);


--
-- Name: index_pages_on_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_position ON pages USING btree ("position");


--
-- Name: index_pages_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_url ON pages USING btree (url);


--
-- Name: index_peer_evaluation_learning_objectives_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_learning_objectives_on_person_id ON peer_evaluation_learning_objectives USING btree (user_id);


--
-- Name: index_peer_evaluation_learning_objectives_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_learning_objectives_on_team_id ON peer_evaluation_learning_objectives USING btree (team_id);


--
-- Name: index_peer_evaluation_reports_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reports_on_recipient_id ON peer_evaluation_reports USING btree (recipient_id);


--
-- Name: index_peer_evaluation_reports_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reports_on_team_id ON peer_evaluation_reports USING btree (team_id);


--
-- Name: index_peer_evaluation_reviews_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reviews_on_author_id ON peer_evaluation_reviews USING btree (author_id);


--
-- Name: index_peer_evaluation_reviews_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reviews_on_recipient_id ON peer_evaluation_reviews USING btree (recipient_id);


--
-- Name: index_peer_evaluation_reviews_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reviews_on_team_id ON peer_evaluation_reviews USING btree (team_id);


--
-- Name: index_presentations_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_presentations_on_course_id ON presentations USING btree (course_id);


--
-- Name: index_presentations_on_presentation_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_presentations_on_presentation_date ON presentations USING btree (presentation_date);


--
-- Name: index_project_types_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_types_on_name ON project_types USING btree (name);


--
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_name ON projects USING btree (name);


--
-- Name: index_registrations_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_registrations_on_course_id ON registrations USING btree (course_id);


--
-- Name: index_registrations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_registrations_on_user_id ON registrations USING btree (user_id);


--
-- Name: index_scotty_dog_sayings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scotty_dog_sayings_on_user_id ON scotty_dog_sayings USING btree (user_id);


--
-- Name: index_sponsored_project_allocation_on_is_archived; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_allocation_on_is_archived ON sponsored_project_allocations USING btree (is_archived);


--
-- Name: index_sponsored_project_allocation_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_allocation_on_person_id ON sponsored_project_allocations USING btree (user_id);


--
-- Name: index_sponsored_project_allocation_on_sponsored_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_allocation_on_sponsored_project_id ON sponsored_project_allocations USING btree (sponsored_project_id);


--
-- Name: index_sponsored_project_efforts_on_month; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_efforts_on_month ON sponsored_project_efforts USING btree (month);


--
-- Name: index_sponsored_project_efforts_on_sponsored_projects_people_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_efforts_on_sponsored_projects_people_id ON sponsored_project_efforts USING btree (sponsored_project_allocation_id);


--
-- Name: index_sponsored_project_efforts_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_efforts_on_year ON sponsored_project_efforts USING btree (year);


--
-- Name: index_sponsored_project_sponsors_on_is_archived; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_sponsors_on_is_archived ON sponsored_project_sponsors USING btree (is_archived);


--
-- Name: index_sponsored_project_sponsors_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_project_sponsors_on_name ON sponsored_project_sponsors USING btree (name);


--
-- Name: index_sponsored_projects_on_is_archived; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_projects_on_is_archived ON sponsored_projects USING btree (is_archived);


--
-- Name: index_sponsored_projects_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_projects_on_name ON sponsored_projects USING btree (name);


--
-- Name: index_sponsored_projects_on_sponsor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sponsored_projects_on_sponsor_id ON sponsored_projects USING btree (sponsor_id);


--
-- Name: index_suggestions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suggestions_on_user_id ON suggestions USING btree (user_id);


--
-- Name: index_teams_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_course_id ON teams USING btree (course_id);


--
-- Name: index_teams_people_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_people_on_person_id ON team_assignments USING btree (user_id);


--
-- Name: index_teams_people_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_people_on_team_id ON team_assignments USING btree (team_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_expires_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_expires_at ON users USING btree (expires_at);


--
-- Name: index_users_on_human_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_human_name ON users USING btree (human_name);


--
-- Name: index_users_on_is_active; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_is_active ON users USING btree (is_active);


--
-- Name: index_users_on_is_staff; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_is_staff ON users USING btree (is_staff);


--
-- Name: index_users_on_is_student; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_is_student ON users USING btree (is_student);


--
-- Name: index_users_on_twiki_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_twiki_name ON users USING btree (twiki_name);


--
-- Name: index_versions_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_created_at ON versions USING btree (created_at);


--
-- Name: index_versions_on_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_number ON versions USING btree (number);


--
-- Name: index_versions_on_tag; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_tag ON versions USING btree (tag);


--
-- Name: index_versions_on_user_id_and_user_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_user_id_and_user_type ON versions USING btree (user_id, user_type);


--
-- Name: index_versions_on_user_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_user_name ON versions USING btree (user_name);


--
-- Name: index_versions_on_versioned_id_and_versioned_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_versioned_id_and_versioned_type ON versions USING btree (versioned_id, versioned_type);


--
-- Name: individual_contribution_for_courses_icid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_contribution_for_courses_icid ON individual_contribution_for_courses USING btree (individual_contribution_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120801031314');

INSERT INTO schema_migrations (version) VALUES ('20080619210409');

INSERT INTO schema_migrations (version) VALUES ('20080619231121');

INSERT INTO schema_migrations (version) VALUES ('20080620055755');

INSERT INTO schema_migrations (version) VALUES ('20080620230317');

INSERT INTO schema_migrations (version) VALUES ('20080621053841');

INSERT INTO schema_migrations (version) VALUES ('20080702065419');

INSERT INTO schema_migrations (version) VALUES ('20080702065841');

INSERT INTO schema_migrations (version) VALUES ('20080705060349');

INSERT INTO schema_migrations (version) VALUES ('20080710061149');

INSERT INTO schema_migrations (version) VALUES ('20080918031633');

INSERT INTO schema_migrations (version) VALUES ('20080918155019');

INSERT INTO schema_migrations (version) VALUES ('20081206043725');

INSERT INTO schema_migrations (version) VALUES ('20090117020407');

INSERT INTO schema_migrations (version) VALUES ('20090128165146');

INSERT INTO schema_migrations (version) VALUES ('20090128165815');

INSERT INTO schema_migrations (version) VALUES ('20090129030553');

INSERT INTO schema_migrations (version) VALUES ('20090520053255');

INSERT INTO schema_migrations (version) VALUES ('20090522175603');

INSERT INTO schema_migrations (version) VALUES ('20090625062816');

INSERT INTO schema_migrations (version) VALUES ('20090625180932');

INSERT INTO schema_migrations (version) VALUES ('20090626052444');

INSERT INTO schema_migrations (version) VALUES ('20090627000346');

INSERT INTO schema_migrations (version) VALUES ('20090714054637');

INSERT INTO schema_migrations (version) VALUES ('20090814053856');

INSERT INTO schema_migrations (version) VALUES ('20090831225506');

INSERT INTO schema_migrations (version) VALUES ('20090905194058');

INSERT INTO schema_migrations (version) VALUES ('20090911193220');

INSERT INTO schema_migrations (version) VALUES ('20090918054335');

INSERT INTO schema_migrations (version) VALUES ('20090918054408');

INSERT INTO schema_migrations (version) VALUES ('20091009011526');

INSERT INTO schema_migrations (version) VALUES ('20091014030813');

INSERT INTO schema_migrations (version) VALUES ('20091029034539');

INSERT INTO schema_migrations (version) VALUES ('20091029195049');

INSERT INTO schema_migrations (version) VALUES ('20091101050251');

INSERT INTO schema_migrations (version) VALUES ('20091204055443');

INSERT INTO schema_migrations (version) VALUES ('20091218075515');

INSERT INTO schema_migrations (version) VALUES ('20091218075543');

INSERT INTO schema_migrations (version) VALUES ('20091218075744');

INSERT INTO schema_migrations (version) VALUES ('20100109054757');

INSERT INTO schema_migrations (version) VALUES ('20100121005745');

INSERT INTO schema_migrations (version) VALUES ('20100202055949');

INSERT INTO schema_migrations (version) VALUES ('20100218185703');

INSERT INTO schema_migrations (version) VALUES ('20100322050123');

INSERT INTO schema_migrations (version) VALUES ('20100324050647');

INSERT INTO schema_migrations (version) VALUES ('20100407234731');

INSERT INTO schema_migrations (version) VALUES ('20100408233625');

INSERT INTO schema_migrations (version) VALUES ('20100415201031');

INSERT INTO schema_migrations (version) VALUES ('20100504234457');

INSERT INTO schema_migrations (version) VALUES ('20100520212356');

INSERT INTO schema_migrations (version) VALUES ('20100610002054');

INSERT INTO schema_migrations (version) VALUES ('20100619210535');

INSERT INTO schema_migrations (version) VALUES ('20100622002054');

INSERT INTO schema_migrations (version) VALUES ('20100702044644');

INSERT INTO schema_migrations (version) VALUES ('20100715161725');

INSERT INTO schema_migrations (version) VALUES ('20100904211437');

INSERT INTO schema_migrations (version) VALUES ('20100930025344');

INSERT INTO schema_migrations (version) VALUES ('20101103222410');

INSERT INTO schema_migrations (version) VALUES ('20101105215911');

INSERT INTO schema_migrations (version) VALUES ('20101107103529');

INSERT INTO schema_migrations (version) VALUES ('20101114062958');

INSERT INTO schema_migrations (version) VALUES ('20101116234544');

INSERT INTO schema_migrations (version) VALUES ('20101119000356');

INSERT INTO schema_migrations (version) VALUES ('20101130011634');

INSERT INTO schema_migrations (version) VALUES ('20101214193111');

INSERT INTO schema_migrations (version) VALUES ('20101214220304');

INSERT INTO schema_migrations (version) VALUES ('20110107054904');

INSERT INTO schema_migrations (version) VALUES ('20110118183803');

INSERT INTO schema_migrations (version) VALUES ('20110208184400');

INSERT INTO schema_migrations (version) VALUES ('20110208185917');

INSERT INTO schema_migrations (version) VALUES ('20110208194827');

INSERT INTO schema_migrations (version) VALUES ('20110211174453');

INSERT INTO schema_migrations (version) VALUES ('20110221012656');

INSERT INTO schema_migrations (version) VALUES ('20110225193907');

INSERT INTO schema_migrations (version) VALUES ('20110308175158');

INSERT INTO schema_migrations (version) VALUES ('20110311170137');

INSERT INTO schema_migrations (version) VALUES ('20110312060145');

INSERT INTO schema_migrations (version) VALUES ('20110317211513');

INSERT INTO schema_migrations (version) VALUES ('20110322233953');

INSERT INTO schema_migrations (version) VALUES ('20110325232412');

INSERT INTO schema_migrations (version) VALUES ('20110405202241');

INSERT INTO schema_migrations (version) VALUES ('20110411233106');

INSERT INTO schema_migrations (version) VALUES ('20110504032301');

INSERT INTO schema_migrations (version) VALUES ('20110510175618');

INSERT INTO schema_migrations (version) VALUES ('20110701042144');

INSERT INTO schema_migrations (version) VALUES ('20110706025043');

INSERT INTO schema_migrations (version) VALUES ('20110722213358');

INSERT INTO schema_migrations (version) VALUES ('20110731155739');

INSERT INTO schema_migrations (version) VALUES ('20110825021209');

INSERT INTO schema_migrations (version) VALUES ('20110906021103');

INSERT INTO schema_migrations (version) VALUES ('20110919204537');

INSERT INTO schema_migrations (version) VALUES ('20111104210105');

INSERT INTO schema_migrations (version) VALUES ('20111106053221');

INSERT INTO schema_migrations (version) VALUES ('20111109050657');

INSERT INTO schema_migrations (version) VALUES ('20111117013039');

INSERT INTO schema_migrations (version) VALUES ('20111117212432');

INSERT INTO schema_migrations (version) VALUES ('20120129043856');

INSERT INTO schema_migrations (version) VALUES ('20120223224138');

INSERT INTO schema_migrations (version) VALUES ('20120308205647');

INSERT INTO schema_migrations (version) VALUES ('20120326061853');

INSERT INTO schema_migrations (version) VALUES ('20120510050900');

INSERT INTO schema_migrations (version) VALUES ('20120518003101');

INSERT INTO schema_migrations (version) VALUES ('20120706232203');

INSERT INTO schema_migrations (version) VALUES ('20120718230225');

INSERT INTO schema_migrations (version) VALUES ('20120718230557');

INSERT INTO schema_migrations (version) VALUES ('20120726001651');

INSERT INTO schema_migrations (version) VALUES ('20121011010839');

INSERT INTO schema_migrations (version) VALUES ('20121030220552');

INSERT INTO schema_migrations (version) VALUES ('20121122012339');

INSERT INTO schema_migrations (version) VALUES ('20121129012328');

INSERT INTO schema_migrations (version) VALUES ('20121129012448');