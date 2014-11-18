//
//  EducationExperienceViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "EducationExperienceViewController.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
@interface EducationExperienceViewController ()
{
    UITextField *schoolTextField;
    UITextField *majorTextField;
    
    NSMutableArray *filterArray;
    int filterNum;
    UIButton *degreeButton;
    //UIDatePicker *datePicker;
    UIButton *startTimeButton;
    UIButton *endTimeButton;
    
    //学位id
    NSString *degreeID;
    
    NSDate *date1; //起始时间
    NSDate *date2; //结束时间
}
@end

@implementation EducationExperienceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        filterArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"教育经历添加";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
        _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
        [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
        [_Button setTitle:@"删除" forState:UIControlStateNormal];
        _Button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_Button addTarget:self action:@selector(DeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
        self.navigationItem.rightBarButtonItem=rightbuttonitem;
        
    }

    
    //起止时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52/2, 160/2, 72/2)];
    timeLabel.text = @"时间：";
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:timeLabel];
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, timeLabel.frame.origin.y, 443.0/2, 72/2)];
    [timeImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    timeImageView.userInteractionEnabled = YES;
    [self.view addSubview:timeImageView];
    
    startTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startTimeButton.frame = CGRectMake(0, 0, 192/2, 72/2);
    [startTimeButton setTitleColor:[UIColor colorWithRed:141/255.0 green:167/255.0 blue:213/255.0 alpha:1] forState:UIControlStateNormal];
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        
        NSString *startStr = self.eduDiction[@"start_time"];
        [startTimeButton setTitle:startStr forState:UIControlStateNormal];
    }else
    {
        [startTimeButton setTitle:@"2014-04-22" forState:UIControlStateNormal];
    }
    
    startTimeButton.tag = 998;
    [startTimeButton addTarget:self action:@selector(timeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    startTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [timeImageView addSubview:startTimeButton];
    
    UILabel *zhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(196/2, 0, 40, 72/2)];
    zhiLabel.text = @"至";
    zhiLabel.backgroundColor = [UIColor clearColor];
    zhiLabel.font = [UIFont systemFontOfSize:16];
    [timeImageView addSubview:zhiLabel];
    
    endTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endTimeButton.frame = CGRectMake(252/2, 0, 192/2, 72/2);
    [endTimeButton setTitleColor:[UIColor colorWithRed:141/255.0 green:167/255.0 blue:213/255.0 alpha:1] forState:UIControlStateNormal];
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        
        NSString *endStr = self.eduDiction[@"end_time"];
        [endTimeButton setTitle:endStr forState:UIControlStateNormal];
    }else
    {
        [endTimeButton setTitle:@"2014-04-22" forState:UIControlStateNormal];
    }

    
    
    endTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    endTimeButton.tag = 999;
    [endTimeButton addTarget:self action:@selector(timeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [timeImageView addSubview:endTimeButton];
    
    //毕业学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeLabel.frame.origin.y+timeLabel.frame.size.height+20/2, 160/2, 72/2)];
    schoolLabel.text = @"毕业学校：";
    schoolLabel.backgroundColor = [UIColor clearColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    schoolLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:schoolLabel];
    
    UIImageView *schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, schoolLabel.frame.origin.y, 443.0/2, 72/2)];
    [schoolImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    schoolImageView.userInteractionEnabled = YES;
    [self.view addSubview:schoolImageView];
    
    schoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    schoolTextField.placeholder = @"请输入毕业学校";
    if ([self.editStyle isEqualToString:@"edit"]) {
        schoolTextField.text = self.eduDiction[@"graduate_institutions"];
    }
    schoolTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    schoolTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    schoolTextField.delegate = self;
    [schoolImageView addSubview:schoolTextField];
    
    //专业
    UILabel *majorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, schoolLabel.frame.origin.y+schoolLabel.frame.size.height+20/2, 160/2, 72/2)];
    majorLabel.text = @"专业：";
    majorLabel.backgroundColor = [UIColor clearColor];
    majorLabel.textAlignment = NSTextAlignmentRight;
    majorLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:majorLabel];
    
    UIImageView *majorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, majorLabel.frame.origin.y, 443.0/2, 72/2)];
    [majorImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    majorImageView.userInteractionEnabled = YES;
    [self.view addSubview:majorImageView];
    
    majorTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    majorTextField.placeholder = @"请输入专业名称";
    if ([self.editStyle isEqualToString:@"edit"]) {
        majorTextField.text = self.eduDiction[@"professional"];
    }
    majorTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    majorTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    majorTextField.delegate = self;
    [majorImageView addSubview:majorTextField];
    
    //学位
    UILabel *degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, majorLabel.frame.origin.y+majorLabel.frame.size.height+20/2, 160/2, 72/2)];
    degreeLabel.text = @"学位：";
    degreeLabel.backgroundColor = [UIColor clearColor];
    degreeLabel.textAlignment = NSTextAlignmentRight;
    degreeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:degreeLabel];
    
    degreeButton = [[UIButton alloc] initWithFrame:CGRectMake(164/2, degreeLabel.frame.origin.y, 443.0/2, 72/2)];
    [degreeButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_tableViewButtonBackground_03@2x"]forState:UIControlStateNormal];
    degreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [degreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([self.editStyle isEqualToString:@"edit"]) {
        [degreeButton setTitle:self.eduDiction[@"degree"] forState:UIControlStateNormal];
    }
    [degreeButton addTarget:self action:@selector(degreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:degreeButton];
    
    //取消
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(18/2, degreeLabel.frame.origin.y+degreeLabel.frame.size.height+64/2, 282/2, 75.0/2);
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"ProjectExperience_cancleButton_07@2x"] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(clickEduCancleButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleButton];
    //完成
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(340/2, degreeLabel.frame.origin.y+degreeLabel.frame.size.height+64/2, 282/2, 75.0/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_finishButton_13@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(clickEduFinishButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
    _filterTableView = [[TableViewWithBlock alloc] initWithFrame:CGRectMake(176/2, 452/2, 438/2, 70/2*4)];
    _filterTableView.backgroundColor = [UIColor whiteColor];
    _filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_filterTableView];
    _filterTableView.hidden = YES;
    
    [_filterTableView initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
     {
         return (NSInteger)filterArray.count;
         
     }setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
         SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
         if (!cell) {
             cell=[[SelectionCell alloc] init];
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         }
         UIImageView *cellXian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68/2, 438/2, 1)];
         cellXian.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:205/255.0 alpha:1];
         [cell.contentView addSubview:cellXian];
         cell.lb.textAlignment = NSTextAlignmentLeft;
         
//         cell.lb.textColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:205/255.0 alpha:1];
         cell.lb.textColor = [UIColor blackColor];
         cell.lb.font = [UIFont systemFontOfSize:15];
         [cell.lb setText:[filterArray objectAtIndex:indexPath.row][@"degree"]];
         return cell;
     } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
         SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
         switch (filterNum) {
             case 10:
                 [degreeButton setTitle:cell.lb.text forState:UIControlStateNormal];
                 degreeID = filterArray[indexPath.row][@"id"];
                 [degreeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                 break;
             default:
                 break;
         }
     }];

    
    
}
#pragma mark - 学位
-(void)degreeButtonClicked
{
    //获得学位
    [BCHTTPRequest getTheEducationDegreeUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            filterArray = resultDic[@"list"];
            [_filterTableView setContentOffset:CGPointMake(0,0) animated:NO];
            _filterTableView.frame = CGRectMake(168/2, 400/2, 438/2, 70/2*filterArray.count);
            if (filterNum == 10) {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame=_filterTableView.frame;
                    frame.size.height=0;
                    [_filterTableView setFrame:frame];
                } completion:^(BOOL finished){
                    filterNum = 0;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    filterNum = 10;
                    
                    
                    CGRect frame=_filterTableView.frame;
                    frame.size.height= 70/2*filterArray.count;
                    
                    [_filterTableView setFrame:frame];
                    _filterTableView.hidden = NO;
                    [_filterTableView reloadData];
                } completion:^(BOOL finished){
                    filterNum = 10;
                }];
            }

        }
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
    
}

