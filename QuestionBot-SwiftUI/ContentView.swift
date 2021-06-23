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
    
    @State var history : [Greeting] = []
    @State var allHistory : [Greeting] = [] {
        willSet {
            self.history = newValue
        }
    }

     @State var searchText = ""
    
    // Add our brains to the equation
    let questionAnswerer = MyQuestionAnswerer()
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    /*
    init() {
       UITableView.appearance().backgroundColor = .systemGray3
    }
    */
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("🤖")
                    .font(.custom("Helvetica Neue", size: 60))
                Spacer(minLength: 15)
                Text(self.responseText)
                    .font(.title3)
                Spacer()
            }
            
            //OPTION 1: Multi line question
            TextEditor(text: $question)
                .frame(height: 100)
                .cornerRadius(10)
            
            Text("Enter your question above and see what the bot will answer...")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                .foregroundColor(Color(.gray))
            Button("Ask me!") {
                // ask the question...
                // And assign the answer to our `answerText` property to be displayed in the UI.
                self.responseText = self.questionAnswerer.responseTo(question: self.question)
                
                let greeting = Greeting(
                    question: self.question,
                    answer: self.responseText,
                    date: Date())
                self.allHistory.insert(greeting, at: 0)
                
                if self.responseText.isEmpty || self.responseText == "🤷‍♀️" {
                    self.feedback.notificationOccurred(.error)
                } else {
                    self.feedback.notificationOccurred(.success)
                }
                // Reset the question
                self.question = ""
                // Also clear the search text, if we've answered a new question
                self.searchText = ""
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .searchable(text: $searchText)
             .onChange(of: self.searchText) { searchText in
                 if !searchText.isEmpty {
                     history = allHistory.filter { $0.question.lowercased().contains(searchText.lowercased()) || $0.answer.lowercased().contains(searchText.lowercased()) }
                 } else {
                     history = allHistory
                 }
             }
            
            Spacer(minLength: 20)
            
            if self.allHistory.count > 0 {
                HStack{
                    Text("History (\(self.history.count))").font(.title3)
                    Spacer()
                }
                
                TextField("Search:", text: $searchText)
                 .textFieldStyle(.roundedBorder)
                
                List {
                    ForEach(self.history, id: \.self) { comm in
                        
                        Section(footer: Text("\(comm.date, formatter: Self.dateFormat)")) {
                            HStack {
                                Spacer()
                                Text(comm.question)
                            }
                            .listRowBackground(Color.accentColor)
                            //.listRowBackground(Color("QuestionColor"))
                            
                            Text(comm.answer)
                                .listRowBackground(Color.gray)
                                //.listRowBackground(Color("AnswerColor"))
                        }
                        
                    }
                    .onDelete(perform: deleteCommunication)
                }
                .listStyle(.insetGrouped)
                .cornerRadius(10)
                .animation(.easeInOut(duration: 2), value: history)
            }
            
        }
        .padding()
        .background(Color(.systemGray4).edgesIgnoringSafeArea(.all))
        
    }

    func deleteCommunication(at offsets: IndexSet) {
         self.history.remove(atOffsets: offsets)
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 12 Pro")
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
        
    }
}
