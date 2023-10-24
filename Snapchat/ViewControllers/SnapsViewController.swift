//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 14/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snap] = []
    
    let autenticacao = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            //Cria ouvinte para Snaps
            snaps.observe(DataEventType.childAdded) { snapshot in
                
                let dados = snapshot.value as? NSDictionary
                
                let snap = Snap()
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao = dados?["descricao"] as! String
                snap.urlImagem = dados?["urlImagem"] as! String
                snap.idImagem = dados?["idImagem"] as! String
                
                self.snaps.append(snap)
                self.tableView.reloadData()
                
            }
            
            //Adiciona evento para item removido
            snaps.observe(DataEventType.childRemoved) { snapshot in
                
                var indice = 0
                for snap in self.snaps{
                    
                    if snap.identificador == snapshot.key {
                        self.snaps.remove(at: indice)
                    }
                    indice = indice + 1
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func sair(_ sender: Any) {
        do {
            try autenticacao.signOut()
            dismiss(animated: true)
        } catch  {
            print("Erro ao deslogar o usuario")
        }
    }
    
}

extension SnapsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = snaps.count
        if totalSnaps == 0{
            return 1
        }
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let totalSnaps = snaps.count
        if totalSnaps == 0{
            celula.textLabel?.text = "Nenhum snap para você!"
        }else{
            
            let snap = self.snaps[indexPath.row]
            celula.textLabel?.text = snap.nome
        }
        
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalSnaps = snaps.count
        if totalSnaps > 0{
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesSnapSegue" {
            
            let detalhesSnapViewController = segue.destination as! DetalhesSnapViewController
            
            detalhesSnapViewController.snap = sender as! Snap
            
        }
    }
}
