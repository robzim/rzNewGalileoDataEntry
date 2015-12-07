//
//  ViewController.h
//  rzGalileoDataEntry
//
//  Created by Robert Zimmelman on 12/4/15.
//  Copyright © 2015 Robert Zimmelman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>

- (IBAction)mySliderMove:(UISlider *)sender;
- (IBAction)myLittleSliderMove:(UISlider *)sender;

- (IBAction)myOK:(id)sender;
- (IBAction)myExit:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *myReferenceConcepts;

@property (weak, nonatomic) IBOutlet UILabel *mySliderValue;

@property (weak, nonatomic) IBOutlet UILabel *myConcept1;

@property (weak, nonatomic) IBOutlet UILabel *myConcept2;


@property (strong, nonatomic) NSArray *myConceptsArray;
@property (strong, nonatomic) NSArray *myRecipientsArray;
@property (strong, nonatomic) NSString *myStudyFile;
@property (strong, nonatomic) NSString *myStudyName;

@property (strong,nonatomic)  NSURL  *myStudyURL;
@property (strong, nonatomic) NSString *myDefaultURLString;

@property (weak, nonatomic) IBOutlet UILabel *myStudyTitleLabel;

@end

