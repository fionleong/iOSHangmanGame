import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var hangmanword: UILabel!
    @IBOutlet var checkPressedButton: UILabel!
    @IBOutlet var currentWord: UILabel!
    @IBOutlet var lifeLabel: UILabel!
    @IBOutlet var gameStatusLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    
    var hmWordArray = [Character]()
    var dashStringArray = [Character]()
    var dashString: String = ""
    var hmWord: String = ""
    var counter = 10
    var matched = false
    var charLeft = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read in the words.txt and hints.txt
        let wordsArray = linesFromResource(fileName: "words.txt")
        let hintsArray = linesFromResource(fileName: "hints.txt")
        
        let wordsArrayLength = wordsArray.count
        
        // Create a random number to pick from the list of words
        let randomNumber: Int = Int(arc4random_uniform(UInt32(wordsArrayLength)))
        
        // Getting the random word from the array
        let randomWord = wordsArray[randomNumber]
        let randomHint = hintsArray[randomNumber]
        
        hintLabel.text = "Hint: ".appending(randomHint)
        hmWord = randomWord
        
        charLeft = hmWord.characters.count
        
        // Put hmWord into an array of characters
        hmWordArray = Array(hmWord.characters)
        
        // Put dashString into an array of characters
        dashStringArray = Array(dashString.characters)
        
        // Display dashString according to the hmWord
        displayWord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func linesFromResource(fileName: String) -> [String] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil)
            else {
            fatalError("Resource file for \(fileName) not found.")
        }
        do {
            let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch let error {
            fatalError("Could not load strings from \(path): \(error).")
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Set buttonLetter to the current Letter
        let buttonLetter: String = sender.currentTitle!
        
        checkPressedButton.text = "Button Selected: ".appending(buttonLetter)
        
        for (index, _) in hmWordArray.enumerated()
        {
            // Check if char at index is equal to buttonLetter, if it is, replace hmWord[index] with *
            let hmWordChar = String(hmWordArray[index])
            if (buttonLetter == hmWordChar)
            {
                hmWordArray[index] = "*"
                charLeft -= 1
                matched = true;
            }
        }
        updateLife()
        checkGameStatus()
        displayWord()
    }
    
    func displayWord() {
        var newDashString = ""
        let startIndex = hmWord.startIndex
        let endIndex = hmWord.endIndex
        
        for index in 0...hmWord.characters.count - 1 {
            if(hmWordArray[index] == " ") {
                newDashString += "   ";
            }
            else if (String(hmWordArray[index]) == "*") {
                newDashString += String(hmWord[hmWord.index(startIndex, offsetBy: index, limitedBy: endIndex)!])
            }
            else {
                newDashString += "_ ";
            }
        }
        dashString = newDashString
        hangmanword.text = dashString;
    }
    
    func updateLife() {
        if (matched == true) {
            matched = false
        }
        else
        {
            counter -= 1
            lifeLabel.text = "Life: ".appending(String(counter))
        }
    }
    
    func checkGameStatus() {
        if (charLeft == 0)
        {
            gameStatusLabel.text = "YOU'VE WON!"
        }
        if (counter == 0)
        {
            gameStatusLabel.text = "GAME OVER"
        }
        
    }
}

