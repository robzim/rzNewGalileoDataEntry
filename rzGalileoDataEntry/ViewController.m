//
//  ViewController.m
//  rz MMDS Survey DataEntry
//
//  Created by Robert Zimmelman on 12/4/15.
//  Copyright © 2016 Robert Zimmelman. All rights reserved.
//
#import "ViewController.h"
BOOL myUsesKeyboard;
BOOL myUsesSpinner;
BOOL myUsesSlider;
//BOOL myLocalFlag = TRUE;
BOOL myLocalFlag = FALSE;
int concept1number = 0;
// j can start at 1 and not zero because we're going to ask the first distance
// from concept1 to conecept1 (we dont' need to ask the distance of concept1 to concept1, it is 0)
int concept2number = 1;
int previousconcept1number = 0;
int previousconcept2number = 0;
int myQuestionCount = 0;
int myRandomStartConcept = 0;
int myNumberofQuestions = 5;
int myConceptCount = 0;
float myDisplayValue = 0;
float myDistances[100][100];
unsigned char *myDistanceTimes[100][100];

@implementation ViewController
@synthesize myConceptsArray;
@synthesize myRecipientArray;
@synthesize myConcept1;
@synthesize myConcept2;
@synthesize mySliderValue;
@synthesize myReferenceConcepts;
@synthesize myStudy;
@synthesize myStudyName;
@synthesize myStudyFile;
@synthesize myStudyTitleLabel;
@synthesize myDefaultURLString;
@synthesize myStudyURL;
@synthesize myStudySite;
@synthesize myReachableReference;
@synthesize myNetworkReachabilityFlags;
@synthesize myCancelledAlertController;
@synthesize myFailedAlertController;
@synthesize mySentMessageAlertController;
@synthesize myStartTimeStamp;
@synthesize myAnswersHoldingString;
@synthesize myAnswersDictionary;
@synthesize myAnswersJSONString;
@synthesize myTextField;
@synthesize mySpinnerButton;
@synthesize myTopSliderStackView;

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}



//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self myHideAllSliders];
//}


-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:(BOOL)animated];
    // use these to control the data entry method
    myUsesSlider = YES;
    myUsesKeyboard = NO;
    myUsesSpinner = NO;
    
    //    [myAnswersHoldingString appendString:@"test"];
    //    NSLog(@"myAnswersHoldingString =  %@",myAnswersHoldingString);
    myAnswersDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
    myStudyFile = @"rztest";
    myDefaultURLString = [NSString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/%@.txt",myStudyFile];
    myReachableReference = SCNetworkReachabilityCreateWithName(NULL, [myDefaultURLString UTF8String]);
    
    myStudySite = [NSString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/%@.txt",myStudyFile];
    NSLog(@"VIEW WILL APPEAR - reachability %@",myReachableReference);
    // rz check the url early and see if we can load it
    //
    NSError *myError = nil;
    
    if (myLocalFlag == YES) {
        NSString *myPath = [[NSBundle mainBundle] pathForResource:@"rztest copy" ofType:@"txt"];
        myStudyURL = [NSURL fileURLWithPath:myPath];
        
    } else {
        myStudyURL = [NSURL URLWithString:myDefaultURLString];
    }
    
//    NSString *myPath = [[NSBundle mainBundle] pathForResource:@"rztest copy" ofType:@"txt"];
//    myStudyURL = [NSURL URLWithString:myPath];

//    myStudy = nil;
    
    myStudy = [NSString stringWithContentsOfURL:myStudyURL encoding:NSUTF8StringEncoding error:nil];
    
    if (!myStudy) {
        NSLog(@"error studystring is nil.  showing URL Error with alert controller");
        [self showURLErrorAlertController:myError];
    } else if (myStudy) {
//        NSLog(@"myStudy = %@",myStudy);
        NSLog(@"GOOD STUDY.  myStudy HAS A VALUE");
    }
  
    
    
    //TODO: make sure the paired comparison shows when the keyboard pops
    [[NSNotificationCenter defaultCenter ] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"Keyboard showed");
        [self myHideAllSliders];
    }];
    [[NSNotificationCenter defaultCenter ] addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"Keyboard hidden");
        [self myShowAllSliders];
    }];
    

    
    
    [myTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [myTextField setClearsOnBeginEditing:YES];
}






-(void)myHideTheKeyboard{
//    [mySliderValue setText:myTextField.text];
//    [myTextField setText:@"Enter Value"];
    [myTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    //    [super viewDidAppear:(BOOL)animated];
    UITapGestureRecognizer *myTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myHideTheKeyboard)];
    [self.view addGestureRecognizer:myTapGestureRecognizer];
    //
    //  rz if we can't get the study string, alert the user
    //
