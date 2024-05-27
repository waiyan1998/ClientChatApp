import UIKit


enum LangCode: String {
    case eng = "en"
    case unicode = "my-MM"
}

class BaseViewController: UIViewController {

    var loading = UIActivityIndicatorView()
    var loadingView = UIView()
    
    var langCode: String {
        get {
            return LocalStorage.shared.getLocalize()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.setupLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
  
    func setupLoading() {
        loadingView.backgroundColor = UIColor.primaryColor().withAlphaComponent(0.2)
        loading.style = .large
        loading.color = UIColor.primaryColor()
        loadingView.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loading, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loading, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        loadingView.isHidden = true
    }

    func showLoading() {
        self.view.bringSubviewToFront(loadingView)
        self.loadingView.isHidden = false
        self.loading.startAnimating()
    }
    
    func hideLoading() {
        self.loading.stopAnimating()
        self.loadingView.isHidden = true
    }
    
  

}
