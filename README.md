# Flic-Button-PbF-Swift

Get started quickly with the PbF SDK from Flic.  This example project will create a simple iOS project to demonstrate how to use the PbF SDK with an application written in Swift.  Use UI buttons to scan, discover, connect, disconnect, and forget Flic buttons. 

## Getting Started

To get started you will need to purchase a developer license for the Flic PbF program. There are other ways to interact with the Flic buttons besides theh PbF, but if you want to build your own custom app for the Flic buttons you will need the PbF developer license.  Contact Flic for details:  https://flic.io/business/solutions

Once you purchase your PbF license Flic will send you an email with instructions and a username/password for their website. They will also send you license keys to activate the PbF library. 

### Prerequisites

To use this project you will need xCode running on an apple device plus at least one Flic button and the PbF developer license.  

Also It would be a good idea to read the documentation on the flic button here:  http://pbf-docs.flic.io/guidelines/index.html

In particular, I would read the section on privacy modes.

### Installing

1) First you will need to purchase a developer license for the Flic PbF program. They will send you an email with instructions and a username/password for their website. They will also send you license keys to use the PbF library. 
2) Download this xCode project into a fresh directory on your system.  
3) Add the PbF library to your xCode project.  
* Go to the Flic developer site: http://pbf-docs.flic.io 
* Download the PbF library.  Look for the link called "PbF-lib-iOS-date...."
* You now have a folder called fliclib.framework in your Downloads folder. Import this framework into your xCode project
4) Install your PbF license keys.  Just look for "appID" near the top of the file ViewController.swift
5) Build and run.  Note you cannot run this project on the simulator because bluetooth is required. 

## Running the app

Running the app is trivial, but sometimes the buttons can get into a state where they no longer connect.  If you get into this state it may be because you told the app to forget a button and now you are trying to reconnect to that button.  In this case you need to hold down the button for 6 seconds while the button is disconnected and the app is not scanning.  This will put the button back into the 'public' mode. 

