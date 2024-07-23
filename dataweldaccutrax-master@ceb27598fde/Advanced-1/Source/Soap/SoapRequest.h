/*
 SoapRequest.h
 Interface definition of the request object used to manage asynchronous requests.
 Author:	Jason Kichline, andCulture - Harrisburg, Pennsylvania USA
*/

#import "SoapHandler.h"
#import "SoapService.h"

@interface SoapRequest : NSObject {
	NSURL* url;
	NSString* soapAction;
	NSString* username;
	NSString* password;
	id postData;
	NSMutableData* receivedData;
	NSURLConnection* conn;
	SoapHandler* handler;
	id deserializeTo;
	SEL action;
	BOOL logging;
	id<SoapDelegate> defaultHandler;
}

@property (strong, nonatomic) NSURL* url;
@property (strong, nonatomic) NSString* soapAction;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) id postData;
@property (strong, nonatomic) NSMutableData* receivedData;
@property (strong, nonatomic) SoapHandler* handler;
@property (strong, nonatomic) id deserializeTo;
@property SEL action;
@property BOOL logging;
@property (strong, nonatomic) id<SoapDelegate> defaultHandler;

+ (SoapRequest*) create: (SoapHandler*) handler urlString: (NSString*) urlString soapAction: (NSString*) soapAction postData: (NSString*) postData deserializeTo: (id) deserializeTo;
+ (SoapRequest*) create: (SoapHandler*) handler action: (SEL) action urlString: (NSString*) urlString soapAction: (NSString*) soapAction postData: (NSString*) postData deserializeTo: (id) deserializeTo;
+ (SoapRequest*) create: (SoapHandler*) handler action: (SEL) action service: (SoapService*) service soapAction: (NSString*) soapAction postData: (NSString*) postData deserializeTo: (id) deserializeTo;

- (BOOL)cancel;
- (void)send;
- (void)handleError:(NSError*)error;
- (void)handleFault:(SoapFault*)fault;

@end