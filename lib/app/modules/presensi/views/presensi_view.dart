import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:absen/app/modules/presensi/controllers/presensi_controller.dart';

class PresensiView extends StatefulWidget {
  @override
  _PresensiViewState createState() => _PresensiViewState();
}

class _PresensiViewState extends State<PresensiView> {
  final PresensiController presensiController = Get.put(PresensiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
            presensiController.selectedDate.value != null
                ? DateFormat('dd MMMM yyyy', 'id_ID')
                    .format(presensiController.selectedDate.value!)
                : 'All day',
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => presensiController.filterDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => presensiController.resetFilter(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: presensiController.fetchAttendanceRecordsStream(
                      presensiController.selectedDate.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('No attendance records found.'));
                    }

                    final attendanceRecords = snapshot.data!;
                    return ListView.builder(
                      itemCount: attendanceRecords.length,
                      itemBuilder: (context, index) {
                        final record = attendanceRecords[index];
                        final date = (record['date'] as Timestamp).toDate();
                        final formattedDate =
                            DateFormat('yyyy-MM-dd – HH:mm').format(date);

                        return ListTile(
                          title: Text(record['description']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formattedDate),
                              if (record['locationName'] != null)
                                Text(
                                  "Location: ${record['locationName']}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                          onTap: () {
                            _showDetailDialog(context, record);
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showPresensiForm(context);
              },
              child: Text("Presensi Baru"),
            ),
          ],
        ),
      ),
    );
  }

  void _showPresensiForm(BuildContext context) {
    String description = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Presensi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    readOnly: true,
                    controller: TextEditingController(
                        text: presensiController.name.value),
                  )),
              Obx(() => TextField(
                    decoration: InputDecoration(labelText: 'Unit'),
                    readOnly: true,
                    controller: TextEditingController(
                        text: presensiController.unit.value),
                  )),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final position = await presensiController.determinePosition();
                  final locationName =
                      await presensiController.getLocationName(position);

                  presensiController.addPresensi(
                      description, DateTime.now(), position, locationName);
                  Navigator.of(context).pop();
                } catch (e) {
                  Get.snackbar('Error', 'Failed to get location: $e',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> record) {
    String updatedDescription = record['description'];
    final location = record['location'] != null
        ? record['location'] as Map<String, dynamic>
        : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detail Presensi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${record['name']}"),
              Text("Unit: ${record['unit']}"),
              Text(
                "Date: ${DateFormat('yyyy-MM-dd – HH:mm').format((record['date'] as Timestamp).toDate())}",
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: TextEditingController(text: updatedDescription),
                onChanged: (value) => updatedDescription = value,
                readOnly: record['isUpdated'] ?? false,
              ),
              SizedBox(height: 10),
              if (location != null) Text("Location: ${location['name']}"),
              if (location != null)
                MapView(
                  latitude: location['latitude'],
                  longitude: location['longitude'],
                ),
            ],
          ),
          actions: [
            if (!(record['isUpdated'] ?? false))
              TextButton(
                onPressed: () {
                  presensiController.updatePresensi(
                      record['id'], updatedDescription);
                  Navigator.of(context).pop();
                },
                child: Text("Update"),
              ),
            TextButton(
              onPressed: () {
                presensiController.deletePresensi(record['id']);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class MapView extends StatelessWidget {
  final double latitude;
  final double longitude;

  MapView({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('user_location'),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
