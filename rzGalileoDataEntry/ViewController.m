//
//  ViewController.m
//  rzGalileoDataEntry
//
//  Created by Robert Zimmelman on 12/4/15.
//  Copyright © 2015 Robert Zimmelman. All rights reserved.
//


int concept1number = 0;
int concept2number = 0;

int previousconcept1number = 0;
int previousconcept2number = 0;


int myConceptCount = 0;

float myDisplayValue = 0;
float myDistances[100][100];

#import "ViewController.h"



@implementation ViewController

@synthesize myConceptsArray;
@synthesize myRecipientsArray;

@synthesize myConcept1;
@synthesize myConcept2;

@synthesize mySliderValue;

@synthesize myReferenceConcepts;
@synthesize myStudyName;
@synthesize myStudyFile;
@synthesize myStudyTitleLabel;
@synthesize myDefaultURLString;
@synthesize myStudyURL;


-(void)viewWillAppear:(BOOL)animated{
    
    
    
}


-(void)getURL{
    UIAlertController *myURLRequestController = [UIAlertController alertControllerWithTitle:@"Enter URL" message:@"Enter URL with Study Email, Title and Concepts" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [myURLRequestController addAction:defaultAction];
    
    [myURLRequestController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = myDefaultURLString;
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [self presentViewController:myURLRequestController animated:YES completion:nil];

}


- (void)viewDidAppear:(BOOL)animated{
    [self getURL];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    


//    UIAlertView *myURLRequest = [[UIAlertView alloc] initWithTitle:@"Enter URL" message:@"Enter URL Here" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Galileo Viewer", @"URL Preview",nil];
    
    myDefaultURLString = @"http://www.acsu.buffalo.edu/~woelfel/DATA/data.crd.txt";
    

    
    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                                                   message:@"This is an alert."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
    
    NSStringEncoding encoding;
    NSError *myError = nil;
    myStudyFile = @"rztest";
    NSString *myStudySite = [NSString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/%@.txt",myStudyFile];
    //
    //
    //  rz set myDefaultURLString and we can use it to read the study data
    //
    myDefaultURLString = [NSString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/%@.txt",myStudyFile];
    
    //
    //
    //
    myStudyURL = [NSURL URLWithString:myStudySite];
    //
    //
    //
    //  now we're going out to the web to get the data from the URL
    //
    NSString *myStudyString = [[NSString alloc] initWithContentsOfURL:myStudyURL
                                                            usedEncoding:&encoding
                                                                   error:&myError];
    NSMutableArray *myTempArray = [NSMutableArray arrayWithObjects:[myStudyString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]], nil];
    //
    // rz first assign the email address to the first line in the file
    //
    myRecipientsArray = [NSArray arrayWithObject:[[myTempArray objectAtIndex:0] objectAtIndex:0]];
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
    
    if (myConceptsArray == nil) {
        [self showURLError];
    }
    
    
//    myRecipientsArray = [NSArray arrayWithObjects:@"zimmelman@gmail.com", nil];
    
    //    myConceptsArray = [NSArray arrayWithObjects:@"Love", @"Hate", @"Happiness", @"Sadness", @"Indifference", @"Anger",   @"Yourself", nil];
//        myConceptsArray = [NSArray arrayWithObjects:@"Love", @"Hate", @"Yourself", nil];
    myConceptCount = myConceptsArray.count - 1.0;
    
    for (int i = 0 ; i <= myConceptCount ; i++) {
        for (int j = 0; j <= myConceptCount; j++) {
            myDistances[i][j] = -1.0;
        }
    }
    
    // rz set up the reference concepts label
    // using the first two concepts in the study at 100 units apart
    //
    //
    self.myConcept1.text = [myConceptsArray objectAtIndex:concept1number];
    self.myConcept2.text = [NSString stringWithFormat:@"%@ ?",[myConceptsArray objectAtIndex:concept2number]];
    [myReferenceConcepts setText:[NSString stringWithFormat:@"%@ and %@",  [myConceptsArray objectAtIndex:0] , [myConceptsArray objectAtIndex:1]   ]];
    
    
    
    UISwipeGestureRecognizer *myRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightSwipeAction)];
    [myRightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:myRightSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *myLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftSwipeAction)];
    [myLeftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:myLeftSwipeGestureRecognizer];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showURLError{
    NSError *myError;
    NSLog(@"Error reading file %@",
          [myError localizedFailureReason]);
    UIAlertController  *myLoadErrorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Error = %@",myError.localizedFailureReason] preferredStyle:UIAlertControllerStyleAlert];
    [self.parentViewController presentViewController:myLoadErrorAlert animated:YES completion:nil];
    
}




-(void)myRightSwipeAction{
    [self myOK:self];
}

-(void)myLeftSwipeAction{
    concept1number = previousconcept1number;
    concept2number = previousconcept2number;
    self.myConcept1.text = [myConceptsArray objectAtIndex:concept1number];
    self.myConcept2.text = [NSString stringWithFormat:@"%@ ?",[myConceptsArray objectAtIndex:concept2number]];
}



-(void)myNextConcepts{
    previousconcept1number = concept1number;
    previousconcept2number = concept2number;
    
    if (concept1number < (myConceptCount)) {  // concept1 needs to be held
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

- (IBAction)myLittleSliderMove:(UISlider *)sender {
    myDisplayValue = sender.value;
    NSString *myNumber = [NSString stringWithFormat:@"%f",myDisplayValue];
    self.mySliderValue.text = myNumber;
}


-(void)myEnterTheValue{
    myDistances[concept1number][concept2number] = myDisplayValue;
}


- (IBAction)myOK:(id)sender {
    [self myEnterTheValue];
    if (concept1number == myConceptCount && concept2number == myConceptCount){
        [self LogTheItemsintheArray];
        [self sendDatabyEmail];
        //        [self sendDatabySMS];
        //        exit(0);
    }
    [self myNextConcepts];
}

- (IBAction)myExit:(id)sender {
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"EXIT ???" message:@"Wewill now send your data to the study leader via email.  Are you sure you are ready to Exit?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self sendDatabyEmail];
                                                          }];
    [myAlert addAction:defaultAction];
    
    [self presentViewController:myAlert animated:YES completion:nil];
}


//- (void)sendDatabySMS  {
//    NSLog(@"at start of sendDatabySMS");
//    if(![MFMessageComposeViewController canSendText]) {
//        NSLog(@"CAN NOT SEND SMS");
//        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your device does not support SMS" preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:myAlert animated:YES completion:nil];
//        return;
//    }
//    
//    NSMutableString *myGalileoData = [[NSMutableString alloc] init];
//    for (int x = 0 ; x < myConceptsArray.count ; x++)
//        for (int y = 0; y < myConceptsArray.count; y++)
//            [myGalileoData appendString:[NSString stringWithFormat:@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]]];
//    MFMessageComposeViewController *mySMSViewController = [[MFMessageComposeViewController alloc] init];
//    [mySMSViewController setMessageComposeDelegate:self];
//    [mySMSViewController setBody:myGalileoData];
//    [mySMSViewController setSubject:@"Galileo Data from XXX Study"];
//    [mySMSViewController setRecipients:myRecipientsArray];
//    [self presentViewController:mySMSViewController animated:NO completion:nil];
//    NSLog(@"at end of sendDatabySMS");
//}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    exit(0);
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your device does not support SMS" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:myAlert animated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)sendDatabyEmail {
    NSLog(@"at start of sendDatabyEmail");
    NSMutableString *myGalileoData = [[NSMutableString alloc] init];
    for (int x = 0 ; x < myConceptsArray.count ; x++)
        for (int y = 0; y < myConceptsArray.count; y++)
            [myGalileoData appendString:[NSString stringWithFormat:@"%@,%@,%f;",myConceptsArray[x],myConceptsArray[y], myDistances[x][y]]];
    if (! [MFMailComposeViewController canSendMail] ) {
        NSLog(@"Cannot send email!!!");
        exit(1);
    }
    MFMailComposeViewController *myMailViewController = [[MFMailComposeViewController alloc] init];
    [myMailViewController setMailComposeDelegate:self];
    [myMailViewController setMessageBody:myGalileoData isHTML:NO];
    [myMailViewController setSubject:[NSString stringWithFormat: @"Galileo Data from %@ Study",myStudyName]];
    [myMailViewController setToRecipients:myRecipientsArray];
    [self presentViewController:myMailViewController animated:NO completion:nil];
    NSLog(@"at end of sendDatabyEmail");
}





@end
