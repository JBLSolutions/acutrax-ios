#import "CoreView.h"
#import "LineaSDK.h"
#import "ZBarSDK.h"
@interface tbl_CustomerList : CoreView<ZBarReaderDelegate,LineaDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UITableView *tblData;
    NSMutableArray *rawData;
    NSMutableArray *rawDataDisplay;
    IBOutlet UISearchBar *sbMain;
    NSTimer *searchTimer;
   	Linea* linea;
}

@property (nonatomic, strong) IBOutlet UITableView *tblData;
@property (nonatomic,strong) NSMutableArray *rawData;
@property (nonatomic,strong) NSMutableArray *rawDataDisplay;
@property (strong, nonatomic) IBOutlet UISearchBar *sbMain;
@property (nonatomic, strong) NSTimer *searchTimer;
@end
