import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Password has been reset successfully.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: const Offset(-14, 0),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Color(0xFF202020),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Center(
                  child: Image.asset(
                    'assets/images/reset_password_center.png',
                    width: 230,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reset Password',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 30,
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
                const SizedBox(height: 38),
                _PasswordField(
                  controller: _newPasswordController,
                  hintText: 'New Password',
                  validator: (value) {
                    final text = value ?? '';
                    if (text.isEmpty) return 'Please enter a new password.';
                    if (text.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                _PasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  validator: (value) {
                    final text = value ?? '';
                    if (text.isEmpty) {
                      return 'Please confirm your password.';
                    }
                    if (text != _newPasswordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: SizedBox(
                    height: 58,
                    child: FilledButton(
                      onPressed: _resetPassword,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF237FBE),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: const Text('Reset Password'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 19,
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
