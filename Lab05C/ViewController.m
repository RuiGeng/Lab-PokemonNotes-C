//
//  ViewController.m
//  Lab05C
//
//  Created by Rui Geng on 2016-10-20.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import "ViewController.h"
#import "Pokemon+CoreDataClass.h"


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
    
    [self setUITextViewStyle];
    
    _textTimestamp.text = [self getDate];
    
    _currentCount=0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Save:(id)sender {
    
    // Get a pointer to the text
    NSString* pokename = _textPokename.text;
    NSString* location = _textLocation.text;
    NSDate* timestamp = [NSDate date];
    NSString* comments = _textComment.text;
    
    // Save it to the .sqlite DB
    
    // 1. Get a pointer to the database
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    // 2. Create a new object of type Entity and fill it with data
    Pokemon* pokemon =[NSEntityDescription
                       insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:context];
    
    [pokemon setValue:pokename forKeyPath:@"pokename"];
    [pokemon setValue:location forKeyPath:@"location"];
    [pokemon setValue:timestamp forKeyPath:@"timestamp"];
    [pokemon setValue:comments forKeyPath:@"comment"];
    
    // 3. Send the object to the local database
    if(![context save:&error]){
        NSLog(@"Save Failed! %@", [error localizedDescription]);
    }else{
        
        NSLog(@"Pokemon %@ Saved!", pokename);
    }
}

// Load data from the local database if it's avaliable
- (NSArray*)loadCoreData {
    
    // 1. Get a pointer to the database
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    // 2. fetch data from core data
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc]init];
    [fetchrequest setEntity:[NSEntityDescription entityForName:@"Pokemon" inManagedObjectContext:context]];
    
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

- (IBAction)leftSwitch:(id)sender {
    
    int count = [self searchData];
    
    if( count > 0){
        
        if(_currentCount == 0){
            
            [self showData:0];
        }
        else if (_currentCount > 0){
            
            _currentCount = _currentCount - 1;
            
            [self showData:_currentCount];
        }
        [self showCount:_currentCount TotalCount:count];
    }
}

-(void)showCount:(int)current TotalCount:(int)total{
    
    NSString *labCount;
    
    labCount = [NSString stringWithFormat:@"%i/%i", current, total];
    
    _labCount.text = labCount;
}

- (IBAction)rightSwitch:(id)sender {
    
    int count = [self searchData];
    
    if( count >0 ){
        
        if(_currentCount == count){
            
            [self showData:count-1];
        }
        else if(_currentCount < count){
            
            [self showData:_currentCount];
            
            _currentCount = _currentCount + 1;
        }
    }
    
    [self showCount:_currentCount TotalCount:count];
}

-(int)searchData{
    
    _arrayResult = [self loadCoreData];
    
    if(_arrayResult.count > 0){
        for(Pokemon *pokemon in _arrayResult){
            NSLog(@"%lu pokemons you have right now!", (unsigned long)_arrayResult.count);
            NSLog(@"Pokemon Name = %@", pokemon.pokename);
            NSLog(@"Location = %@", pokemon.location);
            NSLog(@"Time Stamp = %@", pokemon.timestamp);
            NSLog(@"Comments = %@", pokemon.comment);
        }
    }
    
    return (int)_arrayResult.count;
}

-(void)showData:(int)index{
    
    Pokemon *pokemon = [_arrayResult objectAtIndex:index];
    _textPokename.text = pokemon.pokename;
    _textLocation.text = pokemon.location;
    //_textTimestamp.text = pokemon.timestamp;
    _textComment.text = pokemon.comment;
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

-(void) setUITextViewStyle{
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    _textComment.layer.borderColor = borderColor.CGColor;
    _textComment.layer.borderWidth = 1.0;
    _textComment.layer.cornerRadius = 5.0;
}

-(NSString *) getDate{
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM dd, yyyy HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *nsstr = [format stringFromDate:now];
    return nsstr;
}

@end
