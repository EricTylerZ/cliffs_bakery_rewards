from rest_framework import viewsets
from rest_framework.decorators import action, api_view
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from .models import Coupon, UserProfile
from .serializers import CouponSerializer, UserProfileSerializer
from django.contrib.auth.models import User

class CouponViewSet(viewsets.ModelViewSet):
    queryset = Coupon.objects.all()
    serializer_class = CouponSerializer

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [IsAuthenticated]

    @action(detail=True, methods=['post'])
    def award_points(self, request, pk=None):
        profile = self.get_object()
        profile.award_daily_points()
        return Response({'status': 'points awarded', 'points': profile.points})

@api_view(['POST'])
def register_user(request):
    username = request.data.get('username')
    password = request.data.get('password')
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already taken'}, status=400)
    user = User.objects.create_user(username=username, password=password)
    return Response({'status': 'User created'}, status=201)