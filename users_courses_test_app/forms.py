from django import forms
from users_courses_test_app.models import Users

class UserForm(forms.ModelForm):
    user_name = forms.CharField(max_length=30)
    user_email = forms.EmailField(max_length=40)
    user_status = forms.IntegerField()

    class Meta:
        model = Users
        fields = ['user_name', 'user_email', 'user_status']