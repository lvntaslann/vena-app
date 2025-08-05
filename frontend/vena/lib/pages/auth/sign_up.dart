import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vena/pages/auth/login_page.dart';
import 'package:vena/services/auth/auth_services.dart';

import '../../cubit/auth/auth_state.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../themes/app_colors.dart';
import '../../utils/size.dart';
import '../../widget/button/auth_button.dart';
import '../../widget/button/alternatif_login_button.dart';
import '../../widget/my_divider.dart';
import '../../widget/textfield/auth_textfield.dart';

class Signuppage extends StatelessWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthServices()),
      child: Scaffold(
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
              Container(
                padding: const EdgeInsets.all(16),
                width: ScreenSize.getSize(context).width * 0.9,
                height: ScreenSize.getSize(context).height * 0.5,
                decoration: BoxDecoration(
                  color: AppColors.authPageContainerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error!)),
                      );
                    }
                    if (state.user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.02),
                        AuthTextField(
                          labelText: "Ad/Soyad",
                          icon: Icons.person,
                          onChanged: (val) =>
                              context.read<AuthCubit>().nameChanged(val),
                        ),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.03),
                        AuthTextField(
                          labelText: "E-posta adresiniz",
                          icon: Icons.email,
                          onChanged: (val) =>
                              context.read<AuthCubit>().emailChanged(val),
                        ),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.03),
                        AuthTextField(
                          labelText: "Şifreniz",
                          icon: Icons.lock,
                          obscureText: true,
                          onChanged: (val) =>
                              context.read<AuthCubit>().passwordChanged(val),
                        ),
                        SizedBox(
                            height: ScreenSize.getSize(context).height * 0.03),
                        state.isLoading
                            ? const CircularProgressIndicator()
                            : AuthButton(
                                buttonText: "Kayıt Ol",
                                onTap: () {
                                  context.read<AuthCubit>().register();
                                },
                              ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: ScreenSize.getSize(context).height * 0.02),
              const MyDivider(),
              SizedBox(height: ScreenSize.getSize(context).height * 0.02),
              AlternatifLoginButton(
                  onTap: () => context.read<AuthCubit>().loginWithGoogle()),
            ],
          ),
        ),
      ),
    );
  }
}
