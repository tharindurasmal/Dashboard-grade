-- ============================================================
-- NSBM Student Grade Dashboard - Full Database Schema
-- ADBMS Assignment 2026
-- ============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS final_results CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS assessments CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;

-- ============================================================
-- TABLE 1: Students
-- ============================================================
CREATE TABLE students (
    student_id   SERIAL PRIMARY KEY,
    student_no   VARCHAR(20)  NOT NULL UNIQUE,      -- e.g. "NSB2024001"
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    program      VARCHAR(100) NOT NULL,             -- e.g. "BSc Software Engineering"
    year_of_study INT         NOT NULL CHECK (year_of_study BETWEEN 1 AND 4),
    gpa          DECIMAL(3,2)          CHECK (gpa BETWEEN 0.00 AND 4.00),
    enrolled_at  DATE         NOT NULL DEFAULT CURRENT_DATE,
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE
);

-- ============================================================
-- TABLE 2: Courses
-- ============================================================
CREATE TABLE courses (
    course_id    SERIAL PRIMARY KEY,
    course_code  VARCHAR(20)  NOT NULL UNIQUE,      -- e.g. "CS301"
    course_name  VARCHAR(150) NOT NULL,
    credits      INT          NOT NULL CHECK (credits BETWEEN 1 AND 6),
    lecturer     VARCHAR(100) NOT NULL,
    department   VARCHAR(100) NOT NULL
);

-- ============================================================
-- TABLE 3: Enrollments  (Student ↔ Course many-to-many)
-- ============================================================
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id    INT         NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id     INT         NOT NULL REFERENCES courses(course_id)   ON DELETE CASCADE,
    semester      VARCHAR(20) NOT NULL CHECK (semester IN ('Semester 1','Semester 2','Semester 3')),
    academic_year VARCHAR(10) NOT NULL,             -- e.g. "2024/25"
    status        VARCHAR(20) NOT NULL DEFAULT 'Active' 
                              CHECK (status IN ('Active','Completed','Withdrawn')),
    UNIQUE(student_id, course_id, academic_year)
);

-- ============================================================
-- TABLE 4: Assessments (belong to a Course)
-- ============================================================
CREATE TABLE assessments (
    assessment_id   SERIAL PRIMARY KEY,
    course_id       INT          NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    title           VARCHAR(200) NOT NULL,          -- e.g. "Midterm Exam"
    type            VARCHAR(50)  NOT NULL 
                    CHECK (type IN ('Assignment','Quiz','Midterm','Final Exam','Lab','Project')),
    total_marks     INT          NOT NULL CHECK (total_marks > 0),
    weight_percent  DECIMAL(5,2) NOT NULL CHECK (weight_percent BETWEEN 0 AND 100),
    due_date        DATE
);

-- ============================================================
-- TABLE 5: Grades (Student result for each Assessment)
-- ============================================================
CREATE TABLE grades (
    grade_id      SERIAL PRIMARY KEY,
    student_id    INT          NOT NULL REFERENCES students(student_id)   ON DELETE CASCADE,
    assessment_id INT          NOT NULL REFERENCES assessments(assessment_id) ON DELETE CASCADE,
    marks_obtained DECIMAL(6,2) NOT NULL CHECK (marks_obtained >= 0),
    grade_letter  VARCHAR(3),                       -- Computed: A+, A, B+, B, C, D, F
    feedback      TEXT,
    graded_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    UNIQUE(student_id, assessment_id)
);

-- ============================================================
-- TABLE 6: Attendance
-- ============================================================
CREATE TABLE attendance (
    attendance_id        SERIAL PRIMARY KEY,
    student_id           INT  NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id            INT  NOT NULL REFERENCES courses(course_id)   ON DELETE CASCADE,
    total_classes        INT  NOT NULL CHECK (total_classes >= 0),
    classes_present      INT  NOT NULL CHECK (classes_present >= 0),
    classes_absent       INT  NOT NULL CHECK (classes_absent >= 0),
    classes_late         INT  NOT NULL DEFAULT 0 CHECK (classes_late >= 0),
    attendance_pct       DECIMAL(5,2) GENERATED ALWAYS AS 
                         (ROUND((classes_present::DECIMAL / NULLIF(total_classes,0)) * 100, 2)) STORED,
    academic_year        VARCHAR(10) NOT NULL,
    UNIQUE(student_id, course_id, academic_year),
    CONSTRAINT chk_attendance_total 
        CHECK (classes_present + classes_absent + classes_late <= total_classes)
);

