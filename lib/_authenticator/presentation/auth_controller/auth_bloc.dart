// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/functions/alert_diloge.dart';
import '../../../core/functions/snack_bar.dart';
import '../../../core/global/globals.dart';
import '../../../presentation_screens/presentation/screens/home_screen/page_view_screen.dart';
import '../../../presentation_screens/presentation/screens/intro_screen/start_up_screen.dart';
import '../../domain/auth_base_use_case/auth_use_case.dart';
import '../../domain/auth_entites/auth_entits.dart';
import '../auth_screens/phone_screen.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authUseCase)
      : super(AuthState(
            nameController: TextEditingController(),
            phoneController: TextEditingController(),
            emailController: TextEditingController(),
            passwordController: TextEditingController())) {
    on<LoginByEmailAndPasswordEvent>(_loginByEmailAndPasswordEvent);
    on<LoginByFaceBookEvent>(_loginByFaceBookEvent);
    on<LoginByGmailEvent>(_loginByGmailEvent);
    on<ChangeIconEvent>(_ChangeIconEvent);
    on<RegisterByFaceBookEvent>(_registerByFaceBookEvent);
    on<RegisterByGmailEvent>(_registerByGmailEvent);
    on<RegisterByEmailAndPasswordEvent>(_RegisterByEmailAndPasswordEvent);
    on<ChangeColorButton>(_ChangeColorButton);
    on<AddPhoneNumberEvent>(_addPhoneNumber);
    on<LogOut>(_logOut);
  }

  final AuthUseCase authUseCase;

  void navigate({required dynamic context, required Widget child}) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(child: child, type: PageTransitionType.rightToLeft),
        (route) => false);
  }

  Future<void> saveSharedPreferences({
    String? email,
    String? password,
    String? id,
    String? name,
    String? image,
    String? token,
  }) async {
    await sharedPreferences.setBool("isLogin", true);
    await sharedPreferences.setString("token", token!);
    await sharedPreferences.setString("email", email!);
    await sharedPreferences.setString("password", password!);
    await sharedPreferences.setString("id", id!);
    await sharedPreferences.setString("name", name!);
    await sharedPreferences.setString("phone", "0");
    await sharedPreferences.setString("image", image!);
  }

  Future<FutureOr<void>> _loginByEmailAndPasswordEvent(
      LoginByEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    if (state.formKeyLogin.currentState!.validate()) {
      loading(event.context, changeLoading: false);

      final result = await authUseCase.login(AuthParameters(
          email: state.emailController.text,
          password: state.passwordController.text));
      if (result.status == true) {
        await saveSharedPreferences(
                token: result.data!["token"],
                email: result.data!["email"],
                password: state.passwordController.text,
                id: result.data!["id"].toString(),
                image: result.data!["image"],
                name: result.data!["name"])
            .then((value) {
          loading(event.context, changeLoading: true);
        }).whenComplete(() {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              navigate(child: const PageViewScreen(), context: event.context);
            },
          );
        });
      } else {
        Navigator.pop(event.context);
        ScaffoldMessenger.of(event.context)
            .showSnackBar(snackBar(result.message!, context: event.context));
      }
      print("Message : ${result.message}");
    } else {}
  }

  Future<FutureOr<void>> _loginByFaceBookEvent(
      LoginByFaceBookEvent event, Emitter<AuthState> emit) async {
    loading(event.context, changeLoading: false);

    final LoginResult loginFacebook =
        await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);

    AccessToken? accessToken;
    if (loginFacebook.status == LoginStatus.success) {
      accessToken = loginFacebook.accessToken;
      print("accessToken : ${accessToken!.token}");

      await FacebookAuth.instance.getUserData().then((value) async {
        print("Success To Get Data From FaceBook");
        await authUseCase
            .login(AuthParameters(
                email: value["email"], password: accessToken!.toString()))
            .then((value) async {
          if (value.status == true) {
            await saveSharedPreferences(
                    token: value.data!["token"],
                    email: value.data!["email"],
                    password: value.data!["password"].toString(),
                    id: value.data!["id"].toString(),
                    image: value.data!["image"],
                    name: value.data!["name"])
                .then((value) {
              loading(event.context, changeLoading: true);
            }).whenComplete(() {
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  navigate(
                      child: const PageViewScreen(), context: event.context);
                },
              );
            });
          } else {
            Navigator.pop(event.context);
            // used this textMessage casuse lenght text in en from api more than text length in ar
            ScaffoldMessenger.of(event.context).showSnackBar(snackBar(
                AppLocalizations.of(event.context)!.errorMessageLogin,
                context: event.context));
          }
        });
      });
    } else {
      Navigator.pop(event.context);
      print("status : ${loginFacebook.status}");
      print("Error Mohamed: ${loginFacebook.message}");
    }
  }

  Future<FutureOr<void>> _loginByGmailEvent(
      LoginByGmailEvent event, Emitter<AuthState> emit) async {
    loading(event.context, changeLoading: false);

    final GoogleSignIn signInGoogle = GoogleSignIn();
    try {
      await signInGoogle.signIn().then((value) async {
        final result = await authUseCase
            .login(AuthParameters(email: value!.email, password: value.id));
        if (result.status == true) {
          await saveSharedPreferences(
                  token: result.data!["token"],
                  email: result.data!["email"],
                  password: value.id,
                  id: result.data!["id"].toString(),
                  image: result.data!["image"],
                  name: result.data!["name"])
              .then((value) {
            loading(event.context, changeLoading: true);
          }).whenComplete(() {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                navigate(child: const PageViewScreen(), context: event.context);
              },
            );
          });
        } else {
          Navigator.pop(event.context);

          ScaffoldMessenger.of(event.context)
              .showSnackBar(snackBar(result.message!, context: event.context));
        }
        print("Message : ${result.message}");
      });
    } on PlatformException {
      Navigator.pop(event.context);
      ScaffoldMessenger.of(event.context).showSnackBar(snackBar(
          AppLocalizations.of(event.context)!.checkYourConnections,
          context: event.context));
    } catch (e) {
      Navigator.pop(event.context);
      ScaffoldMessenger.of(event.context).showSnackBar(snackBar(
          AppLocalizations.of(event.context)!.handleErrorMessage,
          context: event.context));
    }
  }

  Future<FutureOr<void>> _registerByFaceBookEvent(
      RegisterByFaceBookEvent event, Emitter<AuthState> emit) async {
    loading(event.context, changeLoading: false);

    final LoginResult loginFacebook =
        await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);

    AccessToken? accessToken;
    if (loginFacebook.status == LoginStatus.success) {
      accessToken = loginFacebook.accessToken;
      print("accessToken : ${accessToken!.token}");
      final number = Random().nextInt(50000);
      await FacebookAuth.instance.getUserData().then((value) async {
        print("Success To Get Data From FaceBook");
        print(value);
        await authUseCase
            .register(AuthParameters(
                email: value["email"],
                password: accessToken!.toString(),
                name: value["name"],
                phone: number + 3,
                image: value["image"]))
            .then((value) async {
          if (value.status == true) {
            await saveSharedPreferences(
                    token: value.data!["token"],
                    email: value.data!["email"],
                    password: value.data!["password"].toString(),
                    id: value.data!["id"].toString(),
                    image: value.data!["image"],
                    name: value.data!["name"])
                .then((value) {
              loading(event.context, changeLoading: true);
            }).whenComplete(() {
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  navigate(
                      child: const PageViewScreen(), context: event.context);
                },
              );
            });
          } else {
            print(value.message);
            Navigator.pop(event.context);

            ScaffoldMessenger.of(event.context).showSnackBar(
                snackBar(value.message.toString(), context: event.context));
          }
        });
      });
    } else {
      Navigator.pop(event.context);
      print("status : ${loginFacebook.status}");
      print("Error: ${loginFacebook.message}");
    }
  }

  Future<FutureOr<void>> _RegisterByEmailAndPasswordEvent(
      RegisterByEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    if (state.formKeyLogin.currentState!.validate()) {
      loading(event.context, changeLoading: false);
      final result = await authUseCase.register(AuthParameters(
          email: state.emailController.text,
          password: state.passwordController.text,
          name: state.nameController.text,
          phone: state.phoneController.text));
      if (result.status == true) {
        await saveSharedPreferences(
                token: result.data!["token"],
                email: result.data!["email"],
                password: result.data!["id"].toString(),
                id: result.data!["id"].toString(),
                image: result.data!["image"],
                name: result.data!["name"])
            .whenComplete(() {
          navigate(child: const AddPhoneScreen(), context: event.context);
        });
      } else {
        Navigator.pop(event.context);

        ScaffoldMessenger.of(event.context)
            .showSnackBar(snackBar(result.message!, context: event.context));
      }

      emit(state.copyWith());
    } else {}
  }

  Future<FutureOr<void>> _registerByGmailEvent(
      RegisterByGmailEvent event, Emitter<AuthState> emit) async {
    final number = Random().nextInt(50000);
    loading(event.context, changeLoading: false);
    try {
      await state.signInGoogle.signIn().then((value) async {
        final result = await authUseCase.register(AuthParameters(
            email: state.signInGoogle.currentUser?.email,
            password: value!.id,
            name: value.displayName,
            phone: number + 3,
            image: value.photoUrl));

        if (result.status == true) {
          await saveSharedPreferences(
                  token: result.data!["token"],
                  email: value.email,
                  password: value.id,
                  id: value.id,
                  image: value.photoUrl.toString(),
                  name: value.displayName.toString())
              .whenComplete(() {
            navigate(child: const AddPhoneScreen(), context: event.context);
          });
        } else {
          await state.signInGoogle.disconnect();
          Navigator.pop(event.context);
          ScaffoldMessenger.of(event.context)
              .showSnackBar(snackBar(result.message!, context: event.context));
        }
      });
    } on PlatformException {
      Navigator.pop(event.context);
      ScaffoldMessenger.of(event.context).showSnackBar(snackBar(
          AppLocalizations.of(event.context)!.checkYourConnections,
          context: event.context));
    } catch (e) {
      Navigator.pop(event.context);
      ScaffoldMessenger.of(event.context).showSnackBar(snackBar(
          AppLocalizations.of(event.context)!.handleErrorMessage,
          context: event.context));
    }
  }

  Future<FutureOr<void>> _addPhoneNumber(
      AddPhoneNumberEvent event, Emitter<AuthState> emit) async {
    loading(event.context, changeLoading: false);

    final result = await authUseCase
        .addPhoneNumber(AuthParameters(
            email: sharedPreferences.getString("email"),
            password: sharedPreferences.getString("password"),
            name: sharedPreferences.getString("name"),
            phone: state.phoneController.text,
            image: sharedPreferences.getString("image")))
        .then((value) async {
      if (value.status == true) {
        await sharedPreferences
            .setString("phone", state.phoneController.text)
            .then((value) {
          loading(event.context, changeLoading: true);
        }).whenComplete(() {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              navigate(child: const PageViewScreen(), context: event.context);
            },
          );
        });
      } else {
        Navigator.pop(event.context);

        ScaffoldMessenger.of(event.context)
            .showSnackBar(snackBar(value.message!, context: event.context));
        print(value.message);
      }
    });
    print("Response Add Phone Number : $result");
  }

  FutureOr<void> _ChangeIconEvent(
      ChangeIconEvent event, Emitter<AuthState> emit) {
    if (state.showPassword == true) {
      emit(state.copyWith(
          emailController: state.emailController,
          passwordController: state.passwordController,
          showPassword: false));
    } else {
      emit(state.copyWith(
          emailController: state.emailController,
          passwordController: state.passwordController,
          showPassword: true));
    }
  }

  FutureOr<void> _ChangeColorButton(
      ChangeColorButton event, Emitter<AuthState> emit) {
    if (event.value == null || event.value == "") {
      emit(AuthState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          nameController: TextEditingController(),
          phoneController: state.phoneController));
    } else {
      emit(AuthState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          nameController: TextEditingController(),
          phoneController: state.phoneController));
    }
  }

  Future<FutureOr<void>> _logOut(LogOut event, Emitter<AuthState> emit) async {
    loading(event.context, changeLoading: false);
    await authUseCase
        .logOut(AuthParameters(
      token: sharedPreferences.getString("token").toString(),
    ))
        .then((value) async {
      if (value.status == true) {
        await sharedPreferences.setBool('isLogin', false);
        await state.signInGoogle.disconnect().then((value) {
          navigate(child: const StartUpScreen(), context: event.context);
        });
      } else {
        Navigator.pop(event.context);

        ScaffoldMessenger.of(event.context)
            .showSnackBar(snackBar(value.message!, context: event.context));
      }
    });
  }
}
