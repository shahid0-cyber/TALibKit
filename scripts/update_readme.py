import sys
import re
from pathlib import Path

version, url = sys.argv[1], sys.argv[2]
readme_path = Path("README.md")
text = readme_path.read_text() if readme_path.exists() else ""

badge_line = f"![TA-Lib version](https://img.shields.io/badge/TA--Lib-{version}-blue)"
dep_block = f""".package(url: "https://github.com/YOUR_GH_USERNAME/TALibKit.git", from: "{version.lstrip('v')}")"""
download_line = f"- Latest built release: [{version}]({url})"

marker_start = "<!-- AUTO-UPDATE:START -->"
marker_end = "<!-- AUTO-UPDATE:END -->"
auto_section = f"{marker_start}\n{badge_line}\n\n{download_line}\n\n```swift\n{dep_block}\n```\n{marker_end}"

if marker_start in text and marker_end in text:
    text = re.sub(f"{re.escape(marker_start)}.*?{re.escape(marker_end)}", auto_section, text, flags=re.S)
else:
    header = "# TALibKit\n\nAuto-built Swift Package (XCFramework) wrapping the official [TA-Lib](https://github.com/TA-Lib/ta-lib) C library for iOS, macOS, tvOS and watchOS.\n\n"
    usage = "\n\n## Usage\n\nAdd this package in Xcode via File > Add Packages, or in `Package.swift`:\n"
    text = header + auto_section + usage

readme_path.write_text(text)
print("README updated for version", version)
