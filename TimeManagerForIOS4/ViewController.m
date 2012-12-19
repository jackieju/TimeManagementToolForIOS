//
//  ViewController.m
//  TimeManagerForIOS4
//
//  Created by juweihua on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ViewController.h"
#import "CustomCell.h"

@implementation ViewController
@synthesize vRecordEditor;
@synthesize tfTime;
@synthesize tfEvent;
@synthesize scRecordType;
@synthesize lbTime;
@synthesize vRecordList;
@synthesize listData;
@synthesize tfCustomEvent;
@synthesize scEventType;
@synthesize vEventList;
@synthesize vChooseEvents;
@synthesize vHome;
@synthesize vCustomEvent;
@synthesize selectedRowOfEventTable;
@synthesize currentRecordRow;
@synthesize ivRecordButton;
@synthesize adBannerView;
@synthesize adBannerViewIsVisible;
@synthesize btnEditEventTypeList;
@synthesize lbLoadingPreviousDay;
@synthesize lbErrorMsg;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    currentEditRow = NULL;
    
    CGRect rect = [self view].frame;
    rect.size = [UIScreen mainScreen].applicationFrame.size;
     
    [self view].frame = rect;
    
    vHome.frame = rect;
    vRecordEditor.frame = rect;
    vChooseEvents.frame = rect;
    
//    NSDate *  d = [NSDate date];
    NSDateFormatter *nsdf=[[NSDateFormatter alloc] init];
    [nsdf setDateStyle:NSDateFormatterShortStyle];
    // [nsdf2 setDateFormat:@"yyyy-MM-DD HH:mm:ss:SSSS"];
    [nsdf setDateFormat:@"yyyyMMdd"];
    NSString *t=[nsdf stringFromDate:[NSDate date]];
    
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *Array = [SaveDefaults objectForKey:[NSString stringWithFormat:@"data%@", t]];
    NSDictionary* data = [Array objectAtIndex:0];
    if (data== NULL)
        listData = [[NSMutableArray alloc]init];
    else
        listData = data;


    Array = [SaveDefaults objectForKey:@"event_types"];
    data = [Array objectAtIndex:0];
    if (data == NULL){
        eventsList = [[NSMutableArray alloc] init];
        NSDictionary* row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"breakfast" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"lunch" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"dinner" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"stroll" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"sports" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"rest" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:1] forKey:@"type"];
        [row setValue:@"work" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"move" forKey:@"event"];
        [eventsList addObject:row];
        row = [[NSMutableDictionary alloc] init];
        [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
        [row setValue:@"shopping" forKey:@"event"];
        [eventsList addObject:row];
        [self saveEventList];
    }
    else
        eventsList = data;
    
   

    [vEventList setDataSource:self];
    [vEventList setDelegate: self];
    [vEventList setTag:2];
    vEventList.frame = CGRectMake(10, 100, 300, [self view].frame.size.height-100-50);
    event_type_list_status = 0; // normal
//    [vEventList setEditing:YES animated:YES];  
    
    [vRecordList setDelegate:self];
    [vRecordList setDataSource:self];
    [vRecordList setTag:1];
    vRecordList.frame = CGRectMake(10, 120, 300, [self view].frame.size.height-120-50);
    lbLoadingPreviousDay.frame = CGRectMake(10, 110, 300, 20);
    lbLoadingPreviousDay.text = @"Loading more record...";
    lbLoadingPreviousDay.hidden = YES;
    
    game_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
//    vChooseEvents.frame = CGRectMake(10, 60, 300, 350);
    //    [vChooseEvents setBackgroundColor:[UIColor redColor]];
    //    [vChooseEvents setAlpha:0.6f];
    vChooseEvents.hidden = YES;
    
//    vCustomEvent.frame = CGRectMake(10, 0, 300, 300);
    vCustomEvent.hidden = YES;
//    [vCustomEvent setBackgroundColor:[UIColor redColor]];
    
    tfCustomEvent.delegate = self;
    lbTime.delegate = self;
    tfEvent.delegate = self;
    tfTime.delegate = self;
    
    [scEventType removeAllSegments];
    [scEventType insertSegmentWithTitle:@"REST" atIndex:0 animated:FALSE];
    [scEventType insertSegmentWithTitle:@"WORK" atIndex:1 animated:FALSE];
    [scRecordType removeAllSegments];
    [scRecordType insertSegmentWithTitle:@"REST" atIndex:0 animated:FALSE];
    [scRecordType insertSegmentWithTitle:@"WORK" atIndex:1 animated:FALSE];
    
