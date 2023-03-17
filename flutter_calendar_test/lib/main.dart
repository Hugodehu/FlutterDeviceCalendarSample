import 'dart:collection';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_test/item.dart';
import 'package:flutter_calendar_test/page/calendar_page.dart';
import 'package:workmanager/workmanager.dart';

final List<LeoMobileCalendarEvent> calendarEventList1 = [];
final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

// Même fonction que dans le fichier calendar_page.dart juste pour tester les tâches en arrière plan
Future<void> _addEventToCalendar(
    {int? id,
    required String title,
    required String description,
    DateTime? start,
    DateTime? end,
    required String location}) async {
  await _deviceCalendarPlugin.requestPermissions();
  Result<UnmodifiableListView<Calendar>> calendarsResult =
      await _deviceCalendarPlugin.retrieveCalendars();
  Calendar calendar;
  if (calendarsResult.isSuccess && calendarsResult.data!.isNotEmpty) {
    try {
      calendarsResult.data!.forEach((element) {
        print(element.name);
      });
      calendar = calendarsResult.data!
          .firstWhere((calendar) => calendar.name == "LEO");
    } catch (e) {
      Result<String> calendarResult =
          await _deviceCalendarPlugin.createCalendar(
        "LEO",
        calendarColor: const Color(0xff135D5D),
        localAccountName: "Mon LEO",
      );
      calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarResult.isSuccess && calendarResult.data != null) {
        calendar = calendarsResult.data!
            .firstWhere((calendar) => calendar.name == "LEO");
      } else {
        throw calendarResult.errors.first.errorMessage;
      }
    }
  } else {
    Result<String> calendarResult = await _deviceCalendarPlugin.createCalendar(
      "LEO",
      calendarColor: const Color(0xff043333),
      localAccountName: "Mon LEO",
    );
    calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarResult.isSuccess && calendarResult.data != null) {
      calendar = calendarsResult.data!
          .firstWhere((calendar) => calendar.name == "LEO");
    } else {
      throw calendarResult.errors.first.errorMessage;
    }
  }
  Location currentLocation = getLocation("Europe/Paris");

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
  await _deviceCalendarPlugin.createOrUpdateEvent(event);
  return Future.value(true);
}

// Cette fonction est appelée par Workmanager et permet de lancer des tâches en arrière plan, on peut y mettre tout ce qu'on veut (appel API, traitement de données, etc...)
// pour que la tâche fonctionne, il faut quelle finisse par un return Future.value(true) ou un return Future.value(false) pour indiquer si la tâche a réussi ou non
// on peut mettre une exception avec le Future.error() mais il faut la gérer dans le code qui appelle la tâche
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
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
    int i = 0;
    var start = DateTime.now();
    var calandarAccess = await _deviceCalendarPlugin.requestPermissions();

    if (!calandarAccess.isSuccess) {
      return Future.value(false);
    }
    Result<UnmodifiableListView<Calendar>> calendarsResult =
        await _deviceCalendarPlugin.retrieveCalendars();
    Calendar calendar;
    try {
      calendar = calendarsResult.data!
          .firstWhere((calendar) => calendar.name == "LEO");
    } catch (e) {
      print("No LEO calendar");
    }

    for (var calendar in calendarEventList1) {
      await _addEventToCalendar(
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
    return Future.value(true);
  });
}

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      // home: CalendarPage()
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // On initialise Workmanager avec la fonction callbackDispatcher qui va être appelée par Workmanager
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    // On enregistre une tâche qui va être appelée toutes les 15 minutes
    Workmanager().registerPeriodicTask("task-identifier", "simpleTask",
        frequency: const Duration(minutes: 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              // On lance la tâche en arrière plan une seule fois
              onPressed: () => Workmanager().registerOneOffTask(
                    "ActiveTask-identifier",
                    "ActiveTask",
                  ),
              child: const Text("Démarer le service")),
          ElevatedButton(
              onPressed: () => Workmanager().registerPeriodicTask(
                  "periodic-identifier", "simpleTask",
                  frequency: const Duration(minutes: 15)),
              child: const Text("Démarer le service périodique")),
          ElevatedButton(
              // On arrête toutes les tâches en arrière plan, on peut aussi arrêter une tâche en particulier avec Workmanager().cancelByUniqueName("task-identifier")
              onPressed: () => Workmanager().cancelAll(),
              child: const Text("Arrêter le service")),
          ElevatedButton(
              onPressed: () => _deviceCalendarPlugin.deleteCalendar("1"),
              child: const Text("Delete le calendrier")),
        ],
      ),
    );
  }
}
