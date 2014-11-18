//
//  BCHTTPRequest.h
//  ChangQu
//
//  Created by 牛 方健 on 13-4-13.
//  Copyright (c) 2013年 BC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BCHTTPRequest : NSObject



#pragma mark - 测试
//测试
+ (void)getCeShiUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 启动页接口===1
//启动页图片
+ (void)getTheLoadingImagesWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 登录/注册===28
/*
 **登录
 */
+ (void)loginTheFaceBookWithPhone:(NSString *)phone WithPassWord:(NSString *)password UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//用户忘记密码
+ (void)findMyPassWordWithPhone:(NSString *)phone WithCode:(NSString *)code WithNewPassWord:(NSString *)newPassWord UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 登录后获取信息操作
//是否登录
+ (BOOL)isLogin;

//退出登录
+ (void)exitLogin;

//获取用户id
+ (NSString *)getUserId;

//获取用户手机号码
+ (NSString *)getUserPhone;

//获取用户token
+ (NSString *)getUserToken;

//获取真实姓名
+ (NSString *)getUserName;

//获取第一个昵称
+ (NSString *)getUserFirstNickName;

//获取第二个昵称
+ (NSString *)getUserSecondNickName;

//获取type资料是否完善类型
+ (BOOL)getUserType;

//获取用户是否是VIP★★★
+ (BOOL)getUserVIP;

//获取脸谱号
+ (NSString *)getUserLPNumber;

//获取用户的头像
+ (NSString *)getUserLogo;

//判断出生地点，学校信息是否完善
+ (BOOL)getTheCicyType;


/*
 **注册
 */
//获取手机验证码
+ (void)GetTheRegisterCodeWithType:(int)type
                         WithPhone:(NSString *)phone
                 UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//注册第一步
+ (void)RegisterTheFirstWithName:(NSString *)name WithPhone:(NSString *)phone WithCode:(NSString *)code WithPassWord:(NSString *)password WithGender:(NSString *)gender WithNickName_First:(NSString *)firstNickName WithNickName_Second:(NSString *)secondNickName WithWorkCicy:(NSString *)city WithWorkArea:(NSString *)workArea  WithPicture:(NSString *)pic WithClause:(NSString *)clause WithInvitation:(NSString *)invitation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//注册第二部【详细信息】
+ (void)RegisterTheSecondWithInstitution_id:(NSString *)institutionID WithCompany:(NSString *)company WithDepartmentID:(NSString *)department_id WithInvestment_preference_id:(NSString *)investment_preference_id WithBirth_city:(NSString *)birth_city WithBirth_area:(NSString *)birth_area WithPrimary_school:(NSString *)primary_school WithJunior_middle_school:(NSString *)junior_middle_school WithHigh_school:(NSString *)high_school WithUniversity:(NSString *)university usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//注册的时候上传头像接口
+ (void)postHeadImageWithImage:(UIImage *)image WithPhone:(NSString *)phone usingSuccessBlock:(void (^)(BOOL isSuccess,NSString *imageId))successBlock;

