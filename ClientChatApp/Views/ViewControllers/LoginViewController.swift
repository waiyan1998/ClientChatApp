//
//  ViewController.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 21/05/2024.
//

import UIKit
import Combine

class LoginViewController: BaseViewController {
    
    
    @IBOutlet weak var username_TF  : AppTextField!
    @IBOutlet weak var password_TF  : AppTextField!
    
    private var viewModel = AuthViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupBindings()
    }
    
    @IBAction func ClickLogin(_ sender: Any) {
        //viewModel.username = username_TF.text ?? ""
        //viewModel.password = password_TF.text ?? ""
        self.viewModel.login()
        
    }
    
    private func setupBindings() {
        
        
        // Bind username text field changes to the view model's username property
        username_TF.publisher(for: \.text)
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.username, on: viewModel)
            .store(in:  &cancellables)
        
        // Bind password text field changes to the view model's password property
        password_TF.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isNavigate
            .receive(on: RunLoop.main)
            .sink { [weak self] isNavigate in
                
                if isNavigate {
                    let vc = ChatListViewController.initiate(appStoryBoard: .Main)
                    
                    self?.show(vc, sender: nil)
                }
                
                    
            }
            .store(in: &cancellables)
        
        
        
    }
    
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
