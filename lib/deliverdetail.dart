import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_express2/user.dart';
import 'package:toast/toast.dart';
import 'package:my_express2/job.dart';
import 'package:my_express2/mainscreen.dart';

String urlupdate =
    "http://alifmirzaandriyanto.com/mydriver/php/update_deliver_status.php";
String _value;

class DeliverDetail extends StatefulWidget {
  final Job job;
  final User user;

  const DeliverDetail({Key key, this.job, this.user}) : super(key: key);

  @override
  _DeliverDetailState createState() => _DeliverDetailState();
}

class _DeliverDetailState extends State<DeliverDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue[300]));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('DELIVERY STATUS'),
            backgroundColor: Colors.blue[300],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                job: widget.job,
                user: widget.user,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Job job;
  final User user;
  DetailInterface({this.job, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;
  String _selectedStatus = 'PENDING';

  void selectStatus(String value){
    setState((){
      _selectedStatus = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
          double.parse(widget.job.joblat), double.parse(widget.job.joblon)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://alifmirzaandriyanto.com/mydriver/images/${widget.job.jobimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.job.jobtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.job.jobtime),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Job Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.jobdes),
                ]),
                TableRow(children: [
                  Text("Job Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.job.jobprice),
                ]),
                TableRow(children: [
                  Text("Job Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("")
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Delivery Status",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.status),
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'Update Delivery Status',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _updateStatus,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

void _updateStatus() {
    TextEditingController statusController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Delivery Status"),
          content: new TextField(
              controller: statusController,
              decoration: InputDecoration(
                labelText: 'Status',
                //icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (statusController.text.length < 5) {
                  Toast.show(
                      "Status should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "jobid": widget.job.jobid,
                  "status": statusController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.job.status = dres[12];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.job.status = dres[12];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  String get value => null;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('PENDING'),
            value: 'PENDING',
          ),
          DropdownMenuItem<String>(
            child: Text('DELIVERING'),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text('DROP'),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
            selectStatus(value);
          });
        },
        hint: Text('Select Status'),
        value: _value, 
        
      ),
    );
  }

  
   void _onLogin(String email, BuildContext ctx) {
     String urlgetuser = "http://alifmirzaandriyanto.com/mydriver/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}

void selectStatus(String value) {
}
