//
//  DKTask+CoreDataProperties.h
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKTask+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DKTask (CoreDataProperties)

+ (NSFetchRequest<DKTask *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nonatomic) BOOL cheked;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) DKList *list;

@end

NS_ASSUME_NONNULL_END
