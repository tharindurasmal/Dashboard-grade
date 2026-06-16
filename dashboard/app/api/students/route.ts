import { NextResponse } from "next/server";
import pool from "@/lib/db";

export async function GET() {
  try {
    const result = await pool.query(
      `SELECT student_id, student_no, full_name, program, year_of_study, gpa
       FROM students
       WHERE is_active = true
       ORDER BY full_name`
    );
    return NextResponse.json(result.rows);
  } catch (error) {
    console.error("DB error /api/students:", error);
    return NextResponse.json({ error: "Failed to fetch students" }, { status: 500 });
  }
}
