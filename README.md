# Excerptor

Quickly take and locate excerpts in PDF files.

Support Preview / Skim (1.4.11) in OS X (>= 10.10)
Dependencies: [EasySIMBL](https://github.com/norio-nomura/EasySIMBL)

When you read a PDF file, you may want to take some excerpts, like excerpting on physical books (including article name, page number etc.). Via Excerptor, you can take excerpts easily: select text in Preview/[Skim](http://skim-app.sourceforge.net) and type a shortcut. An excerpt will be stored in pasteboard or a file. The excerpt includes a special link. By clicking the link, Excerptor will open the corresponding file by Preview/Skim, go to the page you want and highlight the excerpt you made, automatically.

![Excerpt To Pasteboard](https://github.com/guoc/excerptor/raw/master/screenshots/excerpt_to_pasteboard.gif)

## Features

### No lock-in format.

* Excerpt file format is plain text.
* Excerptor links contain all information to locate excerpts. It is possible to find your excerpts by following the information in an excerpt link itself.

### Fully customizable

Excerpts are generated by templates which can be set in Excerptor's preferences.

![Excerptor Preferences](screenshots/preferences.png)

## DEVONthink Pro support

UUID in DEVONthink Pro can be used to locate PDF files if it is installed, otherwise file paths are used to locate files.

## QuickLook excerpt files

By default, excerpt files generated by Excerptor are [Markdown](http://daringfireball.net/projects/markdown/) plain text format.

With Brett Terpstra's MMD-QuickLook(https://github.com/ttscoff/MMD-QuickLook/), you can QuickLook excerpt files by typing space bar when a excerpt file is selected.

![MMD-QuickLook](screenshots/mmd_quicklook.png)

You can click an excerpt link in QuickLook views to open the corresponding PDF file and locate to your excerpt.

## Installation

1. Install [EasySIMBL](https://github.com/norio-nomura/EasySIMBL)
2. Download [excerptor.zip](https://github.com/guoc/excerptor/releases) and unzip it.
3. Launch EasySIMBL and drag PDFReaderPlugin.bundle to EasySIMBL's window.
4. Drag Excerptor.app to your Applications folder, right click it and click open.
5. Now you are ready to use Excerptor. Open a PDF file, select some text and type Command-Shift-E, you'll get an excerpt link in your pasteboard. Paste it to Safari's address bar and type Return key.

## Bug report and feature request
are very welcome. Create an issue or email me guochenFORTYTWO AT gmail.com (replace FORTYTWO with 42)
