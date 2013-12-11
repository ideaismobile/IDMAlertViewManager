//
//  IDMAlertViewManagerTests.m
//  IDMAlertViewManagerTests
//
//  Created by Flavio Caetano on 9/17/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IDMAlertViewManager_Tests.h"

@interface IDMAlertViewManagerTests : XCTestCase <UIAlertViewDelegate>

@property (nonatomic, readonly) IDMAlertViewManager *shared;

@property (nonatomic) BOOL globalResult;

@end

@implementation IDMAlertViewManagerTests

- (void)setUp
{
	[super setUp];
	
	[IDMAlertViewManager _reinit];
	_shared = [IDMAlertViewManager sharedInstance];
    
    self.globalResult = YES;
}

- (void)tearDown
{
	[super tearDown];
	
	[IDMAlertViewManager dismiss:NO];
    
    XCTAssertTrue(self.globalResult, @"[%d] 1", self.globalResult);
}

#pragma mark - Tests

- (void)testInit
{
	XCTAssertThrows([[IDMAlertViewManager alloc] init], @"[throw] init");
}

- (void)testSetDefaultConnectionErrorTitle
{
	BOOL result = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
	// Testing properties before setting
    XCTAssertFalse(result, @"[%d] 0", result);
	XCTAssertNil(self.shared.alertView.title,					@"[nil] %@", self.shared.alertView.title);
	XCTAssertNil(self.shared.alertView.message,					@"[nil] %@", self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 0,	@"[0] %d", self.shared.alertView.numberOfButtons);
    
    // Setting nil outputs
    BOOL resultSet = [IDMAlertViewManager setDefaultConnectionErrorTitle:nil message:nil];
    XCTAssertFalse(resultSet, @"[%d] 0", resultSet);
	
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	NSArray *alertButtons	= @[@"button1"];
	
	NSString *alertTitle2	= @"title2";
	NSString *alertMessage2	= @"message2";
	NSArray *alertButtons2	= @[@"button2", @"button 3"];
	
	[IDMAlertViewManager dismiss:NO];
	resultSet  = [IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	result     = [IDMAlertViewManager showDefaultConnectionFailureAlert];
    
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 0", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,					@"[1] %d", self.shared.alertView.numberOfButtons);
    
    // Setting nil button
    [IDMAlertViewManager dismiss:NO];
    resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage buttons:nil];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertFalse(resultSet, @"[%d] 0", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
    
    // Setting nil messages
    [IDMAlertViewManager dismiss:NO];
    resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:nil message:nil buttons:alertButtons];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertFalse(resultSet, @"[%d] 0", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
    
    // Setting alternate nil title
    [IDMAlertViewManager dismiss:NO];
    resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:nil message:alertMessage buttons:alertButtons];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
    XCTAssertNil(self.shared.alertView.title,                                   @"[nil] %@", self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
    
    // Setting alternate nil message
    [IDMAlertViewManager dismiss:NO];
    resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:nil buttons:alertButtons];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
    XCTAssertNil(self.shared.alertView.message,                                 @"[nil] %@", self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
	
	// Setting buttons keeping the alert's title and message
	[IDMAlertViewManager dismiss:NO];
	resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage buttons:alertButtons];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
	
	// Changing the alert's buttons, title and message
	[IDMAlertViewManager dismiss:NO];
	resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle2 message:alertMessage2 buttons:alertButtons2];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle2],		@"[%@] %@", alertTitle2, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage2],	@"[%@] %@", alertMessage2, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons2.count,		@"[%d] %d", alertButtons2.count, self.shared.alertView.numberOfButtons);
	
	// Removing buttons
	[IDMAlertViewManager dismiss:NO];
	resultSet   = [IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,					@"[1] %d", self.shared.alertView.numberOfButtons);
}

- (void)testSetDefaultDismissalButton
{
    // Setting nil button
    BOOL resultSet = [IDMAlertViewManager setDefaultDismissalButton:nil];
    XCTAssertFalse(resultSet, @"[%d] 0", resultSet);
    
	// Setting properties
	NSString *alertTitle		= @"title";
	NSString *alertMessage		= @"message";
	NSString *newDismisButton	= @"AnotherButton";
	
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	BOOL result = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,					@"[1] %d", self.shared.alertView.numberOfButtons);
	
	// Changing the default text for the dismiss button
	[IDMAlertViewManager dismiss:NO];
	resultSet   = [IDMAlertViewManager setDefaultDismissalButton:newDismisButton];
	result      = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertTrue(resultSet, @"[%d] 1", resultSet);
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],					@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],				@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == 1,								@"[1] %d", self.shared.alertView.numberOfButtons);
	XCTAssertTrue([self.shared.defaultDismissalButtonText isEqualToString:newDismisButton],	@"[%@] %@", newDismisButton, self.shared.defaultDismissalButtonText);
}

