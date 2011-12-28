#import <Foundation/Foundation.h>
#import "ESUtils.h"

// The class is here to force the linker to load categories
@interface ESNSCategories:NSObject
@end

typedef void(^ESEmptyBlock)();
typedef void(^ErrorBlock)(NSError*);

@interface NSBundle(ESUtils)
  -(NSURL*)URLForResource:(NSString*)resource;
@end

@interface NSDateFormatter(ESUtils)
  +(NSDateFormatter*)dateFormatter;
  +(NSDateFormatter*)dateFormatterWithTimeStyle:(NSDateFormatterStyle)timeStyle dateStyle:(NSDateFormatterStyle)dateStyle;
  +(NSDateFormatter*)dateFormatterWithStyle:(NSDateFormatterStyle)style;
@end

@interface NSDate(ESUtils)
  @property(nonatomic, readonly) NSString* asStringWithShortFormat;
  @property(nonatomic, readonly) NSString* asRelativeString;

  -(BOOL)isBefore:(NSDate*)d;
  -(BOOL)isAfter:(NSDate*)d;
  @property(nonatomic, readonly) BOOL      isPast;
  @property(nonatomic, readonly) BOOL      isFuture;

  -(NSDate*)dateByAddingDays:(int)d;
  -(NSDate*)dateByAddingHours:(int)h;
  -(NSDate*)dateByAddingMinutes:(int)m;
  -(NSDate*)dateByAddingSeconds:(int)s;

  @property(nonatomic, readonly) NSInteger hour;
  @property(nonatomic, readonly) NSInteger minute;
  @property(nonatomic, readonly) NSInteger second;
@end

@interface NSDecimalNumber(ESUtils)
  @property(nonatomic, readonly) BOOL isNotANumber;
@end

@interface NSError(ESUtils)
  -(void)log;
  -(void)logWithMessage:(NSString*)message;
@end

@interface NSLock(ESUtils)
    +(NSLock*)lock;
@end

@interface NSObject(ESUtils)
  @property(readonly) NSString *className;
  -(SEL)setterMethodSelectorForKey:(NSString*)key;
  -(BOOL)hasSetterForKey:(NSString*)key;
  -(void)setValuesForKeys:(id<NSFastEnumeration>)keys withDictionary:(NSDictionary*)d;
@end

@interface NSRegularExpression(ESUtils)
    -(BOOL)matches:(NSString*)string;
@end

@interface NSString(ESUtils)
    @property(nonatomic, readonly) NSMutableString* asMutableString;

    //Formats like 576B, 5.6MB
    +(NSString*)stringWithFormattedFileSize:(unsigned long long)byteLength;
    +(NSString*)stringWithClassName:(Class)c;
    +(NSString*)stringWithUUID;
    +(NSString*)stringWithSetterMethodNameForKey:(NSString*)key;

    @property(nonatomic, readonly) NSData   *dataWithUTF8;
    @property(nonatomic, readonly) NSString *strip;
    -(BOOL)containsString:(NSString*)substring;

    //Returns true if the string exists and contains only whitespace.
    @property(nonatomic, readonly) BOOL      isBlank;
    //Checks if a string exists and is not blank.  Preferred over isBlank because existance doesn't need to be checked.
    @property(nonatomic, readonly) BOOL      isPresent;

    @property(nonatomic, readonly) BOOL      isEmpty;
    @property(nonatomic, readonly) BOOL      isNotEmpty;

    @property(nonatomic, readonly) NSString *asCapitalizedFirstLetter;
    @property(nonatomic, readonly) NSString *asCamelCaseFromUnderscore;
    @property(nonatomic, readonly) NSString *asUnderscoreFromCamelCase;
@end

@interface NSThread(ESUtils)
    +(void)detachNewThreadBlock:(ESEmptyBlock)block;
@end
