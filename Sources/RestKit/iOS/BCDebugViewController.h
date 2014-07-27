//
//  BCDebugViewController.h
//  BushidoCore
//
//  Created by Seth Kingsley on 2/7/13.
//  Copyright © 2013 Bushido Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCDebugViewController : UIViewController
{
	IBOutlet UISwitch *_networkTraceSwitch;
	IBOutlet UISwitch *_objectTraceSwitch;
}

+ sharedInstance;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
