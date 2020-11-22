//
//  AuthViewController.swift
//  heme.tv
//
//  Created by Alvaro Hernandez Melo on 25/10/20.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var authStackView: UIStackView!
    
    @IBOutlet weak var facebookButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //poner radius a los txt
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 0.2
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 0.2
        
        //poner redondéz a los botones
        logInButton.layer.cornerRadius = 5
        logInButton.layer.borderWidth = 0.2
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 0.2
        
        googleButton.layer.cornerRadius = 5
        googleButton.layer.borderWidth = 0.2
        
        facebookButton.layer.cornerRadius = 5
        facebookButton.layer.borderWidth = 0.2
        
        
        //title = "HEME Televisión"
        self.setNavigationBarLogo()
        // Comprobar la sesiòn del usuario autentificado
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider") as? String {
            authStackView.isHidden = true
            navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType.init(rawValue: provider)!), animated: false)
        }
        
        //google auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStackView.isHidden = false
    }
    
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        if let  email = emailTextField.text , let password =
            passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result,error) in
                self.showHome(result: result, error: error, provider: .basic)
            }
        }
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let  email = emailTextField.text , let password =
            passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result,error) in
                self.showHome(result: result, error: error, provider: .basic)
            }
        }
    }
    
    
    
    
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self){ (result) in
            switch result{
                
            case .success(granted: let granted, declined: let declined, token: let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: credential){ (result, error) in
                    self.showHome(result: result, error: error, provider: .facebook)
                    
                }
            case .cancelled:
                break
            case .failed:
                break
            }
        }
    }
    private func showHome(result: AuthDataResult?, error : Error?, provider: ProviderType){
        if let result = result, error == nil{
            self.navigationController?
                .pushViewController(HomeViewController(email: result.user.email! , provider: provider), animated: true)
        }else{
            let alertController = UIAlertController(title: "Error", message: "Se ha producido un error de autenticaciòn", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}

extension AuthViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential){ (result, error) in
                self.showHome(result: result, error: error, provider: .google)
            }
        }
    }
    func setNavigationBarLogo() {
            let logo = UIImage(named: "splashImage.png")
             let imageView = UIImageView(image: logo)
            imageView.contentMode = .scaleAspectFit
        //self.navigationItem.standardAppearance?.backgroundColor = UIColor.init(coder: # )
             self.navigationItem.titleView = imageView
        }
}
