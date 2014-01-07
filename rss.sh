#!/bin/sh

### Searching for txt or html files in blog/ and put them in html und atom-xlm feed ###

blogfile="blog.html"
rssfile="blog.xml"

## Generate html-blog

# Header
cat blogHeader.html > $blogfile

# Content
for file in blog/*.*; do
	title=$(basename $file .${file##*.})
	updated=$(date --date=@`stat -c "%Y" "$file"` "+%Y-%m-%d %H:%M");
	echo '<div id="'$updated'" class="hero-unit"><h2 style=margin-top:-4%">'$title'</h2><h6>'$updated'</h6>'>> $blogfile;
	# Markdown txt-file to html
	if [ ${file##*.} = "txt" ]
	then
		markdown $file >> $blogfile;
	else
		cat $file >> $blogfile
	fi
	echo '</div>' >> $blogfile;
done

# Footer
cat blogFooter.html >> $blogfile;

## Generate xml-atom-feed (last 10 txt-files)

# Header
cat blogHeader.xml > $rssfile;
date=`date +%FT%T%:z`;
echo '<updated>'$date'</updated>' >> $rssfile;

# Content #TODO last 10
for file in blog/*.*; do
	title=$(basename $file .${file##*.})
	updated=$(date --date=@`stat -c "%Y" "$file"` "+%FT%T%:z");
	echo '<entry>
			<title>'$title'</title>
			<link href="https://ccc-ol.de/blog.html#'$updated'"/>
			<id>https://ccc-ol.de/blog.html#'$updated'</id>
			<updated>'$updated'</updated>
			<content type="html"><![CDATA[' >> $rssfile;
	# Markdown txt-file to html and replace CDATA endtag
	if [ ${file##*.} = "txt" ]
	then
		markdown $file | tr ']]>' '))>' >> $rssfile;
	else
		cat $file | tr ']]>' '))>' >> $rssfile
	fi
	echo ']]></content></entry>' >> $rssfile;
done

# Footer
echo '</feed>' >> $rssfile;
