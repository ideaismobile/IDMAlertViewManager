//
//  IDMAlertViewManager.m
//  IDMAlertViewManager
//
//  Created by Flavio Caetano on 9/5/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#define kDEFAULT_DISMISS_INDEX -1

#import "IDMAlertViewManager.h"

/**
 *  The singleton's shared instance.
 */
static IDMAlertViewManager *_sharedInstance;

@interface IDMAlertViewManager ()

#pragma mark - Properties

/**
 *  The priority of the current alert visible. If there's none, it's `INFINITY`.
 */
@property (nonatomic) IDMAlertPriority currentPriority;

/**
 *  The success block to be called when the visible alert view gets dismissed.
 */
@property (nonatomic, strong) IDMAlertViewSuccessBlock successBlock;

/**
 *  The failure block to be called when the visible alert view gets dismissed by any reason different than the user.
 */
@property (nonatomic, strong) IDMAlertViewFailureBlock failureBlock;

/**
 *  The title for the default connection failure alert.
 */
@property (nonatomic, strong) NSString *defaultConnectionFailureTitle;

/**
 *  The text message for the default connection failure alert.
 */
@property (nonatomic, strong) NSString *defaultConnectionFailureText;

/**
 *  The "other buttons" array for dismissing the default connection failure alert.
 */
@property (nonatomic, strong) NSArray *buttonsArray;

/**
 *  The visible alert view.
 */
@property (nonatomic, strong) UIAlertView *alertView;

#pragma mark - Private Methods Declaration

/**
 *  Initializes the shared instance for the singleton.
 */
- (id)initSuper;

/**
 *  Clears the volatile properties like `successBlock`, `failureBlock` and `currentPriority`.
 */
- (void)clearVolatileProperties;

/**
 *  Check the importance of the current alert priority, if any, against the given one. If this priority is higher, dismiss the current alert.
 *
 *  @param priority A IDMAlertPriority
 */
- (void)checkImportanceAgainstPriority:(IDMAlertPriority)priority;

/**
 *  Returns the shared instance for the singleton. Initializes it if it's nil.
 */
+ (IDMAlertViewManager *)sharedInstance;

@end

#pragma mark - Implementation

@implementation IDMAlertViewManager

// init
- (id)init
{
	[NSException raise:@"Singleton Implemantation" format:@"Can't instantiate %@", NSStringFromClass([self class])];
	return nil;
}

// Initializes the shared instance for the singleton.
- (id)initSuper
{
	if (self = [super init])
	{
		[self clearVolatileProperties];
	}
	
	return self;
}

#pragma mark - Class Methods

// Sets the title and text for the default connection failure alert.
+ (void)setDefaultConnectionErrorTitle:(NSString *)title text:(NSString *)text
{
	[IDMAlertViewManager setDefaultConnectionErrorTitle:title text:text otherButtons:nil];
}

// Sets the title, text and dismiss buttons for the default connection failure alert.
+ (void)setDefaultConnectionErrorTitle:(NSString *)title text:(NSString *)text otherButtons:(NSArray *)buttonsArray
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	avm.defaultConnectionFailureTitle	= title;
	avm.defaultConnectionFailureText	= text;
	avm.buttonsArray					= buttonsArray;
}

#pragma mark - Displaying Alerts

// Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
+ (void)showDefaultConnectionFailureAlert
{
	[IDMAlertViewManager showDefaultConnectionAlertWithSuccess:nil failure:nil];
}

// Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
+ (void)showDefaultConnectionAlertWithSuccess:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	[IDMAlertViewManager showAlertWithTitle:avm.defaultConnectionFailureTitle
									   text:avm.defaultConnectionFailureText
								   priority:IDMAlertPriorityMedium
									success:successBlock
									failure:failureBlock
							   otherButtons:avm.buttonsArray];
}

