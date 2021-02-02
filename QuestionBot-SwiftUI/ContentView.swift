//
//  ContentView.swift
//  QuestionBot-SwiftUI
//
//  Created by Matthew Hanlon on 02/02/2021.
//

import SwiftUI

struct ContentView: View {
    var responseText: String = "Hello Human, I'm QuestionBot.\nAsk me a question."
    @State var question: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("🤖")
                    .font(.largeTitle)
                Text(self.responseText)
            }
            TextField("Type your question...", text: $question)
            Button("Ask") {
                // ask the question...
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
