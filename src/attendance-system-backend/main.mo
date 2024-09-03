import Buffer "mo:base/Buffer";
import {toText} "mo:base/Nat";

actor AttendanceSystem {

  // Define a type for participants
  type Participant = {
    id: Text;
    name: Text;
  };

  // Define a type for attendance records
  type Attendance = {
    participantId: Text;
    eventId: Text;
    timestamp: Nat;
  };

  // Buffers to store participants and attendance records
  var participantDB = Buffer.Buffer<Participant>(0);
  var attendanceDB = Buffer.Buffer<Attendance>(0);

  // Function to register a participant
  public func registerParticipant(participant: Participant): async Text {
    participantDB.add(participant);
    return "Successfully registered participant: " # participant.name;
  };

  // Function to mark attendance for a participant in an event
  public func markAttendance(attendance: Attendance): async Text {
    // Create a new attendance record
    // let attendance: Attendance = {
    //   participantId = participantId;
    //   eventId = eventId;
    //   timestamp = timestamp;
    // };
    attendanceDB.add(attendance);
    return "Attendance marked!"
  };

  // Function to get a summary of attendance for a specific event
  public query func getAttendanceSummary(eventId: Text): async Text {
    var attendanceCount = 0;

    // Filter attendance records for the specified event
    let attendanceSnapshot = Buffer.toArray(attendanceDB);
    for (attendance in attendanceSnapshot.vals()) {
      if (attendance.eventId == eventId) {
        attendanceCount += 1;
      };
    };

    return "Event " # eventId # " has " # toText(attendanceCount) # " attendees.";
  };

  // Function to get attendance details for a specific participant
  public query func getParticipantAttendance(participantId: Text): async Text {
    var records = "";

    // Filter attendance records for the specified participant
    let attendanceSnapshot = Buffer.toArray(attendanceDB);
    for (attendance in attendanceSnapshot.vals()) {
      if (attendance.participantId == participantId) {
        records #= "Event ID: " # attendance.eventId # ", Timestamp: " # toText(attendance.timestamp) # "\n";
      };
    };

    if (records == "") {
      return "No attendance records found for participant ID: " # participantId;
    } else {
      return "Attendance records for participant ID: " # participantId # ":\n" # records;
    };
  };
}
