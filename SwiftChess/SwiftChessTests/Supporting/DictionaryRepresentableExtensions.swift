//
//  DictionaryRepresentableExtensions.swift
//  SwiftChessExampleTests
//
//  Created by Steve Barnegren on 13/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import SwiftChess

extension DictionaryRepresentable {
    
    var toDictionaryAndBack: Self? {
        
        let dictionary = self.dictionaryRepresentation
        return Self(dictionary: dictionary)
    }
}
