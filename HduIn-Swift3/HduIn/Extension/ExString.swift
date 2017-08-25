//
//  ExString.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/9/26.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import Foundation

extension String {

    func split(_ str: Character) -> [String] {
        return self.characters.split {
            $0 == str
        }.map {
            String($0)
        }
    }

    var URLEscapedString: String {
        return self.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlHostAllowed
        )!
    }
}