//        iapm = [[InAppPurchaseManager alloc] init];
    NSArray* ar_img = [NSArray arrayWithObjects:[UIImage imageNamed:@"button.png"],
                    [UIImage imageNamed:@"button1.png"],
                       [UIImage imageNamed:@"button2.png"],
                       nil];
    [ivRecordButton setAnimationImages:ar_img];

    UIImageView * banner = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,50)];
    banner.image = [UIImage imageNamed:@"banner.png"];
    [[self view] addSubview:banner];

    

    
    wh_server = @"wh.joyqom.com";
//    wh_server = @"192.168.0.10";
    wvAdTop = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    wvAdTop.backgroundColor = [UIColor clearColor];
    wvAdTop.opaque = NO; 
    [wvAdTop loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ad_tm.html?s=1", wh_server]]]];
    [[self view] addSubview:wvAdTop];
    
    [self createAdBannerView];
    
    wvAdBottom = [[UIWebView alloc] initWithFrame:CGRectMake(0, [self view].frame.size.height-50 , 320, 50)];
    wvAdBottom.backgroundColor = [UIColor clearColor];
    wvAdBottom.opaque = NO;
    [wvAdBottom loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ad_tm2.html?s=2", wh_server]]]];
    [[self view] addSubview:wvAdBottom];
    wvAdBottom.hidden = YES;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listData count] inSection:0];
    [vRecordList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
}

- (void)viewDidUnload
{
    [self setLbTime:nil];
    [self setVRecordList:nil];
    
    [self setVEventList:nil];
    [self setTfCustomEvent:nil];
    [self setScEventType:nil];
    [self setVChooseEvents:nil];
    [self setVCustomEvent:nil];
    [self setVHome:nil];
    [self setTfTime:nil];
    [self setTfEvent:nil];
    [self setVRecordEditor:nil];
    [self setScRecordType:nil];
    [self setIvRecordButton:nil];
    [self setBtnEditEventTypeList:nil];
    [self setLbLoadingPreviousDay:nil];
    [self setLbErrorMsg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self refresh];
    [self fixupAdView:[UIDevice currentDevice].orientation];
    [wvAdTop loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ad_tm.html?s=1", wh_server]]]];
    [wvAdBottom loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ad_tm2.html?s=2", wh_server]]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (void) onTimer
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    // [nsdf2 setDateFormat:@"yyyy-MM-DD HH:mm:ss:SSSS"];
    [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    [self.lbTime setText:t2];
}

- (void) hideChooseEvent{
   
    [UIView animateWithDuration:0.2f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect r = vChooseEvents.frame;
                        r.origin.x = 0-r.size.width;
                         vChooseEvents.frame = r;
                     }
                     completion:^(BOOL finished){
                             vChooseEvents.hidden = YES;
                     }];
    

}
- (void) showChooseEvent{
    vChooseEvents.hidden = NO;
    CGRect r = vChooseEvents.frame;
    r.origin.x = 0-r.size.width;
    vChooseEvents.frame = r;
    [UIView animateWithDuration:0.2f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect r = vChooseEvents.frame;
                         r.origin.x = 0;
                         vChooseEvents.frame = r;
                     }
                     completion:^(BOOL finished){
                      
                     }];
          
}
- (IBAction)onBack:(id)sender {
//    vChooseEvents.hidden = YES;
    [self hideChooseEvent];
    
}

- (IBAction)onBackFromRecordEditor:(id)sender {
    [UIView animateWithDuration:0.2f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect r = vRecordEditor.frame;
                         r.origin.x = 0-r.size.width;
                         vRecordEditor.frame = r;
                     }
                     completion:^(BOOL finished){
                            vRecordEditor.hidden = YES;
                     }];
 
    vHome.hidden = NO;
    [vRecordList reloadData];
    tfCustomEvent.text = @"";
    [tfCustomEvent resignFirstResponder];
    [tfTime resignFirstResponder];
    [tfEvent resignFirstResponder];
}

