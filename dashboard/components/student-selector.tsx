"use client";

import { useEffect, useState } from "react";

interface Student {
  student_id: number;
  student_no: string;
  full_name: string;
  program: string;
  year_of_study: number;
}

export default function StudentSelector({ onSelect }: { onSelect: (id: string) => void }) {
  const [students, setStudents] = useState<Student[]>([]);
  const [selected, setSelected] = useState<string>("1");

  useEffect(() => {
    fetch("/api/students")
      .then((r) => r.json())
      .then((d) => {
        setStudents(d);
        if (d.length > 0) {
          setSelected(String(d[0].student_id));
          onSelect(String(d[0].student_id));
        }
      });
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setSelected(e.target.value);
    onSelect(e.target.value);
  };

  return (
    <div className="flex flex-col sm:flex-row sm:items-center gap-3">
      <label className="text-sm font-semibold text-gray-700 whitespace-nowrap">
        Select Student:
      </label>
      <select
        value={selected}
        onChange={handleChange}
        className="border border-gray-300 rounded-lg px-3 py-2 text-sm text-gray-800 bg-white
                   focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:border-indigo-400
                   shadow-sm w-full sm:w-auto"
      >
        {students.map((s) => (
          <option key={s.student_id} value={String(s.student_id)}>
            {s.student_no} — {s.full_name} ({s.program}, Year {s.year_of_study})
          </option>
        ))}
      </select>
    </div>
  );
}
