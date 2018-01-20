//
//  DictionaryRepresentable.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 13/01/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

protocol DictionaryRepresentable {
    
    init?(dictionary: [String: Any])
    var dictionaryRepresentation: [String: Any] {get}
}
