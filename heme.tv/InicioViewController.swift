//
//  InicioViewController.swift
//  heme.tv
//
//  Created by Alvaro Hernandez Melo on 06/12/20.
//

import UIKit
import WebKit
import FirebaseAuth


class InicioViewController: UIViewController {
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarLogo()
        // Do any additional setup after loading the view.
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        //Logoutcode
        
        //1.- COMENTAREMOS ESTA SECCIÓN Y AGREGAREMOS UN MENÚ ELEGANTE PARA AGREGAR EL LINK AL LOGIN
        /*
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Cerrar sesión", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.LogOut))
        
        self.navigationItem.rightBarButtonItem = logButton
        
        //Botón de borrar mi cuenta
        let deleteAccount : UIBarButtonItem = UIBarButtonItem ( title: "Borrar cuenta", style: .plain, target: self, action: #selector(self.deleteAccount))
            // Cambiar esta parte para agregar un menú elegante para borrar la cuenta, en esa secciòn tambièn se agregarìa el nombre de usuario autenticado y el correo, incluso puede agregársele una foto
            //style: UIBarButtonItem.Style.done, target: self, action: "deleteAccount")
        
        self.navigationItem.leftBarButtonItem = deleteAccount
         */
        /*TERMINA LA COMENTADA */
        
        // SECCIÓN QUE CARGA EL WEBVIEW
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
    
    private func load(url: String){
        webView.load(URLRequest(url: URL(string: url)!))
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
        
        /*
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
        navigationController?.popViewController(animated: true)*/
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
extension InicioViewController {
    func setNavigationBarLogo() {
        let logo = UIImage(named: "splashImage.png")
         let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
         self.navigationItem.titleView = imageView
    }
}