- (IBAction)onOKFromRecordEditor:(id)sender {
//    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *row = currentEditRow;
    if (row){
        NSString* v = tfTime.text;
        NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
        
    //    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
        [nsdf2 setTimeZone:[NSTimeZone localTimeZone]];
        [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate* d = [nsdf2 dateFromString:v];
        
        if (d){
            [row setValue:[NSNumber numberWithInt:scRecordType.selectedSegmentIndex] forKey:@"type"];
            [row setValue:tfEvent.text forKey:@"event"];
            [row setValue:d forKey:@"time"];

            
        //    [listData replaceObjectAtIndex:currentRecordRow withObject:row];
            [self saveData:d];
        }else{
            lbErrorMsg.text = @"Invalid Time";
            return;
        }
        currentEditRow = NULL;
    }
    vRecordEditor.hidden = YES;
    vHome.hidden = NO;    
    [vRecordList reloadData];
    tfCustomEvent.text = @"";
    [tfTime resignFirstResponder];
    [tfEvent resignFirstResponder];
}

- (IBAction)onRecord:(id)sender {
    [ivRecordButton setImage:[UIImage imageNamed:@"button.png"]];
//    [self showEventView];
    //    vRecordList.hidden = YES;
    [self performSelector:@selector(showEventView) withObject:nil afterDelay:0.3];
//        [iapm requestProUpgradeProductData];
}

- (void) showEventView{
//    vChooseEvents.hidden = NO;
    [self showChooseEvent];
}

// table view delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
        return [listData count] + 1;
    else
        return [eventsList count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
           NSUInteger row = [indexPath row];
    
       if (tableView.tag ==1 ){
           static BOOL nibsRegistered = NO;
           if (!nibsRegistered) {
               UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
               [tableView registerNib:nib forCellReuseIdentifier:@"CustomCellIdentifier"];
               nibsRegistered = YES;
           }
           CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellIdentifier"];
           
           

        UIImage *image = [UIImage imageNamed:@"button.png"];
        UIImage *image2 = [UIImage imageNamed:@"button2.png"];
/*        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 30, 30)];
        iv.image = image;
        cell.accessoryView = iv;
        [cell.textLabel setContentMode:UIViewContentModeLeft];
//        cell.imageView.frame = CGRectMake(250, 0, 50, 50) ;
//        cell.imageView.image = image;
//        cell.imageView.highlightedImage = image2;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.frame = CGRectMake(0,0,200,30);
*/
        cell.ivImage.image = image;
//        cell.textLabel.backgroundColor = [UIColor redColor];
        NSUInteger row = [indexPath row];
        if (row < [listData count]){
            NSDictionary *record = [listData objectAtIndex:row];
            NSDate* time = [record valueForKey:@"time"];
            NSString* event = [record valueForKey:@"event"];
            int event_type = [[record valueForKey:@"type"] intValue];
            id index = [record valueForKey:@"index"];
            int event_type_index = 0;
            if (index != NULL && index != [NSNull null])
                event_type_index = [index intValue];
            NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
            
            [nsdf2 setTimeZone:[NSTimeZone localTimeZone]];
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *t2=[nsdf2 stringFromDate:time];
            NSLog(@"TIME %@", t2);
            
            float hour = 0;
            if ( row > 0){
                NSDictionary *record = [listData objectAtIndex:row-1];
                NSDate* time2 = [record valueForKey:@"time"];
                NSTimeInterval dd = [time timeIntervalSinceDate:time2];
                NSLog(@"Time interval %f", dd);
                hour = dd /3600.00;
            }
//            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%.1fH %@ %@", hour, t2, event];
            cell.lbEvent.text = event;
            cell.lbTime.text = t2;
            cell.lbDuration.text = [NSString stringWithFormat:@"%.1fH", hour ];
            cell.ivImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"event_%d.png", event_type_index]];
            if (event_type == 0){
//                [cell.textLabel setTextColor:[UIColor grayColor]];
                [cell.lbEvent setTextColor:[UIColor grayColor]];
            }else
//                [cell.textLabel setTextColor:[UIColor redColor]];
                [cell.lbEvent setTextColor:[UIColor redColor]];
        }
        else{
//            cell.textLabel.text = @"  ";
            cell.lbEvent.text = @"new record";
            [cell.lbEvent setTextColor:[UIColor orangeColor]];
            cell.lbTime.text = @"";
            cell.lbDuration.text = @"";
            cell.ivImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"new.png", 0]];
        }
        //        cell.textLabel.font = [UIFont boldSystemFontOfSize:30];
        
