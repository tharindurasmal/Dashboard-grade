"use client";

import { useEffect, useState } from "react";

interface FinalResult {
  result_id: number;
  course_id: number;
  course_name: string;
  percentage: number;
  grade_letter: string;
  grade_point: number;
  remarks: string;
  academic_year: string;
}

const gradeColor = (g: string) => {
  if (g === "A+" || g === "A") return "bg-green-100 text-green-700";
  if (g === "B+" || g === "B") return "bg-blue-100 text-blue-700";
  if (g === "C+" || g === "C") return "bg-yellow-100 text-yellow-700";
  if (g === "D") return "bg-orange-100 text-orange-700";
  return "bg-red-100 text-red-700";
};

export default function FinalResultsTable({ studentId }: { studentId: string }) {
  const [data, setData] = useState<FinalResult[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/final-results?studentId=${studentId}`)
      .then((r) => r.json())
      .then((d) => { setData(d); setLoading(false); })
      .catch(() => setLoading(false));
  }, [studentId]);

  return (
    <div className="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
      <div className="p-6 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900">Final Results</h3>
      </div>
      {loading ? (
        <div className="p-6 text-gray-500">Loading...</div>
      ) : data.length === 0 ? (
        <div className="p-6 text-gray-500">No final results available.</div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                {["Course","Percentage","Grade","GPA Points","GPA Bar","Remarks"].map(h => (
                  <th key={h} className="px-4 py-3 text-left text-gray-700 font-semibold">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.map((row) => {
              const barWidth = (parseFloat(String(row.grade_point)) / 4.0) * 100;
                return (
                  <tr key={row.result_id} className="border-t border-gray-100 hover:bg-gray-50">
                    <td className="px-4 py-3 font-medium text-gray-800">{row.course_name}</td>
                    <td className="px-4 py-3 text-gray-700">{parseFloat(String(row.percentage)).toFixed(1)}%</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-1 rounded-full text-xs font-bold ${gradeColor(row.grade_letter)}`}>
                        {row.grade_letter}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-700">{parseFloat(String(row.grade_point)).toFixed(2)} / 4.0</td>
                    <td className="px-4 py-3 w-40">
                      <div className="bg-gray-200 rounded-full h-2">
                        <div className="h-2 rounded-full bg-indigo-500" style={{ width: `${barWidth}%` }} />
                      </div>
                      <p className="text-xs text-gray-400 mt-1">{barWidth.toFixed(0)}%</p>
                    </td>
                    <td className="px-4 py-3 text-gray-500 text-xs">{row.remarks}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
