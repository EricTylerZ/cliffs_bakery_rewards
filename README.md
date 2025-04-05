# Cliffs Bakery Rewards - Prototype Rewards Program

## Overview
Cliffs Bakery Rewards is a prototype mobile app developed as a proof-of-concept for a bakery rewards system. Built in **1.5 days** (April 3-4, 2025), this project demonstrates a fully functional web-based application with plans for iOS/Android expansion. It features user authentication, a coupon management system with dynamic image loading, and persistent data storage.

## Features
- **User Authentication**: Secure login/signup with JWT via Django REST Framework, persisting across sessions using SharedPreferences.
- **Coupon Management**: Dynamic grid of bakery coupons with images fetched from the backend (stored as filenames in MySQL), allowing users to clip for points.
- **Rewards System**: Users earn 2 daily points on login and 1 point per unique coupon clipped, managed via MySQL and REST APIs.
- **Profile Dashboard**: Fetches user data (username, email, points, clipped coupons) dynamically from the backend.

## Tech Stack
- **Frontend**: Flutter/Dart - Cross-platform UI framework for rapid, responsive design.
- **Backend**: Django/Python - RESTful API server with MySQL integration.
- **Database**: MySQL - Relational database for scalable data management.
- **Tools**: 
  - Git - Version control.
  - SharedPreferences - Persistent state.
  - Vercel - Web deployment (pending).

## Setup (Local Development)
1. **Backend**:
   - `cd backend`
   - `pip install -r requirements.txt` (includes `Django`, `djangorestframework`, `mysqlclient`)
   - `python manage.py migrate`
   - `python manage.py runserver`
2. **Frontend**:
   - `cd ..`
   - `flutter pub get`
   - `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0`
   - Access at `http://localhost:8080`.

## Deployment
- **Frontend**: Deploy to Vercel:
  - `flutter build web --release`
  - `cd build/web && vercel`
- **Backend**: Local for now—Railway setup available.

## Project Structure
- `backend/`: Django server with API endpoints (`/api/token/`, `/api/coupons/`, `/api/profiles/`).
- `lib/`: Flutter frontend with `main.dart`.
- `assets/images/`: Coupon images (`coupon1.png` to `coupon4.png`) and menu image (`menuimage1.png`).

## Future Enhancements
- Backend hosting on Railway for a live demo.
- iOS/Android builds with Flutter.
- Enhanced UI with redemption tracking.