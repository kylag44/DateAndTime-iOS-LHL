import Foundation

/*:
 # Overview of Date Programming on the platform
 - Are dates M, V or C?
 - Date/time programming is fundamental.
 - Why are dates/times hard?
 - Date programming is part of `Foundation`.
 - Involves a number of classes including `(NS)Date`, `(NS)DateComponents`, `(NS)Calendar`, `(NS)DateFormatter`.
 - `(NS)Date` allows you to represent an absolute point in time.
 - `(NS)Calendar` can represent a particular calendar. For instance, the Gregorian or Hebrew Calendar.
 - 🎗 Use `(NS)Calendar` for most date calculations.
 - `(NS)DateComponents` allows you to repesent the components of a particular date, such as the day, month, hour, etc. *relative* to a particular type of Calendar.
 - `(NS)Calendar` allows you to convert from `(NS)Date` to `(NS)DateComponents` since DateComponents are relative to a particular calendar type.
 - `(NS)TimeZone` allows our date/time computations to be time zone aware.
 */

/*:
 ---
 
 # `(NS)Date`
 - A specific point in time, independent of any specific calendar or time zone.
 - Good for storing or transmitting over a wire. Why?
 - `(NS)Date` provides methods for creating dates, comparing dates, and computing intervals with other Dates that are independent of calendars and time zones.
 - `(NS)Date` computes time as a floating point integer relative to an absolute reference time: the first instant of January 1, 2001, Greenwich Mean Time (GMT).
 - Dates before the reference date are stored as negative floats; dates after, are stored as positive floats.
 - 🎗 The sole primitive method of NSDate, `timeIntervalSinceReferenceDate` provides the basis for all the other methods in the NSDate interface.
 - `NSDate` converts all date and time representations to and from `(NS)TimeInterval` values that are relative to the absolute reference date.
 - `(NS)TimeInterval` is just a typedef to double.
 */

let now = Date()

now.timeIntervalSinceReferenceDate
now.timeIntervalSince1970

//: `NSDate` Adding/Subtracting Seconds

let tenMinsLater = Date(timeIntervalSinceNow: 60 * 10)
tenMinsLater.timeIntervalSinceReferenceDate

let twentyFourHoursInSeconds: TimeInterval = 60 * 60 * 24

// init(timeInterval: TimeInterval, since date: Date)
// Returns a Date initialized relative to another given date by a given number of seconds.

let tomorrow = Date(timeInterval: twentyFourHoursInSeconds, since: Date())
tomorrow.timeIntervalSinceReferenceDate

let yesterday = Date(timeInterval: -twentyFourHoursInSeconds, since: Date())
yesterday.timeIntervalSinceReferenceDate

// Normal comparison operators are available in Swift 😎 (not Objc ❌)

