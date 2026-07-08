from pathlib import Path

content = Path("Package.swift").read_text()
import re
content = re.sub(r'url: "[^"]*"', 'url: "TALIB_XCFRAMEWORK_URL_PLACEHOLDER"', content)
content = re.sub(r'checksum: "[^"]*"', 'checksum: "TALIB_XCFRAMEWORK_CHECKSUM_PLACEHOLDER"', content)
Path("Package.swift.template").write_text(content)
print("template reset written to Package.swift.template (reference only)")
