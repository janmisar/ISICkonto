# ISICkonto

Mobile application for ios which is using data from website https://agata.suz.cvut.cz/secure/index.php

### Steps to build the app:

Install XCode for iOS
Install CocoaPods

#### CocoaPods

If you're planning on including external dependencies (e.g. third-party libraries) in your project, [CocoaPods][cocoapods] offers easy and fast integration. Install it like so:

    sudo gem install cocoapods

To get started, move inside your iOS project folder and run

    pod init

This creates a Podfile, which will hold all your dependencies in one place. After adding your dependencies to the Podfile, you run

    pod install

to install the libraries and include them as part of a workspace which also holds your own project. For reasons stated [here][committing-pods-cocoapods] and [here][committing-pods], we recommend committing the installed dependencies to your own repo, instead of relying on having each developer run `pod install` after a fresh checkout.

Note that from now on, you'll need to open the `.xcworkspace` file instead of `.xcproject`, or your code will not compile. The command

    pod update

will update all pods to the newest versions permitted by the Podfile.

### Used principles:

Application needs to log in to website https://agata.suz.cvut.cz/secure/index.php. The procedure is following. If you are not logged in the website respond url that contains https://ds.eduid.cz... This website has two buttons, one for CVUT sso login and second for VSCHT sso login. Application works just for CVUT sso login for now, so it sends response for site linked by CVUT login button. 

It redirects you to the CVUT SSO login page. 
For login it sends post request with parameters: j_username, j_password, _eventId_proceed
```
j_username - for username
j_password - for password
_eventId_proceed - will be empty string
```

If login was successful application gets response to the site where is button continue because it doesn't support javascript. Then it gets components from this site and sends post request which leads to the final site. 



