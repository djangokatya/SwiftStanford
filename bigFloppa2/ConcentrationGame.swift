//
//  ConcentrationGame.swift
//  bigFloppa2
//
//  Created by Катя Катигариди on 28.03.2021.
//

import Foundation

class ConcentrationGame{
    var cards = [Card]();
    
    var indexOfOneAndOnlyFaceUpCard: Int?;
    
    func chooseCard(at index: Int){
        if !cards[index].isMatched{
            if let matchingIndex = indexOfOneAndOnlyFaceUpCard, matchingIndex != index{
                if cards[matchingIndex].identifier == cards[index].identifier{
                    cards[matchingIndex].isMatched = true;
                    cards[index].isMatched = true;
                }
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = nil;
            } else{
                for flipDown in cards.indices{
                    cards[flipDown].isFaceUp = false;
                }
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = index;
            }
            
        }
        
    }
    init(numberOfPairsOfCards: Int){
        for _ in 1...numberOfPairsOfCards{
            let card = Card();
            cards += [card, card];
            
        }
        // As a Python developoler I love all these data manipulations so much, shuffle is not an exception
        self.cards.shuffle();
    }
}
