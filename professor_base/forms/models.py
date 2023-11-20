from django.db import models
from datetime import time

from django.db.models import Avg


class Faculty(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return f'{self.name}'

    class Meta:
        db_table = 'faculties'
        ordering = ('name',)


class Group(models.Model):
    number = models.PositiveIntegerField()
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE, related_name='groups')

    def __str__(self):
        return f'{self.number}'

    def average_mark(self):
        group_marks = Mark.objects.filter(student__group=self)
        if not group_marks.exists():
            return None
        average_mark = group_marks.aggregate(Avg('mark'))['mark__avg']
        return round(average_mark, 2)

    def elder(self):
        elder = Elder.objects.filter(group=self)
        if not elder.exists():
            return None
        return elder

    class Meta:
        db_table = 'groups'
        ordering = ('faculty', 'number')


class Subject(models.Model):
    name = models.CharField(max_length=100)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE, related_name='subjects')

    def __str__(self):
        return f'{self.name}'

    class Meta:
        db_table = 'subjects'
        ordering = ('faculty', 'name')


class Professor(models.Model):
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100, unique=True)
    groups = models.ManyToManyField(Group, related_name='professors', blank=True)
    subjects = models.ManyToManyField(Subject, related_name='professors')

    def __str__(self):
        return f'{self.name}'

    def get_students_list(self):
        students = Student.objects.filter(group__professors=self).order_by('name')
        return students

    class Meta:
        db_table = 'professors'
        ordering = ('name', 'email')


class Student(models.Model):
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100, unique=True)
    group = models.ForeignKey(Group, on_delete=models.SET_NULL, null=True, blank=True,
                              related_name='students')

    def __str__(self):
        return f'{self.name}'

    def average_mark(self):
        student_marks = Mark.objects.filter(student=self)
        if not student_marks.exists():
            return None
        average_mark = student_marks.aggregate(Avg('mark'))['mark__avg']
        return round(average_mark, 2)

    class Meta:
        db_table = 'students'
        ordering = ('name', 'email')


class Elder(models.Model):
    group = models.OneToOneField(Group, on_delete=models.CASCADE, related_name='elder')
    student = models.ForeignKey(Student, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.student}'

    class Meta:
        db_table = 'elders'
        ordering = ('student', 'group')


class Mark(models.Model):
    MARK_CHOICES = [
        (2, '2'),
        (3, '3'),
        (4, '4'),
        (5, '5'),
    ]
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name='marks')
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE, related_name='marks')
    mark = models.SmallIntegerField(choices=MARK_CHOICES)

    def __str__(self):
        return f'{self.student} - {self.subject} - {self.mark}'

    class Meta:
        db_table = 'marks'
        unique_together = ('student', 'subject')
        ordering = ('student', 'subject')


class Schedule(models.Model):
    LESSON_TYPE_CHOICES = [
        ('Лекция', 'Лекция'),
        ('Практика', 'Практика'),
        ('Лабораторное занятие', 'Лабораторное занятие'),
        ('Факультативное занятие', 'Факультативное занятие'),
    ]

    DAY_OF_WEEK_CHOICES = [
        ('Понедельник', 'Понедельник'),
        ('Вторник', 'Вторник'),
        ('Среда', 'Среда'),
        ('Четверг', 'Четверг'),
        ('Пятница', 'Пятница'),
        ('Субботок', 'Суббота'),
    ]

    START_TIME_CHOICES = [
        (time(9, 0), '09:00:00'),
        (time(10, 50), '10:50:00'),
        (time(12, 40), '12:40:00'),
        (time(14, 30), '14:30:00'),
        (time(16, 20), '16:20:00'),
        (time(18, 10), '18:10:00'),
        (time(20, 0), '20:00:00'),
    ]

    professor = models.ForeignKey(Professor, on_delete=models.CASCADE)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, null=True, blank=True)
    lesson_type = models.CharField(max_length=100, choices=LESSON_TYPE_CHOICES)
    day_of_week = models.CharField(max_length=100, choices=DAY_OF_WEEK_CHOICES)
    start_time = models.TimeField(choices=START_TIME_CHOICES)
    cabinet = models.CharField(max_length=100)

    def __str__(self):
        return f'{self.day_of_week} {self.start_time} - {self.cabinet} - {self.subject} ({self.lesson_type}) - {self.group} - {self.professor}'

    class Meta:
        db_table = 'schedules'