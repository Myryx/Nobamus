
import Foundation

protocol DiscoverProgressManagerDelegate: class {
    func moveProgressBar(by angle: Double)
    func setProgressBar(to angle: Double)
}

class DiscoverProgressManager {
    var startingTime: Double = 0.0
    var overallTime: Double = 0.0
    var angleFraction: Double = 1.0
    var timeFraction: Double = 0.2
    weak var delegate: DiscoverProgressManagerDelegate?
    var timer: Timer?
    
    func setStartingProgressPosition(startingTime: Double, overallTime: Double) {
        self.startingTime = startingTime
        self.overallTime = overallTime
        
        let timePartLeft = startingTime / overallTime
        let anglesPast = 360 * timePartLeft
        delegate?.setProgressBar(to: anglesPast)
    }
    
    func calculateAngleFraction() {
        let timePartLeft = startingTime / overallTime
        let timeLeft = overallTime - startingTime
        let anglesLeft = 360 - 360 * timePartLeft
        angleFraction = (anglesLeft / timeLeft) * timeFraction
    }
    
    func startProgress() {
        calculateAngleFraction()
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [weak self] _ in
                guard let `self` = self else { return }
                self.delegate?.moveProgressBar(by: self.angleFraction)
            })
        }
    }
    
    func stopProgress() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
