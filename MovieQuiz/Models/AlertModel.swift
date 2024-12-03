import Foundation

/// Модель данных для отображения алерта
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
