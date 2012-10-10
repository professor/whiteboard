--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: course_numbers; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE course_numbers (
    id integer NOT NULL,
    name character varying(255),
    number character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    short_name character varying(255)
);


ALTER TABLE public.course_numbers OWNER TO clydeli;

--
-- Name: course_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE course_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_numbers_id_seq OWNER TO clydeli;

--
-- Name: course_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE course_numbers_id_seq OWNED BY course_numbers.id;


--
-- Name: course_numbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('course_numbers_id_seq', 1, false);


--
-- Name: courses; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.courses OWNER TO clydeli;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_id_seq OWNER TO clydeli;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('courses_id_seq', 1, true);


--
-- Name: courses_users; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE courses_users (
    course_id integer,
    user_id integer
);


ALTER TABLE public.courses_users OWNER TO clydeli;

--
-- Name: curriculum_comment_types; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE curriculum_comment_types (
    id integer NOT NULL,
    name character varying(255),
    background_color character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.curriculum_comment_types OWNER TO clydeli;

--
-- Name: curriculum_comment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE curriculum_comment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curriculum_comment_types_id_seq OWNER TO clydeli;

--
-- Name: curriculum_comment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE curriculum_comment_types_id_seq OWNED BY curriculum_comment_types.id;


--
-- Name: curriculum_comment_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('curriculum_comment_types_id_seq', 1, false);


--
-- Name: curriculum_comments; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.curriculum_comments OWNER TO clydeli;

--
-- Name: curriculum_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE curriculum_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curriculum_comments_id_seq OWNER TO clydeli;

--
-- Name: curriculum_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE curriculum_comments_id_seq OWNED BY curriculum_comments.id;


--
-- Name: curriculum_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('curriculum_comments_id_seq', 1, false);


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.delayed_jobs OWNER TO clydeli;

--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delayed_jobs_id_seq OWNER TO clydeli;

--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('delayed_jobs_id_seq', 3, true);


--
-- Name: deliverable_attachment_versions; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.deliverable_attachment_versions OWNER TO clydeli;

--
-- Name: deliverable_attachment_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE deliverable_attachment_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverable_attachment_versions_id_seq OWNER TO clydeli;

--
-- Name: deliverable_attachment_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE deliverable_attachment_versions_id_seq OWNED BY deliverable_attachment_versions.id;


--
-- Name: deliverable_attachment_versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('deliverable_attachment_versions_id_seq', 1, false);


--
-- Name: deliverables; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.deliverables OWNER TO clydeli;

--
-- Name: deliverables_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE deliverables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverables_id_seq OWNER TO clydeli;

--
-- Name: deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE deliverables_id_seq OWNED BY deliverables.id;


--
-- Name: deliverables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('deliverables_id_seq', 1, false);


--
-- Name: effort_log_line_items; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.effort_log_line_items OWNER TO clydeli;

--
-- Name: effort_log_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE effort_log_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.effort_log_line_items_id_seq OWNER TO clydeli;

--
-- Name: effort_log_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE effort_log_line_items_id_seq OWNED BY effort_log_line_items.id;


--
-- Name: effort_log_line_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('effort_log_line_items_id_seq', 1, false);


--
-- Name: effort_logs; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.effort_logs OWNER TO clydeli;

--
-- Name: effort_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE effort_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.effort_logs_id_seq OWNER TO clydeli;

--
-- Name: effort_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE effort_logs_id_seq OWNED BY effort_logs.id;


--
-- Name: effort_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('effort_logs_id_seq', 1, false);


--
-- Name: faculty_assignments; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE faculty_assignments (
    course_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.faculty_assignments OWNER TO clydeli;

--
-- Name: individual_contribution_for_courses; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.individual_contribution_for_courses OWNER TO clydeli;

--
-- Name: individual_contribution_for_courses_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE individual_contribution_for_courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.individual_contribution_for_courses_id_seq OWNER TO clydeli;

--
-- Name: individual_contribution_for_courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE individual_contribution_for_courses_id_seq OWNED BY individual_contribution_for_courses.id;


--
-- Name: individual_contribution_for_courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('individual_contribution_for_courses_id_seq', 1, false);


--
-- Name: individual_contributions; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE individual_contributions (
    id integer NOT NULL,
    user_id integer,
    year integer,
    week_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.individual_contributions OWNER TO clydeli;

--
-- Name: individual_contributions_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE individual_contributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.individual_contributions_id_seq OWNER TO clydeli;

--
-- Name: individual_contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE individual_contributions_id_seq OWNED BY individual_contributions.id;


--
-- Name: individual_contributions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('individual_contributions_id_seq', 1, false);


--
-- Name: page_attachments; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.page_attachments OWNER TO clydeli;

--
-- Name: page_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE page_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_attachments_id_seq OWNER TO clydeli;

--
-- Name: page_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE page_attachments_id_seq OWNED BY page_attachments.id;


--
-- Name: page_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('page_attachments_id_seq', 1, false);


--
-- Name: page_comment_types; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE page_comment_types (
    id integer NOT NULL,
    name character varying(255),
    background_color character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.page_comment_types OWNER TO clydeli;

--
-- Name: page_comment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE page_comment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_comment_types_id_seq OWNER TO clydeli;

--
-- Name: page_comment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE page_comment_types_id_seq OWNED BY page_comment_types.id;


--
-- Name: page_comment_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('page_comment_types_id_seq', 1, false);


--
-- Name: page_comments; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.page_comments OWNER TO clydeli;

--
-- Name: page_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE page_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_comments_id_seq OWNER TO clydeli;

--
-- Name: page_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE page_comments_id_seq OWNED BY page_comments.id;


--
-- Name: page_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('page_comments_id_seq', 1, false);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.pages OWNER TO clydeli;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_id_seq OWNER TO clydeli;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('pages_id_seq', 1, false);


--
-- Name: peer_evaluation_learning_objectives; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE peer_evaluation_learning_objectives (
    id integer NOT NULL,
    user_id integer,
    team_id integer,
    learning_objective character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.peer_evaluation_learning_objectives OWNER TO clydeli;

--
-- Name: peer_evaluation_learning_objectives_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE peer_evaluation_learning_objectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.peer_evaluation_learning_objectives_id_seq OWNER TO clydeli;

--
-- Name: peer_evaluation_learning_objectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE peer_evaluation_learning_objectives_id_seq OWNED BY peer_evaluation_learning_objectives.id;


--
-- Name: peer_evaluation_learning_objectives_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('peer_evaluation_learning_objectives_id_seq', 1, false);


--
-- Name: peer_evaluation_reports; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.peer_evaluation_reports OWNER TO clydeli;

--
-- Name: peer_evaluation_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE peer_evaluation_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.peer_evaluation_reports_id_seq OWNER TO clydeli;

--
-- Name: peer_evaluation_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE peer_evaluation_reports_id_seq OWNED BY peer_evaluation_reports.id;


--
-- Name: peer_evaluation_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('peer_evaluation_reports_id_seq', 1, false);


--
-- Name: peer_evaluation_reviews; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.peer_evaluation_reviews OWNER TO clydeli;

--
-- Name: peer_evaluation_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE peer_evaluation_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.peer_evaluation_reviews_id_seq OWNER TO clydeli;

--
-- Name: peer_evaluation_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE peer_evaluation_reviews_id_seq OWNED BY peer_evaluation_reviews.id;


--
-- Name: peer_evaluation_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('peer_evaluation_reviews_id_seq', 1, false);


--
-- Name: presentation_feedback_answers; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.presentation_feedback_answers OWNER TO clydeli;

--
-- Name: presentation_feedback_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE presentation_feedback_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.presentation_feedback_answers_id_seq OWNER TO clydeli;

--
-- Name: presentation_feedback_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE presentation_feedback_answers_id_seq OWNED BY presentation_feedback_answers.id;


--
-- Name: presentation_feedback_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('presentation_feedback_answers_id_seq', 1, false);


--
-- Name: presentation_feedbacks; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE presentation_feedbacks (
    id integer NOT NULL,
    evaluator_id integer,
    presentation_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.presentation_feedbacks OWNER TO clydeli;

--
-- Name: presentation_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE presentation_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.presentation_feedbacks_id_seq OWNER TO clydeli;

--
-- Name: presentation_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE presentation_feedbacks_id_seq OWNED BY presentation_feedbacks.id;


--
-- Name: presentation_feedbacks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('presentation_feedbacks_id_seq', 1, false);


--
-- Name: presentation_questions; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE presentation_questions (
    id integer NOT NULL,
    label character varying(255),
    text text,
    deleted boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.presentation_questions OWNER TO clydeli;

--
-- Name: presentation_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE presentation_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.presentation_questions_id_seq OWNER TO clydeli;

--
-- Name: presentation_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE presentation_questions_id_seq OWNED BY presentation_questions.id;


--
-- Name: presentation_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('presentation_questions_id_seq', 4, true);


--
-- Name: presentations; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.presentations OWNER TO clydeli;

--
-- Name: presentations_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE presentations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.presentations_id_seq OWNER TO clydeli;

--
-- Name: presentations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE presentations_id_seq OWNED BY presentations.id;


--
-- Name: presentations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('presentations_id_seq', 1, false);


--
-- Name: project_types; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE project_types (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.project_types OWNER TO clydeli;

--
-- Name: project_types_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE project_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_types_id_seq OWNER TO clydeli;

--
-- Name: project_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE project_types_id_seq OWNED BY project_types.id;


--
-- Name: project_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('project_types_id_seq', 1, false);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying(255),
    project_type_id integer,
    course_id integer,
    is_closed boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.projects OWNER TO clydeli;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO clydeli;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('projects_id_seq', 1, false);


--
-- Name: registrations; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE registrations (
    course_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.registrations OWNER TO clydeli;

--
-- Name: rss_feeds; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.rss_feeds OWNER TO clydeli;

--
-- Name: rss_feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE rss_feeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rss_feeds_id_seq OWNER TO clydeli;

--
-- Name: rss_feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE rss_feeds_id_seq OWNED BY rss_feeds.id;


--
-- Name: rss_feeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('rss_feeds_id_seq', 1, false);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO clydeli;

--
-- Name: scotty_dog_sayings; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE scotty_dog_sayings (
    id integer NOT NULL,
    saying text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.scotty_dog_sayings OWNER TO clydeli;

--
-- Name: scotty_dog_sayings_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE scotty_dog_sayings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scotty_dog_sayings_id_seq OWNER TO clydeli;

--
-- Name: scotty_dog_sayings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE scotty_dog_sayings_id_seq OWNED BY scotty_dog_sayings.id;


--
-- Name: scotty_dog_sayings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('scotty_dog_sayings_id_seq', 1, false);


--
-- Name: sponsored_project_allocations; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.sponsored_project_allocations OWNER TO clydeli;

--
-- Name: sponsored_project_allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE sponsored_project_allocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sponsored_project_allocations_id_seq OWNER TO clydeli;

--
-- Name: sponsored_project_allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE sponsored_project_allocations_id_seq OWNED BY sponsored_project_allocations.id;


--
-- Name: sponsored_project_allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('sponsored_project_allocations_id_seq', 1, false);


--
-- Name: sponsored_project_efforts; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.sponsored_project_efforts OWNER TO clydeli;

--
-- Name: sponsored_project_efforts_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE sponsored_project_efforts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sponsored_project_efforts_id_seq OWNER TO clydeli;

--
-- Name: sponsored_project_efforts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE sponsored_project_efforts_id_seq OWNED BY sponsored_project_efforts.id;


--
-- Name: sponsored_project_efforts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('sponsored_project_efforts_id_seq', 1, false);


--
-- Name: sponsored_project_sponsors; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE sponsored_project_sponsors (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_archived boolean DEFAULT false
);


ALTER TABLE public.sponsored_project_sponsors OWNER TO clydeli;

--
-- Name: sponsored_project_sponsors_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE sponsored_project_sponsors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sponsored_project_sponsors_id_seq OWNER TO clydeli;

--
-- Name: sponsored_project_sponsors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE sponsored_project_sponsors_id_seq OWNED BY sponsored_project_sponsors.id;


--
-- Name: sponsored_project_sponsors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('sponsored_project_sponsors_id_seq', 1, false);


--
-- Name: sponsored_projects; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE sponsored_projects (
    id integer NOT NULL,
    name character varying(255),
    sponsor_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_archived boolean DEFAULT false
);


ALTER TABLE public.sponsored_projects OWNER TO clydeli;

--
-- Name: sponsored_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE sponsored_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sponsored_projects_id_seq OWNER TO clydeli;

--
-- Name: sponsored_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE sponsored_projects_id_seq OWNED BY sponsored_projects.id;


--
-- Name: sponsored_projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('sponsored_projects_id_seq', 1, false);


--
-- Name: strength_themes; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE strength_themes (
    id integer NOT NULL,
    theme character varying(255),
    brief_description character varying(255),
    long_description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.strength_themes OWNER TO clydeli;

--
-- Name: strength_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE strength_themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strength_themes_id_seq OWNER TO clydeli;

--
-- Name: strength_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE strength_themes_id_seq OWNED BY strength_themes.id;


--
-- Name: strength_themes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('strength_themes_id_seq', 34, true);


--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.suggestions OWNER TO clydeli;

--
-- Name: suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suggestions_id_seq OWNER TO clydeli;

--
-- Name: suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE suggestions_id_seq OWNED BY suggestions.id;


--
-- Name: suggestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('suggestions_id_seq', 1, false);


--
-- Name: task_types; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.task_types OWNER TO clydeli;

--
-- Name: task_types_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE task_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_types_id_seq OWNER TO clydeli;

--
-- Name: task_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE task_types_id_seq OWNED BY task_types.id;


--
-- Name: task_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('task_types_id_seq', 4, true);


--
-- Name: team_assignments; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE TABLE team_assignments (
    team_id integer,
    user_id integer
);


ALTER TABLE public.team_assignments OWNER TO clydeli;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.teams OWNER TO clydeli;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO clydeli;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('teams_id_seq', 1, true);


--
-- Name: user_versions; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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
    course_index_view character varying(255)
);


ALTER TABLE public.user_versions OWNER TO clydeli;

--
-- Name: user_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE user_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_versions_id_seq OWNER TO clydeli;

--
-- Name: user_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE user_versions_id_seq OWNED BY user_versions.id;


--
-- Name: user_versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('user_versions_id_seq', 18, true);


--
-- Name: users; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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
    course_index_view character varying(255)
);


ALTER TABLE public.users OWNER TO clydeli;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO clydeli;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('users_id_seq', 6, true);


--
-- Name: versions; Type: TABLE; Schema: public; Owner: clydeli; Tablespace: 
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


ALTER TABLE public.versions OWNER TO clydeli;

--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: clydeli
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versions_id_seq OWNER TO clydeli;

--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clydeli
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clydeli
--

SELECT pg_catalog.setval('versions_id_seq', 1, false);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY course_numbers ALTER COLUMN id SET DEFAULT nextval('course_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY curriculum_comment_types ALTER COLUMN id SET DEFAULT nextval('curriculum_comment_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY curriculum_comments ALTER COLUMN id SET DEFAULT nextval('curriculum_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY deliverable_attachment_versions ALTER COLUMN id SET DEFAULT nextval('deliverable_attachment_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY deliverables ALTER COLUMN id SET DEFAULT nextval('deliverables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY effort_log_line_items ALTER COLUMN id SET DEFAULT nextval('effort_log_line_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY effort_logs ALTER COLUMN id SET DEFAULT nextval('effort_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY individual_contribution_for_courses ALTER COLUMN id SET DEFAULT nextval('individual_contribution_for_courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY individual_contributions ALTER COLUMN id SET DEFAULT nextval('individual_contributions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY page_attachments ALTER COLUMN id SET DEFAULT nextval('page_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY page_comment_types ALTER COLUMN id SET DEFAULT nextval('page_comment_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY page_comments ALTER COLUMN id SET DEFAULT nextval('page_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY peer_evaluation_learning_objectives ALTER COLUMN id SET DEFAULT nextval('peer_evaluation_learning_objectives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY peer_evaluation_reports ALTER COLUMN id SET DEFAULT nextval('peer_evaluation_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY peer_evaluation_reviews ALTER COLUMN id SET DEFAULT nextval('peer_evaluation_reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY presentation_feedback_answers ALTER COLUMN id SET DEFAULT nextval('presentation_feedback_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY presentation_feedbacks ALTER COLUMN id SET DEFAULT nextval('presentation_feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY presentation_questions ALTER COLUMN id SET DEFAULT nextval('presentation_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY presentations ALTER COLUMN id SET DEFAULT nextval('presentations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY project_types ALTER COLUMN id SET DEFAULT nextval('project_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY rss_feeds ALTER COLUMN id SET DEFAULT nextval('rss_feeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY scotty_dog_sayings ALTER COLUMN id SET DEFAULT nextval('scotty_dog_sayings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY sponsored_project_allocations ALTER COLUMN id SET DEFAULT nextval('sponsored_project_allocations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY sponsored_project_efforts ALTER COLUMN id SET DEFAULT nextval('sponsored_project_efforts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY sponsored_project_sponsors ALTER COLUMN id SET DEFAULT nextval('sponsored_project_sponsors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY sponsored_projects ALTER COLUMN id SET DEFAULT nextval('sponsored_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY strength_themes ALTER COLUMN id SET DEFAULT nextval('strength_themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY suggestions ALTER COLUMN id SET DEFAULT nextval('suggestions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY task_types ALTER COLUMN id SET DEFAULT nextval('task_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY user_versions ALTER COLUMN id SET DEFAULT nextval('user_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: clydeli
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Data for Name: course_numbers; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY course_numbers (id, name, number, created_at, updated_at, short_name) FROM stdin;
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY courses (id, course_number_id, name, number, semester, mini, created_at, updated_at, primary_faculty_label, secondary_faculty_label, twiki_url, remind_about_effort, short_name, year, configure_class_mailinglist, peer_evaluation_first_email, peer_evaluation_second_email, configure_teams_name_themselves, curriculum_url, configure_course_twiki, is_configured, updated_by_user_id, configured_by_user_id, updating_email, email) FROM stdin;
1	\N	Metrics for Software Engineers	96-700	Fall	Both	2012-09-28 21:39:40.394997	2012-09-28 21:39:40.394997	\N	\N	\N	\N	MfSE	2012	f	\N	\N	t	\N	f	f	10	\N	t	fall-2012-mfse@sandbox.sv.cmu.edu
\.


--
-- Data for Name: courses_users; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY courses_users (course_id, user_id) FROM stdin;
\.


--
-- Data for Name: curriculum_comment_types; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY curriculum_comment_types (id, name, background_color, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: curriculum_comments; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY curriculum_comments (id, url, semester, year, user_id, curriculum_comment_type_id, comment, created_at, updated_at, human_name, notify_me) FROM stdin;
\.


--
-- Data for Name: delayed_jobs; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY delayed_jobs (id, priority, attempts, handler, last_error, run_at, locked_at, failed_at, locked_by, created_at, updated_at) FROM stdin;
1	0	0	--- !ruby/struct:GoogleMailingListJob \nnew_distribution_list: fall-2012-mfse@sandbox.sv.cmu.edu\nold_distribution_list: fall-2012-mfse@sandbox.sv.cmu.edu\nemails_array: []\n\nname: fall-2012-mfse@sandbox.sv.cmu.edu\ndescription: Course distribution list\nmodel_id: 1\ntable_name: courses\n	\N	2012-09-28 21:39:40.580229	\N	\N	\N	2012-09-28 21:39:40.580387	2012-09-28 21:39:40.580387
2	0	0	--- !ruby/struct:GoogleMailingListJob \nnew_distribution_list: fall-2012-team-terrific@sandbox.sv.cmu.edu\nold_distribution_list: \nemails_array: []\n\nname: Team Terrific\ndescription: Team Terrific for course Metrics for Software Engineers\nmodel_id: 1\ntable_name: teams\n	\N	2012-09-28 21:39:40.632549	\N	\N	\N	2012-09-28 21:39:40.633386	2012-09-28 21:39:40.633386
3	0	0	--- !ruby/struct:GoogleMailingListJob \nnew_distribution_list: fall-2012-mfse@sandbox.sv.cmu.edu\nold_distribution_list: fall-2012-mfse@sandbox.sv.cmu.edu\nemails_array: []\n\nname: fall-2012-mfse@sandbox.sv.cmu.edu\ndescription: Course distribution list\nmodel_id: 1\ntable_name: courses\n	\N	2012-09-28 21:39:40.636818	\N	\N	\N	2012-09-28 21:39:40.636918	2012-09-28 21:39:40.636918
\.


--
-- Data for Name: deliverable_attachment_versions; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY deliverable_attachment_versions (id, deliverable_id, submitter_id, submission_date, attachment_file_name, attachment_content_type, attachment_file_size, comment) FROM stdin;
\.


--
-- Data for Name: deliverables; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY deliverables (id, name, team_id, course_id, task_number, creator_id, created_at, updated_at, feedback_comment, feedback_file_name, feedback_content_type, feedback_file_size, feedback_updated_at) FROM stdin;
\.


--
-- Data for Name: effort_log_line_items; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY effort_log_line_items (id, effort_log_id, course_id, task_type_id, day1, day2, day3, day4, day5, day6, day7, sum, created_at, updated_at, "position") FROM stdin;
\.


--
-- Data for Name: effort_logs; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY effort_logs (id, user_id, week_number, year, created_at, updated_at, sum) FROM stdin;
\.


--
-- Data for Name: faculty_assignments; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY faculty_assignments (course_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: individual_contribution_for_courses; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY individual_contribution_for_courses (id, individual_contribution_id, course_id, answer1, answer2, answer3, answer4, answer5) FROM stdin;
\.


--
-- Data for Name: individual_contributions; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY individual_contributions (id, user_id, year, week_number, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: page_attachments; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY page_attachments (id, page_id, user_id, "position", is_active, readable_name, page_attachment_file_name, page_attachment_content_type, page_attachment_file_size, page_attachment_updated_at) FROM stdin;
\.


--
-- Data for Name: page_comment_types; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY page_comment_types (id, name, background_color, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: page_comments; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY page_comments (id, user_id, page_id, page_comment_type_id, comment, notify_me, display_name, semester, year, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY pages (id, course_id, title, "position", indentation_level, is_task, tab_one_contents, tab_two_contents, tab_three_contents, task_duration, tab_one_email_from, tab_one_email_subject, created_at, updated_at, tips_and_traps, readings_and_resources, faculty_notes, updated_by_user_id, version, version_comments, url, is_editable_by_all, is_duplicated_page, is_viewable_by_all) FROM stdin;
\.


--
-- Data for Name: peer_evaluation_learning_objectives; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY peer_evaluation_learning_objectives (id, user_id, team_id, learning_objective, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: peer_evaluation_reports; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY peer_evaluation_reports (id, team_id, recipient_id, feedback, email_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: peer_evaluation_reviews; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY peer_evaluation_reviews (id, team_id, author_id, recipient_id, question, answer, sequence_number, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: presentation_feedback_answers; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY presentation_feedback_answers (id, feedback_id, question_id, rating, comment, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: presentation_feedbacks; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY presentation_feedbacks (id, evaluator_id, presentation_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: presentation_questions; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY presentation_questions (id, label, text, deleted, created_at, updated_at) FROM stdin;
1	Content	Did the talk cover all the content suggested on the checklist? (ie goals, progress, and the process for achieving the goals, outcomes)	f	2012-09-28 21:39:40.868715	2012-09-28 21:39:40.868715
2	Organization	How logical was the organization? How smooth were transactions between points and parts of the talk?  Was the talk focused? To the point?  Were the main points clearly stated? easy to find?	f	2012-09-28 21:39:40.876119	2012-09-28 21:39:40.876119
3	Visuals	Were they well-designed? Were all of them readable? Were they helpful? Were they manipulated well?	f	2012-09-28 21:39:40.880614	2012-09-28 21:39:40.880614
4	Delivery	Bodily delivery: (eye-contact, gestures, energy)    Vocal delivery: (loudness, rate, articulation) Question handling (poise, tact, team support; did the team answer the question asked?)	f	2012-09-28 21:39:40.884477	2012-09-28 21:39:40.884477
\.


--
-- Data for Name: presentations; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY presentations (id, name, description, team_id, course_id, task_number, creator_id, presentation_date, user_id, feedback_email_sent, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: project_types; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY project_types (id, name, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY projects (id, name, project_type_id, course_id, is_closed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: registrations; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY registrations (course_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: rss_feeds; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY rss_feeds (id, title, link, publication_date, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY schema_migrations (version) FROM stdin;
20120801031314
20110722213358
20100324050647
20090714054637
20110107054904
20120510050900
20090128165815
20080918031633
20110825021209
20080702065419
20110311170137
20110118183803
20100504234457
20120518003101
20090129030553
20110221012656
20090831225506
20090625062816
20080702065841
20101107103529
20110211174453
20111117013039
20100415201031
20091218075543
20091009011526
20120718230557
20120718230225
20110308175158
20120308205647
20100622002054
20080705060349
20111104210105
20101114062958
20100715161725
20100202055949
20090520053255
20091029195049
20120726001651
20110706025043
20100407234731
20090625180932
20110906021103
20120223224138
20090918054335
20100702044644
20120326061853
20090128165146
20110405202241
20120129043856
20101214220304
20091218075744
20101116234544
20080621053841
20080918155019
20090117020407
20111109050657
20101214193111
20101103222410
20110701042144
20110322233953
20090911193220
20120706232203
20090814053856
20100109054757
20110208184400
20111117212432
20101130011634
20090918054408
20110731155739
20091101050251
20081206043725
20101105215911
20100218185703
20100619210535
20091204055443
20101119000356
20110312060145
20110317211513
20100121005745
20080620230317
20111106053221
20080620055755
20080710061149
20090905194058
20110504032301
20110208185917
20091014030813
20100520212356
20091029034539
20100408233625
20080619210409
20110510175618
20110919204537
20110411233106
20090627000346
20090626052444
20100610002054
20100904211437
20091218075515
20090522175603
20110225193907
20100322050123
20080619231121
20110325232412
20100930025344
20110208194827
\.


--
-- Data for Name: scotty_dog_sayings; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY scotty_dog_sayings (id, saying, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sponsored_project_allocations; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY sponsored_project_allocations (id, sponsored_project_id, user_id, current_allocation, created_at, updated_at, is_archived) FROM stdin;
\.


--
-- Data for Name: sponsored_project_efforts; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY sponsored_project_efforts (id, sponsored_project_allocation_id, year, month, actual_allocation, current_allocation, confirmed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sponsored_project_sponsors; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY sponsored_project_sponsors (id, name, created_at, updated_at, is_archived) FROM stdin;
\.


--
-- Data for Name: sponsored_projects; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY sponsored_projects (id, name, sponsor_id, created_at, updated_at, is_archived) FROM stdin;
\.


--
-- Data for Name: strength_themes; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY strength_themes (id, theme, brief_description, long_description, created_at, updated_at) FROM stdin;
1	Achiever	People who are especially talented in the Achiever theme have a great deal of stamina and work hard. They take great satisfaction from being busy and productive.	Your Achiever theme helps explain your drive. Achiever describes a constant need for achievement. You feel as if every day starts at zero. By the end of the day you must achieve something tangible in order to feel good about yourself. And by “every day” you mean every single day — workdays, weekends, vacations. No matter how much you may feel you deserve a day of rest, if the day passes without some form of achievement, no matter how small, you will feel dissatisfied. You have an internal fire burning inside you. It pushes you to do more, to achieve more. After each accomplishment is reached, the fire dwindles for a moment, but very soon it rekindles itself, forcing you toward the next accomplishment. Your relentless need for achievement might not be logical. It might not even be focused. But it will always be with you. As an Achiever you must learn to live with this whisper of discontent. It does have its benefits. It brings you the energy you need to work long hours without burning out. It is the jolt you can always count on to get you started on new tasks, new challenges. It is the power supply that causes you to set the pace and define the levels of productivity for your work group. It is the theme that keeps you moving.	2012-09-28 21:39:39.69109	2012-09-28 21:39:39.69109
2	Activator	People who are especially talented in the Activator theme can make things happen by turning thoughts into action. They are often impatient.	“When can we start?“ This is a recurring question in your life. You are impatient for action. You may concede that analysis has its uses or that debate and discussion can occasionally yield some valuable insights, but deep down you know that only action is real. Only action can make things happen. Only action leads to performance. Once a decision is made, you cannot not act. Others may worry that “there are still some things we don’t know,” but this doesn’t seem to slow you. If the decision has been made to go across town, you know that the fastest way to get there is to go stoplight to stoplight. You are not going to sit around waiting until all the lights have turned green. Besides, in your view, action and thinking are not opposites. In fact, guided by your Activator theme, you believe that action is the best device for learning. You make a decision, you take action, you look at the result, and you learn. This learning informs your next action and your next. How can you grow if you have nothing to react to? Well, you believe you can’t. You must put yourself out there. You must take the next step. It is the only way to keep your thinking fresh and informed. The bottom line is this: You know you will be judged not by what you say, not by what you think, but by what you get done. This does not frighten you. It pleases you.	2012-09-28 21:39:39.71455	2012-09-28 21:39:39.71455
3	Adaptability	People who are especially talented in the Adaptability theme prefer to “go with the flow.” They tend to be “now” people who take things as they come and discover the future one day at a time.	You live in the moment. You don’t see the future as a fixed destination. Instead, you see it as a place that you create out of the choices that you make right now. And so you discover your future one choice at a time. This doesn’t mean that you don’t have plans. You probably do. But this theme of Adaptability does enable you to respond willingly to the demands of the moment even if they pull you away from your plans. Unlike some, you don’t resent sudden requests or unforeseen detours. You expect them. They are inevitable. Indeed, on some level you actually look forward to them. You are, at heart, a very flexible person who can stay productive when the demands of work are pulling you in many different directions at once.	2012-09-28 21:39:39.718973	2012-09-28 21:39:39.718973
4	Analytical	People who are especially talented in the Analytical theme search for reasons and causes. They have the ability to think about all the factors that might affect a situation.	Your Analytical theme challenges other people: “Prove it. Show me why what you are claiming is true.” In the face of this kind of questioning some will find that their brilliant theories wither and die. For you, this is precisely the point. You do not necessarily want to destroy other people’s ideas, but you do insist that their theories be sound. You see yourself as objective and dispassionate. You like data because they are value free. They have no agenda. Armed with these data, you search for patterns and connections. You want to understand how certain patterns affect one another. How do they combine? What is their outcome? Does this outcome fit with the theory being offered or the situation being confronted? These are your questions. You peel the layers back until, gradually, the root cause or causes are revealed. Others see you as logical and rigorous. Over time they will come to you in order to expose someone’s “wishful thinking” or “clumsy thinking” to your refining mind. It is hoped that your analysis is never delivered too harshly. Otherwise, others may avoid you when that “wishful thinking” is their own.	2012-09-28 21:39:39.722409	2012-09-28 21:39:39.722409
5	Arranger	People who are especially talented in the Arranger theme can organize, but they also have a flexibility that complements this ability. They like to figure out how all of the pieces and resources can be arranged for maximum productivity.	You are a conductor. When faced with a complex situation involving many factors, you enjoy managing all of the variables, aligning and realigning them until you are sure you have arranged them in the most productive configuration possible. In your mind there is nothing special about what you are doing. You are simply trying to figure out the best way to get things done. But others, lacking this theme, will be in awe of your ability. “How can you keep so many things in your head at once?” they will ask. “How can you stay so flexible, so willing to shelve well-laid plans in favor of some brand-new configuration that has just occurred to you?” But you cannot imagine behaving in any other way. You are a shining example of effective flexibility, whether you are changing travel schedules at the last minute because a better fare has popped up or mulling over just the right combination of people and resources to accomplish a new project. From the mundane to the complex, you are always looking for the perfect configuration. Of course, you are at your best in dynamic situations. Confronted with the unexpected, some complain that plans devised with such care cannot be changed, while others take refuge in the existing rules or procedures. You don’t do either. Instead, you jump into the confusion, devising new options, hunting for new paths of least resistance, and figuring out new partnerships — because, after all, there might just be a better way.	2012-09-28 21:39:39.727183	2012-09-28 21:39:39.727183
6	Belief	People who are especially talented in the Belief theme have certain core values that are unchanging. Out of these values emerges a defined purpose for their life.	If you possess a strong Belief theme, you have certain core values that are enduring. These values vary from one person to another, but ordinarily your Belief theme causes you to be family-oriented, altruistic, even spiritual, and to value responsibility and high ethics — both in yourself and others. These core values affect your behavior in many ways. They give your life meaning and satisfaction; in your view, success is more than money and prestige. They provide you with direction, guiding you through the temptations and distractions of life toward a consistent set of priorities. This consistency is the foundation for all your relationships. Your friends call you dependable. “I know where you stand,” they say. Your Belief makes you easy to tru It also demands that you find work that meshes with your values. Your work must be meaningful; it must matter to you. And guided by your Belief theme it will matter only if it gives you a chance to live out your values.	2012-09-28 21:39:39.731878	2012-09-28 21:39:39.731878
7	Command	People who are especially talented in the Command theme have presence. They can take control of a situation and make decisions.	Command leads you to take charge. Unlike some people, you feel no discomfort with imposing your views on others. On the contrary, once your opinion is formed, you need to share it with others. Once your goal is set, you feel restless until you have aligned others with you. You are not frightened by confrontation; rather, you know that confrontation is the first step toward resolution. Whereas others may avoid facing up to life’s unpleasantness, you feel compelled to present the facts or the truth, no matter how unpleasant it may be. You need things to be clear between people and challenge them to be clear-eyed and hone You push them to take risks. You may even intimidate them. And while some may resent this, labeling you opinionated, they often willingly hand you the reins. People are drawn toward those who take a stance and ask them to move in a certain direction. Therefore, people will be drawn to you. You have presence. You have Command.	2012-09-28 21:39:39.735947	2012-09-28 21:39:39.735947
8	Communication	People who are especially talented in the Communication theme generally find it easy to put their thoughts into words. They are good conversationalists and presenters.	You like to explain, to describe, to host, to speak in public, and to write. This is your Communication theme at work. Ideas are a dry beginning. Events are static. You feel a need to bring them to life, to energize them, to make them exciting and vivid. And so you turn events into stories and practice telling them. You take the dry idea and enliven it with images and examples and metaphors. You believe that most people have a very short attention span. They are bombarded by information, but very little of it survives. You want your information — whether an idea, an event, a product’s features and benefits, a discovery, or a lesson — to survive. You want to divert their attention toward you and then capture it, lock it in. This is what drives your hunt for the perfect phrase. This is what draws you toward dramatic words and powerful word combinations. This is why people like to listen to you. Your word pictures pique their interest, sharpen their world, and inspire them to act.	2012-09-28 21:39:39.740009	2012-09-28 21:39:39.740009
9	Competition	People who are especially talented in the Competition theme measure their progress against the performance of others. They strive to win first place and revel in contests.	Competition is rooted in comparison. When you look at the world, you are instinctively aware of other people’s performance. Their performance is the ultimate yardstick. No matter how hard you tried, no matter how worthy your intentions, if you reached your goal but did not outperform your peers, the achievement feels hollow. Like all competitors, you need other people. You need to compare. If you can compare, you can compete, and if you can compete, you can win. And when you win, there is no feeling quite like it. You like measurement because it facilitates comparisons. You like other competitors because they invigorate you. You like contests because they must produce a winner. You particularly like contests where you know you have the inside track to be the winner. Although you are gracious to your fellow competitors and even stoic in defeat, you don’t compete for the fun of competing. You compete to win. Over time you will come to avoid contests where winning seems unlikely. 	2012-09-28 21:39:39.74375	2012-09-28 21:39:39.74375
10	Connectedness	People who are especially talented in the Connectedness theme have faith in the links between all things. They believe there are few coincidences and that almost every event has a reason.	Things happen for a reason. You are sure of it. You are sure of it because in your soul you know that we are all connected. Yes, we are individuals, responsible for our own judgments and in possession of our own free will, but nonetheless we are part of something larger. Some may call it the collective unconscious. Others may label it spirit or life force. But whatever your word of choice, you gain confidence from knowing that we are not isolated from one another or from the earth and the life on it. This feeling of Connectedness implies certain responsibilities. If we are all part of a larger picture, then we must not harm others because we will be harming ourselves. We must not exploit because we will be exploiting ourselves. Your awareness of these responsibilities creates your value system. You are considerate, caring, and accepting. Certain of the unity of humankind, you are a bridge builder for people of different cultures. Sensitive to the invisible hand, you can give others comfort that there is a purpose beyond our humdrum lives. The exact articles of your faith will depend on your upbringing and your culture, but your faith is strong. It sustains you and your close friends in the face of life’s mysteries.	2012-09-28 21:39:39.747768	2012-09-28 21:39:39.747768
11	Consistency	People who are especially talented in the Consistency theme are keenly aware of the need to treat people the same. They try to treat everyone in the world with consistency by setting up clear rules and adhering to them.	Balance is important to you. You are keenly aware of the need to treat people the same, no matter what their station in life, so you do not want to see the scales tipped too far in any one person’s favor. In your view this leads to selfishness and individualism. It leads to a world where some people gain an unfair advantage because of their connections or their background or their greasing of the wheels. This is truly offensive to you. You see yourself as a guardian against it. In direct contrast to this world of special favors, you believe that people function best in a consistent environment where the rules are clear and are applied to everyone equally. This is an environment where people know what is expected. It is predictable and evenhanded. It is fair. Here each person has an even chance to show his or her worth.	2012-09-28 21:39:39.751761	2012-09-28 21:39:39.751761
12	Context	People who are especially talented in the Context theme enjoy thinking about the pa They understand the present by researching its history.	You look back. You look back because that is where the answers lie. You look back to understand the present.\nFrom your vantage point the present is unstable, a confusing clamor of competing voices. It is only by cast-\ning your mind back to an earlier time, a time when the plans were being drawn up, that the present regains\nits stability. The earlier time was a simpler time. It was a time of blueprints. As you look back, you begin to\nsee these blueprints emerge. You realize what the initial intentions were. These blueprints or intentions have\nsince become so embellished that they are almost unrecognizable, but now this Context theme reveals them\nagain. This understanding brings you confidence. No longer disoriented, you make better decisions because\nyou sense the underlying structure. You become a better partner because you understand how your colleagues\ncame to be who they are. And counterintuitively you become wiser about the future because you saw its\nseeds being sown in the pa Faced with new people and new situations, it will take you a little time to orient\nyourself, but you must give yourself this time. You must discipline yourself to ask the questions and allow the\nblueprints to emerge because no matter what the situation, if you haven’t seen the blueprints, you will have\nless confidence in your decisions.\n	2012-09-28 21:39:39.756171	2012-09-28 21:39:39.756171
13	Deliberative	People who are especially talented in the Deliberative theme are best described by the serious care they take in making decisions or choices. They anticipate the obstacles.	You are careful. You are vigilant. You are a private person. You know that the world is an unpredictable place.\nEverything may seem in order, but beneath the surface you sense the many risks. Rather than denying these\nrisks, you draw each one out into the open. Then each risk can be identified, assessed, and ultimately reduced.\nThus, you are a fairly serious person who approaches life with a certain reserve. For example, you like to plan\nahead so as to anticipate what might go wrong. You select your friends cautiously and keep your own counsel\nwhen the conversation turns to personal matters. You are careful not to give too much praise and recognition,\nlest it be misconstrued. If some people don’t like you because you are not as effusive as others, then so be it.\nFor you, life is not a popularity conte Life is something of a minefield. Others can run through it recklessly\nif they so choose, but you take a different approach. You identify the dangers, weigh their relative impact, and\nthen place your feet deliberately. You walk with care.\n	2012-09-28 21:39:39.760359	2012-09-28 21:39:39.760359
14	Developer	People who are especially talented in the Developer theme recognize and cultivate the potential in others. They spot the signs of each small improvement and derive satisfaction from these improvements.	You see the potential in others. Very often, in fact, potential is all you see. In your view no individual is fully\nformed. On the contrary, each individual is a work in progress, alive with possibilities. And you are drawn\ntoward people for this very reason. When you interact with others, your goal is to help them experience success.\nYou look for ways to challenge them. You devise interesting experiences that can stretch them and help them\ngrow. And all the while you are on the lookout for the signs of growth — a new behavior learned or modified,\na slight improvement in a skill, a glimpse of excellence or of “flow” where previously there were only halting\nsteps. For you these small increments — invisible to some — are clear signs of potential being realized. These\nsigns of growth in others are your fuel. They bring you strength and satisfaction. Over time many will seek you\nout for help and encouragement because on some level they know that your helpfulness is both genuine and\nfulfilling to you.\n	2012-09-28 21:39:39.764468	2012-09-28 21:39:39.764468
15	Discipline	People who are especially talented in the Discipline theme enjoy routine and structure. Their world is best described by the order they create.	Your world needs to be predictable. It needs to be ordered and planned. So you instinctively impose structure\non your world. You set up routines. You focus on timelines and deadlines. You break long-term projects into\na series of specific short-term plans, and you work through each plan diligently. You are not necessarily neat\nand clean, but you do need precision. Faced with the inherent messiness of life, you want to feel in control.\nThe routines, the timelines, the structure, all of these help create this feeling of control. Lacking this theme of\nDiscipline, others may sometimes resent your need for order, but there need not be conflict. You must\nunderstand that not everyone feels your urge for predictability; they have other ways of getting things done. \nLikewise, you can help them understand and even appreciate your need for structure. Your dislike of surprises,\nyour impatience with errors, your routines, and your detail orientation don’t need to be misinterpreted as\ncontrolling behaviors that box people in. Rather, these behaviors can be understood as your instinctive method\nfor maintaining your progress and your productivity in the face of life’s many distractions.  \n	2012-09-28 21:39:39.768654	2012-09-28 21:39:39.768654
16	Empathy	People who are especially talented in the Empathy theme can sense the feelings of other people by imagining themselves in others’ lives or others’ situations.	You can sense the emotions of those around you. You can feel what they are feeling as though their feelings\nare your own. Intuitively, you are able to see the world through their eyes and share their perspective. You do\nnot necessarily agree with each person’s perspective. You do not necessarily feel pity for each person’s predicament —\nthis would be sympathy, not Empathy. You do not necessarily condone the choices each person\nmakes, but you do understand. This instinctive ability to understand is powerful. You hear the unvoiced questions.\nYou anticipate the need. Where others grapple for words, you seem to find the right words and the right\ntone. You help people find the right phrases to express their feelings — to themselves as well as to others. You\nhelp them give voice to their emotional life. For all these reasons other people are drawn to you.\n	2012-09-28 21:39:39.773088	2012-09-28 21:39:39.773088
17	Focus	People who are especially talented in the Focus theme can take a direction, follow through, and make the corrections necessary to stay on track. They prioritize, then act.	“Where am I headed?” you ask yourself. You ask this question every day. Guided by this theme of Focus, you\nneed a clear destination. Lacking one, your life and your work can quickly become frustrating. And so each\nyear, each month, and even each week you set goals. These goals then serve as your compass, helping you\ndetermine priorities and make the necessary corrections to get back on course. Your Focus is powerful because\nit forces you to filter; you instinctively evaluate whether or not a particular action will help you move toward\nyour goal. Those that don’t are ignored. In the end, then, your Focus forces you to be efficient. Naturally, the\nflip side of this is that it causes you to become impatient with delays, obstacles, and even tangents, no\nmatter how intriguing they appear to be. This makes you an extremely valuable team member. When others start\nto wander down other avenues, you bring them back to the main road. Your Focus reminds everyone that if\nsomething is not helping you move toward your destination, then it is not important. And if it is not\nimportant, then it is not worth your time. You keep everyone on point.\n	2012-09-28 21:39:39.776816	2012-09-28 21:39:39.776816
18	Futuristic	People who are especially talented in the Futuristic theme are inspired by the future and what could be. They inspire others with their visions of the future.	“Wouldn’t it be great if . . .” You are the kind of person who loves to peer over the horizon. The future\nfascinates you. As if it were projected on the wall, you see in detail what the future might hold, and this detailed\npicture keeps pulling you forward, into tomorrow. While the exact content of the picture will depend on your\nother strengths and interests — a better product, a better team, a better life, or a better world — it will always\nbe inspirational to you. You are a dreamer who sees visions of what could be and who cherishes those visions.\nWhen the present proves too frustrating and the people around you too pragmatic, you conjure up your\nvisions of the future and they energize you. They can energize others, too. In fact, very often people look to you\nto describe your visions of the future. They want a picture that can raise their sights and thereby their spirits.\nYou can paint it for them. Practice. Choose your words carefully. Make the picture as vivid as possible. People\nwill want to latch on to the hope you bring.\n	2012-09-28 21:39:39.780622	2012-09-28 21:39:39.780622
19	Harmony	People who are especially talented in the Harmony theme look for consensus. They don’t enjoy conflict; rather, they seek areas of agreement.	You look for areas of agreement. In your view there is little to be gained from conflict and friction, so you seek\nto hold them to a minimum. When you know that the people around you hold differing views, you try to find\nthe common ground. You try to steer them away from confrontation and toward harmony. In fact, harmony is\none of your guiding values. You can’t quite believe how much time is wasted by people trying to impose their\nviews on others. Wouldn’t we all be more productive if we kept our opinions in check and instead looked for\nconsensus and support? You believe we would, and you live by that belief. When others are sounding off about\ntheir goals, their claims, and their fervently held opinions, you hold your peace. When others strike out in a\ndirection, you will willingly, in the service of harmony, modify your own objectives to merge with theirs (as\nlong as their basic values do not clash with yours). When others start to argue about their pet theory or\nconcept, you steer clear of the debate, preferring to talk about practical, down-to-earth matters on which you can\nall agree. In your view we are all in the same boat, and we need this boat to get where we are going. It is a good\nboat. There is no need to rock it just to show that you can.\n	2012-09-28 21:39:39.78454	2012-09-28 21:39:39.78454
20	Ideation	People who are especially talented in the Ideation theme are fascinated by ideas. They are able to find connections between seemingly disparate phenomena.	You are fascinated by ideas. What is an idea? An idea is a concept, the best explanation of the most events.\nYou are delighted when you discover beneath the complex surface an elegantly simple concept to explain why\nthings are the way they are. An idea is a connection. Yours is the kind of mind that is always looking for\nconnections, and so you are intrigued when seemingly disparate phenomena can be linked by an obscure\nconnection. An idea is a new perspective on familiar challenges. You revel in taking the world we all know and\nturning it around so we can view it from a strange but strangely enlightening angle. You love all these ideas\nbecause they are profound, because they are novel, because they are clarifying, because they are contrary,\nbecause they are bizarre. For all these reasons you derive a jolt of energy whenever a new idea occurs to you.\nOthers may label you creative or original or conceptual or even smart. Perhaps you are all of these. Who can\nbe sure? What you are sure of is that ideas are thrilling. And on most days this is enough.\n	2012-09-28 21:39:39.788324	2012-09-28 21:39:39.788324
21	Includer	People who are especially talented in the Includer theme are accepting of others. They show awareness of those who feel left out, and make an effort to include them.	“Stretch the circle wider.” This is the philosophy around which you orient your life. You want to include people\nand make them feel part of the group. In direct contrast to those who are drawn only to exclusive groups, you\nactively avoid those groups that exclude others. You want to expand the group so that as many people as\npossible can benefit from its support. You hate the sight of someone on the outside looking in. You want to draw\nthem in so that they can feel the warmth of the group. You are an instinctively accepting person. Regardless\nof race or sex or nationality or personality or faith, you cast few judgments. Judgments can hurt a person’s\nfeelings. Why do that if you don’t have to? Your accepting nature does not necessarily rest on a belief that each\nof us is different and that one should respect these differences. Rather, it rests on your conviction that\nfundamentally we are all the same. We are all equally important. Thus, no one should be ignored. Each of us should\nbe included. It is the least we all deserve.\n	2012-09-28 21:39:39.792722	2012-09-28 21:39:39.792722
22	Individualization	People who are especially talented in the Individualization theme are intrigued with the unique qualities of each person. They have a gift for figuring out how people who are different can work together productively.	Your Individualization theme leads you to be intrigued by the unique qualities of each person. You are\nimpatient with generalizations or “types” because you don’t want to obscure what is special and distinct about each\nperson. Instead, you focus on the differences between individuals. You instinctively observe each person’s\nstyle, each person’s motivation, how each thinks, and how each builds relationships. You hear the one-of-a-\nkind stories in each person’s life. This theme explains why you pick your friends just the right birthday gift,\nwhy you know that one person prefers praise in public and another detests it, and why you tailor your\nteaching style to accommodate one person’s need to be shown and another’s desire to “figure it out as I go.” Because\nyou are such a keen observer of other people’s strengths, you can draw out the best in each person. This\nIndividualization theme also helps you build productive teams. While some search around for the perfect team\n“structure” or “process,” you know instinctively that the secret to great teams is casting by individual strengths\nso that everyone can do a lot of what they do well.  \n	2012-09-28 21:39:39.797631	2012-09-28 21:39:39.797631
23	Input	People who are especially talented in the Input theme have a craving to know more. Often they like to collect and archive all kinds of information.	You are inquisitive. You collect things. You might collect information — words, facts, books, and quotations —\nor you might collect tangible objects such as butterflies, baseball cards, porcelain dolls, or sepia photographs.\nWhatever you collect, you collect it because it interests you. And yours is the kind of mind that finds so many\nthings interesting. The world is exciting precisely because of its infinite variety and complexity. If you read a\ngreat deal, it is not necessarily to refine your theories but, rather, to add more information to your archives.\nIf you like to travel, it is because each new location offers novel artifacts and facts. These can be acquired and\nthen stored away. Why are they worth storing? At the time of storing it is often hard to say exactly when or\nwhy you might need them, but who knows when they might become useful? With all those possible uses in\nmind, you really don’t feel comfortable throwing anything away. So you keep acquiring and compiling and\nfiling stuff away. It’s interesting. It keeps your mind fresh. And perhaps one day some of it will prove valuable.\n	2012-09-28 21:39:39.802738	2012-09-28 21:39:39.802738
24	Intellection	People who are especially talented in the Intellection theme are characterized by their intellectual activity. They are introspective and appreciate intellectual discussions.	You like to think. You like mental activity. You like exercising the “muscles” of your brain, stretching them\nin multiple directions. This need for mental activity may be focused; for example, you may be trying to solve\na problem or develop an idea or understand another person’s feelings. The exact focus will depend on your\nother strengths. On the other hand, this mental activity may very well lack focus. The theme of Intellection\ndoes not dictate what you are thinking about; it simply describes that you like to think. You are the kind of\nperson who enjoys your time alone because it is your time for musing and reflection. You are introspective. In\na sense you are your own best companion, as you pose yourself questions and try out answers on yourself to\nsee how they sound. This introspection may lead you to a slight sense of discontent as you compare what you\nare actually doing with all the thoughts and ideas that your mind conceives. Or this introspection may tend\ntoward more pragmatic matters such as the events of the day or a conversation that you plan to have later.\nWherever it leads you, this mental hum is one of the constants of your life.   \n	2012-09-28 21:39:39.807199	2012-09-28 21:39:39.807199
25	Learner	People who are especially talented in the Learner theme have a great desire to learn and want to continuously improve. In particular, the process of learning, rather than the outcome, excites them.	You love to learn. The subject matter that interests you most will be determined by your other themes and\nexperiences, but whatever the subject, you will always be drawn to the process of learning. The process, more\nthan the content or the result, is especially exciting for you. You are energized by the steady and deliberate\njourney from ignorance to competence. The thrill of the first few facts, the early efforts to recite or practice\nwhat you have learned, the growing confidence of a skill mastered — this is the process that entices you. Your\nexcitement leads you to engage in adult learning experiences — yoga or piano lessons or graduate classes. It\nenables you to thrive in dynamic work environments where you are asked to take on short project assignments\nand are expected to learn a lot about the new subject matter in a short period of time and then move on to the\nnext one. This Learner theme does not necessarily mean that you seek to become the subject matter expert, or\nthat you are striving for the respect that accompanies a professional or academic credential. The outcome of\nthe learning is less significant than the “getting there.”   \n	2012-09-28 21:39:39.811957	2012-09-28 21:39:39.811957
26	Maximizer	People who are especially talented in the Maximizer theme focus on strengths as a way to stimulate personal and group excellence. They seek to transform something strong into something superb.	Excellence, not average, is your measure. Taking something from below average to slightly above average\ntakes a great deal of effort and in your opinion is not very rewarding. Transforming something strong into\nsomething superb takes just as much effort but is much more thrilling. Strengths, whether yours or someone\nelse’s, fascinate you. Like a diver after pearls, you search them out, watching for the telltale signs of a strength.\nA glimpse of untutored excellence, rapid learning, a skill mastered without recourse to steps — all these are\nclues that a strength may be in play. And having found a strength, you feel compelled to nurture it, refine it,\nand stretch it toward excellence. You polish the pearl until it shines. This natural sorting of strengths means\nthat others see you as discriminating. You choose to spend time with people who appreciate your particular\nstrengths. Likewise, you are attracted to others who seem to have found and cultivated their own strengths.\nYou tend to avoid those who want to fix you and make you well rounded. You don’t want to spend your life\nbemoaning what you lack. Rather, you want to capitalize on the gifts with which you are blessed. It’s more fun.\nIt’s more productive. And, counterintuitively, it is more demanding.  \n	2012-09-28 21:39:39.816254	2012-09-28 21:39:39.816254
27	Positivity	People who are especially talented in the Positivity theme have an enthusiasm that is contagious. They are upbeat and can get others excited about what they are going to do.	You are generous with praise, quick to smile, and always on the lookout for the positive in the situation. Some\ncall you lighthearted. Others just wish that their glass were as full as yours seems to be. But either way, people\nwant to be around you. Their world looks better around you because your enthusiasm is contagious. Lacking\nyour energy and optimism, some find their world drab with repetition or, worse, heavy with pressure. You\nseem to find a way to lighten their spirit. You inject drama into every project. You celebrate every\nachievement. You find ways to make everything more exciting and more vital. Some cynics may reject your energy,\nbut you are rarely dragged down. Your Positivity won’t allow it. Somehow you can’t quite escape your\nconviction that it is good to be alive, that work can be fun, and that no matter what the setbacks, one must never lose\none’s sense of humor.   \n	2012-09-28 21:39:39.820727	2012-09-28 21:39:39.820727
28	Relator	People who are especially talented in the Relator theme enjoy close relationships with others. They find deep satisfaction in working hard with friends to achieve a goal.	Relator describes your attitude toward your relationships. In simple terms, the Relator theme pulls you\ntoward people you already know. You do not necessarily shy away from meeting new people — in fact, you may\nhave other themes that cause you to enjoy the thrill of turning strangers into friends — but you do derive a\ngreat deal of pleasure and strength from being around your close friends. You are comfortable with intimacy.\nOnce the initial connection has been made, you deliberately encourage a deepening of the relationship. You\nwant to understand their feelings, their goals, their fears, and their dreams; and you want them to understand\nyours. You know that this kind of closeness implies a certain amount of risk — you might be taken advantage\nof — but you are willing to accept that risk. For you a relationship has value only if it is genuine. And the only\nway to know that is to entrust yourself to the other person. The more you share with each other, the more you\nrisk together. The more you risk together, the more each of you proves your caring is genuine. These are your\nsteps toward real friendship, and you take them willingly.\n	2012-09-28 21:39:39.826419	2012-09-28 21:39:39.826419
29	Responsibility	People who are especially talented in the Responsibility theme take psychological ownership of what they say they will do. They are committed to stable values such as honesty and loyalty.	Your Responsibility theme forces you to take psychological ownership for anything you commit to, and\nwhether large or small, you feel emotionally bound to follow it through to completion. Your good name depends on\nit. If for some reason you cannot deliver, you automatically start to look for ways to make it up to the other\nperson. Apologies are not enough. Excuses and rationalizations are totally unacceptable. You will not quite\nbe able to live with yourself until you have made restitution. This conscientiousness, this near obsession for\ndoing things right, and your impeccable ethics, combine to create your reputation: utterly dependable. When\nassigning new responsibilities, people will look to you first because they know it will get done. When people\ncome to you for help — and they soon will — you must be selective. Your willingness to volunteer may\nsometimes lead you to take on more than you should.\n	2012-09-28 21:39:39.832309	2012-09-28 21:39:39.832309
30	Restorative	People who are especially talented in the Restorative theme are adept at dealing with problems. They are good at\nfiguring out what is wrong and resolving it.	You love to solve problems. Whereas some are dismayed when they encounter yet another breakdown, you\ncan be energized by it. You enjoy the challenge of analyzing the symptoms, identifying what is wrong, and\nfinding the solution. You may prefer practical problems or conceptual ones or personal ones. You may seek\nout specific kinds of problems that you have met many times before and that you are confident you can fix. Or\nyou may feel the greatest push when faced with complex and unfamiliar problems. Your exact preferences are\ndetermined by your other themes and experiences. But what is certain is that you enjoy bringing things back\nto life. It is a wonderful feeling to identify the undermining factor(s), eradicate them, and restore something to\nits true glory. Intuitively, you know that without your intervention, this thing — this machine, this technique,\nthis person, this company — might have ceased to function. You fixed it, resuscitated it, rekindled its vitality.\nPhrasing it the way you might, you saved it.  \n	2012-09-28 21:39:39.838519	2012-09-28 21:39:39.838519
31	Self-Assurance	People who are especially talented in the Self-Assurance theme feel confident in their ability to manage their own lives. They possess an inner compass that gives them confidence that their decisions are right.	Self-Assurance is similar to self-confidence. In the deepest part of you, you have faith in your strengths. You\nknow that you are able — able to take risks, able to meet new challenges, able to stake claims, and, most\nimportant, able to deliver. But Self-Assurance is more than just self-confidence. Blessed with the theme of Self-\nAssurance, you have confidence not only in your abilities but in your judgment. When you look at the world,\nyou know that your perspective is unique and distinct. And because no one sees exactly what you see, you\nknow that no one can make your decisions for you. No one can tell you what to think. They can guide. They\ncan sugge But you alone have the authority to form conclusions, make decisions, and act. This authority,\nthis final accountability for the living of your life, does not intimidate you. On the contrary, it feels natural to\nyou. No matter what the situation, you seem to know what the right decision is. This theme lends you an aura\nof certainty. Unlike many, you are not easily swayed by someone else’s arguments, no matter how persuasive\nthey may be. This Self-Assurance may be quiet or loud, depending on your other themes, but it is solid. It is\nstrong. Like the keel of a ship, it withstands many different pressures and keeps you on your course.\n	2012-09-28 21:39:39.844734	2012-09-28 21:39:39.844734
32	Significance	People who are especially talented in the Significance theme want to be very important in the eyes of others. They are independent and want to be recognized.	You want to be very significant in the eyes of other people. In the truest sense of the word you want to be\nrecognized. You want to be heard. You want to stand out. You want to be known. In particular, you want to be\nknown and appreciated for the unique strengths you bring. You feel a need to be admired as credible,\nprofessional, and successful. Likewise, you want to associate with others who are credible, professional, and\nsuccessful. And if they aren’t, you will push them to achieve until they are. Or you will move on. An independent\nspirit, you want your work to be a way of life rather than a job, and in that work you want to be given free rein,\nthe leeway to do things your way. Your yearnings feel intense to you, and you honor those yearnings. And so\nyour life is filled with goals, achievements, or qualifications that you crave. Whatever your focus — and each\nperson is distinct — your Significance theme will keep pulling you upward, away from the mediocre toward\nthe exceptional. It is the theme that keeps you reaching.\n	2012-09-28 21:39:39.849838	2012-09-28 21:39:39.849838
33	Strategic	People who are especially talented in the Strategic theme create alternative ways to proceed. Faced with any given scenario, they can quickly spot the relevant patterns and issues.	The Strategic theme enables you to sort through the clutter and find the best route. It is not a skill that can be\ntaught. It is a distinct way of thinking, a special perspective on the world at large. This perspective allows you\nto see patterns where others simply see complexity. Mindful of these patterns, you play out alternative\nscenarios, always asking, “What if this happened? Okay, well what if this happened?” This recurring question helps\nyou see around the next corner. There you can evaluate accurately the potential obstacles. Guided by where\nyou see each path leading, you start to make selections. You discard the paths that lead nowhere. You discard\nthe paths that lead straight into resistance. You discard the paths that lead into a fog of confusion. You cull\nand make selections until you arrive at the chosen path — your strategy. Armed with your strategy, you strike\nforward. This is your Strategic theme at work: “What if?” Select. Strike.\n	2012-09-28 21:39:39.855648	2012-09-28 21:39:39.855648
34	Woo	People who are especially talented in the Woo theme love the challenge of meeting new people and winning them over. They derive satisfaction from breaking the ice and making a connection with another person.	Woo stands for winning others over. You enjoy the challenge of meeting new people and getting them to like\nyou. Strangers are rarely intimidating to you. On the contrary, strangers can be energizing. You are drawn to\nthem. You want to learn their names, ask them questions, and find some area of common interest so that you\ncan strike up a conversation and build rapport. Some people shy away from starting up conversations because\nthey worry about running out of things to say. You don’t. Not only are you rarely at a loss for words; you\nactually enjoy initiating with strangers because you derive satisfaction from breaking the ice and making a\nconnection. Once that connection is made, you are quite happy to wrap it up and move on. There are new people\nto meet, new rooms to work, new crowds to mingle in. In your world there are no strangers, only friends you\nhaven’t met yet — lots of them.\n	2012-09-28 21:39:39.860841	2012-09-28 21:39:39.860841
\.


--
-- Data for Name: suggestions; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY suggestions (id, user_id, comment, page, created_at, updated_at, email) FROM stdin;
\.


--
-- Data for Name: task_types; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY task_types (id, name, description, is_staff, is_student, created_at, updated_at) FROM stdin;
1	Working on deliverables	Task description	f	t	2012-09-28 21:39:40.010394	2012-09-28 21:39:40.010394
2	Readings	Task description	f	t	2012-09-28 21:39:40.019451	2012-09-28 21:39:40.019451
3	Meetings	Task description	f	t	2012-09-28 21:39:40.025432	2012-09-28 21:39:40.025432
4	Other	Task description	f	t	2012-09-28 21:39:40.031886	2012-09-28 21:39:40.031886
\.


--
-- Data for Name: team_assignments; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY team_assignments (team_id, user_id) FROM stdin;
1	4
1	5
1	6
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY teams (id, name, email, twiki_space, tigris_space, primary_faculty_id, secondary_faculty_id, livemeeting, created_at, updated_at, section, peer_evaluation_first_email, peer_evaluation_second_email, peer_evaluation_do_point_allocation, course_id, updating_email) FROM stdin;
1	Team Terrific	fall-2012-team-terrific@sandbox.sv.cmu.edu	http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome	http://terrific.tigris.org/servlets/ProjectDocumentList	\N	\N	\N	2012-09-28 21:39:40.595979	2012-09-28 21:39:40.595979	\N	\N	\N	\N	1	t
\.


--
-- Data for Name: user_versions; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY user_versions (id, user_id, version, webiso_account, email, created_at, updated_at, is_staff, is_student, is_admin, twiki_name, first_name, last_name, human_name, image_uri, graduation_year, masters_program, masters_track, is_part_time, is_adobe_connect_host, effort_log_warning_email, is_active, legal_first_name, organization_name, title, work_city, work_state, work_country, telephone1, skype, tigris, personal_email, local_near_remote, biography, user_text, office, office_hours, telephone1_label, telephone2, telephone2_label, telephone3, telephone3_label, telephone4, telephone4_label, updated_by_user_id, is_alumnus, pronunciation, google_created, twiki_created, adobe_created, msdnaa_created, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, yammer_created, strength1_id, strength2_id, strength3_id, strength4_id, strength5_id, sponsored_project_effort_last_emailed, photo_file_name, photo_content_type, github, course_tools_view, remember_token, remember_created_at, expires_at, course_index_view) FROM stdin;
1	1	1	1348868380.1422873	todd.sedano@sv.cmu.edu	2012-09-28 21:39:40.185989	2012-09-28 21:39:40.185989	t	f	f	\N	Todd	Sedano	Todd Sedano	/images/mascot.jpg	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	2	1	1348868380.2508008	ed.katz@sv.cmu.edu	2012-09-28 21:39:40.26192	2012-09-28 21:39:40.26192	t	f	f	\N	Ed	Katz	Ed Katz	/images/mascot.jpg	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	3	1	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-09-28 21:39:40.353152	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	4	1	awesm@andrew.cmu.edu	awe.smith@sv.cmu.edu	2012-09-28 21:39:40.726484	2012-09-28 21:39:40.726484	f	t	f	AweSmith	Awe	Smith	Awe Smith	/images/mascot.jpg	2021	SE	DM	t	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	5	1	bross@andrew.cmu.edu	betty.ross@sv.cmu.edu	2012-09-28 21:39:40.800024	2012-09-28 21:39:40.800024	f	t	f	BettyRoss	Betty	Ross	Betty Ross	/images/mascot.jpg	2021	SE	DM	t	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	6	1	cmoss@andrew.cmu.edu	charlie.moss@sv.cmu.edu	2012-09-28 21:39:40.839658	2012-09-28 21:39:40.839658	f	t	f	CharlieMoss	Charlie	Moss	Charlie Moss	/images/mascot.jpg	2021	SE	DM	t	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	3	2	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-09-29 05:44:49.987114	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ztsKLMciAVdWphp9PrQG	2012-09-29 05:44:49.887618	\N	\N
8	3	3	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-09-29 05:44:50.306404	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2012-09-29 05:44:50.302007	2012-09-29 05:44:50.302007	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ztsKLMciAVdWphp9PrQG	2012-09-29 05:44:49.887618	\N	\N
9	3	4	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-09-29 22:18:45.945392	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2012-09-29 05:44:50.302007	2012-09-29 05:44:50.302007	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ztsKLMciAVdWphp9PrQG	2012-09-29 22:18:45.843847	\N	\N
10	3	5	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-09-29 22:18:46.186575	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	2012-09-29 22:18:46.182823	2012-09-29 05:44:50.302007	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ztsKLMciAVdWphp9PrQG	2012-09-29 22:18:45.843847	\N	\N
11	3	6	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-01 05:43:03.828135	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	2012-09-29 22:18:46.182823	2012-09-29 05:44:50.302007	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	3	7	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-01 05:43:52.083663	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	2012-09-29 22:18:46.182823	2012-09-29 05:44:50.302007	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Qzq8qavsYrevFmZExzP1	2012-10-01 05:43:52.072515	\N	\N
13	3	8	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-01 05:43:52.202247	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	3	2012-10-01 05:43:52.197622	2012-09-29 22:18:46.182823	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Qzq8qavsYrevFmZExzP1	2012-10-01 05:43:52.072515	\N	\N
14	3	9	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-01 07:25:45.811995	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2012-10-01 07:25:45.800915	2012-10-01 05:43:52.197622	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Qzq8qavsYrevFmZExzP1	2012-10-01 05:43:52.072515	\N	\N
15	3	10	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-02 19:52:58.175126	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2012-10-01 07:25:45.800915	2012-10-01 05:43:52.197622	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	fgmPHFrFDupgLuGUTFA9	2012-10-02 19:52:58.061703	\N	\N
16	3	11	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-02 19:52:58.524529	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2012-10-02 19:52:58.518323	2012-10-01 07:25:45.800915	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	fgmPHFrFDupgLuGUTFA9	2012-10-02 19:52:58.061703	\N	\N
17	3	12	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-04 00:27:18.316195	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2012-10-02 19:52:58.518323	2012-10-01 07:25:45.800915	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Y97JF7suLmqExLvrNi6C	2012-10-04 00:27:18.207803	\N	\N
18	3	13	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-04 00:27:18.649933	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	2012-10-04 00:27:18.643425	2012-10-02 19:52:58.518323	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Y97JF7suLmqExLvrNi6C	2012-10-04 00:27:18.207803	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY users (id, webiso_account, email, created_at, updated_at, is_staff, is_student, is_admin, twiki_name, first_name, last_name, human_name, image_uri, graduation_year, masters_program, masters_track, is_part_time, is_adobe_connect_host, effort_log_warning_email, is_active, legal_first_name, organization_name, title, work_city, work_state, work_country, telephone1, skype, tigris, personal_email, local_near_remote, biography, user_text, office, office_hours, telephone1_label, telephone2, telephone2_label, telephone3, telephone3_label, telephone4, telephone4_label, updated_by_user_id, version, is_alumnus, pronunciation, google_created, twiki_created, adobe_created, msdnaa_created, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, yammer_created, strength1_id, strength2_id, strength3_id, strength4_id, strength5_id, sponsored_project_effort_last_emailed, photo_file_name, photo_content_type, github, course_tools_view, remember_token, remember_created_at, expires_at, course_index_view) FROM stdin;
1	1348868380.1422873	todd.sedano@sv.cmu.edu	2012-09-28 21:39:40.185989	2012-09-28 21:39:40.185989	t	f	f	\N	Todd	Sedano	Todd Sedano	/images/mascot.jpg	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	1348868380.2508008	ed.katz@sv.cmu.edu	2012-09-28 21:39:40.26192	2012-09-28 21:39:40.26192	t	f	f	\N	Ed	Katz	Ed Katz	/images/mascot.jpg	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	awesm@andrew.cmu.edu	awe.smith@sv.cmu.edu	2012-09-28 21:39:40.726484	2012-09-28 21:39:40.726484	f	t	f	AweSmith	Awe	Smith	Awe Smith	/images/mascot.jpg	2021	SE	DM	t	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	bross@andrew.cmu.edu	betty.ross@sv.cmu.edu	2012-09-28 21:39:40.800024	2012-09-28 21:39:40.800024	f	t	f	BettyRoss	Betty	Ross	Betty Ross	/images/mascot.jpg	2021	SE	DM	t	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	cmoss@andrew.cmu.edu	charlie.moss@sv.cmu.edu	2012-09-28 21:39:40.839658	2012-09-28 21:39:40.839658	f	t	f	CharlieMoss	Charlie	Moss	Charlie Moss	/images/mascot.jpg	2021	SE	DM	t	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	ali@andrew.cmu.edu	clyde.li@sv.cmu.edu	2012-09-28 21:39:40.353152	2012-10-04 00:27:18.649933	f	t	f	ClydeLi	Clyde	Li	An-Tai Li	/images/mascot.jpg	2012	SE	Tech	f	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	\N	\N	\N	\N	\N	\N	6	2012-10-04 00:27:18.643425	2012-10-02 19:52:58.518323	127.0.0.1	127.0.0.1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Y97JF7suLmqExLvrNi6C	2012-10-04 00:27:18.207803	\N	\N
\.


--
-- Data for Name: versions; Type: TABLE DATA; Schema: public; Owner: clydeli
--

COPY versions (id, versioned_id, versioned_type, user_id, user_type, user_name, modifications, number, tag, created_at, updated_at, reverted_from) FROM stdin;
\.


--
-- Name: course_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY course_numbers
    ADD CONSTRAINT course_numbers_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: curriculum_comment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY curriculum_comment_types
    ADD CONSTRAINT curriculum_comment_types_pkey PRIMARY KEY (id);


--
-- Name: curriculum_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY curriculum_comments
    ADD CONSTRAINT curriculum_comments_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: deliverable_attachment_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY deliverable_attachment_versions
    ADD CONSTRAINT deliverable_attachment_versions_pkey PRIMARY KEY (id);


--
-- Name: deliverables_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY deliverables
    ADD CONSTRAINT deliverables_pkey PRIMARY KEY (id);


--
-- Name: effort_log_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY effort_log_line_items
    ADD CONSTRAINT effort_log_line_items_pkey PRIMARY KEY (id);


--
-- Name: effort_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY effort_logs
    ADD CONSTRAINT effort_logs_pkey PRIMARY KEY (id);


--
-- Name: individual_contribution_for_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY individual_contribution_for_courses
    ADD CONSTRAINT individual_contribution_for_courses_pkey PRIMARY KEY (id);


--
-- Name: individual_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY individual_contributions
    ADD CONSTRAINT individual_contributions_pkey PRIMARY KEY (id);


--
-- Name: page_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY page_attachments
    ADD CONSTRAINT page_attachments_pkey PRIMARY KEY (id);


--
-- Name: page_comment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY page_comment_types
    ADD CONSTRAINT page_comment_types_pkey PRIMARY KEY (id);


--
-- Name: page_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY page_comments
    ADD CONSTRAINT page_comments_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: peer_evaluation_learning_objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY peer_evaluation_learning_objectives
    ADD CONSTRAINT peer_evaluation_learning_objectives_pkey PRIMARY KEY (id);


--
-- Name: peer_evaluation_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY peer_evaluation_reports
    ADD CONSTRAINT peer_evaluation_reports_pkey PRIMARY KEY (id);


--
-- Name: peer_evaluation_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY peer_evaluation_reviews
    ADD CONSTRAINT peer_evaluation_reviews_pkey PRIMARY KEY (id);


--
-- Name: presentation_feedback_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY presentation_feedback_answers
    ADD CONSTRAINT presentation_feedback_answers_pkey PRIMARY KEY (id);


--
-- Name: presentation_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY presentation_feedbacks
    ADD CONSTRAINT presentation_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: presentation_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY presentation_questions
    ADD CONSTRAINT presentation_questions_pkey PRIMARY KEY (id);


--
-- Name: presentations_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY presentations
    ADD CONSTRAINT presentations_pkey PRIMARY KEY (id);


--
-- Name: project_types_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY project_types
    ADD CONSTRAINT project_types_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY rss_feeds
    ADD CONSTRAINT rss_feeds_pkey PRIMARY KEY (id);


--
-- Name: scotty_dog_sayings_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY scotty_dog_sayings
    ADD CONSTRAINT scotty_dog_sayings_pkey PRIMARY KEY (id);


--
-- Name: sponsored_project_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY sponsored_project_allocations
    ADD CONSTRAINT sponsored_project_allocations_pkey PRIMARY KEY (id);


--
-- Name: sponsored_project_efforts_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY sponsored_project_efforts
    ADD CONSTRAINT sponsored_project_efforts_pkey PRIMARY KEY (id);


--
-- Name: sponsored_project_sponsors_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY sponsored_project_sponsors
    ADD CONSTRAINT sponsored_project_sponsors_pkey PRIMARY KEY (id);


--
-- Name: sponsored_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY sponsored_projects
    ADD CONSTRAINT sponsored_projects_pkey PRIMARY KEY (id);


--
-- Name: strength_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY strength_themes
    ADD CONSTRAINT strength_themes_pkey PRIMARY KEY (id);


--
-- Name: suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: task_types_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY task_types
    ADD CONSTRAINT task_types_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: user_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY user_versions
    ADD CONSTRAINT user_versions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: clydeli; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: by_evaluator_and_presentation; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE UNIQUE INDEX by_evaluator_and_presentation ON presentation_feedbacks USING btree (evaluator_id, presentation_id);


--
-- Name: by_feedback_and_question; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE UNIQUE INDEX by_feedback_and_question ON presentation_feedback_answers USING btree (feedback_id, question_id);


--
-- Name: index_courses_on_mini; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_courses_on_mini ON courses USING btree (mini);


--
-- Name: index_courses_on_number; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_courses_on_number ON courses USING btree (number);


--
-- Name: index_courses_on_semester; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_courses_on_semester ON courses USING btree (semester);


--
-- Name: index_courses_on_twiki_url; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_courses_on_twiki_url ON courses USING btree (twiki_url);


--
-- Name: index_courses_on_year; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_courses_on_year ON courses USING btree (year);


--
-- Name: index_courses_people_on_course_id_and_person_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE UNIQUE INDEX index_courses_people_on_course_id_and_person_id ON faculty_assignments USING btree (course_id, user_id);


--
-- Name: index_curriculum_comments_on_semester; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_curriculum_comments_on_semester ON curriculum_comments USING btree (semester);


--
-- Name: index_curriculum_comments_on_url; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_curriculum_comments_on_url ON curriculum_comments USING btree (url);


--
-- Name: index_curriculum_comments_on_year; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_curriculum_comments_on_year ON curriculum_comments USING btree (year);


--
-- Name: index_effort_log_line_items_on_effort_log_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_effort_log_line_items_on_effort_log_id ON effort_log_line_items USING btree (effort_log_id);


--
-- Name: index_effort_logs_on_person_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_effort_logs_on_person_id ON effort_logs USING btree (user_id);


--
-- Name: index_effort_logs_on_week_number; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_effort_logs_on_week_number ON effort_logs USING btree (week_number);


--
-- Name: index_faculty_assignments_on_course_id_and_person_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE UNIQUE INDEX index_faculty_assignments_on_course_id_and_person_id ON faculty_assignments USING btree (course_id, user_id);


--
-- Name: index_individual_contribution_for_courses_on_course_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_individual_contribution_for_courses_on_course_id ON individual_contribution_for_courses USING btree (course_id);


--
-- Name: index_individual_contributions_on_user_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_individual_contributions_on_user_id ON individual_contributions USING btree (user_id);


--
-- Name: index_individual_contributions_on_week_number; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_individual_contributions_on_week_number ON individual_contributions USING btree (week_number);


--
-- Name: index_individual_contributions_on_year; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_individual_contributions_on_year ON individual_contributions USING btree (year);


--
-- Name: index_page_attachments_on_is_active; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_attachments_on_is_active ON page_attachments USING btree (is_active);


--
-- Name: index_page_attachments_on_page_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_attachments_on_page_id ON page_attachments USING btree (page_id);


--
-- Name: index_page_attachments_on_position; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_attachments_on_position ON page_attachments USING btree ("position");


--
-- Name: index_page_comments_on_page_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_comments_on_page_id ON page_comments USING btree (page_id);


--
-- Name: index_page_comments_on_semester; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_comments_on_semester ON page_comments USING btree (semester);


--
-- Name: index_page_comments_on_user_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_comments_on_user_id ON page_comments USING btree (user_id);


--
-- Name: index_page_comments_on_year; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_page_comments_on_year ON page_comments USING btree (year);


--
-- Name: index_pages_on_course_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_pages_on_course_id ON pages USING btree (course_id);


--
-- Name: index_pages_on_position; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_pages_on_position ON pages USING btree ("position");


--
-- Name: index_pages_on_url; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_pages_on_url ON pages USING btree (url);


--
-- Name: index_peer_evaluation_learning_objectives_on_person_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_learning_objectives_on_person_id ON peer_evaluation_learning_objectives USING btree (user_id);


--
-- Name: index_peer_evaluation_learning_objectives_on_team_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_learning_objectives_on_team_id ON peer_evaluation_learning_objectives USING btree (team_id);


--
-- Name: index_peer_evaluation_reports_on_recipient_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reports_on_recipient_id ON peer_evaluation_reports USING btree (recipient_id);


--
-- Name: index_peer_evaluation_reports_on_team_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reports_on_team_id ON peer_evaluation_reports USING btree (team_id);


--
-- Name: index_peer_evaluation_reviews_on_author_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reviews_on_author_id ON peer_evaluation_reviews USING btree (author_id);


--
-- Name: index_peer_evaluation_reviews_on_recipient_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reviews_on_recipient_id ON peer_evaluation_reviews USING btree (recipient_id);


--
-- Name: index_peer_evaluation_reviews_on_team_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_peer_evaluation_reviews_on_team_id ON peer_evaluation_reviews USING btree (team_id);


--
-- Name: index_presentations_on_course_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_presentations_on_course_id ON presentations USING btree (course_id);


--
-- Name: index_presentations_on_presentation_date; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_presentations_on_presentation_date ON presentations USING btree (presentation_date);


--
-- Name: index_project_types_on_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_project_types_on_name ON project_types USING btree (name);


--
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_projects_on_name ON projects USING btree (name);


--
-- Name: index_registrations_on_course_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_registrations_on_course_id ON registrations USING btree (course_id);


--
-- Name: index_registrations_on_user_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_registrations_on_user_id ON registrations USING btree (user_id);


--
-- Name: index_scotty_dog_sayings_on_user_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_scotty_dog_sayings_on_user_id ON scotty_dog_sayings USING btree (user_id);


--
-- Name: index_sponsored_project_allocation_on_is_archived; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_allocation_on_is_archived ON sponsored_project_allocations USING btree (is_archived);


--
-- Name: index_sponsored_project_allocation_on_person_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_allocation_on_person_id ON sponsored_project_allocations USING btree (user_id);


--
-- Name: index_sponsored_project_allocation_on_sponsored_project_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_allocation_on_sponsored_project_id ON sponsored_project_allocations USING btree (sponsored_project_id);


--
-- Name: index_sponsored_project_efforts_on_month; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_efforts_on_month ON sponsored_project_efforts USING btree (month);


--
-- Name: index_sponsored_project_efforts_on_sponsored_projects_people_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_efforts_on_sponsored_projects_people_id ON sponsored_project_efforts USING btree (sponsored_project_allocation_id);


--
-- Name: index_sponsored_project_efforts_on_year; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_efforts_on_year ON sponsored_project_efforts USING btree (year);


--
-- Name: index_sponsored_project_sponsors_on_is_archived; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_sponsors_on_is_archived ON sponsored_project_sponsors USING btree (is_archived);


--
-- Name: index_sponsored_project_sponsors_on_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_project_sponsors_on_name ON sponsored_project_sponsors USING btree (name);


--
-- Name: index_sponsored_projects_on_is_archived; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_projects_on_is_archived ON sponsored_projects USING btree (is_archived);


--
-- Name: index_sponsored_projects_on_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_projects_on_name ON sponsored_projects USING btree (name);


--
-- Name: index_sponsored_projects_on_sponsor_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_sponsored_projects_on_sponsor_id ON sponsored_projects USING btree (sponsor_id);


--
-- Name: index_suggestions_on_user_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_suggestions_on_user_id ON suggestions USING btree (user_id);


--
-- Name: index_teams_on_course_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_teams_on_course_id ON teams USING btree (course_id);


--
-- Name: index_teams_people_on_person_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_teams_people_on_person_id ON team_assignments USING btree (user_id);


--
-- Name: index_teams_people_on_team_id; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_teams_people_on_team_id ON team_assignments USING btree (team_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_expires_at; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_expires_at ON users USING btree (expires_at);


--
-- Name: index_users_on_human_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_human_name ON users USING btree (human_name);


--
-- Name: index_users_on_is_active; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_is_active ON users USING btree (is_active);


--
-- Name: index_users_on_is_staff; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_is_staff ON users USING btree (is_staff);


--
-- Name: index_users_on_is_student; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_is_student ON users USING btree (is_student);


--
-- Name: index_users_on_twiki_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_users_on_twiki_name ON users USING btree (twiki_name);


--
-- Name: index_versions_on_created_at; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_versions_on_created_at ON versions USING btree (created_at);


--
-- Name: index_versions_on_number; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_versions_on_number ON versions USING btree (number);


--
-- Name: index_versions_on_tag; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_versions_on_tag ON versions USING btree (tag);


--
-- Name: index_versions_on_user_id_and_user_type; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_versions_on_user_id_and_user_type ON versions USING btree (user_id, user_type);


--
-- Name: index_versions_on_user_name; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_versions_on_user_name ON versions USING btree (user_name);


--
-- Name: index_versions_on_versioned_id_and_versioned_type; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX index_versions_on_versioned_id_and_versioned_type ON versions USING btree (versioned_id, versioned_type);


--
-- Name: individual_contribution_for_courses_icid; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE INDEX individual_contribution_for_courses_icid ON individual_contribution_for_courses USING btree (individual_contribution_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: clydeli; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

