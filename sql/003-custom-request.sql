SELECT name
FROM students
WHERE name LIKE ('Бо%');

SELECT students.name AS student_name
FROM professors
         JOIN professors_groups ON professors.id = professors_groups.professor_id
         JOIN students ON professors_groups.group_id = students.group_id
WHERE professors.name = 'Мокроусов А. С.'
ORDER BY student_name;

SELECT subjects.name AS subject,
       groups.number AS group_number,
       lesson_type,
       day_of_week,
       start_time,
       cabinet
FROM schedules
         JOIN professors ON professors.id = schedules.professor_id
         LEFT JOIN groups ON groups.id = schedules.group_id
         JOIN subjects ON subjects.id = schedules.subject_id
WHERE professors.name = 'Марьясов И. В.';

SELECT professors.name AS professor_name,
       COUNT(students.id) AS student_count
FROM professors
         JOIN professors_groups ON professors.id = professors_groups.professor_id
         JOIN students ON students.group_id = professors_groups.group_id
GROUP BY professors.name
ORDER BY student_count DESC, professor_name;

SELECT groups.number AS group_number,
       AVG(marks.mark) AS average_mark
FROM groups
         JOIN students ON groups.id = students.group_id
         JOIN marks ON students.id = marks.student_id
GROUP BY groups.number
ORDER BY group_number;

SELECT groups.number AS group_number
FROM groups
         LEFT JOIN elders ON groups.id = elders.group_id
WHERE elders.group_id IS NULL;