import 'package:pigeon/pigeon.dart';

// 代码由 Pigeon 自动生成，切勿修改！！！ 任何修改在重新生成，都会丢失！！！

/// 注意： 该代码由 pigeon 自动生成，切勿修改 ！！！
///
/// Ansjer Camera 核心库
///
@HostApi()
abstract class ACCore {
  /// Ansjer Camera SDK 初始化
  ///
  /// - 参数
  ///   - privateKey 私钥
  ///   - licenseKey 序列号
  @async
  void authorize(String licenseKey, String privateKey);

  /// 获取 Ansjer Camera SDK 版本
  String getSDKVersion();
}

/// Ansjer Camera 辅助方法
@HostApi()
abstract class ACCamHelper {
  /// 搜索本地局域网内的设备
  ///
  /// - [timeoutMs] 搜索超时时间(毫秒)
  List<SearchLanInfo> lanSearch(int timeoutMs);
}

///Ansjer Cammera 内置接口，包含摄像机的基本信息，以及与平台紧密相关的功能处理；
@HostApi()
abstract class ACCam {
  /// 设置 uid
  /// @param uid 设备 uid
  @ObjCSelector("setUid:")
  void setUid(String uid);

  /// 设置 AP 的 ssid
  @ObjCSelector("setApSsid:")
  void setApSsid(String ssid);

  /// 设置设备管理员账户信息
  /// @param account 管理员账户
  /// @param password 管理员密码
  @ObjCSelector("setAccount:password:")
  void setAccount(String account, String password);

  /// 通过 uid、管理员账户、密码连接相机
  void connect();

  /// 通过 AP 连接相机
  void connectByAp();

  /// 连接相机通道
  /// - [channel] av 连接通道
  @ObjCSelector("connectChannel:")
  void connectChannel(int channel);

  /// 与相机断开连接
  void disconnect();

  /// 断开 av 通道
  /// @param channel 通道号
  @ObjCSelector("disconnectChannel:")
  void disconnectChannel(int channel);

  /// 通过 av通道 获取视频画面，内部已做解码
  /// @param channel 通道号
  @ObjCSelector("startReceivingVideoThroughChannel:")
  void startReceivingVideo(int channel);

  /// 停止从 av 通道获取视频数据
  /// @param channel 通道号
  @ObjCSelector("stopReceivingVideoThroughChannel:")
  void stopReceivingVideo(int channel);

  /// 通过 av通道 获取视频原始数据，内部未解码，需要自己解码
  /// @param channel 通道号
  @ObjCSelector("startReceivingRawVideoThroughChannel:")
  void startReceivingRawVideo(int channel);

  /// 通过 av 通道获取音频数据， 内部以解码
  /// @param channel 通道号
  @ObjCSelector("startReceivingSoundThroughChannel:")
  void startReceivingSound(int channel);

  /// 停止获取音频数据
  /// @param channel 通道号
  @ObjCSelector("stopReceivingSoundThroughChannel:")
  void stopReceivingSound(int channel);

  /// 通过 av 通道截图，保存到本地，并控制是否保存到相册
  /// @param channel 通道号
  /// @param path 截图保存路径
  /// @param saveToGallery 是否保存到相册
  @ObjCSelector("takeSnapshotThrougChannel:to:andSaveToGallery:")
  void takeSnapshot(int channel, String path, bool saveToGallery);

  /// 通过 av 通道录制视频
  /// @param channel 通道号
  /// @param limitSeconds 视频最长秒数
  @ObjCSelector("recordVideoThroughChannel:limit:")
  void recordVideo(int channel, int limitSeconds);
}

/// 向摄像机/视频录像机等设备发送指令
@HostApi()
abstract class ACCamCmd {
  /// 通过事件类型、状态，获取指定时间段内的事件列表
  /// @param eventType 事件类型
  /// @param status 事件状态
  /// @param startTime 起始时间
  /// @param endTime 截止时间
  @ObjCSelector("getEventsThroughChannel:withEventType:status:from:to:")
  void getEvents(int channel, int eventType, int status, ACDateTime startTime,
      ACDateTime endTime);

  /// 设置移动侦测区域
  /// @param channel Int av 通道
  /// @param width Int 横向选择区域的格子数量
  /// @param height Int 竖向选择区域的格子数量
  /// @param bits Array<Array<Boolean>> 所有格子的选中状态，选中为 true， 否则为 false
  @ObjCSelector("setMotionDetectArea:width:height:bits:")
  void setMotionDetectArea(
      int channel, int width, int height, List<List<bool>> bits);

  /// 获取移动侦测区域
  /// @param channel Int av 通道
  @ObjCSelector("getMotionDetectArea:")
  void getMotionDetectArea(int channel);

  /// 获取系统时间
  /// @param channel Int av 通道
  @ObjCSelector("getSystemTime:")
  void getSystemTime(int channel);

  /// 设置系统时间
  /// @param channel Int av 通道
  /// @param time String 时间，格式：2018-6-26-10-33-26
  @ObjCSelector("setSystemTime:byChannel:")
  void setSystemTime(String time, int channel);

  /// 获取系统时区
  /// @param channel Int av 通道
  @ObjCSelector("getTimeZone:")
  void getTimeZone(int channel);

  /// 设置 IPC 的时区
  /// @param channel Int av 通道
  /// @param zone String GMT+08:00
  @ObjCSelector("setIpcTimeZone:byChannel:")
  void setIpcTimeZone(int zone, int channel);

  /// 检测是否有用户正在回放视频，系统限制，同时只能有一个用户在线观看
  /// @param channel Int av 通道
  @ObjCSelector("hasUserPlayingback:")
  void hasUserPlayingback(int channel);

  /// 设置推送地址
  /// @param channel Int av通道
  /// @param url String 推送地址
  @ObjCSelector("setPushUrl:byChannel:")
  void setPushUrl(int channel, String url);

  /// 设置 九安 推送地址
  /// @param channel Int av 通道
  /// @param url String 不带 s 的地址
  /// @param urls String 带 s 的地址
  @ObjCSelector("setAndonPushUrl:urls:byChannel:")
  void setAndonPushUrl(String url, String urls, int channel);

  ///  获取低功耗相机的电量
  ///  @param channel Int av 通道
  @ObjCSelector("getPowerOfLowPowerCamera:")
  void getPowerOfLowPowerCamera(int channel);

