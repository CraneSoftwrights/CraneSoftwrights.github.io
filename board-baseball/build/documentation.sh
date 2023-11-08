find . -name \*.md -exec sh -c 'sh build/md2xhtml.sh <{} >{}.html' \;
if [ -f documentation-board-baseball-crane.zip ]; then rm documentation-board-baseball-crane.zip ; fi
find . -type f -name "*.md.html" -exec zip documentation-board-baseball-crane.zip {} \;
zip -r documentation-board-baseball-crane.zip shared/* build/*
