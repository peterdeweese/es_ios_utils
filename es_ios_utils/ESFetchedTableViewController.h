//
//  ESFetchedTableViewController.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/8/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//
//  Implemented with one section.
//

#import <Foundation/Foundation.h>

@interface ESFetchedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> { }

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext     *managedObjectContext;

//Configure these:

@property(copy) void(^doOnError)(NSError*);
@property(nonatomic, readonly) NSArray *sortDescriptors;

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
