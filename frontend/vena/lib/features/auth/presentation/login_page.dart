import 'package:flutter/material.dart';
import 'package:vena/features/home/presentation/pages/my_page_controller.dart';
import 'package:vena/features/auth/presentation/sign_up.dart';
import 'package:vena/core/widgets/button/alternatif_login_button.dart';
import 'package:vena/core/widgets/my_divider.dart';
import '../logic/cubit/auth_state.dart';
import '../logic/cubit/auth_cubit.dart';
import '../../calendar/logic/cubit/calendar_cubit.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/size.dart';
import '../../../core/widgets/button/auth_button.dart';
import '../../../core/widgets/textfield/auth_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: ScreenSize.getSize(context).height * 0.002),
            Image.asset(
              "assets/logo-icon.png",
              width: ScreenSize.getSize(context).width * 0.5,
              height: ScreenSize.getSize(context).height * 0.2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: ScreenSize.getSize(context).width * 0.9,
                height: ScreenSize.getSize(context).height * 0.45,
                decoration: BoxDecoration(
                  color: AppColors.authPageContainerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) async {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error!)),
                      );
                    }

                    if (state.user != null && state.error == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPageController(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.02),
                        const Text(
                          "Giriş Yap",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _dontHaveAccountText(context),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.02),
                        AuthTextField(
                          labelText: "E-posta adresiniz",
                          icon: Icons.email,
                          onChanged: (val) {
                            context.read<AuthCubit>().emailChanged(val);
                          },
                        ),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.03),
                        AuthTextField(
                          labelText: "Şifreniz",
                          icon: Icons.lock,
                          obscureText: true,
                          onChanged: (val) {
                            context.read<AuthCubit>().passwordChanged(val);
                          },
                        ),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.03),
                        _forgetPasswordText(),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.03),
                        state.isLoading
                            ? const CircularProgressIndicator()
                            : AuthButton(
                                buttonText: "Giriş Yap",
                                onTap: () {
                                  context.read<AuthCubit>().login();
                                },
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.getSize(context).height * 0.03,
            ),
            const MyDivider(),
            SizedBox(
              height: ScreenSize.getSize(context).height * 0.03,
            ),
            AlternatifLoginButton(
              onTap: () async {
                await context.read<AuthCubit>().loginWithGoogle();
                await context.read<CalendarCubit>().fetchPlansFromBackend();
              },
            )
          ],
        ),
      ),
    );
  }

  Row _dontHaveAccountText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Hesabın yok mu ?",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: ScreenSize.getSize(context).height * 0.005),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Signuppage()));
          },
          child: const Text(
            "Kayıt ol",
            style: TextStyle(color: AppColors.signupTextColor, fontSize: 13),
          ),
        )
      ],
    );
  }

  Padding _forgetPasswordText() {
    return const Padding(
      padding: EdgeInsets.only(right: 50),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Şifremi unuttum",
          style: TextStyle(
            color: AppColors.forgetPasswordText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
