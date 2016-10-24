//
//  AppDelegate.h
//  Lab05C
//
//  Created by Rui Geng on 2016-10-20.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

