//
//  DKCoreDataStack.h
//  CheckList
//
//  Created by Dmitry Kulakov on 15.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKList+CoreDataProperties.h"
#import "DKTask+CoreDataProperties.h"
@import CoreData;

@interface DKCoreDataStack : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedInstance;
- (void)saveContext;
- (DKList*)createListWithTitle:(NSString*)title;
- (DKTask*)createTaskWithTitle:(NSString*)title image:(NSData*)imageData toList:(DKList*)list;

@end
