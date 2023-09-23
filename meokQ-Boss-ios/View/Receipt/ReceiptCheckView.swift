
import SwiftUI
import Kingfisher

//TODO: 상단 유저+미션+보상 정보 UI가 완료되지 않았습니다
//TODO: 이미지를 받아오는 작업을 완료하지 않았습니다

struct ReceiptCheckView: View {
    @State private var showSubmitAlert = false
    @State private var showRejectSheet = false
    @Environment(\.presentationMode) var presentationMode
    let request: Request
    @State var receiptRejected: Bool = false
    @ObservedObject var marketStore: MarketStore

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text(request.reward)
                    .font(Font.custom("Pretendard", size: 23)
                        .weight(.medium))
                Text(request.missionDescription)
                    .font(Font.custom("Pretendard", size: 12)
                        .weight(.medium))
                    .foregroundColor(.Gray)
                HStack {
                    Spacer()
                    Text(getUserDisplayName())
                        .font(Font.custom("Pretendard", size: 14)
                            .weight(.regular))
                }
            }
            .padding(.vertical, 21)
            .padding(.horizontal, 25)
            .background(
                Color.white
                    .shadow(radius: 5)
            )
            .padding(.top, 20)
            ScrollView {
                KFImage(URL(string: request.missionVerificationRequestImage))
                    .placeholder { //플레이스 홀더 설정
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 200)
                    }
                    .onSuccess {r in //성공
                        Log("King succes: \(r)")
                    }
                    .onFailure { e in //실패
                        Log("King failure: \(e)")
                    }
                    .resizable()
                    .scaledToFit()
//                    .scaleEffect(0.2)
                    .frame(minHeight: 550, maxHeight: 700)
                    .background(.gray.opacity(0.2))
            }
            .padding(.horizontal, 16)
            
            HStack{
                Button {
                    showRejectSheet = true
                } label: {
                    Text("반려하기")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 146, height: 50)
                .background(.gray)
                .cornerRadius(12)
                
                Spacer()
                
                Button {
                    showSubmitAlert = true
                } label: {
                    Text("발급하기")
                        .font(Font.custom("Pretendard", size: 20)
                            .weight(.medium))
                        .foregroundColor(.white)
                }
                .frame(width: 180, height: 50)
                .background(.pink)
                .cornerRadius(12)
                .alert(isPresented: $showSubmitAlert) {
                    Alert(title: Text("쿠폰을 발급하시겠습니까?"), message: Text("발급 후 되돌릴 수 없으니 유의 부탁드립니다"),
                          primaryButton: .default(Text("발급"), action: summit),
                          secondaryButton: .cancel(Text("취소")))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationTitle("영수증 확인")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .background(Color.LightYellow)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 17)
                        Text("뒤로")
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showRejectSheet) {
            SheetView(request: request, showRejectSheet: $showRejectSheet, receiptRejected: $receiptRejected, marketStore: marketStore).onDisappear {
                if receiptRejected  {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        presentationMode.wrappedValue.dismiss()
                    }
                  
                }
            }
        }
    }
    
    func getUserDisplayName() -> String {
        let user = marketStore.users.filter { $0.uid == request.userId }.first
        return user?.displayName ?? ""
    }
    
    func summit() {
        // TODO: 쿠폰 발행 로직 및 해당 영수증 리스트에서 삭제
        Task {
            await marketStore.addCoupon(marketId: request.marketId, userId: request.userId, reward: request.reward, missionId: request.missionId, requestId: request.requestId)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ReceiptCheckView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptCheckView(request: Request(), marketStore: MarketStore())
    }
}
