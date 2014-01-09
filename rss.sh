#!/bin/sh

### Searching for txt or html files in blog/ and put them in html und atom-xlm feed ###

blogfile="web/blog.html"
rssfile="web/blog.xml"
blogdir="blog/"

## Generate html-blog

# Header
cat web/blogHeader.html > $blogfile

# Content
filelist=$(ls -t1 $blogdir)
for file in $filelist; do
	file=$blogdir$file
	if [ ${file##*.} = "txt" ] || [ ${file##*.} = "html" ];
	then
		title=$(basename $file .${file##*.})
		updated=$(date --date=@`stat -c "%Y" "$file"` "+%Y-%m-%d %H:%M");
		echo '<div id="'$updated'" class="hero-unit"><h2 style=margin-top:-4%">'$title'</h2><h6>'$updated'</h6>'>> $blogfile;
		# Markdown txt-file to html
		if [ ${file##*.} = "txt" ];
		then
			markdown $file >> $blogfile;
		else
			cat $file >> $blogfile
		fi
		echo '</div>' >> $blogfile;
	fi
done

# Footer
cat web/blogFooter.html >> $blogfile;

## Generate xml-atom-feed (last 10 txt-files)

# Header
cat web/blogHeader.xml > $rssfile;
date=`date +%FT%T%:z`;
echo '<updated>'$date'</updated>' >> $rssfile;

# Content (newest 10 entries)
filelist=$(ls -t1 $blogdir | head -10)
for file in $filelist; do
	file=$blogdir$file
	if [ ${file##*.} = "txt" ] || [ ${file##*.} = "html" ];
	then
		title=$(basename $file .${file##*.})
		updated=$(date --date=@`stat -c "%Y" "$file"` "+%FT%T%:z");
		echo '<entry>
				<title>'$title'</title>
				<link href="https://ccc-ol.de/blog.html#'$updated'"/>
				<id>https://ccc-ol.de/blog.html#'$updated'</id>
				<updated>'$updated'</updated>
				<content type="html"><![CDATA[' >> $rssfile;
		# Markdown txt-file to html and replace CDATA endtag
		if [ ${file##*.} = "txt" ];
		then
			markdown $file | tr ']]>' '))>' >> $rssfile;
		else
			cat $file | tr ']]>' '))>' >> $rssfile
		fi
		echo ']]></content></entry>' >> $rssfile;
	fi
done

# Footer
echo '</feed>' >> $rssfile;
