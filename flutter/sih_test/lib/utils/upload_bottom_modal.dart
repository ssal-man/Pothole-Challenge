import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sih_test/services/auth_widget.dart';
import 'package:sih_test/services/firestore_service.dart';
import 'package:sih_test/utils/text_field.dart';

class UploadBottomModal extends StatefulWidget {
  final String imageRef;
  final String uid;

  UploadBottomModal({this.imageRef, this.uid});

  @override
  _UploadBottomModalState createState() => _UploadBottomModalState();
}

class _UploadBottomModalState extends State<UploadBottomModal> {
  String landmark;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.imageRef);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'ENTER A LANDMARK',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomTextField(
              onChanged: (value) {
                landmark = value;
              },
              obscureText: false,
              hintText: 'Landmark',
            ),
          ),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width - 40,
            height: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.blueAccent,
              onPressed: () async {
                Position position = await Geolocator().getCurrentPosition();
                final report = Report(
                  uid: [widget.uid],
                  imageRef: widget.imageRef,
                  landmark: landmark,
                  location: GeoPoint(position.latitude, position.longitude),
                  timestamp: Timestamp.now(),
                );
                Provider.of<FirestoreService>(context, listen: false)
                    .uploadReport(report)
                    .then((value) {
                  print(value.path);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthWidget()),
                      (Route route) => false);
                });
              },
              child: Text(
                'Submit Report',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
