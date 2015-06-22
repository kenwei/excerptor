
import Foundation

extension CGPoint {
    func pointByOffsetting(#dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}