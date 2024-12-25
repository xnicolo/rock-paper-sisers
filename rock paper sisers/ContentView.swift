import SwiftUI

// Define possible choices for Rock, Paper, Scissors
enum Choice: String, CaseIterable {
    case rock = "✊ Rock"     // Fist emoji for Rock
    case paper = "✋ Paper"   // Open hand emoji for Paper
    case scissors = "✌️ Scissors" // Peace sign emoji for Scissors
    
    // Corresponding hand gesture emojis
    var emoji: String {
        switch self {
        case .rock:
            return "✊"   // fist (rock)
        case .paper:
            return "✋"    // open hand (paper)
        case .scissors:
            return "✌️"    // scissors (V-sign)
        }
    }
    
    // Randomly pick a choice for the computer
    static func random() -> Choice {
        return Choice.allCases.randomElement()!
    }
}

struct ContentView: View {
    @State private var userChoice: Choice? = nil
    @State private var computerChoice: Choice? = nil
    @State private var resultMessage: String = "Make your move!"
    @State private var showResult: Bool = false
    @State private var scaleEffect: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 30) {
            // Title and result message with animation
            Text("Rock, Paper, Scissors!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding()
            
            Text(resultMessage)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.green)
                .scaleEffect(scaleEffect)
                .opacity(opacity)
                .animation(.spring(), value: scaleEffect)  // Make the result message bounce
                .animation(.easeIn(duration: 0.5), value: opacity) // Fade in/out
            
            // Display the choices for the user with hand emojis
            HStack(spacing: 40) {
                ForEach(Choice.allCases, id: \.self) { choice in
                    Button(action: {
                        self.handleUserChoice(choice)
                    }) {
                        Text(choice.emoji)
                            .font(.system(size: 120))
                            .padding()
                            .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                            .scaleEffect(userChoice == choice ? 1.1 : 1)  // Scale when selected
                            .animation(.spring(), value: userChoice)   // Bounce effect
                    }
                }
            }
            .padding()

            // Display the user’s and computer’s choices with emojis
            if let userChoice = userChoice, let computerChoice = computerChoice {
                VStack(spacing: 10) {
                    Text("Your choice:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(userChoice.emoji)
                        .font(.system(size: 120))
                        .padding()

                    Text("Computer's choice:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(computerChoice.emoji)
                        .font(.system(size: 120))
                        .padding()
                }
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5), value: userChoice)
            }
        }
        .padding()
        .onChange(of: userChoice) { _ in
            showResult = true
        }
    }
    
    // Handle the user choice and determine the result
    func handleUserChoice(_ choice: Choice) {
        let computerChoice = Choice.random()
        self.userChoice = choice
        self.computerChoice = computerChoice
        
        // Determine winner after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if choice == computerChoice {
                resultMessage = "It's a tie!"
            } else if (choice == .rock && computerChoice == .scissors) ||
                        (choice == .paper && computerChoice == .rock) ||
                        (choice == .scissors && computerChoice == .paper) {
                resultMessage = "You win!"
            } else {
                resultMessage = "Computer wins!"
            }
            scaleEffect = 1.2  // Result message bounce
            opacity = 1.0      // Show result message
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