//个人简历列表★★★★★
+ (void)getMyPersonResumeListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///颜沛贤增加---查看其他人的个人简历接口
+ (void)getOtherPersonResumeListWithUserId:(NSString*)userid UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//增加项目经历
+ (void)addTheProjectItemWithCompanyName:(NSString *)company WithProjectPost:(NSString *)projectpost WithProjectName:(NSString *)projectname WithProjectIntro:(NSString *)projectIntro WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//增加职业经历
+ (void)addJobItemWithCompanyName:(NSString *)companyname WithDepartName:(NSString *)departName WithWorkField:(NSString *)workfield WithJobIntro:(NSString *)jobintro WithWorkPlace:(NSString *)workplace WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//增加教育经历
+ (void)addEducationItemWithCollegeName:(NSString *)collegeName WithProfessional:(NSString *)professional WithDegree:(NSString *)degree WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改项目经历
+ (void)modifyTheProjectItemWithProjectID:(NSString *)p_id WithCompanyName:(NSString *)company WithProjectPost:(NSString *)projectpost WithProjectName:(NSString *)projectname WithProjectIntro:(NSString *)projectIntro WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改职业经历
+ (void)modifyJobItemWithJobID:(NSString *)jid WithCompanyName:(NSString *)companyname WithDepartName:(NSString *)departName WithWorkField:(NSString *)workfield WithJobIntro:(NSString *)jobintro WithWorkPlace:(NSString *)workplace WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改教育经历
+ (void)modifyEducationItemWithEducationID:(NSString *)edu_id WithCollegeName:(NSString *)collegeName WithProfessional:(NSString *)professional WithDegree:(NSString *)degree WithStartTime:(NSString *)s_time WithEndTime:(NSString *)e_time usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//删除项目经历
+ (void)dellTheProjectItemWithProjectID:(NSString *)p_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//删除职业经历
+ (void)dellTheJobItemWithJobID:(NSString *)j_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//删除教育经历
+ (void)dellTheEducationItemWithEducationID:(NSString *)edu_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


//注册投资偏好
+ (void)getinvestmentListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//身份背景选择(下一层为机构)
+ (void)getMyPositionWithPID:(NSString *)pid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//机构选择
+ (void)getInstitutionWithPID:(int)pid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//部门条线选择
+ (void)getDepartmentListWithID:(int)i_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//获取学位☆☆【绍辉6-27日新加接口】
+ (void)getTheEducationDegreeUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


////用户使用条款
//+ (void)getUserClauseWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//个人主页
+ (void)getMyMainMessageWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改头像
+ (void)modifyTheUserHeaderImagesWithImage:(UIImage *)image UsingSuccessBlock:(void (^)(BOOL isSuccess,NSString *imageId))successBlock;

//修改个人资料★★【6-27绍辉新加接口】
+ (void)ModifyThePersonMessageWithGender:(NSString *)gender FirstName:(NSString *)firstName WithSecondName:(NSString *)secondName WithWorkCity:(NSString *)workCity WithWorkArea:(NSString *)workArea usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//读取详细信息的接口★★【6-27绍辉新加接口】
+ (void)GetThePersonDetialsMessageWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//删除菜单
+ (void)dellTheMenuWithMenuName:(NSString *)menuName usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//快捷访问页面
+ (void)getTheQuickAccessListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//增加快捷访问
+ (void)AddTheMenuItemWithMenuName:(NSString *)menuName usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 联系人模块===12

#pragma mark - 联系人模块--新的好友
//新的好友
+ (void)getMyNewFriendsWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//拒绝增加好友
+ (void)RejectTheNewFriendsWithFriendsID:(NSString *)friendsid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//同意增加好友
+ (void)AgreeTheNewFriendsWithNewFriensdID:(NSString *)friemdsid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 联系人模块--我的联系人
//我的联系人
+ (void)getMyLinkManWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//加入黑名单
+ (void)addBlacklistWithFriendId:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//认可他的身份
+ (void)acceptRankWithFriendId:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 联系人模块--站内联系人
//站内联系人
+ (void)getMyInstationManWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 联系人模块--赠送联系人
//赠送联系人
+ (void)getMypresentManWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//赠送联系人加为好友
+ (void)AddThePresentFriendsToInstationManWithFriendsID:(NSString *)friendsid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 联系人模块--邀请好友
//手机通讯录
+ (void)postFriendFromAddressBookWithUsersArray:phoneArray usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 联系人模块--搜索好友
//搜索好友
+ (void)getSearchTheFriendsWithPhone:(NSString *)phone usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//好友资料---根据uid获取好友信息
+ (void)getMyFriendInformationWithFID:(NSString *)fid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//好友资料---根据脸谱号获取好友信息
+ (void)getMyFriendInformationWithLp_number:(NSString *)Lp_number usingSuccessBlock:(void (^)(BOOL isSuccess, NSDictionary *resultDic))successBlock;

