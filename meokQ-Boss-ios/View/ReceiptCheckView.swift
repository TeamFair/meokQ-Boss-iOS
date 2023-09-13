
import SwiftUI

//TODO: 상단 유저+미션+보상 정보 UI가 완료되지 않았습니다
//TODO: 이미지를 받아오는 작업을 완료하지 않았습니다

struct ReceiptCheckView: View {
    @State private var showSubmitAlert = false
    @State private var showRejectSheet = false
    @Environment(\.presentationMode) var presentationMode
    let receipt: Receipt
    @State var receiptRejected: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading){
                    Text("닉네임 \(receipt.userName)")
                        .font(.system(size: 14, weight: .regular))
                    Text("\(receipt.quest.coupon)")
                        .font(.system(size: 16, weight: .medium))
                    Text("\(receipt.quest.quest)")
                        .font(.system(size: 16, weight: .medium))
                    
                }
                Spacer()
            }
            .padding(.top, 20)
            ScrollView {
                Image(systemName: receipt.imageString)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.2)
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
                        .font(.system(size: 20, weight: .medium))
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
        .background(Color("BackgroundYellowColor"))
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
            SheetView(showRejectSheet: $showRejectSheet, receiptRejected: $receiptRejected).onDisappear {
                if receiptRejected  {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        presentationMode.wrappedValue.dismiss()
                    }
                  
                }
            }
        }
    }
    func summit() {
        // TODO: 쿠폰 발행 로직 및 해당 영수증 리스트에서 삭제
        presentationMode.wrappedValue.dismiss()
    }
}

struct ReceiptCheckView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptCheckView(receipt: Receipt(userName: "chad", imageString: "circle", quest: questList[0]))
    }
}


struct SheetView: View {
    @State private var showCancelAlert = false
    @Binding var showRejectSheet: Bool
    @Binding var receiptRejected: Bool
    @Environment(\.presentationMode) var presentationMode

    let initialText: String = "반려하신 사유를 작성해주세요"
    @State var text: String = ""
    var reasonList: [String] = ["직접 입력", "영수증이 불명확합니다", "영수증과 퀘스트가 일치하지 않습니다"]
    var reasonSelectedIndex: Int = 0
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            
            HStack {
                Text("영수증 반려 사유 입력하기")
                    .font(.system(size: 18, weight: .bold))
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
                }.padding(.horizontal, 12)
                
                
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color(hue: 0, saturation: 0, brightness: 0.96))
            .cornerRadius(12)
            .foregroundColor(.black)
            
            
            TextField(initialText, text: $text, axis: .vertical)
                .font(.system(size: 14, weight: .medium))
                .frame(minHeight: 80)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(hue: 0, saturation: 0, brightness: 0.96))
                .cornerRadius(12)
            
            
            Spacer()
            
            Button {
                showCancelAlert = true
            } label: {
                Text("반려하기")
                    .font(.system(size: 18, weight: .medium))
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
                    // TODO: 리스트에서 해당 영수증 삭제
                    showRejectSheet = false
                    receiptRejected = true
                   // presentationMode.wrappedValue.dismiss()
                   
                }),
                      secondaryButton:.cancel(Text("취소")))
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 16)
    }
    
}
struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(showRejectSheet: .constant(true), receiptRejected: .constant(false))
    }
}
