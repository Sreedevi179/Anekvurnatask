import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Ride {
  final String startLocation;
  final String destinationLocation;
  final DateTime scheduledPickupTime;
  final DateTime approximateReachTime;

  Ride({
    required this.startLocation,
    required this.destinationLocation,
    required this.scheduledPickupTime,
    required this.approximateReachTime,
  });

  factory Ride.fromMap(Map<String, dynamic> data) {
    return Ride(
      startLocation: data['startLocation'],
      destinationLocation: data['destinationLocation'],
      scheduledPickupTime: DateTime.fromMillisecondsSinceEpoch(data['scheduledPickupTime']),
      approximateReachTime: DateTime.fromMillisecondsSinceEpoch(data['approximateReachTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startLocation': startLocation,
      'destinationLocation': destinationLocation,
      'scheduledPickupTime': scheduledPickupTime.millisecondsSinceEpoch,
      'approximateReachTime': approximateReachTime.millisecondsSinceEpoch,
    };
  }
}


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class RideForm extends StatefulWidget {
  @override
  _RideFormState createState() => _RideFormState();
}

class _RideFormState extends State<RideForm> {
  final _formKey = GlobalKey<FormState>();
  final _startLocationController = TextEditingController();
  final _destinationLocationController = TextEditingController();
  final _scheduledPickupTimeController = TextEditingController();
  final _approximateReachTimeController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final ride = Ride(
        startLocation: _startLocationController.text,
        destinationLocation: _destinationLocationController.text,
        scheduledPickupTime: DateTime.parse(
            _scheduledPickupTimeController.text),
        approximateReachTime: DateTime.parse(
            _approximateReachTimeController.text),
      );
      FirebaseFirestore.instance.collection('rides').add(ride.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ride scheduled successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _startLocationController,
                    validator: (value) =>
                    value!.isEmpty
                        ? 'Start location is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Start location',
                    ),
                  ),
                  TextFormField(
                    controller: _destinationLocationController,
                    validator: (value) =>
                    value!.isEmpty
                        ? 'Destination location is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Destination location',
                    ),
                  ),
                  TextFormField(
                    controller: _scheduledPickupTimeController,
                    validator: (value) =>
                    value!.isEmpty
                        ? 'Pickup time is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Pickup time',
                    ),
                  ),
                  TextFormField(
                    controller: _approximateReachTimeController,
                    validator: (value) =>
                    value!.isEmpty
                        ? 'Approx reach time is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Approx reach time',
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                      width: 100,
                      height: 30,
                      child: ElevatedButton(onPressed: (){}, child: Text("Schedule"))),


                ],),),
          ],
        ),
      )
      
    );

  }
}
