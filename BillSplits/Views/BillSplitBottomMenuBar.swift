//
//  BillSplitBottomMenuBar.swift
//  BillSplits
//
//  Created by Sneha on 06/04/25.
//

import SwiftUI

struct BillSplitBottomMenuBar: View {
    let icons = ["house", "text.document", "camera.metering.none", "bubble.left.and.bubble.right", "person"]
    @State var selectedIndex: Int = 0
    
    var body: some View {
        HStack {
            ForEach(0..<5)  { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(selectedIndex == index ? Color.yellow : Color.black)
                        Image(systemName: icons[index])
                            .foregroundStyle(Color.gray)
                    }
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    BillSplitBottomMenuBar()
}
