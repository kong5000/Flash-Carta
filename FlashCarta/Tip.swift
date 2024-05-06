//
//  Tip.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-05-05.
//

import Foundation
import TipKit

struct TestTip: Tip {
    var title: Text {
        Text("Title")
    }
    
    var message: Text? {
        Text("Tip message")
    }
    
    var image: Image? {
        Image(systemName: "paintpallete")
    }
}
