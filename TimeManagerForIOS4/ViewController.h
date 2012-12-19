//
//  ViewController.h
//  TimeManagerForIOS4
//
//  Created by juweihua on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "iAd/ADBannerView.h"
#import <iAd/iAd.h>

@interface ViewController : UIViewController<ADBannerViewDelegate>{
NSTimer* game_timer;
NSMutableArray *listData;
NSMutableArray *eventsList;
int selectedRowOfEventTable;
    int currentRecordRow;
    InAppPurchaseManager* iapm;
    UIWebView* wvAdTop;
    UIWebView* wvAdBottom;
    NSString *wh_server;
    int event_type_list_status;
    int custom_event_status; // status of editing the desc of custom event when create custom event
NSMutableDictionary *currentEditRow;
}
@property (strong, nonatomic) IBOutlet UILabel *lbErrorMsg;
@property (strong, nonatomic) IBOutlet UILabel *lbLoadingPreviousDay;
- (IBAction)onBeginEditCustomEventName:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnEditEventTypeList;
- (IBAction)onStartEditEventList:(id)sender;
- (IBAction)onTouchDownRecord:(id)sender;
- (IBAction)onBackFromCustomEvent:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *ivRecordButton;
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
@property (nonatomic, retain) id adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

- (void) saveData:(NSDate*)d;
- (IBAction)onDeleteRecord:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onBackFromRecordEditor:(id)sender;
- (IBAction)onOKFromRecordEditor:(id)sender;
- (IBAction)onRecord:(id)sender;
@end
