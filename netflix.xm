
@class ATVDictionaryFeedResource;

@interface ATVDictionaryFeedResource

- (id)feedResourceNamed:(id)named;	// 0x171381
- (void)setFeedResource:(id)resource named:(id)named;

@end

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

//this right here will prevent the nag alert from showing, all that is necessary for that! :)

%hook ATVSedonaMerchant

- (ATVDictionaryFeedResource *)sessionResource
{
	%log;
	ATVDictionaryFeedResource *sr = %orig;
	[sr setFeedResource:@"true" named:@"updateMessageShown"];
	[sr setFeedResource:@"false" named:@"showUpdateMessage"];
	return %orig;
}

%end

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