//
//  ViewController.m
//  rzGalileoDataEntry
//
//  Created by Robert Zimmelman on 12/4/15.
//  Copyright © 2015 Robert Zimmelman. All rights reserved.
//


int concept1number = 0;
// j can start at 1 and not zero because we're going to ask the first distance
// from concept1 to conecept1 (we dont' need to ask the distance of concept1 to concept1, it is 0)
int concept2number = 1;

int previousconcept1number = 0;
int previousconcept2number = 0;


int myConceptCount = 0;

float myDisplayValue = 0;
float myDistances[100][100];


#import "ViewController.h"



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



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:(BOOL)animated];
    
    myStudyFile = @"rztest";
    myDefaultURLString = [NSString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/%@.txt",myStudyFile];
    myReachableReference = SCNetworkReachabilityCreateWithName(NULL, [myDefaultURLString UTF8String]);
    myStudyURL = [NSURL URLWithString:myDefaultURLString];
    myStudySite = [NSString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/%@.txt",myStudyFile];
    NSLog(@"VIEW WILL APPEAR - reachability %@",myReachableReference);
    // rz check the url early and see if we can load it
    //
    NSStringEncoding encoding;
    NSError *myError = nil;
    myStudy = [[NSString alloc] initWithContentsOfURL:myStudyURL
                                                         usedEncoding:&encoding
                                                                error:&myError];
    if (!myStudy) {
        NSLog(@"error studystring is nil.  showing URL Error with alert controller");
    } else if (myStudy) {
        NSLog(@"myStudy = %@",myStudy);
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:(BOOL)animated];
    //
    //  rz if we can't get the study string, alert the user
    //
    if ((!myReachableReference)  || (!myStudy))    {
        UIAlertController *myNetworkNotReachableAlert = [UIAlertController alertControllerWithTitle:@"Network ERROR" message:@"The Network is NOT REACHABLE!  Please attempt to correct and try again.  Thanks for trying!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  exit(1);
                                                              }];
        [myNetworkNotReachableAlert addAction:defaultAction];
        
        //        dispatch_async(dispatch_get_main_queue(), ^ {
        //            [self presentViewController:myNetworkNotReachableAlert animated:YES completion:nil];
        //        });
        
        [self presentViewController:myNetworkNotReachableAlert animated:YES completion:nil];
    }
    //
    //
    // rz if we have a study string, let's go conduct the survey
    //
    else if ((myReachableReference)  || (myStudy))  {
        //
        //
        //
        //  rz check that the survey is reasonable here
        //
        // rz check that there is a . and a "@" in the first line
        //
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
    
//    concept1number = arc4random() % myConceptCount;
//    concept2number = concept1number + 1;

    
    
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
    NSString *myMessage = [NSString stringWithFormat:@"There was an Error Loading the URL at %@.   To test the URL, cut and paste it into any web browser and you should see visible Galileo coordinates.  If you do not, see your professor.  The URL that the App was trying to open is in your Paste buffer.  Go to any app and press the 'Paste' button to see it.",myDefaultURLString];
    UIAlertController  *myLoadErrorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Error = %@",theError.localizedFailureReason] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *myAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [myLoadErrorAlert addAction:myAlertAction];
    [myLoadErrorAlert addTextFieldWithConfigurationHandler:^(UITextField * myTextField) {
        [myTextField setText:myMessage];
    }];
    
    //            dispatch_async(dispatch_get_main_queue(), ^ {
    //                [self presentViewController:myLoadErrorAlert animated:YES completion:nil];
    //            });
    
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
    //
    //
    //
    //  rz setting to conceptcount - 1 to avoid comparing the last concept to itself
    //
    if (concept1number < (myConceptCount - 1)) {  // concept1 needs to be held
        if (concept2number < (myConceptCount)) {
            concept2number++;
        }
        
        else { // concept2 is now at the max and needs to be reset
            // concept1 number now can be incremented when we reset concept2
            concept1number++;
            if (concept1number < myConceptCount) {
                concept2number = concept1number + 1;
            }
        }
        self.myConcept1.text = [myConceptsArray objectAtIndex:concept1number];
        self.myConcept2.text =  [NSString stringWithFormat:@"%@ ?",[myConceptsArray objectAtIndex:concept2number]];
        //        NSLog(@"#1 = %d #2 = %d   C1 = %@  C2 = %@",concept1number,concept2number,[myConceptsArray objectAtIndex:concept1number], [myConceptsArray objectAtIndex:concept1number]);
//        [[self.view viewWithTag:9999] 
//        [mySliderValue setText:[NSString stringWithFormat:@"%@",myConceptsArray[concept1number][concept2number]]];
        [mySliderValue setText:[NSString stringWithFormat:@"%f",myDistances[concept1number][concept2number]]];
    }
    
}

-(void)LogTheItemsintheArray {
    for (int x = 0 ; x < myConceptsArray.count ; x++)
        for (int y = 0; y < myConceptsArray.count; y++)
            NSLog(@"%@,%@,%f;", myConceptsArray[x], myConceptsArray[y],  myDistances[x][y]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mySliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}


- (IBAction)myMiddleSliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}



- (IBAction)myLittleSliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}


