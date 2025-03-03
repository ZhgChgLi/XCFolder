//
//  ThanksUseCase.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/3/2.
//

protocol ThanksUseCaseSpec {
    func execute() async
}

final class ThanksUseCase: ThanksUseCaseSpec {
    func execute() async {
        let artMessage = #"""
   ___                                     _   _            
  / _ \ ___ __      __ ___  _ __  ___   __| | | |__   _   _ 
 / /_)// _ \\ \ /\ / // _ \| '__|/ _ \ / _` | | '_ \ | | | |
/ ___/| (_) |\ V  V /|  __/| |  |  __/| (_| | | |_) || |_| |
\/     \___/  \_/\_/  \___||_|   \___| \__,_| |_.__/  \__, |
                                                      |___/ 
 _____ _               ___  _               __  _           
/ _  /| |__    __ _   / __\| |__    __ _   / / (_)          
\// / | '_ \  / _` | / /   | '_ \  / _` | / /  | |          
 / //\| | | || (_| |/ /___ | | | || (_| |/ /___| |          
/____/|_| |_| \__, |\____/ |_| |_| \__, |\____/|_|          
              |___/                |___/                                
Created at 2025-03-02, https://zhgchg.li
"""#
        print(artMessage)
        print("💡 Tip: Consider using XcodeGen or Tuist for continuous project file generation!")
        print("🙏 Thanks for using XCFolder!")
    }
}