  ///  设置云存储地址
  ///  @param channel Int 通道号
  ///  @param tokenUrl String 发送给设备，告知设备获取token的路径
  ///  @param postUrl String 发送给设备,告知设备文件在云端的存储路径
  @ObjCSelector("setCloudStorageUrlWithTokenUrl:postUrl:byChannel:")
  void setCloudStorageUrl(String tokenUrl, String postUrl, int channel);

  /// 关闭云存储
  /// @param channel Int av 通道
  @ObjCSelector("turnoffCloudService:")
  void turnoffCloudService(int channel);

  /// 获取云存储状态
  /// @param channel Int av 通道
  @ObjCSelector("getCloudStorageStatus:")
  void getCloudStorageStatus(int channel);

  /// 设置开通云存的摄像头
  /// @todo 确认参数，
  /// @param channel Int 通道号
  @ObjCSelector("setCloudStorageChannel:")
  void setCloudStorageChannel(int channel);

  // TODO: 待确认
  /// 获取调试信息
  @ObjCSelector("getDebugInfo")
  void getDebugInfo();

  /// 获取低电量提醒配置信息
  /// @param channel 通道号
  @ObjCSelector("getLowPowerNotificationConfig:")
  void getLowPowerNotificationConfig(int channel);

  /// 设置低电量提醒级别和开关状态
  /// @param channel Int 通道号
  /// @param level Int 低电量级别，0: 低于10%；1：低于25%；2：低于50%；3：低于75%。4:close;
  /// @param on Boolean 低电量提醒开关, 0：关闭；1：开启
  @ObjCSelector("setLowPowerNotificationLevel:on:byChannel:")
  void setLowPowerNotificationLevel(int level, bool on, int channel);

  /// 设置休眠事件的开关状态
  /// @param channel Int 通道号
  /// @param time Int 时长
  /// @param on Boolean 开关, 0：关闭；1：开启
  @ObjCSelector("setSleepingTime:status:byChannel:")
  void setSleepingTimeStatus(int time, bool on, int channel);

  /// 设置 pir 开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true: 打开 pir 提醒; false: 关闭
  @ObjCSelector("setPirStatus:byChannel:")
  void setPirStatus(bool on, int channel);

  /// 设置 mic 开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开 mic, false 关闭
  @ObjCSelector("setMicStatus:byChannel:")
  void setMicStatus(bool on, int channel);

  /// 设置 led 开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开 mic, false 关闭
  @ObjCSelector("setLedStatus:byChannel:")
  void setLedStatus(bool on, int channel);

  /// 控制云台
  /// @param channel Int 通道号
  /// @param type Int 控制指令
  /// @param step Int 移动步长
  @ObjCSelector("controlPtzType:step:byChannel:")
  void controlPtz(int type, int step, int channel);

  /// 获取 IPC 的调试信息
  @ObjCSelector("getIpcDebugInfo")
  void getIpcDebugInfo();

  /// 获取室内/室外场景模式； 0: 室外模式；1：室内模式
  @ObjCSelector("getSceneMode")
  void getSceneMode();

  /// 设置室内/室外场景模式
  /// @param mode Int 0: 室外模式；1：室内模式
  @ObjCSelector("setSceneMode:byChannel:")
  void setSceneMode(int mode, int channel);

  /// 获取云台巡航模式
  @ObjCSelector("getPtzCruiseMode")
  void getPtzCruiseMode();

  /// 设置声光报警级别
  /// @param level SoundLightAlarmLevel 声光报警级别
  @ObjCSelector("setSoundLightAlarmLevel:byChannel:")
  void setSoundLightAlarmLevel(int level, int channel);

  /// 设置 ipc 的声光报警级别
  /// @param level SoundLightAlarmLevel 声光报警级别
  @ObjCSelector("setIpcSoundLightAlarmLevel:")
  void setIpcSoundLightAlarmLevel(int level);

  /// 设置手动报警的开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 开启手动报警，停止手动报警
  @ObjCSelector("setManualAlarmStatus:byChannel:")
  void setManualAlarmStatus(int channel, bool on);

  /// 设置 IPC 手动报警的开关状态
  /// @param on Boolean true 开启手动报警，停止手动报警
  @ObjCSelector("setIpcManualAlarmStatus:")
  void setIpcManualAlarmStatus(bool on);

  /// 设置声音大小
  /// @param volume Int 大小 [-30 ~ 6]
  @ObjCSelector("setIpcAudioVolume:")
  void setIpcAudioVolume(int volume);

  /// 设置 pir 警示灯开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setPirLightStatus:byChannel:")
  void setPirLightStatus(int channel, bool on);

  /// 设置夜视灯模式
  /// @param mode Int  0-全彩，1-黑白，2-智能
  @ObjCSelector("setIpcNightLightMode:")
  void setIpcNightLightMode(int mode);

  /// 设置夜视灯模式
  /// @param channel Int 通道号
  /// @param mode Int  0-全彩，1-黑白，2-智能
  @ObjCSelector("setNightLightMode:byChannel:")
  void setNightLightMode(int channel, int mode);

  ///  设置 IPC 报警类型
  /// @param type Int 0：人形检测； 1：移动侦测
  @ObjCSelector("setIpcAlarmType:")
  void setIpcAlarmType(int type);

  ///  设置 IPC 报警类型
  /// @param channel Int 通道号
  /// @param type Int 0：人形检测； 1：移动侦测
  @ObjCSelector("setAlarmType:byChannel:")
  void setAlarmType(int type, int channel);

  /// 获取报警配置信息
  @ObjCSelector("getIpcAlarmConfig")
  void getIpcAlarmConfig();

  /// 获取报警配置信息
  /// @param channel Int 通道号
  @ObjCSelector("getAlarmConfigByChannel:")
  void getAlarmConfig(int channel);

  /// 设置移动侦测报警开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setMotionAlarmStatus:byChannel:")
  void setMotionAlarmStatus(bool on, int channel);

  /// 获取移动侦测、人形监测报警开关状态
  /// @param channel Int 通道号
  @ObjCSelector("getMotionHumanoidStatusByChannel:")
  void getMotionHumanoidStatus(int channel);

  /// 设置人形监测报警开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setHumanoidAlarmStatus:byChannel:")
  void setHumanoidAlarmStatus(bool on, int channel);

  /// 设置闪光灯开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setFlickerLightStatus:byChannel:")
  void setFlickerLightStatus(bool on, int channel);

  /// 设置 IPC 闪光灯报警开关状态
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setIpcFlickerLightAlarmStatus:")
  void setIpcFlickerLightAlarmStatus(bool on);

  /// 设置警示灯开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setWarningLightStatus:byChannel:")
  void setWarningLightStatus(bool on, int channel);

