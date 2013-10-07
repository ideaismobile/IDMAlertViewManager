IDMAlertViewManager [![IDMAlertViewManager Version](http://cocoapod-badges.herokuapp.com/v/IDMAlertViewManager/badge.png)](http://cocoadocs.org/docsets/IDMAlertViewManager) [![IDMAlertViewManager Platforms](http://cocoapod-badges.herokuapp.com/p/IDMAlertViewManager/badge.svg)](http://cocoadocs.org/docsets/IDMAlertViewManager) [![Build Status](https://magnum.travis-ci.com/ideaismobile/IDMAlertViewManager.png?token=HgpLPTLpJGCu6X7AwRB1&branch=master)](https://magnum.travis-ci.com/ideaismobile/IDMAlertViewManager)
===================

IDMAlertViewManager was developed to help you mitigate the problem of dealing with alerts of different priorities and it also focuses on having only one alert window being displayed at a time, centralizing default network error messages in one single class.

## Installation

Simply add `pod 'IDMAlertViewManager'` to your Podfile. Alternatively you can also copy the files in the folder `Classes` to your project.

We recommend importing it in the project's `.pch` to ease access, but you may also import on every class using **UIAlertViewManager**

## Usage

IDMAlertViewManager completely overrides the use of `UIAlertView`. In fact, you shouldn't call any `UIAlertView` anymore. Let us deal with it for you.

The first thing you may want to do is to set the default `title` and `message` for the connectivity error alert. Append it to the bottom of your `applicationDidFinishLaunching:` from your `AppDelegate`:

``` objective-c
[IDMAlertViewManager setDefaultConnectionErrorTitle:@"Network Connectivity Error" 
                                            message:@"Couldn't reach the server. Please, try again."];
	
// You may also want to provide other buttons to dismiss the window:
[IDMAlertViewManager setDefaultConnectionErrorTitle:@"Network Connectivity Error" 
                                            message:@"Couldn't reach the server. Please, try again."
                                            buttons:@[@"Cancel", @"Refresh"]];
```

To show the default alert window for connectivity error you must call `[IDMAlertViewManager showDefaultConnectionFailureAlert]`. Alternatively you can send blocks to be executed on success or failure:

``` objective-c
[IDMAlertViewManager showDefaultConnectionAlertWithSuccess:^(NSUInteger selectedIndex) {
	// Something to do when the user dismisses the alert view
} failure:^(NSError *error) {
	// Usually called when another alert with higher priority must appear.
	// May also mean that the alert was dismissed programmatically.
	// You can find the error cause comparing error.code against the enum IDMAlertError
}];
```

The alert for connectivity error is always called with the default priority (`IDMAlertPriorityMedium`). IDMAlertViewManager adds `OK` as the text for the default dismissal button but you can change it if you may using `[IDMAlertViewManager setDefaultDismissalButton:@"Cancel"]`.

### Other alerts

The most complete method available is:

``` objective-c									   
[IDMAlertViewManager showAlertWithTitle:@"Title"
                                message:@"Message"
                               priority:IDMAlertPriorityHigh
                                success:^(NSUInteger selectedIndex) {
                                	// Do something after dismissing the alert
                              } failure:^(NSError *error) {
                              		// Oops! Something went wrong!
                              } buttons:@[@"Yes", @"No"]];
```

### Priorities

There are four main priorities, but any unsigned integer may be provided to set a priority to an alert. The lower the value, the higher the priority.

If there's an alert on the screen and another with higher priority tries to appear, the current alert will be dismissed calling its `errorBlock` and the new alert will get its place on the screen. There will only be one alert being displayed at a time.

If an alert with equal or lower priority tries to pop on top of an existing alert, it won't show up and its `errorBlock` will be called if not **nil**.

These are the preset priorities from the `IDMAlertPriority` enum:

Priority | Value | Meaning
---------|-------|--------
**IDMAlertPriorityDEFCON** | 0 | The highest priority. Use only in case of emergency.
**IDMAlertPriorityHigh** | 10 | For important but not critical alerts.
**IDMAlertPriorityMedium** | 25 | The default priority. If none is set, this is assigned. Used on the connectivity error alerts.
**IDMAlertPriorityLow** | 50 | Low priority alerts.

You can check the [full documentation](http://ideaismobile.github.io/IDMAlertViewManager/docs) for more information.

## Compatibility

IDMAlertViewManager's test classes were writen using Apple's new framework **XCTest**, so it's only tested agains iOS 7 since previous versions (<= iOS 6.1) are not compatible with **XCTest**.

However, IDMAlertViewManager does not uses anything previous to iOS 5.1, therefore it may successfully work with any iOS version from 5.1 to above. But be aware that any further development will only be tested agains iOS 7!

## License

IDMAlertViewManager is licensed under the MIT License:

Copyright (c) 2013 Ideais Mobile (http://www.ideais.com.br/divisao-mobile/)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## [Complete Documentation >](http://ideaismobile.github.io/IDMAlertViewManager/docs)