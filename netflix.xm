
/*
@class ATVFeedOptionDialogController;

@interface ATVFeedOptionDialogController

	- (NSArray *)subviews;
	- (void)skipUpdateDialog;
	- (void)pressPlay;

@end

%hook ATVFeedOptionDialogController


 "javascript-url" = "https://api-global.netflix.com/atv/redir?jsname=application.js";

"UPDATE_LATER_BUTTON" = "Update later";
  "UPDATE_MESSAGE" = "An Apple TV software update is required to use Netflix. Go to Settings > General > Update Software.";
  "UPDATE_NOW_BUTTON" = "Update now";

kBREventRemoteActionMenu = 1,
kBREventRemoteActionMenuHold,
kBREventRemoteActionUp,
kBREventRemoteActionDown,
kBREventRemoteActionPlay,
kBREventRemoteActionLeft,
kBREventRemoteActionRight,



//all deprecated, we can skip it altogether now!



%new - (void)skipUpdateDialog
{
	%log;
	id mediaMenuView = [[self subviews] lastObject];
	NSString *headerText = [mediaMenuView listDescription];
	
	NSString *netflixPrefFile = @"/var/mobile/Library/Application Support/Front Row/Merchants/netflix/preferences.plist";
	NSDictionary *prefDict = [NSDictionary dictionaryWithContentsOfFile:netflixPrefFile];
	NSString *checkString = @"An Apple TV software update is required to use Netflix. Go to Settings > General > Update Software.";
	NSString *updateLater = @"Update later";
	if (prefDict != nil)
	{
		checkString = [prefDict valueForKey:@"UPDATE_MESSAGE"];
		updateLater = [prefDict valueForKey:@"UPDATE_LATER_BUTTON"];
//		NSLog(@"check string: %@", checkString); //should work for any language now! :)
	}
	
	if ([headerText isEqualToString:checkString])
	{
		NSLog(@"update dialog!");
	} else {
		NSLog(@"its not the update dialog, return");
	}
	
	
	id list = [mediaMenuView list];
	int controlCount = (int)[list controlCount];
//	NSLog(@"control count: %i", controlCount);
	if (controlCount < 2) 
	{
		//when we do this check there isn't more than 1 control for some reason in the list.., doing a timer or delayed selector broke simulation a play button
//		NSLog(@"probably forcing us to update, don't do shit!");
	//	return;
	}
	
	NSString *stringTwo = [[list itemAtIndex:1] text];
	if ([stringTwo isEqualToString:updateLater])
	{
			NSLog(@"doing massive amounts of sciance");
			[list setSelection:1];
			[self pressPlay];
	//		[self performSelectorOnMainThread:@selector(playScience) withObject:nil waitUntilDone:YES];
	}
	
}

%new - (void)pressPlay
{
		%log;
		id eventClass = NSClassFromString(@"BREvent");
		id appClass = NSClassFromString(@"BRApplication");
		id event = [eventClass eventWithAction:5 value: 1];
	//	NSLog(@"event: %@ appClass: %@", event, appClass);
		[[appClass sharedApplication] dispatchEventOnEventThread: event];
	//	event = [eventClass eventWithAction:5 value: 0];
	//	[[appClass sharedApplication] dispatchEventOnEventThread: event];
		
}

- (void)layoutSubcontrols{

	[self skipUpdateDialog];
	%orig;
}
*/

//this is the 7.x stuff for now playing continuously

/*

- (void)wasPushed
{
	%log;
	id mediaMenuView = [[self subviews] lastObject];
	NSString *headerText = [[mediaMenuView listHeader] title];
	NSString *netflixPrefFile = @"/var/mobile/Library/Application Support/Front Row/Merchants/netflix/preferences.plist";
	NSDictionary *prefDict = [NSDictionary dictionaryWithContentsOfFile:netflixPrefFile];
	NSString *checkString = @"Are you still watching?";
	if (prefDict != nil)
	{
		checkString = [prefDict valueForKey:@"ARE_YOU_STILL_WATCHING_LABEL"];
		NSLog(@"check string: %@", checkString); //should work for any language now! :)
	}
	
	if ([headerText isEqualToString:checkString]) //localize
	{
		NSLog(@"doing massive amounts of sciance");
		id eventClass = NSClassFromString(@"BREvent");
		id appClass = NSClassFromString(@"BRApplication");
		id event = [eventClass eventWithAction: 5 value: 1];
		[[appClass sharedApplication] dispatchEventOnEventThread: event];
	}

}


%end

*/
/*

this right here will prevent the nag alert from showing, all that is necessary for that! :)

*/

%hook ATVSedonaMerchant

- (id)sessionResource
{
	%log;
	id sr = %orig;
	[sr setFeedResource:@"true" named:@"updateMessageShown"];
	[sr setFeedResource:@"false" named:@"showUpdateMessage"];
	return %orig;
}

%end

/*

%hook ATVFeedMerchant 

- (id)generateRequestForURL:(id)url headers:(id)headers method:(id)method body:(id)body
{
	
	%log;
	return %orig;
	
}
- (void)startApplication:(id)application
{
	%log;
	%orig;
}
- (void)stopApplication
{
	%log;
	%orig;
}

%end
*/
/*
%hook ATVSedonaMerchant

- (void)_vendorOutOfDateSoftware:(id)dateSoftware
{
	%log;
	%orig;
}

- (void)decorateRequestProperties:(id)properties	// 0x2519b1
{
	%log;
	%orig;
}

- (id)generateRequestForURL:(id)url headers:(id)headers method:(id)method body:(id)body
{
	%log;
	return %orig;
	
}


%end

*/


/*
%hook ATVJSContext

- (void)callFunction:(id)function
{
	%log;
	%orig;
}

- (void)callFunction:(id)function withArguments:(id)arguments{
	%log;
	%orig;
}
- (void)callFunction:(id)function withArguments:(id)arguments completionQueue:(id)queue completionHandler:(id)handler{
	%log;
	%orig;
}
- (BOOL)callSynchronousFunction:(id)function withArguments:(id)arguments returnValue:(id *)value{
	%log;
	%orig;
}	// 0x187469

%end
*/
/*
%hook ATVDictionaryFeedResource

- (id)feedResourceNamed:(id)named
{
	%log;
	if ([named isEqualToString:@"showUpdateMessage"])
	{
		return @"false";
	} else if ([named isEqualToString:@"updateMessageShown"])
	{
		return @"true";
	}
	
	return %orig;
}
%end
*/

//comment code below back in if we ever need to re-direct to our cached version of netflix js

/*

%hook ATVVendorBag

- (id)_normalizeBag:(id)bag
{
	return %orig;
	
	NSMutableDictionary *theBag = [[NSMutableDictionary alloc] initWithDictionary:%orig];
	NSString *javascriptURL = [theBag valueForKey:@"javascript-url"];
	if ([javascriptURL isEqualToString:@"https://api-global.netflix.com/atv/redir?jsname=application.js"])
	{
		[theBag setObject:@"https://dl.dropboxusercontent.com/u/16129573/netflix.js" forKey:@"javascript-url"];
//		NSLog(@"modified bag: %@", theBag);
//		NSLog(@"metadata: %@", [self metadata]);
//		NSLog(@"appConfiguration: %@", [self appConfiguration]);
		
		return theBag;
	}
	return %orig;
}

%end
*/