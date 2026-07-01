import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/features/auth/presentation/pages/login_screen.dart';
import 'package:swasthasathi/app/features/auth/presentation/viewmodels/auth_view_model.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  String? _selectedDistrict;
  String? _selectedBloodGroup;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your district.')),
      );
      return;
    }

    final success = await ref
        .read(authViewModelProvider.notifier)
        .signup(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phoneNumber: _phoneController.text,
          district: _selectedDistrict!,
          bloodGroup: _selectedBloodGroup,
        );

    if (!mounted) return;

    final authState = ref.read(authViewModelProvider);
    final message = authState.errorMessage ?? authState.successMessage;
    if (message != null && message.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      );
    }
  }

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
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 4, 32, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 0),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -16),
                  child: Text(
                    'Register for your account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                      color: const Color(0xFF1D1B8F),
                      fontWeight: FontWeight.w400,
                      shadows: const [
                        Shadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _AuthField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  validator: (value) {
                    if ((value?.trim() ?? '').isEmpty) {
                      return 'Please enter your full name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                _AuthField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Please enter your email.';
                    if (!text.contains('@')) return 'Enter a valid email.';
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                _AuthField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  validator: (value) {
                    final text = value ?? '';
                    if (text.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                _AuthField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if ((value?.trim() ?? '').isEmpty) {
                      return 'Please enter your phone number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                _AuthDropdown(
                  value: _selectedDistrict,
                  hintText: 'Select District',
                  items: _districts,
                  iconRightPadding: 8,
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
                const SizedBox(height: 30),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: authState.isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF237FBE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Register'),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    this.suffixIcon, //suffixicons
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 17, color: Color(0xFF1B1B1B)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          color: Color(0xFF6D6D6D),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : IconTheme(
                data: const IconThemeData(color: Color(0xFF2E2A32), size: 22),
                child: suffixIcon!,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 52,
          minWidth: 52,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFC8C8C8), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF237FBE), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
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
    this.iconRightPadding = 18,
  });

  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? trailingText;
  final double iconRightPadding;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: trailingText == null
          ? Padding(
              padding: EdgeInsets.only(right: iconRightPadding),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF767676),
                size: 34,
              ),
            )
          : const SizedBox.shrink(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          color: Color(0xFF6D6D6D),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),
        suffixIcon: trailingText == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailingText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6D6D6D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF767676),
                      size: 30,
                    ),
                  ],
                ),
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 52,
          minWidth: 52,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFC8C8C8), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF237FBE), width: 1.8),
        ),
      ),
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFF1B1B1B),
        fontWeight: FontWeight.w400,
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
