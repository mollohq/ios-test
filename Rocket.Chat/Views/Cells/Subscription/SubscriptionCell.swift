//
//  SubscriptionCell.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 8/4/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

final class SubscriptionCell: BaseSubscriptionCell {

    static let identifier = "CellSubscription"

    @IBOutlet weak var labelLastMessage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelDate.text = nil
        labelLastMessage.text = nil
        labelName.text = nil
    }

    override func updateSubscriptionInformation() {
        guard let subscription = subscription?.managedObject else { return }

        labelLastMessage.text = subscription.roomLastMessageText ?? localized("subscriptions.list.no_message")

        if let roomLastMessage = subscription.roomLastMessage?.createdAt {
            labelDate.text = dateFormatted(date: roomLastMessage)
        } else {
            labelDate.text = nil
        }

        super.updateSubscriptionInformation()

        setLastMessageColor()
        setDateColor()
    }

    override func updateViewForAlert(with subscription: Subscription) {
        super.updateViewForAlert(with: subscription)
        labelDate.font = UIFont.systemFont(ofSize: labelDate.font.pointSize, weight: .bold)
        labelLastMessage.font = UIFont.systemFont(ofSize: labelLastMessage.font.pointSize, weight: .medium)
    }

    override func updateViewForNoAlert(with subscription: Subscription) {
        super.updateViewForNoAlert(with: subscription)
        labelDate.font = UIFont.systemFont(ofSize: labelDate.font.pointSize, weight: .regular)
        labelLastMessage.font = UIFont.systemFont(ofSize: labelLastMessage.font.pointSize, weight: .regular)
    }

    private func setLastMessageColor() {
        guard
            let theme = theme,
            let subscription = subscription?.managedObject
        else {
            return
        }

        if subscription.unread > 0 || subscription.alert {
            labelLastMessage.textColor = theme.bodyText
        } else {
            labelLastMessage.textColor = theme.auxiliaryText
        }
    }

    private func setDateColor() {
        guard
            let theme = theme,
            let subscription = subscription?.managedObject
        else {
            return
        }

        if subscription.unread > 0 || subscription.alert {
            labelDate.textColor = theme.tintColor
        } else {
            labelDate.textColor = theme.auxiliaryText
        }
    }

    func dateFormatted(date: Date) -> String {
        let calendar = NSCalendar.current

//        if calendar.isDateInYesterday(date) {
//            return localized("subscriptions.list.date.yesterday")
//        }
//
//        if calendar.isDateInToday(date) {
//            return RCDateFormatter.time(date)
//        }
        
        return date.getElapsedInterval()
//        return RCDateFormatter.date(date, dateStyle: .short)
    }
}

// MARK: Date extension
extension Date {
    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
            "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
            "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
            "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
            "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "min ago" :
            "\(minute)" + " " + "mins ago"
        } else {
            return "a moment ago"
        }
    }
}

// MARK: Themeable

extension SubscriptionCell {
    override func applyTheme() {
        super.applyTheme()
        setLastMessageColor()
        setDateColor()
    }
}
