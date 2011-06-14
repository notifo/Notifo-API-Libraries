//
//  SendMessageController.m
//  NotifoObjC
//
//  Created by Joshua Grenon on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendMessageController.h"
#import "NotifoClient.h"
#import "UIColor+DigitalColorMeter.h"

@implementation SendMessageController

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
    
    // Release any cached data, images, etc that aren't in use.
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
    SendMessageRequest *request = [SendMessageRequest alloc];
	request.to = txtTo.text;
	request.msg = txtMsg.text; 
	
    NotifoCompletionBlock complete = ^(NotifoResponse *response, NSError *error)
    {
        if (error) 
        {
            NSLog(@"SendMessage error: %@", [error userInfo]); 
        } 
        else
        {               
            [txtResponse setText:[NSString stringWithFormat:@"status: %@\nresponse: %@\nresponse message: %@",response.status,response.response_code,response.response_message]];
        }
    };
    
	[notifo SendMessage:request completionBlock:complete]; 
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
