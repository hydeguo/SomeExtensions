//
//  Tools.swift
//  DrawHero
//
//  Created by GuoXiaobin on 14/12/1.
//  Copyright (c) 2014年 GuoXiaobin. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

// 屏幕宽度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
// 屏幕高度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width



struct SoundForGame {
    
    static var BGM_Name:String?
    static var soundSkView:SKView?
    static var soundActList = NSMutableDictionary()
    static var playerBMP:AVAudioPlayer?
    
    static var playerSoundList=NSMutableDictionary()
    
    static  func getSoundByName(_ name:String,waitForCom:Bool)->SKAction
    {
        
        if(soundActList[name]==nil){
              soundActList[name] = SKAction.playSoundFileNamed(name, waitForCompletion: waitForCom)
        }
      
        return soundActList[name] as! SKAction
    }
    
    static func playSoundByName(_ name:String)->Void
    {
//        if(Sys.isSimulator()){
//            return
//        }
        soundSkView?.scene?.run(getSoundByName(name,waitForCom:false), withKey: name)
    }
    // 不受暂停影响
    static func playAVSound(_ name:String,volume:Float=1,type:String="mp3")->Void
    {
        if(playerSoundList[name]==nil)
        {
            let temp_player=try? AVAudioPlayer(contentsOf:URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!))
            temp_player!.numberOfLoops=0
            temp_player!.volume=volume
            playerSoundList[name]=temp_player
        }
        (playerSoundList[name] as! AVAudioPlayer).play()
    }
    static func stopAVSound(_ name:String)->Void
    {
        if(playerSoundList[name]==nil)
        {
            return;
        }
        (playerSoundList[name] as! AVAudioPlayer).stop()
    }
    
    static func playBGM(_ name:String,volume:Float=1,loop:Int = 10000)
    {
        if(BGM_Name==name){
            if(playerBMP?.isPlaying==false)
            {
                playerBMP?.play()
            }
            return
        }
        BGM_Name=name
        stopBGM()
        playerBMP=try? AVAudioPlayer(contentsOf:URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!))
        playerBMP?.numberOfLoops=loop
        playerBMP?.volume=volume
        playerBMP?.play()
    }
    
    static func stopBGM()
    {
        if((playerBMP) != nil){
            playerBMP?.stop()
        }
    }
}


public  func isIpadDisplay()->Bool {
    return (UIScreen.main.bounds.height/UIScreen.main.bounds.width==(1024/768)||UIScreen.main.bounds.height/UIScreen.main.bounds.width==(768/1024))
}
public  func isIpadProDisplay()->Bool {
    return (UIScreen.main.bounds.height/UIScreen.main.bounds.width==(1366/1024)||UIScreen.main.bounds.height/UIScreen.main.bounds.width==(1024/1366))
}

public  func isSimulator()->Bool{
    return UIDevice.current.model.range(of: "Simulator" ) != nil
}

public  func isIphoneXDisplay()->Bool{
    return (UIScreen.main.bounds.height/UIScreen.main.bounds.width==(812.0/375.0)||UIScreen.main.bounds.height/UIScreen.main.bounds.width==(375.0/812.0))
}

public  func isIphoneXMaxDisplay()->Bool{
    return (UIScreen.main.bounds.height/UIScreen.main.bounds.width==(896.0/414.0)||UIScreen.main.bounds.height/UIScreen.main.bounds.width==(414.0/896.0))
}

public  func isIphoneXAboveDisplay()->Bool{
    return  isIphoneXDisplay() || isIphoneXMaxDisplay()
}



public func setTimeout(delay:TimeInterval, block:@escaping ()->Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
}

public func setInterval(interval:TimeInterval, block:@escaping ()->Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: interval, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: true)
}


public func GetIPAddresses() -> String? {
    var addresses = [String]()
    
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first
}

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
    guard let object = object else { return }
    print("***** \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    #endif
}


//@available(iOS 9, *) func setStatusBarBackgroundColor(color: UIColor) {
//    
//    if let statusBar  = UIApplication.shared.statusBarView,statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//        statusBar.backgroundColor = color
//    }
//}



func isPhoneNumber(phoneNumber:String) -> Bool {
    if phoneNumber.count == 0 {
        return false
    }
    let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: phoneNumber) == true {
        return true
    }else
    {
        return false
    }
}

//extension UIApplication {
//    
//    @available(iOS 9, *) var statusBarView: UIView? {
//         if #available(iOS 13.0, *) {
//                   let tag = 38482458385
//                   if let statusBar = self.keyWindow?.viewWithTag(tag) {
//                       return statusBar
//                   } else {
//                       let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
//                       statusBarView.tag = tag
//
//                       self.keyWindow?.addSubview(statusBarView)
//                       return statusBarView
//                   }
//               } else {
//                   if responds(to: Selector(("statusBar"))) {
//                       return value(forKey: "statusBar") as? UIView
//                   }
//               }
//               return nil
//    }
//}
