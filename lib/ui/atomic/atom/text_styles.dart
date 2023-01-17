import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  static TextStyle HeaderTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 38,
          color: CustomColorScheme.text,
        ),
        letterSpacing: 1);
  }

  static TextStyle HeaderBoldTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 38,
          color: CustomColorScheme.text,
        ),
        letterSpacing: 1);
  }

  static TextStyle Header2TextStyle(BuildContext context) {
    return GoogleFonts.workSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: CustomColorScheme.text,
        ),
        letterSpacing: 1);
  }

  static TextStyle Header3TextStyle(BuildContext context) {
    return GoogleFonts.workSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: CustomColorScheme.text,
        ),
        letterSpacing: 1);
  }

  static TextStyle LabelTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: CustomColorScheme.text,
      ),
    );
  }

  static TextStyle DropDownTextStyle(BuildContext context) {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        letterSpacing: 0.7,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: CustomColorScheme.text,
      ),
    );
  }

  static TextStyle ErrorTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: CustomColorScheme.inputErrorBorder,
      ),
    );
  }

  static TextStyle TooltipTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: CustomColorScheme.authColumnFill,
      ),
    );
  }

  static TextStyle LabelBoldTextStyle(BuildContext context) {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: CustomColorScheme.text,
      ),
    );
  }

  static TextStyle LabelBoldWorkSansTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: CustomColorScheme.text,
      ),
    );
  }

  static TextStyle LabelBoldPinkTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: CustomColorScheme.button,
      ),
    );
  }

  static TextStyle LinkTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        decoration: TextDecoration.underline,
        color: CustomColorScheme.textLink,
      ),
    );
  }

  static TextStyle LinkLargeTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        decoration: TextDecoration.underline,
        color: CustomColorScheme.textLink,
      ),
    );
  }

  static TextStyle GreyLabelStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: CustomColorScheme.textHint,
      ),
    );
  }

  static TextStyle HintTextStyle(BuildContext context) {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        letterSpacing: 0.7,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: CustomColorScheme.textHint,
      ),
    );
  }

  static TextStyle HintLargeBoldStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: CustomColorScheme.textHint,
      ),
    );
  }

  static TextStyle ButtonTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: CustomColorScheme.text,
      ),
    );
  }

  static TextStyle LargeButtonStyle(BuildContext context) {
    return GoogleFonts.workSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: CustomColorScheme.text,
        ),
        letterSpacing: 1);
  }

  static TextStyle TableHeaderTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: CustomColorScheme.textHint,
      ),
    );
  }

  static TextStyle TableHeaderLinkTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: CustomColorScheme.text,
      ),
    );
  }

  static TextStyle AuthNumberTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: CustomColorScheme.mainDarkBackground,
      ),
    );
  }

  static TextStyle AuthNumberEmptyTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: CustomColorScheme.authColumnEmpty,
      ),
    );
  }

  static TextStyle AuthColumnEmptyTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: CustomColorScheme.authColumnEmpty,
      ),
    );
  }

  static TextStyle AuthColumnFilledTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: CustomColorScheme.authColumnFill,
      ),
    );
  }

  static TextStyle HintSmallTextStyle(BuildContext context) {
    return GoogleFonts.workSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: CustomColorScheme.textHint,
      ),
    );
  }
}
