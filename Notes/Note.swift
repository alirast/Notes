//
//  Note.swift
//  Notes
//
//  Created by n on 15.11.2022.
//

import UIKit
class Note: NSObject, Codable {
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }

}
