import UIKit

/*:
 # Overview of Date Programming on the platform
 - Involves a number of classes including `(NS)Date`, `(NS)DateComponents`, `(NS)Calendar`, `(NS)DateFormatter`.
 - `(NS)Date` allows you to represent an absolute point in time.
 - `(NS)Calendar` can represent a particular calendar. For instance, the Gregorian or Hebrew Calendar.
 - Use `(NS)Calendar for most date calculations.
 - `(NS)Calendar allows you to convert from `(NS)Date` to `(NS)DateComponents`.
 - `(NS)DateComponents allows you to repesent the components of a particular date, such as the day, month, hour, etc relative to a Calendar.
 - `(NS)TimeZone` allows our date/time computations to be time zone aware.
 */

/*:
 ---
 
 # (NS)Date
 - A specific point in time, independent of any specific calendar or time zone.
 - Good for storing or transmitting over a wire.
 - (NS)Date provides methods for creating dates, comparing dates, and computing intervals independent of calendars and time zones.
 - (NS)Date computes time as seconds relative to an absolute reference time: the first instant of January 1, 2001, Greenwich Mean Time (GMT).
 - Dates before the reference date are stored as negative numbers; dates after are stored as positive numbers.
 - The sole primitive method of NSDate, `timeIntervalSinceReferenceDate` provides the basis for all the other methods in the NSDate interface.
 - NSDate converts all date and time representations to and from NSTimeInterval values that are relative to the absolute reference date.
 */

let now = Date()

now.timeIntervalSinceReferenceDate
now.timeIntervalSince1970

//: Create a date 10 minutes later

let tenMinsLater = Date(timeIntervalSinceNow: 60 * 10)
print(tenMinsLater)
print(tenMinsLater.timeIntervalSinceReferenceDate)
let twentyFourHours: TimeInterval = 60 * 60 * 24
let tomorrow = Date(timeInterval: twentyFourHours, since: Date())
let yesterday = Date(timeInterval: -twentyFourHours, since: Date())

// Normal comparison operators are available in Swift (not Objc)

