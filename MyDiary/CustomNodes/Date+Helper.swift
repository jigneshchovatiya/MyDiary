//
//  Date+Helper.swift
//  Numbertank
//
//  Created by Manan Sheth on 24/07/17.
//  Copyright © 2017 Manan Sheth. All rights reserved.
//

import UIKit

public extension Date {
    
    //MARK:- Convert from String
    
    /*
     Initializes a new Date() objext based on a date string, format, optional timezone and optional locale.
     - Returns: A Date() object if successfully converted from string or nil.
     */
    init?(fromString string: String, format: DateFormatType, timeZone: TimeZoneType = .local) {
        
        guard !string.isEmpty else {
            return nil
        }
        
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone)
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    //MARK:- Convert to String
    
    /// Converts the date to string based on a date format, optional timezone and optional locale.
    func toString(format: DateFormatType, timeZone: TimeZoneType = .local, isDefaultLocale: Bool? = false) -> String {
        
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, isDefaultLocale: isDefaultLocale!)
        return formatter.string(from: self)
    }

    func toStringWithRelativeTimeHeadLines(ispast: Bool? = false, timeAgoSuffix: Bool? = true) -> String {
        
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        var isPast = now - time > 0
        var sec: Int = Int(abs(now - time))
        
        let min: Int = Int(round(Double(sec/60)))
        let hr: Int = Int(round(Double(min/60)))
        let d: Int = Int(round(Double(hr/24)))
        
        if ispast == true {
            
            if isPast == false {
                
                isPast = true
                sec = 0
            }
        }
        
        
        if compare(.isToday)
        {
            return "Today"
        }
        else if compare(.isYesterday)
        {
            return "Yesterday"
        }
        else if compare(.isThisWeek)
        {
            return "This week"
        }
        else if compare(.isThisMonth)
        {
            return "This month"
        }
        else if compare(.isThisYear)
        {
            return self.toString(format: .ntMonth)
        }
        else
        {
            return self.toString(format: .ntCalenderMonth)
        }
    }
    
    
    /// Converts the date to string based on a relative time language. i.e. just now, 1 minute ago etc...
    func toStringWithRelativeTime(ispast: Bool? = false, timeAgoSuffix: Bool? = true) -> String {
        
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        var isPast = now - time > 0
        var sec: Int = Int(abs(now - time))
        
        let min: Int = Int(round(Double(sec/60)))
        let hr: Int = Int(round(Double(min/60)))
        let d: Int = Int(round(Double(hr/24)))
        
        if ispast == true {
            
            if isPast == false {
                
                isPast = true
                sec = 0
            }
        }
        
        if sec < 60 {
            
            if sec < 2 {
                return "just now"
            }
            else {
                if isPast {
                    
                    let string = "\(sec) secs ago"
                    return string
                }
                else {
                    return self.scheduleDate()
                }
            }
        }
        else if min < 60 {
            
            if min == 1 {
                
                if isPast {
                    let string = "\(min) min ago"
                    return string
                }
                else {
                    return self.scheduleDate()
                }
            }
            else {
                if isPast {
                    
                    let string = "\(min) mins ago"
                    return string
                }
                else {
                    return self.scheduleDate()
                }
            }
        }
        else if hr < 24 {
            
            if hr == 1 {
                
                if isPast {
                    return "last hour"
                }
                else {
                    return self.scheduleDate()
                }
            }
            else {
                if isPast {
                    return "\(hr) hrs ago"
                }
                else {
                    return self.scheduleDate()
                }
            }
        }
        else if d < 7 {
            
            if d == 1 {
                
                if isPast {
                    return "\(d) days ago"
                }
                else {
                    return "tomorrow"
                }
            }
            else {
                if isPast {
                    return "\(d) days ago"
                }
                else {
                    return self.scheduleDate()
                }
            }
        }
        else if d < 32 {
            
            if isPast {
                
                if compare(.isLastWeek) {
                    return "last week"
                }
                else {
                    return "\(Int(abs(since(Date(), in: .week)))) weeks ago"
                }
            }
            else {
                return self.scheduleDate()
            }
        }
        else if compare(.isThisYear) {
            
            if isPast {
                
                if compare(.isLastMonth)
                {
                    return "last month"
                }
                else {
                    return "\(Int(abs(since(Date(), in: .month)))) months ago"
                }
            }
            else {
                return self.scheduleDate()
            }
        }
        else if isPast {
            
            if compare(.isLastYear) {
                return "last year"
            }
            else {
                return "\(Int(abs(since(Date(), in: .year)))) yrs ago"
            }
        }
        else {
            return self.scheduleDate()
        }
    }
    
    func scheduleDate() -> String {
        
        //Scheduled @ 16, Apr 05:30 PM
        return self.toString(format: .ntScheduleTime)
    }
    
    //MARK:- Compare Dates
    
    /// Compares dates to see if they are equal while ignoring time.
    func compare(_ comparison: DateComparisonType) -> Bool {
        
        switch comparison {
        case .isToday:
            return compare(.isSameDay(as: Date()))
            
        case .isTomorrow:
            let comparison = Date().adjust(.day, offset:1)
            return compare(.isSameDay(as: comparison))
            
        case .isYesterday:
            let comparison = Date().adjust(.day, offset: -1)
            return compare(.isSameDay(as: comparison))
            
        case .isSameDay(let date):
            return component(.year) == date.component(.year)
                && component(.month) == date.component(.month)
                && component(.day) == date.component(.day)
            
        case .isThisWeek:
            return self.compare(.isSameWeek(as: Date()))
            
        case .isNextWeek:
            let comparison = Date().adjust(.week, offset:1)
            return compare(.isSameWeek(as: comparison))
            
        case .isLastWeek:
            let comparison = Date().adjust(.week, offset:-1)
            return compare(.isSameWeek(as: comparison))
            
        case .isSameWeek(let date):
            if component(.week) != date.component(.week) {
                return false
            }
            // Ensure time interval is under 1 week
            return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
            
        case .isThisMonth:
            return self.compare(.isSameMonth(as: Date()))
            
        case .isNextMonth:
            let comparison = Date().adjust(.month, offset:1)
            return compare(.isSameMonth(as: comparison))
            
        case .isLastMonth:
            let comparison = Date().adjust(.month, offset:-1)
            return compare(.isSameMonth(as: comparison))
            
        case .isSameMonth(let date):
            return component(.year) == date.component(.year) && component(.month) == date.component(.month)
            
        case .isThisYear:
            return self.compare(.isSameYear(as: Date()))
            
        case .isNextYear:
            let comparison = Date().adjust(.year, offset:1)
            return compare(.isSameYear(as: comparison))
            
        case .isLastYear:
            let comparison = Date().adjust(.year, offset:-1)
            return compare(.isSameYear(as: comparison))
            
        case .isSameYear(let date):
            return component(.year) == date.component(.year)
            
        case .isInTheFuture:
            return self.compare(.isLater(than: Date()))
            
        case .isInThePast:
            return self.compare(.isEarlier(than: Date()))
            
        case .isEarlier(let date):
            return (self as NSDate).earlierDate(date) == self
            
        case .isLater(let date):
            return (self as NSDate).laterDate(date) == self
            
        case .isWeekday:
            return !compare(.isWeekend)
            
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
    }
    
    //MARK:- Adjust dates
    
    /// Creates a new date with adjusted components
    
    func adjust(_ component: DateComponentType, offset: Int) -> Date {
        
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
            
        case .minute:
            dateComp.minute = offset
            
        case .hour:
            dateComp.hour = offset
            
        case .day:
            dateComp.day = offset
            
        case .weekday:
            dateComp.weekday = offset
            
        case .nthWeekday:
            dateComp.weekdayOrdinal = offset
            
        case .week:
            dateComp.weekOfYear = offset
            
        case .month:
            dateComp.month = offset
            
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    /// Return a new Date object with the new hour, minute and seconds values.
    func adjust(hour: Int?, minute: Int?, second: Int?, day: Int? = nil, month: Int? = nil) -> Date {
        
        var comp = Date.components(self)
        comp.month = month ?? comp.month
        comp.day = day ?? comp.day
        comp.hour = hour ?? comp.hour
        comp.minute = minute ?? comp.minute
        comp.second = second ?? comp.second
        return Calendar.current.date(from: comp)!
    }
    
    func adjustCurrentDate(_ component: DateComponentType, value: Int) -> Date {
        
        var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        switch component {
        case .second:
            dateComp.second = value
            
        case .minute:
            dateComp.minute = value
            
        case .hour:
            dateComp.hour = value
            
        case .day:
            dateComp.day = value
            
        case .weekday:
            dateComp.weekday = value
            
        case .nthWeekday:
            dateComp.weekdayOrdinal = value
            
        case .week:
            dateComp.weekOfYear = value
            
        case .month:
            dateComp.month = value
            
        case .year:
            dateComp.year = value
        }
        
        switch dateComp.month! {
        case 4, 6, 9, 11:
            if dateComp.day! > 30 {
                dateComp.day = 30
            }
            break
            
        case 2:
            if dateComp.year! % 4 == 0 {
                if dateComp.day! > 29 {
                    dateComp.day = 29
                }
            }
            else {
                if dateComp.day! > 28 {
                    dateComp.day = 28
                }
            }
            break
            
        default:
            break
        }
        return Calendar.current.date(from: dateComp)!
    }
    
    //MARK:- Date for...
    func dateFor(_ type: DateForType) -> Date {
        
        switch type {
        case .startOfDay:
            return adjust(hour: 0, minute: 0, second: 0)
            
        case .endOfDay:
            return adjust(hour: 23, minute: 59, second: 59)
            
        case .startOfWeek:
            let offset = component(.weekday)!-1
            return adjust(.day, offset: -(offset))
            
        case .endOfWeek:
            let offset = 7 - component(.weekday)!
            return adjust(.day, offset: offset)
            
        case .startOfMonth:
            return adjust(hour: 0, minute: 0, second: 0, day: 1)
            
        case .endOfMonth:
            let month = (component(.month) ?? 0) + 1
            return adjust(hour: 0, minute: 0, second: 0, day: 0, month: month)
            
        case .tomorrow:
            return adjust(.day, offset:1)
            
        case .yesterday:
            return adjust(.day, offset:-1)
            
        case .nearestMinute(let nearest):
            let minutes = (component(.minute)! + nearest/2) / nearest * nearest
            return adjust(hour: nil, minute: minutes, second: nil)
            
        case .nearestHour(let nearest):
            let hours = (component(.hour)! + nearest/2) / nearest * nearest
            return adjust(hour: hours, minute: 0, second: nil)
        }
    }
    
    //MARK:- Time since...
    func since(_ date: Date, in component: DateComponentType) -> Int64 {
        
        switch component {
        case .second:
            return Int64(timeIntervalSince(date))
            
        case .minute:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.minuteInSeconds)
            
        case .hour:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.hourInSeconds)
            
        case .day:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .day, in: .era, for: self)
            let start = calendar.ordinality(of: .day, in: .era, for: date)
            return Int64(end! - start!)
            
        case .weekday:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekday, in: .era, for: self)
            let start = calendar.ordinality(of: .weekday, in: .era, for: date)
            return Int64(end! - start!)
            
        case .nthWeekday:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: self)
            let start = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: date)
            return Int64(end! - start!)
            
        case .week:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekOfYear, in: .era, for: self)
            let start = calendar.ordinality(of: .weekOfYear, in: .era, for: date)
            return Int64(end! - start!)
            
        case .month:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .month, in: .era, for: self)
            let start = calendar.ordinality(of: .month, in: .era, for: date)
            return Int64(end! - start!)
            
        case .year:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .year, in: .era, for: self)
            let start = calendar.ordinality(of: .year, in: .era, for: date)
            return Int64(end! - start!)
        }
    }
    
    //MARK:- Extracting components
    func component(_ component: DateComponentType) -> Int? {
        
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
            
        case .minute:
            return components.minute
            
        case .hour:
            return components.hour
            
        case .day:
            return components.day
            
        case .weekday:
            return components.weekday
            
        case .nthWeekday:
            return components.weekdayOrdinal
            
        case .week:
            return components.weekOfYear
            
        case .month:
            return components.month
            
        case .year:
            return components.year
        }
    }
    
    func numberOfDaysInMonth() -> Int {
        
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!
        return range.upperBound - range.lowerBound
    }
    
    func firstDayOfWeek() -> Int {
        
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    func lastDayOfWeek() -> Int {
        
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    //MARK:- Internal Components
    internal static func componentFlags() -> Set<Calendar.Component> {
        
        return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear]
    }
    
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    //MARK:- Static Cached Formatters
    /// A cached static array of DateFormatters so that thy are only created once.
    private static func cachedDateFormatters() -> [String: DateFormatter] {
        
        struct Static {
            static var formatters: [String: DateFormatter]? = [String: DateFormatter]()
        }
        return Static.formatters!
    }
    
    private static func cachedOrdinalNumberFormatter() -> NumberFormatter {
        
        struct Static {
            static var numberFormatter = NumberFormatter()
        }
        if #available(iOSApplicationExtension 9.0, *) {
            Static.numberFormatter.numberStyle = .ordinal
        }
        return Static.numberFormatter
    }
    
    /// Generates a cached formatter based on the specified format, timeZone and locale. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ format: String = DateFormatType.ntDateTime.stringFormat, timeZone: Foundation.TimeZone = Foundation.TimeZone.current, isDefaultLocale: Bool? = false) -> DateFormatter {
        
        var appLocale = Locale.current
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(appLocale.hashValue)"
        var formatters = Date.cachedDateFormatters()
        
        if let cachedDateFormatter = formatters[hashKey] {
            return cachedDateFormatter
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            
            formatters[hashKey] = formatter
            return formatter
        }
    }
    
    /// Generates a cached formatter based on the provided date style, time style and relative date. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current) -> DateFormatter {
        
        var formatters = Date.cachedDateFormatters()
        let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        
        if let cachedDateFormatter = formatters[hashKey] {
            return cachedDateFormatter
        }
        else {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatters[hashKey] = formatter
            return formatter
        }
    }
    
    //MARK:- Intervals In Seconds
    internal static let minuteInSeconds: Double = 60
    internal static let hourInSeconds: Double = 3600
    internal static let dayInSeconds: Double = 86400
    internal static let weekInSeconds: Double = 604800
    internal static let yearInSeconds: Double = 31556926
}

extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }
        
        return end - start
    }
}

extension Date {
    
    var zeroSeconds: Date? {
        
        get {
            let calender = Calendar.current
            let dateCompos = calender.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return calender.date(from: dateCompos)
        }
    }
}

//MARK:- Enums
public enum DateFormatType {
    
    /// formatted year "yyyy" i.e. 2000
    case ntYear
    
    /// formatted year and month "yyyy-MM" i.e. 2000-01
    case ntYearMonth
    
    /// formatted month "MMM" i.e. Jan
    case ntMonth
    
    /// formatted month "dd" i.e. 01
    case ntDay
    
    /// formatted month "EE" i.e. Mon
    case ntDayShortName
    
    /// formatted month "EEEE" i.e. Monday
    case ntDayFullName
    
    /// formatted year and month "MMMM yyyy" i.e. January 2000
    case ntCalenderMonth
    
    /// formatted date "yyyy-MM-dd" i.e. 2000-01-01
    case ntDate
    
    /// formatted date "dd MMM yyyy" i.e. 01 Jan 2000
    case ntBirthday
    
    /// formatted date "EEE, dd MMM hh:mm a" i.e. Mon, 01 Jan 12:00 AM
    case ntSchedule
    
    /// formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 2000-01-01 00:00:00
    case ntDateTime
    