  /// 设置红外人形监测的开关状态
  /// @param channel Int
  /// @param on Boolean
  @ObjCSelector("setPirHumanoidStatus:byChannel:")
  void setPirHumanoidStatus(bool on, int channel);

  /// 获取电量信息
  /// @param channel Int 通道号
  @ObjCSelector("getPowerInfoByChannel:")
  void getPowerInfo(int channel);

  /// 获取配置信息，包含录像时长、夜视模式、录像模式、是否有 sd 卡，人形红外开关，红外灵敏度等信息。
  /// 具体参照
  /// @param channel Int
  /// @see CameraSettingsInfo
  @ObjCSelector("getSettingsInfoChannel:")
  void getSettingsInfo(int channel);

  /// 获取所有通道的连接状态
  @ObjCSelector("getAllChannelsConnectStatus")
  void getAllChannelsConnectStatus();

  /// 设置低电量提醒通知开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开，false 关闭
  @ObjCSelector("setLowPowerNotificationStatus:byChannel:")
  void setLowPowerNotificationStatus(bool on, int channel);

  /// 设置时区时间
  /// @param zone ZoneId 时区id
  /// @param time Int 时间
  @ObjCSelector("setZone:time:")
  void setZoneTime(int zone, int time);

  // TODO: 确认夏令时的请求和响应数据
  /// 设置夏令时
  /// @todo 确认请求参数和响应
  @ObjCSelector("setDaylightSavingTime")
  void setDaylightSavingTime();

  /// 设置时间系统
  /// @param system Int 时间系统， 1： 12小时制  2：24小时制
  @ObjCSelector("setTimeSystem:")
  void setTimeSystem(int system);

  /// 获取系统时间配置信息（夏令时、12/24小时制等）
  @ObjCSelector("getTimeConfig")
  void getTimeConfig();

  // TODO: 测试超过 31 个字节会出现的问题
  /// 设置通道名称
  /// @param channel Int 通道号
  /// @param name String 通道名； > 注意：设备端定义的是 36 个字节，但是传递31个以上的字节时，设备端会出现问题
  /// @todo 确认这里的 channel 是通道号还是 cameraIndex
  @ObjCSelector("setChannel:name:")
  void setChannelName(int channel, String name);

  // TODO: 确认参数类型
  /// 获取所有通道的名称
  @ObjCSelector("getAllChannelsNames")
  void getAllChannelsNames();

  /// 设置每周录制时段
  /// @param channel Int 通道
  /// @param hours Array<Array<Boolean>> 7 x 24 的二维数组，一周划分为7天, 每天 24 小时，录制为 true， 否则为 false
  /// @param type Int 0 常规录像 1移动侦测录像 2智能报警录像
  @ObjCSelector("setRecordingHours:type:byChannel:")
  void setRecordingHours(int channel, List<List<bool>> hours, int type);

  /// 获取每周的录制时段
  /// @param channel Int 通道号
  /// @param type Int 0 常规录像 1移动侦测录像 2智能报警录像
  @ObjCSelector("getRecordingHoursBytype:channel:")
  void getRecordingHours(int channel, int type);

  /// 获取单个摄像机名称
  /// @param channel av通道
  /// @param cameraIndex 摄相机编号
  @ObjCSelector("getChannelNameWithCameraIndex:byChannel:")
  void getCameraName(int cameraIndex, int channel);

  /// 设置指示灯开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setIndicatorLightStatus:byChannel:")
  void setIndicatorLightStatus(bool on, int channel);

  /// 获取指示灯开关状态
  /// @param channel Int 通道号
  @ObjCSelector("getIndicatorLightStatusByChannel:")
  void getIndicatorLightStatus(int channel);

  /// 获取网络指示灯状态
  /// @param channel Int 通道号
  @ObjCSelector("getNetworkLightStatusByChannel:")
  void getNetworkLightStatus(int channel);

  /// 设置网络指示灯状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setNetworkLightStatus:byChannel:")
  void setNetworkLightStatus(bool on, int channel);

  /// 设置个性化语音开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true 打开， false 关闭
  @ObjCSelector("setCustomVoiceStatus:byChannel:")
  void setCustomVoiceStatus(bool on, int channel);

  /// 设置化语音
  /// @param channel Int 通道号
  /// @param voiceUrl String 个性化语音下载地址
  /// @param index Int 语音索引号（暂时不知道是什么作用）
  /// @param entering Boolean true 进入特定区域播放的语音，false 离开特定区域播放的语音
  @ObjCSelector("setCustomVoiceUrl:atIndex:forEntering:byChannel:")
  void setCustomVoice(String voiceUrl, int index, bool entering, int channel);

  /// 设置一周监控时段开关状态
  /// @param channel Int 通道号
  /// @param start DateTime 监控开始时间
  /// @param end DateTime 监控结束时间
  /// @param onWeekDays List<bool> 7 个 布尔值数组，代表一周内七天监控时段开关状态
  @ObjCSelector("setWeekMonitoringSchedule:from:to:byChannel:")
  void setWeekMonitoringSchedule(
      List<bool> schedule, ACDateTime start, ACDateTime end, int channel);

  /// 获取人形检测开关状态
  /// @param channel Int 通道号
  @ObjCSelector("getHumanoidDetectStatusByChannel:")
  void getHumanoidDetectStatus(int channel);

  /// 设置人形检测开关状态
  /// @param channel Int 通道号
  /// @param on Boolean true打开，false 关闭
  @ObjCSelector("setHumanoidDetectStatus:byChannel:")
  void setHumanoidDetectStatus(bool on, int channel);

  /// 获取一个月内指定时间段内有录制文件的日期列表
  /// @param channel Int 通道
  /// @param startTime DateTime 开始时间
  /// @param endTime DateTime 结束时间
  @ObjCSelector("getDaysHasRecordingFilesFrom:to:byChannel:")
  void getDaysHasRecordingFiles(
      ACDateTime startTime, ACDateTime endTime, int channel);

  /// 获取所有支持的报警类型
  /// @param channel Int 通道号
  @ObjCSelector("getSupportedAlarmTypesByChannel:")
  void getSupportedAlarmTypes(int channel);

  /// 设置录制视频质量
  /// @param quality Int 0：为高清，1：为流畅
  @ObjCSelector("setRecordingVideoQuality:")
  void setRecordingVideoQuality(int quality);

  /// 设置隐私遮挡区域及开关状态
  /// @param channel Int 通道号
  /// @param areas Array<PrivacyOcclusionArea> 隐私遮挡区域，最多 5 个
  /// @param on Boolean true 开启隐私遮挡功能，false 关闭
  @ObjCSelector("setPrivacyOcclusionAreas:status:byChannel:")
  void setPrivacyOcclusion(
      List<PrivacyOcclusionArea> areas, bool on, int channel);

