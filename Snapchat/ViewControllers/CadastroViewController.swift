//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 01/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var senhaConfirmacao: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func criarConta(_ sender: Any) {
        
        //Recuperar dados digitados
        if let emailR = self.email.text {
            if let nomeCompletoR = self.nomeCompleto.text {
                if let senhaR = self.senha.text {
                    if let senhaConfirmacaoR = self.senhaConfirmacao.text {
                        
                        //Validar senha
                        if senhaR == senhaConfirmacaoR {
                            
                            //Validação do nome
                            if nomeCompletoR != ""{
                                
                                //Criar conta no Firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailR, password: senhaR) { usuario, erro in
                                    
                                    if erro == nil {
                                        if usuario == nil {
                                            let alerta = Alerta(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação,tente novamente.")
                                            self.present(alerta.getAlerta(), animated: true)
                                            
                                        }else{
                                            
                                            let database = Database.database().reference()
                                            let usuarios = database.child("usuarios")
                                            
                                            if let user = Auth.auth().currentUser {
                                                let uid = user.uid
                                                
                                                let usuarioDados = ["nome": nomeCompletoR, "email": emailR]
                                                usuarios.child(uid).setValue(usuarioDados)
                                            } else {
                                                // O usuário não está autenticado.
                                            }
                                            
                                            //redireciona usuario para tela principal
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                        }
                                        
                                        
                                        
                                    }else{
                                        //print(erro?.localizedDescription)
                                        //The email address is badly formatted.
                                        //The password must be 6 characters long or more
                                        //The email address is already in use by another account.
                                        
                                        if let codigoErro = erro {
                                            
                                            let erroTexto = codigoErro.localizedDescription
                                            var mensagemErro = ""
                                            switch erroTexto{
                                                
                                            case "The email address is badly formatted.":
                                                mensagemErro = "E-mail inválido, digite um e-mail válido!"
                                                break
                                            case "The password must be 6 characters long or more.":
                                                mensagemErro = "Senha precisa ter no mínimo 6 caracteres, com letras e números."
                                                break
                                            case "The email address is already in use by another account.":
                                                mensagemErro = "Esse e-mail já está sendo utilizado, crie sua conta com outro e-mail."
                                                break
                                            default:
                                                mensagemErro = "Dados digitados estão incorretos."
                                            }
                                            let alerta = Alerta(titulo: "Dados inválidos", mensagem: mensagemErro)
                                            self.present(alerta.getAlerta(), animated: true)
                                            
                                            
                                        }
                                    }//Fim validacao erro Firebase
                                }
                            }else{
                                let alerta = Alerta(titulo: "Dados incorretos", mensagem: "Digite o seu nome para prosseguir!")
                                self.present(alerta.getAlerta(), animated: true)
                            }
                            
                            
                        }else{
                            let alerta = Alerta(titulo: "Dados incorretos", mensagem: "As senhas não estão iguais, digite novamente")
                            self.present(alerta.getAlerta(), animated: true)
                        }//Fim da validacao senha
                    }
                }
            }
        }
    }
}
