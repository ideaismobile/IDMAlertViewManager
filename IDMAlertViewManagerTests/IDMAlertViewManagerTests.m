//
//  IDMAlertViewManagerTests.m
//  IDMAlertViewManagerTests
//
//  Created by Flavio Caetano on 9/17/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IDMAlertViewManager_Tests.h"

@interface IDMAlertViewManagerTests : XCTestCase

@property (nonatomic, readonly) IDMAlertViewManager *shared;

@end

@implementation IDMAlertViewManagerTests

- (void)setUp
{
	[super setUp];
	
	[IDMAlertViewManager _reinit];
	_shared = [IDMAlertViewManager sharedInstance];
}

- (void)tearDown
{
	[super tearDown];
	
	[IDMAlertViewManager dismiss:NO];
}

#pragma mark - Tests

- (void)testInit
{
	XCTAssertThrows([[IDMAlertViewManager alloc] init], @"[throw] init");
}

- (void)testSetDefaultConnectionErrorTitle
{
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	
	// Testing properties before setting
	XCTAssertNil(self.shared.alertView.title,					@"[nil] %@", self.shared.alertView.title);
	XCTAssertNil(self.shared.alertView.message,					@"[nil] %@", self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,	@"[1] %d", self.shared.alertView.numberOfButtons);
	
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	NSArray *alertButtons	= @[@"button1"];
	
	NSString *alertTitle2	= @"title2";
	NSString *alertMessage2	= @"message2";
	NSArray *alertButtons2	= @[@"button2", @"button 3"];
	
	[IDMAlertViewManager dismiss:NO];
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	[IDMAlertViewManager showDefaultConnectionFailureAlert];

	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,					@"[1] %d", self.shared.alertView.numberOfButtons);
	
	// Setting buttons keeping the alert's title and message
	[IDMAlertViewManager dismiss:NO];
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage otherButtons:alertButtons];
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],			@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],		@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count + 1,	@"[%d] %d", alertButtons.count + 1, self.shared.alertView.numberOfButtons);
	
	// Changing the alert's buttons, title and message
	[IDMAlertViewManager dismiss:NO];
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle2 message:alertMessage2 otherButtons:alertButtons2];
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle2],		@"[%@] %@", alertTitle2, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage2],	@"[%@] %@", alertMessage2, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons2.count + 1,	@"[%d] %d", alertButtons2.count + 1, self.shared.alertView.numberOfButtons);
	
	// Removing buttons
	[IDMAlertViewManager dismiss:NO];
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,					@"[1] %d", self.shared.alertView.numberOfButtons);
}

- (void)testShowDefaultConnectionFailureAlert
{
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	
	// Trying to show an alert with another already being displayed
	[IDMAlertViewManager showDefaultConnectionAlertWithSuccess:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Should not been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
	
	// Trying to show an alert without any being displayed
	[IDMAlertViewManager dismiss:NO];
	[IDMAlertViewManager showDefaultConnectionAlertWithSuccess:^(NSUInteger selectedIndex) {
		XCTAssertTrue(selectedIndex == kDEFAULT_DISMISS_INDEX, @"[%d] %d", kDEFAULT_DISMISS_INDEX, selectedIndex);
	} failure:^(NSError *error) {
		XCTAssertTrue(NO, @"Should not throw error");
	}];
	[IDMAlertViewManager simulateDismissalClick];
	
	// Trying to show the default alert with another with same priority already up
	[IDMAlertViewManager showAlertWithTitle:@"aTitle" message:@"aMessage"];
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
}

- (void)testShowAlertWithTitleMessage
{
	// Setting properties
	NSString *defaultAlertTitle		= @"title";
	NSString *defaultAlertMessage	= @"message";
	
	[IDMAlertViewManager setDefaultConnectionErrorTitle:defaultAlertTitle message:defaultAlertMessage];
	
	NSString *alertTitle	= @"aTitle";
	NSString *alertMessage	= @"aMessage";
	
	// Showing an alert
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage];
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
	
	// Tries to show an alert with the default already up
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage];
	XCTAssertFalse([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
}

- (void)testShowAlertWithTitleMessagePriority
{
	// Setting properties
	NSString *defaultAlertTitle		= @"title";
	NSString *defaultAlertMessage	= @"message";
	
	[IDMAlertViewManager setDefaultConnectionErrorTitle:defaultAlertTitle message:defaultAlertMessage];
	
	NSString *alertTitle	= @"aTitle";
	NSString *alertMessage	= @"aMessage";
	
	// Showing an alert
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityLow];
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
	
	// Tries to show a low priority alert with the default already up
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityLow];
	XCTAssertFalse([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
	
	// Tries to show a high priority alert with the default already up
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityHigh];
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Tries to show a DEFCON priority alert with a high priority already up
	NSString *defconTitle	= @"defconTitle";
	NSString *defconMessage	= @"defconMessage";
	
	[IDMAlertViewManager showAlertWithTitle:defconTitle message:defconMessage priority:IDMAlertPriorityDEFCON];
	XCTAssertTrue([self.shared.alertView.title isEqualToString:defconTitle],		@"[%@] %@", defconTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:defconMessage],	@"[%@] %@", defconMessage, self.shared.alertView.message);
}