-(void)timeButtonClicked:(UIButton *)sender
{
    [schoolTextField resignFirstResponder];
    [majorTextField resignFirstResponder];
    
    if (sender.tag == 998) {
        timeMark = @"start";
    }else if(sender.tag == 999)
    {
        timeMark = @"end";
    }

    bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    
    
    if (!datePicker) {
        //选择有效期 datePicker
        //datePicker上面的工具栏
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton1)];
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickDeleteButton3)];
        //doneButtonItem.tag = button.tag;
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 44)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        [toolbar setItems:[NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,doneButtonItem,nil]];
        [self.view addSubview:toolbar];
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 216)];
        datePicker.backgroundColor= [UIColor whiteColor];
        //datePicker.datePickerMode = UIDatePickerModeDateAndTime;
         [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
    }
    [self showDatePicker];
    [self.view bringSubviewToFront:toolbar];
    [self.view bringSubviewToFront:datePicker];
    
    
}
//动画 选择有效期时间
- (void)showDatePicker
{
    
    [UIView animateWithDuration:0.3 animations:^{
        toolbar.frame = CGRectMake(0, self.view.frame.size.height-216-76/2, 320, 76/2);
        datePicker.frame = CGRectMake(0, self.view.frame.size.height-216, 320, 216);
    }];
    
}
- (void)hideDatePicker
{
    [UIView animateWithDuration:0.4 animations:^{
        toolbar.frame = CGRectMake(0, self.view.frame.size.height, 320, 76/2);
        datePicker.frame = CGRectMake(0, self.view.frame.size.height, 320, 216);
        [bgView removeFromSuperview];
    }];
    
}
//取出年月日
- (void)dateChanged
{
    
    NSDate *selectedDate = [datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",[formatter stringFromDate:selectedDate]);
    
    if ([timeMark isEqualToString:@"start"]) {
        date1 = selectedDate;
        [startTimeButton setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:selectedDate]] forState:UIControlStateNormal];
    }else if ([timeMark isEqualToString:@"end"])
    {
        date2 = selectedDate;
        [endTimeButton setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:selectedDate]] forState:UIControlStateNormal];
    }
}
-(void)clickCancelButton1
{
    [self hideDatePicker];
}
-(void)clickDeleteButton3
{
    [self hideDatePicker];
    
    
    [self dateChanged];
    
}

