//
//  ViewController.swift
//  Project2
//
//  Created by Lorenzo Pesci on 06/11/2019.
//  Copyright © 2019 Lorenzo Pesci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionAnswered = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func askQuestion(action: UIAlertAction!) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "           Score: \(score)".uppercased() + "        Question: \(questionAnswered)/10"
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        let finalScore = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)
        let wrongAnswer = UIAlertController(title: "Wrong!", message: "That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            wrongAnswer.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(wrongAnswer, animated: true)
        }
        
        if questionAnswered == 10 {
            questionAnswered = 0
            score = 0
            finalScore.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(finalScore, animated: true)
       
        } else if questionAnswered < 10 {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            questionAnswered += 1
            
        }
    }
    
}

