import 'dart:collection';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_test/item.dart';
import 'package:flutter_calendar_test/widget/date_time_picker_widget.dart';
import 'package:flutter_calendar_test/widget/time_picker_widget.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

    Future<void> addEventToCalendar(
        {int? id,
        required String title,
        required String description,
        DateTime? start,
        DateTime? end,
        required String location}) async {
      await deviceCalendarPlugin.requestPermissions();
      Result<UnmodifiableListView<Calendar>> calendarsResult =
          await deviceCalendarPlugin.retrieveCalendars();
      Calendar calendar;
      if (calendarsResult.isSuccess && calendarsResult.data!.isNotEmpty) {
        try {
          // Permet de récupérer le calendrier LEO en fonction de son nom
          calendar = calendarsResult.data!
              .firstWhere((calendar) => calendar.name == "LEO");
        } catch (e) {
          // Si le calendrier n'existe pas, on le crée, a voir pour le nom du calendrier et de l'utilisateur
          Result<String> calendarResult =
              await deviceCalendarPlugin.createCalendar(
            "LEO",
            calendarColor: const Color(0xff135D5D),
            localAccountName: "Mon LEO",
          );
          // une fois crée on vérifie qu'il existe bien et on l'affecte à la variable calendar
          calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
          if (calendarResult.isSuccess && calendarResult.data != null) {
            calendar = calendarsResult.data!
                .firstWhere((calendar) => calendar.name == "LEO");
          } else {
            throw calendarResult.errors.first.errorMessage;
          }
        }
      } else {
        // Si le calendrier n'existe pas, on le crée, a voir pour le nom du calendrier et de l'utilisateur
        Result<String> calendarResult =
            await deviceCalendarPlugin.createCalendar(
          "LEO",
          calendarColor: const Color(0xff043333),
          localAccountName: "Mon LEO",
        );
        calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
        if (calendarResult.isSuccess && calendarResult.data != null) {
          calendar = calendarsResult.data!
              .firstWhere((calendar) => calendar.name == "LEO");
        } else {
          throw calendarResult.errors.first.errorMessage;
        }
      }
      // localisation du périphérique pour avoir une date en fonction de la localisation
      Location currentLocation = getLocation("Europe/Paris");

      // Création de l'événement qui sera ajouté au calendrier personnel de l'utilisateur
      Event event = Event(
        calendar.id,
        eventId: id?.toString(),
        title: title,
        // start: TZDateTime.now(currentLocation),
        start: TZDateTime.from(start ?? DateTime.now(), currentLocation),
        // end: TZDateTime.now(currentLocation).add(const Duration(hours: 2)),
        end: TZDateTime.from(end ?? DateTime.now(), currentLocation),
        description: description,
        location: location,
      );
      // Ajoute l'événement au calendrier par défaut
      await deviceCalendarPlugin.createOrUpdateEvent(event);
    }

    List<LeoMobileCalendarEvent> calendarEventList1 = [];
    for (int i = 0; i < 1000; i++) {
      calendarEventList1.add(LeoMobileCalendarEvent(
        id: 1045,
        idUtilisateur: 1025966,
        identifiantUtilisateur: "MSO",
        identifiantCreateur: "MSO",
        dateDebut: DateTime.parse("2019-08-05T10:30:00").add(Duration(days: i)),
        dateFin: DateTime.parse("2019-08-05T11:00:00").add(Duration(days: i)),
        type: "Contraception",
        sujet: "SOULLEZ MORGAN $i",
        description: "Test",
        invite: "SOULLEZ MORGAN",
        lieu: "PHARMACIE DE LA GARE ROUTIERE14640",
        idCategorie: 0,
        origine: OrigineRendezVous.LEO,
        dateCreationExterne: null,
      ));
    }
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _locationController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titre',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lieu',
              ),
            ),
            Row(
              children: [
                DateTimePickerWidget(
                    date: startDate,
                    callback: (date) {
                      startDate = date;
                    }),
                TimePickerWidget(
                    timeInput: TimeOfDay.now(),
                    callback: (time) {
                      startDate = startDate.add(Duration(
                          hours: time.hour, minutes: time.minute, seconds: 0));
                    }),
              ],
            ),
            Row(
              children: [
                DateTimePickerWidget(
                    date: endDate,
                    callback: (date) {
                      endDate = date;
                    }),
                TimePickerWidget(
                    timeInput: TimeOfDay.now(),
                    callback: (time) {
                      endDate = endDate.add(Duration(
                          hours: time.hour, minutes: time.minute, seconds: 0));
                    }),
              ],
            ),
            ElevatedButton(
              child: const Text('Ajouter un événement au calendrier'),
              onPressed: () async => await addEventToCalendar(
                title: _titleController.text,
                description: _descriptionController.text,
                location: _locationController.text,
                start: startDate,
                end: endDate,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                int i = 0;
                var start = DateTime.now();
                await deviceCalendarPlugin.requestPermissions();
                Result<UnmodifiableListView<Calendar>> calendarsResult =
                    await deviceCalendarPlugin.retrieveCalendars();
                Calendar calendar;
                try {
                  calendar = calendarsResult.data!
                      .firstWhere((calendar) => calendar.name == "LEO");
                } catch (e) {
                  print("No LEO calendar");
                }
                for (var calendar in calendarEventList1) {
                  await addEventToCalendar(
                    // id: calendar.id,
                    title: calendar.sujet,
                    description: calendar.description,
                    location: calendar.lieu,
                    start: calendar.dateDebut,
                    end: calendar.dateFin,
                  );
                  i++;
                }
                var end = DateTime.now();
                print("Done");
                print(end.difference(start));
                print(i);
              },
              child: const Text('Synchroniser les éléments de LEO'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deviceCalendarPlugin.requestPermissions();
                Result<UnmodifiableListView<Calendar>> calendarsResult =
                    await deviceCalendarPlugin.retrieveCalendars();
                Calendar calendar;
                try {
                  calendar = calendarsResult.data!
                      .firstWhere((calendar) => calendar.name == "LEO");
                } catch (e) {
                  print("No LEO calendar");
                  return;
                }
                await deviceCalendarPlugin.deleteCalendar(calendar.id!);
                print("Done");
              },
              child: const Text('Effacer le calendrier'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deviceCalendarPlugin.requestPermissions();
                final startDate = DateTime.parse("2018-01-01");
                // final endDate = DateTime.now().add(Duration(days: 365 * 2));
                final endDate =
                    DateTime.now().add(const Duration(days: 365 * 10));
                var result = await deviceCalendarPlugin.retrieveEvents(
                    "1",
                    RetrieveEventsParams(
                        startDate: startDate, endDate: endDate));
                for (var event in result.data!) {
                  print("Event : ${event.title}, id: ${event.eventId}");
                }
              },
              child: const Text(
                  'Lire tout les événements stocker sur le calendrier'),
            ),
          ],
        ),
      ),
    );
  }
}
