import 'package:flutter/material.dart';
import 'models/patient.dart';
import 'services/api_service.dart';
import 'screens/add_patient_screen.dart';

void main() {
  runApp(TriageApp());
}

class TriageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Triage AI', home: PatientListScreen());
  }
}

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Patient>> futurePatients;

  @override
  void initState() {
    super.initState();
    futurePatients = apiService.fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Pasien')),
      body: FutureBuilder<List<Patient>>(
        future: futurePatients,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('Skor Keparahan: ${patient.severityScore}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
