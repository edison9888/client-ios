//
//  ShareAppView.m
//  TongFubao
//
//  Created by  俊   on 14-8-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ShareAppView.h"
#import "SampleCell.h"
#import "DetailViewController.h"

#define TABLE_HEIGHT 80

@interface ShareAppView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray* arrayForPlaces;

@end

@implementation ShareAppView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"推荐应用";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayForPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleCell *cell = (SampleCell*) [tableView dequeueReusableCellWithIdentifier:@"SampleCell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SampleCell" owner:[SampleCell class] options:nil];
        cell = (SampleCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.row];
    
    cell.labelForPlace.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Place"]];
    cell.labelForCountry.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Country"]];
    cell.imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    DetailViewController* detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    /*呔 对应下载列表*/
    NSMutableDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.row];
    detailViewController.dictForData = dict;
    detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    detailViewController.numberTag= 101 + indexPath.row;
    [self.navigationController pushViewController:detailViewController animated:NO];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
