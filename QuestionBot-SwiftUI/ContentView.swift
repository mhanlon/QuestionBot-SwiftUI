//
//  ContentView.swift
//  QuestionBot-SwiftUI
//
//  Created by Matthew Hanlon on 02/02/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var responseText: String = "Hello Human, I'm QuestionBot.\nAsk me a question." // Add an @State property wrapper
    @State var question: String = ""
    
    //Let's use some haptic feedback when we get an answer from the bot
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State var communication : [String : String] = [:]
    
    // Add our brains to the equation
    let questionAnswerer = MyQuestionAnswerer()
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("🤖")
                    .font(.custom("Helvetica Neue", size: 60))
                Spacer(minLength: 10)
                Text(self.responseText)
                    .font(.title3)
                Spacer()
            }
            
            //OPTION 1: Multi line question
            TextEditor(text: $question)
                .frame(height: 100)
                //.keyboardType(.webSearch)
                .cornerRadius(10)
                
            //OPTION 2: Single line question
            
//             TextField("Type your question...", text: $question)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                //.frame(maxHeight: 100)
//                //.background(Color(.white))
//
            Text("Enter your question above and see what the bot will answer...")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                .foregroundColor(Color(.gray))
            Button("Ask me!") {
                // ask the question...
                // And assign the answer to our `answerText` property to be displayed in the UI.
                self.responseText = self.questionAnswerer.responseTo(question: self.question)
                
                self.communication[self.question] = self.responseText
                
                if self.responseText.isEmpty || self.responseText == "🤷‍♀️" {
                    self.feedback.notificationOccurred(.error)
                } else {
                    self.feedback.notificationOccurred(.success)
                }
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
            Spacer()
            
            List {
                ForEach(self.communication.keys.sorted(), id: \.self) { comm in
                    
                    Section(footer: Text("\(Date(), formatter: Self.dateFormat)")) {
                        HStack {
                            Spacer()
                            Text(comm)
                        }
                        .listRowBackground(Color.accentColor)
                        Text(self.communication[comm]!)
                            .listRowBackground(Color.gray)
                    }
                    
                }
            }
            .listStyle(.insetGrouped)
            .frame(maxHeight: 400)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray4).edgesIgnoringSafeArea(.all))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 12 Pro")
        }

    }
}
