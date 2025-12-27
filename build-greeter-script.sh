#!/bin/sh

set -e
mkdir -p "$out/bin"
echo '#!/bin/sh' >> "$out/bin/hello"
echo "echo '$greeting'" >> "$out/bin/hello"
chmod +x "$out/bin/hello"