//    [myTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];

    if ((!myLocalFlag) && (!myReachableReference)    ){
        UIAlertController *myNetworkNotReachableAlert = [UIAlertController alertControllerWithTitle:@"Network ERROR" message:@"The Network is NOT REACHABLE!  Please attempt to correct and try again.  Thanks for trying!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  exit(1);
                                                              }];
        [myNetworkNotReachableAlert addAction:defaultAction];
        [self presentViewController:myNetworkNotReachableAlert animated:YES completion:nil];
    }
    if  (!myStudy)   {
        UIAlertController *myNetworkNotReachableAlert = [UIAlertController alertControllerWithTitle:@"Network ERROR" message:@"The Study Name is not Set.  Please contact the study coordinator.  Thanks for trying!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  exit(1);
                                                              }];
        [myNetworkNotReachableAlert addAction:defaultAction];
        [self presentViewController:myNetworkNotReachableAlert animated:YES completion:nil];
    }
    //
    //
    // rz if we have a study string, let's go conduct the survey
    //
    else if ((myReachableReference)  || (myStudy))  {
        //  rz check that the survey is reasonable here
        //
        // rz check that there is a . and a "@" in the first line
        //
        //
        UISwipeGestureRecognizer *myRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(mySwipeforPriorConcepts)];
        [myRightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:myRightSwipeGestureRecognizer];
        
        UISwipeGestureRecognizer *myLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(mySwipeforNextConcepts)];
        [myLeftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.view addGestureRecognizer:myLeftSwipeGestureRecognizer];
        
        //        [self getURL];
        
        [self conductSurvey];
    }
    
    //
    
}



//

- (void)conductSurvey{
    NSLog(@"In conduct survey");
    if (!myReachableReference) {
        NSLog(@"CONDUCT SURVEY Network is not reachable and is = %@",myReachableReference);
        exit(1);
    }
    
    //  now we're going out to the web to get the data from the URL
    //
    
    NSStringEncoding encoding;
    NSError *myError = nil;
    
    NSString *myStudyString = [[NSString alloc] initWithContentsOfURL:myStudyURL
                                                         usedEncoding:&encoding
                                                                error:&myError];
    
    if (!myStudyString) {
        NSLog(@"error studystring is nil.  showing URL Error with alert controller");
        [self showURLErrorAlertController:myError];
        exit(1);
    }
    
    if (myError != nil) {
        NSLog(@"Error reading file %@",
              [myError localizedFailureReason]);
        exit(1);
    }
    
    
    NSMutableArray *myTempArray = [NSMutableArray arrayWithObjects:[myStudyString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]], nil];
    NSLog(@"myTempArray count = %lu",(unsigned long)[myTempArray count]);
    if ( [myTempArray count] == 0 ) {
        NSLog(@"Error reading URL Temparray is empty !!!");
        
        UIAlertController  *myLoadErrorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error, there are no concepts, the URL may be OFFLINE!!" preferredStyle:UIAlertControllerStyleAlert];
        [myLoadErrorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            exit(1);
        }]];
        [self presentViewController:myLoadErrorAlert animated:YES completion:nil];
        //        exit(1);
    }
    
    
    
    //
    // rz first assign the email address to the first line in the file
    //
    myRecipientArray = [NSMutableArray arrayWithObjects:[[myTempArray objectAtIndex:0] objectAtIndex:0], nil];
    //    NSString *myRecipientsString = [NSString stringWithFormat:@"%@",myRecipientsArray];
    
    //
    //    myRecipientsArray = [NSMutableArray arrayWithObjects:[myRecipientsString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@","]], nil];
    
    
    
    
    
    
    
    [[myTempArray objectAtIndex:0] removeObjectAtIndex:0];
    //  rz now the Study Name is at the top
    //  so we can now assign the top line to the Study Name
    //
    myStudyName = [[myTempArray objectAtIndex:0] objectAtIndex:0] ;
    NSLog(@"Study Name = %@",myStudyName);
    [myStudyTitleLabel setText:myStudyName];
    
    myAnswersHoldingString = [NSMutableString stringWithFormat:@"%@;",myStudyName];
    // assign the study name to the dictionary
    [[myTempArray objectAtIndex:0] removeObjectAtIndex:0];
    //
    // now the Concepts are at the top
    //
    myConceptsArray = [myTempArray objectAtIndex:0];
    
    myConceptCount = myConceptsArray.count - 1.0;
    
    for (int i = 0 ; i <= myConceptCount ; i++) {
        for (int j = 0; j <= myConceptCount; j++) {
            myDistances[i][j] = -1.0;
        }
    }
    
    concept1number = arc4random() % myConceptCount;
    concept2number = concept1number + 1;
    
    
    
    // rz set up the reference concepts label
    // using the first two concepts in the study at 100 units apart
    //
    //
    self.myConcept1.text = [myConceptsArray objectAtIndex:concept1number];
    self.myConcept2.text = [NSString stringWithFormat:@"%@ ?",[myConceptsArray objectAtIndex:concept2number]];
    [myReferenceConcepts setText:[NSString stringWithFormat:@"%@ and %@",  [myConceptsArray objectAtIndex:0] , [myConceptsArray objectAtIndex:1]   ]];
}



