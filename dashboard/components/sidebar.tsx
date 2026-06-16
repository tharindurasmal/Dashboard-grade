"use client";

import { BookOpen } from "lucide-react";

export default function Sidebar() {
	return (
		<aside className="w-64 bg-slate-900 text-white flex flex-col py-6 px-4 shadow-lg">
			<div className="flex items-center gap-3 mb-8">
				<BookOpen className="w-8 h-8 text-blue-400" />
				<div>
					<h1 className="font-bold text-lg">NSBM LMS</h1>
					<p className="text-xs text-gray-400">Grade Dashboard</p>
				</div>
			</div>

			<nav className="flex-1 space-y-4">
				<div className="px-4 py-2 rounded-lg bg-blue-600 text-white">
					<p className="text-sm font-medium">Student Grades</p>
				</div>
			</nav>

			<div className="border-t border-gray-700 pt-4 text-xs text-gray-400">
				<p>© 2026 NSBM</p>
			</div>
		</aside>
	);
}
