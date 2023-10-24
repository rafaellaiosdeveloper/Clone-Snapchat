//
//  EntrarViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 01/10/23.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func entrar(_ sender: Any) {
        
        //Recuperar dados digitados
        if let emailR = self.email.text{
            if let senhaR = self.senha.text{
                
                //Autenticar usuário no Firebase
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailR, password: senhaR) { usuario, erro in
                    
                    if erro == nil {
                        if usuario == nil {
                            let alerta = Alerta(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação,tente novamente.")
                            
                        }else{
                            
                            //redireciona usuario para tela principal
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                        
                    }else{
                        let alerta = Alerta(titulo: "Dados incorretos", mensagem: "Verifique os dados digitados e tente novamente ")
                        self.present(alerta.getAlerta(), animated: true)
                        
                    }
                }
            }
        }
    }
}