#pragma mark - 朋友圈【绍辉6-23新加】====7
//朋友圈列表
+ (void)getFriendsOpenListWithPages:(NSInteger)page UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//好友朋友圈
+ (void)getMyFriendsOpenWithFid:(NSString *)fid WithPages:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布朋友圈
+ (void)PostSendFriendsCircleMessageWithPictureID:(NSString *)pictureid WithConten:(NSString *)content WithInstitution:(NSString *)institution WithDepartment:(NSString *)department usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布前上传的图片
+ (void)PostTheFriendCirclePicturesWithImage:(UIImage *)image usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//朋友圈评论
+ (void)postTheFriendCircleCommentsWithLogID:(NSString *)logid WithContent:(NSString *)content WithToID:(NSString *)toid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//点赞或者取消赞
+ (void)markTheFriendCircleLogWithLogID:(NSString *)logid WithStatus:(NSString *)status usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//更换朋友圈背景
+ (void)PostChangeTheFriendCircleBackPicturesWithImage:(UIImage *)image usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 我的活动【绍辉6-24新加】====10
//活动列表
+ (void)getTheActivityListWithTypeID:(NSString *)typeId WithAreaName:(NSString *)areaName usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//活动详情
+ (void)getTheActivityDetialsWithActivityID:(NSString *)activityId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布活动-类型
+ (void)getTheActivityStyleWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布活动-时间
+ (void)getTheActivityTimeWithStyleID:(NSString *)styleId UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改活动页面○
+ (void)changeTheActivityViewWithActivityID:(NSString *)activityId UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//我的活动列表
+ (void)getMyActivityListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布活动
+ (void)PostTheSendActivityMessageWithTitle:(NSString *)title WithStyleId:(NSString *)styleid WithStartTime:(NSString *)startTime WithTimeRangeID:(NSString *)rangeId WithEndTime:(NSString *)endTime WithAreaName:(NSString *)areaName WithPaymentRange:(NSString *)payRange WithContent:(NSString *)content UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//参加聚会
+ (void)joinTheActivityWithActivityID:(NSString *)activityid UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改活动操作○
+ (void)modifyTheActivityMessageWithTitle:(NSString *)title WithStyleId:(NSString *)styleid WithStartTime:(NSString *)startTime WithTimeRangeID:(NSString *)rangeId WithEndTime:(NSString *)endTime WithAreaName:(NSString *)areaName WithPaymentRange:(NSString *)payRange WithContent:(NSString *)content UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//删除我的活动
+ (void)deleteTheActivityOfMeWithActivityID:(NSString *)activityId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 消息模块【绍辉6-26日新加】===11
//消息列表
+ (void)getTheMessageListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//①拒绝机构群认证
+ (void)RefusedTheConfirmationRelationshipsWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//②消息列表对机构关系进行确认
+ (void)PassTheConfirmationRelationshipsWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//③参加活动人同意参加聚会
+ (void)AgreeJoinThePartyWithFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//④参加活动人拒绝参加聚会
+ (void)RefusedJoinThePartyWithFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//⑤发布人同意参加聚会
+ (void)CreaterAgreeOtherPeopleJoinThePartyFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//⑥发布人拒绝参加聚会
+ (void)CreaterRefusedOtherPeopleJoinThePartyFid:(NSString *)fid WithRelation:(NSString *)relation usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//⑦通过申请加入群接口
+ (void)PassTheJoinApplicationOfGroupWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//⑧拒绝申请加入群接口
+ (void)RefusedTheJoinApplicationOfGroupWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//⑨同意增加好友
+ (void)AgreeTheOthersAddMeFriendsWithFid:(NSString *)fid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//⑩拒绝增加好友
+ (void)RefusedTheOthersAddMeFriendsWithFid:(NSString *)fid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//**********************
// 同乡校友
//**********************
#pragma mark - 同乡校友===3

//同乡列表
+ (void)GetTheSameCityListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//同校列表
+ (void)GetTheSameSchoolListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//增加好友
+ (void)AddTheNewFriendsWithFriendsID:(NSString *)friendsId WithFriendsType:(NSString *)fType WithGroupID:(NSString *)groupid WithGroupType:(NSString *)groupType WithInforString:(NSString *)inforString usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//*******************
// 我的群
//********************
#pragma mark - 我的群
//我的群
+ (void)getMyGroupListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