- (void)testShowAlertWithTitleMessageSuccessFailure
{
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	
	__block BOOL dismissed = NO;
	
	// Showing an alert
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(dismissed, @"Run success block before dismissing");
	} failure:^(NSError *error) {
		XCTAssertFalse(YES, @"Shouldn't throw error");
	}];
	
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Failing to show an alert
	NSString *anotherTitle	= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	
	[IDMAlertViewManager showAlertWithTitle:anotherTitle message:anotherMessage success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
	
	dismissed = YES;
	[IDMAlertViewManager simulateDismissalClick];
}

- (void)testShowAlertWithTitleMessagePrioritySuccessFailure
{
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	
	__block BOOL dismissed = NO;
	
	// Showing an alert
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
	
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Failing to show an alert with lower or equal priority
	NSString *anotherTitle	= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	
	[IDMAlertViewManager showAlertWithTitle:anotherTitle message:anotherMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
	
	XCTAssertFalse([self.shared.alertView.title isEqualToString:anotherTitle],		@"[%@] %@", anotherTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:anotherMessage],	@"[%@] %@", anotherMessage, self.shared.alertView.message);
	
	// Showing an alert with higher priority
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityHigh success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(dismissed, @"Run success block before dismissing");
	} failure:^(NSError *error) {
		XCTAssertFalse(YES, @"Shouldn't throw error");
	}];
	
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	dismissed = YES;
	[IDMAlertViewManager simulateDismissalClick];
}

- (void)testShowAlertWithTitleMessagePrioritySuccessFailureOtherButtons
{
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	NSArray *alertButtons	= @[@"Cancel"];
	
	__block BOOL dismissed = NO;
	
	// Showing an alert
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	} otherButtons:alertButtons];
	
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count + 1,	@"[%d] %d", alertButtons.count + 1, self.shared.alertView.numberOfButtons);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],			@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],		@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Failing to show an alert with lower or equal priority
	NSString *anotherTitle		= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	NSArray *anotherButtons		= @[@"button1", @"button2"];
	
	[IDMAlertViewManager showAlertWithTitle:anotherTitle message:anotherMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	} otherButtons:anotherButtons];
	
	XCTAssertFalse([self.shared.alertView.title isEqualToString:anotherTitle],		@"[%@] %@", anotherTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:anotherMessage],	@"[%@] %@", anotherMessage, self.shared.alertView.message);
	XCTAssertFalse(self.shared.alertView.numberOfButtons == anotherButtons.count + 1, @"[%d] %d", anotherButtons.count + 1, self.shared.alertView.numberOfButtons);
	
	// Showing an alert with higher priority
	[IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityHigh success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(dismissed, @"Run success block before dismissing");
	} failure:^(NSError *error) {
		XCTAssertFalse(YES, @"Shouldn't throw error");
	} otherButtons:anotherButtons];
	
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == anotherButtons.count + 1, @"[%d] %d", anotherButtons.count + 1, self.shared.alertView.numberOfButtons);
	
	dismissed = YES;
	[IDMAlertViewManager simulateDismissalClick];
}

- (void)testDismiss
{
	// Setting properties
	[IDMAlertViewManager showAlertWithTitle:@"title" message:@"message" success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorFailedDismiss, @"[%d] %d", IDMAlertErrorFailedDismiss, error.code);
	}];
	XCTAssertTrue(self.shared.isAlertViewVisible, @"[1] %d", self.shared.isAlertViewVisible);
	
	[IDMAlertViewManager dismiss:NO];
	XCTAssertFalse(self.shared.isAlertViewVisible, @"[0] %d", self.shared.isAlertViewVisible);
}

@end
