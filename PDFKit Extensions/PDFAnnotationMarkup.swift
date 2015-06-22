
import Foundation
import Quartz

extension PDFAnnotationMarkup {
    
// MARK: - Public
    
    var selectionText: String {
        get {
            let selections = horizontalCentralLinesInPageCoordinate.map { self.page().selectionFromPoint($0.startPoint, toPoint: $0.endPoint) }
            let selectionStrings = selections.map({ $0.string() ?? "" }).map({$0.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())})
            return " ".join(selectionStrings)
        }
    }
    
    
// MARK: - Private
    
    private var rects: [CGRect] {
        get {
            let quadrilateralPoints = self.quadrilateralPoints().map { $0.pointValue as NSPoint}
            assert(quadrilateralPoints.count % 4 == 0, "Incorrect number of annotation markup quadrilateral points")
            let groupedQuadrilateralPoints = [Int](0..<quadrilateralPoints.count/4).map { [NSPoint](quadrilateralPoints[$0*4..<$0*4+4]) }
            let rectsInAnnotationCoordinate = groupedQuadrilateralPoints.map { self.smallestRectangleEnclosing($0) }
            return rectsInAnnotationCoordinate
        }
    }
    
    private var horizontalCentralLines: [(startPoint: CGPoint, endPoint: CGPoint)] {
        get {
            return rects.map { (rect: CGRect) -> (startPoint: CGPoint, endPoint: CGPoint) in
                let x = rect.origin.x, y = rect.origin.y, width = rect.width, height = rect.height
                let startPoint = CGPoint(x: x, y: y + height / 2.0)
                let endPoint = CGPoint(x: x + width, y: y + height / 2.0)
                return (startPoint: startPoint, endPoint: endPoint)
            }
        }
    }
    
    private var horizontalCentralLinesInPageCoordinate: [(startPoint: CGPoint, endPoint: CGPoint)] {
        get {
            let origin = self.bounds().origin
            return horizontalCentralLines.map { ($0.startPoint.pointByOffsetting(dx: origin.x, dy: origin.y), $0.endPoint.pointByOffsetting(dx: origin.x, dy: origin.y)) }
        }
    }
    
// MARK: - Helper Methods
    
    private func smallestRectangleEnclosing(points: [CGPoint]) -> CGRect {
        
        let minX = minElement(points.map { $0.x })
        let maxX = maxElement(points.map { $0.x })
        let minY = minElement(points.map { $0.y })
        let maxY = maxElement(points.map { $0.y })
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    private func smallestRectangleEnclosing(points: CGPoint...) -> CGRect {
        return smallestRectangleEnclosing(points)
    }
    
}