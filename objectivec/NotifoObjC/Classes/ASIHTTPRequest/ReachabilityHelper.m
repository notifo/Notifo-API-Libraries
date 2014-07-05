//
//  ReachabilityHelper.m
//  FitHacks
//
//  Created by Joshua Grenon on 2/21/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ReachabilityHelper.h"


@implementation ReachabilityHelper
@synthesize internetUnreachable, wifiUnreachable, statusString;


- (BOOL)internetReachable
{
	internetUnreachable = @" ";
	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
	// method "reachabilityChanged" will be called. 
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	//Change the host name here to change the server your monitoring
	
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
	[self updateInterfaceWithReachability: wifiReach];
	NSLog(@"internt unreachable: %@", internetUnreachable);
	if(![internetUnreachable isEqualToString:@" "])
	{
		NSString *temp = [[NSString alloc]init];
		temp = [NSString stringWithFormat:@"%@%@%@",internetUnreachable,@" \n ", wifiUnreachable];	
		statusString = temp;
		return NO;
	} 
	
	return YES;	
}

- (void)reachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
	
    switch (netStatus)
    {
        case NotReachable:
        {
			if(curReach == internetReach)
			{	
				internetUnreachable = @"Internet Access Not Available";
			}
			
			if(curReach == wifiReach)
			{	
				wifiUnreachable = @"WiFi Network Access Not Available";
			}	
			
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;  
        } 			
    }
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{	
	if(curReach == internetReach)
	{	
		[self reachability: curReach];
	}
	if(curReach == wifiReach)
	{	
		[self reachability: curReach];
	}	
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

@end
