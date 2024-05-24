//
//  TimeHelper.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 21.05.2024.
//

import Foundation

// this helper performs various functions over time operations used in various Chore ViewModels


// function to add a "fault" value to date, this value helps to check possible errors with Date pickers that have seemingly same value
func addMinute(date: Date) -> Date{
    return Calendar.current.date(byAdding: .second, value: 60, to: date) ?? Date.now
}

// returns a Date modified by the repeat interval specified in chore
func dateWithInterval(chore: Chore) -> Date{

    var additionType: Calendar.Component

    var intervalValue = chore.interval!
    switch(chore.intervalType){
    case "Hours":
        additionType = .hour
    case "Days":
        additionType = .day
    case "Weeks":
        additionType = .day
        intervalValue *= 7
    default:
        additionType = .minute
    }
    
    let end = Calendar.current.date(byAdding: additionType, value: intervalValue, to: chore.start) ?? Date.now
    
    return end
}

// helper function to improve readability and perform quick repeating check
func compareTime(chore: Chore)->Double{
    var date: Date
    if(chore.repeating){
        date = dateWithInterval(chore: chore)
    }else{
        date = chore.end!
    }
    
    return date.timeIntervalSince(Date.now)
}

// returns when the chore will turn critical with using the inverse of statusConvertor
func criticalDateConvert(start: Date, end: Date)->Double{
    let interval = end.timeIntervalSince(start)
    return interval*0.82
}

// formats date into string for printing
func timeToString(date: Date) -> String{
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MMM d, hh:mm"
    return dateFormatter.string(from: date)
}

// returns a formated string indicating how much time is left/overdue from input Date
func timeLeft(end: Date) -> String{
    
    let now = Date()
    let calendar = Calendar.current
    
    let components: Set<Calendar.Component> = [.day, .hour, .minute]
    let timeDiff = calendar.dateComponents(components, from: now, to: end)
    
    let days = abs(timeDiff.day ?? 0)
    let hours = abs(timeDiff.hour ?? 0)
    let minutes = abs(timeDiff.minute ?? 0)
    
    if now <= end {
        if(days == 0){
            return "\(hours) hours \(minutes) minutes left"
        }
        return "\(days) days \(hours) hours left"
    } else {
        if(days == 0){
            return "\(hours) hours \(minutes) minutes overdue"
        }
        return "\(days) days \(hours) hours overdue"
    }
}
