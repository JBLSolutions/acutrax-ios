//
//  NSString+Helpers.m
//  acutrax
//
//  Created by Kshitij S. Limaye on 8/9/16.
//
//

#import "NSString+Helpers.h"

@implementation NSString (IsNullOrEmpty)

//TODO: Refactor this to reflect that it can only be used if we know the string is not nil.
// Check of self==nil was removed since it is impossible to call a string instance extension method on nil,
// So we need to look into if this method is used anywhere there is a chance of a nil string.
- (BOOL) isNullOrEmpty {
    if ([[self trim] length] == 0) return YES;
    if ([self isEqualToString:@"(null)"]) return YES;
    return NO;
}

+ (BOOL) isNullOrEmpty:(NSString*) string {
    if (string == nil) return YES;
    return [string isNullOrEmpty];
}

- (BOOL) isEmpty {
    if ([[self trim] length] == 0) return YES;
    return NO;
}

@end

@implementation NSString (Trim)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimAndLowerCase {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
}

@end
