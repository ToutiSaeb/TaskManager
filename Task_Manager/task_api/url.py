from django.urls import path
from . import views

urlpatterns = [
    path('addtasks/', views.CreateTask.as_view(), name='create_task'),
    path('affichtasks/', views.AfficheTask.as_view(), name='affiche_task'),
     path('deletetasks/<int:task_id>/', views.DeleteTask.as_view(), name='delete_task'),
      path('updatetasks/<int:task_id>/', views.UpdateTask.as_view(), name='update_task'),

]