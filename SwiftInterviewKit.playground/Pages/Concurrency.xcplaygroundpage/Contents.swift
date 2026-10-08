////: [Previous](@previous)

import Foundation


/// First all Serial Code will be executed
/// then Dispatch Queue statement will be exeucted in FIFO Order
/// Since you're already on the main thread, the main queue cannot start those async blocks until the current synchronous work gives the main thread back.
func DispatchSerialAsyncQueue() {
    var numbers: String = ""
    for i in 50...55 {
        numbers += "\(i) "
    }
    print(numbers)
    
    DispatchQueue.main.async {
        var numbers: String = ""
        for i in 10...15 {
            numbers += "\(i) "
        }
        print(numbers)
    }
    
    DispatchQueue.main.async {
        var numbers: String = ""
        for i in 0...5 {
            numbers += "\(i) "
        }
        print(numbers)
    }
    numbers = ""
    for i in 30...35 {
        numbers += "\(i) "
    }
    print(numbers)
    
    numbers = ""
    for i in 60...65 {
        numbers += "\(i) "
    }
    print(numbers)

}
//DispatchSerialAsyncQueue()



/// It is serial Queue without concurrent so first 50...55 will be executed nothing to do with Queue
/// then out put can be vary but 0..5 will be print after  10..15 as it is Queue and Queue work on FIFO Order.
func serialAsyncQueue() {
    let queue: DispatchQueue = DispatchQueue(label: "serialAsyncQueue")
    var numbers: String = ""
    for i in 50...55 {
        numbers += "\(i) "
    }
    print(numbers)
    queue.async {
        var numbers: String = ""
        for i in 10...15 {
            numbers += "\(i) "
        }
        print(numbers)
    }
    queue.async {
        var numbers: String = ""
        for i in 0...5 {
            numbers += "\(i) "
        }
        print(numbers)
    }
    numbers = ""
    for i in 30...35 {
        numbers += "\(i) "
    }
    print(numbers)
}

//serialAsyncQueue()

///first 50...55 will be executed nothing to do with Queue
///Now it is concurrent code so out put can be vary
func concurentAsyncQueue() {
    let queue: DispatchQueue = DispatchQueue(label: "serialAsyncQueue", attributes: .concurrent)
    var numbers: String = ""
    for i in 50...55 {
        numbers += "\(i) "
    }
    print(numbers)
    queue.async {
        var numbers: String = ""
        for i in 10...15 {
            numbers += "\(i) "
        }
        print(numbers)
    }
    queue.async {
        var numbers: String = ""
        for i in 0...5 {
            numbers += "\(i) "
        }
        print(numbers)
    }
    numbers = ""
    for i in 30...35 {
        numbers += "\(i) "
    }
    print(numbers)
}

//concurentAsyncQueue()

func dispatchGroupWithMultipleAPIs() {
    let group = DispatchGroup()
    // API 1
    group.enter()
    DispatchQueue.global().async {
        print("API 1 started")
        sleep(2) // Simulating API delay
        print("API 1 completed")
        group.leave()
    }
    // API 2
    group.enter()
    DispatchQueue.global().async {
        print("API 2 started")
        sleep(4) // Simulating API delay
        print("API 2 completed")
        group.leave()
    }
    // API 3
    group.enter()
    DispatchQueue.global().async {
        print("API 3 started")
        sleep(1) // Simulating API delay
        print("API 3 completed")
        group.leave()
    }
    
    
    
    // Called only after ALL APIs complete
    group.notify(queue: .main) {
        print("All API calls completed")
    }
}
//dispatchGroupWithMultipleAPIs()


func dispatchGroupWithMutlipleAPIWithWait() {
    let group = DispatchGroup()
    // API 1
    group.enter()
    DispatchQueue.global().async {
        print("API 1 started")
        sleep(2)
        print("API 1 completed")
        group.leave()
    }
    // API 2
    group.enter()
    DispatchQueue.global().async {
        print("API 2 started")
        sleep(10)
        print("API 2 completed")
        group.leave()
    }
    
    let waitTimeOutResult: DispatchTimeoutResult = group.wait(timeout: .now() + .seconds(3))
    DispatchQueue.main.async {
        switch waitTimeOutResult {
        case .success:
            print("All API calls completed")
            print("Proceed with all results")
        case .timedOut:
            print("Time exceeds 3 seconds")
            print("Go ahead without waiting for all APIs")
        }
    }
}
//dispatchGroupWithMutlipleAPIWithWait()
class APIManager {
    
