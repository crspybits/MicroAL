//
//  MasterViewController.m
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

#import "MasterViewController.h"
#import "MicroAL-Swift.h"
#import <SMCoreLib/SMCoreLib.h>
#import "ServiceProviderTableViewCell.h"

@interface MasterViewController()<UITableViewDelegate, UITableViewDataSource, CoreDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonnull) CoreDataSource *coreDataSource;
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

    /*
    if ([Network connected]) {
        [ServiceProvider removeAllObjects];
        [[ServiceProviders session] download:^(NSError *error) {
            if (!error) {
                 [self setupTableView];
            }
        }];
    }
    else {
        [self setupTableView];
    }
    */
}

- (void) viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self.coreDataSource fetchData];
    [self.tableView reloadData];
    
    // Setting the VC title in the storyboard doesn't actually change it. Because of the use of the nav controller?
    self.title = @"Service Providers";
    
    NSLog(@"viewWillAppear");
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

// This must have sort descriptor(s) because that is required by the NSFetchedResultsController, which is used internally by this class.
- (NSFetchRequest *) coreDataSourceFetchRequest: (CoreDataSource *) cds;
{
    return [ServiceProvider fetchRequestForAllObjectsWithSortedByFieldName:FieldNameNAME];
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

@end
