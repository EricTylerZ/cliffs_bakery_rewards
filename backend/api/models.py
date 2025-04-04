from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

class Coupon(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    points = models.IntegerField(default=0)
    last_point_awarded = models.DateTimeField(null=True, blank=True)

    def award_daily_points(self):
        now = timezone.now()
        today = now.date()
        if not self.last_point_awarded or self.last_point_awarded.date() < today:
            self.points += 2
            self.last_point_awarded = now
            self.save()

    def __str__(self):
        return f"{self.user.username}'s Profile"
