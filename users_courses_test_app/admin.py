from django.contrib import admin
from users_courses_test_app.models import Users, Courses, UserCourse

class UsersAdmin(admin.ModelAdmin):
    list_display = ('user_name', 'user_email', 'user_status')

class CoursesAdmin(admin.ModelAdmin):
    list_display = ('course_name', 'course_code')

class UserCourseAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'course_id')


admin.site.register(Courses, CoursesAdmin)
admin.site.register(UserCourse, UserCourseAdmin)
admin.site.register(Users, UsersAdmin)


