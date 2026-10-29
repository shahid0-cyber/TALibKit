import re
import sys

# Usage: release_notes.py <ta-lib-tag> <checksum> <owner/repo> [extra notes] < upstream-release-body
tag, checksum, repo = sys.argv[1:4]
extra = sys.argv[4].strip() if len(sys.argv) > 4 else ""
version = tag.lstrip("v")
upstream_url = f"https://github.com/TA-Lib/ta-lib/releases/tag/{tag}"

# Upstream bodies open with generic install text; keep only this version's changelog section.
section = re.search(rf"^## \[{re.escape(version)}\][^\n]*\n(.*?)(?=^## |\Z)", sys.stdin.read(), flags=re.M | re.S)
changes = section.group(1).strip() if section else f"See the [TA-Lib {tag} release notes]({upstream_url})."

parts = [f"Prebuilt XCFramework of [TA-Lib {tag}]({upstream_url}) for iOS, macOS, tvOS and watchOS."]
if extra:
    parts.append(extra)
parts += [
    f'```swift\n.package(url: "https://github.com/{repo}.git", from: "{version}")\n```',
    f"SwiftPM checksum: `{checksum}`",
    f"## What's new in TA-Lib {tag}\n\n{changes}",
]
print("\n\n".join(parts))