  /// 获取隐私遮挡区域及开关状态
  /// @param channel Int 通道号
  @ObjCSelector("getPrivacyOcclusionByChannel:")
  void getPrivacyOcclusion(int channel);

  /// 设置算法开关状态
  /// @param channel Int 通道号
  /// @param on Array<Boolean> 6个元素的数组，依次为  移动侦测 、人形、车型 、人脸 、宠物 、异响 的开关状态， true 开启
  @ObjCSelector("setAlgorithmsStatus:byChannel:")
  void setAlgorithmsStatus(List<bool> on, int channel);

  /// 获取算法开关状态
  /// @param channel Int 通道号
  @ObjCSelector("getAlgorithmsStatusByChannel:")
  void getAlgorithmsStatus(int channel);

  /// 设置算法区域
  /// @param channel Int 通道号
  /// @param area Area 区域
  @ObjCSelector("setAlgorithmArea:byChannel:")
  void setAlgorithmArea(Area area, int channel);

  /// 获取算法区域
  /// @param channel Int 通道号
  @ObjCSelector("getAlgorithmAreaByChannel:")
  void getAlgorithmArea(int channel);

  /// 设置异响分贝级别，达到该分贝级别，触发异响报警
  /// @param channel Int 通道号
  /// @param decibel Int 分贝值 1: low;  2:medium; 3: high
  @ObjCSelector("setAbnormalDecibel:byChannel:")
  void setAbnormalDecibel(int decibel, int channel);

  /// 获取异响分贝级别
  /// @param channel Int 通道号
  @ObjCSelector("getAbnormalDecibelByChannel:")
  void getAbnormalDecibel(int channel);
}

/// 接收来自摄像机/视频录像机等设备的响应
///
/// 在 原生 SDK 中，以代理接口的方式告诉指令请求发送者，设备端的响应结果
///
/// 在 flutter SDK 中，通过 flutter 和 原生之间通道，告诉 flutter ，设备端的响应结果
@HostApi()
@FlutterApi()
abstract class ACCamCmdResp {
  /// 设置移动侦测区域响应
  /// @param uid String 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetMotionDetectAreaByChannel:")
  void cameraDidSetMotionDetectArea(String uid, int channel);

  /// 获取移动侦测区域响应
  /// @param uid String 设备 uid
  /// @param area 侦测区域
  /// @param channel av通道
  @ObjCSelector("camera:didGetMotionDetectArea:byChannel:")
  void cameraDidGetMotionDetectArea(
      String uid, MotionDetectArea area, int channel);

  /// 获取设备系统时间响应
  /// @param uid 设备 uid
  /// @param time 设备系统时间
  /// @param success true 获取成功， false 获取失败
  /// @param channel av 通道
  @ObjCSelector("camera:didGetSystemTime:success:byChannel:")
  void cameraDidGetSystemTime(
      String uid, String? time, bool success, int channel);

  /// 设置设备时间系统响应
  /// @param uid: 设备
  /// @param success: true 设置成功， false 设置失败
  /// @param channel av通道
  @ObjCSelector("camera:didGetSystemTimeSuccess:byChannel:")
  void cameraDidSetSystemTimeSuccess(String uid, bool success, int channel);

  /// 获取设备时区响应
  /// @param uid 设备 uid
  /// @param zone 时区
  /// @param channel av通道
  @ObjCSelector("camera:didGetTimeZone:byChannel:")
  void cameraDidGetTimeZone(String uid, int zone, int channel);

  /// 设置时区响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetTimeZoneByChannel:")
  void cameraDidSetTimeZone(String uid, int channel);

  /// 查询是否有用户正在回放
  /// @param uid 设备 uid
  /// @param playingBack true 有人正在回放，false 没有人正在回放。
  /// @param channel av通道
  @ObjCSelector("camera:hasUserPlayingback:byChannel:")
  void cameraHasUserPlayingback(String uid, bool playingBack, int channel);

  /// 设置推送地址响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetPushUrlByChannel:")
  void cameraDidSetPushUrl(String uid, int channel);

  /// 获取低功耗设备电量响应
  /// @param uid 设备 uid
  /// @param powers: 16 个通道的电量信息，数组中的每一个元素代表一个通道的电量信息
  /// @param channel av通道
  @ObjCSelector("camera:didGetPowerOfLowPowerCamera:byChannel:")
  void cameraDidGetPowerOfLowPowerCamera(
      String uid, List<int> powers, int channel);

  /// 设置云存储地址响应
  /// @param uid 设备 uid
  /// @param isCloudStorageOn: true 已启用云存储，false 已关闭云存储
  /// @param channel av通道
  @ObjCSelector("camera:didSetCloudStorageUrl:byChannel:")
  void cameraDidSetCloudStorageUrl(
      String uid, bool isCloudStorageOn, int channel);

  /// 关闭云存储响应
  /// @param uid 设备 uid
  /// @param isCloudStorageOn: true 已启用云存储，false 已关闭云存储
  /// @param channel av通道
  @ObjCSelector("camera:didTurnOffCloudStorage:byChannel:")
  void cameraDidTurnOffCloudStorage(
      String uid, bool isCloudStorageOn, int channel);

  /// 获取云存储状态响应
  /// @param uid 设备 uid
  /// @param isCloudStorageOn: true 已启用云存储，false 已关闭云存储
  /// @param channel av通道
  @ObjCSelector("camera:didGetCloudStorageStatus:byChannel:")
  void cameraDidGetCloudStorageStatus(
      String uid, bool isCloudStorageOn, int channel);

  /// 获取调试信息响应
  /// @todo 待确认
  void cameraDidGetDebugInfo();

  /// 获取低功耗设备配置信息响应
  /// @param uid 设备 uid
  /// @param config 配置信息
  /// @param success true 获取成功，false 获取失败
  /// @param channel av通道
  @ObjCSelector("camera:didGetLowPowerNotificationConfig:success:byChannel:")
  void cameraDidGetLowPowerNotificationConfig(
      String uid, LowPowerNotificationConfig config, bool success, int channel);

  /// 设置低电量通知提醒级别响应
  /// @param uid 设备 uid
  /// @param success true 成功，false 失败
  /// @param channel av通道
  @ObjCSelector("camera:didSetLowPowerNotificationLevelSuccess:byChannel:")
  void cameraDidSetLowPowerNotificationLevel(
      String uid, bool success, int channel);