/////////////////////
//测试
/////////////////////
//我的通讯录接口
+ (void)myAddressBookListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;









#pragma mark - 业务墙===10
//业务墙所有分类
+ (void)getBusinessTypeListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//根据类型获取动态
+ (void)getBusinessListByTypeWithTypeId:(NSString *)typeId WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//获取我的动态列表
+ (void)getMyBusinessListWithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//获取某动态详情
+ (void)getBusinessDetailWithWallId:(NSString *)wallId WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//评论动态接口
+ (void)businessSetCommentWithWallId:(NSString *)wallId WithContent:(NSString *)content WithToID:(NSString *)toid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布动态前判断是否已经三条
+ (void)businessCheckNumsWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//获取定向发布的条线列表--群列表
+ (void)getBusinessDepartmentListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//获取发布业务墙动态信息接口--金币
+ (void)getBusinessGoldsWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//发布动态接口
+ (void)businessSetActionWithTitle:(NSString *)title WithContent:(NSString *)content WithDepartment_ids:(NSString *)department_ids WithType_id:(NSString *)type_id WithNick_name:(NSString *)nick_name WithIs_public:(NSString *)is_public usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//修改动态接口
+ (void)businessEditActionWithTitle:(NSString *)title WithContent:(NSString *)content WithType_id:(NSString *)type_id WithAid:(NSString *)aid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 资讯===6
//所有资讯大分类列表
+ (void)getZXMainListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

// “我订阅”的资讯大分类
+ (void)getMyZXListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

// 订阅资讯
+ (void)dyueZXWithTypeId:(NSString*)type_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

// 取消资讯订阅
+ (void)quxiaoDyueZXWithTypeId:(NSString*)type_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 资讯详情网页接口
//资讯详情 ----网页

