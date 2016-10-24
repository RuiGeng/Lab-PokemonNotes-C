//
//  ViewController.m
//  Lab05C
//
//  Created by Rui Geng on 2016-10-20.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import "ViewController.h"
#import "Entity+CoreDataClass.h"


@interface ViewController ()

@end

@implementation ViewController

// Get, Insert, Delete
@synthesize managedObjectModel = _managedObjectModel;

// Schema
@synthesize managedObjectContext = _managedObjectContext;

// Database Connection
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *results = [self loadCoreData];
    if(results.count > 0){
        for(Entity *entity in results){
            _m_text.text = entity.target;
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Save:(id)sender {
    
    // Get a pointer to the text
    NSString* text = _m_text.text;
    
    // Save it to the .sqlite DB
    
    // 1. Get a pointer to the database
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    // 2. Create a new object of type Entity and fill it with data
    Entity* entity =[NSEntityDescription
                     insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    
    [entity setValue:text forKeyPath:@"target"];
    
    // 3. Send the object to the local database
    if(![context save:&error]){
        NSLog(@"Save Failed! %@", [error localizedDescription]);
    }
}

// Load data from the local database if it's avaliable
- (NSArray*)loadCoreData {
    
    // 1. Get a pointer to the database
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    // 2. fetch data from core data
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc]init];
    [fetchrequest setEntity:[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context]];
    
    NSArray *results = [context executeFetchRequest:fetchrequest error:&error];
    if(error){
        NSLog(@"Fetch request Failed! %@", [error localizedDescription]);
    }
    
    return results;
}

// For core-data
- (void)saveContext{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lab05C"withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"ModelCoreData.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// END CORE DATA //


@end
