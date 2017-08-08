from django.shortcuts import render
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.http import HttpResponseRedirect, HttpResponse
from users_courses_test_app.models import Users, Courses
from users_courses_test_app.forms import UserForm


def root(request):
    return HttpResponseRedirect("/users/?name=&qty=15")

def users(request):
    num_row = request.GET.get('qty')
    if not num_row:
        num_row = 15
    page = request.GET.get('page')
    user_list = [user for user in Users.objects.raw('CALL get_users()')]
    paginator = Paginator(user_list, num_row)
    try:
        users = paginator.page(page)
    except PageNotAnInteger:
        #if first page
        users = paginator.page(1)
    except EmptyPage:
        #if number out of range
        users = paginator.page(paginator.num_pages)
    context_dict = {'users_data': users}
    return render(request, "users.html", context_dict)

def get_users(request):
    if request.method == 'GET':
        name_user = request.GET['name']
        qty = request.GET['qty']
        return None

def courses(request):
    courses_list = [course for course in Courses.objects.raw('CALL get_courses()')]
    context_dict = {'courses_data': courses_list}
    return render(request, "courses.html", context_dict)

def create_user(request):
    if request.method == 'POST':
        form = UserForm(request.POST)
        if form.is_valid():
            form.save(commit=True)
            return HttpResponseRedirect('/users/')# TEMP REDIRECT
    elif request.method == "GET":
        return render(request, "create_user.html")

def change_user(request):
    context_dict = {'message': "Change user Page"}
    return render(request, "change_user.html", context=context_dict)

def search(request):
    pass
