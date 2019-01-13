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

#define DOMAINURL_Inner              @"http://127.0.0.1:8080"
#define DOMAINURL_MAPI               @"http://mapi.tuzicity.com"

#define isInner 1

#define DOMAINURL isInner ? DOMAINURL_Inner : DOMAINURL_MAPI

/**首页*/
#define Home2_URL               kAbs(DOMAINURL,@"/tztvapi/live/getHomeLiveList?city=%@&page=%d&pageSize=3&location=%@")
#define Home2_URL2              kAbs(DOMAINURL,@"/tztvapi/recommend/getRecomGoodsList?page=%d&pageSize=10")

/**分类*/
#define FenLei_URL              kAbs(DOMAINURL,@"/tztvapi/brand/getAllBrand")
#define Search_URL              kAbs(DOMAINURL,@"/tztvapi/search/searchGoods?word=%@&page=%d&pageSize=10")
#define Classify_URL            kAbs(DOMAINURL,@"/xmall/category/list")


/**登录*/
#define LOGINURL                kAbs(DOMAINURL,@"/xboot/login")
/**注册*/
#define REGISTURL               kAbs(DOMAINURL,@"/tztvapi/user/regist?id=%@&code=%@&password=%@&imageUrl=%@&nickname=%@&city=%@&address=%@")
/**发送验证码*/   //type - 1:注册; 2：找回密码;
#define GetRegVerifyCodeURL     kAbs(DOMAINURL,@"/tztvapi/mobile/sendMobileCode?telephone=%@&type=%d")
/*校验验证码*/   //请求得来的id  code短信验证码
#define ValidateMobileCodeURL   kAbs(DOMAINURL,@"/tztvapi/mobile/validateMobileCode?id=%@&code=%@")
/*获取城市接口*/
#define getOpenCityListURL      kAbs(DOMAINURL,@"/fileapi/city/getCityList")

/**上传文件 POST int type        //1：头像；2：图片；3：音频；4视频*/   //userId  type
#define UploadFileUrl           kAbs(DOMAINURL,@"/fileapi/upload/uploadFile")

/**修改头像*/
#define ModifyHeadIconUrl       kAbs(DOMAINURL,@"/tztvapi/userInfo/uptUrl?userId=%@&url=%@")

/*
 * BrandApi
 */
#define getBrandListURL         kAbs(DOMAINURL,@"/tztvapi/brand/getBrandList")
//获取获取品牌主分类
#define getCatalogURL           kAbs(DOMAINURL,@"/tztvapi/brand/getCatalog")
//获取品牌二级分类
#define getCatalogSubURL        kAbs(DOMAINURL,@"/tztvapi/brand/getCatalogSub?catalog_id=%@")
//获取推荐信息
#define getRecommendURL         kAbs(DOMAINURL,@"/tztvapi/brand/getRecommend")
//为你推荐里的品牌点进去后   type - 排序类型 zx:最新；xl:销量；jg:价格    order - 0：升序；1降序
#define getGoodsListByBidURL    kAbs(DOMAINURL,@"/tztvapi/goods/getGoodsListByBid?brand_id=%@&page=%d&pageSize=10&type=%@&order=%d")
//为你推荐下面的类别点进去   catalogsub_id - 二级分类ID   type - 排序类型 zx:最新；xl:销量；jg:价格   order - 0：升序；1降序
#define getGoodsListByCidURL    kAbs(DOMAINURL,@"/tztvapi/goods/getGoodsListByCid?catalogsub_id=%@&page=%d&pageSize=10&type=%@&order=%d")
//获取商品颜色尺码
#define getGoodsInfoSkuURL      kAbs(DOMAINURL,@"/tztvapi/goods/getGoodsInfoSku?goods_id=%@")
/**
 * UserInfoApi
 */
/**找回密码*/
#define findPwdUrl              kAbs(DOMAINURL,@"/tztvapi/userInfo/findPassword?telephone=%@&id=%@&code=%@&password=%@")
#define uptSexURL               kAbs(DOMAINURL,@"/tztvapi/userInfo/uptSex?userId=%@&sex=%d")
#define uptBirthdayURL          kAbs(DOMAINURL,@"/tztvapi/userInfo/uptBirthday?userId=%@&birthday=%@")
#define uptNicknameURL          kAbs(DOMAINURL,@"/tztvapi/userInfo/uptNickname?userId=%@&nickname=%@")
/**
 * ShopCartApi
 */