- (void)testShowDefaultConnectionFailureAlert
{
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	
	[IDMAlertViewManager setDefaultConnectionErrorTitle:alertTitle message:alertMessage];
	
	BOOL result = [IDMAlertViewManager showDefaultConnectionFailureAlert];
    XCTAssertTrue(result, @"[%d] 1", result);
	
	// Trying to show an alert with another already being displayed
	result = [IDMAlertViewManager showDefaultConnectionAlertWithSuccess:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Should not been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
    
    XCTAssertFalse(result, @"[%d] 0", result);
	
	// Trying to show an alert without any being displayed
	[IDMAlertViewManager dismiss:NO];
	result = [IDMAlertViewManager showDefaultConnectionAlertWithSuccess:^(NSUInteger selectedIndex) {
		XCTAssertTrue(selectedIndex == kDEFAULT_DISMISS_INDEX, @"[%d] %d", kDEFAULT_DISMISS_INDEX, selectedIndex);
	} failure:^(NSError *error) {
		XCTAssertTrue(NO, @"Should not throw error");
	}];
	[IDMAlertViewManager simulateDismissalClick];
    
    XCTAssertTrue(result, @"[%d] 1", result);
	
	// Trying to show the default alert with another with same priority already up
	[IDMAlertViewManager showAlertWithTitle:@"aTitle" message:@"aMessage"];
    result = [IDMAlertViewManager showDefaultConnectionFailureAlert];
	
    XCTAssertFalse(result, @"[%d] 0", result);
	XCTAssertFalse([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
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
	BOOL result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage];
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
	
	// Tries to show an alert with the default already up
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage];
    XCTAssertFalse(result, @"[%d] 0", result);
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
	BOOL result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityLow];
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
	
	// Tries to show a low priority alert with the default already up
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityLow];
    XCTAssertFalse(result, @"[%d] 0", result);
	XCTAssertFalse([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	[IDMAlertViewManager dismiss:NO];
	
	// Tries to show a high priority alert with the default already up
	[IDMAlertViewManager showDefaultConnectionFailureAlert];
	result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityHigh];
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Tries to show a DEFCON priority alert with a high priority already up
	NSString *defconTitle	= @"defconTitle";
	NSString *defconMessage	= @"defconMessage";
	
	result = [IDMAlertViewManager showAlertWithTitle:defconTitle message:defconMessage priority:IDMAlertPriorityDEFCON];
    XCTAssertTrue(result, @"[%d] 1", result);
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
	BOOL result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(dismissed, @"Run success block before dismissing");
	} failure:^(NSError *error) {
		XCTAssertFalse(YES, @"Shouldn't throw error");
	}];
	
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Failing to show an alert
	NSString *anotherTitle	= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	
	result = [IDMAlertViewManager showAlertWithTitle:anotherTitle message:anotherMessage success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
    
    XCTAssertFalse(result, @"[%d] 0", result);
	
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
	BOOL result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
	
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Failing to show an alert with lower or equal priority
	NSString *anotherTitle	= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	
	result = [IDMAlertViewManager showAlertWithTitle:anotherTitle message:anotherMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	}];
	
    XCTAssertFalse(result, @"[%d] 0", result);
	XCTAssertFalse([self.shared.alertView.title isEqualToString:anotherTitle],		@"[%@] %@", anotherTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:anotherMessage],	@"[%@] %@", anotherMessage, self.shared.alertView.message);
	
	// Showing an alert with higher priority
	result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityHigh success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(dismissed, @"Run success block before dismissing");
	} failure:^(NSError *error) {
		XCTAssertFalse(YES, @"Shouldn't throw error");
	}];
	
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	dismissed = YES;
	[IDMAlertViewManager simulateDismissalClick];
}

- (void)testShowAlertWithTitleMessagePrioritySuccessFailureButtons
{
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	NSArray *alertButtons	= @[@"Cancel"];
	
	__block BOOL dismissed = NO;
	
	// Showing an alert
	BOOL result = [IDMAlertViewManager showAlertWithTitle:alertTitle message:alertMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	} buttons:alertButtons];
	
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
	
	// Failing to show an alert with lower or equal priority
	NSString *anotherTitle		= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	NSArray *anotherButtons		= @[@"button1", @"button2"];
	
	result = [IDMAlertViewManager showAlertWithTitle:anotherTitle message:anotherMessage priority:IDMAlertPriorityMedium success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorHigherPriorityAlert, @"[%d] %d", IDMAlertErrorHigherPriorityAlert, error.code);
	} buttons:anotherButtons];
	
    XCTAssertFalse(result, @"[%d] 0", result);
	XCTAssertFalse([self.shared.alertView.title isEqualToString:anotherTitle],		@"[%@] %@", anotherTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:anotherMessage],	@"[%@] %@", anotherMessage, self.shared.alertView.message);
	XCTAssertFalse(self.shared.alertView.numberOfButtons == anotherButtons.count,	@"[%d] %d", anotherButtons.count, self.shared.alertView.numberOfButtons);
	
	// Showing an alert with higher priority
	result = [IDMAlertViewManager showAlertWithTitle:alertTitle
									message:alertMessage
								   priority:IDMAlertPriorityHigh success:^(NSUInteger selectedIndex) {
									   XCTAssertTrue(dismissed, @"Run success block before dismissing");
								   } failure:^(NSError *error) {
									   XCTAssertFalse(YES, @"Shouldn't throw error");
								   } buttons:anotherButtons];
	
    XCTAssertTrue(result, @"[%d] 1", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],			@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],		@"[%@] %@", alertMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == anotherButtons.count,	@"[%d] %d", anotherButtons.count, self.shared.alertView.numberOfButtons);
	
	dismissed = YES;
	[IDMAlertViewManager simulateDismissalClick];
}

