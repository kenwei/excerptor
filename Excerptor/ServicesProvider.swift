//
//  ServicesProvider.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

class ServicesProvider: NSObject {

    func getSelectionLink(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        PreferencesWindowController.needShowPreferences = false

        guard let selectionLink = generateFilePathTypeSelectionLink() else {
            notifyWithError("Excerptor Message", informativeText: "There is no text selected OR SIMBL has not been installed correctly OR an unknown bug happened.")
            return
        }
        
        let selection = Selection(selectionLink: selectionLink)
        selection.writeToPasteboardWithTemplateString(Preferences.sharedPreferences.stringForSelectionLinkRichText, plainTextTemplate: Preferences.sharedPreferences.stringForSelectionLinkPlainText)
    }

    func getSelectionFile(_ pboard: NSPasteboard?, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        PreferencesWindowController.needShowPreferences = false

        guard let selectionLink = generateFilePathTypeSelectionLink() else {
            notifyWithError("Excerptor Message", informativeText: "There is no text selected OR SIMBL has not been installed correctly OR an unknown bug happened.")
            return
        }
        
        let selection = Selection(selectionLink: selectionLink)

        let fileName = Preferences.sharedPreferences.stringForSelectionFileName
        let fileExtension = Preferences.sharedPreferences.stringForSelectionFileExtension
        let folderPath = String(NSString(string: Preferences.sharedPreferences.stringForSelectionFilesLocation).expandingTildeInPath)
        let tags = Preferences.sharedPreferences.stringForSelectionFileTags.components(separatedBy: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let content = Preferences.sharedPreferences.stringForSelectionFileContent
        let fileTemplate = FileTemplate(folderPath: folderPath!, fileName: fileName, fileExtension: fileExtension, tags: tags, content: content, creationDate: Preferences.SelectionPlaceholders.CreationDate, modificationDate: Preferences.SelectionPlaceholders.CreationDate)
        selection.writeToFileWith(fileTemplate)
    }

    func getAnnotationFiles(_ pboard: NSPasteboard?, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        PreferencesWindowController.needShowPreferences = false
        if let pboard = pboard {
            guard let fileOrFolderNames = pboard.propertyList(forType: NSFilenamesPboardType) as? [String] else {
                exitWithError("Could not get file names: \(pboard.propertyList(forType: NSFilenamesPboardType))")
            }
            for fileOrFolderName: String in fileOrFolderNames {
                var isDirectory = ObjCBool(false)
                if FileManager.default.fileExists(atPath: fileOrFolderName, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        writePDFAnnotationsFromFilesIn(URL(fileURLWithPath: fileOrFolderName))
                    } else {
                        writePDFAnnotationsIfNecessaryFrom(URL(fileURLWithPath: fileOrFolderName))
                    }
                }
            }
        }
    }

    func generateFilePathTypeSelectionLink() -> SelectionLink? {
        guard let pasteboardContent = PasteboardHelper.readExcerptorPasteboard() else {
            return nil
        }
        guard let selectionLocation = pasteboardContent as? SelectionLocation else {
            exitWithError("Invalid selection location: \(pasteboardContent)")
        }
        return SelectionLink(selectionLocation: selectionLocation)
    }

    func generateDNtpUuidTypeSelectionLink() -> SelectionLink? {
        let selectionLink = generateFilePathTypeSelectionLink()
        return selectionLink?.getDNtpUuidTypeLink() as? SelectionLink
    }


}


extension Selection {

    convenience init(selectionLink: SelectionLink) {
        let selectionText = selectionLink.selectionTextArrayInOneLine
        let author = NSUserName()
        let date = Date()
        let pageIndex = selectionLink.firstPageIndex
        guard let pdfFileID = selectionLink.fileID else {
            exitWithError("Could not get PDF file ID " + selectionLink.fileID.presentativeString)
        }
        let pdfFileName = URL(fileURLWithPath: selectionLink.getFilePath(), isDirectory: false).lastPathComponent
        self.init(selectionText: selectionText, author: author, date: date, pageIndex: pageIndex, pdfFileID: pdfFileID, pdfFileName: pdfFileName)
        self.selectionLink = selectionLink
    }

}