//添加到购物车
#define addShopCartURL          kAbs(DOMAINURL,@"/tztvapi/shopcart/addShopCart?user_id=%@&catalog_name=%@&goods_id=%@&goods_sku_id=%@&goods_num=%d")
//删除购物车   id - 购物车id
#define delShopCartURL          kAbs(DOMAINURL,@"/tztvapi/shopcart/delShopCart?user_id=%@&id=%@")
//修改购物车
#define uptShopCartURL          kAbs(DOMAINURL,@"/tztvapi/shopcart/uptShopCart?user_id=%@&id=%@&goods_num=%ld")
//获取用户购物车列表   page写死，最多返回50条数据
#define getShopCartListURL      kAbs(DOMAINURL,@"/tztvapi/shopcart/getShopCartList?user_id=%@&page=50&pageSize=10")
/**
 * PayApi
 */
// pay_method - 支付类型 默认0 0：支付,1：充值     ids:ord_no
#define getPayDataURL           kAbs(DOMAINURL,@"/tztvapi/pay/getPayData?ids=%@&user_id=%@&pay_method=%d")//支付宝
#define getWXPayDataURL         kAbs(DOMAINURL,@"/tztvapi/paywx/getPayData?ids=%@&user_id=%@&pay_method=%d")//微信
//POST
#define setPayResultURL         kAbs(DOMAINURL,@"/tztvapi/pay/setPayResult")
/**
 * OrderApi     5
 */
//根据用户ID查询订单信息   state - 订单状态//qb：全部；dfk：待付款，dfh：待发货，dsh：待收货，dpj：待评价
#define getOrderByUserIdURL     kAbs(DOMAINURL,@"/tztvapi/order/getOrderByUserId?user_id=%@&page=%d&pageSize=10&state=%@")
#define getOrderByOidURL        kAbs(DOMAINURL,@"/tztvapi/order/getOrderByOid?order_id=%@")
//下订单    express_method - 配送方式；0：物流配送；1：门店自提   --- POST
#define addOrderURL             kAbs(DOMAINURL,@"/tztvapi/order/addOrder")
#define cancelOrderURL          kAbs(DOMAINURL,@"/tztvapi/order/cancelOrder?user_id=%@&order_id=%@&token=%@")
//确认收货
#define confirmReceiveURL       kAbs(DOMAINURL,@"/tztvapi/order/confirmReceive?user_id=%@&order_id=%@&token=%@")
/**
 * ExpressApi
 */
//获取物流信息  order_no - 订单no   express_no - 物流编号
#define getExpressURL           kAbs(DOMAINURL,@"/tztvapi/express/getExpress?order_no=%@&express_no=%@")
/**
 * RefundApi
 */
#define addRefundURL            kAbs(DOMAINURL,@"/tztvapi/refund/addRefund")//POST
#define cancelRefundURL         kAbs(DOMAINURL,@"/tztvapi/refund/cancelRefund?refund_id=%@&user_id=%@&token=%@")
#define getRefundGoodsListURL   kAbs(DOMAINURL,@"/tztvapi/refund/getRefundGoodsList?user_id=%@&page=%d&pageSize=10&token=%@")
/**
 * AddressApi
 */
//获取用户配送地址
#define getAddressListURL       kAbs(DOMAINURL,@"/tztvapi/address/getAddressList?user_id=%@&token=%@")
#define addAddressURL           kAbs(DOMAINURL,@"/tztvapi/address/addAddress?user_id=%@&name=%@&phone=%@&address=%@&detail=%@&is_default=%d&token=%@")
#define delAddressURL           kAbs(DOMAINURL,@"/tztvapi/address/delAddress?user_id=%@&id=%@&token=%@")
#define uptAddressURL           kAbs(DOMAINURL,@"/tztvapi/address/uptAddress?user_id=%@&id=%@&name=%@&phone=%@&address=%@&detail=%@&is_default=%d&token=%@")
#define getDefaultAddressURL    kAbs(DOMAINURL,@"/tztvapi/address/getDefaultAddress?user_id=%@&token=%@")
/**
 * MarketApi
 */
