# iOS
The best mobile platform


## Setting up on your machine

1. Install Xcode
2. Clone the iOS repo
3. Install Cocoapods
    1. enter `sudo gem install cocoapods` in the terminal (doesn't matter what directory you're in)
    2. `cd` into the iOS repo on your machine (if you use `ls` you should be able to see the .xcodeproj file among others)
    3. enter `pod install`
  
Finally, in Xcode open the **The Mac Weekly.xcodeworkspace** file, **NOT The Mac Weekly.xcodeproj** file.

_**If you open the .xcodeproj file, you will not be able to build and run**_

## Building and Running

1. Look at your project directory in Xcode, and click on the part that looks like a blueprint labeled _The Mac Weekly_. You'll know you've got the right thing when you see information about Display Names, Bundle Identifiers and Teams.
2. Change the bundle identifier to be literally anything other than `org.tmw.The-Mac-Weekly`. Trust me, it's much easier this way.
3. Set up your team
    1. You'll need to make sure you have your own Apple ID at this point. If you don't already have one, you can sign up for free using any email you already have. _**You do not need an apple developer account to work on this project, so don't give them any of your money**_.
    2. Once you have your Apple ID ready to go, click on the blueprint again and click on the selection box next to _**Team**_, in the _**Signing**_ category. Select `Add account`.
    3. Add your account information, then go back to the blueprint page and follow any instructions it has for you about certificates and signing. You might need to log in to your developer account at https://developer.apple.com/account/.
4. Now you should be able to build and test the app on any simulator you like! And if you have a phone, you'll need to jump through a few more hoops and add your device to your account, but it should give you information about how to do that if you plug in your phone and try to run the app on it. Happy developing!

## Working on and Submitting new features

Whenever you're about to start working on a new feature, make sure you follow the procedures below:

### When getting ready to start work on a new feature
1. Make a new branch based on master
2. Checkout this new branch on your machine
3. Work on the feature, ONLY committing and pushing to the new branch
### When the feature is ready for review
1. Prepare your branch for a pull request
    1. Make sure all your changes have been committed and pushed
    2. Pull from the master branch, and fix any merge conflicts
    3. Run your code again, make sure that no new issues were introduced with the merge
    4. Once you’re sure that everything is running smoothly, commit and push to your new branch one last time
    
2. Submit the pull request
    1. Under the “Code” tab in the repository you’ve been working in (either iOS or Android), click where it says “Branch: master” and select your new branch.
    2. Next to that same button (which should now read “Branch: <yourbranch>”), click “New Pull Request”
    3. Right below where it says “Open a new pull request”, make sure that one button reads “base: master” and the other reads “compare: <yourbranch>”
    4. Make sure the title has the name of your new feature and describe what it does and how it works in the comment below the title.
    5. That’s it! Click the submit button and let one of your leads know you need a review.


If you have any questions about any of the procedures, feel free to ask one of the leads or anyone else who's been on the team for a bit!

