# AC3.2-APIs: Part II 
### Detailing, Managing and Storing Requests
---
### Readings

1. [HTTP Methods - tutorialspoint](https://www.tutorialspoint.com/http/http_methods.htm)
2. [What is the difference between POST and GET? - Stackoverflow](http://stackoverflow.com/questions/3477333/what-is-the-difference-between-post-and-get)
3. [Understanding HTTP Basics - OneMonth](http://learn.onemonth.com/understanding-http-basics)
4. [The Rubber Duck Story - Youtube](https://www.youtube.com/watch?v=huOPVqztPdc)
5. [Using Storyboards and Swift to Build Dynamic Tableviews](http://www.techotopia.com/index.php/Using_Storyboards_and_Swift_to_Build_Dynamic_TableViews_with_Prototype_Table_View_Cells)
6. [NSUserDefaults - Coding Explorer](http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/)
  - Note: Read this if you have time, but we may not get to it

#### References

1. [HTTP Header Fields - tutorialspoint](https://www.tutorialspoint.com/http/http_header_fields.htm)
  - Note: this is to have for reference, there's much more info here than you need right now
2. [HTTP Status Codes - REST API Tutorial](http://www.restapitutorial.com/httpstatuscodes.html)
3. [HTTP Methods for RESTful Services - REST API Tutorial](http://www.restapitutorial.com/lessons/httpmethods.html)
4. [What is REST? - REST API Tutorial](http://www.restapitutorial.com/lessons/whatisrest.html)
5. [Rubber Duck Debugging - Wiki](https://en.wikipedia.org/wiki/Rubber_duck_debugging)

---
### Just a tiny bit of error handling, plzzz

> *(said with exasperation)* "JSON is... JSON" - Louis

Working with json can be tricky with all of the casting you'll need to do to make it work. But there's no escaping it! So what we should be doing as developers is making things slightly less tedious for us; a task that can be accomplished by having good error handling. What's particularly nice about error handling in swift, is that it's incredibly flexible and easy to work into your existing code.

For any function that throws, or in a situation where you'd like to include code inside of a `do/catch`, you can easily define your own `Error` type, by just creating an `enum` that conforms to `Error`! `Error` has no required properties or functions; it really just signals that your data type is meant to be used in situations where an error should occur. 

```swift
internal enum UserModelParseError: Error {
    case results, name, location, login, id, picture, email
}
```

#### Try this out
Instead of `return nil` in our `guard else` block, we can instead `throw` a `UserModelParseError`! Go ahead and go through your code and make the adjustments necessary. Now, change the name of an expected `key` for your parsing and observer the error that shows up in the `catch` block. 

#### We can do better
By giving our `UserModelParseError` cases a parameter, we can pass in values to the error as well. Let's just change one of them for now...

```swift
internal enum UserModelParseError: Error {
    // .. code ..
    case name(json: AnyObject)
    // .. other code ..
}
```

Now when we `throw`, we can make this change: 

```swift
  throw UserModelParseError.name(json: userResult)
```

But what good is this unless we can access this parameter later? Catch clauses can make use of variable binding to access the parameters that an `Error` gets passed!! (I'm really excited by this, hence __2__ exclamation points)

```swift 
  catch let UserModelParseError.name(json: json) {
    print("An error occured parsing the 'name' key: \(json)")
  }
```

Depending on your needs, you can update these `Error` cases to include all sorts of data to later use when figuring out how you should handle a particular error. (For example, say your code was still having issues casting for the "id" field. Inside of the `catch` block for that particular error you might decide you want to return an instance of `User` with empty strings in all fields, instead of returning `nil`... not that that would be very practical, but it shows that you can have some flexibility in fixing mistakes)

#### >>5 Min Challenge
Replace all of the `enum` cases to accept a parameter of `AnyObject`. Update your `catch` blocks appropriately. 
__Bonus:__ Can you think of a way to have just a single case that handles every type of parsing error and provides a description of where the error happened?

---
### Parameterization of Requests

We've already taken a look at how to refine the data that gets returned from an API: the RandomUserAPI allows for parameters to be passed in with the `URL` to determine the information that is sent in a response. For example, we can limit the number of returned results by tacking on the key `results` with an integer as the value. Looking at the RandomUserAPI documentation, we can see there are a number of these parameter keys we can use to craft the response data as we need to:

|`Key`|Purpose|Example|
|---|---|---|
|`results`| Determines the number of users that are returned | https://randomuser.me/api/?results=10 |
|`gender`| Determines if male/females should be returned | https://randomuser.me/api/?gender=female |
|`nat`| Determines which nationalities should be returned | https://randomuser.me/api/?nat=US,BR,GB |

---
### A "Settings" Menu

By allowing ourselves to modify our request to the RandomUserAPI by use of parameters, we can flexibily change our data set displayed in the tableview. But currently, we have to change our code and re-run our app every time we want to make a change to the data being displayed. This is a less-than-ideal situation, so let's remedy it by creating a settings menu that will allow us to adjust the data that gets displayed in our table. 

For this particular settings menu, we want to be able to change the following:

1. The number of results per request (from 1 - 200)
2. The gender of the returned Users (Male, Female or Both)
3. The pool of nationality that the Users can be from (there are many of these)

<details><summary>Q1: What `UIControl` could best fit each menu option?</summary>
There are different possible answers, but for our purposes a <code>UISlider, UISegmentedControl, and multiple UISwitch</code> (respectively) would satisfy what we need to accomplish. 
</details>

<details><summary>Q2: If we have a prototype cell with a control element in it, how do we detect which cell the element was changed in?</summary>
You'll need a few things (such as a way to index to keep track of the contents of each cell), but more importantly to detect events for a prototype cell that is going to appear multiple times, we'll need to subclass <code>UITableViewCell</code> and have it handle the event. 
</details>

#### Storyboard Updates, Part 1

Part of being a developer is being able to "read" an image and convert it to code (or storyboard, in this case). Take a look at the following image and think about how to recreate it in your own storyboard without looking at the provided hints (down below). 

![Updated Storyboard](./Images/updatedStoryboard.png)

<details><summary>Q1: What can we say for certain about the changes needed?</summary>
<ol>
  <li> A new table view controller is needed
  <li> There is one custom prototype cell in it
  <li> The view controller's title is "Filter Settings"
  <li> There is a new push segue from the UserTableViewController (how do we know this?)
  <li> There is a new bar button item on the navigation bar
 </ol>
</details>
<details><summary>Q2: Similarly, what is ambiguous about the changes?</summary>
<ol>
  <li> The purpose of the new button
  <li> The source of the image of the new button
  <li> The source for the segue (is it tapping the cell? is it the new button?)
  <li> The class of the tableviewcontroller (is it UITableViewController, or some subclass?)
</ol>
</details>

__Implementation Details (a.k.a "spoilers")__

1. Create a new `UITableViewController` subclass called `SettingsTableViewController`, assign it to the class of  `UITableViewController` you added to the storyboard
2. The image for the `UIBarButtonItem` is in your `Assets.xcassets` folder
3. The segue source is the new `UIBarButtonItem` (no other configuration is needed)

#### Storyboard Updates: Part 2

The above example was, for the most part, straightforward. This one will be a bit trickier:

![Updated Prototype Cells](./Images/updatedFilterCells.png)

Q1: What can we say for certain about the changes needed?

Q2: Similarly, what is ambiguous about the changes?

__Implementation Details (a.k.a "spoilers")__

1. Change the `UITableView` to have 3 prototype cells with identifiers and a height of `60pt`:
  1. `SliderCell`
  2. `SegmentedControlCell`
  3. `SwitchCell`
2. `SliderCell` Details
  - The cell is comprised of 3 elements: 2 `UILabel`s and a `UISlider`
  - All elements are vertically aligned in their container
  - `# of Results` label
     1. `8pt` to left/right, relative to margins
     2. `height` of `21pt`
  - `9999` label
     1. `8pt` left/right
     2. `width` of `65pt`, `height` of `21pt`
  - Slider
     1. `height` of `30pt`
     2. `8pt` to left/right, relative to margins
3. `SegmentedControlCell` Details
  - 1 `UILabel` and `UISegmentedControl` with three options: `Both, Male, Female`
  - All vertically aligned in container, and `8pt` left/right constraints relative to margins
  - There is a space of `16pt` between the `Gender` label and the segmented control
  - The segemented control has a `height` of `24pt`
4. `SwitchCellDetails`
  - 1 `UILabel` and 1 `UISwitch`
  - Again, both elements are vertically aligned
  - `Option` label is `8pt` to left relative to margins
  - Switch is `8pt` to the right, relative to margins. Additionally, it is `height`: `31pt`, `width`: `49pt`
  
#### Code Updates
1. Create a new `UITableViewCell` subclass called `SliderTableViewCell`
2. Create outlets for the `slider` and the `numberOfResultsLabel`
3. Add the function `internal func updateSlider(min: Int, max: Int, current: Int)`
  - In this function, adjust the `.minimum, .maximum and .value` for the `slider` using the provided parameters
  - Additionally, update the label text
4. Add an action outlet for the slider named `didChangeValue`
5. Run the project at this point to verify that the changes you made worked

<details><summary>Q1: What should we do in the didChangeValue code?</summary>
Update the text label 
</details>
<details><summary>Q2: How should this class interact with our SettingsManager?</summary>
There can be many discussion points here, but the critical on is that we need to be able to update the locally stored values in our SettingsManager in some manner. 
</details>

---
### The `SettingsManager` singleton
This time around, we're going to utilize the singleton in a much more useful manner by having it manage our settings across the entirety of our app! Add the following to the `SettingsManager` class:

```swift
    var results: Int
    var gender: UserGender
    var nationality: UserNationality
    var excluded: UserField
    
    let minResults: Int = 1
    let maxResults: Int = 200
```

Additionally, create three `enum` in the `SettingsManager.swift` file, but outside of the {}'s for `SettingsManager`:

```swift 
enum UserGender: String {
    case male, female, both
}

enum UserNationality: String {
    case AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US, all
}

enum UserField: String {
    case gender, name, location, email, login, id, picture, nat, none
}
```

And now, set up your `manager` singleton instance and `private init`

#### Updating a Setting
Create the function `func updateNumberOfResults(_ results: Int)` and fill it in. 

---
### Updating the `SettingsManager` with new values

<details><summary>Q1: How will we monitor a change in the slider in order to update the SettingsManager's values?</summary>
One option is to have the <code>UITableViewCell</code> call on <code>SettingsManager</code> inside of the function we set up. And that totally works! 

But think about this: if we wanted to reuse this class in another project, could we? 
</details>

#### Direct Singleton Access Approach
Go ahead and adjust the singleton directly in `didChangeValue` inside of `SliderTableViewCell`.

#### Alternative Approach
Ok, let's take a look at another way of doing this. (pssst. delegation)

#### Updating `APIRequestManager` to use `SettingsManager`
Lastly, let's update the original method for user requests to use the value from `SettingsManager`

`private static let randomAPIEndpoint: URL = URL(string: "https://randomuser.me/api/?results=\(SettingsManager.manager.results)")`

<details><summary>Q1: Why wont this work?</summary>
Well, when the singleton gets made, the SettingsManager value for results is set. So, it's not going to update later on on its own. 
  
So now, we'll need to build out something to help manage the URLs for the requests that need to be made! 
</details>

---
### Exercises

#### Part I
Task 1: With one type of settings cell ready, let's move on to the next one: `SegmentedCell`. Make sure that your `UITableViewCell` subclass can communicate with `SettingsManager` to update the value for the parameter. Similarly, work on `SwitchCell`

Task 2: Using what you already know about `URLSession`'s `downloadTask`, make a request for the `User` image thumbnail and display it the cell. 

__Part I: Advanced__
Have a placehold image available for the cell until the download completes, then swap that out with the correct image

#### Part II
Task 1: We're going to need some way to construct our URL's based on the settings of the `SettingsManager`. Create a new factory class, `RandomUserEndpointFactory` that reads the current settings of `SettingsManager` in order to create a properly formatted request URL. 