if tenMinsLater > now {
  print(#line, "Dates can be compared normally in Swift!")
}

// In Objc use `compare` because NSDate is an object 🙁
// Do it like this in Objc:

let comparisonResult = Date().compare(Date())

switch comparisonResult {
case .orderedSame:
  print(#line, "they are the same dates")
case .orderedAscending:
  print(#line, "the receiver is earlier")
case .orderedDescending:
  print(#line, "the receiver is later")
}

/*:
 ```swift
 var timeIntervalSinceNow: TimeInterval { get }
 ```
 */

//: `timeIntervalSinceNow` is a computed property whose receiver is a `Date` instance. It returns the interval between the receiver's date and now, negative for the future.

// Why is this not 600?

tenMinsLater.timeIntervalSinceNow
-tenMinsLater.timeIntervalSinceNow

yesterday.timeIntervalSinceNow //  / 60 / 60

//: TimeInterval is just a TypeAlias to Double to represents seconds and fractional seconds.

let sixtySeconds = 60.0 as TimeInterval

//: Add time intervals to Date using the `+` operator (Swift only)

let elevenMinsLater = tenMinsLater + sixtySeconds // Adds Date and TimeInterval together -- 11 mins in total (☠️ order matters!)

// Or Swift & ObjC use `func addingTimeInterval(_ timeInterval: TimeInterval) -> Date`

let twelveMinsLater = Date().addingTimeInterval(sixtySeconds * 11)

/*:
 ✅  Create the date for next week at the same time as now using Date.
 */

/*:
 ---
 # `(NS)DateComponents`
 - 🎗 Think URLComponents.
 - A date/time specified in terms of human understandable units.
 - Units are things like year, month, day, hour, minute, etc.
 - These units must be evaluated relative to a specific calendar and time zone.
 - Can be used to specify a particular date/time. eg. 2nd month, 1st day. => 01 Feb
 - Can also be used to specify a time duration: eg. 5 hours, 4 minutes, 3 seconds.
 */

//: DateComponents Swift Initializer!

/*
init(calendar: Calendar? = default, timeZone: TimeZone? = default, era: Int? = default, year: Int? = default, month: Int? = default, day: Int? = default, hour: Int? = default, minute: Int? = default, second: Int? = default, nanosecond: Int? = default, weekday: Int? = default, weekdayOrdinal: Int? = default, quarter: Int? = default, weekOfMonth: Int? = default, weekOfYear: Int? = default, yearForWeekOfYear: Int? = default)
 */

/*:
 ✅ Using the DateComponents Initializer create 01 Feb.
 */

/*:
 ✅ Using the DateComponents Initializer create the time duration 5 hours, 4 minutes, 3 seconds
 */


//: Use the initializer and/or its properties

var dateFromProperties = DateComponents()
dateFromProperties.hour = 2
dateFromProperties.minute = 10
// dateFromProperties.calendar = .current

dateFromProperties.isValidDate

//: Getting the Date from components

if let dateFromProperties = dateFromProperties.date {
  print(#line, "with a calendar it can be converted to a date", dateFromProperties)
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

var feb31 = DateComponents()
feb31.day = 31
feb31.month = 2

// check for a valid date relative to a calendar
feb31.isValidDate(in: .current)


/*:
 ✅  Using `DateComponents` create a date for the last day of LHL; make sure it's a valid date.
 */



/*:
 - You can create dates that don't specify things like year.
 - This might be useful for doing things like storing someone's birth date!
 - Defaults to the year 1 CE (not guaranteed).
 */

var july2 = DateComponents()
july2.month = 7
july2.day = 2

// Use Calendar's method: `date(from components: DateComponents) -> Date?` to get a date from a Calendar

let bDate = Calendar.current.date(from: july2)

/*:
 - We can go ahead and store this as a Date, but when we go to use it we will want to set the year.
 - This is `(NS)Calendar`'s job.
 - Let's look at the `Calendar` next.
 */

/*:
 ---
 # `(NS)Calendar`
 - Date is independent of specific Calendars.
 - The main Calendar in use internationally is the Gregorian Calendar, but there are others.
 - You should write date/time code independently of a specific Calendar if you intend your app to be used outside the Americas and Europe.
 - Use `(NS)Calendar` to convert between absolute date/time and date/time components, like year, day, minutes, etc.
 */

//: Get the current one

var calendar = Calendar.current

//: Since the user could change the calendar while your app is loaded you can call:

calendar = Calendar.autoupdatingCurrent

//: Converting from DateComponents to Date using Calendar

var finalDay2 = DateComponents(year: 2018, month: 6, day: 8, hour: 18)
let greg = Calendar(identifier: .gregorian)

// Returns an optional, nil if no valid date can be found
guard var dateFromComponents = greg.date(from: finalDay2) else { fatalError() }

dateFromComponents

//: You can set a specific time on an existing Date.

let twentyMins = DateComponents(minute: 20)

guard let twentyMinsLater = greg.date(byAdding: twentyMins, to: dateFromComponents) else { fatalError() }

twentyMinsLater

// Getting a date component from a time using `(NS)Calendar`

greg.component(.month, from: twentyMinsLater)


//: Correct way to add dates that need to be Calendar aware. Use `func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool = default) -> Date?`

let calendar2 = Calendar.current
let components2 = DateComponents(day: 1, hour: 1)

guard let date3 = calendar2.date(byAdding: components2, to: Date()) else {
  fatalError()
}

date3

let feb28 = DateComponents(calendar: .current, month: 2, day: 28).date!
Calendar.current.date(byAdding: DateComponents(day: 1), to: feb28)

//: Finding the next occurrence of a date

let components3 = DateComponents(weekday: 2) // Monday

guard let nextMonday = calendar2.nextDate(after: Date(), matching: components3, matchingPolicy: .nextTime) else {
  fatalError()
}

nextMonday


/*:
 ### Comparing dates using Calendar and DateComponents
 */

let dayComponent = DateComponents(day: 1)
guard let tomorrowDate = Calendar.current.date(byAdding: dayComponent, to: Date()) else { fatalError() }

let tomorrowResult = Calendar.current.compare(Date(), to: tomorrowDate , toGranularity: .day)

switch tomorrowResult {
case .orderedSame:
  print(#line, "today and tomorrow don't differ by 1 day")
case .orderedAscending:
  print(#line, "tomorrow is 1 day later than today.")
case .orderedDescending:
  print(#line, "tomorrow is earlier by 1 day than today.")
}

//: Simple Date Comparison

var components5 = DateComponents(hour: 3, minute: 10)

guard let todayPlus3Hrs10Mins = Calendar.current.date(byAdding: components5, to: Date()) else { fatalError() }

//: Get start of day!

var startOfDay = Calendar.current.startOfDay(for: todayPlus3Hrs10Mins)


//: End of Previous Day (Should probably use DateComponents, see the questions).

startOfDay -= 1 // subtract a second from day's beginning


//: Useful Date Comparisons new in iOS 8

Calendar.current.isDate(Date(), inSameDayAs: tomorrow)

Calendar.current.isDateInToday(Date())

Calendar.current.isDateInWeekend(Date())

Calendar.current.isDateInTomorrow(tomorrow)

Calendar.current.isDateInYesterday(Calendar.current.startOfDay(for: Date())-1)

/*:
 ✅ Above I saved my birthdate components as `july2` which is just the month and day. The year defaults to 1 CE. Help me set a reminder this year for that date using Calendar.
 */


/*:
 ✅ Add 10 hours and 20 minutes to right now and test to see if that new time falls on tomorrow.
 */



/*:
 ---
 # Date Formatting
 - `(NS)DateFormatter` is used to convert to and from a string representation of a date. Used for the view layer.
 */

var formatter1 = DateFormatter()
formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
formatter1.timeZone = TimeZone(secondsFromGMT: 0)
formatter1.string(from: Date())

//: This is called a "Fixed Format Date" using the ISO 8601 standard. When would you want to use this and when would you not want to use this?


//: iOS 10+ uses ISO8601DateFormatter for Fixed Formats which uses [ISO 8601 Standard](http://www.iso.org/iso/home/standards/iso8601). See the documentation for details.

//: Convenience API for creating localized date strings (user facing).
// .full, .long, .medium, .short, .none

DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)

DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .full)

//: Localized way of creating DateFormatter with full control

var formatter2 = DateFormatter()
formatter2.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
formatter2.string(from: Date())

//: Converting String dates to Date using template (Can be used for handling dates you get from network requests).

let formatter3 = DateFormatter()
formatter3.dateFormat = "yyyy-MM-dd"
let randomDateString = "2010-12-11"
guard let newDate3 = formatter3.date(from: randomDateString) else {
  fatalError()
}

newDate3 // Date

DateFormatter.localizedString(from: newDate3, dateStyle: .short, timeStyle: .none) // uses US Locale which is default on my system

/*:
 ---
 ## `(NS)DateInterval`
 - iOS 10+ Adds DateInterval.
 - DateInterval represents a positive time/date span (range) or 0 (negatives are not supported).
 */

let nextDayDateInterval = DateInterval(start: Date(), duration: twentyFourHoursInSeconds)

// check if a date falls within the interval
nextDayDateInterval.contains(Date())

// Adding 1 second
let oneSecondPastNextDayDateInterval = Date(timeInterval: 1, since: nextDayDateInterval.end)
nextDayDateInterval.contains(oneSecondPastNextDayDateInterval)

//: Comparing DateInterval

nextDayDateInterval < DateInterval(start: Date(), end: oneSecondPastNextDayDateInterval)
nextDayDateInterval > DateInterval(start: Date(), end: oneSecondPastNextDayDateInterval)
nextDayDateInterval == DateInterval(start: Date(), end: oneSecondPastNextDayDateInterval)

nextDayDateInterval.duration
86400/24/60/60  // One day duration

nextDayDateInterval.intersects(DateInterval(start: Date(), duration: twentyFourHoursInSeconds + 1))

/*:
 ---
 ## (NS)DateIntervalFormatter
 - "A formatter that creates string representations of time intervals."
 - For user readable date interval representations.
 */

let intervalFormatter = DateIntervalFormatter()
intervalFormatter.dateStyle = .medium
intervalFormatter.timeStyle = .short
intervalFormatter.string(from: nextDayDateInterval)

intervalFormatter.dateTemplate = "MMMM-dd-YYYY"
intervalFormatter.string(from: nextDayDateInterval)

/*:
 ---
 ## Questions
 */

//1. Get the start of the day 1 month from today


//2. Check to see if 3 days ago fell on a weekend


//3. Get end of the day 5 days from today


/*:
 ---
 ## References
 * [Date and Time Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DatesAndTimes/DatesAndTimes.html)
 * [Date Formatting Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DataFormatting/DataFormatting.html#//apple_ref/doc/uid/10000029i)
 * [Use Your Loaf](https://useyourloaf.com/blog/fun-with-date-calculations/)
 * [WWDC Session 227](https://developer.apple.com/videos/play/wwdc2013/227/)
 * [Online Fixed Format Tool](http://nsdateformatter.com)
 * [ISO 8601 Standard](https://en.wikipedia.org/wiki/ISO_8601)
 * [Epoch Converter](https://www.epochconverter.com)
 */

/*:
 ---
 
 # Measurements and Units in Foundation
 
 ### Advantages
 * mitigates conversion errors.
 * impossible to accidently compute measurements of incompatible unit types.
 * More expressive and self documenting.
 * Allows us to create more flexible methods.
 * Could define our own units, but Foundation includes most common physical quantities.
 
 ###  `Measurement` (Struct)
 
 
 init(value: Double, unit: UnitType)
 
 mutating func convert(to otherUnit: UnitType)
 
 func converted(to otherUnit: UnitType) -> Measurement<UnitType>

 
 ### Examples:
 
 */

let cm = Measurement(value: 120, unit: UnitLength.centimeters)

let inches = cm.converted(to: UnitLength.inches)

let acres = Measurement(value: 10, unit: UnitArea.acres)
let squareInches = acres.converted(to: .squareInches)

let grams = Measurement(value: 10, unit: UnitMass.grams)
let miligrams = grams.converted(to: .ounces)

let horsePower = Measurement(value: 10, unit: UnitPower.horsepower)
let watts = horsePower.converted(to: .watts)

let cups = Measurement(value: 10, unit: UnitVolume.cups)
let tableSpoons = cups.converted(to: .tablespoons)

let mph = Measurement(value: 10, unit: UnitSpeed.kilometersPerHour)
let metersPerSecond = mph.converted(to: .milesPerHour)

let calories = Measurement(value: 10, unit: UnitEnergy.calories)
let kilowattHours = calories.converted(to: .kilowattHours)

/*:
 
 ## Computation
 
 * We can compute values using *, -, /, +, ==, >=, <=
 * If we compute different units in the same Unit Type Swift will convert them to a base unit.
 */

let kmHome = Measurement(value: 20, unit: UnitLength.kilometers)
let milesToWork = Measurement(value: 5, unit: UnitLength.miles)
let totalDistance = kmHome + milesToWork

//: totalDistance is converted to base unit meters.


/*:
 ## Cool Generic Functions
 */

func rotate(angle: Measurement<UnitAngle>) {
  _ = angle.converted(to: .radians)
  // do the rotation
}

func animate(duration: Measurement<UnitDuration>) {
  _ = duration.converted(to: .seconds)
  // do animation
}

rotate(angle: Measurement(value: 12, unit: .degrees))
rotate(angle: Measurement(value: 40, unit: .radians))

animate(duration: Measurement(value: 1, unit: .hours))
animate(duration: Measurement(value: 20, unit: .minutes))

/*:
 
 ## MeasurementFormatter
 
 * Formats measurements in locale aware way.
 */

let distance = Measurement(value: 100, unit: UnitLength.miles)

let formatter = MeasurementFormatter()

let 🇨🇦 = Locale(identifier: "en_CA")
formatter.locale = 🇨🇦
formatter.string(from: distance)

let 🇺🇸 = Locale(identifier: "en_US")
formatter.locale = 🇺🇸
formatter.string(from: distance)

let 🇨🇳 = Locale(identifier: "zh_Hans_CN")
formatter.locale = 🇨🇳
formatter.string(from: distance)


/*:
 
 ### iOS Locale Identifiers
 
 [https://gist.github.com/jacobbubu/1836273](https://gist.github.com/jacobbubu/1836273)
 */
























