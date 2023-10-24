//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 14/10/23.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString//GERAR IDENTIFICADOR UNICO PARA CADA IMAGEM

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //desabilita o botão proximo
        botaoProximo.isEnabled = false
        botaoProximo.backgroundColor = UIColor.gray

    }
    
    
    @IBAction func proximoPasso(_ sender: Any) {
        
        self.botaoProximo.isEnabled = false
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        
        //Recuperar a imagem
        if let imagemSelecionada = imagem.image {
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.1) {
               let imagemSalva =  imagens.child("\(self.idImagem).jpg")
                    imagemSalva.putData(imagemDados) { metaDados, erro in
                    
                    if erro == nil {
                        print("Sucesso ao fazer o upload do Arquivo")
                        
                        imagemSalva.downloadURL { url, erro in
                            guard let url = url else {return}
                           
                            
                            self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url.absoluteString)
                        }

                        
                        self.botaoProximo.isEnabled = true
                        self.botaoProximo.setTitle("Próximo", for: .normal)
                    }else {
                        print("Erro ao fazer o upload do Arquivo")
                        let alerta = Alerta(titulo: "Upload falhou", mensagem: "Erro ao salvar o arquivo, tente novamente!")
                        self.present(alerta.getAlerta(), animated: true)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue" {
            
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
        }
            
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagem.image = imagemRecuperada
        
        //Habilita botão proximo
        
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
   
        imagePicker.dismiss(animated: true)
    }

}
