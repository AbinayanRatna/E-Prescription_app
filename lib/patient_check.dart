import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'patientmodel.dart'; // Import your Person and Medicine models

class ViewPatientsScreen extends StatefulWidget {
  @override
  _ViewPatientsScreenState createState() => _ViewPatientsScreenState();
}

class _ViewPatientsScreenState extends State<ViewPatientsScreen> {
  late Box<Patient> personBox;
  late Box<Medicine> medicineBox;

  @override
  void initState() {
    super.initState();
    personBox = Hive.box<Patient>('Patients'); // Open the Hive box for patients
    medicineBox = Hive.box<Medicine>('Medicines'); // Open the Hive box for medicines
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Patients and medicines"),
      ),
      body: Column(
        children: [
          Expanded(
            flex:1,
            child: ValueListenableBuilder(
              valueListenable: personBox.listenable(),
              builder: (context, Box<Patient> box, _) {
                if (box.isEmpty) {
                  return Center(child: Text("No patients found."));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    Patient person = box.getAt(index)!; // Get person at index

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(person.patient_name),
                        subtitle: Text(
                          "Medicines: ${person.medicines.map((med) => med.medicineName).join(', ')}",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Delete person from Hive
                            personBox.deleteAt(index);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex:1,
            child: ValueListenableBuilder(
              valueListenable: medicineBox.listenable(),
              builder: (context, Box<Medicine> box, _) {
                if (box.isEmpty) {
                  return Center(child: Text("No medicnes found."));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    Medicine medicine = box.getAt(index)!; // Get person at index

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(medicine.medicineName),
                        subtitle: Text(
                          "Medicines: ${medicine.frequency}",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Delete person from Hive
                            medicineBox.deleteAt(index);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
