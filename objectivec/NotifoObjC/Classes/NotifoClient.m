//
//  NotifoClient.m
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


#import "NotifoClient.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import <objc/runtime.h>

@interface NotifoClient()

@property(nonatomic, copy) NotifoCompletionBlock notifoCompletionBlock;

@end

@implementation NotifoClient

@synthesize _username;
@synthesize _apisecret;
@synthesize notifoCompletionBlock;

NSString * const SendNotificationURL = @"https://api.notifo.com/v1/send_notification";
NSString * const SubscribeUserURL = @"https://api.notifo.com/v1/subscribe_user";
NSString * const SendMessageURL = @"https://api.notifo.com/v1/send_message";

-(NotifoClient*) initWithCredentials: (NSString *) username 
						   APISecret: (NSString *) apisecret
{
	self = [super init];
    if ( self ) {
		
		_username = username;
		_apisecret = apisecret;
	}
	
	return self;
}

-(ASIFormDataRequest* )buildPostObject: (const char *)className urltoPost: (NSURL *)post_url postObject: (NSObject *)postObj
{
	//use reflection to loop through all the items in the post class.
	//Then get each value that is not null and setPostValue each forKey in ASIFormDataRequest class
	//and return ASIFormDataRequest class.
	
	Class clazz = objc_getClass(className);
	NSUInteger count;
    objc_property_t *propList = class_copyPropertyList(clazz, &count); 
	
	ASIFormDataRequest* postRequest = [ASIFormDataRequest requestWithURL:post_url];
	[postRequest setUsername:_username];
	[postRequest setPassword:_apisecret];
	[postRequest addRequestHeader:@"ContentType" value:@"application/x-www-form-urlencoded"];
	[postRequest addRequestHeader:@"Accept" value:@"application/json, text/json"];
	
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
		
		const char *propName = property_getName(property);
		NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
		
		const char *propAttributes = property_getAttributes(property);
		NSString *propAttributesString =[NSString stringWithCString:propAttributes encoding:NSASCIIStringEncoding];
		NSLog(@"property attributes: %@", propAttributesString);
		
		//use property attributes to get the type of property for each one in the class
		if(propName) 
		{
			NSArray *attributesArray = [propAttributesString componentsSeparatedByString:@","];
			id value = [postObj valueForKey:propNameString];
			
			NSString *valueToCompare = [attributesArray objectAtIndex:0];
			
			//only add to postRequest if the value is not null
			if (value != nil) 
			{			 
				if([valueToCompare isEqualToString:@"T@\"NSString\""])
				{ 
					//convert _private key to private
					//because private is an objc keyword
					if ([value isEqualToString:@"_private"]) 
						propNameString = @"private";
					
					[postRequest addPostValue:value forKey:propNameString];
				}
				
			}
		}
	}
    free(propList);
	
	return postRequest;
}

-(void)SubscribeUser: (SubscribeUserRequest *) requestObject completionBlock:(NotifoCompletionBlock)completion
{	
    const char *SubscribeUserRequest = "SubscribeUserRequest";
    
    notifoCompletionBlock = [completion copy];
	NSURL *postURL = [NSURL URLWithString:SubscribeUserURL];    
	[self PostRequest:postURL postObject: requestObject classname:SubscribeUserRequest];
}

-(void)SendNotification: (SendNotificationRequest*) requestObject completionBlock:(NotifoCompletionBlock)completion
{
    const char *SendNotificationRequestConst = "SendNotificationRequest";
    
    notifoCompletionBlock = [completion copy];
	NSURL *postURL = [NSURL URLWithString:SendNotificationURL];
	[self PostRequest:postURL postObject: requestObject classname:SendNotificationRequestConst];
}

-(void)SendMessage: (SendMessageRequest*) requestObject completionBlock:(NotifoCompletionBlock)completion
{
    const char *SendMessageRequestConst = "SendMessageRequest";
    
    notifoCompletionBlock = [completion copy];
	NSURL *postURL = [NSURL URLWithString:SendMessageURL];
	[self PostRequest:postURL postObject: requestObject classname: SendMessageRequestConst];
}

-(void)PostRequest: (NSURL *)postURL postObject: (NotifoRequest*)notifoRequest classname: (const char *)className
{
	ASIFormDataRequest* postRequest = [self buildPostObject:className urltoPost:postURL postObject:notifoRequest];
	[postRequest setDelegate:self];
	[postRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{	
	NSData *responseData = [request responseData];
	
	if (responseData != NULL) 
	{
		CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
		NSError *error = nil;
		NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:responseData error:&error];
		
		if (error != nil)
			[self errorParsingJSON:error];
		else 
		{
			NotifoResponse *response = [[NotifoResponse alloc] initWithJSON:resultsDictionary];
			
            if (self.notifoCompletionBlock) 
                self.notifoCompletionBlock(response, nil);
		}
	}
}

-(void)errorParsingJSON:(NSError *)error
{
	NSLog(@"Error parsing JSON: %@", [error localizedDescription]);
}
 
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"request failed: %@", error);
}

@end