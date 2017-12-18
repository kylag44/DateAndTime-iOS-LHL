import UIKit


/*:
 # (NS)Date
 - "A specific point in time, independent of any calendar or time zone."
 */

let now = Date()

//: Test to see which reference date Apple uses for Date

now.timeIntervalSinceReferenceDate
now.timeIntervalSince1970

//: This proves that Date uses Apple's reference date

Date(timeIntervalSinceReferenceDate: now.timeIntervalSinceReferenceDate)

//: Create a date 10 minutes later

let later = Date(timeIntervalSinceNow: 60 * 10)
print(#line, later)
print(#line, later.timeIntervalSinceReferenceDate)

// Other operators are also available
if later > now {
  print(#line, "Dates can be compared")
}

/*:
 ```swift
 var timeIntervalSinceNow: TimeInterval { get }
 ```
 */

//: timeIntervalSinceNow gives you the interval between some date and now, negative for the future.


later.timeIntervalSinceNow

//: TimeInterval is just a TypeAlias to double

let interval = 60.0 as TimeInterval

//: Add time intervals to Date

let evenLater = later + interval // 11 mins in total

/*:
 # DateComponents
 - DateComponents has a very long initializer, but everything has a default value so can be omitted.
 */

/*
 let dateComponents = DateComponents(calendar: nil,
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
 yearForWeekOfYear: nil)
 */

//: You can just set/get its properties

var finalDay = DateComponents()
finalDay.calendar = Calendar(identifier: .gregorian)
finalDay.timeZone = .current
finalDay.day = 22
finalDay.month = 12
finalDay.year = 2017
finalDay.hour = 13
finalDay.minute = 20

/*:
 - Only set the components that are useful.
 - ☢️ The system doesn't prevent you from setting nonsensical date component values.
 */

var bumDate = DateComponents()
bumDate.day = 31
bumDate.month = 2

if let noDate = bumDate.date {
  print(#line, noDate)
}else {
  print(#line, "date is nil because there is no Feb 31")
}

//: Getting the Date from components

guard let dateValue = finalDay.date else { fatalError() }

//: Getting the components
if let day = finalDay.day, let month = finalDay.month {
  print(#line, "finalDay is day: \(day), month: \(month)")
}

/*:
 # Calendar
 - Neither Date nor DateComponents know anything about the users current Calendar.
 - The main Calendar in use internationally is the .gregorian calendar, but there are others which can make apps break!
 */

//: Get the current one

var calendar = Calendar.current

//: Since the user could change the calendar while your app is loaded you can call:

calendar = Calendar.autoupdatingCurrent

guard let dateFromComponents = calendar.date(from: finalDay) else { fatalError() }

//: Converting from DateComponents to Date using Calendar

var finalDay2 = DateComponents(year: 2017, month: 12, day: 22, hour: 18)
let greg = Calendar(identifier: .gregorian)

// returns nil if no valid date can be found
guard var dateFromComponents2 = greg.date(from: finalDay2) else { fatalError() }
dateFromComponents2

//: You can set a specific time on an existing Date.

guard let twentyMinsLater = greg.date(bySettingHour: 18, minute: 20, second: 30, of: dateFromComponents2) else { fatalError() }

twentyMinsLater


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

let tomorrow = Calendar.current.compare(Date(), to: tomorrowDate , toGranularity: .day)
if tomorrow == ComparisonResult.orderedSame {
  print(#line, "if today and tomorrow are the same in terms of 1 day granularity.")
} else if tomorrow == ComparisonResult.orderedAscending {
  print(#line, "tomorrow is 1 day later than today, which it is.")
} else if tomorrow == ComparisonResult.orderedDescending {
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
DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)

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
 # DateInterval
 * iOS 10+ Adds DateInterval.
 * DateInterval is a Swift only Struct that represents a  positive time/date span or 0 (negatives are not supported).
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
 # DateIntervalFormatter
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
let components6 = DateComponents(month: 1)
let newDate6 = Calendar.current.date(byAdding: components6, to: Date())
Calendar.current.startOfDay(for: newDate6!)

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
























