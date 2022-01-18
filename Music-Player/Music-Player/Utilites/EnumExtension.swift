//
//  Enum.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/18.
//

import SwiftUI

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func previous() -> Self {
        let all = Self.allCases
        guard let idx = all.firstIndex(of: self) else { return self }
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.index(before: all.endIndex) : previous]
    }

    func next() -> Self {
        let all = Self.allCases
        guard let idx = all.firstIndex(of: self) else { return self }
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}
