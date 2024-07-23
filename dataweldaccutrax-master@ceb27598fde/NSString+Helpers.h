//
//  NSString+Helpers.h
//  acutrax
//
//  Created by Kshitij S. Limaye on 8/9/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (IsNullOrEmpty)
- (BOOL) isNullOrEmpty;
+ (BOOL) isNullOrEmpty:(NSString*)string;
- (BOOL) isEmpty;
@end

@interface NSString (Trim)

- (NSString *)trim;
- (NSString *)trimAndLowerCase;
@end