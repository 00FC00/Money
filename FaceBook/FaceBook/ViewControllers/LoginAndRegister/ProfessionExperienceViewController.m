//
//  ProfessionExperienceViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ProfessionExperienceViewController.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
@interface ProfessionExperienceViewController ()
{
    UIScrollView *backgroundScrollView;
    UITextField *companyTextField;//公司名称
    UITextField *projectOfficeTextField;//部门名称
    UITextField *projectNameTextField;//线条领域
    UITextField *workPlaceTextField;//工作地点
    
   
    UIButton *startTimeButton;
    UIButton *endTimeButton;
    
    UIDatePicker *datePicker;
    UIView *bgView;
    UIToolbar *toolbar;
    NSString *timeMark;
    
    NSDate *date1; //起始时间
    NSDate *date2; //结束时间
}
@end

@implementation ProfessionExperienceViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"职业经历添加";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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

    
    //ScrollView背景
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height)];
    backgroundScrollView.delegate = self;
    backgroundScrollView.contentSize = CGSizeMake(320, 1300/2);
    backgroundScrollView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
    [self.view addSubview:backgroundScrollView];
    
    //公司名称
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52/2, 160/2, 72/2)];
    companyLabel.text = @"公司名称：";
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.textAlignment = NSTextAlignmentRight;
    companyLabel.font = [UIFont systemFontOfSize:15];
    [backgroundScrollView addSubview:companyLabel];
    
    UIImageView *companyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, companyLabel.frame.origin.y, 443.0/2, 72/2)];
    [companyImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    companyImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:companyImageView];
    
    companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    companyTextField.placeholder = @"请输入公司名称";
    if ([self.editStyle isEqualToString:@"edit"]) {
        companyTextField.text = self.jobDiction[@"com_name"];
    }
    companyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    companyTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    companyTextField.delegate = self;
    [companyImageView addSubview:companyTextField];
    
    //部门名称
    UILabel *projectOfficeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, companyLabel.frame.origin.y+companyLabel.frame.size.height+20/2, 160/2, 72/2)];
    projectOfficeLabel.text = @"部门名称：";
    projectOfficeLabel.backgroundColor = [UIColor clearColor];
    projectOfficeLabel.textAlignment = NSTextAlignmentRight;
    projectOfficeLabel.font = [UIFont systemFontOfSize:15];
    [backgroundScrollView addSubview:projectOfficeLabel];
    
    UIImageView *projectOfficeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, projectOfficeLabel.frame.origin.y, 443.0/2, 72/2)];
    [projectOfficeImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    projectOfficeImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:projectOfficeImageView];
    
    projectOfficeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    projectOfficeTextField.placeholder = @"请填写部门名称";
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        projectOfficeTextField.text = self.jobDiction[@"department_name"];
    }

    projectOfficeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    projectOfficeTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    projectOfficeTextField.delegate = self;
    [projectOfficeImageView addSubview:projectOfficeTextField];
    
    //线条领域
    UILabel *projectNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, projectOfficeLabel.frame.origin.y+projectOfficeLabel.frame.size.height+20/2, 160/2, 72/2)];
    projectNameLabel.text = @"职务：";
    projectNameLabel.backgroundColor = [UIColor clearColor];
    projectNameLabel.textAlignment = NSTextAlignmentRight;
    projectNameLabel.font = [UIFont systemFontOfSize:15];
    [backgroundScrollView addSubview:projectNameLabel];
    
    UIImageView *projectNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, projectNameLabel.frame.origin.y, 443.0/2, 72/2)];
    [projectNameImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    projectNameImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:projectNameImageView];
    
    projectNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    projectNameTextField.placeholder = @"请填写条线领域";
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        projectNameTextField.text = self.jobDiction[@"work_field"];
    }
    
    projectNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    projectNameTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    projectNameTextField.delegate = self;
    [projectNameImageView addSubview:projectNameTextField];
    
    //项目名称
    UILabel *projectDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, projectNameLabel.frame.origin.y+projectNameLabel.frame.size.height+20/2, 160/2, 72/2)];
    projectDetailLabel.text = @"岗位介绍：";
    projectDetailLabel.backgroundColor = [UIColor clearColor];
    projectDetailLabel.textAlignment = NSTextAlignmentRight;
    projectDetailLabel.font = [UIFont systemFontOfSize:15];
    [backgroundScrollView addSubview:projectDetailLabel];
    
    //内容
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(18/2, projectDetailLabel.frame.origin.y+projectDetailLabel.frame.size.height+20/2,600/2, 344/2)];
    _contentTextView.textColor = [UIColor grayColor];
    _contentTextView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    _contentTextView.delegate = self;
    _contentTextView.font = [UIFont systemFontOfSize:15];
    _contentTextView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:216/255.0 blue:227/255.0 alpha:1].CGColor;
    _contentTextView.layer.borderWidth = 1;
    [_contentTextView.layer setMasksToBounds:YES];
    _contentTextView.layer.cornerRadius = 6;
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        _contentTextView.text = self.jobDiction[@"job_description"];
    }

    
    [backgroundScrollView addSubview:_contentTextView];
    
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 580/2, 20)];
    _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeHolderLabel.font = [UIFont systemFontOfSize:15.0f];
    _placeHolderLabel.textColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1];
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    //_placeHolderLabel.alpha = 0;
    _placeHolderLabel.numberOfLines = 0;
    _placeHolderLabel.tag = 999;
    if ([self.editStyle isEqualToString:@"edit"]) {
        _placeHolderLabel.text = @"";
    }else
    {
        _placeHolderLabel.text = @"请填写岗位介绍...";
    }
    
    
    [_contentTextView addSubview:_placeHolderLabel];
    if ([[_placeHolderLabel text] length] == 0) {
        [[_placeHolderLabel viewWithTag:999] setAlpha:1];
    }
    //工作地点
    UILabel *workPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentTextView.frame.origin.y+_contentTextView.frame.size.height+20/2, 160/2, 72/2)];
    workPlaceLabel.text = @"工作地点：";
    workPlaceLabel.backgroundColor = [UIColor clearColor];
    workPlaceLabel.textAlignment = NSTextAlignmentRight;
    workPlaceLabel.font = [UIFont systemFontOfSize:15];
    [backgroundScrollView addSubview:workPlaceLabel];
    
    UIImageView *workPlaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, workPlaceLabel.frame.origin.y, 443.0/2, 72/2)];
    [workPlaceImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    workPlaceImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:workPlaceImageView];
    
    workPlaceTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    workPlaceTextField.placeholder = @"请填写工作地点";
    if ([self.editStyle isEqualToString:@"edit"]) {
        workPlaceTextField.text = self.jobDiction[@"work_place"];
    }
    workPlaceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    workPlaceTextField.font = [UIFont systemFontOfSize:14];
    //    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    workPlaceTextField.delegate = self;
    [workPlaceImageView addSubview:workPlaceTextField];
    
    //起止时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, workPlaceLabel.frame.origin.y+workPlaceLabel.frame.size.height+20/2, 160/2, 72/2)];
    timeLabel.text = @"起止时间：";
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [backgroundScrollView addSubview:timeLabel];
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, timeLabel.frame.origin.y, 443.0/2, 72/2)];
    [timeImageView setImage:[UIImage imageNamed:@"detailInfo_companyBackground_06@2x"]];
    timeImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:timeImageView];
    
    startTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startTimeButton.frame = CGRectMake(0, 0, 192/2, 72/2);
    [startTimeButton setTitleColor:[UIColor colorWithRed:141/255.0 green:167/255.0 blue:213/255.0 alpha:1] forState:UIControlStateNormal];
    
    if ([self.editStyle isEqualToString:@"edit"]) {
        NSString *startStr = self.jobDiction[@"start_time"];
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
        NSString *endStr = self.jobDiction[@"end_time"];
       [endTimeButton setTitle:endStr forState:UIControlStateNormal];
    }else
    {
        [endTimeButton setTitle:@"2014-04-22" forState:UIControlStateNormal];
    }

    
    
    endTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    endTimeButton.tag = 999;
    [endTimeButton addTarget:self action:@selector(timeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [timeImageView addSubview:endTimeButton];
    //取消
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(18/2, timeLabel.frame.origin.y+timeLabel.frame.size.height+64/2, 282/2, 75.0/2);
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"ProjectExperience_cancleButton_07@2x"] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(clickjobCancleButton) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:cancleButton];
    //完成
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(340/2, timeLabel.frame.origin.y+timeLabel.frame.size.height+64/2, 282/2, 75.0/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"detailInfo_finishButton_13@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(clickjobfinishButton) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:finishButton];
}