- (void)showURLErrorAlertController: (NSError *)theError{
    NSLog(@"showURLErrorAlertController  Error reading file %@",
          [theError localizedFailureReason]);
    //    NSString *myMessage = [NSString stringWithFormat:@"There was an Error Loading the URL at %@.   To test the URL, cut and paste it into any web browser and you should see visible Study coordinates.  If you do not, see your professor.  The URL that the App was trying to open is in your Paste buffer.  Go to any app and press the 'Paste' button to see it.",myDefaultURLString];
    //    NSString *myMessage = [NSString stringWithFormat:@"Error: %@",myDefaultURLString];
    UIAlertController  *myLoadErrorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Error = %@",theError] preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *myAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *myAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ERROR NO URL - EXITING!!!");
        exit(1);
    }];
    [myLoadErrorAlert setTitle:@"Study Not Found On Network!!!"];
    [myLoadErrorAlert setEditing:NO];
    [myLoadErrorAlert setPreferredContentSize:CGSizeMake(400.0, 400.)];
    [myLoadErrorAlert addAction:myAlertAction];
    [self presentViewController:myLoadErrorAlert animated:YES completion:nil];
    NSLog(@"showURLErrorAlertController    -  After present ViewController");
}



-(void)mySwipeforNextConcepts{
    // rz currently swipe left
    [self myOK:self];
}

-(void)mySwipeforPriorConcepts{
    // rz currently swipe right
    concept1number = previousconcept1number;
    concept2number = previousconcept2number;
    self.myConcept1.text = [myConceptsArray objectAtIndex:concept1number];
    self.myConcept2.text = [NSString stringWithFormat:@"%@ ?",[myConceptsArray objectAtIndex:concept2number]];
}



-(void)myNextConcepts{
    previousconcept1number = concept1number;
    previousconcept2number = concept2number;
    //  rz setting to conceptcount - 1 to avoid comparing the last concept to itself
    if (concept1number < (myConceptCount - 1)) {  // concept1 needs to be held
        if (concept2number < (myConceptCount)) { concept2number++; }
        else { // concept2 is now at the max and needs to be reset
            // concept1 number now can be incremented when we reset concept2
            concept1number++;
            if (concept1number < myConceptCount) { concept2number = concept1number + 1; }
        }
        self.myConcept1.text = [myConceptsArray objectAtIndex:concept1number];
        self.myConcept2.text =  [NSString stringWithFormat:@"%@ ?",[myConceptsArray objectAtIndex:concept2number]];
        [mySliderValue setText:[NSString stringWithFormat:@"%0.0f",myDistances[concept1number][concept2number]]];
    }
//    [myTextField setText:@""];
}

-(void)LogTheItemsintheArray {
    for (int x = 0 ; x < myConceptsArray.count ; x++)
        for (int y = 0; y < myConceptsArray.count; y++)
            NSLog(@"%@,%@,%f;", myConceptsArray[x], myConceptsArray[y],  myDistances[x][y]);
}


- (IBAction)mySliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%0.0f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}


- (IBAction)myMiddleSliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%0.0f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}



- (IBAction)myLittleSliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%0.0f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}


