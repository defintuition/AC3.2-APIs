# AC3.2-APIs: Part II Exercises
---

### Part I Discussion
In task 1, you were asked to build out the `SegementedCell` using the `SliderCell` as a template. You will have different answers, but what your `UITableViewCell` subclass must accomplish is: 

1. Define a `static let` constant for it's `cellIdentifier` property to be used in `cellForRow` in `SettingsTableViewController`
2. Contain both an outlet and action that links the `UISegmentedControl` object that is in your cell in storyboard
  - You may have named them differently; I went with `genderSegmentControl` and `selectedSegmentDidChange(_:)` where the `sender` is `UISegmentedControl`
3. A way to parse between the currently selected segment and the segment's index. 

__Here's how I did it:__

```swift 
  protocol SegmentedCellDelegate: class {
    func segmentedValueChanged(_ gender: UserGender)
}

class SegmentedTableViewCell: UITableViewCell {
    internal weak var delegate: SegmentedCellDelegate?
    static let cellIdentifier: String = "SegmentedSelectionCellIdentifier"
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    // 1. I decided I wanted two helpers to assist me in switching between segment index and the corresponding UserGender
    internal func genderFor(segment: Int) -> UserGender {
        switch segment {
        case 0: return .both
        case 1: return .male
        default: return .female
        }
    }
    
    internal func segmentFor(gender: UserGender) -> Int {
        switch gender {
        case .both: return 0
        case .male: return 1
        default: return 2
        }
    }
    
    // 2. Next, I wanted to have functions to update my selections: one using Int as a parameter and the other UserGender
    internal func updateSelectedSegment(index: Int) {
        genderSegmentedControl.selectedSegmentIndex = index
    }
    
    internal func updateSelectedSegment(gender: UserGender) {
        genderSegmentedControl.selectedSegmentIndex = segmentFor(gender: gender)
    }

    @IBAction func selectedSegmentDidChange(_ sender: UISegmentedControl) {
        self.delegate?.segmentedValueChanged(genderFor(segment: sender.selectedSegmentIndex))
    }
}
```

Next, for the implementation of `SegmentedCellDelegate` in `SettingsManager`

```swift
    // MARK: - Segmented Cell Delegate
    func segmentedValueChanged(_ gender: UserGender) {
        self.gender = gender
    }
```

And lastly, in `cellForRow` in `SettingsTableViewController`

```swift
   cell = tableView.dequeueReusableCell(withIdentifier: SegmentedTableViewCell.cellIdentifier, for: indexPath)
            
   if let segmentedCell: SegmentedTableViewCell = cell as? SegmentedTableViewCell {
      segmentedCell.updateSelectedSegment(gender: SettingsManager.manager.gender)
      segmentedCell.delegate = SettingsManager.manager
   }
```
---
### `SwitchCell` Design Discussion
The `SwitchCell` implementation is going to be a bit trickier, and if you've found a solution other than this one be sure to share. 

<details><summary>Q1: When thinking about what the SwitchCell will need to do, what do you come up with and what problems can you foresee?</summary>
Well the biggest one is that we'll need to maintain two separate collections in order to (1) keep the right Bool values for each of the UserNationality enums and (2) have the data sorted properly. 

