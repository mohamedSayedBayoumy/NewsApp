import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app_clean_architecture/_authenticator/presentation/auth_controller/auth_bloc.dart';
import 'package:news_app_clean_architecture/_authenticator/presentation/auth_controller/auth_state.dart';
import 'package:news_app_clean_architecture/core/core_components/custom_text/text.dart';

import '../../../core/core_components/custom_button/custom_button.dart';
import '../../../core/core_components/custom_textfiled/text_filed.dart';
import '../../../core/services/services_locator.dart';
import '../auth_controller/auth_event.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final GoogleSignIn x = GoogleSignIn();

  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance
        .login(loginBehavior: LoginBehavior.webOnly);

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
      print("data : ${_userData}");
    } else {
      print("status : ${result.status}");
      print(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<AuthBloc>(context);
          return Scaffold(
            body: Container(
              width: media.width,
              height: media.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/back_register.jpg"),
                      fit: BoxFit.cover)),
              child: ListView(
                padding: EdgeInsets.only(top: media.height * .15),
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: media.height * .03),
                    child: SizedBox(
                      width: media.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Let's to Join us",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "poppins",
                                fontSize: 30),
                          ),
                          CustomText(
                            "Sign up to continue",
                            isBold: false,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.perm_identity_sharp,
                            textInputAction: TextInputAction.next,
                            labelText: "username",
                            hinText: "mohamed .. ",
                            fill: true,
                            fillColor: Theme.of(context).primaryColor,
                            valid: (p0) => state.errorEmail(
                                state.emailController,
                                val: p0.toString(),
                                ErrorSpace: "username"),
                            width: media.width * .9,
                            controller: bloc.state.emailController,
                            borderColor: Colors.grey,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.phone_enabled_outlined,
                            textInputAction: TextInputAction.next,
                            labelText: "phone",
                            hinText: "0110000",
                            fill: true,
                            fillColor: Theme.of(context).primaryColor,
                            valid: (p0) => state.errorEmail(
                                state.emailController,
                                val: p0.toString(),
                                ErrorSpace: "phone"),
                            width: media.width * .9,
                            controller: bloc.state.emailController,
                            borderColor: Colors.grey,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.email,
                            textInputAction: TextInputAction.next,
                            labelText: "email",
                            hinText: "example@gmail.com",
                            fill: true,
                            fillColor: Theme.of(context).primaryColor,
                            valid: (p0) => state.errorEmail(
                                state.emailController,
                                val: p0.toString(),
                                ErrorSpace: "email"),
                            width: media.width * .9,
                            controller: bloc.state.emailController,
                            borderColor: Colors.grey,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            obscureText: state.showPassword,
                            fill: true,
                            fillColor: Theme.of(context).primaryColor,
                            prefixIcon: Icons.lock,
                            suffixIcon: Icons.visibility_outlined,
                            onPressedSuffixIcon: () {
                              bloc.add(ChangeIconEvent());
                            },
                            textInputAction: TextInputAction.done,
                            labelText: "password",
                            hinText: "password",
                            valid: (p0) => state.errorPassword(
                                state.passwordController,
                                val: p0.toString(),
                                ErrorSpace: "password"),
                            width: media.width * .9,
                            controller: bloc.state.passwordController,
                            borderColor: Colors.grey,
                            maxLength: 1,
                            minLength: 1,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                height: media.height * .05,
                                width: media.width * .5,
                                onPressed: () async {
                                  bloc.add(LoginEvent(
                                      email: bloc.state.emailController.text,
                                      password:
                                          bloc.state.passwordController.text));
                                },
                                text: "Sign up",
                                // color: Colors.pink,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.height * .05,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: media.width * .09),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Container(
                          width: media.width * .03,
                          color: Colors.white,
                          height: media.height * .001,
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: media.width * .05),
                          child: CustomText(
                            "or",
                            isBold: false,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          width: media.width * .03,
                          color: Colors.white,
                          height: media.height * .001,
                        )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          x.signIn().then((value) async {
                            String x = value!.email;
                            String? y = value.displayName;
                            String? n = value.photoUrl;
                            String? o = value.id;

                            /// TODO : here we will registration " => createUserWithEmailAndPassword "
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: x,
                              password: state.passwordController.toString(),
                            );
                            print(o);
                            print(n);
                            print(n);
                            print(y);
                            print(x);
                          });
                        },
                        child: Container(
                          width: media.width * .15,
                          height: media.height * .07,
                          margin: EdgeInsets.only(top: media.height * .03),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                  image: AssetImage("assets/icons/google.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(width: media.width * .17),
                      GestureDetector(
                        onTap: () async {
                          await _login();
                        },
                        child: Container(
                          width: media.width * .15,
                          height: media.height * .07,
                          margin: EdgeInsets.only(top: media.height * .03),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/icons/facebook.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