-(void)myEnterTheValue{
    
    // rz this is where we load the mydistances array with the value in the slider
    NSDate *myTimeStamp = [NSDate date];
    [ myAnswersHoldingString  appendString: [NSString stringWithFormat:@"GMT=%@,",myTimeStamp ]];
    [ myAnswersHoldingString  appendString: [NSString stringWithFormat:@"%@,%@,%0.0f;",myConceptsArray[concept1number],myConceptsArray[concept2number], [self.mySliderValue.text floatValue]]];
    myDistances[concept1number][concept2number] = [self.mySliderValue.text floatValue];
    
    NSDictionary *myTempDictionary = [NSDictionary dictionaryWithObjects:@[ [NSString stringWithFormat:@"Time: %@, Value %@",
                                                                           myTimeStamp, mySliderValue.text]
                                                                           ] forKeys:@[
                                                                                       [NSString stringWithFormat:@"%@, %@",myConceptsArray[concept1number],myConceptsArray[concept2number]],
                                                                                       ]];
    [myAnswersDictionary addEntriesFromDictionary:myTempDictionary];
    
    NSLog(@"Answers Dictionary = %@",myAnswersDictionary);
    
    
    //    NSLog(@"myAnswersHoldingString = %@",myAnswersHoldingString);
}

-(void)myIncrementConcepts{
    [self myEnterTheValue];
    //
    // increment the counter so we can exit when we've entered enough
    myQuestionCount++;
    // rz once concept1 is nconcepts -1 and concept2 is nconcepts, we're done
    //
    if ((concept1number == (myConceptCount -1) && concept2number == myConceptCount) || (myQuestionCount >= myNumberofQuestions)  )    {
        NSLog(@"%@",myAnswersHoldingString);
        [self sendDatabyEmail];
    }
    [self myNextConcepts];
    
//    [myTextField setText:@""];
    // increment the concept count number
    //  rz if the concepts are the same we don't need to get the values

}

- (IBAction)myOK:(id)sender {
    if (myTopSliderStackView.isHidden) {
        [mySliderValue setText:myTextField.text];
        [myTextField setText:@""];
    }
    [self myIncrementConcepts];
}

- (IBAction)myExit:(id)sender {
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"EXIT ???" message:@"You are about to send survey responses to the study leader via email.  Are you sure you are ready to Send Responses and Exit?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
//                                                              [self testPrint];
                                                              
                                                              
                                                              
                                                              [self sendDatabyEmail];
                                                          }];
    [myAlert addAction:defaultAction];
    [self presentViewController:myAlert animated:YES completion:nil];
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"in mailComposeViewController didFinishWithResult");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MFMailComposeResultSent:
        {
            NSLog(@"Sent!");
            mySentMessageAlertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your data was sent to the study leader.  Thank you for your participation!  Press OK to Exit" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      exit(0);
                                                                  }];
            [mySentMessageAlertController addAction:defaultAction];
//            [self removeFromParentViewController];
            [self presentViewController:mySentMessageAlertController animated:YES completion:nil];
            break;
        }
            
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Cancelled!");
            myCancelledAlertController = nil;
            myCancelledAlertController = [UIAlertController alertControllerWithTitle:@"Cancelled" message:@"You have Cancelled the email send.  Your data was NOT sent.  Please consider re-taking the survey!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * action) {
                                                                      exit(0);
                                                                      
                                                                  }];
            [myCancelledAlertController addAction:defaultAction];
            UIAlertAction *myRetakeAction = [UIAlertAction actionWithTitle:@"Re Take The Study" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [myTextField setText:@"Tap for Keyboard"];
                myQuestionCount = 0;
            }];
            [myCancelledAlertController addAction:myRetakeAction];
            [self presentViewController:myCancelledAlertController animated:YES completion:nil];
            break;
        }
        case MFMailComposeResultFailed:
        {
            NSLog(@"Failed!");
            myFailedAlertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your device does not support SMS" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      exit(1);
                                                                  }];
            [myFailedAlertController addAction:defaultAction];
            [self presentViewController:myFailedAlertController animated:YES completion:nil];
            break;
        }
        default:
            NSLog(@"ERROR!");
            mySentMessageAlertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Unknowr Error!  Please Contact the Research Coordinator!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      exit(0);
                                                                  }];
            [mySentMessageAlertController addAction:defaultAction];
            [self presentViewController:mySentMessageAlertController animated:YES completion:nil];
            break;
    }
}





