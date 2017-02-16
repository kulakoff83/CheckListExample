//
//  DKTasksViewController.h
//  CheckList
//
//  Created by Dmitry Kulakov on 15.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKList+CoreDataProperties.h"

@interface DKTasksViewController : UIViewController

@property(strong,nonatomic) DKList *list;

@end
