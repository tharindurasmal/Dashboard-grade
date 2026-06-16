"use client";

import { useEffect, useState } from "react";

interface AttendanceRecord {
  attendance_id: number;
  course_id: number;
  course_name: string;
  total_classes: number;
  present: number;
  absent: number;
  late: number;
  attendance_percentage: number;
  academic_year: string;
}

const pctColor = (p: number) =>
  p >= 90 ? "text-green-600" : p >= 75 ? "text-blue-600" : p >= 50 ? "text-orange-600" : "text-red-600";

const barColor = (p: number) =>
  p >= 90 ? "bg-green-500" : p >= 75 ? "bg-blue-500" : p >= 50 ? "bg-orange-500" : "bg-red-500";

export default function AttendanceSummary({ studentId }: { studentId: string }) {
  const [data, setData] = useState<AttendanceRecord[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/attendance?studentId=${studentId}`)
      .then((r) => r.json())
      .then((d) => { setData(d); setLoading(false); })
      .catch(() => setLoading(false));
  }, [studentId]);

  return (
    <div className="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
      <div className="p-6 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900">Attendance Summary</h3>
      </div>
      {loading ? (
        <div className="p-6 text-gray-500">Loading...</div>
      ) : data.length === 0 ? (
        <div className="p-6 text-gray-500">No attendance records found.</div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                {["Course","Total Classes","Present","Absent","Late","Attendance %"].map(h => (
                  <th key={h} className="px-4 py-3 text-left text-gray-700 font-semibold">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.map((row) => (
                <tr key={row.attendance_id} className="border-t border-gray-100 hover:bg-gray-50">
                  <td className="px-4 py-3 font-medium text-gray-800">{row.course_name}</td>
                  <td className="px-4 py-3 text-gray-600">{row.total_classes}</td>
                  <td className="px-4 py-3 text-green-700 font-medium">{row.present}</td>
                  <td className="px-4 py-3 text-red-700 font-medium">{row.absent}</td>
                  <td className="px-4 py-3 text-orange-700 font-medium">{row.late}</td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-2 w-48">
                      <div className="flex-1 bg-gray-200 rounded-full h-2">
                        <div
                          className={`h-2 rounded-full ${barColor(row.attendance_percentage)}`}
                          style={{ width: `${Math.min(row.attendance_percentage, 100)}%` }}
                        />
                      </div>
                      <span className={`text-sm font-semibold ${pctColor(row.attendance_percentage)}`}>
                        {parseFloat(String(row.attendance_percentage)).toFixed(1)}%
                      </span>
                    </div>
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
