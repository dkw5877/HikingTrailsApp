//
//  FirstViewController.m
//  HikingTrails
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "TrailViewController.h"
#import "MapViewController.h"
#import "TrailManager.h"
#import "Trail.h"

@interface TrailViewController ()< UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)NSMutableArray* trails;
@property (nonatomic)NSIndexPath* selectedCell;

@end

@implementation TrailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.trails = [NSMutableArray new];
    TrailManager* trailManager = [[TrailManager alloc]init];
    trailManager.delegate = (id)self;
    [trailManager retrieveTrailFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trails.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Trail* trail = self.trails[indexPath.item];
    cell.textLabel.text = trail.trailName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    //get the tab bar controller
    MapViewController* mapViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    
    //pass the selected cell
    mapViewController.trail = self.trails[indexPath.item];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark )
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return indexPath;
}


#pragma mark -TrailManagerDelegate
-(void)didFinishParsingXMLFile:(TrailManager*)trailManager forTrail:(Trail*)trail
{
    [self.trails addObject:trail];
    //[self.tableView reloadData];
    
    NSInteger row = self.trails.count-1;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];

    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

@end
