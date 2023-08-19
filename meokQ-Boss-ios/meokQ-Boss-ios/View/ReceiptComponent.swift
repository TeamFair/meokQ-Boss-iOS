//
//  ReceiptListRowView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/19.
//

import SwiftUI

struct ReceiptComponent: View {
    let receipt: Receipt
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(receipt.quest.coupon)
                .font(.system(size: 23, weight: .medium))
                .padding(.bottom, 9)
            Text(receipt.quest.quest)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.38))
            HStack(spacing: 4) {
                Spacer()
                Text("영수증 확인하기")
                    .font(.system(size: 12, weight: .medium))
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 5, height: 10)
            }
        }
        .navigationBarTitle("영수증", displayMode: .large)
        .padding(.horizontal, 24)
        .padding(.vertical, 13)
        .padding(.top, 17)
        .background(.white)
        .cornerRadius(16)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(23)
                .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.38))
        }
    }
}

struct ReceiptComponent_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptComponent(receipt:  Receipt(userName: "chad", imageString: "circle", quest: questList[0])).padding(.vertical, 20).background(.brown)
    }
}
