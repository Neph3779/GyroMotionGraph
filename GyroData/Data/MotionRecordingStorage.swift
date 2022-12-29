//
//  MotionRecordingStorage.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/29.
//

import Foundation

final class MotionRecordingStorage: MotionRecordingStorageProtocol {
    private let coreDataStorage = CoreDataStorage.shared

    func saveRecord(record: MotionRecord, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStorage.persistentContainer.viewContext
        DispatchQueue.global().async {
            let newRecord = MotionRecordEntity(context: context)
            newRecord.motionRecordId = record.id
            newRecord.startDate = record.startDate
            newRecord.msInterval = Int64(record.msInterval)
            newRecord.motionMode = record.motionMode.name
            newRecord.coordinates = record.coordinates.map { return [$0.x, $0.y, $0.z] }

            do {
                try context.save()
                completion(.success(Void()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

fileprivate extension MotionMode {
    var name: String {
        switch self {
        case .accelerometer:
            return "acc"
        case .gyroscope:
            return "gyro"
        }
    }
}