//资讯详情带分享网页
+ (void)informationDetailWithInfo_id:(NSString *)info_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//资讯评论页
+ (void)informationCommentWithNews_id:(NSString *)news_id WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//评论资讯
+ (void)CommentInformationWithNews_id:(NSString *)news_id WithContent:(NSString *)content usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 脸谱群【6-30日绍辉新加接口】
//脸谱群机构列表☆☆☆☆☆☆☆☆☆
+ (void)getTheFaceBookGroupInstitutionListWithClassID:(NSString *)classid WithPages:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群机构筛选标签列表☆☆☆☆☆☆☆☆☆
+ (void)checkTheFaceBookGroupInstitutionConditionWithClassID:(NSString *)classid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//加入群所调用的接口【7-1】☆☆☆☆☆☆☆☆☆
+ (void)AddTheGroupFromMeWithInstitutionID:(NSString *)institutionid WithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构-【动态7-1】☆☆☆☆☆☆☆☆☆
+ (void)getTheFaceBookInstitutionActionListWithPages:(NSInteger)page WithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构-群聊【常用联系人7-1】☆☆☆☆☆☆☆☆☆
+ (void)GetTheFaceBookInstitutionGroupChatOftenConnectPeopleWithInstitutionID:(NSString *)institutionid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构-群聊【群聊列表7-1】☆☆☆☆☆☆☆☆☆
+ (void)GetTheFaceBookGroupChatListWithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构-新建群聊选人【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)GetTheFaceBookInstitutionMembersWithInstitutionID:(NSString *)institutionId WithPages:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构-新建群聊【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)CreateTheFaceBookInstitutionGroupWithUserStr:(NSString *)userStr WithGroupName:(NSString *)groupName WithInstitutionId:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构===条线===主题===发布动态前上传的照片【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)PostWithFromDynamicPhoto:(NSString *)fromDynamic WithPicture:(UIImage *)picture usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群-机构===条线===主题===发布动态【7-2-feng.sh】☆☆☆☆☆☆☆☆☆
+ (void)PostWithFromDynamicMessage:(NSString *)fromDynamic WithPicture:(NSString *)picStr WithInstitutionID:(NSString *)institutionID WithContent:(NSString *)content WithIsFriendsCircle:(NSString *)isFC WithIsDepartment:(NSString *)isDp usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 脸谱群---条线
//脸谱群条线列表---根据标签获取条线列表
+ (void)getGroupDepartmentScreeningByKeyWithClass_id:(NSString *)class_id WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群条线筛选标签列表
+ (void)getGroupDepartmentKeysWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//申请加入脸谱条线群
+ (void)addDepartmentGroupWithDepartment_id:(NSString *)department_id WithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群条线群用户列表
+ (void)getGroupsDepartmentUsersWithDid:(NSString *)did WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群条线群动态列表
+ (void)getGroupsDepartmentActionListWithDid:(NSString *)did WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群条线动态详情====机构动态详情====主题动态详情
+ (void)getGroupsWithFromDetail:(NSString *)fromDetail WithAid:(NSString *)aid WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群条线动态评论====机构动态评论====主题动态评论
+ (void)GetGroupsWithFromComment:(NSString *)fromComment WithIid:(NSString *)iid WithAid:(NSString *)aid WithContent:(NSString *)content usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线群群聊--常用联系人
+ (void)getDepartmentTopContactsWithDepartment_id:(NSString *)department_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线群群聊--群聊列表 --条线群某用户的群聊列表
+ (void)getDepartmentGroupUsersWithDepartment_id:(NSString *)department_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线群创建聊天群
+ (void)createDepartmentChatGroupWithUserStr:(NSString *)userStr WithGroupName:(NSString *)groupName WithDepartment_id:(NSString *)department_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 脸谱群---主题
//脸谱群主题列表---根据关键字搜索主题
+ (void)getGroupsThemeListWithKeys:(NSString *)keys WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//申请加入脸谱主题群
+ (void)addThemeGroupWithTheme_id:(NSString *)theme_id WithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//创建主题群前上传主题头像接口
+ (void)createThemeGroupUploadWithGroupImage:(UIImage *)groupImage usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//创建脸谱群主题群
+ (void)createThemeGroupWithLogo_id:(NSString *)logo_id WithTitle:(NSString *)title usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群主题群用户列表
+ (void)getGroupsThemeUsersWithTid:(NSString *)tid WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//脸谱群主题群动态列表
+ (void)getGroupsThemeActionListWithTid:(NSString *)tid WithPage:(NSInteger)page usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题群群聊--常用联系人
+ (void)getThemeTopContactsWithTheme_id:(NSString *)theme_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题群群聊--群聊列表 --条线群某用户的群聊列表
+ (void)getThemeGroupUsersWithTheme_id:(NSString *)theme_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题群创建聊天群
+ (void)createThemeChatGroupWithUserStr:(NSString *)userStr WithGroupName:(NSString *)groupName WithTheme_id:(NSString *)theme_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//********群成员接口********
//机构的每一个群的所有成员
+ (void)GetTheInstitutionGroupMembersListWithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线的每一个群的所有成员
+ (void)GetTheDepartmentGroupMembersListWithDepartmentID:(NSString *)departmentId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题的每一个群的所有成员
+ (void)GetTheThemeGroupMembersListWithThemeID:(NSString *)themeId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//***********退出群接口*************
//机构的群成员主动退群
+ (void)exitTheInstitutionGroupWithGroupID:(NSString *)groupId WithTypeID:(NSString *)typeId   WithUserId:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线的群成员主动退群
+ (void)exitTheDepartmentGroupWithGroupID:(NSString *)groupId WithTypeID:(NSString *)typeId   WithUserId:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题的群成员主动退群
+ (void)exitTheThemeGroupWithGroupID:(NSString *)groupId WithTypeID:(NSString *)typeId   WithUserId:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//**********脸谱群私聊前调用的接口***************
//机构私聊前调用
+ (void)BeforeTheInstitutionPrivateChatWithInstitutionID:(NSString *)institutionid WithFriendID:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线私聊前调用
+ (void)BeforeTheDepartmentPrivateChatWithDepartmentID:(NSString *)departmentid WithFriendID:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题私聊前调用
+ (void)BeforeTheThemePrivateChatWithThemeID:(NSString *)themeid WithFriendID:(NSString *)friendId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

