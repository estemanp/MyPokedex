## Description of the problem and solution

Create a simple iOS app that fetches and displays a list of Pokemon from the PokeAPI (https://pokeapi.co/).

**The app should have the following features:**

1.  Display a list of Pokemon retrieved from the PokeAPI. Each Pokemon should display the name, image, and type(s).
2.  Tapping a Pokemon in the list should display the Pokemon's detail view. The detail view should display the name, full image, type(s), abilities, and moves.
3.  Allow the user to search for Pokemon by name.
4.  Implement a basic caching mechanism to store previously retrieved Pokemon data and display it while offline.

**Technical Requirements:**

1. Use SwiftUI, Combine and the latest version of Xcode.
2. Use some Design patterns.
3. Use the PokeAPI to retrieve and display Pokemon data.
4. Use SOLID and good practices.
5. Use a third-party library for image loading (e.g. KingFisher or SDWebImage).
6. The app’s UI should be responsive on different devices and orientations.
7. Write unit tests for the networking layer of the app.

**Bonus Points:**

1. Allow the user to filter Pokemon by type or ability.
2. Implement pagination for the list of Pokemon.
3. Show your knowlegde building the first Screen with this example without the TabBar, you can use any typography that you want

## Trade-offs

Considering that this project was created in practical terms and with a specific deadline (5 days), I think it could be great to do a refactoring to the following topics:

1. Adding a property list to handle some application constants.
2. Customizing error message alerts.
3. Adding unit tests to viewModel layer.
4. Adding pop-ups for Internet connection status.
5. Adding splash screen
6. Adding a configuration enum where the different padding, spacing, application view sizes, or icon sizes to be used in the views are defined so that we have a standard and it is easier to maintain in the future.
7. Adding the Swinject framework to handle dependency injection.
8. Reviewing and improving the performance of LazyVgrid along with animation as it currently has its issues.

# Technical Approach

## Architecture MVVM

![alt text](https://miro.medium.com/v2/resize:fit:720/format:webp/1*_DMvajfGcKQoIOWpLysa1Q.png)

### A quick refresher on MVVM rules:
1. The view has a reference to the ViewModel, but not vice-versa.
2. The ViewModel has a reference to the Model, but not vice-versa.
3. The View has no reference to the Model or vice-versa.

### Model

The model represents the data and business logic of the application. It can be a structure or a class that encapsulates data and related methods.

### View


The view is responsible for visually representing the data provided by the ViewModel and handling user interaction. In SwiftUI, views are defined using declarative syntax and can automatically react to changes in data.

### ViewModel

The ViewModel communicates with the model and provides the necessary data to the view. It may also contain data presentation and transformation logic. In SwiftUI, ViewModels are observable objects that notify views when data changes.

In addition to the previous layers, a networking layer called **ApiManager** was added, capable of requesting data through [the RESTful Pokémon API](https://pokeapi.co/) and through the combined framework it manages the data cache.

## Good Practices
With the following practices, we've achieved create a product with highly quality.
- **Clean code**
- **SOLID Principles**
- **DRY Principle**
- **Dependency Injection** [It was manual]
- **Unit tests**

### Third Party Frameworks

- [Kingfisher](https://github.com/onevcat/Kingfisher): This frameworks allows us manage the image downloading in an easy way.

## Installation

- This project require  `Xcode 14.3.1`, `Swift 5` and should be run on `iOS 16.4`.
- Just open the project with the previously mentioned requirements and run the application.
