import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart';

class CalendarClient {
  // For storing the CalendarApi object, this can be used
  // for performing all the operations
  static var calendar;

  // For creating a new calendar event
  Future<Map<String?, String?>> insert({
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required bool hasConferenceSupport,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    late Map<String?, String?> eventData = {'id': '', 'link': ''};
    if (kDebugMode) {
      print('inserting event started');
    }
    // If the account has multiple calendars, then select the "primary" one
    String calendarId = "primary";
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    if (hasConferenceSupport) {
      ConferenceData conferenceData = ConferenceData();
      CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
      conferenceRequest.requestId =
          "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
      conferenceData.createRequest = conferenceRequest;

      event.conferenceData = conferenceData;
    }

    EventDateTime start = EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    EventDateTime end = EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar.events
          .insert(event, calendarId,
              conferenceDataVersion: hasConferenceSupport ? 1 : 0,
              sendUpdates: shouldNotifyAttendees ? "all" : "none")
          .then((value) {
        if (kDebugMode) {
          print("Event Status: ${value.status}");
        }
        if (value.status == "confirmed") {
          late String joiningLink;
          String? eventId;

          eventId = value.id;

          if (hasConferenceSupport) {
            joiningLink =
                "https://meet.google.com/${value.conferenceData.conferenceId}";
          }

          eventData = {'id': eventId, 'link': joiningLink};

          if (kDebugMode) {
            print('Event added to Google Calendar');
          }
          return eventData;
       
        } else {
          if (kDebugMode) {
            print("Unable to add event to Google Calendar");
          }
          return eventData;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error creating event $e');
      }
      return eventData;
    }

    return eventData;
  }

  // For patching an already-created calendar event
  Future<Map<String, String>> modify({
    required String? id,
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required bool hasConferenceSupport,
    required DateTime startTime,
    required DateTime endTime,
  }) async {

    late Map<String, String> eventData;
    if (kDebugMode) {
      print('modify event started');
    }

  String calendarId = "primary";
  Event event = Event();

  event.summary = title;
  event.description = description;
  event.attendees = attendeeEmailList;
  event.location = location;

  EventDateTime start = EventDateTime();
  start.dateTime = startTime;
  start.timeZone = "GMT+05:30";
  event.start = start;

  EventDateTime end = EventDateTime();
  end.timeZone = "GMT+05:30";
  end.dateTime = endTime;
  event.end = end;

  try {
    await calendar.events
        .patch(event, calendarId, id,
            conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none")
        .then((value) {
      if (kDebugMode) {
        print("Event Status: ${value.status}");
      }
      if (value.status == "confirmed") {
        late String joiningLink;
        late String eventId;

        eventId = value.id;

        if (hasConferenceSupport) {
          joiningLink = "https://meet.google.com/${value.conferenceData.conferenceId}";
        }

        eventData = {'id': eventId, 'link': joiningLink};

        if (kDebugMode) {
          print('Event updated in Google Calendar');
        }
      } else {
        if (kDebugMode) {
          print("Unable to update event in Google Calendar");
        }
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error updating event $e');
    }
  }
   if (kDebugMode) {
      print('returing event data');
    }
  return eventData;

  }

  // For deleting a calendar event
  Future<void> delete(String? eventId, bool shouldNotify) async {
    if (kDebugMode) {
      print('delete event started');
    }
    String calendarId = "primary";

  try {
    await calendar.events.delete(calendarId, eventId, sendUpdates: shouldNotify ? "all" : "none").then((value) {
      if (kDebugMode) {
        print('Event deleted from Google Calendar');
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error deleting event: $e');
    }
  }
  }
}