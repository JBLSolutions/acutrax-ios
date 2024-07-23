//
//  LoginView.m
//  Accidents
//
//  Created by Johnathan Rossitter on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"
#import "SPLAppDelegate.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "Linea+Connect.h"


@implementation LoginView;
@synthesize btnLogin;
@synthesize lblSwipeCard;
@synthesize btnCancel;
@synthesize txtUser;
@synthesize txtPassword;
@synthesize delegate;

int loginMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //NSLog(@"initWithNibName: %@ bundle: %@",nibNameOrNil,nibBundleOrNil);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {

    }
    return self;
}


-(void)viewDidDisappear:(BOOL)animated  
{
    [super viewDidDisappear:animated];
    [linea disconnectMe:self];
}

-(void) viewDidAppear:(BOOL)animated    
{
    [super viewDidAppear:animated];
    [activityMain stopAnimating];
    lblSwipeCard.hidden = YES;
    linea=[Linea sharedDevice];
    [linea connectMe:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    txtUser.text=@"";
    txtPassword.text=@"";

}



- (void)viewDidUnload
{
    [self setTxtUser:nil];
    [self setTxtPassword:nil];
    [self setBtnLogin:nil];
    [self setLblSwipeCard:nil];
    [self setBtnCancel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3 
{
    [activityMain startAnimating];
    loginMode = 1;
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;
    [service Driver_Login_By_DL:self action:@selector(handleList:) DL_Tracks:[NSString stringWithFormat:@"%@%@%@", track1, track2, track3] Device_ID:myDelegate.myDeviceToken];
}




-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
            break;
		case CONN_CONNECTING:
			break;
		case CONN_CONNECTED:
            lblSwipeCard.hidden = NO;
            SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
            [linea setMSCardDataMode:MS_PROCESSED_CARD_DATA error:nil];
          //  [linea msStartScan];
            //[linea stopScan];
            [linea setScanButtonMode:BUTTON_DISABLED error:nil];
            [linea setScanBeep:myDelegate.playBeep volume:0 beepData:nil length:0 error:nil];
            break;
	}
}



//button handlers
- (IBAction)btnLogin_Touch:(id)sender 
{
    [activityMain startAnimating];
    loginMode = 2;
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    

    
    if(txtUser.text.length > 0 && txtPassword.text.length > 0)
    {
        SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
        service.logging = NO;
        NSString *theID = @"";
        if(myDelegate.myDeviceToken == nil)
        {
            theID = @"";
        }
        else
        {
            theID = myDelegate.myDeviceToken;
//            NSLog(@"myDeviceToken: %@",theID);
        }
        NSLog(@"user: %@ pass: %@ device: %@",txtUser.text,txtPassword.text,theID);
//        txtUser.text=@"DSB999";
//        txtPassword.text=@"DSB999";
        [service Driver_Login:self action:@selector(handleList:) User_Name:txtUser.text Password:txtPassword.text Device_ID:theID];
    }
    else
    {
            [activityMain stopAnimating];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Email Address and Password are Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
//        [alert show];

    
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Login"
                                      message:@"Email Address and Password are Required"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* CancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        
        [alert addAction:CancelButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    
    
    }
    
    NSLog(@"end of btnLogin_Touch");
    
    [txtUser resignFirstResponder];
    [txtPassword resignFirstResponder];
}

- (IBAction)btnCancel_Touch:(id)sender
{
            [delegate touchedOK:self];
    [linea disconnect];
}


//soap handlers
-(void)handleList:(id)result
{
    NSLog(@"in handleList");
    [activityMain stopAnimating];

    if([result isKindOfClass:[NSError class]]) 
    {
        NSError *MyError = (NSError*) result;
        if(MyError.code == 410)
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network" message:@"Your Network Connection is not Present" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
//            [alert show];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Network"
                                          message:@"Your Network Connection is not Present"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* CancelButton = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
            
            [alert addAction:CancelButton];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
		return;
	}
    SQLSTUDIOADVANCEDLogin_Token *myToken = (SQLSTUDIOADVANCEDLogin_Token*)result;
    SPLAppDelegate *mydelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate]; 
    if(myToken.Driver_ID !=0)
    {
        mydelegate.userID = myToken.Driver_ID;
        mydelegate.driverFirstName = myToken.Driver_First_Name;
        mydelegate.driverLastName = myToken.Driver_Last_Name;
        [mydelegate setDriverInitials:self.txtUser.text];
        [[NSUserDefaults standardUserDefaults] setInteger:myToken.Driver_ID forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setObject:myToken.Driver_First_Name forKey:@"Driver_First_Name"];
        [[NSUserDefaults standardUserDefaults] setObject:myToken.Driver_Last_Name forKey:@"Driver_Last_Name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [delegate touchedOK:self];
        [linea disconnect];
        self.txtUser.text =@"";
        self.txtPassword.text =@"";
        
        NSString *DeviceID = [[NSUserDefaults standardUserDefaults] stringForKey    :@"deviceToken"];
        if(DeviceID.length >0)
        {
        SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
        service.logging = YES;
            //[service EnrollPushNotifications:self action:nil Driver_ID:myToken.Driver_ID Device:DeviceID];
        }
    }
    else
    {
        mydelegate.userID = 0;
        NSString *errorMsg;
        if(loginMode == 1)
        {
            errorMsg = @"Driver Not Found, please try again.";
        }
        else
        {
            errorMsg = @"User Name or Password is Incorrect, please try again.";
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
//        [alert show];

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Login"
                                      message:errorMsg
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* OkButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        
        [alert addAction:OkButton];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        self.txtPassword.text = @"";
    }
}

@end
