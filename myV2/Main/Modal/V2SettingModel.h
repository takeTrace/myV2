//
//  V2SettingModel.h
//  myV2
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, V2SettingCellType) {
    V2SettingCellTypeNone,
    V2SettingCellTypeSwitch,
    V2SettingCellTypeCheck,
    V2SettingCellTypeLabel,
    V2SettingCellTypeArrow
    
};

@interface V2SettingModel : NSObject
/**
 *   类型     */
@property (nonatomic, assign) V2SettingCellType cellType;

/**
 *    状态     */
@property (nonatomic, assign) BOOL isOn;

/**
 *   标题     */
@property (nonatomic, copy) NSString *title;

/**
 *   说明     */
@property (nonatomic, copy) NSString *desc;

/**
 *   额外说明(当 type = label 时     */
@property (nonatomic, copy) NSString *state;

/**
 *   选中操作     */
@property (nonatomic, copy) void (^operation)(V2SettingModel *settingM);
@end
