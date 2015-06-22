//
//  nscolor-helper.swift
//  Excerptor
//
//  Created by Chen Guo on 22/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

extension NSColor {
    
    var colorComponents: [CGFloat] {
        get {
            let colorSpaceName = self.colorSpaceName
            let numberOfComponents = self.numberOfComponents
            var components = UnsafeMutablePointer<CGFloat>.alloc(numberOfComponents)
            self.getComponents(components)
            return Array(UnsafeMutableBufferPointer(start: components, count: numberOfComponents))
        }
    }
    
    var hexDescription: String! {
        get {
            if let color = self.colorUsingColorSpace(NSColorSpace.genericRGBColorSpace()) {
                let r = color.redComponent
                let g = color.greenComponent
                let b = color.blueComponent
                return String(format: "%02X%02X%02X", Int(r * 255.0), Int(g * 255.0), Int(b * 255.0))
            } else {
                return "Unrecognized color"
            }
        }
    }
}