//
//  Canvas.swift
//  Karel
//
//  Created by RAJAN on 4/14/17.
//  Copyright © 2017 RAJAN. All rights reserved.
//

import UIKit

protocol CanvasDelegate {
    
    func getKarelDirection() -> KarelDirection
}

class Canvas: UIView, CanvasDelegate {
    
    private var BLOCK_DIM = 0
    
    private var BLOCK_DIM_X = 0
    
    private var BLOCK_DIM_Y = 0
    
    private var DISTANCE_FROM_BOUNDARY = 0
    
    private var currentKarelBlock : BlockData! = nil
    
    private var blocks = [[BlockData]]()
    
    private var delegate: KarelDelegate?
    
    init(frame: CGRect, row: Int = 5, column: Int = 5, backgroundColor: UIColor = UIColor.white, delegate: KarelDelegate) {
        
        super.init(frame: frame)
        self.configureCanvas(row: row, column: column, backgroundColor: backgroundColor)
        self.assignDimensions(row: row, column: column)
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCanvas(row: Int, column: Int, backgroundColor: UIColor) {
        assignBackgroundColor(color: backgroundColor)
        assignDimensions(row: row, column: column)
        calculateDimensions()
    }
    
    private func assignBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    private func assignDimensions(row: Int, column: Int) {
        BLOCK_DIM_Y = row
        BLOCK_DIM_X = column
        calculateDimensions()
    }
    
    private func calculateDimensions() {
        
        BLOCK_DIM = Int(Float(frame.width) / Float(BLOCK_DIM_X))
        if (BLOCK_DIM * BLOCK_DIM_Y) > Int(Float(frame.height)) {
            
            BLOCK_DIM = Int(Float(frame.height) / Float(BLOCK_DIM_Y))
            DISTANCE_FROM_BOUNDARY = Int((Float(frame.width) - (Float(BLOCK_DIM_X) * Float(BLOCK_DIM))) / 2)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let BLOCK_SIZE = CGSize(width: self.BLOCK_DIM, height: self.BLOCK_DIM)
        
        let BLOCK_DIM = Int(self.BLOCK_DIM)
        
        for x in 0...BLOCK_DIM_X-1 {
            
            blocks.append([])
            
            for y in 0...BLOCK_DIM_Y-1 {
                blocks[x].append(BlockData(x: x, y: y))
                
                let blockData = blocks[x][y]
                
                if (x==0 && y==BLOCK_DIM_Y-1) {
                    blockData.HAS_KAREL = true
                    currentKarelBlock = blockData
                }
                
                self.addSubview(BlockView(data: blockData, frame: CGRect(origin: CGPoint(x: DISTANCE_FROM_BOUNDARY + x*BLOCK_DIM, y: y*BLOCK_DIM), size: BLOCK_SIZE), delegate: self))
            }
        }
    }
    
    func moveKarel(direction: KarelDirection) {
    
        let futureKarelBlock = getFutureBlock(direction: direction)
        
        if ((futureKarelBlock) != nil) {
            currentKarelBlock.HAS_KAREL =   false
            futureKarelBlock!.HAS_KAREL  =   true
            currentKarelBlock = futureKarelBlock!
        }
    }
    
    private func getFutureBlock(direction: KarelDirection) -> BlockData? {
        
        let x = currentKarelBlock.x
        let y = currentKarelBlock.y
        
        switch direction {
        case .Left  : return x-1 < 0 ? nil:getBlock(x: x-1, y: y)
        case .Right : return x+1 >= BLOCK_DIM_X ? nil: getBlock(x: x+1, y: y)
        case .Top   : return y-1 < 0 ? nil: getBlock(x: x, y: y-1)
        case .Down  : return y+1 >= BLOCK_DIM_Y ? nil: getBlock(x: x, y: y+1)
        }
    }
    
    private func getBlock(x: Int, y: Int) -> BlockData {
        
        return blocks[x][y]
    }
    
    // MARK: - Canvas delegate
    func getKarelDirection() -> KarelDirection {
        return (delegate?.getKarelDirection())!
    }
    
}
