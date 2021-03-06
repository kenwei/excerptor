//
//  PasteboardHelper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Cocoa

class PasteboardHelper {

    struct Constants {
        static let OutputPasteboardName = "name.guoc.excerptor.ExcerptorToPDFReader"
        static let InputPasteboardName = "name.guoc.excerptor.PDFReaderToExcerptor"
        static let PasteboardType = "org.nspasteboard.TransientType"
        static let ExcerptorToPDFReaderHeader = "ExcerptorToPDFReader:"
        static let PDFReaderToExcerptorHeader = "PDFReaderToExcerptor:"
    }

    class func writeGeneralPasteboardWith(_ selectionLink: SelectionLink?) -> Bool {
        if let selectionLink = selectionLink {
            let pasteboard = NSPasteboard.general()
            pasteboard.clearContents()
            let attributedString = NSAttributedString(string: selectionLink.selectionTextArrayInOneLine, attributes: [NSLinkAttributeName: selectionLink.string])
            return pasteboard.writeObjects([attributedString])
                && pasteboard.setString(selectionLink.string, forType:NSPasteboardTypeString)
        }
        return false
    }

    class func readExcerptorPasteboard() -> Location? {
        let pasteboard = NSPasteboard(name: Constants.InputPasteboardName)
        guard let data = pasteboard.data(forType: Constants.PasteboardType) else {
            return nil
        }
        guard let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            exitWithError("Could not unarchive object with data " + data.description)
        }
        guard let location = unarchivedObject as? Location else {
            if let errorMessage = unarchivedObject as? NSString {
                notifyWithError("Error message in pasteboard", informativeText: String(errorMessage))
                return nil
            } else {
                exitWithError("Could not convert unarchived object to location " + (unarchivedObject as AnyObject).description)
            }
        }
        return location
    }

    class func writeExcerptorPasteboardWithLocation(_ location: Location) {
        let pasteboard = NSPasteboard(name: Constants.OutputPasteboardName)
        pasteboard.clearContents()
        let data = NSKeyedArchiver.archivedData(withRootObject: location)
        guard pasteboard.setData(data, forType:Constants.PasteboardType) else {
            exitWithError("Could not write into pasteboard with excerpt location")
        }
    }


}