    func fetchAllAPIs() {
        var apiTasks: [URLSessionDataTask] = []
        let group = DispatchGroup()
        let urls = [
            URL(string: "https://httpbin.org/delay/1")!,
            URL(string: "https://httpbin.org/delay/2")!,
            URL(string: "https://httpbin.org/delay/10")!,
            URL(string: "https://httpbin.org/delay/5")!
        ]
        for (index, url) in urls.enumerated() {
            group.enter()
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer {
                    print("Defer for \(index + 1)")
                    group.leave()
                }
                if let error = error {
                    if let urlError = error as? URLError,
                       urlError.code == .cancelled {
                        print("API \(index + 1) cancelled")
                        return
                    }
                    print("API \(index + 1) failed")
                    print(error.localizedDescription)
                    return
                }
                print("API \(index + 1) completed")
            }
            apiTasks.append(task)
            task.resume()
        }
        // Make immutable copy for concurrent closure
        let tasks = apiTasks
        let waitTimeOutResult: DispatchTimeoutResult = group.wait(timeout: .now() + .seconds(3))
        DispatchQueue.main.async {
            switch waitTimeOutResult {
            case .success:
                print("All APIs completed")
                print("Proceed with all results")
            case .timedOut:
                print("Time exceeds 3 seconds")
                print("Cancelling remaining API requests")
                tasks.forEach { task in
                    task.cancel()
                }
                print("Go to next screen")
            }
        }
    }
}

let apiManager = APIManager()
//apiManager.fetchAllAPIs()

// MARK:  - Race Condition solve with barrier -
final class BankAccount: @unchecked Sendable {
    private var balance: Int = 2000
    private let queue = DispatchQueue(label: "bank.account.queue", attributes: .concurrent)
    func withdrawBalance(value: Int) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            if self.balance >= value {
                Thread.sleep(forTimeInterval: 0.1)
                self.balance -= value
                print("Withdrawal of \(value)")
            } else {
                print("Balance is not sufficient to withdraw \(value)")
            }
        }
    }

    func getBalance() {
        queue.async {
            print("Updated balance: \(self.balance)")
        }
    }
}

//let account = BankAccount()
//DispatchQueue.global().async {
//    account.withdrawBalance(value: 1500)
//}
//DispatchQueue.global().async {
//    account.withdrawBalance(value: 2000)
//}
//Thread.sleep(forTimeInterval: 0.5)
//account.getBalance()

// MARK: - Race condition solved with Semaphore -
final class BankAccountSemaphore: @unchecked Sendable {
    private var balance: Int = 2000
    private let semaphore = DispatchSemaphore(value: 1)

    func withdrawBalance(value: Int) {
        DispatchQueue.global().async {
            // Lock
            self.semaphore.wait()
            if self.balance >= value {
                Thread.sleep(forTimeInterval: 0.1)
                self.balance -= value
                print("Withdrawal of \(value)")
            } else {
                print("Balance is not sufficient for value \(value)")
            }
            // Unlock
            self.semaphore.signal()
        }
    }

    func getBalance() {
        DispatchQueue.global().async {
            self.semaphore.wait()
            print("Total balance: \(self.balance)")
            self.semaphore.signal()
        }
    }
}

//let account = BankAccountSemaphore()
//DispatchQueue.global().async {
//    account.withdrawBalance(value: 1500)
//}
//DispatchQueue.global().async {
//    account.withdrawBalance(value: 1500)
//}
//Thread.sleep(forTimeInterval: 1)
//account.getBalance()

// MARK: - Race condition solved with actor  -
final actor BankAccountActor {
    private var balance: Int = 2000
    
    func withdrawBalance(value: Int) {
        if self.balance >= value {
            Thread.sleep(forTimeInterval: 0.1)
            self.balance -= value
            print("Withdrawal of \(value)")
        } else {
            print("Balance is not sufficient for value \(value)")
        }
    }
    
    func getBalance() {
        print("Total balance: \(self.balance)")
    }
}

let actorAccount = BankAccountActor()



//Task {
//    await withTaskGroup(of: Void.self) { group in
//        group.addTask {
//            await actorAccount.withdrawBalance(value: 1500)
//        }
//
//        group.addTask {
//            await actorAccount.withdrawBalance(value: 1500)
//        }
//    }
//
//    await actorAccount.getBalance()
//}

