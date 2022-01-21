import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:shipbay/shared/services/colors.dart';

class UploadFile extends StatefulWidget {
  final mover;
  final type;
  UploadFile({Key key, this.mover, this.type}) : super(key: key);
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  bool _isSubmiting = false;
  PlatformFile _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar("Upload file"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isSubmiting
                    ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: Text("Choose file"),
                              onPressed: () => _chooseFile()),
                          SizedBox(width: 10),
                          Text(_file == null ? 'Not selected' : 'Selected')
                        ],
                      ),
              ],
            )),
          ),
        ),
        floatingActionButton: Visibility(
          visible: _file != null,
          child: FloatingActionButton(
              onPressed: () {
                _uploadFile(context, _file);
              },
              child: const Icon(Icons.upload)),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  Future _chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      setState(() {
        _file = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  void _uploadFile(context, file) async {
    Api api = new Api();
    setState(() {
      _isSubmiting = true;
    });
    try {
      FormData formData = new FormData.fromMap({
        "refrence": widget.mover,
        "type": widget.type,
        "file": await MultipartFile.fromFile(file.path, filename: file.name),
      });
      var response = await api.uploadFile(formData, "upload");
      if (response.statusCode == 200) {
        setState(() {
          _isSubmiting = false;
        });
        Navigator.pop(context, 'uploaded');
      }
    } catch (e) {
      showSnackbar(context, "Could not uplod file $e");
    }
  }
}
