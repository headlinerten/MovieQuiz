//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Tenzin Sangadzhiev on 12/1/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
