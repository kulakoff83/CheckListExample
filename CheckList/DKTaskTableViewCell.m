//
//  DKTaskTableViewCell.m
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKTaskTableViewCell.h"

@implementation DKTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.taskImageView.hidden = NO;
    self.taskTitleLabel.hidden = NO;
    self.taskCheckButton.hidden = NO;
}

- (void)configureAddCell {
    self.textLabel.text = @"Add Task";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.taskImageView.hidden = YES;
    self.taskTitleLabel.hidden = YES;
    self.taskCheckButton.hidden = YES;
}

- (void)detectCheckedButtonState {
    if (self.task.cheked) {
        [self.taskCheckButton setBackgroundImage:[UIImage imageNamed:@"check_image"] forState:UIControlStateNormal];
    } else {
        [self.taskCheckButton setBackgroundImage:[UIImage imageNamed:@"uncheck_image"] forState:UIControlStateNormal];
    }
}

- (void)configureChekedButtonWith:(DKTask*)task {
    self.task = task;
    [self detectCheckedButtonState];
}

- (IBAction)checkButtonPressed:(id)sender {
    //self.checked = !self.checked;
    self.task.cheked = !self.task.cheked;
    [self detectCheckedButtonState];
    //self.checkedButtonHandler(self.task);
    
}

@end
