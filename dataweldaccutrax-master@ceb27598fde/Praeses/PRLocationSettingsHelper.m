//
//  PRLocationSettingsHelper.m
//  acutrax
//
//  Created by Kshitij S. Limaye on 4/10/17.
//
//

#import "PRLocationSettingsHelper.h"

@implementation PRLocationSettingsHelper

+ (void)showSettingsDialogIn:(UIViewController*)viewController {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Location Access Disabled" message:@"In order to show you customer locations relative to where you currently are, we need access to your current location. Please open Settings and grant location access to this app." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //settings can be opened only in iOs 8 and above.
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsUrl];
    }];
    [alertVC addAction:openAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

@end
