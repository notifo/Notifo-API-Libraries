//
//  SendNotificationController.m
//  NotifoObjC
//
//  Created by Joshua Grenon on 6/11/11.
//  Copyright 2011 MotionMObs. All rights reserved.
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

#import "SendNotificationController.h"
#import "NotifoClient.h"
#import "UIColor+DigitalColorMeter.h"

@implementation SendNotificationController

@synthesize txtTo;
@synthesize txtMsg;
@synthesize txtResponse;
@synthesize btnSend;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithDigitalColorMeterString:@"62.0	73.7	83.5"];
    txtResponse.backgroundColor = [UIColor colorWithDigitalColorMeterString:@"62.0	73.7	83.5"];
}

-(IBAction)sendMessage
{
    [txtTo resignFirstResponder];
    [txtMsg resignFirstResponder];
    
    __block NotifoClient *notifo = [[NotifoClient alloc] initWithCredentials:USERNAME 
                                                                   APISecret:APISECRET];
    SendNotificationRequest *request = [SendNotificationRequest alloc];
	request.to = txtTo.text;
	request.msg = txtMsg.text; 
	
    NotifoCompletionBlock complete = ^(NotifoResponse *response, NSError *error)
    {
        if (error) 
        {
            NSLog(@"SendNotification error: %@", [error userInfo]); 
        } 
        else
        {               
            [txtResponse setText:[NSString stringWithFormat:@"status: %@\nresponse: %@\nresponse message: %@",response.status,response.response_code,response.response_message]];
        }
    };
    
	[notifo SendNotification:request completionBlock:complete]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end