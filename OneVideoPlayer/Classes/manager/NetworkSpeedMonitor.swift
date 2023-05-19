//
//  NetworkSpeedMonitor.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/5/19.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

open class NetworkSpeedMonitor {
    private var iBytes: UInt32 = 0
    private var oBytes: UInt32 = 0
    private var allFlow: UInt32 = 0
    private var wifiIBytes: UInt32 = 0
    private var wifiOBytes: UInt32 = 0
    private var wifiFlow: UInt32 = 0
    private var wwanIBytes: UInt32 = 0
    private var wwanOBytes: UInt32 = 0
    private var wwanFlow: UInt32 = 0
    private var timer: Timer?

    private(set) var downloadNetworkSpeed: String?
    private(set) var uploadNetworkSpeed: String?
    
    public static let DownloadNetworkSpeedNotification = Notification.Name(rawValue: "NetworkSpeedMonitorNotification.download")
    public static let UploadNetworkSpeedNotification = Notification.Name(rawValue: "NetworkSpeedMonitorNotification.upload")
    public static let NetworkSpeedNotificationKey = "NetworkSpeedNotificationKey"
    
    deinit {
        debugPrint("-- NetworkSpeedMonitor is deinit  --")
    }

    func startNetworkSpeedMonitor() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkNetworkSpeed), userInfo: nil, repeats: true)
            if let timer = timer {
                RunLoop.current.add(timer, forMode: .common)
                timer.fire()
            }
        }
    }

    func stopNetworkSpeedMonitor() {
        if timer?.isValid ?? false {
            timer?.invalidate()
            timer = nil
        }
    }

    private func stringWithBytes(_ bytes: Int) -> String {
        if bytes < 1024 {
            return "\(bytes)B"
        } else if bytes >= 1024 && bytes < 1024 * 1024 {
            return String(format: "%.0fKB", Double(bytes) / 1024)
        } else if bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024 {
            return String(format: "%.1fMB", Double(bytes) / (1024 * 1024))
        } else {
            return String(format: "%.1fGB", Double(bytes) / (1024 * 1024 * 1024))
        }
    }

    @objc private func checkNetworkSpeed() {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return }
        defer { freeifaddrs(ifaddr) }

        var iBytes: UInt32 = 0
        var oBytes: UInt32 = 0
        //var allFlow: UInt32 = 0
        var wifiIBytes: UInt32 = 0
        var wifiOBytes: UInt32 = 0
        //var wifiFlow: UInt32 = 0
        var wwanIBytes: UInt32 = 0
        var wwanOBytes: UInt32 = 0
        //var wwanFlow: UInt32 = 0

        for ptr in sequence(first: ifaddr, next: { $0?.pointee.ifa_next }) {
            guard let ifa = ptr?.pointee else { continue }
            if ifa.ifa_addr.pointee.sa_family != UInt8(AF_LINK) { continue }
            if (ifa.ifa_flags & UInt32(IFF_UP)) == 0 && (ifa.ifa_flags & UInt32(IFF_RUNNING)) == 0 { continue }
            if ifa.ifa_data == nil { continue }

            let name = String(cString: ifa.ifa_name)
            let if_data = ifa.ifa_data.assumingMemoryBound(to: if_data.self).pointee

            if !name.hasPrefix("lo") {
                iBytes += if_data.ifi_ibytes
                oBytes += if_data.ifi_obytes
                allFlow = iBytes + oBytes
            }

            if name == "en0" {
                wifiIBytes += if_data.ifi_ibytes
                wifiOBytes += if_data.ifi_obytes
                wifiFlow = wifiIBytes + wifiOBytes
            }

            if name == "pdp_ip0" {
                wwanIBytes += if_data.ifi_ibytes
                wwanOBytes += if_data.ifi_obytes
                wwanFlow = wwanIBytes + wwanOBytes
            }
        }

        if self.iBytes != 0 {
            downloadNetworkSpeed = stringWithBytes(Int(iBytes - self.iBytes)) + "/s"
            NotificationCenter.default.post(name: NetworkSpeedMonitor.DownloadNetworkSpeedNotification, object: nil, userInfo: [NetworkSpeedMonitor.NetworkSpeedNotificationKey: downloadNetworkSpeed ?? ""])
        }

        self.iBytes = iBytes

        if self.oBytes != 0 {
            uploadNetworkSpeed = stringWithBytes(Int(oBytes - self.oBytes)) + "/s"
            NotificationCenter.default.post(name: NetworkSpeedMonitor.UploadNetworkSpeedNotification, object: nil, userInfo: [NetworkSpeedMonitor.NetworkSpeedNotificationKey: uploadNetworkSpeed ?? ""])
        }

        self.oBytes = oBytes
    }
}
