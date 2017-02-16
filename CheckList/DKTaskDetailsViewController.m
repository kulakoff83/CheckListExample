//
//  DKTaskDetailsViewController.m
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKTaskDetailsViewController.h"
#import "DKCoreDataStack.h"

@interface DKTaskDetailsViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;

@end

@implementation DKTaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureTitleTextField];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTaskWithTitle:(NSString*)title andImage:(UIImage*)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    self.task = [[DKCoreDataStack sharedInstance] createTaskWithTitle:title image:imageData toList:self.list];
    [[DKCoreDataStack sharedInstance] saveContext];
}

- (void)editeTask {
    self.task.title = self.taskTitleTextField.text;
    NSData *imageData = UIImageJPEGRepresentation(self.taskImageView.image, 1.0);
    self.task.imageData = imageData;
    [[DKCoreDataStack sharedInstance] saveContext];
}

#pragma mark - TextField Delegate
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (![textField.text isEqualToString:@""]) {
//        self.list.title = textField.text;
//    } else {
//        textField.text = self.list.title;
//    }
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.taskImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Configure Elements

- (void)configureNavigationBar {
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneItem;
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItem = closeItem;
    if([self isEditMode]) {
        self.title = @"Edite Task";
    } else {
        self.title = @"Add Task";
    }
}

- (void)configureTitleTextField {
    self.taskTitleTextField.delegate = self;
    self.taskTitleTextField.returnKeyType = UIReturnKeyDone;
    self.taskTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.taskTitleTextField.placeholder = @"Task title";
    if (self.isEditMode) {
        self.taskTitleTextField.text = self.task.title;
        self.taskImageView.image = [UIImage imageWithData:self.task.imageData];
    }
    if(!self.task.imageData) {
        self.taskImageView.image = [UIImage imageNamed:@"no_image"];

    }
}

- (void)showImageActionSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit Image"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Image"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              self.task.imageData = nil;
                                                              self.taskImageView.image = [UIImage imageNamed:@"no_image"];
                                                          }];
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"Change Image"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self presentImagePicker];
                                                           }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:removeAction];
    [alert addAction:changeAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Actions

- (void)closeAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction {
    if(![self.taskTitleTextField.text isEqualToString:@""]){
        if([self isEditMode]) {
            [self editeTask];
        } else {
            [self createTaskWithTitle:self.taskTitleTextField.text andImage:self.taskImageView.image];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)taskImageViewTapped:(id)sender {
    if([self isEditMode]) {
        [self showImageActionSheet];
    } else {
        [self presentImagePicker];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
