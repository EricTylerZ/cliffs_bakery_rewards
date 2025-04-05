from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from django.db.models.signals import post_save
from django.dispatch import receiver
import json

class Coupon(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    image = models.CharField(max_length=255, default='coupon1.png')  # New field for image filename
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    points = models.IntegerField(default=0)
    last_point_awarded = models.DateTimeField(null=True, blank=True)
    clipped_coupons = models.TextField(default='[]')  # JSON string for MySQL

    def award_daily_points(self):
        now = timezone.now()
        today = now.date()
        if not self.last_point_awarded or self.last_point_awarded.date() < today:
            self.points += 2
            self.last_point_awarded = now
            self.save()

    def get_clipped_coupons(self):
        return json.loads(self.clipped_coupons)

    def set_clipped_coupons(self, coupons):
        self.clipped_coupons = json.dumps(coupons)

    def __str__(self):
        return f"{self.user.username}'s Profile"

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)