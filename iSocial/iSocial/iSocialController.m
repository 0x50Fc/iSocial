//
//  iSocialController.m
//  iSocial
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "iSocialController.h"
#import <vTeam/vTeam.h>

#import "WXApi.h"
#import "WXApiObject.h"

#define LocalizedString(key,v)  [[NSBundle mainBundle] localizedStringForKey:(key) value:(v) table:nil]

#define ACTION_SAVE         LocalizedString(iSocialSaveImage, @"保存到相册")
#define ACTION_SHARE_WEIBO  LocalizedString(iSocialShareWeibo, @"分享到微博")
#define ACTION_SHARE_WEIXIN LocalizedString(iSocialShareWeixin, @"分享给微信好友")
#define ACTION_SHARE_WEIXIN_GROUP   LocalizedString(iSocialShareWeixinGroup, @"分享到微信朋友圈")
#define ACTION_SHARE_Facebook    LocalizedString(iSocialShareFacebook, @"分享到 Facebook")
#define ACTION_SHARE_Twitter    LocalizedString(iSocialShareTwitter, @"分享到 Twitter")
#define ACTION_SHARE_EMAIL  LocalizedString(iSocialShareEmail, @"发邮件")
#define ACTION_SHARE_SMS    LocalizedString(iSocialShareSMS, @"发短信")
#define ACTION_CANCEL       LocalizedString(iSocialCancel, @"取消")

@implementation iSocialController

@synthesize image = _image;
@synthesize viewController = _viewController;
@synthesize body = _body;
@synthesize actionSheet = _actionSheet;
@synthesize title = _title;

-(void) dealloc{
    [_image release];
    [_body release];
    [_actionSheet release];
    [super dealloc];
}

-(void) setImage:(UIImage *)image{
    if(_image != image){
        [image retain];
        [_image release];
        _image = image;
        [_actionSheet release];
        _actionSheet = nil;
    }
}

-(void) setBody:(NSString *)body{
    if(_body != body){
        [body retain];
        [_body release];
        _body = body;
        [_actionSheet release];
        _actionSheet = nil;
    }
}

-(void) setTitle:(NSString *)title{
    if(_title != title){
        [title retain];
        [_title release];
        _title =title;
        [_actionSheet release];
        _actionSheet = nil;
    }
}