//        cell.textLabel.textAlignment = UITextAlignmentCenter;
             return cell;
    }
    else  if (tableView.tag == 2){
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        NSUInteger row = [indexPath row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIdentifier];

        if (cell == nil) {
#ifdef __IPHONE_3_0
            // Other styles you can try
            // UITableViewCellStyleSubtitle
            // UITableViewCellStyleValue1
            // UITableViewCellStyleValue2
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: SimpleTableIdentifier] ;
            
            
#else
            cell = [[UITableViewCell alloc] initWithFrame::CGRectZero
                                          reuseIdentifier: SimpleTableIdentifier] ;
#endif
            
        }
        UIImage *image = [UIImage imageNamed:@"star.png"];
        UIImage *image2 = [UIImage imageNamed:@"star2.png"];
        cell.imageView.image = image;
        cell.imageView.highlightedImage = image2;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
 
        if (row < [eventsList count]){
            NSDictionary *record = [eventsList objectAtIndex:row];
            NSDate* time = [record valueForKey:@"time"];
            NSString* event = [record valueForKey:@"event"];
            int event_type = [[record valueForKey:@"type"] intValue];
            
            NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
            [nsdf2 setTimeZone:[NSTimeZone localTimeZone]];
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            //            [nsdf2 setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
            //            NSString *t2=[nsdf2 stringFromDate:time];
            //            NSLog(@"TIME %@", t2);
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", event];
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"event_%d.png", row+1]]];
            CGRect rect = iv.frame;
            rect.size.height = cell.frame.size.height;
            rect.size.width = 60;
            iv.frame = rect;
            cell.accessoryView = iv;
            if (event_type == 0){
                [cell.textLabel setTextColor:[UIColor grayColor]];
            }else
                [cell.textLabel setTextColor:[UIColor redColor]];
        }
        else{
            cell.textLabel.text = @"new";
            [cell.textLabel setTextColor:[UIColor orangeColor]];
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"event_%d.png", 0]]];
            CGRect rect = iv.frame;
            rect.size.height = cell.frame.size.height;
            rect.size.width = 60;
            iv.frame = rect;
            cell.accessoryView = iv;
        }
        //        cell.textLabel.font = [UIFont boldSystemFontOfSize:30];
        
        cell.textLabel.textAlignment = UITextAlignmentCenter;
          return cell;
    }
    

  
    
    
    
    
    
}

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger row = [indexPath row];
//    return row;
//}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSUInteger row = [indexPath row];
    //    if (row == 0)
    //        return nil;
    
    return indexPath; 
}
-(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2

{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
    
}
- (void) saveData:(NSDate*) d{
    
    // generete name
    NSDateFormatter *nsdf=[[NSDateFormatter alloc] init];
    [nsdf setDateStyle:NSDateFormatterShortStyle];
    // [nsdf2 setDateFormat:@"yyyy-MM-DD HH:mm:ss:SSSS"];
    [nsdf setDateFormat:@"yyyyMMdd"];
    NSString *t=[nsdf stringFromDate:[NSDate date]];
    
    // pick all record in the same day
    NSMutableArray * list = [[NSMutableArray alloc] init];
    for (int i = 0; i< listData.count; i++){
        NSMutableDictionary* row = [listData objectAtIndex:i];
        NSDate* time = [row valueForKey:@"time"];
        if (time && [self isSameDay:d date2:time]){
            [list addObject:row];
        }
    }
    
    // save 
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"data%@", t];
    NSArray *Array = [NSArray arrayWithObjects:list, nil];
    [SaveDefaults setObject:Array forKey:key];
    
}
- (void) saveEventList{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *Array = [NSArray arrayWithObjects:eventsList, nil];
    [SaveDefaults setObject:Array forKey:@"event_types"];

    
}
- (IBAction)onDeleteRecord:(id)sender {
    NSDictionary* o = [listData objectAtIndex:currentRecordRow];
    NSDate *d = [o valueForKey:@"time"];
    [listData removeObjectAtIndex:currentRecordRow];
    [self saveData:d];
    
    vRecordEditor.hidden = YES;
    vHome.hidden = NO;
    [vRecordList reloadData];
    tfCustomEvent.text = @"";
    [tfCustomEvent resignFirstResponder];
    [tfTime resignFirstResponder];
    [tfEvent resignFirstResponder];
}

/*******************************
    table view delegate method
 *******************************/
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
        lbLoadingPreviousDay.hidden = NO;
        [self performSelector:@selector(loadPreviousDay) withObject:nil afterDelay:0.5f ];
    }
}

