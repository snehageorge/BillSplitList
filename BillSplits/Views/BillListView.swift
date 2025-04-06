//
//  BillListView.swift
//  BillSplits
//
//  Created by Sneha on 06/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct BillListView: View {
    
    @ObservedObject var viewModel = BillListViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height > geometry.size.width
            let screenHeight = geometry.size.height
            ZStack {
                Color.black
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .foregroundStyle(.white)
                        } else if viewModel.bills.isEmpty {
                            Text("No bills found")
                        } else {
                            BillListTopBarView(bills: viewModel.bills)
                            if isPortrait {
                                BillCarouselView(bills: viewModel.bills, screenHeight: screenHeight)
                            }
                            BillRecentSplitListView(bills: viewModel.bills)
                            BillSplitBottomMenuBar()
                            Spacer()
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchBills()
            }
        }
    }
}

struct BillListTopBarView: View {
    var bills: [Bill]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hey \(bills[0].userName)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.gray.opacity(0.8))
                
                Text("\(bills.filter{ $0.isPending == true }.count) Pending Bills")
                    .font(.caption2)
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
            
            Button(action: {
                print("Notifications button tapped")
            }) {
                Image(systemName: "bell")
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .foregroundStyle(Color.white)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}

struct BillCarouselView: View {
    @State var selectedIndex = 0
    var bills: [Bill]
    var screenHeight: CGFloat
    
    var body: some View {
        //TODO: Change swipe control to top
        ZStack {
            Color.yellow
                .clipShape(RoundedRectangle(cornerRadius: 20))
            VStack {
                HStack {
                    ForEach(0..<bills.prefix(2).count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedIndex ? Color.black : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top)
                TabView(selection: $selectedIndex) {
                    ForEach(Array(bills.prefix(2).enumerated()), id: \.element.id) { index, bill in
                        VStack {
                            WebImage(url: URL(string: bill.foodImage))
                                .resizable()
                                .padding(.top)
                                .scaledToFit()
                                .frame(width: 240, height: 240)
                            
                            HStack {
                                WebImage(url: URL(string: bill.shopLogo))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                Spacer()
                                
                                VStack {
                                    Text(String(format: "$%.2f", bill.totalAmount))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.black)
                                    
                                    Text("\(bill.shopName)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.gray.opacity(0.8))
                                }
                                Spacer()
                                
                                WebImage(url: URL(string: bill.userImage))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            .padding([.leading, .trailing, .bottom])
                        }
                        .tag(index)
                        .padding(.bottom)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .padding([.leading, .trailing])
        .frame(height: screenHeight / 2.5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BillRecentSplitListView: View {
    var bills: [Bill]
    
    var body: some View {
        HStack {
            Text("Recent Splits")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            Spacer()
            Button(action: {
                print("See all button tapped")
            }, label: {
                Text("See all")
                    .foregroundStyle(Color.yellow)
            })
        }
        .padding()
        VStack {
            ForEach(bills.prefix(2)) { bill in
                HStack {
                    WebImage(url: URL(string: bill.shopLogo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(bill.shopName)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                        
                        Text("\(bill.date)")
                            .font(.caption2)
                            .foregroundStyle(Color.white)
                        
                    }
                    
                    Spacer()
                    Text("$\(bill.totalAmount, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
        }
    }
}

#Preview {
    BillListView()
}
