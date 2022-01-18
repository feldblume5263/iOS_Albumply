//
//  Enum.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/18.
//

import SwiftUI

// MARK: - Enum 순환을 위한 Extension - https://stackoverflow.com/questions/51103795/how-to-get-next-case-of-enumi-e-write-a-circulating-method-in-swift-4-2
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
