//
//  Beverages.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 21/01/21.
//

import Foundation
import UIKit
struct Beverages{
    var name: String
    var price: Int
    var image: UIImage
    var firstOpt: String
    var sncOpt: String
    var shouldHaveSegment: Bool? = false
    var isMarked: Bool
    var segmentSelected: Int?
}
