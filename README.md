# PickNMix
Idea Pick and Mix app - Done for a test/job interview process

# Installation notes

Uses Realm

You will require to install cocoapods and run

`pod install`

on the main project folder.


# Other Notes

* It uses a basic MVVM pattern 
* Uses an observer to update the UI once DB is complete
* The DB layer doesn't directly interact with UI; I use a struct to do this
* It uses codable protocol to parse the JSON

# Things I would have done better

* I don't think I would have used the codable protocol, it repeats code I use elsewhere
* I would have tried to seperate the API call, the DB entities and the view model a bit better; at the moment its a bit mixed up
* Added elements to handle when there is no Internet
* A cleaner state rather than having so many structs/classes handling the same information

# Screenshot

<img src="./screenshot.png" alt="Screenshot" width="350">