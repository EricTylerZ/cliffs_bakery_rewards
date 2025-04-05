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
    permission_classes = [IsAuthenticated]

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['get'])
    def me(self, request):
        profile = UserProfile.objects.get(user=request.user)
        serializer = UserProfileSerializer(profile)
        return Response({
            'username': request.user.username,
            'email': request.user.email,
            'points': profile.points,
            'clipped_coupons': profile.get_clipped_coupons(),
        })

    @action(detail=False, methods=['post'])  # Collection-level, no ID needed
    def award_points(self, request):
        profile = UserProfile.objects.get(user=request.user)
        profile.award_daily_points()
        return Response({'status': 'points awarded', 'points': profile.points})

    @action(detail=False, methods=['post'])  # Collection-level, no ID needed
    def clip_coupon(self, request):
        profile = UserProfile.objects.get(user=request.user)
        coupon_title = request.data.get('coupon_title')
        clipped = profile.get_clipped_coupons()
        if coupon_title and coupon_title not in clipped:
            clipped.append(coupon_title)
            profile.set_clipped_coupons(clipped)
            profile.points += 1
            profile.save()
        return Response({'status': 'coupon clipped', 'points': profile.points, 'clipped': clipped})

@api_view(['POST'])
def register_user(request):
    username = request.data.get('username')
    password = request.data.get('password')
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already taken'}, status=400)
    user = User.objects.create_user(username=username, password=password)
    return Response({'status': 'User created'}, status=201)