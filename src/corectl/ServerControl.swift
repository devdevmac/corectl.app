//
//  ServerControl.swift
//  corectl
//
//  Created by Rimantas Mocevicius on 06/07/2016.
//  Copyright © 2016 The New Normal. All rights reserved.
//

import Foundation
import Cocoa

// server control //

// start corectld server
func ServerStart() {
    // send stop to corectld just in case it was left running
    ServerStop()
    
    // send an alert about the user password
    let mText: String = "Corectl for macOS"
    let infoText: String = "You will be asked to type your user password, needed to start 'corectld' server !!!"
    displayWithMessage(mText, infoText: infoText)
    
    //
    let menuItem : NSStatusItem = statusItem
    
    // start corectld server
    let task = NSTask()
    task.launchPath = "~/bin/corectld"
    task.arguments = ["start"]
    task.launch()
    task.waitUntilExit()
    
    //
    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
    dispatch_after(time, dispatch_get_main_queue()) {
        //
        let script = NSBundle.mainBundle().resourcePath! + "/check_corectld_status.command"
        let status = shell(script, arguments: [])
        NSLog("corectld running status: '%@'",status)
        //
        if (status == "no"){
            let menuItem : NSStatusItem = statusItem
            menuItem.menu?.itemWithTag(1)?.title = "Server is Off"
            // display the error message
            let mText: String = "Corectl for macOS"
            let infoText: String = "Cannot start the \"corectld server\" !!!"
            displayWithMessage(mText, infoText: infoText)
        }
        else {
            menuItem.menu?.itemWithTag(1)?.title = "Server is running"
            menuItem.menu?.itemWithTag(1)?.state = NSOnState
            //
            let script = NSBundle.mainBundle().resourcePath! + "/check_corectld_version.command"
            let version = shell(script, arguments: [])
            NSLog("corectld version: '%@'",version)
            menuItem.menu?.itemWithTag(11)?.title = " Server version: " + version
        }
    }
}


func ServerStartShell() {
    // send stop to corectld just in case it was left running
    ServerStop()
    
    // send an alert about the user password
    let mText: String = "Corectl for macOS"
    let infoText: String = "You will be asked to type your user password, needed to start 'corectld' server !!!"
    displayWithMessage(mText, infoText: infoText)
    
    //
    let menuItem : NSStatusItem = statusItem
    
    // start corectld server
    let task: NSTask = NSTask()
    let launchPath = NSBundle.mainBundle().resourcePath! + "/start_corectld.command"
    task.launchPath = launchPath
    task.launch()
    task.waitUntilExit()
    
    //
    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
    dispatch_after(time, dispatch_get_main_queue()) {
        //
        let script = NSBundle.mainBundle().resourcePath! + "/check_corectld_status.command"
        let status = shell(script, arguments: [])
        NSLog("corectld running status: '%@'",status)
        //
        if (status == "no"){
            let menuItem : NSStatusItem = statusItem
            menuItem.menu?.itemWithTag(1)?.title = "Server is Off"
            // display the error message
            let mText: String = "Corectl for macOS"
            let infoText: String = "Cannot start the \"corectld server\" !!!"
            displayWithMessage(mText, infoText: infoText)
        }
        else {
            menuItem.menu?.itemWithTag(1)?.title = "Server is running"
            menuItem.menu?.itemWithTag(1)?.state = NSOnState
            //
            let script = NSBundle.mainBundle().resourcePath! + "/check_corectld_version.command"
            let version = shell(script, arguments: [])
            NSLog("corectld version: '%@'",version)
            menuItem.menu?.itemWithTag(11)?.title = " Server version: " + version
        }
    }
}


// stop corectld server
func ServerStop() {
    let menuItem : NSStatusItem = statusItem
    
    // stop corectld server
    let task = NSTask()
    task.launchPath = "~/bin/corectld"
    task.arguments = ["stop"]
    task.launch()
    task.waitUntilExit()
    
    // run script and wait till corectld.runner stops
    // runScript("wait_for_corectld_runner_stop.command", arguments: "")
    
    menuItem.menu?.itemWithTag(1)?.title = "Server is off"
    menuItem.menu?.itemWithTag(1)?.state = NSOffState
}


// restart corectld server
func RestartServer() {
    //
    let menuItem : NSStatusItem = statusItem
    
    // send a notification on to the screen
    print("Restarting corectld server")
    let notification: NSUserNotification = NSUserNotification()
    notification.title = "Restarting corectld server"
    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    
    menuItem.menu?.itemWithTag(1)?.title = "Server is stopping"
    
    // stop corectld server
    ServerStop()
    
    menuItem.menu?.itemWithTag(1)?.title = "Server is starting"
    // start corectld server
    ServerStartShell()
    //
    menuItem.menu?.itemWithTag(3)?.title = "Check for App updates"
    menuItem.menu?.itemWithTag(4)?.title = "Check for corectl updates"
}

//
func appDelegate () -> AppDelegate
{
    return NSApplication.sharedApplication().delegate as! AppDelegate
}

