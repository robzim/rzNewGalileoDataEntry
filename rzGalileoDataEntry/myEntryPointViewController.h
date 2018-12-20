//
//  myEntryPointViewController.h
//  rzGalileoDataEntry
//
//  Created by Robert Zimmelman on 5/26/17.
//  Copyright © 2017 Robert Zimmelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myViewController.h"

@interface myEntryPointViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myStudyTextField;

@property (weak, nonatomic) IBOutlet UITextField *myURLTextField;
@property NSString *myStudyTag;
- (IBAction)myShowTheURL:(id)sender;
- (IBAction)myGetTheURL:(id)sender;

@end
