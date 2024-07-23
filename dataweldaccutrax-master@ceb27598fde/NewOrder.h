//
//  NewOrder.h
//  AcuTrax
//
//  Created by Johnathan Rossitter on 11/21/12.
//
//

#import "CoreView.h"
#import "ZBarSDK.h"
#import "LineaSDK.h"
@interface NewOrder : CoreView<ZBarReaderDelegate, UIImagePickerControllerDelegate, LineaDelegate>
{
    IBOutlet UITextField *txtOrderNumber;
    IBOutlet UITextField *txtPO;
    IBOutlet UIButton *btnCreateOrder;
    Linea* linea;
}

@property (strong, nonatomic) IBOutlet UITextField *txtOrderNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtPO;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnSnapPhoto;
@property (nonatomic, strong) UIImagePickerController *imgPicker;

- (IBAction)btnCreateOrder_Touch:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Customer_ID:(int)Customer_ID;

- (IBAction)btnScanBarcode_Touch:(id)sender;
//- (IBAction)btnSnapPhoto_Touch:(id)sender;
@end
