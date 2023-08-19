//
//  RecieptView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/19.
//

import SwiftUI

// 영수증 Tab입니다. 

struct Receipt: Identifiable {
    var id = UUID()
    var userName: String
    var imageString: String 
    var quest: Quest
}

struct Quest {
    var quest: String
    var coupon: String
}

var questList: [Quest] = [
    Quest(quest: "오후 2시전 아메리카노 2잔 주문", coupon: "아메리카노 50% 할인권"),
    Quest(quest: "아메리카노 00잔 주문", coupon: "아메리카노 1% 할인권")
]
var receiptList: [Receipt] = [
    Receipt(userName: "chad", imageString: "circle", quest: questList[0]),
    Receipt(userName: "jjjjjjad", imageString: "star", quest: questList[0]),
    Receipt(userName: "zzzzzzzzzzad", imageString: "person", quest: questList[1])
]

struct ReceiptView: View {
    @State var receiptSelection: Receipt?

    var body: some View {
            VStack (spacing:0){
                ScrollView {
                    
                    HStack{
                        Text("영수증")
                            .font(Font.custom("Pretendard", size: 34)
                                .weight(.bold))
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, 23)
                    
                    LazyVGrid(columns: [GridItem(.flexible())],spacing: 16) {
                        ForEach(receiptList) { receipt in
                            NavigationLink(destination: ReceiptCheckView(receipt: receipt )) {
                                ReceiptComponent(receipt: receipt)
                            }
                        }
                        .tint(.black)
                    }.shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 0)
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                }
                Spacer()
            }
            .background(Color.LightYellow)
        
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView()
    }
}

