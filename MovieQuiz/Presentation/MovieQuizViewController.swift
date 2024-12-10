import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    /// общее количество вопросов для квиза
    private let questionsAmount: Int = 10
    /// фабрика вопросов. Контроллер будет обращаться за вопросами к ней
    private var questionFactory: QuestionFactoryProtocol?
    /// вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    /// объявление свойства alertPresenter в контроллере
    private var alertPresenter: AlertPresenter?
    /// переменная с индексом текущего вопроса, начальное значение 0 (так как индекс в массиве начинается с 0)
    private var currentQuestionIndex = 0
    /// переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    /// добавим свойство типа StatisticServiceProtocol, чтобы наш контроллер мог работать с сервисом
    private var statisticService: StatisticServiceProtocol?
     
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
       imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Methods
    /// приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        // Сбрасываем рамку
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    /// приватный метод конвертации, который принимает вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    /// приватный метод, который содержит логику перехода в один из сценариев
    /// метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // Сохраняем результат текущего раунда
            statisticService?.store(correct: correctAnswers, total: questionsAmount)

            // Форматирование даты для "Рекорда"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm" // Формат: день.месяц.год часы:минуты
            let bestGameDate = statisticService?.bestGame.date ?? Date()
            let formattedDate = dateFormatter.string(from: bestGameDate)
            
            // Формируем текст для алерта
            let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
            Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(formattedDate))
            Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%
            """
            
            // Отображаем алерт
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: message,
                buttonText: "Сыграть ещё раз"
            )
            
            alertPresenter?.showQuizResult(
                viewModel: resultViewModel,
                message: message
            ) { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
        
    private func showAnswerResult(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
            
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {return}
                self.showNextQuestionOrResults()
            }
        }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(in: self, model: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    
        // MARK: - Actions
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = true
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = false
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }
