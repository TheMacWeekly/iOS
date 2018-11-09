# iOS
The best mobile platform


## Setting up on your machine

1. Install Xcode
2. Clone the iOS repo
3. Install Cocoapods
    1. enter `sudo gem install cocoapods` in the terminal (doesn't matter what directory you're in)
    2. `cd` into the iOS repo on your machine (if you use `ls` you should be able to see the .xcodeproj file among others)
    3. enter `pod install`
    
**NOTE:** If you already have Cocoapods installed, you may need to enter `pod repo update` and then `pod install`. The first command might take literally forever to run but trust me, it gets there eventually. 
  
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

