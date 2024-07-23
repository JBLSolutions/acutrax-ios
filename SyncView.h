//
//  SyncView.h
//  AcuTrax
//
//  Created by Johnathan Rossitter on 11/21/12.
//
//

#import "CoreView.h"
#import "SyncService.h"

@interface SyncView : CoreView
{
   IBOutlet UIButton *btnDownloadEverything;
   IBOutlet UIButton *btnDownloadAssetData;
   IBOutlet UIButton *btnDownloadCustomerData;
    IBOutlet UIButton *btnUploadOrders;
}

@property (strong, nonatomic) IBOutlet UIButton *btnDownloadEverything;
@property (strong, nonatomic) IBOutlet UIButton *btnDownloadAssetData;
@property (strong, nonatomic) IBOutlet UIButton *btnDownloadCustomerData;
@property (strong, nonatomic) IBOutlet UIButton *btnUploadOrders;

- (IBAction)btnDownloadAssets_Touch:(id)sender;
- (IBAction)btnDownloadCustomerData_Touch:(id)sender;
- (IBAction)btnUploadOrders_Touch:(id)sender;
- (IBAction)btnDownloadEverything_Touch:(id)sender;
@end
