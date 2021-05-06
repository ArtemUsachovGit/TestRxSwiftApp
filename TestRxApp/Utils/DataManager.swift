//
//  DataManager.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation

struct DataManager {
    
    func saveData(_ data: Data, filename: String) throws {
        let filename = getDocumentsDirectory().appendingPathComponent(filename)
        try data.write(to: filename, options: .atomic)
    }
    
    func loadData(fileName: String) -> Data? {
        let filename = getDocumentsDirectory().appendingPathComponent(fileName)
        return try? Data(contentsOf: filename)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
