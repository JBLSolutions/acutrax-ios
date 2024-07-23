@class Reachability;
#import <UIKit/UIKit.h>

@interface CoreView : UIViewController
{
UINavigationController *coreNavigationController;
    IBOutlet UIActivityIndicatorView *activityMain;
    IBOutlet UILabel *lblNetworkStatus;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSString *networkStatus;
    NSString *myHostStatus;
    BOOL internetActive;
    BOOL hostActive;
    NSString *domainName;

}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityMain;
@property (nonatomic,strong)     UINavigationController *coreNavigationController;
@property (nonatomic, strong) NSString *domainName;
@property (nonatomic, strong) IBOutlet UILabel *lblNetworkStatus;
@property (nonatomic, strong) Reachability* internetReachable;
@property (nonatomic, strong) Reachability* hostReachable;
@property (nonatomic, strong) NSString *networkStatus;
@property (nonatomic, strong) NSString *myHostStatus;
@property BOOL internetActive;
@property BOOL hostActive;

- (void) checkNetworkStatus:(NSNotification *)notice;
- (void)Gumball;

@end
