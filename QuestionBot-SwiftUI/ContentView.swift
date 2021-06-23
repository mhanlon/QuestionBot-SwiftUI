//
//  ContentView.swift
//  QuestionBot-SwiftUI
//
//  Created by Matthew Hanlon on 02/02/2021.
//

import SwiftUI

struct Greeting : Hashable {
    let uuid = UUID()
    let question : String
    let answer : String
    let date : Date
}

struct ContentView: View {
    
    @State var responseText: String = "Hello Human, I'm QuestionBot.\nAsk me a question." // Add an @State property wrapper
    @State var question: String = ""
    
    //Let's use some haptic feedback when we get an answer from the bot
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State var communication : [Greeting] = []
    
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
                
                let greeting = Greeting(question: self.question, answer: self.responseText, date: Date())
                self.communication.insert(greeting, at: 0)
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
            
            HStack{
                Text("History (\(self.communication.count))").font(.title3)
                Spacer()
            }
            List {
                ForEach(self.communication, id: \.uuid) { comm in
                    
                    Section(footer: Text("\(comm.date, formatter: Self.dateFormat)")) {
                        HStack {
                            Spacer()
                            Text(comm.question)
                        }
                        .listRowBackground(Color.accentColor)
                        Text(comm.answer)
                            .listRowBackground(Color.gray)
                    }
                }
            }
            .animation(.easeInOut)
            .listStyle(.insetGrouped)
            .frame(maxHeight: 350)
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
