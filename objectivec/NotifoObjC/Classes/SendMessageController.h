//
//  SendMessageController.h
//  NotifoObjC
//
//  Created by Joshua Grenon on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SendMessageController : UIViewController {
 
    IBOutlet UITextField *txtTo;
    IBOutlet UITextField *txtMsg;
    IBOutlet UITextView *txtResponse;
    IBOutlet UIButton *btnSend;
}

@property(nonatomic, retain) IBOutlet UITextField *txtTo;
@property(nonatomic, retain) IBOutlet UITextField *txtMsg;
@property(nonatomic, retain) IBOutlet UITextView *txtResponse;
@property(nonatomic, retain) IBOutlet UIButton *btnSend;

-(IBAction)sendMessage;

@end