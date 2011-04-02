#import "ESApplicationDelegateTest.h"
#import "ESApplicationDelegate.h"

@implementation ESApplicationDelegateTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate
{
    ESApplicationDelegate *delegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(delegate, @"UIApplication failed to find the AppDelegate");
    
    STAssertEquals([ESApplicationDelegate delegate], delegate, @"Class delegate method should return current application delegate");
    STAssertEquals([ESApplicationDelegate managedObjectContext], delegate.managedObjectContext, @"Class managedObjectContext method should return current managed object context");

    NSURL *docDir = delegate.applicationDocumentsDirectory;
    STAssertNotNil(docDir, @"UIApplication failed to return document directory."); 
    STAssertEqualObjects(@"Documents", docDir.lastPathComponent, @"applicationDocumentsDirectory should end in Documents.");
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:docDir.path], @"documents directory should exist.");
    
    STAssertNotNil(delegate.managedObjectModel, @"managedObjectModel singleton should be created.");
    STAssertNotNil(delegate.persistentStoreCoordinator, @"persistentStoreCoordinator singleton should be created.");
    STAssertNotNil(delegate.managedObjectContext, @"managedObjectContext singleton should be created.");
}

#else                           // all code under test must be linked into the Unit Test bundle



#endif

@end
