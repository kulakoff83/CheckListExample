//
//  DKListsViewController.m
//  CheckList
//
//  Created by Dmitry Kulakov on 15.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKListsViewController.h"
#import "DKCoreDataStack.h"
#import "DKListTableViewCell.h"
#import "DKTasksViewController.h"
@import CoreData;

static NSString *ListCellIdentifier = @"ListCell";
static NSString *TasksSegueIdentifier = @"TasksSegue";

@interface DKListsViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DKListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureFetchResultController];
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UItableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DKListTableViewCell *cell = (DKListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DKList *list = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:list];
    }
}

#pragma mark - UItableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DKList *list = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:TasksSegueIdentifier sender:list];
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
            [self configureCell:(DKListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - Configure Elements

- (void)configureFetchResultController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DKList"];
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

- (void)configureCell:(DKListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:[record valueForKey:@"title"]];
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"DKListTableViewCell" bundle:nil] forCellReuseIdentifier:ListCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)configureNavigationBar {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(createList)];
    self.navigationItem.rightBarButtonItem = addItem;
}

#pragma mark - Actions

- (void)createList {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Add List" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Title";
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Current title %@", [[alerController textFields][0] text]);
        if (![[[alerController textFields][0] text] isEqualToString:@""]) {
            [[DKCoreDataStack sharedInstance] createListWithTitle:[[alerController textFields][0] text]];
            [[DKCoreDataStack sharedInstance] saveContext];
        }
    }];
    [alerController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancelled");
    }];
    [alerController addAction:cancelAction];
    [self presentViewController:alerController animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:TasksSegueIdentifier]) {
        DKTasksViewController *listsvc = segue.destinationViewController;
        listsvc.list = (DKList*)sender;
    }
}

@end
