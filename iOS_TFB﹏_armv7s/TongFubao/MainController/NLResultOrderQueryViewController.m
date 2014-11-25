//
//  NLResultOrderQueryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLResultOrderQueryViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLTowLinesCell.h"
#import "NLUtils.h"

@interface NLResultOrderQueryViewController ()
{
    int _offset;
}

@property(nonatomic,strong)IBOutlet UIWebView* myWebView;
@property(nonatomic,strong)IBOutlet UITableView* myTableView;

@end

@implementation NLResultOrderQueryViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"查询结果";
    if (ResultOrderQuery_Web == self.myType)
    {
        [self showWebView];
    }
    else if (ResultOrderQuery_Table == self.myType)
    {
        [self showTablView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showWebView
{
    self.myTableView.hidden = YES;
    self.myWebView.hidden = NO;
    NSString* url = [[self.myArray objectAtIndex:0] objectForKey:@"apiurl"];
    [self loadURL:url];
}

-(void)showTablView
{
    self.myTableView.hidden = NO;
    self.myWebView.hidden = YES;
}

-(void)loadURL:(NSString*)url
{
    NSURLRequest* req=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.myWebView loadRequest:req];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLTowLinesCell *cell =nil;
    static NSString *kCellID = @"NLTowLinesCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    cell.myLabel2Behind.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.myLabel1.text = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    NSString* aStr = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"context"];
    [cell.myLabel2Fore setText:aStr];
    cell.myLabel2Fore.textColor = [UIColor blueColor];
    cell.myLabel2Fore.numberOfLines = 0;
//    [cell.myLabel2Fore setLineBreakMode:UILineBreakModeWordWrap];
    [cell.myLabel2Fore setLineBreakMode:NSLineBreakByWordWrapping];
    CGFloat contentWidth = 300;
    UIFont *font = [UIFont systemFontOfSize:14];
//    CGSize size = [aStr sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    CGSize size = [aStr sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    [cell.myLabel2Fore setFrame:CGRectMake(cell.myLabel2Fore.frame.origin.x, cell.myLabel2Fore.frame.origin.y, contentWidth, size.height+20)];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    CGFloat contentWidth = 270;
    UIFont *font = [UIFont systemFontOfSize:14];
    NSString *content = [[self.myArray objectAtIndex:row] objectForKey:@"context"];
//    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    int height = size.height+46;
    _offset = (height - 20)/2;
    return height;//size.height+46;
    
}

@end
