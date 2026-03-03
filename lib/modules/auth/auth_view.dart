import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient background ────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1B2F),
                  Color(0xFF2D1B3D),
                  Color(0xFF1B1B2F),
                ],
              ),
            ),
          ),

          // ── Decorative blobs ──────────────────────────────
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.15),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.xl),

                  // Logo + brand
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.15),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text('🍽️', style: TextStyle(fontSize: 36)),
                          ),
                        )
                            .animate()
                            .scale(
                              curve: Curves.elasticOut,
                              duration: 600.ms,
                            )
                            .fadeIn(),
                        const SizedBox(height: AppDimensions.sm),
                        const Text(
                          'NulEat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // ── Glass card ────────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.lg),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusXl),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Mode toggle ───────────────
                                _ModeToggle(controller: controller),
                                const SizedBox(height: AppDimensions.lg),

                                // ── Email field ───────────────
                                _buildLabel('Email'),
                                const SizedBox(height: AppDimensions.xs),
                                _AuthField(
                                  hint: 'Enter your email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (v) => controller.email.value = v,
                                ),
                                const SizedBox(height: AppDimensions.md),

                                // ── Password field ────────────
                                _buildLabel('Password'),
                                const SizedBox(height: AppDimensions.xs),
                                _AuthField(
                                  hint: 'Enter your password',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: controller.obscurePassword.value,
                                  onChanged: (v) =>
                                      controller.password.value = v,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.obscurePassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                  ),
                                ),

                                // ── Confirm password (sign up only) ──
                                if (!controller.isLogin.value) ...[
                                  const SizedBox(height: AppDimensions.md),
                                  _buildLabel('Confirm Password'),
                                  const SizedBox(height: AppDimensions.xs),
                                  _AuthField(
                                    hint: 'Re-enter your password',
                                    icon: Icons.lock_outline_rounded,
                                    obscure: controller.obscureConfirm.value,
                                    onChanged: (v) =>
                                        controller.confirmPassword.value = v,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.obscureConfirm.value
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                      onPressed:
                                          controller.toggleConfirmVisibility,
                                    ),
                                  ),
                                ],

                                // ── Forgot password (login only) ──
                                if (controller.isLogin.value) ...[
                                  const SizedBox(height: AppDimensions.sm),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: AppColors.primaryLight,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: AppDimensions.lg),

                                // ── Submit button ─────────────
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusLg),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            controller.isLogin.value
                                                ? 'Sign In'
                                                : 'Create Account',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15),

                  const SizedBox(height: AppDimensions.lg),

                  // ── Divider ───────────────────────────────
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                              color: Colors.white.withValues(alpha: 0.2))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.sm),
                        child: Text('or',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12)),
                      ),
                      Expanded(
                          child: Divider(
                              color: Colors.white.withValues(alpha: 0.2))),
                    ],
                  ).animate().fadeIn(delay: 450.ms),

                  const SizedBox(height: AppDimensions.lg),

                  // ── Social buttons ────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          label: 'Google',
                          emoji: '🇬',
                          onTap: controller.continueAsGuest,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: _SocialButton(
                          label: 'Apple',
                          emoji: '🍎',
                          onTap: controller.continueAsGuest,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: AppDimensions.xl),

                  // ── Guest link ────────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: controller.continueAsGuest,
                      child: Text.rich(
                        TextSpan(
                          text: 'Just browsing?  ',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13),
                          children: const [
                            TextSpan(
                              text: 'Continue as guest →',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: AppDimensions.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ── Mode toggle (Login / Sign Up tabs) ──────────────────────────────────────
class _ModeToggle extends StatelessWidget {
  final AuthController controller;
  const _ModeToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Row(
            children: [
              _tab('Sign In', controller.isLogin.value, () {
                if (!controller.isLogin.value) controller.toggleMode();
              }),
              _tab('Sign Up', !controller.isLogin.value, () {
                if (controller.isLogin.value) controller.toggleMode();
              }),
            ],
          ),
        ));
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDimensions.animNormal,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white54,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                fontSize: AppDimensions.textMd,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable dark text field ─────────────────────────────────────────────────
class _AuthField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon;

  const _AuthField({
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: TextField(
        obscureText: obscure,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.35), fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.primaryLight, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md, vertical: 14),
        ),
      ),
    );
  }
}

// ── Social login button ──────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;

  const _SocialButton(
      {required this.label, required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
