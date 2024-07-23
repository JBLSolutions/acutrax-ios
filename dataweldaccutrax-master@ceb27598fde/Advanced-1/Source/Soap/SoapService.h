#import "SoapDelegate.h"

@interface SoapService : NSObject
{
	NSString* _serviceUrl;
	NSString* _namespace;
	NSString* _username;
	NSString* _password;
	NSDictionary* _headers;
	BOOL _logging;
	id<SoapDelegate> _defaultHandler;
}

@property (strong) NSString* serviceUrl;
@property (strong) NSString* namespace;
@property (strong) NSString* username;
@property (strong) NSString* password;
@property (strong) NSDictionary* headers;
@property BOOL logging;
@property (nonatomic, strong) id<SoapDelegate> defaultHandler;

- (id) initWithUrl: (NSString*) url;
- (id) initWithUsername: (NSString*) username andPassword: (NSString*) password;

@end