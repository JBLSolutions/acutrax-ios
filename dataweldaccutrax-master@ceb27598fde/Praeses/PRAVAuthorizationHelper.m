//
//  PRAVAuthorizationHelper.m
//
//  Created by Kshitij Limaye on 4/20/15.
//  Copyright (c) 2015 Praeses. All rights reserved.
//

#import "PRAVAuthorizationHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation PRAVAuthorizationHelper

- (void)showSettingsDialog:(UIViewController*)viewController {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Camera Access Disabled" message:@"In order to scan a barcode we need access to the camera. Please open Settings and grant camera access to this app." preferredStyle:UIAlertControllerStyleAlert];
    
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


- (void)authorizeIfRequired:(AccessGrantedAction)action viaViewController:(UIViewController *)viewController {
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (cameraStatus == AVAuthorizationStatusAuthorized) {
        action();
    }
    else if (cameraStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    action();
                });
            }
        }];
    }
    else {
        [self showSettingsDialog:viewController];
    }
}


@end
