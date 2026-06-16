import { NextRequest, NextResponse } from "next/server";
import pool from "@/lib/db";

export async function GET(req: NextRequest) {
  const studentId = req.nextUrl.searchParams.get("studentId");
  if (!studentId) return NextResponse.json({ error: "studentId required" }, { status: 400 });

  try {
    const result = await pool.query(
      `SELECT 
         e.enrollment_id,
         c.course_code,
         c.course_name,
         c.credits,
         c.lecturer,
         e.semester,
         e.academic_year,
         e.status
       FROM enrollments e
       JOIN courses c ON e.course_id = c.course_id
       WHERE e.student_id = $1
       ORDER BY e.academic_year DESC, e.semester`,
      [studentId]
    );
    return NextResponse.json(result.rows);
  } catch (error) {
    console.error("DB error /api/enrollments:", error);
    return NextResponse.json({ error: "Failed to fetch enrollments" }, { status: 500 });
  }
}
