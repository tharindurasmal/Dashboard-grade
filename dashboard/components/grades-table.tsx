"use client";

import { useEffect, useState } from "react";

interface Grade {
  grade_id: number;
  assessment_title: string;
  type: string;
  marks: number;
  total_marks: number;
  grade_letter: string;
  feedback: string;
  graded_at: string;
  course_name: string;
}

const gradeColor = (g: string) => {
  if (g === "A+" || g === "A") return "bg-green-100 text-green-700";
  if (g === "B+" || g === "B") return "bg-blue-100 text-blue-700";
  if (g === "C+" || g === "C") return "bg-yellow-100 text-yellow-700";
  if (g === "D") return "bg-orange-100 text-orange-700";
  return "bg-red-100 text-red-700";
};

export default function GradesTable({ studentId }: { studentId: string }) {
  const [data, setData] = useState<Grade[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/grades?studentId=${studentId}`)
      .then((r) => r.json())
      .then((d) => { setData(d); setLoading(false); })
      .catch(() => setLoading(false));
  }, [studentId]);

  return (
    <div className="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
      <div className="p-6 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900">Grades</h3>
      </div>
      {loading ? (
        <div className="p-6 text-gray-500">Loading...</div>
      ) : data.length === 0 ? (
        <div className="p-6 text-gray-500">No grades available.</div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                {["Assessment","Course","Type","Marks","Grade","Feedback","Graded At"].map(h => (
                  <th key={h} className="px-4 py-3 text-left text-gray-700 font-semibold">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.map((row) => (
                <tr key={row.grade_id} className="border-t border-gray-100 hover:bg-gray-50">
                  <td className="px-4 py-3 font-medium text-gray-800">{row.assessment_title}</td>
                  <td className="px-4 py-3 text-gray-500 text-xs">{row.course_name}</td>
                  <td className="px-4 py-3">
                    <span className="px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-600">
                      {row.type}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-700">{row.marks}/{row.total_marks}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded-full text-xs font-bold ${gradeColor(row.grade_letter)}`}>
                      {row.grade_letter}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-500 text-xs max-w-xs truncate">{row.feedback}</td>
                  <td className="px-4 py-3 text-gray-500 text-xs">{row.graded_at}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
