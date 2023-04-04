import 'package:Schoolclock/calendar_client.dart';
import 'package:Schoolclock/constants.dart';
import 'package:Schoolclock/util/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';

import '../customColors.dart';
import '../model/eventInfo.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  Storage storage = Storage();
  late CalendarClient calendarClient = CalendarClient();

  late TextEditingController textControllerDate;
  late TextEditingController textControllerStartTime;
  late TextEditingController textControllerEndTime;
  late TextEditingController textControllerTitle;
  late TextEditingController textControllerDesc;
  late TextEditingController textControllerLocation;
  late TextEditingController textControllerAttendee;

  late FocusNode textFocusNodeTitle;
  late FocusNode textFocusNodeDesc;
  late FocusNode textFocusNodeLocation;
  late FocusNode textFocusNodeAttendee;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  late String currentTitle;
  late String currentDesc;
  late String currentLocation;
  late String currentEmail;
  String errorString = '';
  // List<String> attendeeEmails = [];
  List<calendar.EventAttendee> attendeeEmails = [];

  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool isEditingEndTime = false;
  bool isEditingBatch = false;
  bool isEditingTitle = false;
  bool isEditingEmail = false;
  bool isEditingLink = false;
  bool isErrorTime = false;
  bool shouldNofityAttendees = false;
  bool hasConferenceSupport = false;

  bool isDataStorageInProgress = false;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate.text = DateFormat.yMMMMd().format(selectedDate);
      });
    }
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        textControllerStartTime.text = selectedStartTime.format(context);
      });
    } else {
      setState(() {
        textControllerStartTime.text = selectedStartTime.format(context);
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
        textControllerEndTime.text = selectedEndTime.format(context);
      });
    } else {
      setState(() {
        textControllerEndTime.text = selectedEndTime.format(context);
      });
    }
  }

  String? _validateTitle(String value) {
    if (value.isNotEmpty) {
      value = value.trim();

      if (value.isEmpty) {
        return 'Title can\'t be empty';
      }

      return null;
    } else {
      return 'Title can\'t be empty';
    }

    //return null;
  }

  String? _validateEmail(String value) {
    if (value.isNotEmpty) {
      value = value.trim();

      if (value.isEmpty) {
        return 'Can\'t add an empty email';
      } else {
        final regex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        final matches = regex.allMatches(value);
        for (Match match in matches) {
          if (match.start == 0 && match.end == value.length) {
            return null;
          }
        }
      }
    } else {
      return 'Can\'t add an empty email';
    }

    return null;
  }

  @override
  void initState() {
    textControllerDate = TextEditingController();
    textControllerStartTime = TextEditingController();
    textControllerEndTime = TextEditingController();
    textControllerTitle = TextEditingController();
    textControllerDesc = TextEditingController();
    textControllerLocation = TextEditingController();
    textControllerAttendee = TextEditingController();

    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: const Text(
          'Create Event',
          style: TextStyle(
            color: CustomColor.dark_blue,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This will add a new event to the events list. You can also add video conferencing option and choose to notify the attendees of this event.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You will have access to modify or remove the event afterwards.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    RichText(
                      text: const TextSpan(
                        text: 'Select Date',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: CustomColor.sea_blue,
                      controller: textControllerDate,
                      textCapitalization: TextCapitalization.characters,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: kEventTextFieldDecoration.copyWith(
                        hintText: 'eg: September 10, 2020',
                        errorText:
                            isEditingDate && textControllerDate.text != null
                                ? textControllerDate.text.isNotEmpty
                                    ? null
                                    : 'Date can\'t be empty'
                                : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Start Time',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: CustomColor.sea_blue,
                      controller: textControllerStartTime,
                      onTap: () => _selectStartTime(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: kEventTextFieldDecoration.copyWith(
                        hintText: 'eg: 09:30 AM',
                        errorText: isEditingStartTime &&
                                textControllerStartTime.text != null
                            ? textControllerStartTime.text.isNotEmpty
                                ? null
                                : 'Start time can\'t be empty'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'End Time',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: CustomColor.sea_blue,
                      controller: textControllerEndTime,
                      onTap: () => _selectEndTime(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: kEventTextFieldDecoration.copyWith(
                        hintText: 'eg: 11:30 AM',
                        errorText: isEditingEndTime &&
                                textControllerEndTime.text != null
                            ? textControllerEndTime.text.isNotEmpty
                                ? null
                                : 'End time can\'t be empty'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    //title
                    RichText(
                      text: const TextSpan(
                        text: 'Title',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    //title field
                    EventTextField(
                      context: context,
                      focusNode: textFocusNodeTitle,
                      focusNode2: textFocusNodeDesc,
                      controller: textControllerTitle,
                      onchanged: (value) {
                        setState(() {
                          isEditingTitle = true;
                          currentTitle = value;
                        });
                      },
                      decoration: kEventTextFieldDecoration.copyWith(
                        hintText: 'eg: Birthday party of John',
                        errorText: isEditingTitle
                            ? _validateTitle(currentTitle)
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //description
                    RichText(
                      text: const TextSpan(
                        text: 'Description',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    //desription
                    EventTextField(
                      context: context,
                      focusNode: textFocusNodeDesc,
                      focusNode2: textFocusNodeLocation,
                      controller: textControllerDesc,
                      onchanged: (value) {
                        setState(() {
                          currentDesc = value;
                        });
                      },
                      decoration: kEventTextFieldDecoration.copyWith(
                        hintText: 'eg: where this event would hold',
                      ),
                    ),
                    const SizedBox(height: 10),
                    //location
                    RichText(
                      text: const TextSpan(
                        text: 'Location',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    //locationb
                    EventTextField(
                      context: context,
                      focusNode: textFocusNodeLocation,
                      focusNode2: textFocusNodeAttendee,
                      controller: textControllerLocation,
                      onchanged: (value) {
                        setState(() {
                          currentLocation = value;
                        });
                      },
                      decoration: kEventTextFieldDecoration.copyWith(
                        hintText: 'Place of the event',
                      ),
                    ),
                    const SizedBox(height: 10),
                    //attendees
                    RichText(
                      text: const TextSpan(
                        text: 'Attendees',
                        style: TextStyle(
                          color: CustomColor.dark_cyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      itemCount: attendeeEmails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                attendeeEmails[index].email.toString(),
                                style: const TextStyle(
                                  color: CustomColor.neon_green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    attendeeEmails.removeAt(index);
                                  });
                                },
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: true,
                            cursorColor: CustomColor.sea_blue,
                            focusNode: textFocusNodeAttendee,
                            controller: textControllerAttendee,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                currentEmail = value;
                              });
                            },
                            onSubmitted: (value) {
                              textFocusNodeAttendee.unfocus();
                            },
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: CustomColor.sea_blue, width: 1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: CustomColor.dark_blue, width: 2),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 16,
                                bottom: 16,
                                top: 16,
                                right: 16,
                              ),
                              hintText: 'Enter attendee email',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              errorText: isEditingEmail
                                  ? _validateEmail(currentEmail)
                                  : null,
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: CustomColor.sea_blue,
                            size: 35,
                          ),
                          onPressed: () {
                            setState(() {
                              isEditingEmail = true;
                            });
                            if (_validateEmail(currentEmail) == null) {
                              setState(() {
                                textFocusNodeAttendee.unfocus();
                                calendar.EventAttendee eventAttendee =
                                    calendar.EventAttendee();
                                eventAttendee.email = currentEmail;

                                attendeeEmails.add(eventAttendee);

                                textControllerAttendee.text = '';
                                currentEmail = 'null';
                                isEditingEmail = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: attendeeEmails.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Notify attendees',
                                style: TextStyle(
                                  color: CustomColor.dark_cyan,
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Switch(
                                value: shouldNofityAttendees,
                                onChanged: (value) {
                                  setState(() {
                                    shouldNofityAttendees = value;
                                  });
                                },
                                activeColor: CustomColor.sea_blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add video conferencing',
                          style: TextStyle(
                            color: CustomColor.dark_cyan,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Switch(
                          value: hasConferenceSupport,
                          onChanged: (value) {
                            setState(() {
                              hasConferenceSupport = value;
                            });
                          },
                          activeColor: CustomColor.sea_blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        // elevation: 0,
                        // focusElevation: 0,
                        // highlightElevation: 0,
                        // color: CustomColor.sea_blue,
                        onPressed: isDataStorageInProgress
                            ? null
                            : () async {
                                print(
                                    'onpress to create the event has been registered');
                                //stage one
                                //isDataStorageInProgress is initially false

                                setState(() {
                                  //stage two
                                  //reverts isDataStorageInProgress to true
                                  //to make the onpress null
                                  isErrorTime = false;
                                  isDataStorageInProgress = true;
                                   log(
                                      'data storage  has gotten to stage two');
                                });
                                //this unfocus all the fields
                                textFocusNodeTitle.unfocus();
                                textFocusNodeDesc.unfocus();
                                textFocusNodeLocation.unfocus();
                                textFocusNodeAttendee.unfocus();

                                if (selectedDate.toString().isNotEmpty &&
                                    selectedStartTime.toString().isNotEmpty &&
                                    selectedEndTime.toString().isNotEmpty &&
                                    currentTitle.isNotEmpty) {
                                  int startTimeInEpoch = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedStartTime.hour,
                                    selectedStartTime.minute,
                                  ).millisecondsSinceEpoch;

                                  int endTimeInEpoch = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedEndTime.hour,
                                    selectedEndTime.minute,
                                  ).millisecondsSinceEpoch;

                                  if (kDebugMode) {
                                    print(
                                        'DIFFERENCE: ${endTimeInEpoch - startTimeInEpoch}');
                                  }

                                  if (kDebugMode) {
                                    print(
                                        'Start Time: ${DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch)}');
                                  }
                                  if (kDebugMode) {
                                    print(
                                        'End Time: ${DateTime.fromMillisecondsSinceEpoch(endTimeInEpoch)}');
                                  }

                                  if (endTimeInEpoch - startTimeInEpoch > 0) {
                                    if (_validateTitle(currentTitle) == null) {
                                      log(
                                          'currentTitle has returned null as it suppose to');
                                      await calendarClient
                                          .insert(
                                              title: currentTitle,
                                              description: currentDesc,
                                              location: currentLocation,
                                              attendeeEmailList: attendeeEmails,
                                              shouldNotifyAttendees:
                                                  shouldNofityAttendees,
                                              hasConferenceSupport:
                                                  hasConferenceSupport,
                                              startTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      startTimeInEpoch),
                                              endTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      endTimeInEpoch))
                                          .then((eventData) async {
                                        log(
                                            'data is being insert in the calendarclient method');
                                        String? eventId = eventData['id'];
                                        String? eventLink = eventData['link'];

                                        List<String?> emails = [];

                                        for (int i = 0;
                                            i < attendeeEmails.length;
                                            i++) {
                                          emails.add(attendeeEmails[i].email);
                                        }
                                        print(
                                            'emails, eventid, eventlink has been set');
//todo: create a function like validate string to output an empty string if the user doesnt add anythin in the description
                                        EventInfo eventInfo = EventInfo(
                                          id: eventId,
                                          name: currentTitle,
                                          description: currentDesc,
                                          location: currentLocation,
                                          link: eventLink,
                                          attendeeEmails: emails,
                                          shouldNotifyAttendees:
                                              shouldNofityAttendees,
                                          hasConfereningSupport:
                                              hasConferenceSupport,
                                          startTimeInEpoch: startTimeInEpoch,
                                          endTimeInEpoch: endTimeInEpoch,
                                        );
                                      log('event info has been set');
                                        log(
                                            'and now the data is being set to firebase');
                                        await storage
                                            .storeEventData(eventInfo)
                                            .whenComplete(() =>
                                                Navigator.of(context).pop())
                                            .catchError(
                                              (e) => ErrorWidget(e, size),
                                            );
                                      }).catchError(
                                        (e) => print(e),
                                      );

                                      setState(() {
                                        isDataStorageInProgress = false;
                                      });
                                    } else {
                                      setState(() {
                                        log('invalid title please fix');
                                        isEditingTitle = true;
                                        isEditingLink = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      log(
                                          'Invalid time! Please use a proper start and end time');
                                      isErrorTime = true;
                                      errorString =
                                          'Invalid time! Please use a proper start and end time';
                                    });
                                  }
                                } else {
                                   log(
                                      'selected date starttime endtime and title are empty');
                                  setState(() {
                                    isEditingDate = true;
                                    isEditingStartTime = true;
                                    isEditingEndTime = true;
                                    isEditingBatch = true;
                                    isEditingTitle = true;
                                    isEditingLink = true;
                                  });
                                }
                                setState(() {
                                  isDataStorageInProgress = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          // onPrimary: Colors.black87,
                          //primary: Colors.grey[300],
                          minimumSize: const Size(88, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black)),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: isDataStorageInProgress
                              ? const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'ADD',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isErrorTime,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorString,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField EventTextField(
      {required BuildContext context,
      InputDecoration? decoration,
      void Function(String)? onsubmitted,
      void Function(String)? onchanged,
      FocusNode? focusNode,
      FocusNode? focusNode2,
      TextEditingController? controller}) {
    return TextField(
        enabled: true,
        cursorColor: CustomColor.sea_blue,
        focusNode: focusNode,
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        onChanged: onchanged,
        onSubmitted: (value) {
          focusNode?.unfocus();
          FocusScope.of(context).requestFocus(focusNode2);
        },
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        decoration: decoration);
  }

  Widget ErrorWidget(String errorText, Size size) {
    return Card(
      elevation: 5,
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.85,
        padding: EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
            child: Text(
          errorText,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        )),
      ),
    );
  }
}
