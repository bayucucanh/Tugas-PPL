import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'font.dart';

const buttonTextStyle = TextStyle(color: textButtonColor);
const forgotPasswordTextStyle = TextStyle(color: primaryColor);
const creditTextStyle = TextStyle(color: creditColor, fontSize: creditTextSize);
const whiteFont = TextStyle(color: Colors.white);
const boldWhiteFont =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
final registerHeaderFontTextStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: textLoginColor, fontSize: 32, fontWeight: FontWeight.bold));
final registerCaptionActiveStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: textLoginColor, fontSize: 18, fontWeight: FontWeight.bold));
final registerCaptionUnderlineStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: textLoginColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.underline));
final loginHeaderFontTextStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: textLoginColor, fontSize: 24, fontWeight: FontWeight.bold));
final loginTitleFontTextStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: textLoginColor, fontSize: 18, fontWeight: FontWeight.bold));
final loginCaptionFontTextStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: textLoginColor, fontSize: 14, fontWeight: FontWeight.normal));
final loginRegisterButtonTextStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal));
final loginSignupButtonTextStyles = GoogleFonts.poppins(
    textStyle: const TextStyle(
        color: primaryColor, fontSize: 14, fontWeight: FontWeight.normal));
