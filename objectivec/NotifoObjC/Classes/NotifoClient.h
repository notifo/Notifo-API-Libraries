//
//  NotifoClient.h
//  NotifoObjC
//
//  Created by Joshua Grenon on 11/13/10.
// Copyright (c) 2010 MotionMobs (http://motionmobs.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <Foundation/Foundation.h>
#import "NotifoResponse.h"
#import "NotifoRequest.h"
#import "SubscribeUserRequest.h"
#import "SendNotificationRequest.h"
#import "SendMessageRequest.h"

#define USERNAME @"YOUR_NOTIFO_USERNAME"
#define APISECRET @"YOUR_NOTIFO_API_SECRET"
 
typedef void (^NotifoCompletionBlock)(NotifoResponse *response, 
                                              NSError *error); 

@interface NotifoClient : NSObject {
	
	NSString *_username;
	NSString *_apisecret;
}

@property (nonatomic, retain) NSString *_username;
@property (nonatomic, retain) NSString *_apisecret;

-(NotifoClient*) initWithCredentials: (NSString *) username 
						   APISecret: (NSString *) apisecret; 

-(void)SubscribeUser: (SubscribeUserRequest *) requestObject completionBlock:(NotifoCompletionBlock)completion;

-(void)SendNotification: (SendNotificationRequest*) requestObject completionBlock:(NotifoCompletionBlock)completion;

-(void)SendMessage: (SendMessageRequest*) requestObject completionBlock:(NotifoCompletionBlock)completion;

-(void)PostRequest: (NSURL *)postURL postObject: (NotifoRequest*)notifoRequest classname: (const char *)className;
-(void)errorParsingJSON:(NSError *)error;

@end