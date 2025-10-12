MovieQuiz

MovieQuiz is an iOS quiz app built in Swift that challenges users to guess movie titles based on hints, scenes, or other clues. The project is built using the Model-View-Presenter (MVP) architecture and includes unit/UI tests to ensure robustness.

Table of Contents
	•	Features
	•	Architecture & Design
	•	Requirements
	•	Setup & Installation
	•	Running the App
	•	Testing
	•	Folder Structure
	•	Contributing
	•	License

Features
	•	Quiz gameplay with movie-related questions
	•	Multiple-choice answers
	•	Score tracking
	•	Smooth UI transitions
	•	Support for localization (if applicable)
	•	Unit tests & UI tests included

Architecture & Design

MovieQuiz follows the MVP (Model-View-Presenter) architecture, which separates concerns clearly:
	•	Model: holds the data types, quiz logic, and question / movie data.
	•	Presenter: orchestrates the interactions between Model and View, handles business logic and user input.
	•	View: displays UI elements, and delegates user actions to the Presenter.

This architecture helps make the codebase more testable and maintainable.

Requirements
	•	iOS 13.0+ (or whichever minimum version your project targets)
	•	Xcode 12.0+ (or the version you used)
	•	Swift 5.x

Setup & Installation
	1.	Clone the repository
  git clone https://github.com/headlinerten/MovieQuiz.git
cd MovieQuiz

	2.	Open the project in Xcode
Open MovieQuiz.xcodeproj in Xcode.
	3.	Resolve dependencies
If you use any external dependencies (CocoaPods, Swift Package Manager, etc.), ensure they are installed / resolved.
	4.	Build
In Xcode, select a simulator or device and build the MovieQuiz target.

Running the App

After building, run the app on a simulator or physical iOS device. The quiz interface should appear, and you can begin playing.

Testing

The project includes test targets:
	•	MovieQuizTests — unit tests for the presenter and model logic
	•	MovieQuizPresenterTests — focused tests for the presenter layer
	•	MovieQuizUITests — UI-level integration tests

To run tests:
	1.	In Xcode, select the Test action (⌘U)
	2.	Choose which test suite to run (or run all)
	3.	View results in the Test navigator

Folder Structure (Overview)

MovieQuiz/
├── MovieQuiz.xcodeproj
├── MovieQuiz/                   # App target: code & resources
│   ├── Views/
│   ├── Presenters/
│   ├── Models/
│   ├── Resources/
│   └── ...
├── MovieQuizTests/              # Unit test target
├── MovieQuizPresenterTests/     # Presenter-specific tests
├── MovieQuizUITests/            # UI test target
└── README.md

You can adjust or expand this to reflect your actual directory layout.

Contributing

Contributions are welcome! If you want to contribute:
	1.	Fork the repository
	2.	Create a feature branch (e.g. feature-add-levels)
	3.	Make your changes & add tests as appropriate
	4.	Submit a pull request with a clear description of your changes

Please ensure coding style consistency, documentation, and passing tests.
