import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notificationResponse: UNNotificationResponse?
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permissão concedida")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = Manager.shared.palavraDoDia
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Houve um erro ao agendar a notificação: \(error)")
            } else {
                print("Notificação agendada com sucesso!")
            }
        }
        
        print("Tentativa de agendar uma notificação")
    }
    
    func scheduleDailyNotifications() {
        let times = [(hour: 9, minute: 0), (hour: 13, minute: 0), (hour: 18, minute: 0)]
        
        for time in times {
            scheduleDailyNotification(at: time.hour, minute: time.minute)
        }
    }
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleDailyNotification(at hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = Manager.shared.palavraDoDia
        content.body = "Confira a palavra do dia!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
}
