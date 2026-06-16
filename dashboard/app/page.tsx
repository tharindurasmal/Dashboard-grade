"use client";

import { useState } from "react";
import StudentSelector from "@/components/student-selector";
import StudentSummaryCard from "@/components/student-summary-card";
import EnrolledCoursesTable from "@/components/enrolled-courses-table";
import GradesTable from "@/components/grades-table";
import FinalResultsTable from "@/components/final-results-table";
import AttendanceSummary from "@/components/attendance-summary";

export default function Dashboard() {
	const [selectedStudentId, setSelectedStudentId] = useState<string>("1");

	return (
		<div className="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen py-8">
			<div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">
				{/* Header */}
				<div className="space-y-4">
					<h1 className="text-4xl font-bold text-gray-900">
						Student Grade Dashboard
					</h1>
					<p className="text-gray-600">NSBM LMS</p>
				</div>

				{/* Student Selector */}
				<div className="bg-white rounded-lg p-6 border border-gray-200 shadow-sm">
					<StudentSelector onSelect={setSelectedStudentId} />
				</div>

				{/* Student Summary */}
				<div>
					<StudentSummaryCard studentId={selectedStudentId} />
				</div>

				{/* Enrolled Courses */}
				<div>
					<EnrolledCoursesTable studentId={selectedStudentId} />
				</div>

				{/* Grades */}
				<div>
					<GradesTable studentId={selectedStudentId} />
				</div>

				{/* Final Results */}
				<div>
					<FinalResultsTable studentId={selectedStudentId} />
				</div>

				{/* Attendance */}
				<div>
					<AttendanceSummary studentId={selectedStudentId} />
				</div>
			</div>
		</div>
	);
}
