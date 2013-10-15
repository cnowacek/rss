//
//  CTViewController.m
//  RSS
//
//  Created by Forest on 10/10/13.
//  Copyright (c) 2013 Forest. All rights reserved.
//

#import "CTAppDelegate.h"
#import "CTViewController.h"
#import "CTWebViewController.h"

@interface CTViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CTWebViewController *webViewController;
@property (weak, nonatomic) IBOutlet UIButton *addRssButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *rssEntries;
@property (strong, nonatomic) NSXMLParser *xml;
@property (strong, nonatomic) NSMutableDictionary *rssEntry;
@property (strong, nonatomic) NSMutableString *curVal;

@end

@implementation CTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"RSS Reeder";
        self.curVal = nil;
        self.webViewController = [[CTWebViewController alloc] init];
        self.rssEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Sett he navigation bar to opaque so that it doesnt cover the top of the view
    self.navigationController.navigationBar.translucent = NO;
    self.inputField.text = @"http://feeds.feedburner.com/TechCrunch/";
    [self loadURLFromInput:self.inputField];

    // Set up the pull to refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.tableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadURLFromInput:self.inputField];
}

-(void)addEntries:(NSString *)str_url {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *url = [NSURL URLWithString:str_url];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        // silently fail for now
        if([data length] == 0 || error != nil)
            return;
        
        self.xml = [[NSXMLParser alloc] initWithData:data];
        [self.xml setDelegate:self];
        [self.xml parse];
    }];
}

- (void)loadURLFromInput:(UITextField *)textField {
    [self addEntries:textField.text];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self loadURLFromInput:self.inputField];
    return NO;
}

#pragma mark - XML parser delegate

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // begin building for item, ignore everything else
    if([elementName isEqualToString:@"item"]) {
        self.rssEntry = [[NSMutableDictionary alloc] init];
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!self.curVal)
        self.curVal = [[NSMutableString alloc] initWithString:string];
    else
        [self.curVal appendString:string];
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    // done parsing feed
    // NOTE: Blocks retain their references (self). Use a weak reference instead
    __weak CTViewController *wself = self;
    if([elementName isEqualToString:@"channel"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableView reloadData];
            [wself.refreshControl endRefreshing];
        });
        return;
    }
    
    // done parsing entry
    else if([elementName isEqualToString:@"item"]) {
        NSString *title = [self.rssEntry[@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *link = [self.rssEntry[@"link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self.rssEntries addObject:@[title, link]];
        self.rssEntry = nil;
    }
    
    // update current entry
    else if(self.rssEntry) {
        if([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"link"])
            [self.rssEntry setObject:self.curVal forKey:elementName];
    }
    
    self.curVal = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rssEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.rssEntries[indexPath.row][0];
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row immedietly so that it doesnt stay highlighted forever
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.webViewController loadSite:self.rssEntries[indexPath.row][1]];
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

@end
