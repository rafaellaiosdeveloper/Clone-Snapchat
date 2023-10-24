//
//  Alerta.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 18/10/23.
//

import UIKit

class Alerta {
    
    var titulo: String
    var mensagem: String
    
    init(titulo: String, mensagem: String) {
        self.titulo = titulo
        self.mensagem = mensagem
    }
    
    func getAlerta() -> UIAlertController {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addAction(acaoCancelar)
        return alerta
    }
}
