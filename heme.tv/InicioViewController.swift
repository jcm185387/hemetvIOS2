//
//  InicioViewController.swift
//  heme.tv
//
//  Created by Alvaro Hernandez Melo on 06/12/20.
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

class InicioViewController: UIViewController {
    
    private let provider: ProviderType
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarLogo()

        // Do any additional setup after loading the view.
        
        //Logoutcode
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Cerrar sesión", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.LogOut))
        
        self.navigationItem.rightBarButtonItem = logButton
        
        //Botón de borrar mi cuenta
        let deleteAccount : UIBarButtonItem = UIBarButtonItem ( title: "Borrar cuenta", style: .plain, target: self, action: #selector(self.deleteAccount))
            // Cambiar esta parte para agregar un menú elegante para borrar la cuenta, en esa secciòn tambièn se agregarìa el nombre de usuario autenticado y el correo, incluso puede agregársele una foto
            //style: UIBarButtonItem.Style.done, target: self, action: "deleteAccount")
        
        self.navigationItem.leftBarButtonItem = deleteAccount

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
    
    private func firebaseLogout(){
        do {
            try Auth.auth().signOut()

        }catch{
            // se ha producido un error
        }
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
