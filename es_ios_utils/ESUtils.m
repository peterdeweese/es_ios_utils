#import "ESUtils.h"
#import <objc/runtime.h>

@implementation ES

+(NSString*)typeNameStringForProperty:(NSString*)propertyName inClass:(Class)c
{
    objc_property_t property = class_getProperty(c, propertyName.UTF8String);
    if(!property) return nil;
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
    
	static char buffer[256];
	const char * e = strchr( attrs, ',' );
	if ( e == NULL )
		return ( NULL );
    
	int len = (int)(e - attrs);
	memcpy( buffer, attrs, len );
	buffer[len] = '\0';
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(BOOL)isPropertyADouble:(NSString*)p inClass:(Class)c
{
    return [@"Td" isEqualToString:[self typeNameStringForProperty:p inClass:c]];
}

@end