#pragma mark - 升级VIP

//上传名片
+ (void)uploadCardWithCardImage:(UIImage *)cardImage usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//升级VIP
+ (void)updateVIPWithCardId:(NSString *)card WithGold:(NSString *)gold usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//金币充值列表
+ (void)goldcoinsListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//充值完成后调用接口
+ (void)addGoldCoinsWithCoins:(NSString *)coins usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//分享成功后加金币
+ (void)inviteWithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


#pragma mark - 圈圈页面
///1，得到圈圈的图片的接口
+ (void)getLPImageWithInstitutionId:(NSString*)institution_id       // 机构id
                       SuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///2、获取某坐标某范围内的其他坐标
+ (void)getPointsWithOrginX:(NSString*)orgin_x OrginY:(NSString*)orgin_y Distance:(NSString*)distance InstitutionId:(NSString*)institution_id successBlock:(void (^)(NSMutableArray* dataArray))successBlock;

///机构确认关系
+ (void)confirmationWithType:(NSString *)type WithFriend_id:(NSString *)friend_id WithInstitution_id:(NSString *)institution_id usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


//接口4.4   用户注册后必须调用的接口
//+ (void)UserAfterRegisterMustGet


//获取已知公司的名称
+ (void)GetTheWeKnowCompanyNameWithClass_id:(NSString *)classids UsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;
//获取已知小学名称
+ (void)GetTheWeKnowPrimarySchoolNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;
//获取已知初中名称
+ (void)GetTheWeKnowJuniorSchoolNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;
//获取已知高中名称
+ (void)GetTheWeKnowHighSchoolNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;
//获取已知大学名称
+ (void)GetTheWeKnowUniversityNameUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//*********添加群成员****************
//机构群添加成员
+ (void)InstitutionChatGroupAddNewMemberWithMembers:(NSString *)members WithGroupID:(NSString *)groupid WithInstitutionID:(NSString *)institutionId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//条线群添加成员
+ (void)DepartmentChatGroupAddNewMemberWithMembers:(NSString *)members WithGroupID:(NSString *)groupid WithDepartmentID:(NSString *)departmentId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//主题群添加成员
+ (void)ThemeChatGroupAddNewMemberWithMembers:(NSString *)members WithGroupID:(NSString *)groupid WithThemeID:(NSString *)themeId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//*********************************
//删除部落消息
+ (void)deleteTheRemindMessageWithMessageID:(NSString *)messageId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///检测是否有部落消息
+ (void)CheckTheNewRemindMessageUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///咨询接口新加
//新闻分类列表
+ (void)GetTheNewsClassListsUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;
//新闻列表
+ (void)GetTheNewsListsWithPages:(NSInteger)pages WithTypeID:(NSString *)typeId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

//广告
+ (void)GetTheAdvertisementListWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///我的联系人创建群
+ (void)CreateGroupOnMyContactPeopleWithUsers:(NSString *)users WithGroupName:(NSString *)name usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///我的联系人群-成员
+ (void)TheMemberOfContactGroupPeopleWithGroupID:(NSString *)groupId usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///我的连立人退群
+ (void)ExitTheContactPeopleGroupWithGroupID:(NSString *)groupId WithUserID:(NSString *)userid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///我的联系人群添加成员
+ (void)AddMemberOfContactPeopleGroupWithUsers:(NSString *)users WithGroupId:(NSString *)groupid usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///分享咨询得金币
+ (void)getTheGoldAfterShareInformationWithType:(NSString *)type usingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;

///4.44注册成功后调取的接口，用于聊天和推送
+ (void)sendTheUserTokenAndDriveTokenWithUsingSuccessBlock:(void (^)(BOOL isSuccess,NSDictionary*resultDic))successBlock;


@end