  /// 设置休眠时间响应
  /// @param uid 设备 uid
  /// @param success true 成功，false 失败
  /// @param channel av通道
  @ObjCSelector("camera:didSetSleepingTimeStatusSuccess:byChannel:")
  void cameraDidSetSleepingTimeSuccess(String uid, bool success, int channel);

  /// 设置 Pir 开关响应
  /// @param uid 设备 uid
  /// @param success true 成功，false 失败
  /// @param channel av通道
  @ObjCSelector("camera:didSetPirStatusSuccess:byChannel:")
  void cameraDidSetPirStatus(String uid, bool success, int channel);

  /// 设置 mic 开关响应
  /// @param uid 设备 uid
  /// @param success true 成功，false 失败
  /// @param channel av通道
  @ObjCSelector("camera:didSetMicStatusSuccess:byChannel:")
  void cameraDidSetMicStatus(String uid, bool success, int channel);

  /// 设置 led 开关响应
  /// @param uid 设备 uid
  /// @param success true 成功，false 失败
  /// @param channel av通道
  @ObjCSelector("camera:didSetLedStatusSuccess:byChannel:")
  void cameraDidSetLedStatus(String uid, bool success, int channel);

  /// 控制云台响应
  /// @param uid 设备 uid
  /// @param command 云台指令码
  /// @param channel av通道
  @ObjCSelector("camera:didControlPztWithCommand:byChannel:")
  void cameraDidControlPzt(String uid, int command, int channel);

  /// @todo 需要补充
  void cameraDidGetIpcDebugInfo();

  ///  获取场景模式响应
  /// @param uid 设备 uid
  /// @param mode 环境模式，0: 室外模式；1：室内模式
  /// @param channel av通道
  @ObjCSelector("camera:didGetSceneMode:byChannel:")
  void cameraDidGetSceneMode(String uid, int mode, int channel);

  /// 设置场景模式响应
  /// @param uid 设备 uid
  /// @param success true 成功， false 失败
  /// @param channel av通道
  @ObjCSelector("camera:didSetSceneModeSuccess:byChannel:")
  void cameraDidSetSceneMode(String uid, bool success, int channel);

  /// 获取云台巡航模式响应
  /// @param uid 设备 uid
  /// @param mode  1：自动巡航, 2：预设点巡航
  /// @param channel av通道
  @ObjCSelector("camera:didGetPtzCruiseMode:byChannel:")
  void cameraDidGetPtzCruiseMode(String uid, int mode, int channel);

  /// 设置声光警报级别响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetSoundLightAlarmLevelByChannel:")
  void cameraDidSetSoundLightAlarmLevel(String uid, int channel);

  /// 设置手动报警开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetManualAlarmStatusByChannel:")
  void cameraDidSetManualAlarmStatus(String uid, int channel);

  /// 设置声音响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetAudioVolumeByChannel:")
  void cameraDidSetAudioVolume(String uid, int channel);

  /// 设置 pir 灯 响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetPirLightStatusByChannel:")
  void cameraDidSetPirLightStatus(String uid, int channel);

  /// 设置夜视灯光模式响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetNightLightModeByChannel:")
  void cameraDidSetNightLightMode(String uid, int channel);

  /// 设置报警类型（人形 / 移动）响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetAlarmTypeByChannel:")
  void cameraDidSetAlarmType(String uid, int channel);

  /// IPC 获取报警配置信息响应
  /// @param uid 设备 uid
  /// @param config 配置信息
  /// @param channel av通道
  @ObjCSelector("camera:didGetIpcAlarmConfig:byChannel:")
  void cameraDidGetIpcAlarmConfig(
      String uid, IPCAlarmConfig conifg, int channel);

  /// (视频录像机)获取报警配置信息响应
  /// @param uid 设备 uid
  /// @param config 配置信息
  /// @param channel av通道
  @ObjCSelector("camera:didGetAlarmConfig:byChannel:")
  void cameraDidGetAlarmConfig(
      String uid, GetVRAlarmConfigResp conifg, int channel);

  /// 设置移动侦测报警开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetMotionAlarmStatusByChannel:")
  void cameraDidSetMotionAlarmStatus(String uid, int channel);

  /// 获取移动侦测、人形侦测报警开关状态响应
  /// @param uid 设备 uid
  /// @param isMotionOn true 移动侦测报警打开，否则关闭
  /// @param isHumanoidOn true 人形侦测报警打开，否则关闭
  /// @param channel av通道
  @ObjCSelector("camera:didGetMotionStatus:humanoidStatus:byChannel:")
  void cameraDidGetMotionHumanoidStatus(
      String uid, bool isMotionOn, bool isHumanoidOn, int channel);

  /// 设置人形侦测报警开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetHunmanoidAlarmStatusByChannel:")
  void cameraDidSetHunmanoidAlarmStatus(String uid, int channel);

  /// 设置闪关灯报警开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetIpcFlickerLightAlarmStatusByChannel:")
  void cameraDidSetIpcFlickerLightAlarmStatus(String uid, int channel);

  /// 设置警示灯开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetWarningLightStatusByChannel:")
  void cameraDidSetWarningLightStatus(String uid, int channel);

  /// 设置红外人形检测开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetPirHumanoidStatusByChannel:")
  void cameraDidSetPirHumanoidStatus(String uid, int channel);

  /// @todo 待补充
  void cameraDidGetPowerInfo(String uid, PowerInfo info, int channel);

  // @todo 待补充
  void cameraDidGetSettingsInfo(String uid, SettingsInfo info, int channel);

  // @todo 待补充
  void cameraDidGetAllChannelsConnectStatus(String uid, int channel);

  /// 设置低电量开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetLowPowerNotificationStatusByChannel:")
  void cameraDidSetLowPowerNotificationStatus(String uid, int channel);

  /// 设置时区时间响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didZoneTimeByChannel:")
  void cameraDidSetZoneTime(String uid, int channel);

  /// 设置夏令时响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetDayLightSavingTimeByChannel:")
  void cameraDidSetDayLightSavingTime(String uid, int channel);

  /// 设置时间系统回调 12 / 24 小时制 响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetTimeSystemByChannel:")
  void cameraDidSetTimeSystem(String uid, int channel);

  /// 获取时间相关的配置信息响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didGetTimeConfig:byChannel:")
  void cameraDidGetTimeConfig(
      String uid, GetTimeConfigResp config, int channel);

  /// 设置通道名称响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetChannelNameByChannel:")
  void cameraDidSetChannelName(String uid, int channel);

