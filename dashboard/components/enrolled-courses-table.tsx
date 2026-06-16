"use client";

import { useEffect, useState } from "react";

interface Enrollment {
  enrollment_id: number;
  course_code: string;
  course_name: string;
  credits: number;
  lecturer: string;
  semester: string;
  academic_year: string;
  status: string;
}

export default function EnrolledCoursesTable({ studentId }: { studentId: string }) {
  const [data, setData] = useState<Enrollment[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/enrollments?studentId=${studentId}`)
      .then((r) => r.json())
      .then((d) => { setData(d); setLoading(false); })
      .catch(() => setLoading(false));
  }, [studentId]);

  const statusColor = (s: string) =>
    s === "Active" ? "bg-green-100 text-green-700" :
    s === "Completed" ? "bg-blue-100 text-blue-700" :
    "bg-red-100 text-red-700";

  return (
    <div className="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
      <div className="p-6 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900">Enrolled Courses</h3>
      </div>
      {loading ? (
        <div className="p-6 text-gray-500">Loading...</div>
      ) : data.length === 0 ? (
        <div className="p-6 text-gray-500">No enrolled courses found.</div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                {["Code","Course Name","Credits","Lecturer","Semester","Year","Status"].map(h => (
                  <th key={h} className="px-4 py-3 text-left text-gray-700 font-semibold">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.map((row) => (
                <tr key={row.enrollment_id} className="border-t border-gray-100 hover:bg-gray-50">
                  <td className="px-4 py-3 font-mono text-gray-600">{row.course_code}</td>
                  <td className="px-4 py-3 font-medium text-gray-800">{row.course_name}</td>
                  <td className="px-4 py-3 text-gray-600">{row.credits}</td>
                  <td className="px-4 py-3 text-gray-600">{row.lecturer}</td>
                  <td className="px-4 py-3 text-gray-600">{row.semester}</td>
                  <td className="px-4 py-3 text-gray-600">{row.academic_year}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${statusColor(row.status)}`}>
                      {row.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
