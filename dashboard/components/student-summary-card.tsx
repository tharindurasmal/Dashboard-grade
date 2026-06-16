"use client";

import { useEffect, useState } from "react";

interface Student {
  student_id: number;
  student_no: string;
  full_name: string;
  email: string;
  program: string;
  year_of_study: number;
  gpa: number;
}

export default function StudentSummaryCard({ studentId }: { studentId: string }) {
  const [student, setStudent] = useState<Student | null>(null);

  useEffect(() => {
    fetch("/api/students")
      .then((r) => r.json())
      .then((all: Student[]) => {
        const found = all.find((s) => String(s.student_id) === studentId);
        setStudent(found || null);
      });
  }, [studentId]);

  if (!student) return null;

  const gpa = parseFloat(String(student.gpa));

  const gpaColor =
    gpa >= 3.7 ? "text-green-600" :
    gpa >= 3.0 ? "text-blue-600" :
    gpa >= 2.0 ? "text-orange-600" : "text-red-600";

  return (
    <div className="bg-white rounded-lg border border-gray-200 shadow-sm p-6">
      <div className="flex flex-col sm:flex-row sm:items-center gap-4">
        {/* Avatar */}
        <div className="w-16 h-16 rounded-full bg-indigo-100 flex items-center justify-center text-2xl font-bold text-indigo-600 shrink-0">
          {student.full_name.charAt(0)}
        </div>

        {/* Info */}
        <div className="flex-1 grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div>
            <p className="text-xs text-gray-500 uppercase tracking-wide">Name</p>
            <p className="font-semibold text-gray-900">{student.full_name}</p>
            <p className="text-xs text-gray-400">{student.student_no}</p>
          </div>
          <div>
            <p className="text-xs text-gray-500 uppercase tracking-wide">Program</p>
            <p className="font-medium text-gray-800 text-sm">{student.program}</p>
          </div>
          <div>
            <p className="text-xs text-gray-500 uppercase tracking-wide">Year</p>
            <p className="font-medium text-gray-800">Year {student.year_of_study}</p>
          </div>
          <div>
            <p className="text-xs text-gray-500 uppercase tracking-wide">GPA</p>
            <p className={`text-2xl font-bold ${gpaColor}`}>{gpa.toFixed(2)}</p>
            <p className="text-xs text-gray-400">out of 4.00</p>
          </div>
        </div>
      </div>
    </div>
  );
}
