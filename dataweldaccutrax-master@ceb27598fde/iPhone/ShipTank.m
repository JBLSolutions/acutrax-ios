//
//  ShipTank.m
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPLAppDelegate.h"
#import "ShipTank.h"
#import "ZBarSDK.h"
#import "LineaSDK.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "MyPicker.h"
#import "Linea+Connect.h"
#import "PRAVAuthorizationHelper.h"
@interface ShipTank()
@property (nonatomic, strong) PRAVAuthorizationHelper *cameraAuthHelper;
@end

@implementation ShipTank
@synthesize tbTankID;
@synthesize lblTankType;
@synthesize btnFinished;
@synthesize btnScanBarcode;
@synthesize tbSerial;
@synthesize btnSnapPhoto;
@synthesize imgPicker;
@synthesize imgPhoto;
@synthesize snappedPhoto;
@synthesize btnSave;
@synthesize lblEnterVolume;
@synthesize txtVolume;
@synthesize btnFindType;
@synthesize lblEnterSerial;
@synthesize lbl_Description1;
@synthesize lbl_Description2;
@synthesize lbl_Description3;
@synthesize lbl_Description4;
@synthesize lblSerial2;
@synthesize txtSerial2;
@synthesize txtCat;
@synthesize lblStats;
@synthesize lblSerial3;
@synthesize txtSerial3;
MyPicker *picker;
int delegateMode;
int n_formMode;
int selectedCustomerST;
int selectedOrderST;
int yesNoMode;
bool trackType = YES;
//char trackType;
NSString *poNameST;

#pragma textfield delegate
static NSInteger TANK_ID = 100;
static NSInteger SERIAL = 200;
static NSString *ITEM_TYPE_NOT_SET_TEXT = @"Item ID Not Recognized";

