//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 21/10/23.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class DetalhesSnapViewController: UIViewController {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var snap = Snap()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detalhes.text = "Carregando..."
        
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { imagem, erro, cache, url in
            
            if erro == nil {
                
                self.detalhes.text = self.snap.descricao
               
            //Inicializar o timer
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    
                    //decrementar o timer
                    self.tempo = self.tempo - 1
                    
                    //Exibir timer na tela
                    self.contador.text = String(self.tempo)
                    
                    //Caso o timer execute ate o 0, invalida
                    if self.tempo == 0{
                        timer.invalidate()
                        self.dismiss(animated: true)
                    }
                }
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            //Remove nos do database
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
           snaps.child(snap.identificador).removeValue()
            
            //Remove imagem do Snap
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child("\(snap.idImagem).jpg").delete
            { erro in

                if erro == nil{
                    print("Sucesso ao excluir a imagem")
                }else{
                    print("Erro ao excluir a imagem")
                }
            }
        }
    }
}
