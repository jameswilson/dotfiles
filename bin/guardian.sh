curl -silent "http://www.guardian.co.uk/rss" | grep -E '(title>|description>)' | \
sed -n '4,$p' | \
sed -e 's/<title>/ - /' -e 's/<\/title>//' -e 's/<description>//' -e 's/<\/description>//' | \
head -n 10