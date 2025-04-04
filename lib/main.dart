import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(CliffsBakeryRewardsApp());
}

class CliffsBakeryRewardsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliff’s Bakery Rewards',
      theme: ThemeData(
        primaryColor: Color(0xFF00918B),  // Royal Tourqouise
        scaffoldBackgroundColor: Color(0xFFF5E8C7),  // Cream
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFF4A2F1A)),  // Darker brown
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF00918B),
            onPrimary: Colors.white,
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _emailController.text,
        'password': 'AdminP@ss123',  // Replace with actual password
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CouponsScreen()),
      );
    } else {
      setState(() => _errorMessage = 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email or Phone'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty) Text(_errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class CouponsScreen extends StatefulWidget {
  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  List<dynamic> coupons = [];
  int points = 0;

  @override
  void initState() {
    super.initState();
    _fetchCoupons();
    _awardPoints();
  }

  Future<void> _fetchCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/coupons/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() => coupons = jsonDecode(response.body));
    }
  }

  Future<void> _awardPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/profiles/1/award_points/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => points = data['points']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coupons')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Your Points: $points', style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xFFEAD9A8),  // Light tan
                  child: ListTile(
                    title: Text(coupons[index]['title']),
                    subtitle: Text(coupons[index]['description']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}