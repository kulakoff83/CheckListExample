//
//  DKTaskTableViewCell.h
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKTask+CoreDataProperties.h"

@interface DKTaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *taskCheckButton;
@property  (nonatomic, copy) void(^checkedButtonHandler)(DKTask *task, BOOL checked);
@property (nonatomic,strong) DKTask *task;

- (void)configureChekedButtonWith:(DKTask*)task;
//@property (nonatomic,getter=isChecked) BOOL checked;

- (void)configureAddCell;

@end
