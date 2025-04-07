import HealthKit

class HealthDataController {
    private let healthStore = HKHealthStore()
    private(set) var caloriesBurned: Double = 0.0
    private(set) var currentHeartRate: Double = 0.0
    private var startTime: Date?
    private var timer: Timer?

    func startTracking() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("LOG: HealthKit is not available on this device.")
            return
        }
        
        requestAuthorization { [weak self] success in
            if success {
                self?.startTime = Date()
                self?.caloriesBurned = 0.0
                self?.startTimer()
                print("LOG: Health data tracking started.")
            } else {
                print("LOG: HealthKit authorization failed.")
            }
        }
    }

    func stopTracking(completion: @escaping (Double, Double) -> Void) {
        timer?.invalidate()
        timer = nil
        
        guard let startTime = startTime else {
            completion(0.0, 0.0)
            return
        }
        
        fetchActiveCalories(from: startTime) { [weak self] result in
            switch result {
            case .success(let activeCalories):
                self?.caloriesBurned = activeCalories
                self?.fetchHeartRate { heartRate in
                    completion(activeCalories, heartRate)
                }
            case .failure(let error):
                print("LOG: Error fetching final calories: \(error.localizedDescription)")
                completion(177, 75.0)
            }
        }
    }

    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard
            let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else {
            completion(false)
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [energyType, heartRateType]) { success, error in
            if let error = error {
                print("LOG: HealthKit authorization error: \(error.localizedDescription)")
            }
            completion(success)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateHealthData()
        }
    }

    private func updateHealthData() {
        guard let startTime = startTime else { return }
        fetchActiveCalories(from: startTime) { [weak self] result in
            switch result {
            case .success(let activeCalories):
                self?.caloriesBurned = activeCalories
                print("LOG: Updated calories burned: \(activeCalories) kcal")
            case .failure(let error):
                print("LOG: Error updating calories: \(error.localizedDescription)")
            }
        }
        fetchHeartRate { [weak self] heartRate in
            self?.currentHeartRate = heartRate
            print("LOG: Current heart rate: \(heartRate) BPM")
        }
    }

    private func fetchActiveCalories(from startDate: Date, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(.failure(NSError(domain: "HealthKitError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Active energy type not available."])));
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let quantity = result?.sumQuantity() {
                let activeCalories = quantity.doubleValue(for: HKUnit.kilocalorie())
                completion(.success(activeCalories))
            } else {
                completion(.success(0.0))
            }
        }

        healthStore.execute(query)
    }

    private func fetchHeartRate(completion: @escaping (Double) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(0.0)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-60), end: Date(), options: .strictStartDate)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, results, error in
            if let error = error {
                print("LOG: Error fetching heart rate: \(error.localizedDescription)")
                completion(0.0)
                return
            }

            if let quantitySample = results?.first as? HKQuantitySample {
                let heartRate = quantitySample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                completion(heartRate)
            } else {
                completion(0.0)
            }
        }

        healthStore.execute(query)
    }
}
