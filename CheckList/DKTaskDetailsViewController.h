//
//  DKTaskDetailsViewController.h
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKTask+CoreDataProperties.h"
#import "DKList+CoreDataProperties.h"

@interface DKTaskDetailsViewController : UIViewController

@property (strong,nonatomic) DKTask *task;
@property (strong,nonatomic) DKList *list;
@property (nonatomic,getter=isEditMode) BOOL editMode;

@end
