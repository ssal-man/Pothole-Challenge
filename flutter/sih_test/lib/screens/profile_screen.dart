import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_test/services/firebase_auth_service.dart';
import 'package:sih_test/services/firestore_service.dart';
import 'package:sih_test/utils/report_box.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width / 4.5,
          decoration: BoxDecoration(
              //color: Colors.blue,
              ),
          padding: EdgeInsets.only(top: 30.0, right: 30.0, left: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  final report = Report(
                      uid: [Provider.of<User>(context, listen: false).uid],
                      imageRef: 'reports/hello',
                      landmark: 'hello',
                      location: GeoPoint(20.222, 30.222),
                      timestamp: Timestamp.now());
                  Provider.of<FirestoreService>(context, listen: false)
                      .uploadReport(report)
                      .then((value) {
                    print(value.path);
                  });
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 25.0,
                ),
              ),
              Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Provider.of<FirebaseAuthService>(context, listen: false)
                      .signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.grey.withOpacity(0.5),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Center(
                child: Text(
                  Provider.of<User>(context).email ??
                      Provider.of<User>(context).phoneNo,
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat'),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              Center(
                child: Text(
                  'Level 2',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'REPORTS',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 2.0,
                  ),
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Provider.of<FirestoreService>(context)
                    .getReportsByUser(Provider.of<User>(context).uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docs = snapshot.data.documents;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: ReportBox(title: docs[index].data['landmark']),
                        );
                      },
                    );
                  }
                  return SizedBox(
                      height: 20.0, child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}