#import "CoreView.h"
#import "LoginView.h"
@interface HomeView : CoreView<LoginViewDelegate>
{
    IBOutlet UIButton *btnTodaysStops;
    IBOutlet UIButton *btnCustomerList;
    IBOutlet UIProgressView *pvSync;
}
@property (strong, nonatomic) IBOutlet UIButton *btnTodaysStops;
@property (strong, nonatomic) IBOutlet UIButton *btnCustomerList;

- (IBAction)btnCustomerList_Touch:(id)sender;
- (IBAction)btnTodaysStops_Touch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnDownloadOrders;
- (IBAction)btnDownloadOrders_Touch:(id)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UIButton *btnVerifyTag;
- (IBAction)btnVerifyTag_Touch:(id)sender;
@end
