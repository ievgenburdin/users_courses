from django.shortcuts import render
from django.http import HttpResponse
from django.http import HttpResponseRedirect


def root(request):
    return HttpResponseRedirect("/users/")

def users(request):
    context_dict = {'message':"Users Page"}
    return render(request, "users.html", context = context_dict)

def courses(request):
    context_dict = {'message': "Courses Page"}
    return render(request, "courses.html", context=context_dict)

def create_user(request):
    context_dict = {'message': "Create users Page"}
    return render(request, "create_user.html", context=context_dict)

def change_user(request):
    context_dict = {'message': "Change user Page"}
    return render(request, "change_user.html", context=context_dict)

def search(request):
    pass

