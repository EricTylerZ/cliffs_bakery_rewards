import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliff’s Bakery Rewards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00918B)),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFFF5E8C7),
      ),
      home: const AuthCheckPage(),
    );
  }
}

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CouponsPage(token: token)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CouponsPage(token: data['access'])),
      );
    } else {
      setState(() => _errorMessage = 'Login failed—check username and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Welcome to Cliff’s Bakery Rewards'),
        actions: [
          IconButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF00918B)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/menuimage1.png',
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80),
                  ),
                  const SizedBox(height: 8),
                  const Text('Cliff’s Bakery Rewards', style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              title: const Text('Coupons'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Sign In'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text('Sign Up'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Call Eric Zosso at (219) 241-3354 to schedule an Interview for your Mobile App Developer role at Natural Grocers'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  Future<void> _signup() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      setState(() => _message = 'Signup successful! Please log in.');
    } else {
      setState(() => _message = 'Signup failed—try a different username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sign Up'),
        actions: [
          IconButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF00918B)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/menuimage1.png',
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80),
                  ),
                  const SizedBox(height: 8),
                  const Text('Cliff’s Bakery Rewards', style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              title: const Text('Coupons'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Sign In'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Sign Up'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Call Eric Zosso at (219) 241-3354 to schedule an Interview for your Mobile App Developer role at Natural Grocers'),
              ),
              if (_message.isNotEmpty)
                Text(_message, style: const TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}

class CouponsPage extends StatefulWidget {
  final String token;

  const CouponsPage({super.key, required this.token});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  List<dynamic> coupons = [];
  List<String> clippedCoupons = [];
  int points = 0;
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchCoupons();
    _awardPoints();
  }

  Future<void> _fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/profiles/me/'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        username = data['username'];
        email = data['email'];
        points = data['points'];
        clippedCoupons = List<String>.from(data['clipped_coupons'] ?? []);
      });
    } else {
      _logout(context); // Logout on auth failure
    }
  }

  Future<void> _fetchCoupons() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/coupons/'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      setState(() => coupons = jsonDecode(response.body));
    } else {
      _logout(context); // Logout on auth failure
    }
  }

  Future<void> _awardPoints() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/profiles/award_points/'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      await _fetchUserData(); // Refresh user data after awarding points
    } else {
      _logout(context); // Logout on auth failure
    }
  }

  Future<void> _clipCoupon(String title) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/profiles/clip_coupon/'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: jsonEncode({'coupon_title': title}),
    );
    if (response.statusCode == 200) {
      await _fetchUserData(); // Refresh user data after clipping
    } else {
      _logout(context); // Logout on auth failure
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cliff’s Bakery Rewards'),
        actions: [
          IconButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(
                  token: widget.token,
                  points: points,
                  username: username,
                  email: email,
                  clippedCoupons: clippedCoupons,
                )),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF00918B)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/menuimage1.png',
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80),
                  ),
                  const SizedBox(height: 8),
                  const Text('Cliff’s Bakery Rewards', style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              title: const Text('Coupons'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(
                    token: widget.token,
                    points: points,
                    username: username,
                    email: email,
                    clippedCoupons: clippedCoupons,
                  )),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Bakery Reward Points: $points', style: const TextStyle(fontSize: 20)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final title = coupon['title'];
                final imagePath = 'assets/images/${coupon['image']}';
                return Card(
                  color: Color(0xFFEAD9A8),
                  child: Column(
                    children: [
                      Image.asset(
                        imagePath,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 120),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          coupon['description'],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: clippedCoupons.contains(title) ? null : () => _clipCoupon(title),
                        child: Text(clippedCoupons.contains(title) ? 'Clipped' : 'Clip'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Call Eric Zosso at (219) 241-3354 to schedule an Interview for your Mobile App Developer role at Natural Grocers'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String token;
  final int points;
  final String username;
  final String email;
  final List<String> clippedCoupons;

  const ProfilePage({
    super.key,
    required this.token,
    required this.points,
    required this.username,
    required this.email,
    required this.clippedCoupons,
  });

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Username: $username'),
              Text('Email: $email'),
              Text('Bakery Reward Points: $points'),
              const SizedBox(height: 16),
              const Text('Clipped Coupons:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (clippedCoupons.isEmpty)
                const Text('No coupons clipped yet.')
              else
                Column(
                  children: clippedCoupons.map((coupon) => Text(coupon)).toList(),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text('Logout'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Call Eric Zosso at (219) 241-3354 to schedule an Interview for your Mobile App Developer role at Natural Grocers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}