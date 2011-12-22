#import "ESNSCategories.h"
#import <objc/runtime.h>

@implementation ESNSCategories
@end


@implementation NSBundle(ESUtils)

-(NSURL*)URLForResource:(NSString*)resource
{
    return [self URLForResource:resource withExtension:nil];
}

@end


@implementation NSDateFormatter(ESUtils)

+(NSDateFormatter*)dateFormatter
{
    return [[[NSDateFormatter alloc] init] autorelease];
}

+(NSDateFormatter*)dateFormatterWithTimeStyle:(NSDateFormatterStyle)timeStyle dateStyle:(NSDateFormatterStyle)dateStyle
{
    NSDateFormatter* result = [NSDateFormatter dateFormatter];
    result.timeStyle = NSDateFormatterShortStyle;
    result.dateStyle = NSDateFormatterShortStyle;
    return result;
}

+(NSDateFormatter*)dateFormatterWithStyle:(NSDateFormatterStyle)style
{
    return [NSDateFormatter dateFormatterWithTimeStyle:style dateStyle:style];
}

@end


@implementation NSDate(ESUtils)

-(NSString*)asStringWithShortFormat
{
    NSDateFormatter *f = [NSDateFormatter dateFormatterWithStyle:NSDateFormatterShortStyle];
    return [f stringFromDate:self];
}

-(NSString*)asRelativeString
{
    NSDateFormatter *f = [NSDateFormatter dateFormatterWithTimeStyle:NSDateFormatterNoStyle dateStyle:NSDateFormatterMediumStyle];
    f.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    f.doesRelativeDateFormatting=YES;
    
    return [f stringForObjectValue:self];
}

-(BOOL)isAfter:(NSDate*)d
{
    return [self compare:d] == NSOrderedDescending;
}

-(BOOL)isBefore:(NSDate*)d
{
    return [self compare:d] == NSOrderedAscending;
}

-(BOOL)isPast
{
    return [self isBefore:NSDate.date];
}

-(BOOL)isFuture
{
    return [self isAfter:NSDate.date];
}

-(NSDate*)dateByAddingDays:(int)d
{
    return [self dateByAddingTimeInterval:d * 24 * 60 * 60];
}

-(NSDate*)dateByAddingHours:(int)h
{
    return [self dateByAddingTimeInterval:h * 60 * 60];
}

-(NSDate*)dateByAddingMinutes:(int)m
{
    return [self dateByAddingTimeInterval:m * 60];
}

-(NSDate*)dateByAddingSeconds:(int)s
{
    return [self dateByAddingTimeInterval:s];
}

-(NSInteger)hour
{
    return [NSCalendar.currentCalendar components:kCFCalendarUnitHour fromDate:self].hour;
}

-(NSInteger)minute
{
    return [NSCalendar.currentCalendar components:kCFCalendarUnitMinute fromDate:self].minute;
}

-(NSInteger)second
{
    return [NSCalendar.currentCalendar components:kCFCalendarUnitSecond fromDate:self].second;
}

@end


@implementation NSDecimalNumber(ESUtils)

-(BOOL)isNotANumber
{
    return [NSDecimalNumber.notANumber isEqualToNumber:self];
}

@end


@implementation NSError(ESUtils)

-(void)log
{
    NSLog(@"%@", self.localizedDescription);
}

-(void)logWithMessage:(NSString*)message
{
    NSLog(@"%@ - %@", message, self);
}

@end


@implementation NSLock(ESUtils)

+(NSLock*)lock
{
    return [[[NSLock alloc] init] autorelease];
}

@end


@implementation NSObject(ESUtils)

-(NSString*)className
{
    return [NSString stringWithClassName:self.class];
}

-(SEL)setterMethodSelectorForKey:(NSString*)key
{
    return NSSelectorFromString([NSString stringWithSetterMethodNameForKey:key]);
}

-(BOOL)hasSetterForKey:(NSString*)key
{
    return [self respondsToSelector:[self setterMethodSelectorForKey:key]];
}

-(void)setValuesForKeys:(id<NSFastEnumeration>)keys withDictionary:(NSDictionary*)d
{
    for(id k in keys)
        if([self hasSetterForKey:k])
            [self setValue:[d objectForKey:k] forKey:k];
        else
            NSLog(@"No setter found in %@ for %@.", self.className, k);
}

@end


@implementation NSRegularExpression(ESUtils)

-(BOOL)matches:(NSString*)string
{
    return [self rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)].location != NSNotFound;
}

@end


@implementation NSString(ESUtils)

-(NSMutableString*)asMutableString
{
    return [self.mutableCopy autorelease];
}

//REFACTOR: consider pulling up into a math util library
float logx(float value, float base);
float logx(float value, float base) 
{
    return log10f(value) / log10f(base);
}

+(NSString*)stringWithFormattedFileSize:(unsigned long long)byteLength
{
    if(byteLength == 0)
        return @"0 B";
    //REFACTOR: consider storing for reuse
    NSArray *labels = $array(@"B", @"KB", @"MB", @"GB", @"TB");
    
    int power = MIN(labels.count-1, floor(logx(byteLength, 1024)));
    float size = (float)byteLength/powf(1024, power);
    
    return $format(@"%@ %@",
                   power?$format(@"%1.1f",size):$format(@"%i",byteLength),
                   [labels objectAtIndex:power]);
}

+(NSString*)stringWithClassName:(Class)c
{
    return [NSString stringWithUTF8String:class_getName(c)];
}

+(NSString*)stringWithUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

+(NSString*)stringWithSetterMethodNameForKey:(NSString*)key
{
    return $format(@"set%@:", key.asCapitalizedFirstLetter);
}

-(NSData*)dataWithUTF8
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)strip
{
    return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

-(BOOL)containsString:(NSString*)substring
{
    return [self rangeOfString:substring].location != NSNotFound;
}

-(BOOL)isEmpty
{
    return self.length == 0;
}

-(BOOL)isNotEmpty
{
    return self.length > 0;
}

-(BOOL)isBlank
{
    // Shortcuts object creation by testing before trimming.
    return self.isEmpty || self.strip.isEmpty;
}

-(BOOL)isPresent
{
    return !self.isEmpty && !self.strip.isEmpty;
}

-(NSString*)asCapitalizedFirstLetter
{
    if(self.isBlank) return self;
    
    return $format(@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]);
}

//credit: http://stackoverflow.com/questions/1918972/camelcase-to-underscores-and-back-in-objective-c
-(NSString*)asCamelCaseFromUnderscore
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [self length]; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

-(NSString*)asUnderscoreFromCamelCase
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [self length]; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

@end


@implementation NSThread(ESUtils)

+(void)detachNewThreadBlockImplementation:(ESEmptyBlock)block
{
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    block();
    Block_release(block);
    [p release];
}

+(void)detachNewThreadBlock:(ESEmptyBlock)block
{
    [NSThread detachNewThreadSelector:@selector(detachNewThreadBlockImplementation:) toTarget:self withObject:Block_copy(block)];
}

@end
