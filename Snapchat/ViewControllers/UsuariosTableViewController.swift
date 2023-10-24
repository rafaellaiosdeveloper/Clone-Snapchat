//
//  UsuariosTableViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 18/10/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    var usuarios: [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        
        //Adiciona evento novo usuario adicionado
        usuarios.observe(DataEventType.childAdded) { snapshot in//recuperamos todos os usuarios
            let dados = snapshot.value as? NSDictionary
            
            //Recupera dados do usuario logado
            let autenticacao = Auth.auth()
            let idUsuarioLogado = autenticacao.currentUser?.uid
            
            //Recuperar os dados
            let emailUsuario = dados?["email"] as! String
            let nomeUsuario = dados?["nome"] as! String
            let idUsuario = snapshot.key
            let usuario = Usuario(email: emailUsuario, nome: nomeUsuario, uid: idUsuario)
            
            //adiciona usuario no array
            if idUsuario != idUsuarioLogado {
                self.usuarios.append(usuario)
            }
            
            self.tableView.reloadData()
            
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usuarios.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        // Configurar celula
        let usuario = self.usuarios[indexPath.row]
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = usuario.email
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usuarioSelecionado = self.usuarios[indexPath.row]
        let idUsuarioSelecionado = usuarioSelecionado.uid
        
        //Recupera referencia do banco de dados
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        let snaps = usuarios.child(idUsuarioSelecionado).child("snaps")
        
        //Recuperar dados do usuario logado
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            let usuarioLogado = usuarios.child(idUsuarioLogado)
            usuarioLogado.observeSingleEvent(of: DataEventType.value) { snapshot in
                
                let dados = snapshot.value as? NSDictionary
                
                let snap = [
                    "de" : dados?["email"] as! String,
                    "nome" : dados?["nome"] as! String,
                    "descricao" : self.descricao,
                    "urlImagem" : self.urlImagem,
                    "idImagem" : self.idImagem
                ]
                snaps.childByAutoId().setValue(snap)//criar id automatico para o nó
                self.navigationController?.popToRootViewController(animated: true)//volta para a viewController principal
            }
        }
    }
    
}
