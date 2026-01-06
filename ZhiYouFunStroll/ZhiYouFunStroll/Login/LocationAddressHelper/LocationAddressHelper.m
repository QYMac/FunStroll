//
//  LocationAddressHelper.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "LocationAddressHelper.h"

@interface LocationAddressHelper () <CLLocationManagerDelegate, AMapSearchDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, copy, nullable) LocationAddressCompletion completion;
@property (nonatomic, assign) BOOL isLocating;

@end

static LocationAddressHelper *_sharedHelper;

@implementation LocationAddressHelper

+ (instancetype)shared {
    @synchronized(self) {
        if (!_sharedHelper) {
            _sharedHelper = [[self alloc] init];
        }
    }
    return _sharedHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化定位管理器
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        // 初始化搜索API
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
        
        _isLocating = NO;
    }
    return self;
}

- (void)getCurrentAddressWithCompletion:(LocationAddressCompletion)completion {
    // 如果正在定位，取消之前的请求
    if (self.isLocating) {
        [self cancel];
    }
    
    // 保存回调
    self.completion = completion;
    self.isLocating = YES;
    
    // 检查定位权限
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSError *error = [NSError errorWithDomain:@"LocationAddressHelper"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"定位权限被拒绝，请在设置中开启定位权限"}];
        [self callCompletionWithRegeocode:nil coordinate:kCLLocationCoordinate2DInvalid error:error];
        return;
    }
    
    // 请求定位权限（如果未授权）
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
        return;
    }
    
    // 开始定位（单次定位，获取到位置后立即停止）
    [self.locationManager startUpdatingLocation];
}

- (void)getAddressForCoordinate:(CLLocationCoordinate2D)coordinate
                      completion:(LocationAddressCompletion)completion {
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        NSError *error = [NSError errorWithDomain:@"LocationAddressHelper"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"无效的坐标"}];
        if (completion) {
            completion(nil, coordinate, error);
        }
        return;
    }
    
    // 如果正在定位，取消之前的请求
    if (self.isLocating) {
        [self cancel];
    }
    
    // 保存回调
    self.completion = completion;
    self.isLocating = YES;
    
    // 创建反地理编码请求
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude
                                                longitude:coordinate.longitude];
    request.requireExtension = YES; // 返回扩展信息
    
    // 发起请求
    [self.searchAPI AMapReGoecodeSearch:request];
}

- (void)cancel {
    [self.locationManager stopUpdatingLocation];
    self.completion = nil;
    self.isLocating = NO;
}

#pragma mark - Private

- (void)callCompletionWithRegeocode:(AMapReGeocode *)regeocode
                          coordinate:(CLLocationCoordinate2D)coordinate
                               error:(NSError *)error {
    self.isLocating = NO;
    
    if (self.completion) {
        self.completion(regeocode, coordinate, error);
        self.completion = nil;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 单次定位：获取到位置后立即停止
    [manager stopUpdatingLocation];
    
    if (locations.count == 0) {
        NSError *error = [NSError errorWithDomain:@"LocationAddressHelper"
                                             code:-3
                                         userInfo:@{NSLocalizedDescriptionKey: @"未获取到位置信息"}];
        [self callCompletionWithRegeocode:nil coordinate:kCLLocationCoordinate2DInvalid error:error];
        return;
    }
    
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    // 使用获取到的坐标进行反地理编码
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude
                                                longitude:coordinate.longitude];
    request.requireExtension = YES;
    
    // 发起反地理编码请求
    [self.searchAPI AMapReGoecodeSearch:request];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    [self callCompletionWithRegeocode:nil coordinate:kCLLocationCoordinate2DInvalid error:error];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || 
        status == kCLAuthorizationStatusAuthorizedAlways) {
        // 权限已授权，开始定位
        [manager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied || 
               status == kCLAuthorizationStatusRestricted) {
        // 权限被拒绝
        NSError *error = [NSError errorWithDomain:@"LocationAddressHelper"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"定位权限被拒绝，请在设置中开启定位权限"}];
        [self callCompletionWithRegeocode:nil coordinate:kCLLocationCoordinate2DInvalid error:error];
    }
}

#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
    
    if (response.regeocode) {
        [self callCompletionWithRegeocode:response.regeocode coordinate:coordinate error:nil];
    } else {
        NSError *error = [NSError errorWithDomain:@"LocationAddressHelper"
                                             code:-4
                                         userInfo:@{NSLocalizedDescriptionKey: @"反地理编码返回结果为空"}];
        [self callCompletionWithRegeocode:nil coordinate:coordinate error:error];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if ([request isKindOfClass:[AMapReGeocodeSearchRequest class]]) {
        AMapReGeocodeSearchRequest *regeoRequest = (AMapReGeocodeSearchRequest *)request;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(regeoRequest.location.latitude, regeoRequest.location.longitude);
        [self callCompletionWithRegeocode:nil coordinate:coordinate error:error];
    }
}

@end

