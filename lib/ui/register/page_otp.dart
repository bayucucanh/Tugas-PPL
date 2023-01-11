import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/styles.dart';
import 'package:mobile_pssi/ui/register/controller/register_controller.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/timer_converter.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:velocity_x/velocity_x.dart';

class PageOTP extends GetView<RegisterController> {
  const PageOTP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 16),
              child: Text("OTP", style: loginHeaderFontTextStyles),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 16, right: 16),
          child: RichText(
            text: TextSpan(
              style: loginCaptionFontTextStyles,
              children: [
                const TextSpan(
                    text: 'OTP sudah dikirim ke email ',
                    style: TextStyle(color: textLoginColor)),
                TextSpan(
                    text:
                        "${controller.emailController.text.trim().toString()}. ",
                    style: const TextStyle(color: primaryColor)),
                const TextSpan(
                    text: 'Cek email sekarang dan masukan kode OTP dibawah!',
                    style: TextStyle(color: textLoginColor)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 16, right: 16),
          child: Row(
            children: [
              const Text('Waktu tersisa: ',
                  style: TextStyle(color: textLoginColor)),
              Countdown(
                  seconds: controller.timerCountdown.value,
                  build: (BuildContext context, double time) => Text(
                        parseFromSeconds(time),
                        style: const TextStyle(color: primaryColor),
                      ),
                  interval: const Duration(milliseconds: 1000),
                  onFinished: () {
                    getSnackbar(
                        "Done registration", "Beres bos, tinggal API ae");
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: PinInputTextFormField(
            key: controller.formKeyOTP,
            pinLength: 4,
            decoration: UnderlineDecoration(
              colorBuilder: PinListenColorBuilder(Colors.cyan, Colors.green),
              // bgColorBuilder: _solidEnable ? _solidColor : null,
              // obscureStyle: ObscureStyle(
              //   isTextObscure: false,
              //   obscureText: '·',
              // ),
              hintText: "····",
            ),
            controller: controller.otpController,
            textInputAction: TextInputAction.go,
            enabled: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            onSubmit: (pin) {
              if (controller.formKeyOTP.currentState!.validate()) {
                controller.formKeyOTP.currentState!.save();
              }
            },
            onChanged: (pin) {
              debugPrint('onChanged execute. pin:$pin');
            },
            onSaved: (pin) {
              debugPrint('onSaved pin:$pin');
            },
            validator: (pin) {
              if (pin.isBlank!) {
                return 'Pin cannot empty.';
              }
              if (pin!.length < 4) {
                return 'Pin is not completed.';
              }
              return null;
            },
            cursor: Cursor(
              width: 2,
              color: Colors.lightBlue,
              radius: const Radius.circular(1),
              enabled: true,
            ),
          ),
        ),
      ],
      alignment: MainAxisAlignment.start,
      crossAlignment: CrossAxisAlignment.start,
    ).scrollVertical();
  }
}
