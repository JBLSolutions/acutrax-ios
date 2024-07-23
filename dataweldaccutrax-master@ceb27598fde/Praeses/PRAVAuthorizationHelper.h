//
//  PRAVAuthorizationHelper.h
//
//  Created by Kshitij Limaye on 4/20/15.
//  Copyright (c) 2015 Praeses. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AccessGrantedAction)();

@interface PRAVAuthorizationHelper : NSObject

- (void)authorizeIfRequired:(AccessGrantedAction)action viaViewController:(UIViewController*)viewController;

@end
