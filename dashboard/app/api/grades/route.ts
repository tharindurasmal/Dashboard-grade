import { NextRequest, NextResponse } from "next/server";
import pool from "@/lib/db";

export async function GET(req: NextRequest) {
  const studentId = req.nextUrl.searchParams.get("studentId");
  if (!studentId) return NextResponse.json({ error: "studentId required" }, { status: 400 });

  try {
    const result = await pool.query(
      `SELECT 
         g.grade_id,
         a.title         AS assessment_title,
         a.type,
         g.marks_obtained AS marks,
         a.total_marks,
         g.grade_letter,
         g.feedback,
         TO_CHAR(g.graded_at, 'YYYY-MM-DD') AS graded_at,
         c.course_name
       FROM grades g
       JOIN assessments a ON g.assessment_id = a.assessment_id
       JOIN courses c     ON a.course_id     = c.course_id
       WHERE g.student_id = $1
       ORDER BY g.graded_at DESC`,
      [studentId]
    );
    return NextResponse.json(result.rows);
  } catch (error) {
    console.error("DB error /api/grades:", error);
    return NextResponse.json({ error: "Failed to fetch grades" }, { status: 500 });
  }
}
