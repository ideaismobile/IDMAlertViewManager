//
//  IDMAlertViewManager.m
//  IDMAlertViewManager
//
//  Created by Flavio Caetano on 9/5/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

// random num
#define kDEFAULT_DISMISS_INDEX	17672
#define kFAILED_DISMISS_INDEX	94836

#define kHIGHER_ALERT_MESSAGE	@"Higher Priority Alert: %d"
#define kFAILED_DISMISS_MESSAGE	@"Programmatically Dismissed Alert"

#import "IDMAlertViewManager.h"

/**
 *  The singleton's shared instance.
 */
static IDMAlertViewManager *_sharedInstance;

/**
 *  The queue to run blocks
 */
static dispatch_queue_t custom_queue;

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
@property (nonatomic, strong) NSString *defaultConnectionFailureMessage;

/**
 *  The default text of the dismissal button. If not set, the default value is `OK`
 */
@property (nonatomic, strong) NSString *defaultDismissalButtonText;

/**
 *  The "other buttons" array for dismissing the default connection failure alert.
 */
@property (nonatomic, strong) NSArray *buttonsArray;

/**
 *  The visible alert view.
 */
@property (nonatomic, strong) UIAlertView *alertView;

/**
 *  Indicates if the current alert view is visible. Necessary because [UIAlertView show] might be called, but it's `isVisible` is yet `NO`.
 */
@property (nonatomic) BOOL isAlertViewVisible;

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
- (BOOL)isMoreImportantThanPriority:(IDMAlertPriority)priority;

/**
 *  Returns the shared instance for the singleton. Initializes it if it's nil.
 */
+ (IDMAlertViewManager *)sharedInstance;

/**
 *  Inits another IDMAlertViewManager
 */
+ (void)_reinit;

/**
 *  Simulates the user clicking to dismiss a alert view.
 *
 *  @warning For testing purposes only!
 */
+ (void)simulateDismissalClick;

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
		custom_queue = dispatch_queue_create("br.com.ideais.IDMAlertViewManagerQueue", NULL);
		self.defaultDismissalButtonText = @"OK";
	}
	
	return self;
}

#pragma mark - Class Methods

// Sets the title and message for the default connection failure alert.
+ (void)setDefaultConnectionErrorTitle:(NSString *)title message:(NSString *)message
{
	[IDMAlertViewManager setDefaultConnectionErrorTitle:title message:message otherButtons:nil];
}

// Sets the title, message and dismiss buttons for the default connection failure alert.
+ (void)setDefaultConnectionErrorTitle:(NSString *)title message:(NSString *)message otherButtons:(NSArray *)buttonsArray
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	avm.defaultConnectionFailureTitle	= title;
	avm.defaultConnectionFailureMessage	= message;
	avm.buttonsArray					= buttonsArray;
}

// Changes the default message for the main dismissal button. If this mehod is not called, the message is `OK`
+ (void)setDefaultDismissalButton:(NSString *)dismissButtonMessage
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	avm.defaultDismissalButtonText = dismissButtonMessage;
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
									message:avm.defaultConnectionFailureMessage
								   priority:IDMAlertPriorityMedium
									success:successBlock
									failure:failureBlock
							   otherButtons:avm.buttonsArray];
}

// Shows an alert with the given `title` and `message` and the default priority `IDMAlertPriorityMedium`.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
	[self showAlertWithTitle:title message:message priority:IDMAlertPriorityMedium];
}

// Shows an alert with the given `title`, `message` and `priority`. If an alert with lower priority than this is currently visible, it gets dismissed and this alert takes it's place.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message priority:(IDMAlertPriority)priority
{
	[IDMAlertViewManager showAlertWithTitle:title
									message:message
								   priority:priority
									success:nil
									failure:nil];
}

// Shows an alert with the given `title` and `message` and the default priority `IDMAlertPriorityMedium`.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message success:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	[IDMAlertViewManager showAlertWithTitle:title
									message:message
								   priority:IDMAlertPriorityMedium
									success:successBlock
									failure:failureBlock];
}

