import Foundation

// ISP: Small and focused protocol with only the method clients need.
protocol NotificationService {
    func trigger(message: String)
}

// SRP: Responsible only for sending notifications through Email.
// OCP: New notification services can be added without modifying this class.
class EmailServiceImpl: NotificationService {
    func trigger(message: String) {
        print("\(message) sent via Email")
    }
}

// SRP: Responsible only for sending notifications through SMS.
// LSP: Can substitute NotificationService without changing Notification's behavior.
class SMSServiceImpl: NotificationService {
    func trigger(message: String) {
        print("\(message) sent via SMS")
    }
}

// SRP: Responsible only for coordinating notification sending.
// DIP: Depends on NotificationService abstraction, not concrete implementations.
// OCP: Can work with new NotificationService implementations without modification.
class Notification {
    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func send(message: String) {
        notificationService.trigger(message: message)
    }
}

// DIP: Concrete implementation is injected from outside.
let emailNotification = Notification(notificationService: EmailServiceImpl())
emailNotification.send(message: "Hello Swift")

// LSP: SMSServiceImpl can be substituted wherever NotificationService is expected.
let smsNotification = Notification(notificationService: SMSServiceImpl())
smsNotification.send(message: "Hello Swift")
