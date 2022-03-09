# Peggle Clone
An iOS Peggle clone developed using SwiftUi. Everything was developed from scratch, including the physics engine and game engine.


## Dev Guide

### Introduction
This project aims to create a fully-functional Peggle clone for the iPad. Currently there are two main features, and correspondingly two main Views in the application:
- Designing a level by placing and dragging pegs, together with the ability to save and load levels (LevelDesignerView)
	- Consists of smaller Views such as `GameBoardView`, `BottomBarView` etc which uses are self-explanatory
- Playing the designed level by shooting a ball from the cannon and clearing all pegs (`StartGameView`)

### Dependencies
- SwiftUi to render the Views
- Codable for persistence
- CoreGraphics for coordinate system

#### LevelDesignerView

<img src="https://user-images.githubusercontent.com/45702380/153740020-bc391bf1-52fa-439f-ad26-a741fb2dade4.png" width="400">

- Press START to start the level that is designed
- Type the level name into the text box and press SAVE to save a level
- Press LOAD to select a level from the available saved ones
- Press RESET to clear all pegs on the board

#### StartGameView
<img src="https://user-images.githubusercontent.com/45702380/153740089-f3774ebe-e799-4bc1-ac10-177573d645ac.png" width="400">



- Pressing anywhere on the board fires a ball from the cannon in that direction
- When a peg collides with a ball, it lights up and is removed when:
	- The ball is stationary
	- The ball leaves the board
- The score, number of blue pegs and orange pegs hit is currently a work in progress
- There are walls at the side and top of the game board preventing the ball from exiting the game board other than from the bottom

### High-Level Architecture

I used the MVVM (Model, View, View-Model) paradigm when designing my application, where the View is tightly coupled with the View Model. 


- Each View stores an instance of its corresponding ViewModel which takes care of the logic, placement and positions of objects and communicates with the Model
- For this problem set, I did the `Game Renderer`, which takes care of updating the `Game Engine`, which will be described in more detail below.
- The  `StartGameViewModel` stores and creates a  `Game Renderer`  object upon initialization, and passes in the array of `GameObject`s which is to be updated and rendered by the `Game Renderer`.
- Meanwhile the `LevelDesignerViewModel` does not directly store the `Persistence` models but simply uses it as a medium to convert to and from the data stored as a `json`. 
	- `PersistenceUtils` is under `Persistence` and it contains the methods which allow easy encoding/decoding of the board
	- Lastly, `GameObject`s (Pegs, Balls, and Walls) are stored in both the `StartGameViewModel` and the `LevelDesignerViewModel` to be rendered in their respective views.