- (void) loadPreviousDay{
    NSDate * dd = [NSDate date];
    if ([listData count] > 0){
        NSMutableDictionary *row = [listData objectAtIndex:0];
        dd = [row valueForKey:@"time"];
        
    }
        

    if (dd){
        NSDate *  d = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[dd timeIntervalSinceReferenceDate] - 24*3600];
        NSDateFormatter *nsdf=[[NSDateFormatter alloc] init];
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        // [nsdf2 setDateFormat:@"yyyy-MM-DD HH:mm:ss:SSSS"];
        [nsdf setDateFormat:@"yyyyMMdd"];
        NSString *t=[nsdf stringFromDate:d];
        
        NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *Array = [SaveDefaults objectForKey:[NSString stringWithFormat:@"data%@", t]];
        NSMutableArray* data = [Array objectAtIndex:0];
        if (data != NULL){
//                for (id row in data){
//                    listData insertObject:row atIndex:￼
//                }
            [data addObjectsFromArray:listData];
            listData = data;
            [vRecordList reloadData];
        }

    }

    lbLoadingPreviousDay.hidden = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (game_status != 1){
    //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //        return;
    //    }
    NSUInteger row = [indexPath row];
    //    NSString *rowValue;
    

    
    if (tableView.tag == 2){ // did select on event type list
            selectedRowOfEventTable  = row;
        if ( row  == [eventsList count]){ // create new event
            CGRect r = vCustomEvent.frame;
            r.origin.x = 0-r.size.width;
            vCustomEvent.frame = r;
            vCustomEvent.hidden = NO;
            
            [UIView animateWithDuration:0.2f
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 CGRect r = vCustomEvent.frame;
                                 r.origin.x = 0;
                                 vCustomEvent.frame = r;
                             }
                             completion:^(BOOL finished){
                                tfCustomEvent.text = @"new event";
                                [tfCustomEvent setTextColor:[UIColor grayColor]];
                                custom_event_status = 0; // initialized
                             }];
//            return;
        }else{
            NSDictionary* e = [eventsList objectAtIndex:row];
            NSString* event = [e valueForKey:@"event"];
            NSNumber* t = [e valueForKey:@"type"];
            
            NSDictionary* r = [[NSMutableDictionary alloc] init];
            NSDate *  d = [NSDate date];
            [r setValue:d forKey:@"time"];
            [r setValue:event forKey:@"event"];
            [r setValue:t  forKey:@"type"];
            [r setValue:[NSNumber numberWithInt:(row+1) ] forKey:@"index"];
            [listData addObject:r];
            [vRecordList reloadData];
            [self saveData:d];
            vCustomEvent.hidden = YES;
//            vChooseEvents.hidden = YES;
            [self hideChooseEvent];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listData count] inSection:0];
            [vRecordList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
        }
        
        
    }else if (tableView.tag == 1){ // did selection on record list
        if ( row  == [listData count]){ // new record
//            vChooseEvents.hidden = NO;
            [self showChooseEvent];
            return;
        }else{  // edit existing record
            lbErrorMsg.text = @"";
            vRecordEditor.hidden = NO;
            
            CGRect r = vRecordEditor.frame;
            r.origin.x = 0-r.size.width;
            vRecordEditor.frame = r;
            
            [UIView animateWithDuration:0.2f
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                CGRect r = vRecordEditor.frame;
                                 r.origin.x = 0;
                                 vRecordEditor.frame = r;
                             }
                             completion:^(BOOL finished){
                             }];
            
            currentRecordRow = row;
            NSDictionary* o = [listData objectAtIndex:row];
            currentEditRow = o;
            NSDate *d = [o valueForKey:@"time"];
            NSNumber* t = [o valueForKey:@"type"];
            NSString* str = [o valueForKey:@"event"];
            NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
            
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            
            [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *t2=[nsdf2 stringFromDate:d];
            
            tfTime.text = t2;
            tfEvent.text = str;
            
            [scRecordType setSelectedSegmentIndex:[t intValue]];
        }
    }
    
    
    
    /*  NSString *message = [[NSString alloc] initWithFormat:
     @"You selected %@", rowValue];
     UIAlertView *alert = [[UIAlertView alloc] 
     initWithTitle:@"Row Selected!"
     message:message 
     delegate:nil 
     cancelButtonTitle:@"Yes I Did" 
     otherButtonTitles:nil];
     [alert show];
     
     [message release];
     [alert release];*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2)
        return UITableViewCellEditingStyleDelete;
        else
    return UITableViewCellEditingStyleNone;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger row = [indexPath row];
        if (row < eventsList.count){
            [eventsList removeObjectAtIndex:row];
            [self saveEventList];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
//- (CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}


- (IBAction)onCreateCustomEvent:(id)sender {
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    NSString* content = tfCustomEvent.text;
 
    if (custom_event_status != 0 && [content length] != 0){
        [row setValue:[NSNumber numberWithInt:scEventType.selectedSegmentIndex] forKey:@"type"];
        [row setValue:content forKey:@"event"];
        [eventsList addObject:row];
        [self saveEventList];
    }
    vCustomEvent.hidden = YES;
//    vChooseEvents.hidden = NO;
    [self showChooseEvent];
    [vEventList reloadData];
    tfCustomEvent.text = @"";
    
    [tfCustomEvent resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) updateEditButton{
    if (event_type_list_status == 0){
        [vEventList setEditing:YES animated:YES];
        [btnEditEventTypeList setTitle:@"done" forState:UIControlStateNormal] ;
        event_type_list_status = 1;
    }
    else{
        [vEventList setEditing:NO animated:YES];
        [btnEditEventTypeList setTitle:@"edit" forState:UIControlStateNormal] ;
        event_type_list_status = 0;
    }
}
- (IBAction)onStartEditEventList:(id)sender {
    [self performSelector:@selector(updateEditButton)];

}

- (IBAction)onTouchDownRecord:(id)sender {
//    ivRecordButton.animationRepeatCount = 1;
//    ivRecordButton.animationDuration = 0.3f;
//    [ivRecordButton startAnimating];
    [ivRecordButton setImage:[UIImage imageNamed:@"button2.png"]];
}

- (IBAction)onBackFromCustomEvent:(id)sender {
    [UIView animateWithDuration:0.2f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect r = vCustomEvent.frame;
                         r.origin.x = 0-r.size.width;
                         vCustomEvent.frame = r;
                     }
                     completion:^(BOOL finished){
                         vCustomEvent.hidden = YES;
                     }];
    [tfCustomEvent resignFirstResponder];
}

/******************
  iAD Function
*******************/
- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    return 50;
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        return 32;
//    } else {
//        return 50;
//    }
}

