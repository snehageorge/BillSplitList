//
//  BillListViewModel.swift
//  BillSplits
//
//  Created by Sneha on 06/04/25.
//

import Foundation

@MainActor
class BillListViewModel: ObservableObject {
    @Published var bills = [Bill]()
    @Published var isLoading = false
    
    func fetchBills() async {
        guard let url = Bundle.main.url(forResource: "bills", withExtension: "json") else {
            print("File not found")
            return
        }
        self.isLoading = true
        
        defer {
            self.isLoading = false
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(BillResponse.self, from: data)
            self.bills = decodedResponse.bills
        } catch {
            print("Failed to decode: \(error)")
        }
        
        
    }
}
