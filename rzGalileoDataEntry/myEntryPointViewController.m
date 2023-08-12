//
//  myEntryPointViewController.m
//  rzGalileoDataEntry
//
//  Created by Robert Zimmelman on 5/26/17.
//  Copyright © 2017 Robert Zimmelman. All rights reserved.
//

#import "myEntryPointViewController.h"

@interface myEntryPointViewController ()

@end

@implementation myEntryPointViewController
@synthesize myStudyTag;
@synthesize myStudyTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [myStudyTextField setDelegate:self];
}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [[segue identifier] isEqualToString:@"myConductSurveySegue" ] ) {
        myViewController *myVC = segue.destinationViewController;
        [myVC setMyStudyTagString:self.myStudyTextField.text];
        // Delay for 5 seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:myVC animated:YES];
        });
        
    }
}

- (IBAction)myShowTheURL:(id)sender {
    [_myURLTextField setHidden:NO];
}

- (IBAction)myGetTheURL:(id)sender {
    NSLog(@" URL IS  %@",_myURLTextField.text);
    [_myURLTextField resignFirstResponder];
}
@end
