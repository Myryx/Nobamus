//
//  SpeakersImageView.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 9/30/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

class SpeakersImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let image1 = UIImage(named: "rings-animation_1"),
            let image2 = UIImage(named: "rings-animation_2"),
            let image3 = UIImage(named: "rings-animation_3") {
            self.animationImages = [image1, image2, image3]
            self.animationDuration = 1
            self.image = image1
        }
        self.tintColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        startAnimating()
    }
    
    func stop() {
        stopAnimating()
    }
}
