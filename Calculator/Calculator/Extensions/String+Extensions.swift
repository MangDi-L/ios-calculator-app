//
//  String+Extensions.swift
//  Calculator
//
//  Created by 나이든별, 민쏜
//

import Foundation

extension String {
    func split(with target: Character) -> [String] {
        let data = self.map { $0 }
        var result = [String]()
        var storage = ""
        
        data.forEach {
            if $0 == target {
                result.append(storage)
                
                let operatorValue = String($0)
                result.append(operatorValue)
                
                storage = ""
            } else {
                let letter = String($0)
                storage += letter
            }
        }
        
        if storage.isNotEmpty {
            result.append(storage)
        }
        
        return result
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
