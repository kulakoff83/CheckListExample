//
//  DKList+CoreDataProperties.m
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKList+CoreDataProperties.h"

@implementation DKList (CoreDataProperties)

+ (NSFetchRequest<DKList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DKList"];
}

@dynamic createDate;
@dynamic title;
@dynamic tasks;

@end
