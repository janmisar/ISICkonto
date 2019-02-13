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

Application needs to log in to website https://agata.suz.cvut.cz/secure/index.php. The procedure is following. If you are not logged in the website respond url that contains https://ds.eduid.cz... This website <a href="https://ds.eduid.cz/wayf-static.php?filter=eyJhbGxvd0ZlZWRzIjogWyJlZHVJRC5jeiJdLCAiYWxsb3dJZFBzIjogWyJodHRwczovL3dzc28udnNjaHQuY3ovaWRwL3NoaWJib2xldGgiLCJodHRwczovL2lkcDIuY2l2LmN2dXQuY3ovaWRwL3NoaWJib2xldGgiXSwgImFsbG93SG9zdGVsIjogZmFsc2UsICJhbGxvd0hvc3RlbFJlZyI6IGZhbHNlfQ==&lang=cz&entityID=https%3A%2F%2Fagata.suz.cvut.cz%2Fshibboleth&return=https%3A%2F%2Fagata.suz.cvut.cz%2FShibboleth.sso%2FLogin%3FSAMLDS%3D1%26target%3Dss%253Amem%253Acfe566ffecd9ffd36b69d62c9556a9c073239f011994c5c2b2e207b56998b55d"></a>

