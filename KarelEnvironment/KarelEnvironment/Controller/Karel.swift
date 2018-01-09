//
//  Karel.swift
//  Karel
//
//  Created by RAJAN on 4/16/17.
//  Copyright © 2017 RAJAN. All rights reserved.
//

import Foundation
import UIKit

protocol KarelDelegate {
    
    func getKarelDirection() -> KarelDirection
}

public class Karel: KarelDelegate{
    
    let data: KarelData?
    
    var karelEnvironmentView: UIView?
    
    var canvas: Canvas?
    
    public init(view: UIView, row: Int = 5, column: Int = 5, backgroundColor: UIColor = UIColor.white) {
        
        karelEnvironmentView     = view
        data                     = KarelData()
        canvas                   = Canvas(frame: (karelEnvironmentView?.bounds)!, row: row, column: column, backgroundColor: backgroundColor, delegate: self)
        self.karelEnvironmentView?.addSubview(self.canvas!)
    }
    
    public func move() {
        canvas!.moveKarel(direction: data!.direction)
    }
    
    public func turnLeft() {
        data!.turnLeft()
    }
    
    public func turnRight() {
        data!.turnRight()
    }
    
    func getKarelDirection() -> KarelDirection {
        return data!.direction
    }

}
