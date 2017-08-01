import Foundation
import UIKit
import CoreGraphics

extension UIImage {
    func round() -> UIImage? {
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height / 2
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let bounds = CGRect(origin: CGPoint.zero, size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        newImage.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}

extension UIImageView {
    func roundImage(imageSize: CGFloat) {
        let circle = CAShapeLayer()
        let circularPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: CGSize(width: imageSize, height: imageSize)), cornerRadius: imageSize)
        
        circle.path = circularPath.cgPath
        
        // Configure the apperence of the circle
        circle.fillColor = UIColor.black.cgColor
        circle.strokeColor = UIColor.black.cgColor
        circle.lineWidth = 0
        
        self.layer.mask = circle;
    }
    
    func setImageAsynchronously(imageName: String) {
        DispatchQueue.global().async {
            let imageOrNil = UIImage(named: imageName)
            guard let image = imageOrNil else {
                return
            }
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            defer {
                UIGraphicsEndImageContext()
            }
            
            image.draw(at: CGPoint.zero)
            
            let decodedImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            DispatchQueue.main.async {
                self.image = decodedImage.withRenderingMode(.alwaysTemplate)
            }
        }
    }
}