![image](https://user-images.githubusercontent.com/45702380/153741191-ad26cbca-334d-49b7-9379-cbc7e4842a87.png)
### Entity Component System
For the easy addition of new components into the game, the game uses a slightly modified version of an [Entity Component System](http://vasir.net/blog/game-development/how-to-build-entity-component-system-in-javascript) (ECS). 
#### Game Object
Each `GameObject` represents an Entity, in that it is a "container of components". Instead of making a singleton Entity Manager which stores a mapping of `Entity`s to their respective dictionary of `Component`s, I went for a more testable solution of making each `GameObject` store a dictionary of it's components instead - the  `EntityComponentSystem`.
If we want to check if a Game Object is a Wall for example, we can just do `gameObj.getComponent(of: WallComponent.self)`, instead of going through the Entity Manager like `entityManager.get(gameObj).getComponent(of: WallComponent.self)`.
Using an ECS makes it easily extensible if I want to make a `GameObject` a `Peg`, a `SpookyPeg`, and change image on hit using `ActivateOnHit`,  I can do `gameObj.setComponent(of: Peg())`, `gameObj.setComponent(of: SpookyPegComponent())` and `gameObj.setComponent(of: ActivateOnHit(imageNameHit: imageNameHit))`

#### Component
Each component stores the respective data required for the component, and makes it easy for me to compartmentalise my data.
You might see that there is a lot of empty Components without any data, as some of them are just used purely for identification (eg seeing if I'm colliding with a Wall for example).
Also the `reset` function is used to reset the data of the components upon exit as some components are not deleted and recreated when navigating through views. 

#### System
In a normal ECS, systems hold the logic for components. However, I find that in this case, as components rarely even had data, much less logic and behaviour, I combined the System and Component aspect of the ECS into one. 

Instead, I called the struct that maps component names to their data the `EntityComponentSystem`.

### Model

Data involving all the state of the objects are found here.  

![image](https://user-images.githubusercontent.com/45702380/151546218-d8bd0a0f-c83c-4f92-bced-420e54ca6410.png)

As shown above, `OrangePeg`s and `BluePeg`s inherit from `Peg`, which in turn inherits from `GameObject`.


- `GameObject` exists to make it extensible when other objects are added, such as rectangles, squares, or triangles.
- `GameObjects` are then stored in an array `objArr` in the ViewModel, and are rendered by the View.
- `PhysicsBody` takes care of the collisions/overlaps between other `PhysicsBody`s using the `isIntersecting` method.
- The radius of a `Peg` and it's `coordinates` are handled by it's `PhysicsBody`. 
- The `PhysicsBody` exists to ensure a clear separation between the Physics Engine and the rest of the logic.

### GameRenderer

Basically, the flow of how the game renders and updates the view is as follows:

![image](https://user-images.githubusercontent.com/45702380/153743140-d693ac2e-d41b-419f-9cba-df65629211db.png)

Note that the `StartGameViewModel` is created when the START button is pressed, but due to the limitations of PlantUML I am unable to show it as such.

1. From the LevelDesignerView, the user presses the START button
2. As the `StartGameViewModel` is wrapped in a `LazyView`, it is initialized only when the button is pressed
3. When START is pressed, the `objArr` storing the list of objects is passed into the `init` of the `StartGameViewModel`
4. `StartGameViewModel`creates and stores a reference to the `GameRenderer`. The `objArr` is passed to the `GameRenderer` to be updated on a loop
5. The `StartGameViewModel` subscribes to the `objArr` in the `GameRenderer` to observe for any changes and renders it accordingly in the View
6. The `GameRenderer` creates the `GameEngine`  and passes the `objArr` to it, and it takes care of the game-specific behaviour such as removing objects outside the boundaries and removing lighted up Pegs
7. The `GameEngine` creates a `PhysicsEngine` and stores a reference to it

On each tick of the `CADisplayLink` in the `GameRenderer` used to synchronize the game with the refresh rate:


1.  The `update()` function in the `GameRenderer` is called by the `CADisplayLink`, which in turn calls the GameEngine's update() function: `gameEngine.update()`
2. The `GameEngine` removes all objects outside the boundaries of the game and removes the lighted up Pegs based on certain conditions (ball not moving or ball is outside boundaries)
3. The  `GameEngine` calls `simulatePhysics()`, which calls methods in the `PhysicsEngine` to update next game state which is as follows:
 - All `dynamic` `PhysicsBody`s are updated according to their respective positions, velocity, and acceleration.  The resultant force is calculated based on it's `forces` array and added to the acceleration.
 -  Note: currently, the only thing that applies `force` is gravity, as collisions modify the velocity directly because I found it to be more realistic. This allows us to further extend it in case of other forces which are not collisions, like wind.
 - Velocities are updated by checking if all other objects are intersecting with the `dynamic` `PhysicsBody`. 
 - Lastly, the coordinates are updated to prevent overlapping by "pushing back" the two objects when they collide such that they no longer overlap with each other
4. The updated `objArr` is then returned by the `GameEngine` and is published to the subscribing `StartGameViewModel`.


### PhysicsSimulator

![image](https://user-images.githubusercontent.com/45702380/153743362-044a618d-7261-41d4-9ee9-44ef915b4663.png)
- All elements which want to have physics simulations need to have a `PhysicsBody`, describing its coordinates and size (in the form of radius for a circle, height and width for a rectangle etc)
- The `PhysicsEngine` calculates the next coordinates of a `PhysicsBody` given a `PhysicsBody` and an array of other `PhysicsBody`s. The methods here are called by the `GameEngine` on every loop.

### View and View Model

#### View
The view, `LevelDesignerView`, consists of all the front-facing logic such as what will be displayed when: 
- a button is clicked
- pegs are placed
- pegs are dragged
- etc

Whenever for example a button is pressed, it will notify the View Model if there are any updates required.

It also observes the View Model for changes in state for the array of pegs (`objArr`), the currently selected object (`selectionObject`), etc.

The `StartGameView` just displays the cannon and all objects in the objArr given in the `StartGameViewModel`. 

#### View Model

The view-model, `LevelDesignerViewModel`, consists of higher level logic and functions called by the view when the above occur. We have functions that take care of:

- peg deletion
- peg placement
- dragging a peg
- the selection made by the user (whether to add a peg or delete)
- etc

The `PlaceholderObj` represents the object which allows the user to tell the position of the object before placement and deletion is done.

The `KeyboardResponder` is used to check when the keyboard is open to move the pegs up accordingly.

### Persistence
![image](https://user-images.githubusercontent.com/45702380/151552082-bf5b6927-300b-4243-9e45-316bbbba5872.png)


As we require many different levels in the game, we have a `BoardList`, which stores a dictionary of `Board`s, with the name of the `Board` as the key, for fast retrieval of a specific `Board`.

- A `board` has an array of `EncodableObject`s, which is the `Encodable` version of a `GameObject`. 
	- I created another class instead of making `GameObject` Codable because I wanted to cleanly separate the logic of the Model and Persistence, and I also didn't like how declaring certain properties as `CodableKeys` was done.
- An `EncodableObject` has x,y fields for the coordinates which can be read easily from a JSON file. This is as opposed to storing `CGPoint` which can be difficult to read and store.
- `PersistenceUtils` are for utility functions for persistence, like encoding and decoding the board.

## Rules of the Game
To win the game, you have to clear all the red pegs. You can select a powerup from the start menu, but the rules of the game is the same. Try to get the highest score!
Score:
- Each peg give 100 points
- Each Orange peg gives 50 more points

You start with 10 balls. Every time you shoot a ball, the number of balls get subtracted. 
You win the game by clearing all orange pegs.
You lose if you run out of balls and there are still orange pegs remaining in the game.

Powerups:
- Eyeball pegs are spooky pegs  
- Red pegs are kaboom pegs
- They are activated when hit and can be placed in the level designer.

#### Attributions
Eyeball from: https://www.how-to-draw-funny-cartoons.com/cartoon-eyeball.html  
Mars planet from: https://www.pinterest.com/pin/222928250288021864/
