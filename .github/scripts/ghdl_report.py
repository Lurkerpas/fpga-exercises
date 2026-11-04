#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
REPORT_PATH = ROOT / "test-report.md"
XML_DIR = ROOT / "test-results"


def project_dirs():
    dirs = []
    for item in sorted(ROOT.iterdir()):
        if item.is_dir() and item.resolve() != ROOT and not item.name.startswith(".") and (item / "Makefile").exists():
            dirs.append(item)
    return dirs


def find_testbenches(project_dir: Path):
    bench_files = sorted(project_dir.glob("*_tb.vhd"))
    if bench_files:
        return [f.stem for f in bench_files]

    vhd_files = sorted(project_dir.glob("*.vhd"))
    if vhd_files:
        return [f.stem for f in vhd_files]

    return [project_dir.name]


def write_markdown(results):
    lines = ["# HDL Test Report", ""]
    for project_name, cases in results:
        lines.append(f"## {project_name}")
        for case in cases:
            status = "PASS" if case["passed"] else "FAIL"
            lines.append(f"- {status}: {case['name']}")
        lines.append("")

    REPORT_PATH.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def write_junit(results):
    XML_DIR.mkdir(exist_ok=True)
    testsuites = ET.Element("testsuites")

    for project_name, cases in results:
        suite = ET.SubElement(
            testsuites,
            "testsuite",
            {
                "name": project_name,
                "tests": str(len(cases)),
                "failures": str(sum(1 for case in cases if not case["passed"])),
                "errors": "0",
            },
        )

        for case in cases:
            testcase = ET.SubElement(
                suite,
                "testcase",
                {
                    "classname": project_name,
                    "name": case["name"],
                    "time": "0",
                },
            )
            if not case["passed"]:
                failure = ET.SubElement(testcase, "failure", {"message": "make all failed"})
                failure.text = case["output"]

    xml_path = XML_DIR / "ghdl-report.xml"
    ET.indent(testsuites, space="  ")
    ET.ElementTree(testsuites).write(xml_path, encoding="utf-8", xml_declaration=True)


def main():
    results = []
    failures = 0

    for project_dir in project_dirs():
        project_name = project_dir.name
        benches = find_testbenches(project_dir)
        cases = []

        for bench_name in benches:
            proc = subprocess.run(["make", "all"], cwd=project_dir, capture_output=True, text=True)
            passed = proc.returncode == 0
            if not passed:
                failures += 1
            output = (proc.stdout or "") + (proc.stderr or "")
            cases.append({"name": bench_name, "passed": passed, "output": output.strip()})

        results.append((project_name, cases))

    write_markdown(results)
    write_junit(results)

    if results:
        print(REPORT_PATH.read_text(encoding="utf-8"))

    return 1 if failures > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
