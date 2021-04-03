//
//  ViewController.swift
//  bigFloppa2
//
//  Created by Katerina Katigaridi on 27.03.2021.
//

// I studied using Russian translations of what I think is 2019 edition of Stanford lections made by Ivan Skorokhod on YouTube. https://www.youtube.com/channel/UChfEfFKYILtO5yZSX2irynw

import UIKit


// Adding interface for button border manipulation found here https://stackoverflow.com/a/48470255
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class ViewController: UIViewController {

    lazy var amountOfButtons = (buttonCollection.count + 1) / 2;
    lazy var game = ConcentrationGame(numberOfPairsOfCards: amountOfButtons);

    func flipButton(_ emoji: String, _ button: UIButton, _ background: UIColor){
        if button.currentTitle == emoji{
            button.setTitle("", for: .normal);
            button.backgroundColor = background;
        }
        else{
            button.setTitle(emoji, for: .normal);
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        }
    }
    
    var touches: Int = 0{
        didSet{
            touchesLabel.text = "Touches: \(touches)";
        }
    }
    
    // made a function to generate a random list of emojis based on the amount of buttons in buttonCollection
    func makeEmojiList(_ amount: Int) -> [String]{
        var emojiPool = ["🐝", "🐢", "🐋", "🦑", "🐂", "🦋", "🐙", "🐣", "🪲", "🐡", "🐁", "🐃", "🦉"];
        emojiPool.shuffle()
        let resultingArray = Array(emojiPool[0...amount-1])
        print("Emojis used:", resultingArray.joined(separator: ", "))
        return resultingArray
    }
    
    @IBOutlet var buttonCollection: [UIButton]!
    

    
    lazy var emojiCollection = makeEmojiList(amountOfButtons)
    var emojiDictionary = [Int:String]();
    
    func emojiIdentifier(for card: Card) -> String{
        if emojiDictionary[card.identifier] == nil{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiCollection.count)))
            emojiDictionary[card.identifier] = emojiCollection.remove(at: randomIndex);
        }
        return emojiDictionary[card.identifier] ?? "?";
    }
    
    var matchedEmojis = [String]();
    
    func updateViewFromModel(){
        for index in buttonCollection.indices{
            let button = buttonCollection[index];
            let card = game.cards[index];
            
            let currentEmoji = emojiIdentifier(for: card);
            
            if card.isFaceUp{
                button.setTitle(currentEmoji, for: .normal);  // emojiCollection[index] ???
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 1;
                button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
            }else{
                button.setTitle("", for: .normal);
//                if card.isMatched == true{
//                    if !matchedEmojis.contains(currentEmoji){
//
//                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0);
//                        matchedEmojis.append(currentEmoji);
//                        if alreadyGuessedLabel.text! == "" {
//                            alreadyGuessedLabel.text = "Already guessed:"
//
//                            matchedEmojisList.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1);
//                            matchedEmojisList.layer.cornerRadius = 5;
//                            matchedEmojisList.layer.borderWidth = 1;
//                        }
//                        matchedEmojisList.text = "  " + matchedEmojis.joined(separator: " ")
//                    }
//
//                }else{
//                    button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1);
//                }
                
                // button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1);
                
                
            }
        }
    }
    
    
    @IBOutlet weak var alreadyGuessedLabel: UILabel!
    @IBOutlet weak var matchedEmojisList: UITextField!;
    
    @IBOutlet weak var touchesLabel: UILabel!
    @IBAction func buttonAction(_ sender: UIButton) {
        touches += 1;
        if let buttonIndex = buttonCollection.firstIndex(of: sender){
            
            game.chooseCard(at: buttonIndex)
//            flipButton(emojiCollection[buttonIndex],
//                       sender,
//                       colorCollection[buttonIndex])
            updateViewFromModel();
            	
        }
        
    }
    
}


// By the end of Lection 1 I decided to make emoji lists great
// again so I made two functions for randoms lists of emojis and
// button colors for fun and to complicate the code a bit.

func makeEmojiArray()-> [String]{
    var emojis = ["🐝", "🐢", "🐋", "🦑", "🐂"]
    emojis.shuffle()
    
    // at this point I realized I need to count the number of buttons / 2, but how would I do it. I didn't care much about static/lazy so I decided to stop here and just type in 7. It was pretty and worked fine.
    
    emojis = Array(emojis[0...7]);
    var result: [String] = [];
    for x in emojis{
        result += Array(repeating: x, count: 2);
    }
    result.shuffle()
    return result
}
var emojiCollection = makeEmojiArray();

//Same thing as makeEmojiArray() but for background colors.
func makeColorArray()-> [UIColor]{
    var colors = [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)];
    colors.shuffle()
    colors = Array(colors[0...7]);
    var result: [UIColor] = [];
    for x in colors{
        result += Array(repeating: x, count: 2)
    }
    result.shuffle()
    return result
}
var colorCollection = makeColorArray();
