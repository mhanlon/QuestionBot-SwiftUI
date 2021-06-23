//
//  QuestionAnswerer.swift
//  QuestionBot-SwiftUI
//
//  Created by Matthew Hanlon on 02/02/2021.
//

import Foundation

struct MyQuestionAnswerer {
    func responseTo(question: String) -> String {
        // TODO: Write a response
        // Add in your logic so this is a bit more interesting...
        var answer = ""
        
        switch question {
            case "Ahoi" : answer = "Greetings!"
            case "Aloha" : answer = "Mahalo!"
            case "Hola" : answer = "Hola chica!"
            case "Moin" : answer = "Moin"
            case "Servus" : answer = "Ja Servus!"
            default: answer = "... 🤷‍♀️ ?"
        }
        
        return answer
    }
}

