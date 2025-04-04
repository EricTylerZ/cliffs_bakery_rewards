from rest_framework import serializers
from .models import Coupon, UserProfile
from django.contrib.auth.models import User

class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = '__all__'

class UserProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    clipped_coupons = serializers.JSONField(source='get_clipped_coupons', read_only=True)

    class Meta:
        model = UserProfile
        fields = ['username', 'points', 'last_point_awarded', 'clipped_coupons']