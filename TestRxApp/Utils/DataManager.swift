//
//  DataManager.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation

protocol DataManager {
    func saveData(_ data: Data, filename: String) throws
    func loadData(path: String) -> Data?
}

struct FileDataManagerImpl: DataManager {
    
    let fileManager: FileManager
    
    func saveData(_ data: Data, filename: String) throws {
        let filename = getDocumentsDirectory().appendingPathComponent(filename)
        try data.write(to: filename, options: .atomic)
    }
    
    func loadData(path: String) -> Data? {
        let filename = getDocumentsDirectory().appendingPathComponent(path)
        return try? Data(contentsOf: filename)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
