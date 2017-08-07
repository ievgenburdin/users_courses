from django import forms
from users_courses_test_app.models import Users

class UserForm(forms.ModelForm):
    name = forms.CharField(max_length=30)
    email = forms.EmailField(max_length=40)
    status = forms.IntegerField()

    class Meta:
        model = Users
        fields = ['name', 'email', 'status']