// Shows an alert with the given `title`, `message` and `priority`.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message priority:(IDMAlertPriority)priority success:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	[IDMAlertViewManager showAlertWithTitle:title
									message:message
								   priority:priority
									success:successBlock
									failure:failureBlock
							   otherButtons:nil];
}

// Shows an alert with the given `title`, `message`, `priority` and `otherButtons` for dismissing the UIAlertView.
+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock
			  otherButtons:(NSArray *)buttonsArray
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	if ([avm isMoreImportantThanPriority:priority])
	{
		if (failureBlock)
		{
			__block IDMAlertPriority currentPriority = avm.currentPriority;
			dispatch_async(custom_queue, ^{
				NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:kHIGHER_ALERT_MESSAGE, currentPriority] code:IDMAlertErrorHigherPriorityAlert userInfo:nil];
				failureBlock(error);
			});
		}
		
		return;
	}
	
	avm.currentPriority		= priority;
	avm.successBlock		= successBlock;
	avm.failureBlock		= failureBlock;
	avm.isAlertViewVisible	= YES;
	
	avm.alertView.title		= title;
	avm.alertView.message	= message;
	
	[avm.alertView addButtonWithTitle:avm.defaultDismissalButtonText];
	for (NSString *buttonTitle in buttonsArray)
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
	
	[avm.alertView dismissWithClickedButtonIndex:kFAILED_DISMISS_INDEX animated:animated];
	[avm clearVolatileProperties];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (self.successBlock)
	{
		__block IDMAlertViewSuccessBlock successBlock = self.successBlock;
		dispatch_async(custom_queue, ^{
			successBlock(buttonIndex);
		});
	}
	
	[self clearVolatileProperties];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (self.failureBlock && buttonIndex == kFAILED_DISMISS_INDEX)
	{
		__block IDMAlertViewFailureBlock failureBlock = self.failureBlock;
		dispatch_async(custom_queue, ^{
			NSError *error = [[NSError alloc] initWithDomain:kFAILED_DISMISS_MESSAGE code:IDMAlertErrorFailedDismiss userInfo:nil];
			failureBlock(error);
		});
	}
}

#pragma mark - Private Methods

// Clears the volatile properties like `successBlock`, `failureBlock` and `currentPriority`.
- (void)clearVolatileProperties
{
	self.isAlertViewVisible	= NO;
	
	self.alertView			= [UIAlertView new];
	self.alertView.delegate = self;
	
	self.successBlock		= nil;
	self.failureBlock		= nil;
	
	self.currentPriority	= INFINITY;
}

// Check the importance of the current alert priority, if any, against the given one. If this priority is higher, dismiss the current alert.
- (BOOL)isMoreImportantThanPriority:(IDMAlertPriority)priority
{
	if (! self.isAlertViewVisible)
	{
		return NO;
	}
	
	// Dismiss the current alert if it's priority is lower than `priority`.
	if (priority < self.currentPriority)
	{
		[self.alertView dismissWithClickedButtonIndex:kDEFAULT_DISMISS_INDEX animated:NO];
		
		if (self.failureBlock)
		{
			__block IDMAlertViewFailureBlock failureBlock	= self.failureBlock;
			__block IDMAlertPriority currentPriority		= self.currentPriority;
			dispatch_async(custom_queue, ^{
				NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:kHIGHER_ALERT_MESSAGE, currentPriority] code:IDMAlertErrorHigherPriorityAlert userInfo:nil];
				failureBlock(error);
			});
		}
		
		[self clearVolatileProperties];
		
		return NO;
	}
	
	return YES;
}

// Returns the shared instance for the singleton. Initializes it if it's nil.
+ (IDMAlertViewManager *)sharedInstance
{
	if (_sharedInstance == nil)
	{
		[IDMAlertViewManager _reinit];
	}
	
	return _sharedInstance;
}

+ (void)_reinit
{
	_sharedInstance = [[IDMAlertViewManager alloc] initSuper];
}

+ (void)simulateDismissalClick
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	[avm.alertView dismissWithClickedButtonIndex:kDEFAULT_DISMISS_INDEX animated:NO];
}

@end
