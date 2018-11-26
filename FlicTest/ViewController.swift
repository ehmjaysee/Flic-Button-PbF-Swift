//
//  ViewController.swift
//  FlicTest
//
//  Created by Michael Chartier on 11/18/18.
//  Copyright © 2018 Motion Instruments. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SCLFlicManagerDelegate, SCLFlicButtonDelegate {

    // You must set appID and appSecret to the values you received from Flic when you purchsed PbF SDK.
    // None of the app functions will work until this step is done.
    let appID = "replace-with-your-appID"
    let appSecret = "replace-with-your-appSecret"
    
    @IBOutlet var O_message: UILabel!
    @IBOutlet var O_message2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        O_message.text = "Idle"
        O_message2.text = ""

        // configure() must be called once before any SDK functions are called
        SCLFlicManager.configure(with: self, defaultButtonDelegate: self, appID: appID, appSecret: appSecret, backgroundExecution: true)
        
        reconnect()
    }

    // Start the BLE scanner. If any buttons are in the area AND they are advertising
    // then our app will receive the didDiscover() callback.
    @IBAction func B_scan(_ sender: Any) {
        print("Function: \(#function), line: \(#line)")
        SCLFlicManager.shared()?.startScan()
        O_message.text = "Scanning..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            SCLFlicManager.shared()?.stopScan()
            self.O_message.text = "Scan OFF"
        })
    }

    // Disconnect from all known buttons
    @IBAction func B_disconnect(_ sender: Any) {
        print("Function: \(#function), line: \(#line)")
        if let known = SCLFlicManager.shared()?.knownButtons() {
            for item in known {
                print("uuid: \(item.key)")
                item.value.dump()
                if item.value.connectionState == .connected {
                    item.value.disconnect()
                }
            }
        }
        O_message.text = "Disconnected from ALL"
    }

    @IBAction func B_reconnect(_ sender: Any) {
        reconnect()
    }
    
    @IBAction func B_forget(_ sender: Any) {
        forget()
    }
    
    // Attempt to restore device state to all
    func reconnect()
    {
        print("Reconnectig to known buttons...")
        
        var count = 0
        
        if let known = SCLFlicManager.shared()?.knownButtons() {
            for item in known {
                count += 1
                item.value.dump()
                if item.value.connectionState == .disconnected {
                    print("Attempt connection to \(item.key)")
                    item.value.connect()
                }
            }
        }
        O_message.text = "Reconnect Count \(count)"
    }
    
    // Forget all known devices
    func forget()
    {
        print("Trying to forget...")
        
        var count = 0
        
        if let known = SCLFlicManager.shared()?.knownButtons() {
            for item in known {
                count += 1
                item.value.dump()
                if item.value.connectionState == .connected {
                    print("Forget " + item.key.short() + " while connected")
                } else {
                    print("Forget " + item.key.short() + " while disconnected")
                }
                SCLFlicManager.shared()?.forget(item.value)
            }
        }
        O_message.text = "Forget Count \(count)"
    }
    

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: SCLFlicManager Delegate
    
    func flicManager(_ manager: SCLFlicManager, didDiscover button: SCLFlicButton, withRSSI RSSI: NSNumber?) {
        let name = button.buttonIdentifier.short()
        print("Function: \(#function), line: \(#line)")
        print( name )
        button.connect()
        O_message.text = "Connecting " + name
        SCLFlicManager.shared()?.stopScan()
    }

    func flicManagerDidRestoreState(_ manager: SCLFlicManager) {
        // Manager has been restored after app start
        print("Function: \(#function), line: \(#line)")
    }

    func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState) {
        // Bluetooth has switched state
        print("Function: \(#function), line: \(#line)")
        print(state.rawValue)
    }

    func flicManager(_ manager: SCLFlicManager, didForgetButton buttonIdentifier: UUID, error: Error?) {
        // A button has been removed
        print("Function: \(#function), line: \(#line)")
        print("UUID: " + buttonIdentifier.short())
    }

    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: SCLFlicButtonDelegate

    func flicButtonDidConnect(_ button: SCLFlicButton) {
        print("Function: \(#function), line: \(#line)")
        print("UUID: " + button.buttonIdentifier.short())
        O_message.text = "Connected"
    }

    func flicButtonIsReady(_ button: SCLFlicButton) {
        print("Function: \(#function), line: \(#line)")
        print("UUID: " + button.buttonIdentifier.short())
        O_message.text = "Button Ready"
    }

    func flicButton(_ button: SCLFlicButton, didDisconnectWithError error: Error?) {
        print("Function: \(#function), line: \(#line)")
        print("UUID: " + button.buttonIdentifier.short())
        O_message.text = "Disconnected"
    }

    func flicButton(_ button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
        print("Function: \(#function), line: \(#line)")
        print("UUID: " + button.buttonIdentifier.short() )
        O_message2.text = button.buttonIdentifier.short() + " press \(button.pressCount)"
    }
    
}

extension SCLFlicButton {
    func dump() {
        print("UUID " + buttonIdentifier.short())
        print("type \(buttonType().rawValue)")
        print("battery \(batteryStatus.rawValue)")
        print("connection \(connectionState.rawValue)")
        print("Clicks \(pressCount)")
    }
}

extension UUID {
    func short() -> String {
        let uuidString = self.uuidString
        let startIndex = uuidString.index(uuidString.endIndex, offsetBy: -4)
        let uuidTail = uuidString[startIndex...]
        let shortName = String(uuidTail)
        return shortName
    }
}
