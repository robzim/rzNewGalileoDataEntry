//
//  myEntryPointViewController.h
//  rzGalileoDataEntry
//
//  Created by Robert Zimmelman on 5/26/17.
//  Copyright © 2017 Robert Zimmelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myEntryPointViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myURLTextField;
- (IBAction)myShowTheURL:(id)sender;
- (IBAction)myGetTheURL:(id)sender;

@end
