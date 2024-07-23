//
//  VerifyTag.m
//  acutrax
//
//  Created by Johnathan Rossitter on 6/18/13.
//
//

#import "SPLAppDelegate.h"
#import "VerifyTag.h"
#import "ZBarSDK.h"
#import "LineaSDK.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "MyPicker.h"
#import "Linea+Connect.h"
#import "PRAVAuthorizationHelper.h"


@interface VerifyTag ()
@property (nonatomic, strong) PRAVAuthorizationHelper *cameraAuthHelper;
@end

@implementation VerifyTag

@synthesize btnScanBarcode;
@synthesize tbSerial;
@synthesize tbTankID;
@synthesize lblTankType;
@synthesize lbl_Description1;
@synthesize lbl_Description2;
@synthesize lbl_Description3;
@synthesize lbl_Description4;


int delegateModeVT;

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [linea disconnectMe:self];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [activityMain stopAnimating];
    linea=[Linea sharedDevice];
    [linea connectMe:self];    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Verify Tag";
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    [tbTankID becomeFirstResponder];
    self.cameraAuthHelper = [[PRAVAuthorizationHelper alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 100)
    {
        [self resolveTank];
        [textField selectAll:nil];
    }
    if(textField.tag == 200)
    {
        [self resolveTankBySerial];
        [textField selectAll:nil];
    }
    //[textField resignFirstResponder];
    return NO;
}

- (void)viewDidUnload {
    [self setTbSerial:nil];
    [self setTbTankID:nil];
    [super viewDidUnload];
}

- (void)onMainThreadSafeAction:(dispatch_block_t)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

-(void) resolveTank
{
    BOOL useLast = NO;
    BOOL copyIt =[[NSUserDefaults  standardUserDefaults] boolForKey:@"SaveTags"];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *tank = [myDelegate resolveTank:tbTankID.text];
    if([tank.Cylinder_Type isEqualToString:@"Item ID Not Recognized"])
    {
        
        if(copyIt == YES)
        {
            tbSerial.text = tbTankID.text;
        }

        
        if(myDelegate.lastCylinderType !=0)
        {
            useLast = YES;
            SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *myOrder = [myDelegate getCylinderTypeByPKID:myDelegate.lastCylinderType];
            
            [self onMainThreadSafeAction:^{
                lblTankType.text = myOrder.Cylinder_Type;
                self.lbl_Description1.text = myOrder.Description_1;
                self.lbl_Description2.text = myOrder.Description_2;
                self.lbl_Description3.text = myOrder.Description_3;
                self.lbl_Description4.text = myOrder.Description_4;
            }];
        }
        
    }
 
    if(useLast == NO)
    {
        NSLog(@"Cylinder Type: %@",tank.Cylinder_Type);
        NSLog(@"Cylinder Type ID: %i",tank.Cylinder_Type_ID);
        NSLog(@"Category: %@",tank.Category);
        NSLog(@"Hazard Class: %@",tank.Hazzard_Class);
        NSLog(@"UN_Number: %@",tank.UN_Number);
        NSLog(@"Proper_Name_1: %@",tank.Proper_Name_1);
        NSLog(@"Description_1: %@",tank.Description_1);
        NSLog(@"Serial_Number: %@",tank.Serial_Number);
        [self onMainThreadSafeAction:^{
            self.lblTankType.text = tank.Cylinder_Type;
            self.tbSerial.text = tank.Serial_Number;
            self.lbl_Description1.text = tank.Description_1;
            self.lbl_Description2.text = tank.Description_2;
            self.lbl_Description3.text = tank.Description_3;
            self.lbl_Description4.text = tank.Description_4;
        }];
    }
    [self onMainThreadSafeAction:^{
        [self.tbTankID becomeFirstResponder];
    }];
}

- (IBAction)btnScanBarcode_Touch:(id)sender
{
    [self.cameraAuthHelper authorizeIfRequired:^{
        delegateModeVT = 1;
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        //[self presentModalViewController: reader animated: YES];
        
        [self presentViewController: reader animated:YES completion:nil];
        
    } viaViewController:self];
}


//visual based barcode delegate
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(delegateModeVT == 1)
    {
        id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        self.tbTankID.text = symbol.data;
        [self resolveTank];
        //[reader dismissModalViewControllerAnimated: YES];
        [reader dismissViewControllerAnimated:YES completion:nil];
    }
    

}

-(void) resolveTankBySerial
{
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *tank = [myDelegate resolveTankBySerial:tbSerial.text];
    self.lbl_Description1.text = tank.Description_1;
    self.lbl_Description2.text = tank.Description_2;
    self.lbl_Description3.text = tank.Description_3;
    self.lbl_Description4.text = tank.Description_4;
    self.lblTankType.text = tank.Cylinder_Type;
    self.tbTankID.text = tank.TagID;

}

//laserbased barcode and magstrip
-(void)barcodeData:(NSString *)barcode type:(int)type
{
    self.tbTankID.text = barcode;
    [self resolveTank];
}



-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    self.tbTankID.text = track1;
    NSLog(@"...%@%@%@...", track1, track2, track3);
}


-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
			break;
		case CONN_CONNECTED:
            NSLog(@"");
            SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
            //            [linea setMSCardDataMode:MS_PROCESSED_CARD_DATA error:nil];
            //            [linea msStartScan];
            //            [linea stopScan];
            int beepData[]={100,100,2000,100,3000,100,4000,100,5000,100};
            
           // [linea msStopScan];
            //[linea startScan];
            
            [linea setScanButtonMode:BUTTON_ENABLED error:nil];
            if(myDelegate.playBeep == YES)
            {
                [linea setScanBeep:YES volume:5 beepData:beepData length:sizeof(beepData) error:nil];
            }
            else
            {
                [linea setScanBeep:NO volume:0 beepData:nil length:0 error:nil];
            }
            
            break;
	}
}
@end