-(void)myEnterTheValue{
    myDistances[concept1number][concept2number] = [self.mySliderValue.text floatValue];
    NSLog(@"Value = %f",myDistances[concept1number][concept2number]);
}


- (IBAction)myOK:(id)sender {
    [self myEnterTheValue];
    //
    // rz once concept1 is nconcepts -1 and concept2 is nconcepts, we're done
    //
    if (concept1number == myConceptCount -1 && concept2number == myConceptCount){
        [self LogTheItemsintheArray];
        [self testPrint];
        [self sendDatabyEmail];
        //        [self sendDatabySMS];
        //        exit(0);
    }
    [self myNextConcepts];
    //
    //
    //
    //  rz if the concepts are the same we don't need to get the values
    //
}

- (IBAction)myExit:(id)sender {
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"EXIT ???" message:@"You are about to send survey responses to the study leader via email.  Are you sure you are ready to Send Responses and Exit?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self testPrint];
                                                              [self sendDatabyEmail];
                                                          }];
    [myAlert addAction:defaultAction];
    [self presentViewController:myAlert animated:YES completion:nil];
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"in mailComposeViewController didFinishWithResult");
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Cancelled!");
            myCancelledAlertController = [UIAlertController alertControllerWithTitle:@"Cancelled" message:@"You have Cancelled the email send.  Your data was NOT sent.  Please consider re-taking the survey!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {
                                                                      NSLog(@"from the block.  CANCELLED!");
                                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            [myCancelledAlertController addAction:defaultAction];
            [self.parentViewController presentViewController:myCancelledAlertController animated:YES completion:nil];
            [self removeFromParentViewController];
            break;
        }
        case MFMailComposeResultFailed:
        {
            NSLog(@"Failed!");
            
            myFailedAlertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your device does not support SMS" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      
                                                                  }];
            [myFailedAlertController addAction:defaultAction];
            [self removeFromParentViewController];
            [self presentViewController:myFailedAlertController animated:YES completion:nil];
            break;
        }
        case MFMailComposeResultSent:
        {
            NSLog(@"Sent!");
            mySentMessageAlertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your data was sent to the study leader.  Thank you for your participation!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      
                                                                  }];
            [mySentMessageAlertController addAction:defaultAction];
            [self removeFromParentViewController];
            [self presentViewController:mySentMessageAlertController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    exit(0);
}


-(void)testPrint{
    NSMutableString *myGalileoData = [[NSMutableString alloc] init];
    for (int x = 0 ; x < myConceptsArray.count ; x++)
        for (int y = 0; y < myConceptsArray.count; y++){
            [myGalileoData appendString:[NSString stringWithFormat:@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]]];
            NSLog(@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]);
        }
}



- (void)sendDatabyEmail {
    NSLog(@"at start of sendDatabyEmail");
    
    
    if (! [MFMailComposeViewController canSendMail] ) {
        NSLog(@"Cannot send email!!!");
        exit(1);
    } else {
        NSLog(@"CAN send email!!!");
        NSMutableString *myGalileoData = [[NSMutableString alloc] init];
        for (int x = 0 ; x < myConceptsArray.count ; x++)
            for (int y = 0; y < myConceptsArray.count; y++)
                [myGalileoData appendString:[NSString stringWithFormat:@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]]];
        MFMailComposeViewController *myMailViewController = [[MFMailComposeViewController alloc] init];
        [myMailViewController setMailComposeDelegate:self];
        [myMailViewController setMessageBody:myGalileoData isHTML:NO];
        [myMailViewController setSubject:[NSString stringWithFormat: @"Galileo Data from %@ Study",myStudyName]];
        [myMailViewController setToRecipients:myRecipientArray];
        [self presentViewController:myMailViewController animated:NO completion:nil];
        NSLog(@"at end of sendDatabyEmail");
    }
}



-(void)getURL{
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
        textField.text = myStudySite;
    }];
    
    [self presentViewController:myURLRequestController animated:YES completion:^(void) {
        NSLog(@"in getURL Completion Block");
    }];
}




@end