if tenMinsLater > now {
  print(#line, "Dates can be compared")
}

// In Objc use `compare` because NSDate is an object

let comparisonResult = Date().compare(Date())
if comparisonResult == .orderedSame {
  print(#line, "they are the same!")
}

/*:
 ```swift
 var timeIntervalSinceNow: TimeInterval { get }
 ```
 */

//: timeIntervalSinceNow gives you the interval between some date and now, negative for the future.

// Why is this not 600?

tenMinsLater.timeIntervalSinceNow

//: TimeInterval is just a TypeAlias to double which represents seconds.

let interval = 60.0 as TimeInterval

//: Add time intervals to Date (Swift only)

let elevenMinsLater = tenMinsLater + interval // Adds Date and TimeInterval together -- 11 mins in total

// Or

let twelveMinsLater = Date().addingTimeInterval(60 * 11)

/*:
 ✅  Create the date for next week at the same time as now using Date.
 */

let oneWeekLaterInterval: TimeInterval = 7 * 24 * 60 * 60
let oneWeekLater = now + oneWeekLaterInterval

/*:
 ---
 # (NS)DateComponents
 - Think URLComponents.
 - A date/time specified in terms of date/time units.
 - Units are things like year, month, day, hour, and minute, etc.
 - These units are evaluated by a calendar and time zone.
 - Can be used to specify a particular date/time according to the components. eg. 2nd month, 1st day. => 01 Feb
 - Can also be used to specify a time duration: eg. 5 hours, 4 minutes, 3 seconds.
 */

//: DateComponents Swift Initializer
/*
 let dateComponents = DateComponents(
 calendar: nil,
 timeZone: nil,
 era: nil,
 year: nil,
 month: nil,
 day: nil,
 hour: nil,
 minute: nil,
 second: nil,
 nanosecond: nil,
 weekday: nil,
 weekdayOrdinal: nil,
 quarter: nil,
 weekOfMonth: nil,
 weekOfYear: nil,
 yearForWeekOfYear: nil
 )
 */

/*:
✅ Using the DateComponents Initializer create 01 Feb.
*/

let febOne = DateComponents(calendar: .current, timeZone: .current, month: 2, day: 1)

febOne.date
  
/*
✅ Using the DateComponents Initializer create the time duration 5 hours, 4 minutes, 3 seconds
*/

let fivehoursFourMinsThreeSecs = DateComponents(calendar: .current, timeZone: .current, hour: 5, minute: 4, second: 3)
print(#line, fivehoursFourMinsThreeSecs.hour ?? "No date")


//: Use the initializer and/or its properties

var dateFromProperties = DateComponents()
dateFromProperties.hour = 2
dateFromProperties.minute = 10
// dateFromProperties.calendar = .current

//: Getting the Date from components
if let _ = dateFromProperties.date {
  print(#line, "with a calendar it can be converted to a date")
} else {
  print(#line, "without a calendar it can't convert to a date")
}


//: Getting the components
if let month = dateFromProperties.month {
  print(#line, "month is \(month)")
} else {
  print(#line, "no month was set, so month is nil")
}

/*:
 - Only set the components that are useful.
 - ☠️ The system doesn't prevent you from setting nonsensical date component values.
 */

var bumDate = DateComponents()
bumDate.day = 31
bumDate.month = 2

// check for a valid date
bumDate.isValidDate(in: .current)


/*:
 ✅  Using `DateComponents` create a date for the last day, make sure it's a legitimate date.
 */


/*:
 ---
 # (NS)Calendar
 - Neither Date nor DateComponents know anything about the users current Calendar.
 - The main Calendar in use internationally is the Gregorian calendar, but there are others which can make apps break.
 - Use `(NS)Calendar` to convert between absolute date/time and date/time components, like year, day, minutes, etc.
 */

//: Get the current one

var calendar = Calendar.current

//: Since the user could change the calendar while your app is loaded you can call:

calendar = Calendar.autoupdatingCurrent

//: Converting from DateComponents to Date using Calendar

var finalDay2 = DateComponents(year: 2017, month: 2, day: 31, hour: 18)
let greg = Calendar(identifier: .gregorian)

// returns nil if no valid date can be found
guard var dateFromComponents = greg.date(from: finalDay2) else { fatalError() }

dateFromComponents

//: You can set a specific time on an existing Date.

guard let twentyMinsLater = greg.date(bySettingHour: 18, minute: 20, second: 30, of: dateFromComponents) else { fatalError() }

twentyMinsLater

// Getting the seconds component from a date using (NS)Calendar

Calendar.current.component(.second, from: twentyMinsLater)


//:  Adding dates using Calendar.
//: (This is the correct way to add dates. Why should you avoid creating dates by adding TimeIntervals to Date?)


let calendar2 = Calendar.current
let components2 = DateComponents(day: 1, hour: 1)
guard let date3 = calendar2.date(byAdding: components2, to: Date()) else {
  // will fail if this is not an actual date
  fatalError()
}

date3

//: Finding the next occurrence of a date.

let components3 = DateComponents(weekday: 2) // Monday
guard let nextMonday = greg.nextDate(after: Date(), matching: components3, matchingPolicy: .nextTime) else {
  fatalError()
}

nextMonday

//: More on DateInterval below!

guard let nextWeekend = greg.nextWeekend(startingAfter: Date()) else { fatalError() }
print(#line, nextWeekend)

/*:
 #### Comparing dates using Calendar and DateComponents
*/

let dayComponents = DateComponents(day:1)
guard let tomorrowDate = Calendar.current.date(byAdding: dayComponents, to: Date()) else { fatalError() }

let tomorrow2 = Calendar.current.compare(Date(), to: tomorrowDate , toGranularity: .day)

if tomorrow2 == ComparisonResult.orderedSame {
  print(#line, "if today and tomorrow are the same in terms of 1 day granularity.")
} else if tomorrow2 == ComparisonResult.orderedAscending {
  print(#line, "tomorrow is 1 day later than today, which it is.")
} else if tomorrow2 == ComparisonResult.orderedDescending {
  print(#line, "fires if tomorrow is earlier by 1 day than today, which it is not.")
}

//: Simple Date Comparison

var components5 = DateComponents(hour: 3, minute: 10)
guard let todayPlus2Hours = Calendar.current.date(byAdding: components5, to: Date()) else { fatalError() }

//: Start of Day
var startOfDay = Calendar.current.startOfDay(for: todayPlus2Hours)


//: End of Previous Day (Should probably use DateComponents, see the questions).
startOfDay -= 1 // subtract a second from day's beginning


//: Useful Date Comparisons

Calendar.current.isDateInToday(Date())
Calendar.current.isDateInWeekend(Date())
Calendar.current.isDateInTomorrow(Date())
Calendar.current.isDateInYesterday(Date())

/*:
 ---
 # Date Formatting
 * (NS)DateFormatter is used to convert to and from a string representation of a date.
 */

var formatter1 = DateFormatter()
formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
formatter1.timeZone = TimeZone(secondsFromGMT: 0)
formatter1.string(from: Date())

//: This is called a "Fixed Format Date" using the ISO 8601 standard. When would you want to use this and when would you not want to use this?


//: iOS 10+ uses ISO8601DateFormatter for Fixed Formats. See the documentation.

//: Convenient way to create localized date strings (user facing).

DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none)
DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .full)

//: Localized way of creating DateFormatter with full control

var formatter2 = DateFormatter()
formatter2.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
formatter2.string(from: Date())

//: Converting String dates to Date using template (Used for network requests).

let formatter3 = DateFormatter()
formatter3.dateFormat = "yyyy-MM-dd"
let randomDateString = "2010-12-11"
guard let newDate3 = formatter3.date(from: randomDateString) else {
  fatalError()
}

DateFormatter.localizedString(from: newDate3, dateStyle: .short, timeStyle: .none) // uses US Locale which is default on my system

/*:
 # (NS)DateInterval
 * iOS 10+ Adds DateInterval.
 * DateInterval represents a  positive time/date span or 0 (negatives are not supported).
 */

let dateInterval = DateInterval(start: Date(), duration: 60*60*24)
dateInterval.contains(Date())
let endDatePlus1 = Date(timeInterval: 1, since: dateInterval.end)
dateInterval.contains(endDatePlus1)

//: Comparing DateInterval

dateInterval < DateInterval(start: Date(), end: endDatePlus1)
dateInterval > DateInterval(start: Date(), end: endDatePlus1)
dateInterval == DateInterval(start: Date(), end: endDatePlus1)

dateInterval.duration
86400/24/60/60

/*:
 # (NS)DateIntervalFormatter
 - "A formatter that creates string representations of time intervals."
 - For user readable date interval representations.
 */

let intervalFormatter = DateIntervalFormatter()
intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .short
intervalFormatter.string(from: dateInterval)

intervalFormatter.dateTemplate = "MMMM-dd-YYYY"
intervalFormatter.string(from: dateInterval)

// Questions

//1. Get the start of the day 1 month from today

//2. Check to see if 3 days ago fell on a weekend

//3. Get end of the day 5 days from today

//4. Using DateComponents get the Date/Time that is 1 week earlier and the very last second of the day.

/*:
 ## References
 * [Date and Time Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DatesAndTimes/DatesAndTimes.html)
 * [Date Formatting Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DataFormatting/DataFormatting.html#//apple_ref/doc/uid/10000029i)
 * [Use Your Loaf](https://useyourloaf.com/blog/fun-with-date-calculations/)
 * [WWDC Session 227](https://developer.apple.com/videos/play/wwdc2013/227/)
 * [Online Fixed Format Tool](http://nsdateformatter.com)
 * [ISO 8601 Standard](https://en.wikipedia.org/wiki/ISO_8601)
 * [Epoch Converter](https://www.epochconverter.com)
 */
