    /// formatted date and time "yyyy-MM-dd hh:mm:ss a" i.e. 2000-01-01 12:00:00 AM
    case ntDateTimeAMPM
    
    /// formatted date "dd MMM yyyy, hh:mm a" i.e. 01 Jan 2000, 12:00 AM
    case ntEventPoll
    
    /// formatted date "dd-MM-yyyy" i.e. 01-01-2000
    case ntFollowDate
    
    /// formatted date "dd MMM yy  HH:mm" i.e. 01/01/00  00:00
    case ntDeliveryStatusDateTime24
    
    /// formatted date "dd MMM yy  h:mm a" i.e. 01/01/00  12:00 AM
    case ntDeliveryStatusDateTime12
    
    /// formatted date "HH:mm" i.e. 00:00
    case ntDeliveryStatusTime24
    
    /// formatted date "h:mm a" i.e. 12:00 AM
    case ntDeliveryStatusTime12
    
    /// formatted date "dd MMM yyyy" i.e. 01 Jan 2000
    case ntTalkTime
    
    /// formatted date "dd, MMM hh:mm a" i.e. 01, Jan 12:00 AM
    case ntScheduleTime
    
    /// formatted date "dd-MM-yyyy' at 'hh:mm a'" i.e. 01-01-2000 at 12:00 AM
    case ntFullDateTime
    
