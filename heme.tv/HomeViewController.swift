//
//  HomeViewController.swift
//  heme.tv
//
//  Created by Alvaro Hernandez Melo on 11/11/20.
//

import UIKit
import WebKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

enum ProviderType: String {
    case basic
    case google
    case facebook
    case apple
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var closeSessionButton: UIButton!
    
    private let email: String
    private let provider: ProviderType
    
    
    init(email: String, provider: ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    private var webView: WKWebView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarLogo()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        //Logoutcode
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Cerrar sesión", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.LogOut))
        
        self.navigationItem.rightBarButtonItem = logButton
        
        //Botón de borrar mi cuenta
        let deleteAccount : UIBarButtonItem = UIBarButtonItem ( title: "Borrar cuenta", style: .plain, target: self, action: #selector(self.deleteAccount))
            // Cambiar esta parte para agregar un menú elegante para borrar la cuenta, en esa secciòn tambièn se agregarìa el nombre de usuario autenticado y el correo, incluso puede agregársele una foto
            //style: UIBarButtonItem.Style.done, target: self, action: "deleteAccount")
        
        self.navigationItem.leftBarButtonItem = deleteAccount

        
        // Guardamos los datos del usuario
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        
        
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        // Do any additional setup after loading the view.
        
        //cargar heme.tv
        
        
        let webViewPrefs = WKPreferences()
        webViewPrefs.javaScriptEnabled  = true
        webViewPrefs.javaScriptCanOpenWindowsAutomatically = true
        let webViewConf =  WKWebViewConfiguration()
        webViewConf.preferences = webViewPrefs
        webView = WKWebView(frame: view.frame, configuration: webViewConf)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
        load(url: "https://heme.tv/")
        
        
    }
    
    @objc func deleteAccount(){
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
            // Account deleted.
            self.LogOut()
            
          }
        }
    }
    
    @objc func LogOut(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider {
        case .basic:
            firebaseLogout()
        case .google:
            
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogout()
        case .facebook:
            LoginManager().logOut()
            firebaseLogout()

        case .apple:
            firebaseLogout()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeSessionButtonAction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider {
        case .basic:
            firebaseLogout()
        case .google:
            
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogout()
        case .facebook:
            LoginManager().logOut()
            firebaseLogout()
        case .apple:
            firebaseLogout()

        }
        navigationController?.popViewController(animated: true)
    }
    
    private func firebaseLogout(){
        do {
            try Auth.auth().signOut()

        }catch{
            // se ha producido un error
        }
    }
        
    private func load(url: String){
        webView.load(URLRequest(url: URL(string: url)!))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
extension HomeViewController {
    func setNavigationBarLogo() {
        let logo = UIImage(named: "splashImage.png")
         let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
         self.navigationItem.titleView = imageView
    }
}