//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[_contentTextView text] length] == 0) {
        [[_contentTextView viewWithTag:999] setAlpha:1];
    }
    else {
        [[_contentTextView viewWithTag:999] setAlpha:0];
    }
    
}
//隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [_contentTextView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

-(void)setViewMoveUp:(BOOL)moveUp
{
    CGRect rect = _contentTextView.frame;
    if (moveUp) {
        rect.origin.y-=50;
        rect.size.height+=0;
    }
    _contentTextView.frame = rect;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_contentTextView resignFirstResponder];
}

-(void)timeButtonClicked:(UIButton *)sender
{
    [companyTextField resignFirstResponder];
    [projectOfficeTextField resignFirstResponder];
    [projectNameTextField resignFirstResponder];
    [workPlaceTextField resignFirstResponder];
    
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
//    
//    if (sender.tag == 998) {
//        timeMark = @"start";
//    }else if(sender.tag == 999)
//    {
//        timeMark = @"end";
//    }
//
//    [backgroundScrollView setContentOffset:CGPointMake(0,700/2) animated:YES];
//    
//    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 430/2, 320, 430)];
//    datePicker.tag = sender.tag;
//    // 设置时区
//    //    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    // 设置显示最大时间（此处为当前时间）
//    [datePicker setMaximumDate:[NSDate date]];
//    // 设置UIDatePicker的显示模式
//    [datePicker setDatePickerMode:UIDatePickerModeDate];
//    // 当值发生改变的时候调用的方法
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:datePicker];
//}
//
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

