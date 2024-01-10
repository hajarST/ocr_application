import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:ocr_application/utils/routes.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<OcrText> scannedTexts = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) => setState(() {}));
  }

  static int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
  static String word = "TEXT";

  Future<void> _read() async {
    List<OcrText> texts = [];

    try {
      texts = await FlutterMobileVision.read(
        multiple: true,
        camera: OCR_CAM,
        waitTap: false,
        preview: FlutterMobileVision.PREVIEW,
      );
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() {
      scannedTexts = texts;
      // Définir les valeurs par défaut pour les champs du formulaire
      nameController.text = 'OTHMANE';
      lastNameController.text = 'MOUTAOUAKKIL';
      dobController.text = '07.12.1983';
      addressController.text = 'MAARIF CASABLANCA ANFA';
    });

    _showAlertDialog();
  }

  void backpressed(BuildContext context) {
    Navigator.pushReplacementNamed(context, MyRoutes.home);
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Text'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  // for (var text in scannedTexts)
                  //   TextFormField(
                  //     initialValue: text.value,
                  //     readOnly: true,
                  //     decoration: InputDecoration(
                  //       labelText: 'Scanned Text',
                  //     ),
                  //   ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Firstname'),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'Lastname'),
                  ),
                  TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Adress'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Annuler'),
            // ),
            // TextButton(
            //   onPressed: () {
            //     // Ajoutez ici le code pour traiter les données du formulaire
            //     // par exemple, vous pouvez imprimer les valeurs
            //     print('Nom: ${nameController.text}');
            //     print('Prénom: ${lastNameController.text}');
            //     print('Date de Naissance: ${dobController.text}');
            //     print('Adresse: ${addressController.text}');

            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Enregistrer'),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        backpressed(context);
        return false;
      },
      child: Card(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            _read();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            height: 40,
            width: 400,
            child: Center(
              child: Text(
                "Scan Using Camera",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
