//
//  ViewController.swift
//  Project27
//
//  Created by Lorenzo Pesci on 27/04/2020.
//  Copyright © 2020 Lorenzo Pesci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquare()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            writeTwin()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for col in 0..<8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquare() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var lenght: CGFloat = 256
            
            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: lenght, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: lenght, y: 50))
                }
                lenght *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = img
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
          ctx.cgContext.translateBy(x: 256, y: 256)
          
          let rotations = 5
          let amount = (Double.pi) / 2.5
          
          ctx.cgContext.rotate(by: .pi / 5.7)
          
          ctx.cgContext.move(to: CGPoint(x: -11, y: 130))
          
          for _ in 0 ..< rotations {
            ctx.cgContext.addLine(to: CGPoint(x: -30, y: 30))
            ctx.cgContext.addLine(to: CGPoint(x: -128, y: 30))
            ctx.cgContext.rotate(by: CGFloat(amount))
          }
          
          ctx.cgContext.setFillColor(UIColor.red.cgColor)
          
          ctx.cgContext.drawPath(using: .fill)
        }
        
        imageView.image = img
    }
    
    func writeTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
          
          let img = renderer.image { ctx in
            let spacing = 15
            var letterStartingPoint = 15
            let lenghtLineLetter = 50
            
            // Start String
            ctx.cgContext.translateBy(x: 187, y: 228)
            
            // Letter T
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: lenghtLineLetter))
            
            ctx.cgContext.move(to: CGPoint(x: -(lenghtLineLetter / 2), y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: lenghtLineLetter / 2, y: 0))
            
            letterStartingPoint += lenghtLineLetter / 2
            
            // Letter W
            var spacingW = letterStartingPoint
            for _ in 0 ..< 2 {
              ctx.cgContext.move(to: CGPoint(x: spacingW, y: 0))
              spacingW += 12
              ctx.cgContext.addLine(to: CGPoint(x: spacingW, y: lenghtLineLetter))
              
              ctx.cgContext.move(to: CGPoint(x: spacingW, y: lenghtLineLetter))
              spacingW += 12
              ctx.cgContext.addLine(to: CGPoint(x: spacingW, y: 0))
            }
            
            letterStartingPoint = spacingW + spacing
            
            // Letter I
            ctx.cgContext.move(to: CGPoint(x: letterStartingPoint, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: letterStartingPoint, y: lenghtLineLetter))
            
            letterStartingPoint += spacing
            
            // Letter N
            var spacingN = letterStartingPoint
            for lineOfLetterN in 0 ..< 3 {
              ctx.cgContext.move(to: CGPoint(x: spacingN, y: 0))
              
              if lineOfLetterN == 1 { spacingN += lenghtLineLetter / 2 }
              
              ctx.cgContext.addLine(to: CGPoint(x: spacingN, y: lenghtLineLetter))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
          }
          
          imageView.image = img
        }
}

