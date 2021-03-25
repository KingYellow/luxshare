//
// TuyaSmartUser+BleMesh.h
// TuyaSmartBLEMeshKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <TuyaSmartBaseKit/TuyaSmartUser.h>
#import "TuyaSmartBleMesh.h"

@interface TuyaSmartUser (BleMesh)

@property (nonatomic, strong) TuyaSmartBleMeshModel *meshModel;

@property (nonatomic, strong) TuyaSmartBleMesh *mesh;

@end
