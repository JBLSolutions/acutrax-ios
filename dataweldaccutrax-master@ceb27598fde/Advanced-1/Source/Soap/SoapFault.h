/*
 SoapFault.h
 Interface that constructs a fault object from a SOAP fault when the
 web service returns an error.

 Author:	Jason Kichline, andCulture - Harrisburg, Pennsylvania USA
*/

#import "TouchXML.h"

@interface SoapFault : NSObject {
	NSString* faultCode;
	NSString* faultString;
	NSString* faultActor;
	NSString* detail;
	BOOL hasFault;
}

@property (strong, nonatomic) NSString* faultCode;
@property (strong, nonatomic) NSString* faultString;
@property (strong, nonatomic) NSString* faultActor;
@property (strong, nonatomic) NSString* detail;
@property BOOL hasFault;

+ (SoapFault*) faultWithData: (NSMutableData*) data;
+ (SoapFault*) faultWithXMLDocument: (CXMLDocument*) document;
+ (SoapFault*) faultWithXMLElement: (CXMLNode*) element;

@end
