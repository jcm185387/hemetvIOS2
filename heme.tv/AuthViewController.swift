//
//  AuthViewController.swift
//  heme.tv
//
//  Created by Alvaro Hernandez Melo on 25/10/20.
//

import UIKit
import WebKit
import FirebaseAnalytics
import FirebaseAuth

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var logInButton: UIButton!
    	
    private var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Iniciar sesión"
        /*
        let webViewPrefs = WKPreferences()
        webViewPrefs.javaScriptEnabled  = true
        webViewPrefs.javaScriptCanOpenWindowsAutomatically = true
        let webViewConf =  WKWebViewConfiguration()
        webViewConf.preferences = webViewPrefs
        webView = WKWebView(frame: view.frame, configuration: webViewConf)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
        load(url: "https://www.heme.tv")*/
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        if let  email = emailTextField.text , let password =
            passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result,error) in
                
                if let result = result, error == nil{
                    self.navigationController?
                        .pushViewController(HomeViewController(email: result.user.email! , provider: .basic), animated: true)
                }else{
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let  email = emailTextField.text , let password =
            passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result,error) in
                
                if let result = result, error == nil{
                    self.navigationController?
                        .pushViewController(HomeViewController(email: result.user.email! , provider: .basic), animated: true)
                }else{
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func load(url: String){
        webView.load(URLRequest(url: URL(string: url)!))
    }
}
