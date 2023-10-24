//
//  ViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 01/10/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        
        //Deslogar o usuario
        //        do {
        //            try autenticacao.signOut()
        //        } catch  {
        //            print("erro")
        //        }
        
        autenticacao.addStateDidChangeListener { autenticacao, usuario in
            
            if let usuarioLogado = usuario {
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
}