- (int)getBannerHeight {
    return 50;
//    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}
- (void)createAdBannerView {
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        adBannerView = [[classAdBannerView alloc]
                              initWithFrame:CGRectMake(0, [self view].frame.size.height-50, 320, 50)] ;
        [adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                          ADBannerContentSizeIdentifier320x50,
                                                          ADBannerContentSizeIdentifier480x32, nil]];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifier480x32];
        } else {
            [adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifier320x50];
        }
        [adBannerView setFrame:CGRectOffset([adBannerView frame], 0,
                                             -50)];
        [adBannerView setDelegate:self];
        
        [self.view addSubview:adBannerView];        
    }
}
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    if (adBannerView != nil) {
//        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
//            [adBannerView setCurrentContentSizeIdentifier:
//             ADBannerContentSizeIdentifier480x32];
//        } else {
//            [adBannerView setCurrentContentSizeIdentifier:
//             ADBannerContentSizeIdentifier320x50];
//        }
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (adBannerViewIsVisible) { // show it with animation
            CGRect adBannerViewFrame = [adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = [self view].frame.size.height-50;
            [adBannerView setFrame:adBannerViewFrame];
//            CGRect contentViewFrame = adBannerView.frame;
//            contentViewFrame.origin.y =
//            [self getBannerHeight:toInterfaceOrientation];
//            contentViewFrame.size.height = self.view.frame.size.height -
//            [self getBannerHeight:toInterfaceOrientation];
//            adBannerView.frame = contentViewFrame;
        } else {    // hide it with animation
            CGRect adBannerViewFrame = [adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = [self view].frame.size.height-50;
            [adBannerView setFrame:adBannerViewFrame];
//            CGRect contentViewFrame = _contentView.frame;
//            contentViewFrame.origin.y = 0;
//            contentViewFrame.size.height = self.view.frame.size.height;
//            _contentView.frame = contentViewFrame;
        }
        [UIView commitAnimations];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fixupAdView:toInterfaceOrientation];
}
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!adBannerViewIsVisible) {
        adBannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
        wvAdBottom.hidden = YES;;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd error:%@", error.description);
    if (adBannerViewIsVisible)
    {
        adBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
        
        wvAdBottom.hidden = NO;
    }
}
- (IBAction)onBeginEditCustomEventName:(id)sender {
    if (custom_event_status == 0){
        tfCustomEvent.text = @"";
        custom_event_status = 1;
        [tfCustomEvent setTextColor:[UIColor blackColor]];
    }
}
@end
