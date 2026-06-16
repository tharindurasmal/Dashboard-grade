import { NextRequest, NextResponse } from "next/server";
import pool from "@/lib/db";

export async function GET(req: NextRequest) {
  const studentId = req.nextUrl.searchParams.get("studentId");
  if (!studentId) return NextResponse.json({ error: "studentId required" }, { status: 400 });

  try {
    const result = await pool.query(
      `SELECT 
         a.attendance_id,
         c.course_id,
         c.course_name,
         a.total_classes,
         a.classes_present  AS present,
         a.classes_absent   AS absent,
         a.classes_late     AS late,
         CAST(a.attendance_pct AS FLOAT) AS attendance_percentage,
         a.academic_year
       FROM attendance a
       JOIN courses c ON a.course_id = c.course_id
       WHERE a.student_id = $1
       ORDER BY c.course_name`,
      [studentId]
    );
    return NextResponse.json(result.rows);
  } catch (error) {
    console.error("DB error /api/attendance:", error);
    return NextResponse.json({ error: "Failed to fetch attendance" }, { status: 500 });
  }
}
