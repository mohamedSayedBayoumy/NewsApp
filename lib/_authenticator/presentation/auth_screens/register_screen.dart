import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/custom_button/custom_button.dart';
import '../../../core/widgets/custom_text/text.dart';
import '../../../core/widgets/custom_textfiled/text_filed.dart';
import '../../../core/services/services_locator.dart';
import '../auth_controller/auth_bloc.dart';
import '../auth_controller/auth_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../auth_controller/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<AuthBloc>(context);
          return Form(
            key: state.formKeyLogin,
            child: Scaffold(
              body: ListView(
                padding: EdgeInsets.only(top: media.height * .15),
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: media.height * .03),
                    child: SizedBox(
                      width: media.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppLocalizations.of(context)!.letsToJoinUs,
                            fontSize: media.width * .09,
                          ),
                          CustomText(
                            text: AppLocalizations.of(context)!
                                .enterYourdataToContinue,
                            fontSize: media.width * .05,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.perm_identity_sharp,
                            textInputAction: TextInputAction.next,
                            labelText: AppLocalizations.of(context)!.username,
                            hinText: "mohamed .. ",
                            valid: (p0) => state.publicError(
                                state.nameController,
                                val: p0.toString(),
                                ErrorSpace:
                                    AppLocalizations.of(context)!.username),
                            width: media.width * .9,
                            controller: bloc.state.nameController,
                            borderColor: Colors.grey,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.phone_enabled_outlined,
                            textInputAction: TextInputAction.next,
                            labelText: AppLocalizations.of(context)!.phone,
                            hinText: "0110000",
                            fill: true,
                            valid: (p0) => state.publicError(
                                state.phoneController,
                                val: p0.toString(),
                                ErrorSpace:
                                    AppLocalizations.of(context)!.phone),
                            width: media.width * .9,
                            controller: bloc.state.phoneController,
                            borderColor: Colors.grey,
                          ),
                          SizedBox(
                            height: media.height * .03,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.email,
                            textInputAction: TextInputAction.next,
                            labelText: AppLocalizations.of(context)!.email,
                            hinText: "example@gmail.com",
                            fill: true,
                            valid: (p0) => state.errorEmail(
                                state.emailController,
                                val: p0.toString(),
                                ErrorSpace:
                                    AppLocalizations.of(context)!.email),
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
                            prefixIcon: Icons.lock,
                            suffixIcon: Icons.visibility_outlined,
                            onPressedSuffixIcon: () {
                              bloc.add(ChangeIconEvent());
                            },
                            textInputAction: TextInputAction.done,
                            labelText: AppLocalizations.of(context)!.password,
                            hinText: AppLocalizations.of(context)!.password,
                            valid: (p0) => state.errorPassword(
                                state.passwordController,
                                val: p0.toString(),
                                ErrorSpace:
                                    AppLocalizations.of(context)!.password),
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
                              customButton(
                                context: context,

                                height: media.height * .05,
                                width: media.width * .5,

                                onPressed: () async {
                                  bloc.add(
                                      RegisterByEmailAndPasswordEvent(context));
                                },
                                text: AppLocalizations.of(context)!.signUp,
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
                          color: Colors.yellowAccent.shade700,
                          height: media.height * .001,
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: media.width * .05),
                          child: CustomText(
                            text: AppLocalizations.of(context)!.or,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          width: media.width * .03,
                          color: Colors.yellowAccent.shade700,
                          height: media.height * .001,
                        )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            bloc.add(RegisterByGmailEvent(context: context));
                          },
                          icon: Image.asset("assets/icons/google.png"),
                          iconSize: media.width * .12),
                      SizedBox(width: media.width * .17),
                      IconButton(
                          onPressed: () {
                            bloc.add(RegisterByFaceBookEvent(context: context));
                          },
                          icon: Image.asset("assets/icons/facebook.png"),
                          iconSize: media.width * .12),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
