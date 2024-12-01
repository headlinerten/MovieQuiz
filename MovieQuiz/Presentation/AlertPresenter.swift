//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Tenzin Sangadzhiev on 12/1/24.
//

import UIKit

/// Класс, отвечающий за отображение алертов.
final class AlertPresenter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    /// Показывает алерт на основе данных QuizResultsViewModel
    func showQuizResult(_ result: QuizResultsViewModel, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            completion()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
