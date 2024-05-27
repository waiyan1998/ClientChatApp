
import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func initiate(appStoryBoard: AppStoryboard) -> Self {
        return appStoryBoard.viewController(viewControllerClass: self)
    }
    
}