-(UIActionSheet *) actionSheet{
    if(_actionSheet == nil){
        
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
        
        if(_image){
            [_actionSheet addButtonWithTitle:ACTION_SAVE];
        }
        
        if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
            [_actionSheet addButtonWithTitle:ACTION_SHARE_WEIXIN];
            [_actionSheet addButtonWithTitle:ACTION_SHARE_WEIXIN_GROUP];
        }
        
        Class clazz = NSClassFromString(@"SLComposeViewController");
        
        if([clazz isAvailableForServiceType:SLServiceTypeSinaWeibo]){
            [_actionSheet addButtonWithTitle:ACTION_SHARE_WEIBO];
        }
        
        if([clazz isAvailableForServiceType:SLServiceTypeFacebook]){
            [_actionSheet addButtonWithTitle:ACTION_SHARE_Facebook];
        }
        
        if([clazz isAvailableForServiceType:SLServiceTypeTwitter]){
            [_actionSheet addButtonWithTitle:ACTION_SHARE_Twitter];
        }
        
        if([MFMailComposeViewController canSendMail]){
            [_actionSheet addButtonWithTitle:ACTION_SHARE_EMAIL];
        }
        
        if(_image == nil){
            if([MFMessageComposeViewController canSendText]){
                [_actionSheet addButtonWithTitle:ACTION_SHARE_SMS];
            }
        }
        
        [_actionSheet setCancelButtonIndex:[_actionSheet addButtonWithTitle:ACTION_CANCEL]];
        
    }
    return _actionSheet;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    VTAppStatusMessageView * appStatus = [[VTAppStatusMessageView alloc] initWithTitle:NSLocalizedString(iSocialSaveImageFinish, @"成功保存图片")];
    [appStatus show:YES duration:1.5];
    [appStatus release];
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString * action = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([action isEqualToString:ACTION_SAVE]){
        
        UIImageWriteToSavedPhotosAlbum(_image, self , @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
    else if([action isEqualToString:ACTION_SHARE_WEIBO]){
        
        Class clazz = NSClassFromString(@"SLComposeViewController");
        
        SLComposeViewController * viewController = [clazz composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        [viewController setCompletionHandler:^(SLComposeViewControllerResult result){
            if(result == SLComposeViewControllerResultDone){
                VTAppStatusMessageView * appStatus = [[VTAppStatusMessageView alloc] initWithTitle:NSLocalizedString(iSocialShareFinish, @"成功发布")];
                [appStatus show:YES duration:1.5];
                [appStatus release];
            }
        }];
        
        if(_body){
            [viewController setInitialText:_body];
        }
        
        if(_image){
            [viewController addImage:_image];
        }
        
        [_viewController presentModalViewController:viewController animated:YES];
        
    }
    else if([action isEqualToString:ACTION_SHARE_Facebook]){
        
        Class clazz = NSClassFromString(@"SLComposeViewController");
        
        SLComposeViewController * viewController = [clazz composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [viewController setCompletionHandler:^(SLComposeViewControllerResult result){
            if(result == SLComposeViewControllerResultDone){
                VTAppStatusMessageView * appStatus = [[VTAppStatusMessageView alloc] initWithTitle:NSLocalizedString(iSocialShareFinish, @"成功发布")];
                [appStatus show:YES duration:1.5];
                [appStatus release];
            }
        }];
        
        if(_body){
            [viewController setInitialText:_body];
        }
        
        if(_image){
            [viewController addImage:_image];
        }
        
        [_viewController presentModalViewController:viewController animated:YES];
        
    }
    else if([action isEqualToString:ACTION_SHARE_Twitter]){
        
        Class clazz = NSClassFromString(@"SLComposeViewController");
        
        SLComposeViewController * viewController = [clazz composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [viewController setCompletionHandler:^(SLComposeViewControllerResult result){
            if(result == SLComposeViewControllerResultDone){
                VTAppStatusMessageView * appStatus = [[VTAppStatusMessageView alloc] initWithTitle:NSLocalizedString(iSocialShareFinish, @"成功发布")];
                [appStatus show:YES duration:1.5];
                [appStatus release];
            }
        }];
        
        if(_body){
            [viewController setInitialText:_body];
        }
        
        if(_image){
            [viewController addImage:_image];
        }
        
        [_viewController presentModalViewController:viewController animated:YES];
        
    }
    else if([action isEqualToString:ACTION_SHARE_EMAIL]){
        
        MFMailComposeViewController * viewController = [[MFMailComposeViewController alloc] init];
        
        [viewController setMailComposeDelegate:self];
        
        if(_title){
            [viewController setSubject:_title];
        }
        
        if(_body){
            [viewController setMessageBody:_body isHTML:NO];
        }
        
        if(_image){
            [viewController addAttachmentData:UIImageJPEGRepresentation(_image, 0.8) mimeType:@"image/jpeg" fileName:@"image.jpg"];
        }
        
        [_viewController presentModalViewController:viewController animated:YES];
        [viewController release];
        
    }
    else if([action isEqualToString:ACTION_SHARE_SMS]){
        
        MFMessageComposeViewController * viewController = [[MFMessageComposeViewController alloc] init];
        
        [viewController setMessageComposeDelegate:self];
        
        if(_body){
            [viewController setBody:_body];
        }
        else if(_title){
            [viewController setTitle:_title];
        }
        
        [_viewController presentModalViewController:viewController animated:YES];
        
        [viewController release];
        
    }
    else if([action isEqualToString:ACTION_SHARE_WEIXIN]
            || [action isEqualToString:ACTION_SHARE_WEIXIN_GROUP]){
        
        SendMessageToWXReq * msg = [[SendMessageToWXReq alloc] init];
        
        if(_body){
            [msg setText:_body];
        }
        
        if(_image){
            
            UIImage * thumbImage = _image;
            
            CGSize size = [_image size];
            
            if(size.width > 160){
                size = CGSizeMake(160, size.height / size.width * 160);
                UIGraphicsBeginImageContext(size);
                [_image drawInRect:CGRectMake(0, 0, size.width, size.height)];
                thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }
            
            WXMediaMessage * mediaMessage = [WXMediaMessage message];
            [mediaMessage setThumbImage:thumbImage];
            WXImageObject * imageObject = [WXImageObject object];
            [imageObject setImageData:UIImageJPEGRepresentation(_image, 0.8)];
            [mediaMessage setMediaObject:imageObject];
            [msg setMessage:mediaMessage];
            
        }
        
        if([action isEqualToString:ACTION_SHARE_WEIXIN_GROUP]){
            [msg setScene:WXSceneTimeline];
        }
        else{
            [msg setScene:WXSceneSession];
        }
        
        [WXApi sendReq:msg];
        
    }
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result == MFMailComposeResultSent){
        VTAppStatusMessageView * appStatus = [[VTAppStatusMessageView alloc] initWithTitle:NSLocalizedString(iSocialSendFinish,@"成功发送")];
        [appStatus show:YES duration:1.5];
        [appStatus release];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    if(result == MessageComposeResultSent){
        VTAppStatusMessageView * appStatus = [[VTAppStatusMessageView alloc] initWithTitle:NSLocalizedString(iSocialSendFinish,@"成功发送")];
        [appStatus show:YES duration:1.5];
        [appStatus release];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

@end