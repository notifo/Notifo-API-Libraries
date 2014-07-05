//
//  ReachabilityHelper.h
//  FitHacks
//
//  Created by Joshua Grenon on 2/21/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Reachability.h"

@class Reachability;
@interface ReachabilityHelper : NSObject {
    Reachability* internetReach;
    Reachability* wifiReach;
	NSString *internetUnreachable;
	NSString *wifiUnreachable;
	NSString *statusString;
}

@property (nonatomic, retain)NSString *internetUnreachable;
@property (nonatomic, retain)NSString *wifiUnreachable;
@property (nonatomic, retain)NSString *statusString;

- (BOOL)internetReachable;
- (void) updateInterfaceWithReachability: (Reachability*) curReach;
@end
