#import "CoreView.h"
#import "Reachability.h"
#import "SPLAppDelegate.h"
@implementation CoreView

@synthesize coreNavigationController;
@synthesize activityMain;
@synthesize lblNetworkStatus;
@synthesize internetReachable;
@synthesize hostReachable;
@synthesize networkStatus;
@synthesize myHostStatus;
@synthesize internetActive;
@synthesize hostActive;
@synthesize domainName;

NSString *domainName;
NSTimer *timer;
-(void)updateTime
{
    if([[SyncService getSyncService] isSyncing] == YES)
    {
        [activityMain startAnimating];
    }
    else
    {
        [activityMain stopAnimating];
    }
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (void)Gumball
{
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    UIImage *background;
    
//    if(iPad == YES)
//    {
//        background = [UIImage imageNamed: @"blank.png"];
//    }
//    else
//    {
//        background = [UIImage imageNamed: @"blank.png"];  
//    }   
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage: background]; 
//    if(iPad == YES)
//    {
//        imageView.frame = CGRectMake(0, -20, 798, 1054);
//    }
//    else
//    {
//        imageView.frame = CGRectMake(0, -10, 335, 568);
//    } 
//    
//    [self.view insertSubview:imageView atIndex:0];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        [self Gumball];
    }
    return self;
    
}
-(void)viewDidAppear:(BOOL)animated
{
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [super viewDidAppear:animated];
//    BOOL iPad = NO;
//#ifdef UI_USER_INTERFACE_IDIOM
//    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
//#endif
//    if(iPad == YES)
//    {
//        [lblNetworkStatus setFrame:CGRectMake(0, 950, 768, 21)];
//    }
//    else
//    {
//        if(screenBounds.size.height == 568)
//        {
//            [lblNetworkStatus setFrame:CGRectMake(0, 500, 320, 21)];
//        }
//        else
//        {
//        [lblNetworkStatus setFrame:CGRectMake(0, 410, 320, 21)];
//        }
//
//    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        [self Gumball];    
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    domainName = @"iphone.g1c.net";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    hostReachable = [Reachability reachabilityWithHostName: domainName];
    [hostReachable startNotifier];
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            networkStatus = @"Not Connected";
            self.internetActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            networkStatus = @"WIFI";
            self.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            networkStatus = @"3G";
            self.internetActive = YES;
            
            break;
            
        }
            
    }
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            myHostStatus = @"Server Offline";
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            myHostStatus = @"Online";
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            myHostStatus = @"Online";
            self.hostActive = YES;
            
            break;
            
        }
    }
    lblNetworkStatus.text = [NSString stringWithFormat:@"%@%@%@%@",@"Network Status : ",networkStatus, @" Server Status : ", myHostStatus];
    [self updateTime];
}


//Network Detection
- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            networkStatus = @"Not Connected";
            self.internetActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            networkStatus = @"WIFI";
            self.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            networkStatus = @"3G";
            self.internetActive = YES;
            
            break;
            
        }
            
    }
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            myHostStatus = @"Server Offline";
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            myHostStatus = @"Online";
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            myHostStatus = @"Online";
            self.hostActive = YES;
            
            break;
            
        }
    }
    lblNetworkStatus.text = [NSString stringWithFormat:@"%@%@%@%@",@"Network Status : ",networkStatus, @" Server Status : ", myHostStatus];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    activityMain = nil;
    lblNetworkStatus = nil;
    [self setInternetActive:NO];
    [self setHostActive:NO];
    [self setNetworkStatus:nil];
    [self setMyHostStatus:nil];
    [self setDomainName:nil];
    [self setInternetReachable:nil];
    [self setHostReachable:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  YES;
}

@end
