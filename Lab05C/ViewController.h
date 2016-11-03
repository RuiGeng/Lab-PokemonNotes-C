//
//  ViewController.h
//  Lab05C
//
//  Created by Rui Geng on 2016-10-20.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/Coredata.h>

@interface ViewController : UIViewController


// Used for Core-Data
// Schema
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

// Get insert delete from the database
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

// Database Connection
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// nice to have to reference files for core data
- (NSURL *)applicationDocumentsDirectory;

@property (weak, nonatomic) IBOutlet UITextField *textPokename;

@property (weak, nonatomic) IBOutlet UITextField *textLocation;

@property (weak, nonatomic) IBOutlet UITextField *textTimestamp;

@property (weak, nonatomic) IBOutlet UITextView *textComment;

@property NSArray *arrayResult;

@property int currentCount;

@property (weak, nonatomic) IBOutlet UILabel *labCount;

@end
