//
//  SoapParameter.h
//  Giant
//
//  Created by Jason Kichline on 7/13/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SoapParameter : NSObject {
	NSString* name;
	NSString* xml;
	id value;
	BOOL null;
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) id value;
@property (readonly) BOOL null;
@property (nonatomic, strong, readonly) NSString* xml;

-(id)initWithValue:(id)value forName: (NSString*) name;

@end
