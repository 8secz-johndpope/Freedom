#
# 前言
Freedom是集合了以下功能系列：
社交类   微信
金融类   支付宝
音乐类   酷狗
视频类   爱奇艺
商务类   淘宝
web2.0  新浪微博
生活类   大众点评
资讯类   今日头条
全网类   聚合数据
公众号   微能量
个人应用
我的简历
书籍收藏
个性特色自由主义
我的数据库
这是一款我自己设计开发的自由主义APP
有个浮标可以自由切换这些功能系列之间。
#
#简介
* 1、功能多样
一般情况下默认一倍图片大小为30，60 ，90
#
#更新记录
* 1、完善了整个APP框架的设计，生成了《王子设计总结初版.rp》。                                                                                                      2016.07.07
* 2、使用Cocoapods建立了整个APP系统层，包括网络请求框架，图片缓存框架，JSON与对象，友盟分享，SharedSDK，提示性信息，数据库，即时聊天，特效以及其他系列功能架构。                 2016.07.14
* 3、建立了整个APP辅助层，包括各个系统类功能的扩展、分类和继承以及基本类，如BaseViewController，categorys,手动导入的三方库。                                              2016.07.22
* 4、完善了APP整个框架的基本配置，如info.plist,PrefixHeader,Foundation,README记录,封装了工具类Utility，导入了应用中可能用到的系列库(Linked Frameworks and Libraries)。  2016.07.25
* 5、建立了Coredata使用框架以及Database使用框架，应用中将充分利用Coredata，Database，Sqlite，Plist，Archive,本地文件(如TXT)读取结合网络请求与JSON解析处理数据。            2016.08.01
* 6、建立了APP整个框架结构的文件夹，有效分类了所有功能系列，并建立了所有功能应用的基础框架，如各自的Storyboard，TabBarViewController，ViewController。                      2016.08.08
* 7、建立了基本的数据库系列，如icons.txt  TotalData  UserData.plist  MyCoreData.xcdatamodeld  Coredata.json                                                     2016.08.12
* 8、引入了APP整个系列功能要用到的通用图标  UserData  JSON  HomePictures，封装了从本地获取图片和从网络获取图片的方法。                                                   2016.08.15
* 9、完成了主界面的代码设计以及流水式左滑设置页面和右滑功能库界面还有基本的配置与搜索界面，浮标的自由切换效果等。                                                             2016.08.20
* 10、修复了已知bug和冲突，如MRC与ARC，Objective和Swift，配置了APPICON，LaunchScreen，真机测试运行成功，并完成了《Freedom框架版.zip》。                               2016.08.22
* 11、初步实现了微信的系列功能。如消息，通讯录，发现，我，朋友圈，个人信息，设置等内容。                                                                                  2016.08.25
* 12、初步实现了新浪微博的系列功能。如获取API，授权，获取微博数据，首页，消息，发微博，发现，我以及一些设置。                                                                2016.08.30
* 13、初步实现了支付宝的系列功能。如支付宝，口碑，朋友，我的，余额宝等。                                                                                               2016.09.05
* 14、初步实现了淘宝的系列功能。如淘宝主页。                                                                                                                      2016.09.07
* 15、初步实现了今日头条的系列功能。如主要框架和响应页面功能，包括首页，视频。                                                                                          2016.09.09
* 16、初步实现了大众点评的系列功能。如首页，闪惠团购，发现，我的。                                                                                                    2016.09.12
* 17、初步实现了酷狗的系列功能。如首页，左侧设置，右侧界面，听，看，唱，本地音乐和播放界面等。                                                                             2016.09.15
* 18、初步实现了爱奇艺的系列功能。如精选视频，服务，订阅推荐，我的，分类，和播放界面等                                                                                    2016.09.20
* 19、初步实现了书籍收藏系列功能。如首页，朋友圈，书籍阅读界面等。                                                                                                    2016.09.23
* 20、初步实现了聚合数据的系列功能。如联系我们，常见问题，数据接口，聚合动态，个人中心等。                                                                                2016.09.25
* 21、初步实现了微能量的系列功能。  如经典案例，新闻动态，主页面，精品人人店，联系我们等页面。                                                                            2016.09.30
* 22、初步实现了个人应用的系列功能。如行业列表界面，企业列表界面，企业详情界面。                                                                                        2016.10.03
* 23、初步实现了我的简历系列功能。如首页，事业合作，理论体系，联系我等。                                                                                               2016.10.05
* 24、初步实现了个性特色自由主义的系列功能。如个性特色自由主义书库界面，书籍阅读界面，编辑页面等。                                                                         2016.10.10
* 25、初步实现了我的数据库系列功能。如数据库首页的集合界面，打开编辑界面。                                                                                             2016.10.15
* 第二步:截获数据接口。生成API.h
* 26、在能力范围之内截获了以上所有APP的数据接口API，并完善了Foundation.h   Foundation_API.h     Foundation_defines.h                                               2016.10.18
* 27、优化了部分功能，重构了系统框架，增加了utility里面的MJExtension文件夹、Tools文件夹、BaseFile文件夹、ThirdPart文件夹。                                               2016.10.20
* 28、在plist中增加大部分访问用户隐私的授权属性，增加摇一摇功能在各个板块之间的跳转。                                                                                    2016.10.21
* 29、完善所有系列功能……………………
* 30、完善封装所有系列功能的类和方法……………………
* 31、测试与初步运营上线………………
* 32、在测试与实践的基础上优化APP……………………
* 33、功能完善，正式投放市场，上线运营。