//#pragma mark - 选择时间
//-(void)timeButtonClicked:(UIButton *)sender
//{
//    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 430/2, 320, 430)];
//    datePicker.tag = sender.tag;
//    // 设置时区
////    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    // 设置显示最大时间（此处为当前时间）
//    [datePicker setMaximumDate:[NSDate date]];
//    // 设置UIDatePicker的显示模式
//    [datePicker setDatePickerMode:UIDatePickerModeDate];
//    // 当值发生改变的时候调用的方法
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:datePicker];
//}

//-(void)datePickerValueChanged:(UIDatePicker*)sender
//{
//    // 获得当前UIPickerDate所在的时间
//    
//    NSDate *selectedDate = [sender date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSLog(@"%@",[formatter stringFromDate:selectedDate]);
//    if(sender.tag == 998)
//    {
//        [startTimeButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
//    }else if(sender.tag == 999)
//    {
//        [endTimeButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
//        
//    }
//}

//+(NSString*)dateToString:(NSString *)formatter date:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:formatter];
//    return[dateFormatter stringFromDate:date];
//}
#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [schoolTextField resignFirstResponder];
    [majorTextField resignFirstResponder];
    //[datePicker removeFromSuperview];
}

#pragma mark - 返回
-(void)backButtonClicked
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        ;
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除教育经历
- (void)DeleteButtonClicked
{
    [BCHTTPRequest dellTheEducationItemWithEducationID:self.eduDiction[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            //定义通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refushPersonResume" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - 取消
- (void)clickEduCancleButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 确定
- (void)clickEduFinishButton
{
    NSDate *now = [NSDate date];
    if ([schoolTextField.text length]==0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入毕业院校"];
    }else if ([majorTextField.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入专业名称"];
    }else if ([degreeButton.titleLabel.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入学位"];
    } else if(![date1 timeIntervalSinceDate:now])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"时间填写不合格"];
    }else if(![date2 timeIntervalSinceDate:now])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"时间填写不合格"];
    }else if ([date1 timeIntervalSinceDate:date2]>0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"时间填写不合格"];
    }else if ([self.editStyle isEqualToString:@"edit"]) {
        //修改
        [BCHTTPRequest modifyEducationItemWithEducationID:@"" WithCollegeName:schoolTextField.text WithProfessional:majorTextField.text WithDegree:degreeID WithStartTime:startTimeButton.titleLabel.text WithEndTime:endTimeButton.titleLabel.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else if ([self.editStyle isEqualToString:@"newAdd"])
    {
        //新建
        [BCHTTPRequest addEducationItemWithCollegeName:schoolTextField.text WithProfessional:majorTextField.text WithDegree:degreeID WithStartTime:startTimeButton.titleLabel.text WithEndTime:endTimeButton.titleLabel.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    //发送通知，个人简历页面刷新数据
    //定义通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refushPersonResume" object:nil];
}
@end
