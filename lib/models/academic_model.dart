/// Academic data models for college student features.

/// Represents a course/class in a semester.
class CourseModel {
  final String id;
  final String code;
  final String name;
  final String instructor;
  final int credits;
  final String? grade;
  final double? gradePoints;
  final String room;
  final String building;

  const CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.instructor,
    required this.credits,
    this.grade,
    this.gradePoints,
    required this.room,
    required this.building,
  });

  CourseModel copyWith({
    String? id,
    String? code,
    String? name,
    String? instructor,
    int? credits,
    String? grade,
    double? gradePoints,
    String? room,
    String? building,
  }) {
    return CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      instructor: instructor ?? this.instructor,
      credits: credits ?? this.credits,
      grade: grade ?? this.grade,
      gradePoints: gradePoints ?? this.gradePoints,
      room: room ?? this.room,
      building: building ?? this.building,
    );
  }
}

/// Represents a class session in the weekly schedule.
class ClassSession {
  final String id;
  final String courseId;
  final String courseName;
  final String courseCode;
  final String instructor;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String startTime;
  final String endTime;
  final String room;
  final String building;
  final ClassType type;

  const ClassSession({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.instructor,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.building,
    required this.type,
  });
}

enum ClassType {
  lecture,
  lab,
  tutorial,
  seminar;

  String get displayName {
    switch (this) {
      case ClassType.lecture:
        return 'Lecture';
      case ClassType.lab:
        return 'Lab';
      case ClassType.tutorial:
        return 'Tutorial';
      case ClassType.seminar:
        return 'Seminar';
    }
  }

  String get shortName {
    switch (this) {
      case ClassType.lecture:
        return 'LEC';
      case ClassType.lab:
        return 'LAB';
      case ClassType.tutorial:
        return 'TUT';
      case ClassType.seminar:
        return 'SEM';
    }
  }
}

/// Represents an assignment or exam.
class AssignmentModel {
  final String id;
  final String courseId;
  final String courseName;
  final String title;
  final String? description;
  final DateTime dueDate;
  final AssignmentType type;
  final bool isCompleted;
  final double? score;
  final double? maxScore;

  const AssignmentModel({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.title,
    this.description,
    required this.dueDate,
    required this.type,
    this.isCompleted = false,
    this.score,
    this.maxScore,
  });

  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());

  Duration get timeRemaining => dueDate.difference(DateTime.now());
}

enum AssignmentType {
  assignment,
  quiz,
  midterm,
  final_exam,
  project,
  presentation;

  String get displayName {
    switch (this) {
      case AssignmentType.assignment:
        return 'Assignment';
      case AssignmentType.quiz:
        return 'Quiz';
      case AssignmentType.midterm:
        return 'Midterm';
      case AssignmentType.final_exam:
        return 'Final Exam';
      case AssignmentType.project:
        return 'Project';
      case AssignmentType.presentation:
        return 'Presentation';
    }
  }
}

/// Academic semester data.
class SemesterModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<CourseModel> courses;
  final double? gpa;
  final int totalCredits;

  const SemesterModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.courses,
    this.gpa,
    required this.totalCredits,
  });

  bool get isCurrent {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}

/// Student academic profile.
class AcademicProfile {
  final String studentId;
  final String program;
  final String department;
  final int year;
  final int semester;
  final double cgpa;
  final int totalCreditsCompleted;
  final int totalCreditsRequired;

  const AcademicProfile({
    required this.studentId,
    required this.program,
    required this.department,
    required this.year,
    required this.semester,
    required this.cgpa,
    required this.totalCreditsCompleted,
    required this.totalCreditsRequired,
  });

  double get progressPercent =>
      (totalCreditsCompleted / totalCreditsRequired).clamp(0.0, 1.0);
}
