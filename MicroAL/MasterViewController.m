//
//  MasterViewController.m
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

// Give the list of Service Provider's, in a table view.

#import "MasterViewController.h"
#import "MicroAL-Swift.h"
#import <SMCoreLib/SMCoreLib.h>
#import "ServiceProviderTableViewCell.h"

@interface MasterViewController()<UITableViewDelegate, UITableViewDataSource, CoreDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CoreDataSource *coreDataSource;
@property (strong, nonatomic) UIBarButtonItem *sort;
@property (nonatomic) FieldName fieldNameForSorting;
@end

@implementation MasterViewController

- (void) viewDidLoad;
{
    [super viewDidLoad];
    
    self.coreDataSource = [[CoreDataSource alloc] initWithDelegate:self];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Not needed!!! If you use this, your IBOutlets won't get assigned!! :(. Bad puppy!
    //[self.tableView registerClass:[ServiceProviderTableViewCell class] forCellReuseIdentifier:[ServiceProviderTableViewCell reuseIdentifier]];
    
    NSArray *serviceProviders = [ServiceProvider fetchAllObjects];
    NSLog(@"serviceProviders: %@", serviceProviders);
    
    self.sort = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonAction)];
    
    self.fieldNameForSorting = FieldNameNAME;
}

- (void) changeSortOrderTo: (FieldName) fieldName;
{
    self.fieldNameForSorting = fieldName;
    [self.coreDataSource fetchData];
    [self.tableView reloadData];
}

- (void) sortButtonAction;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sort Order" message:@"Change the Sorting Order" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sort by name" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self changeSortOrderTo:FieldNameNAME];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sort by grade" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self changeSortOrderTo:FieldNameGRADE];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sort by review count" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self changeSortOrderTo:FieldNameREVIEW_COUNT];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    // On iPad, get a crash without this: http://stackoverflow.com/questions/26039229/swift-uialtertcontroller-actionsheet-ipad-ios8-crashes
    alertController.popoverPresentationController.barButtonItem = self.sort;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self.coreDataSource fetchData];
    [self.tableView reloadData];
    
    // Setting the VC title in the storyboard doesn't actually change it. Because of the use of the nav controller?
    self.title = @"Service Providers";
    
    NSLog(@"viewWillAppear");
    
    // Setting the nav bar sort button in viewWillAppear, and removing it in viewWillDisappear so that we don't have the sort in the detail view controller.
    self.navigationItem.rightBarButtonItem = self.sort;
}

- (void) viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSInteger numberOfRows = [self.coreDataSource numberOfRowsInSection:0];
    NSLog(@"number of rows: %ld", (long)numberOfRows);
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ServiceProviderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ServiceProviderTableViewCell reuseIdentifier] forIndexPath:indexPath];
    
    ServiceProvider *serviceProvider = (ServiceProvider *) [self.coreDataSource objectAtIndexPath:indexPath];
    
    [cell configureWith:serviceProvider];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailViewController = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    ServiceProvider *serviceProvider = (ServiceProvider *) [self.coreDataSource objectAtIndexPath:indexPath];
    detailViewController.serviceProvider = serviceProvider;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - CoreDataSourceDelegate

// NSFetchRequest must have sort descriptor(s) because that is required by the NSFetchedResultsController, which is used internally by CoreDataSource.
- (NSFetchRequest *) coreDataSourceFetchRequest: (CoreDataSource *) cds;
{
    BOOL ascendingSortOrder = YES;
    switch (self.fieldNameForSorting) {
    case FieldNameREVIEW_COUNT:
        ascendingSortOrder = NO;
        break;
        
    case FieldNameNAME:
    case FieldNameGRADE:
        // Leave as ascending; look better to have dictionary order (ascending) for names and grade.
        break;
    
    default:
        // Not using the other field names for sorting, but give a default of ascending.
        break;
    }
    
    return [ServiceProvider fetchRequestForAllObjectsWithSortedByFieldName:self.fieldNameForSorting withAscendingSortSorder:ascendingSortOrder];
}

- (NSManagedObjectContext *) coreDataSourceContext: (CoreDataSource *) cds;
{
    return [CoreData sessionNamed: [CoreDataSession name]].context;
}

// This is needed to deal with a race condition: Does the network load of data finish before or after the view controller appears?
- (void) coreDataSource: (CoreDataSource *) cds objectWasInserted: (NSIndexPath *) indexPathOfInsertedObject;
{
    NSLog(@"objectWasInserted");
    [self.tableView reloadData];
}

#pragma mark - 

@end
