from django.contrib import admin
from django.db.models import Count
from django.shortcuts import render

from .models import (Faculty, Subject, Group, Professor, Mark, Student, Elder, Schedule)


class ElderInline(admin.StackedInline):
    model = Elder
    extra = 0
    fields = ['student', 'group']


class GroupInline(admin.StackedInline):
    model = Group
    extra = 0
    fields = ['number', 'faculty']


class StudentInline(admin.StackedInline):
    model = Student
    extra = 0
    fields = ['name', 'email']


class ProfessorInline(admin.StackedInline):
    model = Professor
    extra = 0
    fields = ['name', 'email']


class SubjectInline(admin.StackedInline):
    model = Subject
    extra = 0
    fields = ['name', 'faculty']


class MarkInline(admin.StackedInline):
    model = Mark
    extra = 0
    fields = ['subject', 'mark']


class ScheduleInline(admin.StackedInline):
    model = Schedule
    extra = 0
    fields = ['professor', 'subject', 'group', 'lesson_type', 'day_of_week', 'start_time', 'cabinet']


class FacultyAdmin(admin.ModelAdmin):
    list_display = ('name',)
    list_filter = ('name',)
    inlines = [GroupInline, SubjectInline]


class ProfessorAdmin(admin.ModelAdmin):
    list_display = ('name', 'email')
    list_filter = ('subjects',)
    filter_horizontal = ['subjects', 'groups']

    actions = ['view_students', 'count_students']

    def view_students(self, request, queryset):
        return render(request, 'admin/view_students.html', {'professors': queryset})

    def count_students(self, request, queryset):
        sorted_professors = queryset.annotate(student_count=Count('groups__students')).order_by(
            '-student_count', 'name')
        return render(request, 'admin/count_students.html', {'professors': sorted_professors})

    view_students.short_description = 'Show students'
    count_students.short_description = 'Count students'


class SubjectAdmin(admin.ModelAdmin):
    list_display = ('name', 'faculty')
    filter_horizontal = ['professors']
    list_filter = ('faculty',)

    class ProfessorInline(admin.StackedInline):
        model = Professor.subjects.through
        extra = 1


class StudentAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'group', 'average_mark')
    list_filter = ('group',)
    inlines = [MarkInline]
    search_fields = ('name',)


class GroupAdmin(admin.ModelAdmin):
    list_display = ('number', 'faculty', 'elder', 'average_mark')
    list_filter = ('faculty', 'elder')
    filter_horizontal = ['professors']
    inlines = [ElderInline, StudentInline]


class ElderAdmin(admin.ModelAdmin):
    list_display = ('student', 'group')


class ScheduleAdmin(admin.ModelAdmin):
    list_display = (
        'professor', 'subject', 'group', 'lesson_type', 'day_of_week', 'start_time', 'cabinet')
    list_filter = ('professor', 'subject', 'group')
    search_fields = ('professor__name',)


admin.site.register(Faculty, FacultyAdmin)
admin.site.register(Subject, SubjectAdmin)
admin.site.register(Professor, ProfessorAdmin)
admin.site.register(Group, GroupAdmin)
admin.site.register(Student, StudentAdmin)
admin.site.register(Elder, ElderAdmin)
admin.site.register(Schedule, ScheduleAdmin)
