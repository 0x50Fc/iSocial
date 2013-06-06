//
//  iSocialController.h
//  iSocial
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Social/Social.h>
#import <MessageUI/MessageUI.h>


#define iSocialSaveImage        @"iSocialSaveImage"
#define iSocialShareWeibo       @"iSocialShareWeibo"
#define iSocialShareWeixin      @"iSocialShareWeixin"
#define iSocialShareWeixinGroup @"iSocialShareWeixinGroup"
#define iSocialShareEmail       @"iSocialShareEmail"
#define iSocialShareSMS         @"iSocialShareSMS"
#define iSocialCancel           @"iSocialCancel"

#define iSocialShareFacebook    @"iSocialShareFacebook"
#define iSocialShareTwitter     @"iSocialShareTwitter"

#define iSocialSaveImageFinish  @"iSocialSaveImageFinish"
#define iSocialShareFinish      @"iSocialShareFinish"
#define iSocialSendFinish       @"iSocialSendFinish"

typedef enum {
    iSocialControllerSourceTypeNone = 0
    ,iSocialControllerSourceTypeSaveImage = 1 <<0
    ,iSocialControllerSourceTypeWeibo = 1 <<1
    ,iSocialControllerSourceTypeWeixin = 1 <<2
    ,iSocialControllerSourceTypeWeixinGroup = 1 <<3
    ,iSocialControllerSourceTypeEmail = 1 <<4
    ,iSocialControllerSourceTypeSMS = 1 <<5
    ,iSocialControllerSourceTypeFacebook = 1 <<6
    ,iSocialControllerSourceTypeTwitter = 1 <<7
    ,iSocialControllerSourceTypeChina = iSocialControllerSourceTypeSaveImage | iSocialControllerSourceTypeWeibo | iSocialControllerSourceTypeWeixin | iSocialControllerSourceTypeWeixinGroup | iSocialControllerSourceTypeEmail | iSocialControllerSourceTypeSMS
    ,iSocialControllerSourceTypeAll = 0xffffffff
} iSocialControllerSourceType;

@interface iSocialController : NSObject<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic,retain) UIImage * image;
@property(nonatomic,retain) NSString * body;
@property(nonatomic,retain) NSString * title;
@property(nonatomic,assign) IBOutlet UIViewController * viewController;
@property(nonatomic,readonly) UIActionSheet * actionSheet;
@property(nonatomic,assign) iSocialControllerSourceType sourceType;

@end
