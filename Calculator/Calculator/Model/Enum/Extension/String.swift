//
//  String.swift
//  Calculator
//
//  Created by 김동용 on 2022/05/20.
//

extension String {
    func split(with target: Character) -> [String] {
        return self.split(separator: target).map { String($0) }
    }
}
