//
//  HardwareModel.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import Darwin.POSIX.sys

// https://stackoverflow.com/questions/11197509/ios-how-to-get-device-make-and-model
public enum HardwareModel: String {
    case iPhone
    case iPhone3G, iPhone3GS
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5S
    case iPhone5C
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    case iPhoneSE
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX

    case iPad
    case iPad2
    case iPadMini
    case iPad3
    case iPad4
    case iPadAir
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadAir2

    case iPadPro

    case iPod1G
    case iPod2G
    case iPod3G
    case iPod4G
    case iPod5G
    case iPod6G

    case unknown

    init(name: String) {
        switch HardwareModel.hardwareModelName {
        // phone
        case "iPhone1,1":
            self = .iPhone
        case "iPhone1,2":
            self = .iPhone3G
        case "iPhone2,1":
            self = .iPhone3GS
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            self = .iPhone4
        case "iPhone4,1":
            self = .iPhone4S
        case "iPhone5,1", "iPhone5,2":
            self = .iPhone5
        case "iPhone5,3", "iPhone5,4":
            self = .iPhone5C
        case "iPhone6,1", "iPhone6,2":
            self = .iPhone5S
        case "iPhone7,1":
            self = .iPhone6Plus
        case "iPhone7,2":
            self = .iPhone6
        case "iPhone8,1":
            self = .iPhone6S
        case "iPhone8,2":
            self = .iPhone6SPlus
        case "iPhone8,4":
            self = .iPhoneSE
        case "iPhone9,1", "iPhone9,2":
            self = .iPhone7
        case "iPhone9,3", "iPhone9,4":
            self = .iPhone7Plus
        case "iPhone10,1", "iPhone10,4":
            self = .iPhone8
        case "iPhone10,2", "iPhone10,5":
            self = .iPhone8Plus
        case "iPhone10,3", "iPhone10,6":
            self = .iPhoneX
        // pad
        case "iPad1,1":
            self = .iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            self = .iPad2
        case "iPad2,5", "iPad2,6", "iPad2,7":
            self = .iPadMini
        case "iPad3,1", "iPad3,2", "iPad3,3":
            self = .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":
            self = .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":
            self = .iPadAir
        case "iPad4,4", "iPad4,5", "iPad4,6":
            self = .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":
            self = .iPadMini3
        case "iPad5,1", "iPad5,2":
            self = .iPadMini4
        case "iPad5,3", "iPad5,4":
            self = .iPadAir2

        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":
            self = .iPadPro

        // pod
        case "iPod1,1":
            self = .iPod1G
        case "iPod2,1":
            self = .iPod2G
        case "iPod3,1":
            self = .iPod3G
        case "iPod4,1":
            self = .iPod4G
        case "iPod5,1":
            self = .iPod5G
        case "iPod7,1":
            self = .iPod6G

        default:
            self = .unknown
        }
    }

    private static var hardwareModelName: String {
        var u = utsname()
        uname(&u)

        let machineMirror = Mirror(reflecting: u.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
