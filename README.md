# Techinical test submition: CS:GO Fuze app
>Candidate: Leonardo Sousa
<br>Contact: sousalenardo@outlook.com

## Description
CS.GO Fuze app uses PandarScore Api to list CS:GO matches happening or scheduled within a year from the current date.

## Problem statment
> Challenge: https://fuzecc.notion.site/iOS-Challenge-EN-c27257e1ed0e47158d83508dd1e5f408
> <br> Desing spec:
https://www.figma.com/file/OeNVxV2YkHXMgzky8YNQQO/Desafio-CSTV?node-id=0%3A1

### Requiriments
- iOS => 17.6
- Xcode 16.2

### Instalation
```bash
git clone https://github.com/sousaleonardodev/FuzeChallenge.git
```

### Running app
1. Clone the repository
2. Open FuzeChallenge.xcodeproj file
3. Run the app on Xcode (cmd + R)

## Project organization
```plaintext
FuzeChallenge/
│___ Modules/
│    │___ Module/
│         │__ View
│         │__ Model
│         │__ ViewModel
│         │__ Service/
│             │__ Endpoint
│         
│___ Services/
│    │__ ApiService
│
│___ SupportingFiles
│    │__ Assets
│    │__ Colors
│    │__ Fonts/
│
│___ Components
│    │__ StateViews/
│    │   │__ LoadingView
│    │   │__ ErrorView
│    │
│    │__ Modifiers/
│
│___ Utilities/
│    │__ Extensions/

FuzeChallengeTests
|
FuzeChallengeTestsUI
|
```

## Implementation decision
1. Architecture choice:
    - Using MVVM architecture to allow a well organized, testable and scalable code.
    - Selected Combine to bind ViewModel and View
    - Dividing the app in modules representing each screen.

## Design patterns used
1. Service for Api requests.
    - Was created a specific class to encapsulate the request services. Allowing a easier mantainance since all requests pass by it.
2. Builder pattern was choosen for view creation, to make easier the creation of modules as it centralizes the modulo initialization and its dependences injection.
