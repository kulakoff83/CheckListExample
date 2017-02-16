//
//  DKTask+CoreDataProperties.m
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKTask+CoreDataProperties.h"

@implementation DKTask (CoreDataProperties)

+ (NSFetchRequest<DKTask *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DKTask"];
}

@dynamic cheked;
@dynamic imageData;
@dynamic title;
@dynamic list;
@dynamic createDate;

@end
