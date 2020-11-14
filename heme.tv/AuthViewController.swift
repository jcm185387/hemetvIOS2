//
//  AuthViewController.swift
//  heme.tv
//
//  Created by Alvaro Hernandez Melo on 25/10/20.
//

import UIKit
import WebKit
import FirebaseAnalytics

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
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
    }
    
    private func load(url: String){
        webView.load(URLRequest(url: URL(string: url)!))
    }
}
