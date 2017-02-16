//
//  DKCoreDataStack.m
//  CheckList
//
//  Created by Dmitry Kulakov on 15.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKCoreDataStack.h"

@implementation DKCoreDataStack

+ (instancetype)sharedInstance
{
    static DKCoreDataStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DKCoreDataStack alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (DKList*)createListWithTitle:(NSString*)title {
    DKList *list = [NSEntityDescription insertNewObjectForEntityForName:@"DKList" inManagedObjectContext:self.persistentContainer.viewContext];
    list.title = title;
    list.createDate = [NSDate date];
    return list;
}

- (DKTask*)createTaskWithTitle:(NSString*)title image:(NSData*)imageData toList:(DKList*)list {
    DKTask *task = [NSEntityDescription insertNewObjectForEntityForName:@"DKTask" inManagedObjectContext:self.persistentContainer.viewContext];
    task.title = title;
    task.imageData = imageData;
    task.createDate = [NSDate date];
    [list addTasksObject:task];
    return task;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CheckList"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