#define StartLiveBrandListURL   kAbs(DOMAINURL,@"/tztvapi/market/getBrandList")//getBrandList,brandapi里也有一个
//#define getBrandListByMidURL    kAbs(DOMAINURL,@"/tztvapi/market/getBrandListByMid?")

/**
 * LiveApi
 */
//1获取回放地址
#define getHistoryURL           kAbs(DOMAINURL,@"/tztvapi/live/getHistory?live_id=%@&live_rtmp_play_url=%@")
//2获取主播播放信息
#define getLiveInfoByUidURL     kAbs(DOMAINURL,@"/tztvapi/live/getLiveInfoByUid?user_id=%@")
//3获取直播列表
#define getLiveListURL          kAbs(DOMAINURL,@"/tztvapi/live/getLiveList?city=%@&page=%d&pageSize=%d&location=%@")
//4获取主播列表
#define getLiveUserListURL      kAbs(DOMAINURL,@"/tztvapi/live/getLiveUserList")
//5开启直播
#define startLiveURL            kAbs(DOMAINURL,@"/tztvapi/live/startLive?user_id=%@&live_title=%@&market_name=%@&brand_id=%@&live_img=%@&city=%@&location=%@")

/**
 * ChatApi
 */
//消息发送
#define addChatURL              kAbs(DOMAINURL,@"/tztvapi/chat/addChat?room_id=%@&user_id=%@&nicname=%@&msg_content=%@&token=%@")
//获取直播历史消息
#define getFirstChatListURL     kAbs(DOMAINURL,@"/tztvapi/chat/getFirstChatList?room_id=%@&size=100")
//获取直播实时消息     room_id = live_id
#define getChatListURL          kAbs(DOMAINURL,@"/tztvapi/chat/getChatList?room_id=%@&msg_id=%d&user_id=%@&size=10")
/**
 * ChatNumApi
 */
//点赞
#define addLikeURL              kAbs(DOMAINURL,@"/tztvapi/chatnum/addLike?live_id=%@&user_id=%@&token=%@")
//获取直播信息         live_user_id - 直播用户ID
#define getChatInfoURL          kAbs(DOMAINURL,@"/tztvapi/chatnum/getChatInfo?live_id=%@&live_user_id=%@&user_id=%@")
//获取直播相关数字      live_id - 直播ID
#define getChatNumURL           kAbs(DOMAINURL,@"/tztvapi/chatnum/getChatNum?live_id=%@")
/**
 * CouponApi
 */
//1领取优惠券
#define addCouponURL            kAbs(DOMAINURL,@"/tztvapi/coupon/addCoupon?activity_id=%@&user_id=%@")
//2领取的优惠券列表
#define getCouponListURL        kAbs(DOMAINURL,@"/tztvapi/coupon/getCouponList?user_id=%@")
//3请求手机验证码
#define sendCodeURL             kAbs(DOMAINURL,@"/tztvapi/coupon/sendCode?telephone=%@")
//4校验验证码  id - 短信ID   code - 短信验证码
#define validateCodeURL         kAbs(DOMAINURL,@"/tztvapi/coupon/validateCode?id=%@&code=%@&activity_id=%@&user_id=%@")

//获取Gift礼物数据
#define getGiftURL              kAbs(DOMAINURL,@"/tztvapi/gift/getGift")

/**
 * HtmlUrl
 */
#define aboutTZ_URL             kAbs(DOMAINURL,@"/app/html/about_us.html")
#define shopDetail              kAbs(DOMAINURL,@"/app/html/goods_info.html?goods_id=%@&brand_id=%@")
#define findURL                 kAbs(DOMAINURL,@"/app/html/discover.html")
#define squareURL               kAbs(DOMAINURL,@"/app/html/square.html?market_id=%@")
#define bannerLinkURL           kAbs(DOMAINURL,@"/app/html/banner%d.html")
#define agreeMentURL            kAbs(DOMAINURL,@"/app/html/agreement.html")

#define lingquyouhuiquanhtml    kAbs(DOMAINURL,@"/appcoupon/html/coupon.html?telephone=%@&activity_id=8&user_id=%@")

#endif /* Common_Api_h */







