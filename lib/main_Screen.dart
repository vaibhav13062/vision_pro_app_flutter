import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:vision_pro_app_trial/extras/colors.dart';

import 'extras/gradient_text.dart';

String googleAiAPIkey = "AIzaSyB13zOGQ9aIgQeXtBneCBXkaZ7ctTIV9CA";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  final model = GenerativeModel(model: 'gemini-pro', apiKey: googleAiAPIkey);
  String output = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage("assets/bg.png"))),
          padding: const EdgeInsets.all(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: isLoading
                      ? ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => const LinearGradient(
                                  colors: AppColors.mainGradient)
                              .createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Center(
                              child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                  ))),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => const LinearGradient(
                                      colors: AppColors.mainGradient)
                                  .createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              ),
                              child: DefaultTextStyle(
                                style: GoogleFonts.poppins(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                                child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  repeatForever: false,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                        output.isEmpty
                                            ? "Apple Vision Pro AI App"
                                            : output,
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40),
                          border: const GradientBoxBorder(
                            gradient:
                                LinearGradient(colors: AppColors.mainGradient),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                              isDense: true, border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        if (textEditingController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          final response = await model.generateContent(
                              [Content.text(textEditingController.text)]);

                          setState(() {
                            textEditingController.clear();
                            output = (response.text ?? "");
                            isLoading = false;
                          });
                        }
                      },
                      // backgroundColor: AppColors.mainGradient[3],
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) =>
                            const LinearGradient(colors: AppColors.mainGradient)
                                .createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Icon(
                          Icons.all_inclusive_rounded,
                          size: 35,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
