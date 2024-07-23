//
//  VerifyTag.h
//  acutrax
//
//  Created by Johnathan Rossitter on 6/18/13.
//
//

#import <UIKit/UIKit.h>
#import "CoreView.h"
#import "ZBarSDK.h"
#import "LineaSDK.h"
#import "MyPicker.h"

@interface VerifyTag : CoreView<ZBarReaderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LineaDelegate,UIAlertViewDelegate>
{
  	Linea* linea;
    IBOutlet UIButton *btnScanBarcode;
    IBOutlet UILabel *lbl_Description1;
    IBOutlet UILabel *lbl_Description2;
    IBOutlet UILabel *lbl_Description3;
    IBOutlet UILabel *lbl_Description4;
    IBOutlet UILabel *lblTankType;
}
@property (strong, nonatomic) IBOutlet UITextField *tbTankID;
@property (strong, nonatomic) IBOutlet UITextField *tbSerial;
@property (strong, nonatomic) IBOutlet UIButton *btnScanBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblTankType;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Description4;
- (IBAction)btnScanBarcode_Touch:(id)sender;
@end
