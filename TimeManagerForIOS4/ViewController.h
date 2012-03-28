//
//  ViewController.h
//  TimeManagerForIOS4
//
//  Created by juweihua on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
NSTimer* game_timer;
NSMutableArray *listData;
NSMutableArray *eventsList;
int selectedRowOfEventTable;
    int currentRecordRow;

}
@property (nonatomic,assign) int selectedRowOfEventTable;
@property (nonatomic,assign) int currentRecordRow;
@property (nonatomic, retain) NSTimer *game_timer;
@property (strong, nonatomic) IBOutlet UITextField *lbTime;
@property (strong, nonatomic) IBOutlet UITableView *vRecordList;
@property (nonatomic, retain) NSMutableArray *listData;
@property (strong, nonatomic) IBOutlet UITextField *tfCustomEvent;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scEventType;
- (IBAction)onCreateCustomEvent:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *vEventList;
@property (strong, nonatomic) IBOutlet UIView *vChooseEvents;   // the view contains the event list to be chosen
@property (strong, nonatomic) IBOutlet UIView *vHome;
@property (strong, nonatomic) IBOutlet UIView *vCustomEvent;    // the view to define new event
@property (strong, nonatomic) IBOutlet UIView *vRecordEditor;
@property (strong, nonatomic) IBOutlet UITextField *tfTime;
@property (strong, nonatomic) IBOutlet UITextField *tfEvent;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scRecordType;
- (IBAction)onBack:(id)sender;
- (IBAction)onBackFromRecordEditor:(id)sender;
- (IBAction)onOKFromRecordEditor:(id)sender;
- (IBAction)onRecord:(id)sender;
@end
