// ignore_for_file: prefer_const_constructors

import 'package:colorsnap/components/color_card.dart';
import 'package:colorsnap/components/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> _colors = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageModal(
          onCameraPressed: () => _getImage(ImageSource.camera),
          onGalleryPressed: () => _getImage(ImageSource.gallery),
        );
      },
    );
  }

  void _copyColorCode(String colorCode) {
    Clipboard.setData(ClipboardData(text: colorCode)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$colorCode copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      setState(() {
        _image = File(pickedImage!.path);
      });

      pickColorsFromImage(_image!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickColorsFromImage(File image) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      FileImage(image),
    );

    setState(() {
      _colors = paletteGenerator.colors.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "ColorCatch",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.cyan[900],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _image = null;
                  _colors = [];
                });
              },
              child: Icon(
                Icons.restart_alt_sharp,
                size: 30,
                weight: 900,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Image
            Container(
              child: _image != null
                  ? Image.file(_image!)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => _showModal(context),
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Select an Image",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),

            // Snapped Colors
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: _colors.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Select an Image!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: _colors.length,
                      itemBuilder: (context, index) {
                        String colorCode =
                            '#${_colors[index].value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
                        return GestureDetector(
                          onTap: () => _copyColorCode(colorCode),
                          child: ColorCard(
                            color: _colors[index],
                            colorCode: colorCode,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