    /// formatted date "dd MMM, HH:mm" i.e. 01 Jan, 15:00
    case ntThisYearDateTime24
    
    /// formatted date "dd MMM, h:mm a" i.e. 01 Jan, 12:00 AM
    case ntThisYearDateTime12
    
    /// formatted date "dd MMM yyyy, h:mm a" i.e. 01 Jan, 12:00 AM
    case ntFullDateTimeWithMonth
    
    /// A custom date format string
    case custom(String)
    
    var stringFormat: String {
        
        switch self {
        case .ntYear: return "yyyy"
        case .ntYearMonth: return "yyyy-MM"
        case .ntMonth: return "MMM"
        case .ntDay: return "dd"
        case .ntDayShortName: return "EEE"
        case .ntDayFullName: return "EEEE"
        case .ntCalenderMonth: return "MMMM yyyy"
        case .ntDate: return "yyyy-MM-dd"
        case .ntBirthday: return "dd MMM yyyy"
        case .ntSchedule: return "EEE, dd MMM hh:mm a"
        case .ntDateTime: return "yyyy-MM-dd HH:mm:ss"
        case .ntDateTimeAMPM: return "yyyy-MM-dd hh:mm:ss a"
        case .ntEventPoll: return "dd MMM yyyy, hh:mm:ss a"
        case .ntFollowDate: return "dd-MM-yyyy"
        case .ntDeliveryStatusDateTime24: return "dd MMM yy  HH:mm"
        case .ntDeliveryStatusDateTime12: return "dd MMM yy  h:mm a"
        case .ntFullDateTime: return "dd-MM-yyyy' at 'hh:mm a"
        case .ntDeliveryStatusTime24: return "HH:mm"
        case .ntDeliveryStatusTime12: return "h:mm a"
        case .ntTalkTime: return "dd MMM yyyy"
        case .ntScheduleTime: return "dd, MMM hh:mm a"
        case .ntThisYearDateTime24: return "dd MMM, HH:mm"
        case .ntThisYearDateTime12: return "dd MMM, h:mm a"
        case .ntFullDateTimeWithMonth: return "dd MMM yyyy, h:mm a"
            
        case .custom(let customFormat): return customFormat
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    
    case local, utc
    var timeZone: TimeZone {
        
        switch self {
        //case .local: return NSTimeZone.local
        case .local: return TimeZone.current
        case .utc: return TimeZone(secondsFromGMT: 0)!
        }
    }
}

// The string keys to modify the strings in relative format
public enum RelativeTimeStringType {
    
    case nowPast, nowFuture, secondsPast, secondsFuture, oneMinutePast, oneMinuteFuture, minutesPast, minutesFuture, oneHourPast, oneHourFuture, hoursPast, hoursFuture, oneDayPast, oneDayFuture, daysPast, daysFuture, oneWeekPast, oneWeekFuture, weeksPast, weeksFuture, oneMonthPast, oneMonthFuture, monthsPast, monthsFuture, oneYearPast, oneYearFuture, yearsPast, yearsFuture
}

// The type of comparison to do against today's date or with the suplied date.
public enum DateComparisonType {
    
    // Days
    
    /// Checks if date today.
    case isToday
    /// Checks if date is tomorrow.
    case isTomorrow
    /// Checks if date is yesterday.
    case isYesterday
    /// Compares date days
    case isSameDay(as:Date)
    
    // Weeks
    
    /// Checks if date is in this week.
    case isThisWeek
    /// Checks if date is in next week.
    case isNextWeek
    /// Checks if date is in last week.
    case isLastWeek
    /// Compares date weeks
    case isSameWeek(as:Date)
    
    // Months
    
    /// Checks if date is in this month.
    case isThisMonth
    /// Checks if date is in next month.
    case isNextMonth
    /// Checks if date is in last month.
    case isLastMonth
    /// Compares date months
    case isSameMonth(as:Date)
    
    // Years
    
    /// Checks if date is in this year.
    case isThisYear
    /// Checks if date is in next year.
    case isNextYear
    /// Checks if date is in last year.
    case isLastYear
    /// Compare date years
    case isSameYear(as:Date)
    
    // Relative Time
    
    /// Checks if it's a future date
    case isInTheFuture
    /// Checks if the date has passed
    case isInThePast
    /// Checks if earlier than date
    case isEarlier(than:Date)
    /// Checks if later than date
    case isLater(than:Date)
    /// Checks if it's a weekday
    case isWeekday
    /// Checks if it's a weekend
    case isWeekend
}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

// The type of date that can be used for the dateFor function.
public enum DateForType {
    
    case startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, tomorrow, yesterday, nearestMinute(minute: Int), nearestHour(hour: Int)
}

@objc class LocalizationKeys: NSObject {
 
    
   
    
    override init() {
        super.init()
    }
}
