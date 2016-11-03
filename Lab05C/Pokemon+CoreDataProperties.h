//
//  Pokemon+CoreDataProperties.h
//  Lab05C
//
//  Created by Rui on 2016-11-03.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import "Pokemon+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Pokemon (CoreDataProperties)

+ (NSFetchRequest<Pokemon *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *pokename;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *comment;

@end

NS_ASSUME_NONNULL_END
