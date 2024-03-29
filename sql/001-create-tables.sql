CREATE TABLE IF NOT EXISTS faculties
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    name VARCHAR(100)                            NOT NULL,
    CONSTRAINT pk_faculties PRIMARY KEY (id),
    CONSTRAINT uc_faculties_name UNIQUE (name),
    CHECK (LENGTH(name) > 0)
);

CREATE TABLE IF NOT EXISTS subjects
(
    id         BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    name       VARCHAR(100)                            NOT NULL,
    faculty_id BIGINT                                  NOT NULL,
    CONSTRAINT pk_subjects PRIMARY KEY (id),
    CONSTRAINT uc_subjects_name_faculty_id UNIQUE (name, faculty_id),
    CONSTRAINT fk_subjects_on_faculty FOREIGN KEY (faculty_id) REFERENCES faculties (id) ON DELETE CASCADE,
    CHECK (LENGTH(name) > 0)
);

CREATE TABLE IF NOT EXISTS groups
(
    id         BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    number     BIGINT                                  NOT NULL,
    faculty_id BIGINT,
    CONSTRAINT pk_groups PRIMARY KEY (id),
    CONSTRAINT uc_groups_number_faculty_id UNIQUE (number, faculty_id),
    CONSTRAINT fk_groups_on_faculty FOREIGN KEY (faculty_id) REFERENCES faculties (id) ON DELETE CASCADE,
    CHECK (number >= 0)
);

CREATE TABLE IF NOT EXISTS professors
(
    id    BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    name  VARCHAR(100)                            NOT NULL,
    email VARCHAR(100)                            NOT NULL,
    CONSTRAINT pk_professors PRIMARY KEY (id),
    CONSTRAINT uc_professors_email UNIQUE (email),
    CHECK (LENGTH(name) > 0),
    CHECK (email LIKE '%_@__%.__%')
);

CREATE TABLE IF NOT EXISTS students
(
    id       BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    name     VARCHAR(100)                            NOT NULL,
    email    VARCHAR(100)                            NOT NULL,
    group_id BIGINT,
    CONSTRAINT pk_students PRIMARY KEY (id),
    CONSTRAINT uc_students_email UNIQUE (email),
    CONSTRAINT fk_students_on_group FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE SET NULL,
    CHECK (LENGTH(name) > 0),
    CHECK (email LIKE '%_@__%.__%')
);

CREATE OR REPLACE FUNCTION is_elder_from_own_group(elder_student_id BIGINT, elder_group_id BIGINT)
    RETURNS BIT AS
$is_elder_from_own_group$
BEGIN
    IF (SELECT students.group_id FROM students WHERE students.id = elder_student_id) = elder_group_id
    THEN
        RETURN B'1';
    END IF;

    RETURN B'0';
END;
$is_elder_from_own_group$
    LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS elders
(
    group_id   BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    CONSTRAINT pk_elders PRIMARY KEY (group_id),
    CONSTRAINT uc_elders_student_id UNIQUE (student_id),
    CONSTRAINT fk_elders_on_group FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE CASCADE,
    CONSTRAINT fk_elders_on_student FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
    CHECK (is_elder_from_own_group(student_id, group_id) = B'1')
);

CREATE TABLE IF NOT EXISTS professors_groups
(
    professor_id BIGINT NOT NULL,
    group_id     BIGINT NOT NULL,
    CONSTRAINT pk_professors_groups PRIMARY KEY (professor_id, group_id),
    CONSTRAINT fk_professors_groups_on_professor FOREIGN KEY (professor_id) REFERENCES professors (id) ON DELETE CASCADE,
    CONSTRAINT fk_professors_groups_on_group FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS professors_subjects
(
    professor_id BIGINT NOT NULL,
    subject_id   BIGINT NOT NULL,
    CONSTRAINT pk_professors_subjects PRIMARY KEY (professor_id, subject_id),
    CONSTRAINT fk_professors_subjects_on_professor FOREIGN KEY (professor_id) REFERENCES professors (id) ON DELETE CASCADE,
    CONSTRAINT fk_professors_subjects_on_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS marks
(
    id         BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    student_id BIGINT                                  NOT NULL,
    subject_id BIGINT                                  NOT NULL,
    mark       int2,
    CONSTRAINT pk_marks PRIMARY KEY (id),
    CONSTRAINT fk_students_subjects_on_student FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
    CONSTRAINT fk_students_subjects_on_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE,
    CHECK ( mark >= 2 AND mark <= 5)
);

CREATE OR REPLACE FUNCTION has_professor_a_subject(professorid BIGINT, subjectid BIGINT)
    RETURNS BIT AS
$has_professor_a_subject$
DECLARE
    subject_count INT;
BEGIN
    SELECT COUNT(*)
    INTO subject_count
    FROM professors_subjects
    WHERE professors_subjects.professor_id = professorid
      AND professors_subjects.subject_id = subjectid;

    IF subject_count > 0 THEN
        RETURN B'1';
    ELSE
        RETURN B'0';
    END IF;
END;
$has_professor_a_subject$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION has_professor_a_group(professorid BIGINT, groupid BIGINT)
    RETURNS BIT AS
$has_professor_a_group$
DECLARE
    group_count INT;
BEGIN
    SELECT COUNT(*)
    INTO group_count
    FROM professors_groups
    WHERE professors_groups.professor_id = professorid
      AND professors_groups.group_id = groupid;

    IF group_count > 0 THEN
        RETURN B'1';
    ELSE
        RETURN B'0';
    END IF;
END;
$has_professor_a_group$
    LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS schedules
(
    id           BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    professor_id BIGINT                                  NOT NULL,
    subject_id   BIGINT                                  NOT NULL,
    group_id     BIGINT,
    lesson_type  VARCHAR(100)                            NOT NULL,
    day_of_week  VARCHAR(100)                            NOT NULL,
    start_time   TIME                                    NOT NULL,
    cabinet      VARCHAR(100)                            NOT NULL,
    CONSTRAINT pk_schedules PRIMARY KEY (id),
    CONSTRAINT fk_schedules_on_professor FOREIGN KEY (professor_id) REFERENCES professors (id) ON DELETE CASCADE,
    CONSTRAINT fk_schedules_on_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE,
    CONSTRAINT fk_schedules_on_group FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE CASCADE,
    CONSTRAINT uk_schedules_professor_id_day_of_the_week_start_time UNIQUE (professor_id, day_of_week, start_time),
    CONSTRAINT uk_schedules_day_of_the_week_start_time_cabinet UNIQUE (day_of_week, start_time, cabinet),
    CHECK
        (
                lesson_type = 'Лекция' OR
                lesson_type = 'Практика' OR
                lesson_type = 'Лабораторное занятие' OR
                lesson_type = 'Факультативное занятие'
        ),
    CHECK
        (
                day_of_week = 'Понедельник' OR
                day_of_week = 'Вторник' OR
                day_of_week = 'Среда' OR
                day_of_week = 'Четверг' OR
                day_of_week = 'Пятница' OR
                day_of_week = 'Суббота'
        ),
    CHECK
        (
                start_time = '9:00:00' OR
                start_time = '10:50:00' OR
                start_time = '12:40:00' OR
                start_time = '14:30:00' OR
                start_time = '16:20:00' OR
                start_time = '18:10:00' OR
                start_time = '20:00:00'
        ),
    CHECK ( has_professor_a_subject(professor_id, subject_id) = B'1' ),
    CHECK ( has_professor_a_group(professor_id, group_id) = B'1' )
);