//
//  ShipTank.h
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreView.h"
#import "ZBarSDK.h"
#import "LineaSDK.h"
#import "MyPicker.h"
@interface ShipTank : CoreView<ZBarReaderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LineaDelegate,UIAlertViewDelegate,MyPickerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *tbTankID;
    IBOutlet UILabel *lblTankType;
    IBOutlet UIButton *btnFinished;
    IBOutlet UIButton *btnScanBarcode;
    IBOutlet UITextField *tbSerial;
    IBOutlet UIButton *btnSnapPhoto;
    UIImagePickerController *imgPicker;
   	Linea* linea;
    IBOutlet UIImageView *imgPhoto;
    UIImage *snappedPhoto;
    IBOutlet UIButton *btnSave;
    IBOutlet UILabel *lblEnterVolume;
    IBOutlet UITextField *txtVolume;
    IBOutlet UILabel *lblEnterSerial;
    IBOutlet UITextField *txtSerial2;
    IBOutlet UILabel *lblSerial2;
    IBOutlet UILabel *lblStats;
    IBOutlet UITextField *txtCat;
    IBOutlet UILabel *lblSerial3;
    IBOutlet UITextField *txtSerial3;

}


@property (strong, nonatomic) IBOutlet UILabel *lblStats;
@property (strong, nonatomic) IBOutlet UITextField *txtSerial2;
@property (strong, nonatomic) IBOutlet UILabel *lblSerial2;
- (IBAction)btnFindType_Touch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFindType;
@property (strong, nonatomic) IBOutlet UILabel *lblEnterVolume;
@property (strong, nonatomic) IBOutlet UITextField *txtVolume;
@property (strong, nonatomic) IBOutlet UITextField *txtCat;
@property (strong, nonatomic) IBOutlet UILabel *lblEnterSerial;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description1;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Description2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description4;

@property (strong, nonatomic) IBOutlet UITextField *txtSerial3;
@property (strong, nonatomic) IBOutlet UILabel *lblSerial3;
@property (strong, nonatomic) IBOutlet UITextField *tbTankID;
@property (strong, nonatomic) IBOutlet UILabel *lblTankType;
@property (strong, nonatomic) IBOutlet UIButton *btnFinished;
@property (strong, nonatomic) IBOutlet UIButton *btnScanBarcode;
@property (strong, nonatomic) IBOutlet UITextField *tbSerial;
@property (strong, nonatomic) IBOutlet UIButton *btnSnapPhoto;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, strong) UIImage *snappedPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)btnScanBarcode_Touch:(id)sender;
- (IBAction)btnFinished_Touched:(id)sender;
- (IBAction)btnSnapPhoto_Touch:(id)sender;
- (IBAction)btnSave_Touch:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil formMode:(int)Form_Mode customerID:(int)CustomerID orderID:(int)OrderID  poName:(NSString*)PO_Name;
@end
