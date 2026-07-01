import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/presentation/pages/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const ResetPasswordScreen(),
      ),
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
                    'assets/images/forgot_password_center.png',
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Forgot Password',
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
                const SizedBox(height: 18),
                const Text(
                  "Enter your email below. We'll send you instructions\n"
                  'to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        color: Color(0x22000000),
                        offset: Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Please enter your email.';
                    if (!text.contains('@')) return 'Enter a valid email.';
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF1B1B1B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                      borderSide: const BorderSide(
                        color: Color(0xFFC8C8C8),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Color(0xFF237FBE),
                        width: 1.8,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.4,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: SizedBox(
                    height: 58,
                    child: FilledButton(
                      onPressed: _sendResetLink,
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
                      child: const Text('Send'),
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
