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
    
    // Add our brains to the equation
    let questionAnswerer = MyQuestionAnswerer()
    
    var body: some View {
        VStack {
            Spacer().frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 44) // To account for the notch we have a little space at the top
            HStack {
                Text("🤖")
                    .font(.largeTitle)
                    .padding()
                Text(self.responseText)
                Spacer()
            }
            TextField("Type your question...", text: $question)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 120)
                .background(Color.white)
            Button("Ask") {
                // ask the question...
                // And assign the answer to our `answerText` property to be displayed in the UI.
                self.responseText = self.questionAnswerer.responseTo(question: self.question)
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 44)
            .foregroundColor(.white)
            .background(Color.blue)
         Spacer()
        }
        .background(Color(UIColor.systemGray4))
        .edgesIgnoringSafeArea(.all) // This necessitates the Spacer() which is our first element in the VStack,
        // but it will also color the whole background light gray...
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
