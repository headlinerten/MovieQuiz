import UIKit

/// Класс, отвечающий за отображение алертов.
final class AlertPresenter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    /// Показывает алерт на основе данных QuizResultsViewModel
    func showQuizResult(viewModel: QuizResultsViewModel, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: viewModel.buttonText, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