- (void)showAlertWithText:(NSString*)text {
    UIAlertController * message=   [UIAlertController
                                    alertControllerWithTitle:@"Alert"
                                    message:text
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* OkButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    [message addAction:OkButton];
    [self presentViewController:message animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == TANK_ID)
    {
        [textField resignFirstResponder];
        //[self showAlertWithText:@"from : textField should return. resolving tank NOW"];
        [self resolveTank];
        return NO;
    }
    if(textField.tag == SERIAL && txtSerial2.hidden == YES)
    {
        [textField resignFirstResponder];
        [self resolveTankBySerial];
        return NO;
    }
    if(textField.tag == 210){
        [textField resignFirstResponder];
        [self resolveCount];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range  replacementString:(NSString *)string {
    if ([self.txtSerial2 isFirstResponder] && txtSerial2.text.length > 0 ) {
        
        NSError *error;
        NSRegularExpression * regExp = [[NSRegularExpression alloc]initWithPattern:@"^\\d{0,10}(([.]\\d{1,4})|([.]))?$" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSString * existingText = txtSerial2.text;
        NSString * completeText = [existingText stringByAppendingFormat:@"%@",string];
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        if ([regExp numberOfMatchesInString:completeText options:0 range:NSMakeRange(0, [completeText length])])
        {
            if ([completeText isEqualToString:@"."])
                [textField insertText:@"0"];
            return YES;
        }
        else
            return NO;
        
    }
    return YES;
    
    
}
#pragma -

-(void)resetForm
{
    tbSerial.hidden = NO;
    lblEnterSerial.hidden = NO;
    btnSave.hidden = YES;
    lblTankType.text = @"";
    tbTankID.text =@"";
    tbSerial.text = @"";
    txtSerial2.text = @"";
    txtSerial2.hidden = YES;
    lblSerial2.hidden = YES;
    txtSerial3.hidden = YES;
    lblSerial3.hidden = YES;
    txtVolume.text =@"0";
    lbl_Description1.text = @"";
    lbl_Description2.text = @"";
    lbl_Description3.text = @"";
    lbl_Description4.text = @"";
    txtCat.text=@"";
    txtCat.hidden=YES;
    lblEnterVolume.hidden=YES;
    txtVolume.hidden=YES;
}

-(void) resolveCount
{

    
    if ( [txtSerial2.text length] != 0 ){
        txtVolume.text=txtSerial2.text;
    }
    
    
}

-(void) resolveTank
{
    BOOL useLast = NO;
    BOOL copyIt =[[NSUserDefaults  standardUserDefaults] boolForKey:@"SaveTags"];
     SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *tank = [myDelegate resolveTank:tbTankID.text];

    txtSerial3.autocorrectionType = UITextAutocorrectionTypeNo;
    BOOL autoSave = YES;
    if([tank.Cylinder_Type isEqualToString:ITEM_TYPE_NOT_SET_TEXT])
    {
        autoSave = NO;
        if(copyIt == YES)
        {
            tbSerial.text = tbTankID.text;
            txtSerial2.text = tbTankID.text;
        }
        btnSave.hidden = NO;
        btnFindType.hidden = NO;
        lblEnterVolume.hidden=YES;
        txtSerial3.hidden=NO;
        lblSerial3.hidden=NO;
        txtSerial3.text=@"";
        txtSerial2.hidden=YES;
        lblSerial2.hidden=YES;
        txtVolume.hidden=YES;
        //12-7-2016 -> commented based on feedback from Greg Renfro
//        SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *myOrder = [myDelegate getCylinderTypeByPKID:myDelegate.lastCylinderType];
//            if(myDelegate.lastCylinderType !=0 && myDelegate.lastCylinderType != myOrder.Cylinder_Type_ID)
//            {
//               useLast = YES;
//                tbSerial.text = [NSString stringWithFormat:@"%i",myDelegate.lastCylinderType];
//                tank = [myDelegate resolveTankByID:myDelegate.lastCylinderType];
//        
//                lblTankType.text = myOrder.Cylinder_Type;
//                NSLog(@"Cylinder Type: %@",lblTankType.text);
//                self.lbl_Description1.text = myOrder.Description_1;
//                self.lbl_Description2.text = myOrder.Description_2;
//                self.lbl_Description3.text = myOrder.Description_3;
//                self.lbl_Description4.text = myOrder.Description_4;
//            }
    }

    if(tank.Maintain_Volume == NO && tank.Track_Type == YES && !(tank.Category.length))
    {
        tbSerial.text = tank.Serial_Number;
        btnSave.hidden = NO;
        btnFindType.hidden = YES;
        txtSerial3.hidden=YES;
        lblSerial3.hidden=YES;
        lblEnterVolume.hidden=YES;
        txtVolume.hidden=YES;
    }

    if(tank.Maintain_Volume == YES && tank.Track_Type == YES && !(tank.Category.length))
    {
        autoSave = NO;
        lblEnterVolume.hidden = NO;
        txtVolume.hidden = NO;
        lblEnterVolume.text=@"VOLUME:";
        btnSave.hidden = NO;
        if(n_formMode != 1)
        {
            txtVolume.text = @"0";
        }
    }
    
    if(tank.Maintain_Volume == YES && tank.Track_Type == NO && !(tank.Category.length))
    {
        autoSave = NO;
        //its emedical
        lblSerial3.hidden=YES;
        txtSerial3.hidden=YES;
        lblSerial2.hidden=YES;
        txtSerial3.hidden=YES;
        lblEnterVolume.text=@"COUNT:";
        lblEnterVolume.hidden=NO;
        txtVolume.hidden=NO;
        btnSave.hidden = NO;
    }
    
    if(tank.Maintain_Volume == YES && tank.Track_Type == NO && [tank.Category isEqual: @"HG"])
    {
        autoSave = NO;
        txtSerial2.text = @"";
        lblSerial2.text=@"ORDERED: ";
        txtSerial3.hidden=YES;
        lblSerial3.hidden=YES;
        lblSerial2.hidden = NO;
        txtSerial2.hidden = NO;
        txtVolume.hidden = NO;
        lblEnterVolume.hidden = NO;
        btnSave.hidden=NO;

    }
    NSLog(@"Track Type = %d",tank.Track_Type);
    NSLog(@"Maintain Volume = %d",tank.Maintain_Volume);
    NSLog(@"Category = %@",tank.Category);
    
    if(useLast == NO)
    {
        self.lblTankType.text = tank.Cylinder_Type;
            if(copyIt == NO)
            {
                self.tbSerial.text = tank.Serial_Number;
            }
            else
            {
                if([tank.Cylinder_Type isEqualToString:ITEM_TYPE_NOT_SET_TEXT] == NO)
                {
                    self.tbSerial.text = tank.Serial_Number;
                    btnFindType.hidden=YES;
                }
                else
                {
                    self.tbSerial.text = self.tbTankID.text;
                    txtSerial2.text = self.tbTankID.text;
                }
            }
        self.lbl_Description1.text = tank.Description_1;
        self.lbl_Description2.text = tank.Description_2;
        self.lbl_Description3.text = tank.Description_3;
        self.lbl_Description4.text = tank.Description_4;
    }
    if (autoSave) {
        [self btnSave_Touch:nil];
    }
}

-(void) resolveTankBySerial
{
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *tank = [myDelegate resolveTankBySerial:tbSerial.text];
    txtSerial3.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if(tank.Maintain_Volume == NO && tank.Track_Type == YES)
    {
        tbSerial.text = tank.Serial_Number;
        lblTankType.text = tank.Cylinder_Type;
        btnSave.hidden = NO;
        btnFindType.hidden = YES;

    }
    
    if(tank.Maintain_Volume == YES && tank.Track_Type == YES)
    {
        lblEnterVolume.hidden = NO;
        txtVolume.hidden = NO;
        lblEnterVolume.text=@"VOLUME:";
        btnSave.hidden = NO;
        if(n_formMode != 1)
        {
            txtVolume.text = @"0";
        }
    }
    
    if(tank.Maintain_Volume == YES && tank.Track_Type == NO)
    {
        //its emedical
        lblSerial3.hidden=YES;
        txtSerial3.hidden=YES;
        lblEnterVolume.text=@"COUNT:";
        btnSave.hidden = NO;
    }
    
    if(tank.Maintain_Volume == YES && tank.Track_Type == NO && [tank.Category  isEqual: @"HG"])
    {
        txtSerial2.text = @"";
        lblSerial2.text=@"ORDERED: ";
        txtSerial3.hidden=YES;
        lblSerial3.hidden=YES;
        lblSerial2.hidden = NO;
        txtSerial2.hidden = NO;
        btnSave.hidden = NO;
    }
    
    self.lbl_Description1.text = tank.Description_1;
    self.lbl_Description2.text = tank.Description_2;
    self.lbl_Description3.text = tank.Description_3;
    self.lbl_Description4.text = tank.Description_4;
    self.lblTankType.text = tank.Cylinder_Type;
    NSLog(@"Tank Type: %@",self.lblTankType.text);
    self.tbTankID.text = tank.TagID;
    //self.tbSerial.text = tbTankID.text;
}

- (IBAction)btnFinished_Touched:(id)sender
{
    BOOL isDirty = NO;
    
//    NSLog(@"tank.Serial_Number = %@",tank.Serial_Number);

    if([self.tbTankID.text isEqualToString:@""])
    {
        
    }
    else
    {
        NSLog(@"There is item ID Data");
        isDirty = YES;
    }
    
    if([self.tbSerial.text isEqualToString:@""])
    {
        
    }
    else
    {
        NSLog(@"There is Item Serial Data");
        isDirty = YES;
    }

    if(isDirty == NO)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
//        yesNoMode = 1;
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"You have entered Data into this screen"
//                                                          message:@"Are you sure you want to leave this screen?"
//                                                         delegate:self
//                                                cancelButtonTitle:@"Yes"
//                                                otherButtonTitles:nil];
//        
//        [message addButtonWithTitle:@"No"];
//        
//
//        
//        [message show];

        UIAlertController * message=   [UIAlertController
                                      alertControllerWithTitle:@"You have entered Data into this screen"
                                      message:@"Are you sure you want to leave this screen?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* OkButton = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
/* Replaced commented out line (507) to new line (506). With this, case 1 in the switch statement in the deprecated method alertView:clickedButtonAtIndex (line 530) and the yesNoMode variable (line 481) have been commented out as there is no need for them here anymore */
                                       [self.navigationController popViewControllerAnimated:YES];
//                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        UIAlertAction* NoButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   /* Added UIAlertActionStyleCancel (line 513) which automatically dismisses alert, no handler necessary below */
                                   handler:nil];
        
        [message addAction:OkButton];
        [message addAction:NoButton];
        [self presentViewController:message animated:YES completion:nil];
        
        
        
        
    }
}

-(void)reAddScannedItem {
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOADVANCEDtbl_Customer_Result *customer = [myDelegate GetCustomer:selectedCustomerST];
    SQLSTUDIOADVANCEDtbl_Orders_Result  *order = [myDelegate GetOrder:selectedOrderST];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm:ss"];
    
    NSString *formMode =@"";
    if(n_formMode == 1) {
        formMode = @"CS";
    } else {
        formMode = @"DE";
    }
    
    NSString *formMode2 =@"";
    if(n_formMode == 1) {
        formMode2 = @"12";
    } else {
        formMode2 = @"13";
    }
    
    NSLog(@"Tank Type = %@",lblTankType.text);
    if (![myDelegate driverInitialsSet]) {
        [self showAlertWithText:@"Cannot add scanned item as no operator set. Please login."];
    }
    if ([lblTankType.text isEqualToString:ITEM_TYPE_NOT_SET_TEXT]) {
        [self showAlertWithText:@"Item Type has to be set"];
        return;
    }
    [myDelegate insertNewDeviceTransaction:
     [formatter stringFromDate:[NSDate date]]:
     [formatter2 stringFromDate:[NSDate date]]
//                                                      :customer.Account_Number
                                          :customer.Customer_ID
                                          :customer.Customer_Name
                                          :tbTankID.text
                                          :lblTankType.text
                                          :formMode
                                          :[myDelegate getDriverInitials]
                                          :order.Order_Number
                                          :formMode2
                                          :@""
                                          :txtVolume.text
                                          :tbSerial.text
                                          :order.PO_Number
                                          :txtSerial2.text
                                          :customer.Account_Number
     ];
    //[self.navigationController popViewControllerAnimated:YES];
    [self resetForm];
}

- (IBAction)btnSnapPhoto_Touch:(id)sender
{

    delegateMode =2;
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //[self presentModalViewController:self.imgPicker animated:YES];
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

- (IBAction)btnSave_Touch:(id)sender {
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL serialsmatch = YES;
    if ([[tbTankID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self showAlertWithText:@"Item ID has to be set"];
        return;
    }
    if([txtCat.text isEqualToString:@"HG"]) {
    } else {
        if(txtSerial3.hidden == NO) {
            if([txtSerial3.text isEqualToString:tbSerial.text] == NO) {
                serialsmatch = NO;
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirm Serial"
//                                                          message:@"The Serial Numbers you entered do not match."
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        
// 
//        
//        
//        
//        [message show];

            UIAlertController * message=   [UIAlertController
                                            alertControllerWithTitle:@"Confirm Serial"
                                            message:@"The Serial Numbers you entered do not match."
                                            preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* OkButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [message dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            
            [message addAction:OkButton];

            [self presentViewController:message animated:YES completion:nil];
        
        
        }

        if(!txtSerial3.text.length && !tbSerial.text.length)
        {
            serialsmatch = NO;
            UIAlertController * message=   [UIAlertController
                                            alertControllerWithTitle:@"Confirm Serial"
                                            message:@"There must be serials entered."
                                            preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* OkButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [message dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            
            [message addAction:OkButton];
            
            [self presentViewController:message animated:YES completion:nil];
        
        
        
        }
        
    }
    }

    if(serialsmatch == YES) {
        //save data
        SQLSTUDIOADVANCEDtbl_Customer_Result *customer = [myDelegate GetCustomer:selectedCustomerST];
        SQLSTUDIOADVANCEDtbl_Orders_Result  *order = [myDelegate GetOrder:selectedOrderST];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"HH:mm:ss"];
        
    //    btnSave.hidden=NO;
        
        NSString *formMode =@"";
        if(n_formMode == 1) {
            formMode = @"CS";
        } else {
            formMode = @"DE";
        }
        NSString *formMode2 =@"";
        if(n_formMode == 1) {
            formMode2 = @"12";
        } else {
            formMode2 = @"13";
        }
        BOOL exists = NO;
                    NSLog(@"Customer ID = %d",customer.Customer_ID);
        exists = [myDelegate CheckTagExistsInTransaction:tbTankID.text :order.Order_Number :customer.Customer_ID];
//        [self showAlertWithText:[NSString stringWithFormat:@"exists : %@, For Tag : %@ for order %@ under customer %@ %d",exists ? @"Yes" : @"No",tbTankID.text,order.Order_Number, customer.Customer_Name, customer.Customer_ID]];
        if(trackType == NO) {
            exists = NO;
        }
        if (![myDelegate driverInitialsSet]) {
            [self showAlertWithText:@"Cannot add scanned item as no operator set. Please login."];
            return;
        }
        if ([lblTankType.text isEqualToString:ITEM_TYPE_NOT_SET_TEXT]) {
            [self showAlertWithText:@"Item Type has to be set"];
            return;
        }
        if(exists == NO) {
            NSLog(@"Tank Type = %@",lblTankType.text);
                [myDelegate insertNewDeviceTransaction:
                 [formatter stringFromDate:[NSDate date]]:
                 [formatter2 stringFromDate:[NSDate date]]
                                                      :customer.Customer_ID
                                                      :customer.Customer_Name
                                                      :tbTankID.text
                                                      :lblTankType.text
                                                      :formMode
                                                      :[myDelegate getDriverInitials]
                                                      :order.Order_Number
                                                      :formMode2
                                                      :@""
                                                      :txtVolume.text
                                                      :tbSerial.text
                                                      :order.PO_Number
                                                      :txtSerial2.text
                                                      :customer.Account_Number
                 ];
            if(txtSerial3.hidden == NO)
            {
                [myDelegate addSingleTag:0 :myDelegate.lastCylinderType :0 :txtSerial3.text :self.tbTankID.text];
            }
            [self resetForm];
        }
        else {
            UIAlertController * message=   [UIAlertController
                                            alertControllerWithTitle:@"Item Exists"
                                            message:@"This item has already been scanned, are you sure you want to add it again?"
                                            preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* OkButton = [UIAlertAction
                                       actionWithTitle:@"Yes"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
    /* Moved the logic from case 2 in the commented out alertView:clickedButtonAtIndex method (no longer necessary) into it's own method (line 527) */
                                           [self reAddScannedItem];
                                       }];
            
            UIAlertAction* NoButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
    /* Added UIAlertActionStyleCancel (line 828) which automatically dismisses alert, no handler necessary below */
                                       handler:nil];
            
            [message addAction:OkButton];
            [message addAction:NoButton];
            dispatch_async(dispatch_get_main_queue(), ^{
               [self presentViewController:message animated:YES completion:nil];
            });
        }
    }
/* Since the code in reAddScannedItem is now being executed before "lblStats" is being executed below (line 872), as far as I can determine the label is now being updated properly. */
    int shipped = [myDelegate checkShippedAgainstTransactions:poNameST customerID:selectedCustomerST];
    int received = [myDelegate checkReceivedAgainstTransactions:poNameST  customerID:selectedCustomerST ];
//    exists = [myDelegate checkTagExistsInTransaction:tbTankID.text customerID:Customer_ID];
    self.lblStats.text =[NSString stringWithFormat:@"Total Shipped : %i Total Received : %i", shipped, received];
    
    dispatch_async(dispatch_get_main_queue(), ^{
           [self.tbTankID becomeFirstResponder];
    });
}

- (void)setupScreen:(SPLAppDelegate *)myDelegate
{
  if(n_formMode == 1)
        {
           
            
            if([myDelegate isCustomerVendor:selectedCustomerST] == YES)
            {
                self.title = @"Receive Item";
                [btnSave setTitle:@"Receive Item" forState:UIControlStateNormal];
                [btnSave setImage:[UIImage imageNamed:@"Ship300.png"] forState:UIControlStateNormal];
            }
            else
            {
               self.title = @"Ship Item";
                [btnSave setTitle:@"Ship Item" forState:UIControlStateNormal];
                [btnSave setImage:[UIImage imageNamed:@"Ship300.png"] forState:UIControlStateNormal];
                
            }
        }
        else
        {
            self.title = @"Return Item";
            [btnSave setTitle:@"Return Item" forState:UIControlStateNormal];
            [btnSave setImage:[UIImage imageNamed:@"Return300.png"] forState:UIControlStateNormal];            
        }
        
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES)
        {
            picker = [[MyPicker alloc] initWithNibName:@"MyPicker_iPad" bundle:nil];
        }
        else
        {
            picker = [[MyPicker alloc] initWithNibName:@"MyPicker" bundle:nil];
        }
        picker.delegate = self;

        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        lblEnterVolume.hidden = YES;
        txtVolume.hidden = YES;
        lblSerial2.hidden = YES;
        txtSerial2.hidden = YES;
        lblSerial3.hidden = YES;
        txtSerial3.hidden = YES;
        int shipped = [myDelegate checkShippedAgainstTransactions:poNameST customerID:selectedCustomerST];
        int received = [myDelegate checkReceivedAgainstTransactions:poNameST  customerID:selectedCustomerST];
        self.lblStats.text =[NSString stringWithFormat:@"Total Shipped : %i Total Received : %i", shipped, received];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil formMode:(int)Form_Mode customerID:(int)CustomerID orderID:(int)OrderID poName:(NSString*)PO_Name
{
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        selectedCustomerST = CustomerID;
        selectedOrderST = OrderID;
        poNameST = PO_Name;
        n_formMode = Form_Mode;
    }
    return self;
}

-(void)touchedOK:(MyPicker *)controller
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *myOrder = picker.selectedCylinder;
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.lastCylinderType = myOrder.Cylinder_Type_ID;
    NSLog(@"Cylinder Type: %@",myOrder.Cylinder_Type);
    NSLog(@"Cylinder Type ID: %d",myOrder.Cylinder_Type_ID);
    NSLog(@"Track Type: %d",myOrder.Track_Type);
    NSLog(@"Raw Data: %@",picker.rawData);
//    NSLog(@"Cylinder Type: %@",myOrder.Cylinder_Type);
    lblTankType.text = myOrder.Cylinder_Type;
    NSLog(@"Tank Type: %@",lblTankType.text);
    self.lbl_Description1.text = myOrder.Description_1;
    self.lbl_Description2.text = myOrder.Description_2;
    self.lbl_Description3.text = myOrder.Description_3;
    self.lbl_Description4.text = myOrder.Description_4;
    //tbSerial.hidden = YES;
    //lblEnterSerial.hidden = YES;
    lblSerial3.hidden = NO;
    txtSerial3.hidden = NO;
    lblSerial2.hidden = YES;
    txtSerial2.hidden = YES;
    
    if(myOrder.Maintain_Volume == YES)
    {
        lblEnterVolume.hidden = NO;
        txtVolume.hidden = NO;
    }
    else
    {
        lblEnterVolume.hidden = YES;
        txtVolume.hidden = YES;
    }
    btnSave.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
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

- (void)dismissKeyboard {
    [tbTankID resignFirstResponder];
    [tbSerial resignFirstResponder];
    [txtSerial2 resignFirstResponder];
    [txtSerial3 resignFirstResponder];
    [txtVolume resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cameraAuthHelper = [[PRAVAuthorizationHelper alloc] init];
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate addGradient:btnFinished];
    [myDelegate addGradient:btnSave];
    [myDelegate addGradient:btnScanBarcode];
    [myDelegate addGradient:btnSnapPhoto];
    [myDelegate addGradient:btnFindType];
    [self setupScreen:myDelegate];
    btnSave.hidden=YES;
    [tbTankID becomeFirstResponder];
}

- (void)viewDidUnload
{

    [self setTbTankID:nil];
    [self setLblTankType:nil];
    [self setLblTankType:nil];
    [self setBtnFinished:nil];
    [self setBtnScanBarcode:nil];
    [self setTbSerial:nil];
    [self setBtnSnapPhoto:nil];
    [self setImgPicker:nil];
    [self setImgPhoto:nil];
    [self setSnappedPhoto:nil];
    [self setBtnSave:nil];
    [self setLblEnterVolume:nil];
    [self setTxtVolume:nil];
    [self setBtnFindType:nil];

    [self setLblEnterSerial:nil];
    [self setLbl_Description1:nil];
    [self setLbl_Description2:nil];
    [self setLbl_Description3:nil];
    [self setLbl_Description4:nil];
    [self setLblSerial2:nil];
    [self setTxtSerial2:nil];
    [self setLblStats:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnScanBarcode_Touch:(id)sender 
{
    [self.cameraAuthHelper authorizeIfRequired:^{
        delegateMode = 1;
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
    
    if(delegateMode == 1)
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
    
    
    if(delegateMode == 2)
    {        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        [activityMain startAnimating];
        //[reader dismissModalViewControllerAnimated: YES];
        [reader dismissViewControllerAnimated:YES completion:nil];
        
        snappedPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        [imgPhoto setImage:snappedPhoto];
        
        UIImage *snappedSmall = [myDelegate scaleMe:snappedPhoto toSize:CGSizeMake(640, 960)];
   
        

        NSData* imageData = UIImageJPEGRepresentation(snappedSmall, 1.0);//  UIImagePNGRepresentation(snappedSmall);
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
        [imageData writeToFile:[NSString stringWithFormat:@"%@/cylinder%@_%@_%@_%@_%i_%@.jpg",imagePath,[myDelegate stringFromDate:[NSDate date]],[NSString stringWithFormat:@"%i",myDelegate.userID],[[NSNumber numberWithDouble:[myDelegate GetLat]] stringValue],[[NSNumber numberWithDouble:[myDelegate GetLong]] stringValue], selectedOrderST,self.tbSerial.text] atomically:NO];
        NSURL *myURL = [[NSURL alloc] initFileURLWithPath:imagePath];
        [self addSkipBackupAttributeToItemAtURL:myURL ];
        
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
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

            //[linea msStopScan];
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
- (IBAction)btnFindType_Touch:(id)sender
{

    
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif

        if(iPad == YES)
        {
//            picker.view.frame = CGRectMake(-114, -120, 768, 1024);
            picker.view.frame = CGRectMake(0,0, 768, 1024);
        }
        else
        {
            picker.view.frame = CGRectMake(0, 20, 90, 480);
        }

}
@end
