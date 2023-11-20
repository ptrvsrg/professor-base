INSERT INTO faculties(name)
VALUES ('Институт гуманитарных наук'),
       ('Институт медицины и психологии имени Зельмана'),
       ('Институт философии и права'),
       ('Факультет физики'),
       ('Факультет естественных наук'),
       ('Факультет экономики'),
       ('Факультет математики и механики'),
       ('Факультет информационных технологий'),
       ('Факультет геологии и геофизики');
INSERT INTO subjects(name, faculty_id)
VALUES ('Методы трансляции и компиляции', (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       ('Сети и телекоммуникации', (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       ('Электротехника и электроника',(SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       ('Базы данных', (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       ('Вычислительная математика', (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       ('Операционные системы', (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       ('Объектно-ориентированный анализ и дизайн', (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий'));
INSERT INTO professors(name, email)
VALUES ('Марьясов И. В.', 'i.maryasov@g.nsu.ru'),
       ('Епишин И. С.', 'i.epishin@g.nsu.ru'),
       ('Соломатин Б. Н.', 'b.solomatin@g.nsu.ru'),
       ('Мокроусов А. С.', 'a.mokrousov@g.nsu.ru'),
       ('Полунина Е. И.', 'e.polunina@g.nsu.ru'),
       ('Рудометов А. С.', 'a.rudometov@g.nsu.ru'),
       ('Воронов А. А.', 'a.voronov@g.nsu.ru');
INSERT INTO groups(number, faculty_id)
VALUES (21207, (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий')),
       (21211, (SELECT (id) FROM faculties WHERE name = 'Факультет информационных технологий'));
INSERT INTO professors_subjects(subject_id, professor_id)
VALUES ((SELECT (id) FROM subjects WHERE name = 'Операционные системы'),
        (SELECT (id) FROM professors WHERE name = 'Рудометов А. С.')),
       ((SELECT (id) FROM subjects WHERE name = 'Сети и телекоммуникации'),
        (SELECT (id) FROM professors WHERE name = 'Епишин И. С.')),
       ((SELECT (id) FROM subjects WHERE name = 'Вычислительная математика'),
        (SELECT (id) FROM professors WHERE name = 'Полунина Е. И.')),
       ((SELECT (id) FROM subjects WHERE name = 'Электротехника и электроника'),
        (SELECT (id) FROM professors WHERE name = 'Соломатин Б. Н.')),
       ((SELECT (id) FROM subjects WHERE name = 'Базы данных'),
        (SELECT (id) FROM professors WHERE name = 'Мокроусов А. С.')),
       ((SELECT (id) FROM subjects WHERE name = 'Методы трансляции и компиляции'),
        (SELECT (id) FROM professors WHERE name = 'Марьясов И. В.')),
       ((SELECT (id) FROM subjects WHERE name = 'Объектно-ориентированный анализ и дизайн'),
        (SELECT (id) FROM professors WHERE name = 'Воронов А. А.'));
INSERT INTO students(name, email, group_id)
VALUES ('Беляев В.М.', 'v.belyaev@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Борисов Д.М.', 'd.borisov@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Ванаг Н.С.', 'n.vanag@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Виолин А.Ф.', 'a.violin@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Катаева М.Д.', 'm.kataeva@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Никитин Б.М.', 'b.nikitin@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Помогаев М.П.', 'm.pomogaev@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Степанюк В.В.', 'v.stepanyuk@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Фомин А.Т.', 'a.fomin@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Хорошев Д.А.', 'd.khoroshev@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Черновская Я.Т.', 'y.chernovskaya@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21207)),
       ('Авдеев В.С.', 'v.avdeev@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Адамович А.А.', 'a.adamovich@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Болотов К.Ю.', 'k.bolotov@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Завороткина Я.С.', 'y.zavorotkina@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Идрисова М.А.', 'm.idrisova@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Косолап М.А.', 'm.kosolap@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Котельникова Н.А.', 'n.kotelnikova@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Малышев В.О.', 'v.malyshev@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Михалёв М.А.', 'm.mikhalev@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Петров С.Е.', 's,petrov1@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Трушков С.В.', 's.trushkov@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211)),
       ('Шапатин А.А.', 'a.shapatin@g.nsu.ru', (SELECT (id) FROM groups WHERE number = 21211));
INSERT INTO professors_groups(group_id, professor_id)
VALUES ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Рудометов А. С.')),
       ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Епишин И. С.')),
       ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Полунина Е. И.')),
       ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Соломатин Б. Н.')),
       ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Мокроусов А. С.')),
       ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Марьясов И. В.')),
       ((SELECT id FROM groups WHERE number = 21211),
        (SELECT (id) FROM professors WHERE name = 'Воронов А. А.'));
INSERT INTO schedules(professor_id, subject_id, group_id, lesson_type, day_of_week, start_time, cabinet)
VALUES ((SELECT (id) FROM professors WHERE name = 'Марьясов И. В.'),
        (SELECT (id) FROM subjects WHERE name = 'Методы трансляции и компиляции'),
        (SELECT id FROM groups WHERE number = 21211),
        'Практика', 'Понедельник', '9:00:00', '2213');
INSERT INTO elders(student_id, group_id)
VALUES ((SELECT id FROM students WHERE name = 'Ванаг Н.С.'), (SELECT id FROM groups WHERE number = 21207)),
       ((SELECT id FROM students WHERE name = 'Котельникова Н.А.'), (SELECT id FROM groups WHERE number = 21211));
INSERT INTO marks (student_id, subject_id, mark)
SELECT students.id,
       subjects.id,
       FLOOR(RANDOM() * 3) + 3 AS mark
FROM students
         CROSS JOIN subjects;