- (void)sendDatabyEmail {
    NSLog(@"at start of sendDatabyEmail");
    [myAnswersDictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:myStudyName,@"Study Name", nil]];
    NSLog(@"FINAL FINAL Answers Dictionary = %@",myAnswersDictionary);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myAnswersDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    myAnswersJSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"My Answers Dictionary AS JSON = %@",myAnswersJSONString);
    
    if (! [MFMailComposeViewController canSendMail] ) {
        NSLog(@"Cannot send email!!!");
        UIAlertController  *myCannoSendEmailAlertController = [UIAlertController alertControllerWithTitle:@"Email FAILURE!!" message:@"Your device FAILED to send EMAIL!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  exit(1);
                                                                  
                                                                  
                                                              }];
        [myCannoSendEmailAlertController addAction:defaultAction];
        [self presentViewController:myCannoSendEmailAlertController animated:YES completion:nil];
    } else {
        NSLog(@"CAN send email!!!");
        NSMutableString *mySurveyData = [[NSMutableString alloc] init];
        NSDate *myTimeStamp = [NSDate date];
        [mySurveyData appendString:[NSString stringWithFormat:@"Date/Time(GMT)=%@",myTimeStamp]];
        for (int x = 0 ; x < myConceptsArray.count ; x++)
            for (int y = 0; y < myConceptsArray.count; y++)
                [mySurveyData appendString:[NSString stringWithFormat:@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]]];
        MFMailComposeViewController *myMailViewController = [[MFMailComposeViewController alloc] init];
        [myMailViewController setMailComposeDelegate:self];
        
        //        [myMailViewController setMessageBody:mySurveyData isHTML:NO];
//        [myMailViewController setMessageBody:myAnswersHoldingString isHTML:NO];
        [myMailViewController setMessageBody:myAnswersJSONString isHTML:NO];
        
        
        [myMailViewController setSubject:[NSString stringWithFormat: @"Data from %@ Study",myStudyName]];
        [myMailViewController setToRecipients:myRecipientArray];
        [self presentViewController:myMailViewController animated:NO completion:nil];
        [myMailViewController setEditing:NO];
        //        NSLog(@"%@",mySurveyData);
        NSLog(@"%@",myAnswersJSONString);
        NSLog(@"at end of sendDatabyEmail");
        
    }
}


-(void)myGetURL{
    UIAlertController *myURLRequestController = [UIAlertController alertControllerWithTitle:@"Enter URL" message:@"Enter URL with Study Email, Title and Concepts" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self conductSurvey];
                                                              
                                                          }];
    [myURLRequestController addAction:defaultAction];
    [myURLRequestController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = myDefaultURLString;
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        //
        // rz why are we setting to myStudySite here?
        //
//        textField.text = myStudySite;
    }];
    
    [self presentViewController:myURLRequestController animated:YES completion:^(void) {
        NSLog(@"in getURL Completion Block");
    }];
}

-(void)testPrint{
    //    NSMutableString *mySurveyTestPrintData = [[NSMutableString alloc] init];
    for (int x = 0 ; x < myConceptsArray.count ; x++)
        for (int y = 0; y < myConceptsArray.count; y++){
            //            [mySurveyTestPrintData appendString:[NSString stringWithFormat:@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]]];
            NSLog(@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]);
        }
}


-(void)myShowAllSliders{
    [mySpinnerButton setHidden:NO];
    [mySliderValue setHidden:NO];
    NSArray *theSubViews  = [self.view subviews];
    [theSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *theSubSubViews = [obj subviews];
        [theSubSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(UIView *) obj tag] == 101   ) {
                [obj setHidden:NO];
            }
        }];
    } ];
}


-(void)myHideAllSliders{
    [mySpinnerButton setHidden:YES];
    [mySliderValue setHidden:YES];
    NSArray *theSubViews  = [self.view subviews];
    [theSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *theSubSubViews = [obj subviews];
        [theSubSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(UIView *) obj tag] == 101   ) {
                [obj setHidden:YES];
            }
        }];
    } ];
}


- (IBAction)myDisplayKeyboard:(id)sender {
    [self myHideAllSliders];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification object:self];

//    UIInputView *myInputView = [[UIInputView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0) inputViewStyle:UIInputViewStyleKeyboard];
    //
    //
    //  how do we add the accessory view here?
    //
    UIBarButtonItem *myOKItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(myHideTheKeyboard)];
    UIBarButtonItem *myCancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(myHideTheKeyboard)];
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
    [myToolbar setItems:@[  myOKItem, myCancelItem,
                          ]];
    [myToolbar sizeToFit];
    [myToolbar setBarStyle:UIBarStyleDefault];
    [myTextField setInputAccessoryView:myToolbar];

    
    
//    UIButton *myOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [myOKButton setFrame:CGRectMake(1.0, 10.0, 50.0, 30.0)];
//    [myOKButton setTitle:@"OK" forState:UIControlStateNormal];
//    [myInputView addSubview:myOKButton];

    

    [self.view addSubview:myToolbar];
//    [myInputView setNeedsDisplay];
    
    
    
}

- (IBAction)myDisplayStepper:(id)sender {
    [self myShowAllSliders];

}
@end

