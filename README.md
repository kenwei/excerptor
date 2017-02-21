# Excerptor

Quickly take and locate excerpts in PDF files.

Support Preview / Skim (1.4.11) in OS X (>= 10.10, not test on 10.11)

Dependencies: [SIMBL](http://www.culater.net/software/SIMBL/SIMBL.php)

When you read a PDF file, you may want to take some excerpts, like excerpting on physical books (including article name, page number etc.). *Via Excerptor, you can take excerpts easily: select text in Preview/[Skim](http://skim-app.sourceforge.net) and type a shortcut. An excerpt will be stored in pasteboard or a file. The excerpt includes a special link. By clicking the link, Excerptor will open the corresponding file by Preview/Skim, go to the page you want and highlight the excerpt you made, automatically.*

![Excerpt To Pasteboard](https://github.com/guoc/excerptor/raw/master/screenshots/excerpt_to_pasteboard.gif)

(In the screenshot, the link is pasted as rich text in Notes.app. It will be plain text if it is pasted in an application which only supports plain text.)

## Features

### No lock-in format.

* Excerpt file format is plain text.
* Excerptor links contain all information to locate excerpts. It is possible to find your excerpts by following the information in an excerpt link itself. Even if the PDF files are missing, the excerpt text could be extracted from the excerpt link per se.

  A typical excerpt link is as follows (The part in square brackets may be repeated and delimited by "-").
  ```
  excerptor://{FilePathOrDEVONthinkUUID}:{ExcerptText}:[p{PageNumber}_{ExcerptTextLocation}_{ExcerptTextLength}]
  ```
  See Wiki page [Excerpt Link Format](https://github.com/guoc/excerptor/wiki/Excerpt-Link-Format) for details.

### Fully customizable

Excerpts are generated by templates which can be set in Excerptor's preferences.

![Excerptor Preferences (Excerpt To Pasteboard)](screenshots/preferences_excerpt_to_pasteboard.png)
![Excerptor Preferences (Excerpt To File)](screenshots/preferences_excerpt_to_file.png)

## DEVONthink Pro support

UUID in DEVONthink Pro can be used to locate PDF files if it is installed, otherwise file paths are used to locate files.

DEVONthink's built-in PDF viewer is not supported to take excerpts.

## QuickLook excerpt files

By default, excerpt files generated by Excerptor are [Markdown](http://daringfireball.net/projects/markdown/) plain text format.

With Brett Terpstra's MMD-QuickLook(https://github.com/ttscoff/MMD-QuickLook/), you can QuickLook excerpt files by typing space bar when a excerpt file is selected.

![MMD-QuickLook](screenshots/mmd_quicklook.png)

You can click an excerpt link in QuickLook views to open the corresponding PDF file and locate to your excerpt.

## Installation

See Wiki page [Excerptor Installation](https://github.com/guoc/excerptor/wiki/Excerptor-Installation)

## Bug report and feature request
are very welcome. Create an issue or email me guochen42+excerptor@gmail.com
