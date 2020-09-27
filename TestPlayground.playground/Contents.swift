import UIKit
import SUAI_API


//PocketAPI.shared.setToken("c3e7738eb01265a7dc932a1486824a9de1e59c9eea64ddfcfb637a58339ee66f23589fd5276e917216e4c")
//
//if let data = PocketAPI.shared.syncLoadTask(method: .getFeedOrder){
//	do{
//		let decodedData  = try JSONDecoder().decode([FeedSource].self, from: data)
//		print(decodedData)
//	}catch{
//		print("SANews source list: \(error)")
//	}
//}
extension Calendar{
    static func convertToRU(_ day:Int)->Int{
        let d = day - 2
        return d < 0 ? 6 : d
    }
    static func convertToUS(_ day:Int)->Int{
        let d = day + 2
        return d > 7 ? 1 : d
    }
    
    var weekdaysRu:[String] {
        var symbols = Array(self.weekdaySymbols.dropFirst())
        symbols.append(self.weekdaySymbols.first!)
        return symbols
    }
}

let offset = 5
func createTrigger(weekday:Int,hour:Int,minute:Int)->UNNotificationTrigger{
	let hours = (minute-offset) < 0 ? hour-1 : hour
	let hour = hours > 0 ? hours : 23
	
	let minute = (minute-offset) < 0 ? (60-offset) : minute-offset
	

	let dateComponents = DateComponents(hour: hour, minute: minute,weekday: Calendar.convertToUS(weekday))
	let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
	
	return trigger
}

createTrigger(weekday: 6, hour: 0, minute: 00 )
//
//for i in 0...6{
//	print("RU: \(i) RU->US \(Calendar.convertToUS(i))  RU->US->RU \(Calendar.convertToRU(Calendar.convertToUS(i)))")
////	print("US: \(i)     US->RU \(Calendar.convertToRU(i))      US->RU->US \(Calendar.convertToUS(Calendar.convertToRU(i)))")
//}