#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [companyTextField resignFirstResponder];
    [projectOfficeTextField resignFirstResponder];
    [projectNameTextField resignFirstResponder];
    [workPlaceTextField resignFirstResponder];
    [_contentTextView resignFirstResponder];
    
}

#pragma mark - 移动视图
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == workPlaceTextField) {
        [backgroundScrollView setContentOffset:CGPointMake(0,700/2) animated:YES];
    }
}
#pragma mark - 返回
-(void)backButtonClicked
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        ;
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除职业经历
- (void)DeleteButtonClicked
{
    [BCHTTPRequest dellTheJobItemWithJobID:self.jobDiction[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            //定义通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refushPersonResume" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
   
}

#pragma mark - 取消
- (void)clickjobCancleButton
{
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 确定
- (void)clickjobfinishButton
{
     NSDate *now = [NSDate date];
    if ([companyTextField.text length]==0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入公司名称"];
    }else if ([projectOfficeTextField.text length]==0)
    {
       [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入部门名称"];
    }else if ([projectNameTextField.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入线条领域"];
    }else if ([self.contentTextView.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入岗位简介"];
    }else if ([workPlaceTextField.text length]==0)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入工作地点"];
    }else if(![date1 timeIntervalSinceDate:now])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"时间填写不合格"];
    }else if(![date2 timeIntervalSinceDate:now])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"时间填写不合格"];
    }else if ([date1 timeIntervalSinceDate:date2]>0) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"时间填写不合格"];
    }else if ([self.editStyle isEqualToString:@"edit"]) {
        //        //修改资料
       [BCHTTPRequest modifyJobItemWithJobID:@"" WithCompanyName:companyTextField.text WithDepartName:projectOfficeTextField.text  WithWorkField:projectNameTextField.text WithJobIntro:self.contentTextView.text WithWorkPlace:workPlaceTextField.text WithStartTime:startTimeButton.titleLabel.text WithEndTime:endTimeButton.titleLabel.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
           if (isSuccess == YES) {
               [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"修改成功"];
               [self.navigationController popViewControllerAnimated:YES];
           }
       }];
    }else if ([self.editStyle isEqualToString:@"newAdd"])
    {
        //新建的资料
        [BCHTTPRequest addJobItemWithCompanyName:companyTextField.text WithDepartName:projectOfficeTextField.text WithWorkField:projectNameTextField.text WithJobIntro:self.contentTextView.text WithWorkPlace:workPlaceTextField.text WithStartTime:startTimeButton.titleLabel.text WithEndTime:endTimeButton.titleLabel.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
