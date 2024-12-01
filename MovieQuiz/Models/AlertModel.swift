//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Tenzin Sangadzhiev on 12/1/24.
//

import Foundation

/// Модель данных для отображения алерта
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