  /// 获取到所有通道的名称
  /// @param uid 设备 uid
  /// @param names  相机名称列表
  /// @param channel av通道
  @ObjCSelector("camera:didGetAllChannelNames:byChannel:")
  void cameraDidGetAllChannelNames(
      String uid, List<CameraName> names, int channel);

  /// 设置每周录制时段响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:setRecordingHoursByChannel:")
  void cameraDidSetRecordingHours(String uid, int channel);

  /// 获取每周录制时段响应
  /// @param uid 设备 uid
  /// @param hours 表示一周划分为 7 * 24 的时段，元素为 true 时，表示该时段录制，否则不录制
  /// @param type 录像类型，0 常规录像 1移动侦测录像 2智能报警录像
  /// @param channel av通道
  @ObjCSelector("camera:didGetRecordingHours:byType:channel:")
  void cameraDidGetRecordingHours(
      String uid, List<List<bool>> hours, int type, int channel);

  /// 获取摄像头名称响应
  /// @param uid 设备 uid
  /// @param 摄像机名称
  /// @param channel av通道
  @ObjCSelector("camera:didGetCameraName:byChannel:")
  void cameraDidGetCameraName(String uid, CameraName name, int channel);

  /// 设置指示灯开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetIndicatorLightStatusByChannel:")
  void cameraDidSetIndicatorLightStatus(String uid, int channel);

  /// 获取指示灯开关状态响应
  /// @param uid 设备 uid
  /// @param on true 打开，false 关闭
  /// @param channel av通道
  @ObjCSelector("camera:didGetIndicatorLightStatus:byChannel:")
  void cameraDidGetIndicatorLightStatus(String uid, bool on, int channel);

  /// 设置网络指示灯开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetNetworkLightStatusByChannel:")
  void cameraDidSetNetworkLightStatus(String uid, int channel);

  /// 获取网络指示灯开关状态响应
  /// @param uid 设备 uid
  /// @param on true 打开，false 关闭
  /// @param channel av通道
  @ObjCSelector("camera:didGetNetworkLightStatus:byChannel:")
  void cameraDidGetNetworkLightStatus(String uid, bool on, int channel);

  /// 设置个性化语音开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetCustomVoiceStatusByChannel:")
  void cameraDidSetCustomVoiceStatus(String uid, int channel);

  /// 设置个性化语音响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetCustomVoiceByChannel:")
  void cameraDidSetCustomVoice(String uid, int channel);

  /// 设置一周监控时段开关状态响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetWeekMonitoringScheduleByChannel:")
  void cameraDidSetWeekMonitoringSchedule(String uid, int channel);

  /// 获取人形检测开关响应
  /// @param uid 设备 uid
  /// @param on true 打开，false 关闭
  /// @param channel av通道
  @ObjCSelector("camera:didGetHumanoidDetectStatus:byChannel:")
  void cameraDidGetHumanoidDetectStatus(String uid, bool on, int channel);

  /// 设置人形检测开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetHumanoidDetectStatusByChannel:")
  void cameraDidSetHumanoidDetectStatus(String uid, int channel);

  /// 获取一个月内指定时间段有录制文件的日期列表响应
  /// 设置人形检测开关响应
  /// @param uid 设备 uid
  /// @param days 有录制文件的日期列表
  /// @param channel av通道
  @ObjCSelector("camera:didGetDaysHasRecordingFiles:byChannel:")
  void cameraDidGetDaysHasRecordingFiles(
      String uid, List<String> days, int channel);

  /// 获取支持的检测类型响应
  /// @param uid 设备 uid
  /// @param types 支持的类型
  /// @param channel av通道
  @ObjCSelector("camera:didGetSupportedAlarmType:byChannel:")
  void cameraDidGetSupportedAlarmType(
      String uid, SupportedAlarmType types, int channel);

  /// 获取指定事件段内的事件列表的响应
  /// @param uid 设备 uid
  /// @param resp 事件列表
  /// @param channel av通道
  @ObjCSelector("camera:DidGetEvents:byChannel:")
  void cameraDidGetEvents(String uid, GetEventsResponse resp, int channel);

  /// 设置录像分辨率响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetRecordingResolutionByChannel:")
  void cameraDidSetRecordingResolution(String uid, int channel);

  /// 设置隐私遮挡响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetPrivacyOcclusionByChannel:")
  void cameraDidSetPrivacyOcclusion(String uid, int channel);

  /// 获取隐私遮挡区域响应
  /// @param uid 设备 uid
  /// @param area 遮挡区域
  /// @param channel av通道
  @ObjCSelector("camera:didGetPrivacyOcclusion:byChannel:")
  void cameraDidGetPrivacyOcclusion(
      String uid, PrivacyOcclusionArea area, int channel);

  /// 设置算法开关响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetAlgorithmStausByChannel:")
  void cameraDidSetAlgorithmStaus(String uid, int channel);

  /// 获取算法开关响应
  /// @param uid 设备 uid
  /// @param status 算法开关状态
  /// @param channel av通道
  @ObjCSelector("camera:didGetAlgorithmStaus:byChannel:")
  void cameraDidGetAlgorithmStaus(
      String uid, AIAlgorithmStatus status, int channel);

  /// 设置算法区域响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetAlgorithmAreaByChannel:")
  void cameraDidSetAlgorithmArea(String uid, int channel);

  /// 获取算法区域响应
  /// @param uid 设备 uid
  /// @param area 算法区域
  /// @param channel av通道
  @ObjCSelector("camera:didGetAlgorithmArea:byChannel:")
  void cameraDidGetAlgorithmArea(String uid, AIAlgorithmArea area, int channel);

  /// 设置异响级别响应
  /// @param uid 设备 uid
  /// @param channel av通道
  @ObjCSelector("camera:didSetAbnormalDecibelByChannel:")
  void cameraDidSetAbnormalDecibel(String uid, int channel);

  /// 获取异响级别响应
  /// @param uid 设备 uid
  /// @param decibel 异响级别 1: low;  2:medium; 3: high
  /// @param channel av通道
  @ObjCSelector("camera:didGetAbnormalDecibel:byChannel:")
  void cameraDidGetAbnormalDecibel(String uid, int decibel, int channel);
}

/// 注意： 该代码由 pigeon 自动生成，切勿修改 ！！！
///
/// 操控相机的接口
@HostApi()
abstract class CameraMessage {
  /// 创建相机
  /// [cameraInfo]  相机信息
  @ObjCSelector("createCamera:")
  void createCamera(CameraInfo cameraInfo);