// Shows an alert with the given `title` and `text` and the default priority `IDMAlertPriorityMedium`.
+ (void)showAlertWithTitle:(NSString *)title text:(NSString *)text
{
	[self showAlertWithTitle:title text:text priority:IDMAlertPriorityMedium];
}

// Shows an alert with the given `title`, `text` and `priority`. If an alert with lower priority than this is currently visible, it gets dismissed and this alert takes it's place.
+ (void)showAlertWithTitle:(NSString *)title text:(NSString *)text priority:(IDMAlertPriority)priority
{
	[IDMAlertViewManager showAlertWithTitle:title
									   text:text
								   priority:priority
									success:nil
									failure:nil];
}

// Shows an alert with the given `title` and `text` and the default priority `IDMAlertPriorityMedium`.
+ (void)showAlertWithTitle:(NSString *)title text:(NSString *)text success:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	[IDMAlertViewManager showAlertWithTitle:title
									   text:text
								   priority:IDMAlertPriorityMedium
									success:successBlock
									failure:failureBlock];
}

// Shows an alert with the given `title`, `text` and `priority`.
+ (void)showAlertWithTitle:(NSString *)title text:(NSString *)text priority:(IDMAlertPriority)priority success:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	[IDMAlertViewManager showAlertWithTitle:title
									   text:text
								   priority:priority
									success:successBlock
									failure:failureBlock
							   otherButtons:nil];
}

// Shows an alert with the given `title`, `text`, `priority` and `otherButtons` for dismissing the UIAlertView.
+ (void)showAlertWithTitle:(NSString *)title
					  text:(NSString *)text
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock
			  otherButtons:(NSArray *)buttonsArray
{
	
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	[avm checkImportanceAgainstPriority:priority];
	
	avm.currentPriority		= priority;
	avm.successBlock		= successBlock;
	avm.failureBlock		= failureBlock;
	
	avm.alertView.title		= title;
	avm.alertView.message	= text;
	
	[avm.alertView addButtonWithTitle:@"OK"];
	for (NSString *buttonTitle in avm.buttonsArray)
	{
		[avm.alertView addButtonWithTitle:buttonTitle];
	}
	
	[avm.alertView show];
}

#pragma mark - Dismissing Alerts

// Dismiss the visible UIAlertView, if any.
+ (void)dismiss:(BOOL)animated
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	[avm.alertView dismissWithClickedButtonIndex:kDEFAULT_DISMISS_INDEX animated:animated];
	[avm clearVolatileProperties];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (self.successBlock)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			self.successBlock(buttonIndex);
		});
	}
}

#pragma mark - Private Methods

// Clears the volatile properties like `successBlock`, `failureBlock` and `currentPriority`.
- (void)clearVolatileProperties
{
	self.alertView			= [UIAlertView new];
	self.alertView.delegate = self;
	
	self.successBlock		= nil;
	self.failureBlock		= nil;
	
	self.currentPriority	= INFINITY;
}

// Check the importance of the current alert priority, if any, against the given one. If this priority is higher, dismiss the current alert.
- (void)checkImportanceAgainstPriority:(IDMAlertPriority)priority
{
	// Dismiss the current alert if it's priority is lower than `priority`.
	if (self.alertView.isVisible && self.currentPriority < priority)
	{
		[self.alertView dismissWithClickedButtonIndex:kDEFAULT_DISMISS_INDEX animated:NO];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (self.failureBlock)
			{
				NSError *error = [[NSError alloc] initWithDomain:@"Higher Priority Alert" code:IDMAlertErrorHigherPriorityAlert userInfo:nil];
				self.failureBlock(error);
			}
		});
		
		[self clearVolatileProperties];
	}
}

// Returns the shared instance for the singleton. Initializes it if it's nil.
+ (IDMAlertViewManager *)sharedInstance
{
	if (_sharedInstance == nil)
	{
		_sharedInstance = [[IDMAlertViewManager alloc] initSuper];
	}
	
	return _sharedInstance;
}

@end
