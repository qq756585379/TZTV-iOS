//
//  Common_Api.h
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#ifndef Common_Api_h
#define Common_Api_h

#define kAbs(__MAINURL__, __CHILDURL__)    [NSString stringWithFormat:@"%@%@", __MAINURL__, __CHILDURL__]

#define DOMAINURL_Inner    @"http://114.55.234.142:8080"
#define DOMAINURL_release  @"http://mapi.qqxueche.net"

#define isInner 1

#define DOMAINURL isInner ? DOMAINURL_Inner : DOMAINURL_release

/**登录*/
#define LOGINURL                kAbs(DOMAINURL,@"/tztvapi/user/login?mobile=%@&password=%@")
/**找回密码*/
#define findPwdUrl              kAbs(DOMAINURL,@"/tztvapi/userInfo/findPassword?telephone=%@&id=%@&code=%@&password=%@")
/**注册*/
#define REGISTURL               kAbs(DOMAINURL,@"/tztvapi/user/regist?id=%@&code=%@&password=%@&imageUrl=%@&nickname=%@&city=%@&address=%@")
/**发送验证码*/   //type - 1:注册; 2：找回密码;
#define GetRegVerifyCodeURL     kAbs(DOMAINURL,@"/tztvapi/mobile/sendMobileCode?telephone=%@&type=%d")
/*校验验证码*/   //请求得来的id  code短信验证码
#define ValidateMobileCodeURL   kAbs(DOMAINURL,@"/tztvapi/mobile/validateMobileCode?id=%@&code=%@")
/*获取城市接口*/
#define getOpenCityListURL      kAbs(DOMAINURL,@"/tztvapi/city/getCityList")

/**上传文件 POST int type        //1：头像；2：图片；3：音频；4视频*/
#define UploadFileUrl           kAbs(DOMAINURL,@"/tztvapi/upload/uploadFile")
#define UploadImagesUrl         kAbs(DOMAINURL,@"/tztvapi/upload/uploadImg")



#endif /* Common_Api_h */
