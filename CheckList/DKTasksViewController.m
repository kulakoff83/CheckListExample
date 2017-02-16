//
//  DKTasksViewController.m
//  CheckList
//
//  Created by Dmitry Kulakov on 15.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKTasksViewController.h"
#import "DKCoreDataStack.h"
#import "DKTaskTableViewCell.h"
#import "DKTaskDetailsViewController.h"
#import "DKGalleryViewController.h"

@import CoreData;

static NSString *TaskCellIdentifier = @"TaskCell";
static NSString *TaskDetailsVCIdentifier = @"TaskDetailsVC";
static NSString *GallerySegueIdentifier = @"GallerySegue";

@interface DKTasksViewController () <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,getter=isEditMode) BOOL editMode;

@end

@implementation DKTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureFetchResultController];
    [self configureNavigationBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UItableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DKTaskTableViewCell *cell = (DKTaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TaskCellIdentifier forIndexPath:indexPath];
    if([self isLastCellFor:indexPath]){
        [cell configureAddCell];
    } else {
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isLastCellFor:indexPath]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DKTask *task = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:task];
    }
}

#pragma mark - UItableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self isLastCellFor:indexPath]){
        [self createTask];
    } else {
        DKTask *task = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [self editeTask:task];
    }
}

#pragma mark - FetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(DKTaskTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        self.list.title = textField.text;
    } else {
        textField.text = self.list.title;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Configure Elements

- (void)configureFetchResultController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DKTask"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"list == %@", self.list];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[[DKCoreDataStack sharedInstance] persistentContainer] viewContext] sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (void)configureCell:(DKTaskTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureChekedButtonWith:(DKTask *)record];
    NSData *imageData = [record valueForKey:@"imageData"];
    if(imageData == nil) {
        [cell.taskImageView setImage:[UIImage imageNamed:@"no_image"]];
    } else {
        [cell.taskImageView setImage:[UIImage imageWithData:imageData]];
    }
    [cell.taskTitleLabel setText:[record valueForKey:@"title"]];
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"DKTaskTableViewCell" bundle:nil] forCellReuseIdentifier:TaskCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addHeaderToTableView];
}

- (void)configureNavigationBar {
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editList)];
    self.navigationItem.rightBarButtonItem = editItem;
}

-(void)addHeaderToTableView {
    CGFloat width = self.view.frame.size.width;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 60)];
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.enabled = NO;
    textField.frame = CGRectMake(0, 0, width - 32, 30);
    textField.font = [UIFont systemFontOfSize:20];
    textField.text = self.list.title;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = @"List title";
    textField.delegate = self;
    [headerView addSubview:textField];
    textField.center = headerView.center;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Actions

- (void)createTask {
    DKTaskDetailsViewController *taskDetailsVC = [[DKTaskDetailsViewController alloc]initWithNibName:@"DKTaskDetailsViewController" bundle:nil];
    taskDetailsVC.list = self.list;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:taskDetailsVC];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

- (void)editeTask:(DKTask*)task {
    DKTaskDetailsViewController *taskDetailsVC = [[DKTaskDetailsViewController alloc]initWithNibName:@"DKTaskDetailsViewController" bundle:nil];
    taskDetailsVC.task = task;
    taskDetailsVC.editMode = YES;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:taskDetailsVC];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

- (void)editList {
    UITextField *textField = self.tableView.tableHeaderView.subviews.lastObject;
    if (![self isEditMode]) {
        textField.enabled = YES;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.tableView setEditing: YES animated: YES];
        self.navigationItem.rightBarButtonItem.title = @"Done";
    } else {
        textField.enabled = NO;
        textField.borderStyle = UITextBorderStyleNone;
        [self.tableView setEditing: NO animated: YES];
        self.navigationItem.rightBarButtonItem.title = @"Edit";
    }
    self.editMode = !self.editMode;
}

- (IBAction)attachmentButtonPressed:(id)sender {
    [self performSegueWithIdentifier:GallerySegueIdentifier sender:nil];
    NSLog(@"%@",[self getImages]);
}

#pragma mark - Helpers

- (BOOL)isLastCellFor:(NSIndexPath*) indexPath {
    NSInteger totalRow = [self.tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow - 1){
        return YES;
    }
    return NO;
}

- (NSMutableArray*)getImages {
    NSMutableArray *imageArray = [NSMutableArray new];
    for (DKTask *task in self.list.tasks) {
        UIImage *image = [UIImage imageWithData:task.imageData];
        if(image) {
           [imageArray addObject:[UIImage imageWithData:task.imageData]];
        }
    }
    return imageArray;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:GallerySegueIdentifier]) {
        DKGalleryViewController *galleryVC = segue.destinationViewController;
        galleryVC.images = [self getImages];
    }
}

@end
