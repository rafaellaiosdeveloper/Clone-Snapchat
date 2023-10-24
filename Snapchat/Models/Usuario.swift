//
//  Usuario.swift
//  Snapchat
//
//  Created by Rafaella Rodrigues Santos on 18/10/23.
//

import Foundation

class Usuario {
    
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String) {
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}
