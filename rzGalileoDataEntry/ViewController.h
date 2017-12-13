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


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate,UITextFieldDelegate>
- (IBAction)mySliderMove:(UISlider *)sender;
- (IBAction)myMiddleSliderMove:(UISlider *)sender;
- (IBAction)myLittleSliderMove:(UISlider *)sender;
- (IBAction)myOK:(id)sender;
- (IBAction)myExit:(id)sender;
@property (weak, nonatomic) IBOutlet UIStackView *myTopSliderStackView;

@property SCNetworkReachabilityRef myReachableReference;
@property SCNetworkReachabilityFlags *myNetworkReachabilityFlags;

@property (weak, nonatomic) IBOutlet UIButton *mySpinnerButton;
@property (weak, nonatomic) IBOutlet UILabel *myReferenceConcepts;
@property (weak, nonatomic) IBOutlet UILabel *mySliderValue;
@property (weak, nonatomic) IBOutlet UILabel *myConcept1;
@property (weak, nonatomic) IBOutlet UILabel *myConcept2;
@property (strong, nonatomic) NSArray *myConceptsArray;
@property (strong, nonatomic) NSMutableArray *myRecipientArray;
@property (strong, nonatomic) NSString *myStudyFile;
@property (strong, nonatomic) NSString *myStudy;
@property (strong, nonatomic) NSString *myStudyName;
@property (strong, nonatomic) NSString *myStudySite;
@property (strong,nonatomic)  NSURL  *myStudyURL;
@property (weak, nonatomic) IBOutlet UILabel *myTapLabel;
@property (strong, nonatomic) NSString *myDefaultURLString;
@property (weak, nonatomic) IBOutlet UILabel *myStudyTitleLabel;
@property (strong, nonatomic) UIAlertController *myCancelledAlertController;
@property (strong, nonatomic) UIAlertController *myFailedAlertController;
@property (strong, nonatomic) UIAlertController *mySentMessageAlertController;
@property (strong, nonatomic) NSString *myStartTimeStamp;
@property (strong, nonatomic) NSMutableString *myAnswersHoldingString;
@property NSMutableDictionary *myAnswersDictionary;
@property NSString *myAnswersJSONString;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;

- (IBAction)myDisplayKeyboard:(id)sender;
- (IBAction)myDisplayStepper:(id)sender;

@end

