from django.urls import path, include
from task_api.views import CreateTask
from django.contrib import admin

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('task_api.url')),  
]
