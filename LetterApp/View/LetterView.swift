//
//  LetterView.swift
//  LetterApp

import SwiftUI

struct LetterView: View {
  @State var text: String = "" // 편지의 내용
  
  // 편지를 담당하는 뷰
  var body: some View {
    VStack(spacing: 0, content: {
      Spacer().frame(height: 30)
      
      // 텍스트를 입력하는 부분과 밑줄을 겹침
      ZStack(content: {
        let lineCount = Int(floor(AppTheme.letterHeight / 31))
        
        // 텍스트를 입력하는 부분
        VStack(spacing: 0, content: {
          CustomTextEditorView(text: $text, lineCount: lineCount)
            .padding(.horizontal, 30)
            .frame(height: AppTheme.letterHeight+7)
        }).frame(height: AppTheme.letterHeight+7)
        
        // 밑줄을 보여주는 부분
        VStack(spacing:0, content: {
          // 높이에 따라 다른 여백을 줌
          Spacer().frame(height: 50 - (AppTheme.letterHeight.truncatingRemainder(dividingBy: 31)))
          
          // 14개의 줄을 생성 줄의 간격을 30으로 설정
          VStack(spacing: 30, content: {
            ForEach(Array(0..<lineCount), id: \.self) { _ in
              Divider().frame(height: 1).background(Color.black).padding(.horizontal, 30)
            }
          })
          Spacer().frame(height: 30)
        }).frame(height: AppTheme.letterHeight + 5)
      })
      
      Spacer().frame(height: 30)
    })
    .background(AppTheme.letterBackgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .padding(.horizontal, 30)
  }
}

#Preview {
  LetterView()
}