-- ============================================================
-- TABLE 7: Final Results (one per student per course)
-- ============================================================
CREATE TABLE final_results (
    result_id     SERIAL PRIMARY KEY,
    student_id    INT          NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id     INT          NOT NULL REFERENCES courses(course_id)   ON DELETE CASCADE,
    percentage    DECIMAL(5,2) NOT NULL CHECK (percentage BETWEEN 0 AND 100),
    grade_letter  VARCHAR(3)   NOT NULL,
    grade_point   DECIMAL(3,2) NOT NULL CHECK (grade_point BETWEEN 0.00 AND 4.00),
    remarks       VARCHAR(100),
    academic_year VARCHAR(10)  NOT NULL,
    UNIQUE(student_id, course_id, academic_year)
);


-- ============================================================
-- SAMPLE DATA (10+ records per table)
-- ============================================================

-- Students
INSERT INTO students (student_no, full_name, email, program, year_of_study, gpa) VALUES
('NSB2024001', 'Ashan Perera',      'ashan.p@nsbm.ac.lk',   'BSc Software Engineering', 2, 3.75),
('NSB2024002', 'Nimasha Silva',     'nimasha.s@nsbm.ac.lk', 'BSc Software Engineering', 2, 3.50),
('NSB2024003', 'Dulshan Fernando',  'dulshan.f@nsbm.ac.lk', 'BSc IT',                   3, 3.20),
('NSB2024004', 'Sachini Jayawardena','sachini.j@nsbm.ac.lk','BSc IT',                   1, 3.90),
('NSB2024005', 'Kaveen Bandara',    'kaveen.b@nsbm.ac.lk',  'BSc CS',                   2, 2.85),
('NSB2024006', 'Tharushi Dissanayake','tharushi.d@nsbm.ac.lk','BSc CS',                 3, 3.10),
('NSB2024007', 'Malith Rajapaksha', 'malith.r@nsbm.ac.lk',  'BSc Software Engineering', 1, 3.65),
('NSB2024008', 'Dinuka Wijesinghe', 'dinuka.w@nsbm.ac.lk',  'BSc IT',                   4, 3.40),
('NSB2024009', 'Rashmi Gunawardena','rashmi.g@nsbm.ac.lk',  'BSc CS',                   2, 2.95),
('NSB2024010', 'Supun Madushanka',  'supun.m@nsbm.ac.lk',   'BSc Software Engineering', 3, 3.80);

-- Courses
INSERT INTO courses (course_code, course_name, credits, lecturer, department) VALUES
('CS301', 'Advanced Database Management Systems', 4, 'S. Naji',        'Computing'),
('CS302', 'Software Engineering',                 4, 'R. Perera',      'Computing'),
('CS303', 'Computer Networks',                    3, 'K. Fernando',    'Computing'),
('CS304', 'Artificial Intelligence',              4, 'M. Silva',       'Computing'),
('CS305', 'Web Technologies',                     3, 'N. Bandara',     'Computing'),
('CS306', 'Operating Systems',                    3, 'T. Wijesekara',  'Computing'),
('CS307', 'Mobile App Development',               3, 'D. Jayawardena', 'Computing'),
('CS308', 'Data Structures & Algorithms',         4, 'A. Rajapaksha',  'Computing'),
('CS309', 'Cloud Computing',                      3, 'S. Gunawardena', 'Computing'),
('CS310', 'Cybersecurity',                        3, 'L. Dissanayake', 'Computing');

-- Enrollments
INSERT INTO enrollments (student_id, course_id, semester, academic_year, status) VALUES
(1, 1, 'Semester 1', '2024/25', 'Active'),
(1, 2, 'Semester 1', '2024/25', 'Active'),
(1, 3, 'Semester 1', '2024/25', 'Active'),
(1, 5, 'Semester 2', '2024/25', 'Active'),
(2, 1, 'Semester 1', '2024/25', 'Active'),
(2, 4, 'Semester 1', '2024/25', 'Active'),
(3, 1, 'Semester 1', '2024/25', 'Completed'),
(3, 6, 'Semester 2', '2024/25', 'Active'),
(4, 2, 'Semester 1', '2024/25', 'Active'),
(5, 3, 'Semester 1', '2024/25', 'Active'),
(6, 7, 'Semester 2', '2024/25', 'Active'),
(7, 8, 'Semester 1', '2024/25', 'Active');