  /// 连接相机
  /// [cameraInfo]  相机信息
  @ObjCSelector("connectCamera:")
  void connectCamera(String uid);

  /// 连接相机通道
  ///
  /// - [uid] 相机 uid
  /// - [channel] 通道号
  @ObjCSelector("connectChannelWithUid:channel:")
  void connectChannel(String uid, int channel);

  /// 断开相机连接
  /// - [uid]  相机 uid
  @ObjCSelector("disconnectCamera:")
  void disconnectCamera(String uid);

  /// 断开通道连接
  void disconnectChannel(String uid, int channel);

  /// 指定相机通道 [channelId] 回传的视频画面渲染到播放器 [monitorId] 上
  ///
  void attachToMonitor(int monitorId, String uid, int channelId);

  /// 相机解除播放器绑定关系
  void detachMonitor(int monitorId, String uid);

  /// 请求开始出图
  /// - [uid] 相机uid
  /// - [channel] 通道号
  /// - [isSoftwareDecode] 是否使用软解
  void startReceiveingVideoFrames(
      String uid, int channel, bool isSoftwareDecode);

  /// 停止出图
  /// - [uid] 相机 uid
  /// - [channel] 通道号
  void stopReceivingVideoFrame(String uid, int? channel);

  /// 向相机发送指令
  ///
  /// - [uid] 相机 uid
  /// - [command] 指令信息
  /// @see CameraCommand
  void sendCommand(String uid, CameraCommand command);

  ///对讲音频格式设置
  /// - [uid] 相机 uid
  /// - [channel] 通道号
  /// - [audioFormat] 音频格式 (目前的格式：318)
  void setAudioInputCodecId(String uid, int channel, int audioFormat);

  /// 开始向相机发送音频，内部会进行音频的采集、编码、发送
  /// - [uid] 相机 uid
  /// - [channel] 通道号
  void startSendingSoundToCamera(String uid, int channel);

  /// 停止音频采集、编码、发送
  ///
  /// - [uid] 相机 uid
  /// - [channel] 通道号
  void stopSendingSoundToCamera(String uid, int channel);

  /// 开始接收Device端的音频数据，内部会进行音频的接收、解码、播放
  ///
  /// - [uid] 设备 uid
  /// - [channel] 通道号
  void startReceivingSoundFormCamera(String uid, int channel);

  /// 停止音频接收、解码、播放
  /// - [uid] 设备 uid
  /// - [channel] 通道号
  void stopReceivingSoundFormCamera(String uid, int channel);

  /// 设置音频播放模式
  ///
  /// - mode 0 外放模式，1 听筒模式(耳机模式)
  void setAudioPlayMode(String uid, int mode);

  /// 直播截图
  ///
  /// - [uid] 相机id
  /// - [channel] 通道号
  /// - [targetUrl] 截图保存路径
  bool takeASnapShot(String uid, int channel, String targetUrl);

  /// 录制视频
  ///
  /// - [uid] 相机id
  /// - [channel] 通道号
  /// - [targetUrl] 录制的视频保存位置
  /// - [durationMs] 最大录制时长，单位为 毫秒
  bool startRecording(
    String uid,
    int channel,
    String targetUrl,
    int durationMs,
  );

  /// 停止录制视频
  /// - [uid] 相机id
  /// - [channel] 通道号
  bool stopRecording(String uid, int channel);

  /// 获取当前音频播放模式
  ///
  /// @return 0 外放模式，1 听筒模式(耳机模式)
  // int getAudioPlayMode(String uid);

  /// 判断与相机是否已经建立连线
  ///
  /// @return 是否连线
  bool isCameraConnected(String uid);

  /// 判断与相机通道是否已经建立连接
  ///
  /// @return 是否连线
  bool isChannelConnected(String uid, int channel);
}

/// 注意： 该代码由 pigeon 自动生成，切勿修改 ！！！
///
/// 相机基本信息
class CameraInfo {
  CameraInfo({
    required this.password,
    required this.account,
    required this.uid,
    this.name,
  });

  /// 相机名称
  String? name;

  /// 相机管理账户
  final String account;

  /// 相机管理账户的密码
  String password;

  /// 相机 uid
  final String uid;
}

/// 注意： 该代码由 pigeon 自动生成，切勿修改 ！！！
///
/// 相机指令数据结构
class CameraCommand {
  const CameraCommand({
    required this.type,
    required this.data,
    required this.channelId,
  });

  /// 通道
  final int channelId;

  /// 指令携带数据
  final List<int?> data;

  /// 指令类型
  final int type;
}

/// wifi 信息
class WifiInfo {
  WifiInfo({required this.ssid, this.password});

  final String? password;
  final String ssid;
}

/// 注意： 该代码由 pigeon 自动生成，切勿修改 ！！！
///
/// 通用错误信息
class MessageError {
  MessageError({required this.code, this.messge});

  final String code;
  final String? messge;
}

/// IOCTLisner 回传的事件模型
class IotcEvent {
  IotcEvent({
    required this.uid,
    this.resultCode,
    required this.eventType,
    this.channel,
    this.data,
    this.avIOCtrlMsgType,
  });

  final int? avIOCtrlMsgType;
  final int? channel;
  final List<int>? data;
  final int eventType;
  final int? resultCode;
  final String uid;
}

/// 通道、流
class ChannelStream {
  final int channel;
  final int index;
  const ChannelStream(this.channel, this.index);
}

class SearchLanInfo {
  final List<int?>? uid;
  final List<int?>? ip;
  final int? port;

  SearchLanInfo({this.uid, this.ip, this.port});
}

class Wifi {
  final String ssid;
  final int mode;
  final int encryptType;

  /// 信号强度 0 ~ 100%
  final int signal;
  final int status;
  const Wifi(this.ssid, this.mode, this.encryptType, this.signal, this.status);
}

/// 事件列表响应结果
///
class GetEventsResponse {
  final int channel;
  final int total;
  final int index;
  final int count;
  final bool isAllEventsLoaded;
  final List<Event?>? events;
  const GetEventsResponse(this.channel, this.total, this.index, this.count,
      this.isAllEventsLoaded, this.events);
}

/// 相机事件
class Event {
  final int eventType;
  final int status;
  final int time;

  const Event(this.eventType, this.status, this.time);
}

/// 音频格式信息
class AudioFormatInfo {
  final int channel;
  final int codec;
  final int sampleRate;
  final int dataBits;
  final int channels;

  /// 0子通道; 1主通道; otherwise 子通道（默认0）
  final int servChannel;

