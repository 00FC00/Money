//
//  AddressBookViewController.h
//  FaceBook
//
//  Created by HMN on 14-6-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>


@interface AddressBookViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    UITableView *searchAddressBookTableView;
    
    
    NSMutableArray *phoneArray;
    
    
    NSMutableDictionary *phoneDic;
    
    MFMessageComposeViewController *compose;
}

@end
