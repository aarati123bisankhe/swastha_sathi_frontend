import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/presentation/pages/login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const _districts = [
    'Kathmandu',
    'Lalitpur',
    'Bhaktapur',
    'Sindhupalchok',
    'Karve',
    'Dadeldhura',
    'Kailali-Kanchanpur',
  ];

  static const _bloodGroups = [
    'A+',
    'O+',
    'B+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-',
  ];

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  String? _selectedDistrict;
  String? _selectedBloodGroup;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 185,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Register for your account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 26,
                  color: const Color(0xFF1D1B8F),
                  fontWeight: FontWeight.w500,
                  shadows: const [
                    Shadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _AuthField(
                controller: _fullNameController,
                hintText: 'Full Name',
              ),
              const SizedBox(height: 14),
              _AuthField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _AuthField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.lock_outline_rounded
                        : Icons.lock_open_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _AuthField(
                controller: _phoneController,
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              _AuthDropdown(
                value: _selectedDistrict,
                hintText: 'Select District',
                items: _districts,
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                },
              ),
              const SizedBox(height: 14),
              _AuthDropdown(
                value: _selectedBloodGroup,
                hintText: 'Blood Group',
                trailingText: 'Optional',
                items: _bloodGroups,
                onChanged: (value) {
                  setState(() {
                    _selectedBloodGroup = value;
                  });
                },
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF237FBE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF006FB7),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 17, color: Color(0xFF1B1B1B)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 20,
          color: Color(0xFF6D6D6D),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 18),
                child: IconTheme(
                  data: const IconThemeData(
                    color: Color(0xFF2E2A32),
                    size: 24,
                  ),
                  child: suffixIcon!,
                ),
              ),
        suffixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(27),
          borderSide: const BorderSide(color: Color(0xFFC2C2C2), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(27),
          borderSide: const BorderSide(color: Color(0xFF237FBE), width: 1.8),
        ),
      ),
    );
  }
}

class _AuthDropdown extends StatelessWidget {
  const _AuthDropdown({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.trailingText,
  });

  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: trailingText == null
          ? const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF767676),
                size: 36,
              ),
            )
          : const SizedBox.shrink(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 20,
          color: Color(0xFF6D6D6D),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        suffixIcon: trailingText == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 22),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailingText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6D6D6D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF767676),
                      size: 32,
                    ),
                  ],
                ),
              ),
        suffixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(27),
          borderSide: const BorderSide(color: Color(0xFFC2C2C2), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(27),
          borderSide: const BorderSide(color: Color(0xFF237FBE), width: 1.8),
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF1B1B1B),
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: Colors.white,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
