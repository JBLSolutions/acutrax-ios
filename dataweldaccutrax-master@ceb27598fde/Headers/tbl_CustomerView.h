#import "CoreView.h"
#import "MyPicker.h"

@interface tbl_CustomerView : CoreView<MyPickerDelegate>
{
     NSMutableArray *rawData;
       MyPicker *myPicker;
}
- (IBAction)btnPhone_Touch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
- (IBAction)btnDirections_Touch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnDirections;
@property (strong, nonatomic) IBOutlet UITableView *tblData;
@property (nonatomic,strong) NSMutableArray *rawData;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) MyPicker *myPicker;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer_ID;
@property (strong, nonatomic) IBOutlet UITextField *txtAccount_Number;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer_Name;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer_Address;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer_Address_2;
@property (strong, nonatomic) IBOutlet UITextField *txtCityState;
@property (strong, nonatomic) IBOutlet UITextField *txtZip;
@property (strong, nonatomic) IBOutlet UITextField *txtZip_4;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtCode;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtCompany_Letter;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtLongitude;
@property (strong, nonatomic) IBOutlet UITextField *txtLatitude;
@property (strong, nonatomic) IBOutlet UITextField *txtssImage_Logo;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress3;


@property (strong, nonatomic) IBOutlet UILabel *lblAccount;
@property (strong, nonatomic) IBOutlet UITextView *tbPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imhLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnOrders;
- (IBAction)btnOrders_Touch:(id)sender;

- (IBAction)btnMap_Touch:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Customer_ID:(int)Customer_ID;
- (IBAction)btnSave_Touch:(id)sender;




@end
