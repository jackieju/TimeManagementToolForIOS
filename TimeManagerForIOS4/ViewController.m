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
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *Array = [SaveDefaults objectForKey:@"data"];
    NSDictionary* data = [Array objectAtIndex:0];
    if (data== NULL)
        listData = [[NSMutableArray alloc]init];
    else
        listData = data;
    eventsList = [[NSMutableArray alloc] init];
    NSDictionary* row = [[NSMutableDictionary alloc] init];
    [row setValue:[NSNumber numberWithInt:0] forKey:@"type"];
    [row setValue:@"breadfast" forKey:@"event"];
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
    [row setValue:@"breadfast" forKey:@"event"];
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
    [vEventList setDataSource:self];
    [vEventList setDelegate: self];
    [vEventList setTag:2];
    vEventList.frame = CGRectMake(10, 60, 250, 300);
    
    [vRecordList setDelegate:self];
    [vRecordList setDataSource:self];
    [vRecordList setTag:1];
    vRecordList.frame = CGRectMake(10, 120, 300, 300);
    
    game_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
//    vChooseEvents.frame = CGRectMake(10, 60, 300, 350);
    //    [vChooseEvents setBackgroundColor:[UIColor redColor]];
    //    [vChooseEvents setAlpha:0.6f];
    vChooseEvents.hidden = YES;
    
//    vCustomEvent.frame = CGRectMake(10, 0, 300, 300);
    vCustomEvent.hidden = YES;
    [vCustomEvent setBackgroundColor:[UIColor redColor]];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    // [nsdf2 setDateFormat:@"YYYY-MM-DD HH:mm:ss:SSSS"];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    [self.lbTime setText:t2];
}
- (IBAction)onBack:(id)sender {
    vChooseEvents.hidden = YES;
    
}

- (IBAction)onBackFromRecordEditor:(id)sender {
    vRecordEditor.hidden = YES;
}

- (IBAction)onOKFromRecordEditor:(id)sender {
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    NSString* v = tfTime.text;
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    NSDate* d = [nsdf2 dateFromString:v];
    
    [row setValue:[NSNumber numberWithInt:scRecordType.selectedSegmentIndex] forKey:@"type"];
    [row setValue:tfEvent.text forKey:@"event"];
    [row setValue:d forKey:@"time"];
    [listData replaceObjectAtIndex:currentRecordRow withObject:row];
    [self saveData];
    vRecordEditor.hidden = YES;
    vHome.hidden = NO;
    [vRecordList reloadData];
    tfCustomEvent.text = @"";
    
    [tfCustomEvent resignFirstResponder];
}

- (IBAction)onRecord:(id)sender {
    [ivRecordButton setImage:[UIImage imageNamed:@"button.png"]];
//    [self showEventView];
    //    vRecordList.hidden = YES;
    [self performSelector:@selector(showEventView) withObject:nil afterDelay:0.3];
//        [iapm requestProUpgradeProductData];
}

- (void) showEventView{
    vChooseEvents.hidden = NO;
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
            
            NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
            [nsdf2 setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shangha"]];
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
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
            if (event_type == 0){
//                [cell.textLabel setTextColor:[UIColor grayColor]];
                [cell.lbEvent setTextColor:[UIColor grayColor]];
            }else
//                [cell.textLabel setTextColor:[UIColor redColor]];
                [cell.lbEvent setTextColor:[UIColor redColor]];
        }
        else{
//            cell.textLabel.text = @"  ";
            cell.lbEvent.text = @"";
            cell.lbTime.text = @"";
            cell.lbDuration.text = @"";
            cell.ivImage.image = nil;
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
            [nsdf2 setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shangha"]];
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            //            [nsdf2 setDateFormat:@"YYYY-MM-DD HH:mm:ss"];
            //            NSString *t2=[nsdf2 stringFromDate:time];
            //            NSLog(@"TIME %@", t2);
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", event];
            
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"event_%@.png", event]]];
            if (event_type == 0){
                [cell.textLabel setTextColor:[UIColor grayColor]];
            }else
                [cell.textLabel setTextColor:[UIColor redColor]];
        }
        else{
            cell.textLabel.text = @"  ";
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

- (void) saveData{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *Array = [NSArray arrayWithObjects:listData, nil];
    [SaveDefaults setObject:Array forKey:@"data"];

}

- (IBAction)onDeleteRecord:(id)sender {
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
        if ( row  == [eventsList count]){
            vCustomEvent.hidden = NO;
            return;
        }else{
            NSDictionary* e = [eventsList objectAtIndex:row];
            NSString* event = [e valueForKey:@"event"];
            NSNumber* t = [e valueForKey:@"type"];
            
            NSDictionary* r = [[NSMutableDictionary alloc] init];
            NSDate *  d = [NSDate date];
            [r setValue:d forKey:@"time"];
            [r setValue:event forKey:@"event"];
            [r setValue:t  forKey:@"type"];
            [listData addObject:r];
            [vRecordList reloadData];
            [self saveData];
            vCustomEvent.hidden = YES;
            vChooseEvents.hidden = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listData count] inSection:0];
            [vRecordList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
        }
        
        
    }else if (tableView.tag == 1){ // did selection on record list
        if ( row  == [listData count]){
            vChooseEvents.hidden = NO;
            return;
        }else{

            vRecordEditor.hidden = NO;
            currentRecordRow = row;
            NSDictionary* o = [listData objectAtIndex:row];
            NSDate *d = [o valueForKey:@"time"];
            NSNumber* t = [o valueForKey:@"type"];
            NSString* str = [o valueForKey:@"event"];
            NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
            
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            
            [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
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


//- (CGFloat)tableView:(UITableView *)tableView 
//heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}


- (IBAction)onCreateCustomEvent:(id)sender {
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    
    [row setValue:[NSNumber numberWithInt:scEventType.selectedSegmentIndex] forKey:@"type"];
    [row setValue:tfCustomEvent.text forKey:@"event"];
    [eventsList addObject:row];
    vCustomEvent.hidden = YES;
    vChooseEvents.hidden = NO;
    [vEventList reloadData];
    tfCustomEvent.text = @"";
    
    [tfCustomEvent resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onTouchDownRecord:(id)sender {
//    ivRecordButton.animationRepeatCount = 1;
//    ivRecordButton.animationDuration = 0.3f;
//    [ivRecordButton startAnimating];
    [ivRecordButton setImage:[UIImage imageNamed:@"button2.png"]];
}
@end
