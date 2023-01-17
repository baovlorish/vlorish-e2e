import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/contact_us/contact_us_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/contact_us/contact_us_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUsLayout extends StatefulWidget {
  const ContactUsLayout({Key? key}) : super(key: key);

  @override
  State<ContactUsLayout> createState() => _ContactUsLayoutState();
}

class _ContactUsLayoutState extends State<ContactUsLayout> {
  final contactUsFormKey = GlobalKey<FormState>();
  int? reasonOfContact;
  String? message;
  String? email;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      title: AppLocalizations.of(context)!.contactUs,
      headerWidget: Label(
        text: AppLocalizations.of(context)!.contactUs,
        type: LabelType.Header2,
      ),
      bodyWidget: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsErrorState) {
            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.error);
              },
            );
          } else if (state is ContactUsSuccessState) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessAlertDialog(context, message: state.message);
              },
            );
          }
        },
        builder: (context, state) {
          if (state is ContactUsLoadingState) {
            return CustomLoadingIndicator();
          } else if (state is ContactUsLoadedState) {
            email = state.email;
            return Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColorScheme.blockBackground,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: CustomColorScheme.tableBorder,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: contactUsFormKey,
                      child: Row(children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 350),
                                child: DropdownItem<int>(
                                    labelText: AppLocalizations.of(context)!
                                        .selectTheReasonContact,
                                    hintText: AppLocalizations.of(context)!
                                        .giveFeedback,
                                    items: [
                                      AppLocalizations.of(context)!
                                          .giveFeedback,
                                      AppLocalizations.of(context)!
                                          .requestFeature,
                                      AppLocalizations.of(context)!.support,
                                      AppLocalizations.of(context)!.other,
                                    ],
                                    itemKeys: [0, 1, 2, 3],
                                    validateFunction:
                                        FormValidators.reasonOfContact,
                                    callback: (value) {
                                      reasonOfContact = value;
                                      setState(() {});
                                    }),
                              ),
                              SizedBox(height: 16),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 350),
                                child: InputItem(
                                  labelText:
                                      AppLocalizations.of(context)!.email,
                                  value: email,
                                  validateFunction:
                                      FormValidators.emailValidateFunction,
                                  onChanged: (value) {
                                    email = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(height: 16),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 350),
                                child: InputItem(
                                  prefix: '+',
                                  labelText: AppLocalizations.of(context)!
                                      .phoneFieldLabelText,
                                  textInputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(12)
                                  ],
                                  validateFunction:
                                      FormValidators.optionalPhone,
                                  onChanged: (value) {
                                    phone = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(height: 16),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 700),
                                child: InputItem(
                                  labelText: AppLocalizations.of(context)!
                                      .commentLabelText,
                                  minLines: 3,
                                  maxLines: 5,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(300),
                                  ],
                                  validateFunction:
                                      FormValidators.contactMessage,
                                  onChanged: (value) {
                                    message = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(height: 32),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150),
                                child: ButtonItem(
                                  context,
                                  text: AppLocalizations.of(context)!.submit,
                                  onPressed: () {
                                    if (contactUsFormKey.currentState!
                                        .validate()) {
                                      BlocProvider.of<ContactUsCubit>(context)
                                          .createTicket(
                                              email: email!,
                                              subject: message!,
                                              phone: phone,
                                              name: state.name,
                                              code: reasonOfContact!);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
