import { NextRequest, NextResponse } from "next/server";
import pool from "@/lib/db";

export async function GET(req: NextRequest) {
  const studentId = req.nextUrl.searchParams.get("studentId");
  if (!studentId) return NextResponse.json({ error: "studentId required" }, { status: 400 });

  try {
    const result = await pool.query(
      `SELECT 
         fr.result_id,
         c.course_id,
         c.course_name,
         CAST(fr.percentage AS FLOAT)  AS percentage,
         fr.grade_letter,
         CAST(fr.grade_point AS FLOAT) AS grade_point,
         fr.remarks,
         fr.academic_year
       FROM final_results fr
       JOIN courses c ON fr.course_id = c.course_id
       WHERE fr.student_id = $1
       ORDER BY fr.percentage DESC`,
      [studentId]
    );
    return NextResponse.json(result.rows);
  } catch (error) {
    console.error("DB error /api/final-results:", error);
    return NextResponse.json({ error: "Failed to fetch final results" }, { status: 500 });
  }
}