-- Assessments (for course 1 = ADBMS, course 2 = Software Eng)
INSERT INTO assessments (course_id, title, type, total_marks, weight_percent, due_date) VALUES
(1, 'ADBMS Assignment 1',      'Assignment',  100, 20, '2025-03-15'),
(1, 'ADBMS Midterm Exam',      'Midterm',     100, 30, '2025-04-10'),
(1, 'ADBMS Lab Test',          'Lab',          50, 10, '2025-04-20'),
(1, 'ADBMS Final Exam',        'Final Exam',  100, 40, '2025-06-15'),
(2, 'SE Group Project',        'Project',     100, 25, '2025-03-30'),
(2, 'SE Quiz 1',               'Quiz',         50, 10, '2025-03-01'),
(2, 'SE Midterm',              'Midterm',     100, 25, '2025-04-05'),
(2, 'SE Final Exam',           'Final Exam',  100, 40, '2025-06-20'),
(3, 'Networks Assignment',     'Assignment',  100, 20, '2025-03-20'),
(3, 'Networks Final',          'Final Exam',  100, 60, '2025-06-18');

-- Grades (student 1 grades)
INSERT INTO grades (student_id, assessment_id, marks_obtained, grade_letter, feedback, graded_at) VALUES
(1, 1,  88, 'A',  'Excellent work on ER diagrams',                  '2025-03-20 10:00:00'),
(1, 2,  75, 'B+', 'Good understanding of normalization',             '2025-04-15 14:00:00'),
(1, 3,  44, 'A+', 'Perfect lab performance',                        '2025-04-25 09:00:00'),
(1, 4,  82, 'A',  'Strong performance in final exam',               '2025-06-20 16:00:00'),
(1, 5,  90, 'A+', 'Outstanding group project',                      '2025-04-05 11:00:00'),
(1, 6,  42, 'A',  'Good quiz performance',                          '2025-03-05 10:00:00'),
(1, 7,  78, 'B+', 'Good midterm result',                            '2025-04-10 15:00:00'),
(1, 8,  85, 'A',  'Very good final exam',                           '2025-06-25 14:00:00'),
(2, 1,  72, 'B+', 'Good assignment',                                '2025-03-20 10:00:00'),
(2, 2,  68, 'B',  'Needs improvement in indexing topics',           '2025-04-15 14:00:00'),
(3, 1,  55, 'C',  'Adequate understanding but needs more practice', '2025-03-20 10:00:00');

-- Attendance
INSERT INTO attendance (student_id, course_id, total_classes, classes_present, classes_absent, classes_late, academic_year) VALUES
(1, 1, 40, 38, 1, 1, '2024/25'),
(1, 2, 40, 35, 3, 2, '2024/25'),
(1, 3, 30, 28, 1, 1, '2024/25'),
(1, 5, 30, 30, 0, 0, '2024/25'),
(2, 1, 40, 32, 6, 2, '2024/25'),
(2, 4, 40, 38, 2, 0, '2024/25'),
(3, 1, 40, 25, 12, 3,'2024/25'),
(4, 2, 40, 39, 1, 0, '2024/25'),
(5, 3, 30, 22, 6, 2, '2024/25'),
(6, 7, 30, 29, 0, 1, '2024/25'),
(7, 8, 40, 36, 3, 1, '2024/25');

-- Final Results
INSERT INTO final_results (student_id, course_id, percentage, grade_letter, grade_point, remarks, academic_year) VALUES
(1, 1, 83.5, 'A',  3.70, 'Distinction',    '2024/25'),
(1, 2, 86.0, 'A+', 4.00, 'High Distinction','2024/25'),
(1, 3, 90.0, 'A+', 4.00, 'High Distinction','2024/25'),
(2, 1, 70.0, 'B+', 3.30, 'Credit',         '2024/25'),
(2, 4, 65.0, 'B',  3.00, 'Credit',         '2024/25'),
(3, 1, 58.0, 'C+', 2.30, 'Pass',           '2024/25'),
(4, 2, 94.0, 'A+', 4.00, 'High Distinction','2024/25'),
(5, 3, 72.0, 'B+', 3.30, 'Credit',         '2024/25'),
(6, 7, 88.0, 'A',  3.70, 'Distinction',    '2024/25'),
(7, 8, 79.0, 'B+', 3.30, 'Credit',         '2024/25'),
(8, 9, 62.0, 'B',  3.00, 'Credit',         '2024/25'),
(9, 10,55.0, 'C+', 2.30, 'Pass',           '2024/25');


