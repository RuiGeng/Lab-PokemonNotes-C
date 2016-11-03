//
//  Pokemon+CoreDataProperties.m
//  Lab05C
//
//  Created by Rui on 2016-11-03.
//  Copyright © 2016 Rui Geng. All rights reserved.
//

#import "Pokemon+CoreDataProperties.h"

@implementation Pokemon (CoreDataProperties)

+ (NSFetchRequest<Pokemon *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Pokemon"];
}

@dynamic pokename;
@dynamic timestamp;
@dynamic location;
@dynamic comment;

@end
