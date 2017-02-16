//
//  DKList+CoreDataProperties.h
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DKList (CoreDataProperties)

+ (NSFetchRequest<DKList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSSet<DKTask *> *tasks;

@end

@interface DKList (CoreDataGeneratedAccessors)

- (void)addTasksObject:(DKTask *)value;
- (void)removeTasksObject:(DKTask *)value;
- (void)addTasks:(NSSet<DKTask *> *)values;
- (void)removeTasks:(NSSet<DKTask *> *)values;

@end

NS_ASSUME_NONNULL_END