-- ============================================================
-- VIEWS (Section 3 requirement - at least 2 views)
-- ============================================================

-- View 1: Student GPA Overview
CREATE OR REPLACE VIEW vw_student_gpa_overview AS
SELECT 
    s.student_id,
    s.student_no,
    s.full_name,
    s.program,
    s.year_of_study,
    COUNT(DISTINCT fr.course_id)        AS courses_completed,
    ROUND(AVG(fr.grade_point), 2)       AS calculated_gpa,
    SUM(c.credits)                      AS total_credits
FROM students s
LEFT JOIN final_results fr ON s.student_id = fr.student_id
LEFT JOIN courses c        ON fr.course_id  = c.course_id
GROUP BY s.student_id, s.student_no, s.full_name, s.program, s.year_of_study;

-- View 2: Course Grade Distribution
CREATE OR REPLACE VIEW vw_course_grade_distribution AS
SELECT 
    c.course_code,
    c.course_name,
    COUNT(fr.result_id)                                        AS total_students,
    ROUND(AVG(fr.percentage), 2)                               AS avg_percentage,
    COUNT(CASE WHEN fr.grade_letter IN ('A+','A') THEN 1 END) AS grade_a_count,
    COUNT(CASE WHEN fr.grade_letter IN ('B+','B') THEN 1 END) AS grade_b_count,
    COUNT(CASE WHEN fr.grade_letter IN ('C+','C') THEN 1 END) AS grade_c_count,
    COUNT(CASE WHEN fr.grade_letter = 'F'         THEN 1 END) AS grade_f_count
FROM courses c
LEFT JOIN final_results fr ON c.course_id = fr.course_id
GROUP BY c.course_id, c.course_code, c.course_name;

-- View 3: Student Attendance Risk (students below 75%)
CREATE OR REPLACE VIEW vw_attendance_risk AS
SELECT 
    s.student_no,
    s.full_name,
    c.course_name,
    a.attendance_pct,
    CASE 
        WHEN a.attendance_pct < 50  THEN 'Critical'
        WHEN a.attendance_pct < 75  THEN 'At Risk'
        ELSE 'Good'
    END AS status
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN courses  c ON a.course_id  = c.course_id
WHERE a.attendance_pct < 75;


-- ============================================================
-- TRIGGERS (Section 3 requirement - at least 2 triggers)
-- ============================================================

-- Trigger 1: Auto-calculate grade letter when a grade is inserted/updated
CREATE OR REPLACE FUNCTION fn_calculate_grade_letter()
RETURNS TRIGGER AS $$
DECLARE
    v_total_marks   INT;
    v_percentage    DECIMAL(5,2);
BEGIN
    SELECT total_marks INTO v_total_marks 
    FROM assessments WHERE assessment_id = NEW.assessment_id;
    
    v_percentage := (NEW.marks_obtained / v_total_marks::DECIMAL) * 100;
    
    NEW.grade_letter := CASE
        WHEN v_percentage >= 90 THEN 'A+'
        WHEN v_percentage >= 80 THEN 'A'
        WHEN v_percentage >= 75 THEN 'B+'
        WHEN v_percentage >= 65 THEN 'B'
        WHEN v_percentage >= 55 THEN 'C+'
        WHEN v_percentage >= 50 THEN 'C'
        WHEN v_percentage >= 40 THEN 'D'
        ELSE 'F'
    END;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_auto_grade_letter
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW EXECUTE FUNCTION fn_calculate_grade_letter();

-- Trigger 2: Log when final results are updated (audit trail)
CREATE TABLE IF NOT EXISTS audit_log (
    log_id      SERIAL PRIMARY KEY,
    table_name  VARCHAR(50),
    action      VARCHAR(10),
    record_id   INT,
    changed_at  TIMESTAMP DEFAULT NOW(),
    changed_by  VARCHAR(100) DEFAULT CURRENT_USER
);