The first requires a Dictionary and the second an Array. (Remember, Dictionaries aren't guaranteed to be in any particular order)

Another issue involves the delegate method. We're going to need to be able to update the Bool value in a dictionary, but in order to do so, we'll also need the rawValue of the enum of the cell we alter. In other words, the delegate function needs 2 parameters, a String representing the enum rawValue and a Bool representing the current switch state. 

Lastly, we're going to have to alter how we generate URLs from implicit param values, to explicit ones. So enum cases were we were just leaving a blank string (to indicate to return all values) will have to be replaced with explicit enum rawValue Strings. 
</details>

---
#### Implementation Roadmap

To save you a bit of typing, here's some code for you:

```swift
enum UserNationality: String {
    case AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US
    case all = ""
    
    static func allNatEnums() -> [UserNationality] {
        return [AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US]
    }
}

enum UserField: String {
    case gender, name, location, email, login, id, picture, nat
    case none = ""
    
    static func allFieldEnums() -> [UserField] {
        return [gender, name, location, email, login, id, picture, nat]
    }
}
```

Now, add this next snippet to `SettingsManager`

```swift 

    // SwitchCellDicts
    var userNationalitySwitchStatus: [UserNationality : Bool] = [
        UserNationality.AU : true, UserNationality.BR: true,
        UserNationality.CA : true, UserNationality.CH : true,
        UserNationality.DE : true, UserNationality.DK : true,
        UserNationality.ES : true, UserNationality.FI : true,
        UserNationality.FR : true, UserNationality.GB : true,
        UserNationality.IE : true, UserNationality.IR : true,
        UserNationality.NL : true, UserNationality.NZ : true,
        UserNationality.TR : true, UserNationality.US : true
    ]
    var userFieldsSwitchStatus: [UserField : Bool] = [
        UserField.gender : true, UserField.name : true,
        UserField.location : true, UserField.email : true,
        UserField.login : true, UserField.id : true,
        UserField.picture : true, UserField.nat : true
    ]
```

<details><summary>Q1: Can you explain the need for these new functions and vars?</summary>
In short: we need to maintain the current status for each UserNationality. This status corresponds to a UISwitch state, which indicates whether or not we're interested in passing along a particular UserNationality as a param value in our URLRequest. 

The enum functions are useful for determining the number of cells in each section we'll need to have
</details>

#### Instructions: 

__Prerequisites:__

1. Make sure you've implemented your `SwitchTableViewCell` and `SwitchCellDelegate`
  - Hint: You'll only need 1 function in your delegate protocol, `selectionDidChange(option: String, value: Bool)`
2. Ensure that `SettingsManager` conforms to `SwitchCellDelegate` (you don't have to fill out the code inside of the function just yet)
3. Add a helper function to `SwitchTableViewCell`: `internal func updateElements(key: String, value: Bool)`
  - Hint: You'll use this function to update your cell's `label` and `switch` state when you instantiate a `SwitchTableViewCell` in `SettingsTableViewController`'s `cellForRow`

__Main:__

1. Create two more variables for `SettingsManager`: `sortedNationalityKeys: [String]` and `sortedFieldKeys: [String]`
  - This `[String]` should be the keys for the `userNationalitySwitchStatus`/`userFieldSwitchStatus` sorted alphabetically, in ascending order. 
  - Implement these two as computed values
  - Hint: Make use of `map` and `sorted(by:)`
2. Create a new function, `validNationalities(_ dict: [UserNationality : Bool]) -> [UserNationality]`
  - This function's purpose is to return all keys from `userNationalitySwitchStatus` who's value is `true`
  - Hint: You can do this many different ways, but `filter` can help. 
3. Similarly, create another new function, `validFields(_ dict: [UserField : Bool]) -> [UserField]`
4. (Verify this is being done) Update your code inside of `RandomUserURLFactory` for `func endpoint(users: Int, nationality: [UserNationality], gender: UserGender) -> URL` to make sure that your `[UserNationality]` is being iterrated over and getting the appropriate `rawValue`. 
  - Hint: This can be done with `flatMap`
  
__Verify your work__

Make sure that the following occur: 

1. You see a full list of the UserNationality's listed in your `SettingsTableViewController`
2. You can toggle the `switch` in each of the cells
3. `switch` state (true or false / on or off) persists after doing a push/pop of the navigation stack.
4. A `true/on` state for the `switch` results in the the `nat=` key having that `UserNationality` as one of the param values listed. (ie. if only the `switch` for `UserNationality.US` is `on`, then the param should look like `nat=US` when making the `URLRequest`)
  - The reverse must also be true!! (an `off/false` state of a `switch` should result in that UserNationality being removed from the param values.

---
### Exercises

1. Add approproate titles for each section of the `SettingsTableViewController`
2. Fully implement the cells/section for determining the `UserFields` to return
  - This requires updating the `URL` factory class as well to use the `inc` key (see the RandomUser doc for info on this)
3. Test out this "Settings" menu (which is really a debug menu now) by altering the parameters of your requests.
  - For example, test out how gracefully your `JSON` parsing handles errors for missing different `UserField`s
4. If you haven't already, ensure that the image is being downloaded as well
5. Change the `detailLabel` text to show a user's nationality and gender (so that it is easier to match your results to your debug settings)
5. (Advanced) Replace __ANY__ loops (where possible) with either `map`, `flatMap`, `filter`, or `reduce`
6. (Advanced) `validFields(_ dict: [UserField : Bool]) -> [UserField]` and `validNationalities(_ dict: [UserNationality : Bool]) -> [UserNationality]` are quite similar, aren't they? Find a way (using generics) to rewrite the two functions as a single one.
  - Hint: make this new generic function `private` and have two `internal func` to do the work: `validNationalities() -> [UserNationality]` and `validFields() -> [UserField]`

