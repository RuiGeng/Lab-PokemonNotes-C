//
//  Entity+CoreDataProperties.h
//  Lab05C
//
//  Created by Rui Geng on 2016-10-20.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import "Entity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *target;

@end

NS_ASSUME_NONNULL_END
