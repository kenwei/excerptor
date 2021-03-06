//
//  AnnotationLink.swift
//  Excerptor
//
//  Created by Chen Guo on 8/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

class AnnotationLink: Link {

    fileprivate let annotationLocation: AnnotationLocation!
    fileprivate let annotationText: String!

    override init!() {
        annotationLocation = nil
        annotationText = nil
        super.init()
        return nil
    }

    init(fileID: FileID, annotationLocation: AnnotationLocation, annotationText: String) {
        self.annotationText = annotationText
        self.annotationLocation = annotationLocation
        super.init(fileID: fileID)
    }

    convenience init(filePath: String, annotationLocation: AnnotationLocation, annotationText: String) {
        self.init(fileID: FileID.filePath(filePath), annotationLocation: annotationLocation, annotationText: annotationText)
    }

    convenience init(dntpUuid: String, annotationLocation: AnnotationLocation, annotationText: String) {
        self.init(fileID: FileID.dNtpUuid(dntpUuid), annotationLocation: annotationLocation, annotationText: annotationText)
    }

    convenience init(filePathOrDNtpUuid: String, annotationLocation: AnnotationLocation, annotationText: String) {
        self.init(fileID: FileID(filePathOrDNtpUuid: filePathOrDNtpUuid), annotationLocation: annotationLocation, annotationText: annotationText)
    }

    convenience required init?(location: Location, text: String?) {
        if let location = location as? AnnotationLocation, let text = text {
            self.init(fileID: FileID.filePath(location.pdfFilePath), annotationLocation: location, annotationText: text)
        } else {
            self.init()
            return nil
        }
    }

    required convenience init?(linkString: String) {
        if linkString.hasPrefix(SelectionLink.head) {
            let linkStringWithoutHead = linkString.stringByRemovingPrefix(SelectionLink.head)
            let arr = linkStringWithoutHead.components(separatedBy: ":")
            if arr.count == 3 {
                let fileID = FileID(filePathOrDNtpUuid: arr[0].removingPercentEncoding!)
                let annotationText = arr[1].removingPercentEncoding!
                let pageNumberAndDateString = arr[2]
                if pageNumberAndDateString.hasPrefix("p") {
                    let pageNumberAndData = String(pageNumberAndDateString.characters.dropFirst()).components(separatedBy: "_")
                    if pageNumberAndData.count == 1 || pageNumberAndData.count == 2 {
                        if let pageNumber = Int(pageNumberAndData[0]) {
                            let pageIndex = UInt(pageNumber - 1)
                            var annotationDate: Date? = nil
                            if pageNumberAndData.count == 2 {
                                if let timeInterval = NumberFormatter().number(from: pageNumberAndData[1])?.doubleValue {
                                    annotationDate = Date(timeIntervalSince1970: timeInterval)
                                }
                            }
                            let annotationLocation = AnnotationLocation(pdfFilePath: fileID.getFilePath(), pageIndex: UInt(pageIndex), annotationDate: annotationDate)
                            self.init(fileID: fileID, annotationLocation: annotationLocation!, annotationText: annotationText)
                            return
                        }
                    }
                }
            }
        }
        self.init()
        return nil
    }

    convenience init?(annotation: Annotation) {
        let annotationLocation = AnnotationLocation(pdfFilePath: annotation.pdfFileID.getFilePath(), pageIndex: UInt(annotation.pageIndex), annotationDate: annotation.date as Date!)
        self.init(location: annotationLocation!, text: annotation.annotationOrNoteText)
    }

    override var string: String {
        get {
            let fileIDString = fileID.percentEncodedString
            let replacedAnnotationText = annotationText.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.isEmpty}).joined(separator: "+")
            let allowedCharacterSet = NSMutableCharacterSet(charactersIn: "+")
            allowedCharacterSet.formUnion(with: URIUnreservedCharacterSet as CharacterSet)
            let annotationTextString = replacedAnnotationText.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)!
            let pageNumber = annotationLocation.pageIndex + 1
            var returnString = "\(SelectionLink.head)\(fileIDString):\(annotationTextString):p\(String(pageNumber))"
            if let annotationDate = annotationLocation.annotationDate {
                let dateString = String(Int(annotationDate.timeIntervalSince1970))
                returnString = returnString + "_\(dateString)"
            }
            return returnString
        }
    }

    override var location: Location {
        get {
            return annotationLocation
        }
    }

    override func getDNtpUuidTypeLink() -> Link? {
        if isDNtpUuidLinkType {
            return self
        }
        if let dntpUuid = getDNtpUuid() {
            return AnnotationLink(dntpUuid: dntpUuid, annotationLocation: annotationLocation, annotationText: annotationText)
        } else {
            return nil
        }
    }

    override func getFilePathTypeLink() -> Link? {
        if isFilePathLinkType {
            return self
        }
        let filePath = getFilePath()
        return AnnotationLink(filePath: filePath, annotationLocation: annotationLocation, annotationText: annotationText)
    }


}
