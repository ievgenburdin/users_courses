from django.db import models

class Courses(models.Model):
    course_id = models.AutoField(primary_key=True)
    course_name = models.CharField(max_length=20)
    course_code = models.CharField(unique=True, max_length=10)

    class Meta:
        db_table = 'courses'
        verbose_name_plural = 'Courses'
        unique_together = (('course_code'),)

    def __str__(self):
        return self.course_name

class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    user_name = models.CharField(max_length=30)
    user_email = models.CharField(unique=True, max_length=40)
    user_status = models.IntegerField(blank=True, null=True)

    class Meta:
        db_table = 'users'
        verbose_name_plural = 'Users'
        unique_together = (('user_email'),)

    def __str__(self):
        return self.user_name

class UserCourse(models.Model):
    user = models.ForeignKey('Users', models.ManyToOneRel)
    course = models.ForeignKey('Courses', models.ManyToOneRel)

    class Meta:
        db_table = 'user_course'
        verbose_name_plural = 'Stadying'
        unique_together = (('user', 'course'),)

    def __str__(self):
        return ("%s %s".format(self.user_id, self.course_id))