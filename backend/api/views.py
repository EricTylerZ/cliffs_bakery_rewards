from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Coupon, UserProfile
from .serializers import CouponSerializer, UserProfileSerializer

class CouponViewSet(viewsets.ModelViewSet):
    queryset = Coupon.objects.all()
    serializer_class = CouponSerializer

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

    @action(detail=True, methods=['post'])
    def award_points(self, request, pk=None):
        profile = self.get_object()
        profile.award_daily_points()
        return Response({'status': 'points awarded', 'points': profile.points})
