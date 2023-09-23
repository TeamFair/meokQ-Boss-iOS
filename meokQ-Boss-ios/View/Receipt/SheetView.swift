//
//  SheetView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/12.
//

import SwiftUI

struct SheetView: View {
    let initialText: String = "반려하신 사유를 작성해주세요"
    var reasonList: [String] = ["직접 입력", "영수증이 불명확합니다", "영수증과 퀘스트가 일치하지 않습니다"]
    var reasonSelectedIndex: Int = 0
    let request: Request

    @State var text: String = ""
    @State private var showCancelAlert = false
    @Binding var showRejectSheet: Bool
    @Binding var receiptRejected: Bool
    
    @ObservedObject var marketStore: MarketStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 16) {
                
                HStack {
                    Text("반려사유 선택하기")
                        .font(Font.custom("Pretendard", size: 17)
                            .weight(.medium))
                    Spacer()
                }
                Menu {
                    ForEach(reasonList, id: \.self) { reason in
                        Button {
                            text = (reason == reasonList[0] ? "" : reason)
                        } label: {
                            Text(reason)
                        }
                    }
                } label: {
                    HStack {
                        Text(reasonList.contains(text) ? text: reasonList[0])
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 12)
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color(hue: 0, saturation: 0, brightness: 0.96))
                .cornerRadius(12)
                .foregroundColor(.black)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke()
                }
                
                TextField(initialText, text: $text)
                    .font(Font.custom("Pretendard", size: 14)
                        .weight(.bold))
                    .frame(minHeight: 80)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hue: 0, saturation: 0, brightness: 0.96))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke()
                    }
                
                
                Spacer()
                
                Button {
                    Task {
                        await marketStore.rejectRequest(marketId: request.marketId, missionId: request.missionId, requestId: request.requestId, message: text)
                    }
                    showCancelAlert = true
                } label: {
                    Text("반려하기")
                        .font(Font.custom("Pretendard", size: 18)
                            .weight(.medium))
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(12)
                .alert(isPresented: $showCancelAlert) {
                    Alert(title: Text("영수증을 반려하시겠습니까?"), message: Text("반려 후 되돌릴 수 없으니 유의 부탁드립니다"),
                          primaryButton:  .default(Text("반려"),
                                                   action: {
                        Task {
                            await marketStore.rejectRequest(marketId: request.marketId, missionId: request.missionId, requestId: request.uuid.uuidString, message: text)
                        }
                        showRejectSheet = false
                        receiptRejected = true
                        presentationMode.wrappedValue.dismiss()
                        
                    }),
                          secondaryButton:.cancel(Text("취소")))
                }
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 16)
            .navigationTitle("영수증 반려하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(request: Request(), showRejectSheet: .constant(true), receiptRejected: .constant(false), marketStore: MarketStore())
    }
}
