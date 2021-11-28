//
//  String+Extension.swift
//  Calculator
//
//  Created by Seul Mac on 2021/11/13.
//

import Foundation

extension String {
    func split(with target: Character) -> [String] {
       return self.split(separator: target).map { String($0)}
    }
}