#!/bin/bash
set -e

SOURCE="regulations"
DEST="docs"

echo "Syncing regulations to docs/..."

# Create destination if it doesn't exist
mkdir -p "$DEST"

# Clear destination (keep intro.md if exists)
find "$DEST" -mindepth 1 ! -name 'intro.md' -delete 2>/dev/null || true

# Copy regulations
for dir in "$SOURCE"/*/; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        # Remove numeric prefix (e.g., "1-General" -> "General")
        newname=$(echo "$dirname" | sed 's/^[0-9]*-//')
        
        newdir="$DEST/$newname"
        mkdir -p "$newdir"
        
        # Process subdirectories
        for subdir in "$dir"*/; do
            if [ -d "$subdir" ]; then
                subdirname=$(basename "$subdir")
                subnewname=$(echo "$subdirname" | sed 's/^[0-9]*-//')
                subnewdir="$newdir/$subnewname"
                
                mkdir -p "$subnewdir"
                cp -r "$subdir"* "$subnewdir/" 2>/dev/null || true
            fi
        done
        
        # Copy files from current directory
        find "$dir" -maxdepth 1 -type f -exec cp {} "$newdir/" \; 2>/dev/null || true
    fi
done

# Create intro.md if it doesn't exist
if [ ! -f "$DEST/intro.md" ]; then
    cat > "$DEST/intro.md" << 'EOF'
# 용인대학교 규정집

용인대학교 제규정 통합 관리 시스템입니다.
EOF
fi

echo "Sync completed!"