- (void)testShowAlertViewPriority
{
    self.globalResult = NO;
    
	// Setting properties
	NSString *alertTitle	= @"title";
	NSString *alertMessage	= @"message";
	NSArray *alertButtons	= @[@"Foo", @"Bar"];
    
    UIAlertView *alertView  = [UIAlertView new];
    alertView.title         = alertTitle;
    alertView.message       = alertMessage;
    alertView.delegate      = self;
    
    for (NSString *buttonTitle in alertButtons)
    {
        [alertView addButtonWithTitle:buttonTitle];
    }
    
	// Showing an alert
    BOOL result = [IDMAlertViewManager showAlertView:alertView priority:IDMAlertPriorityMedium];
	
    XCTAssertTrue(result, @"[1], %d", result);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == alertButtons.count,	@"[%d] %d", alertButtons.count, self.shared.alertView.numberOfButtons);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:alertTitle],		@"[%@] %@", alertTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:alertMessage],	@"[%@] %@", alertMessage, self.shared.alertView.message);
    
	// Failing to show an alert with lower or equal priority
	NSString *anotherTitle		= @"aTitle";
	NSString *anotherMessage	= @"aMessage";
	NSArray *anotherButtons		= @[@"button1", @"button2", @"button3"];
    
    UIAlertView *newAlertView   = [UIAlertView new];
    newAlertView.title          = anotherTitle;
    newAlertView.message        = anotherMessage;
    newAlertView.delegate       = self;
    
    for (NSString *buttonTitle in anotherButtons)
    {
        [newAlertView addButtonWithTitle:buttonTitle];
    }
    
    result = [IDMAlertViewManager showAlertView:newAlertView priority:IDMAlertPriorityMedium];
	
    XCTAssertFalse(result, @"[0], %d", result);
	XCTAssertFalse([self.shared.alertView.title isEqualToString:anotherTitle],		@"[%@] %@", anotherTitle, self.shared.alertView.title);
	XCTAssertFalse([self.shared.alertView.message isEqualToString:anotherMessage],	@"[%@] %@", anotherMessage, self.shared.alertView.message);
	XCTAssertFalse(self.shared.alertView.numberOfButtons == anotherButtons.count,	@"[%d] %d", anotherButtons.count, self.shared.alertView.numberOfButtons);
	
	// Showing an alert with higher priority
    result = [IDMAlertViewManager showAlertView:newAlertView priority:IDMAlertPriorityHigh];
    
    XCTAssertTrue(result, @"[1], %d", result);
	XCTAssertTrue([self.shared.alertView.title isEqualToString:anotherTitle],		@"[%@] %@", anotherTitle, self.shared.alertView.title);
	XCTAssertTrue([self.shared.alertView.message isEqualToString:anotherMessage],	@"[%@] %@", anotherMessage, self.shared.alertView.message);
	XCTAssertTrue(self.shared.alertView.numberOfButtons == anotherButtons.count,	@"[%d] %d", anotherButtons.count, self.shared.alertView.numberOfButtons);
	
	[IDMAlertViewManager simulateDismissalClick];
}

- (void)testDismiss
{
	// Setting properties
	BOOL result = [IDMAlertViewManager showAlertWithTitle:@"title" message:@"message" success:^(NSUInteger selectedIndex) {
		XCTAssertTrue(NO, @"Shouldn't been successful");
	} failure:^(NSError *error) {
		XCTAssertNotNil(error, @"[not nil] %@", error);
		XCTAssertTrue(error.code == IDMAlertErrorFailedDismiss, @"[%d] %d", IDMAlertErrorFailedDismiss, error.code);
	}];
    
    XCTAssertTrue(result, @"[%d] 1", result);
	
	[IDMAlertViewManager dismiss:NO];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.globalResult = YES;
}

@end