CREATE OR REPLACE FUNCTION fn_audit_final_results()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log(table_name, action, record_id)
    VALUES ('final_results', TG_OP, NEW.result_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_audit_final_results
AFTER INSERT OR UPDATE ON final_results
FOR EACH ROW EXECUTE FUNCTION fn_audit_final_results();


-- ============================================================
-- FUNCTIONS (Section 3 requirement - at least 2 functions)
-- ============================================================

-- Function 1: Get student GPA
CREATE OR REPLACE FUNCTION fn_get_student_gpa(p_student_id INT)
RETURNS DECIMAL(3,2) AS $$
DECLARE
    v_gpa DECIMAL(3,2);
BEGIN
    SELECT ROUND(
        SUM(fr.grade_point * c.credits)::DECIMAL / NULLIF(SUM(c.credits), 0)
    , 2)
    INTO v_gpa
    FROM final_results fr
    JOIN courses c ON fr.course_id = c.course_id
    WHERE fr.student_id = p_student_id;
    
    RETURN COALESCE(v_gpa, 0.00);
END;
$$ LANGUAGE plpgsql;

-- Function 2: Get grade letter from percentage
CREATE OR REPLACE FUNCTION fn_percentage_to_grade(p_percentage DECIMAL)
RETURNS VARCHAR(3) AS $$
BEGIN
    RETURN CASE
        WHEN p_percentage >= 90 THEN 'A+'
        WHEN p_percentage >= 80 THEN 'A'
        WHEN p_percentage >= 75 THEN 'B+'
        WHEN p_percentage >= 65 THEN 'B'
        WHEN p_percentage >= 55 THEN 'C+'
        WHEN p_percentage >= 50 THEN 'C'
        WHEN p_percentage >= 40 THEN 'D'
        ELSE 'F'
    END;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- STORED PROCEDURES (Section 3 - at least 2)
-- ============================================================

-- Procedure 1: Enroll a student in a course
CREATE OR REPLACE PROCEDURE sp_enroll_student(
    p_student_id   INT,
    p_course_id    INT,
    p_semester     VARCHAR(20),
    p_academic_year VARCHAR(10)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO enrollments(student_id, course_id, semester, academic_year)
    VALUES (p_student_id, p_course_id, p_semester, p_academic_year)
    ON CONFLICT (student_id, course_id, academic_year) DO NOTHING;
    
    RAISE NOTICE 'Student % enrolled in course % for %', 
        p_student_id, p_course_id, p_academic_year;
END;
$$;

-- Procedure 2: Calculate and update final result for a student in a course
CREATE OR REPLACE PROCEDURE sp_calculate_final_result(
    p_student_id    INT,
    p_course_id     INT,
    p_academic_year VARCHAR(10)
)
LANGUAGE plpgsql AS $$
DECLARE
    v_percentage   DECIMAL(5,2);
    v_grade_letter VARCHAR(3);
    v_grade_point  DECIMAL(3,2);
    v_remarks      VARCHAR(100);
BEGIN
    -- Weighted average across all assessments in this course
    SELECT ROUND(
        SUM((g.marks_obtained / a.total_marks::DECIMAL) * a.weight_percent) / 
        NULLIF(SUM(a.weight_percent), 0)
    , 2)
    INTO v_percentage
    FROM grades g
    JOIN assessments a ON g.assessment_id = a.assessment_id
    WHERE g.student_id = p_student_id AND a.course_id = p_course_id;

    v_grade_letter := fn_percentage_to_grade(v_percentage);

    v_grade_point := CASE v_grade_letter
        WHEN 'A+' THEN 4.00 WHEN 'A'  THEN 3.70
        WHEN 'B+' THEN 3.30 WHEN 'B'  THEN 3.00
        WHEN 'C+' THEN 2.30 WHEN 'C'  THEN 2.00
        WHEN 'D'  THEN 1.00 ELSE 0.00
    END;

    v_remarks := CASE
        WHEN v_percentage >= 90 THEN 'High Distinction'
        WHEN v_percentage >= 75 THEN 'Distinction'
        WHEN v_percentage >= 65 THEN 'Credit'
        WHEN v_percentage >= 50 THEN 'Pass'
        ELSE 'Fail'
    END;

    INSERT INTO final_results(student_id, course_id, percentage, grade_letter, grade_point, remarks, academic_year)
    VALUES (p_student_id, p_course_id, v_percentage, v_grade_letter, v_grade_point, v_remarks, p_academic_year)
    ON CONFLICT (student_id, course_id, academic_year) 
    DO UPDATE SET 
        percentage   = EXCLUDED.percentage,
        grade_letter = EXCLUDED.grade_letter,
        grade_point  = EXCLUDED.grade_point,
        remarks      = EXCLUDED.remarks;

    RAISE NOTICE 'Final result calculated: Student %, Course %, Grade: % (%), GPA: %',
        p_student_id, p_course_id, v_grade_letter, v_percentage, v_grade_point;
END;
$$;