  const AudioFormatInfo(this.channel, this.codec, this.sampleRate,
      this.dataBits, this.channels, this.servChannel);
}

class ChannelNameInfo {
  final String name;
  final int index;

  const ChannelNameInfo(this.name, this.index);
}

class VideoFrameInfo {
  final int videoCodec;
  final int channel;
  final int onlineNum;
  final int timestamp;
  final int videoWidth;
  final int videoHeight;

  const VideoFrameInfo(this.videoCodec, this.channel, this.onlineNum,
      this.timestamp, this.videoWidth, this.videoHeight);
}

class ACDateTime {
  ACDateTime(
      {required this.year,
      required this.month,
      required this.day,
      required this.time});
  final int year;
  final int month;
  final int day;
  final ACTime time;
}

class ACTime {
  final int hour;
  final int minute;
  final int second;

  ACTime({required this.hour, required this.minute, required this.second});
}

/// 隐私遮挡区域
/// @property x double
/// @property y double
/// @property width double
/// @property height double
/// @property color Long
/// @constructor
/// @todo 确认每个参数表达的含义
class PrivacyOcclusionArea {
  final double x;
  final double y;
  final double width;
  final double height;
  final int color;

  PrivacyOcclusionArea({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
  });
}

/// 区域空间
/// @property x Int
/// @property y Int
/// @property width Int
/// @property height Int
/// @constructor
class Area {
  final int x;
  final int y;
  final int width;
  final int height;
  Area({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

/// 移动侦测区域数据结构
///
/// @detail data
class MotionDetectArea {
  MotionDetectArea({
    required this.width,
    required this.height,
    required this.data,
  });
  final int width;
  final int height;
  final List<List<bool?>?> data;
}

/// 低功耗设备提醒配置信息
class LowPowerNotificationConfig {
  final bool isPowerLowNotifyOn;
  final int triggerPercent;
  final bool isSleepingNotificationOn;
  final bool neverSleep;
  final int sleepTime;
  final int motionPushInterval;
  final int pirPushInterval;
  final bool isPirOn;
  final bool isMicOn;
  final bool isLedOn;

  LowPowerNotificationConfig(
      {required this.isPowerLowNotifyOn,
      required this.triggerPercent,
      required this.isSleepingNotificationOn,
      required this.neverSleep,
      required this.sleepTime,
      required this.motionPushInterval,
      required this.pirPushInterval,
      required this.isPirOn,
      required this.isMicOn,
      required this.isLedOn});
}

/// IPC 告警配置信息
class IPCAlarmConfig {
  /// 告警类型 0:人形，1: 移动侦测
  final int alarmType;

  /// 告警级别 0:关闭 1:大声强光 2:小声弱光 3:大声 4. 小声 5. 强光
  final int alarmLevel;

  /// 手动人为告警 0:关闭1:开启
  final bool isManualAlarmOn;

  /// 夜间模式灯光 0:全彩  1:黑白  2:智能
  final int nightLightMode;

  /// 音量大小[-30,6]
  final int audioVolume;

  IPCAlarmConfig(
      {required this.alarmType,
      required this.alarmLevel,
      required this.isManualAlarmOn,
      required this.nightLightMode,
      required this.audioVolume});
}

class GetVRAlarmConfigResp {
  int cameraIndex;

  /// 0为人形 1为移动    ，3是人形和移动侦测0x0f:忽略
  final int alarmType;

  ///  0: 关闭   1：强烈声光告警   2：轻微声光告警  3: 强烈声告警4:轻微声告警5:强烈光告警  0x0f  忽略当前结构体
  final int alarmLevel;

  /// 人为告警0关1开
  final bool isManualAlarmOn;

  /// 夜视模式: 0:全彩夜视 开灯 1:黑白夜视 2:智能夜视
  final int nightLightMode;

  /// 音量值0-100
  final int audioVolume;

  /// 1: succ  -1: get info fail  0: video loss
  final bool status;

  /// 长亮
  final int longLight;

  /// 0 声光都不支持 1支持声的设备 2 支持光的设备 3支持声光的设备
  final int supportSoundLight;

  /// 0 不支持人形检测       1支持人形检测
  final int supportHuman;

  /// reserved[0]用作警示灯状态，1：开，2：关，0：没有这个功能
  final List<int?> reserved;

  /// 获取视频录像告警配置信息的响应模型
  GetVRAlarmConfigResp({
    required this.cameraIndex,
    required this.alarmType,
    required this.alarmLevel,
    required this.isManualAlarmOn,
    required this.nightLightMode,
    required this.audioVolume,
    required this.status,
    required this.longLight,
    required this.supportSoundLight,
    required this.supportHuman,
    required this.reserved,
  });
}

/// @todo 待补充
class PowerInfo {}

/// @todo 待补充
class SettingsInfo {}

/// @todo 待补充
class GetTimeConfigResp {}

/// 摄像机名称
class CameraName {
  /// 名称
  final int name;

  /// 相机索引
  final int cameraIndex;

  CameraName({required this.name, required this.cameraIndex});
}

/// 支持的报警类型信息
class SupportedAlarmType {
  /// 是否支持人形检测 0 不支持 1支持
  final bool supportHuman;

  /// 是否支持人脸检测 0不支持 1支持
  final bool supportFace;

  /// 是否支持车辆检测 0不支持 1支持
  final bool supportCar;

  /// 是否支持宠物检测 0不支持 1支持
  final bool supportPet;

  /// 0 声光都不支持 1支持声的设备 2 支持光的设备 3支持声光的设备
  final int supportSoundLight;

  SupportedAlarmType(
      {required this.supportHuman,
      required this.supportFace,
      required this.supportCar,
      required this.supportPet,
      required this.supportSoundLight});
}

/// AI 算法开关状态
class AIAlgorithmStatus {
  /// 移动侦测算法状态
  final bool isMotionOn;

  /// 人形检测算法状态
  final bool isHumanoidOn;

  /// 人脸识别算法状态
  final bool isFaceOn;

  /// 汽车检测算法状态
  final bool isCarOn;

  /// 宠物检测算法状态
  final bool isPetOn;

  /// 声光报警类型
  final int soundLightMode;

  AIAlgorithmStatus(
      {required this.isMotionOn,
      required this.isHumanoidOn,
      required this.isFaceOn,
      required this.isCarOn,
      required this.isPetOn,
      required this.soundLightMode});
}

/// AI 算法区域
class AIAlgorithmArea {
  final int x;
  final int y;
  final int width;
  final int height;
  AIAlgorithmArea(
      {required this.x,
      required this.y,
      required this.width,
      required this.height});
}
