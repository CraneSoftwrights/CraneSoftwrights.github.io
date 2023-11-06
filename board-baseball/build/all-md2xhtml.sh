find . -name \*.md -exec sh -c 'sh build/md2xhtml.sh <{} >{}.html' \;
if [ -f md2xhtml.zip ]; then rm md2xhtml.zip ; fi
find . -type f -name "*.md.html" -exec zip md2xhtml.zip {} \;
zip -r md2xhtml.zip shared/* build/*
