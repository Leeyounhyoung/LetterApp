//
//  ContentView.swift
//  LetterApp

import SwiftUI
import UIKit

extension NSLayoutManager {
  // 총 줄수를 계산하여 반환하는 함수
  func numberOfLines() -> Int {
    var numberOfLines = 0 // 줄 수
    var index = 0
    
    // 줄 수 만큼 반복
    while index < numberOfGlyphs {
      numberOfLines += 1
      
      var lineRange = NSRange() // 글리프의 범위를 저장하기 위한 변수
      self.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange) // 현재 글리프를 전달하여 글리프가 속해있는 줄의 범위를 lineRanges에 저장
      
      index = NSMaxRange(lineRange) // 인덱스를 현재 범위의 끝 글리프로 설정
    }
    
    // 라인수를 리턴
    return numberOfLines
  }
}

  
struct ContentView: View {
  @State var text: String = "" // 편지의 내용
  let letterHeight: CGFloat = 186 // 편지의 높이
  
  var body: some View {
    VStack(spacing:0, content: {
      LetterView
    })
  }
  
  // 편지를 담당하는 뷰
  private var LetterView: some View {
    VStack(spacing: 0, content: {
      Spacer().frame(height: 30)
      
      // 텍스트를 입력하는 부분과 밑줄을 겹침
      ZStack(content: {
        let lineCount = Int(floor(letterHeight / 31))
        
        // 텍스트를 입력하는 부분
        VStack(spacing: 0, content: {
          CustomTextEditorView(text: $text, lineCount: lineCount)
            .padding(.horizontal, 30)
            .frame(height: letterHeight+7)
        }).frame(height: letterHeight+7)
        
        // 밑줄을 보여주는 부분
        VStack(spacing:0, content: {
          // 높이에 따라 다른 여백을 줌
          Spacer().frame(height: 50 - (letterHeight.truncatingRemainder(dividingBy: 31)))
          
          // 14개의 줄을 생성 줄의 간격을 30으로 설정
          VStack(spacing: 30, content: {
            ForEach(Array(0..<lineCount), id: \.self) { _ in
              Divider().frame(height: 1).background(Color.black).padding(.horizontal, 30)
            }
          })
          Spacer().frame(height: 30)
        }).frame(height: letterHeight + 5)
      })
      
      Spacer().frame(height: 30)
    })
    .background(Color(hex: "E4E4E4"))
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .padding(.horizontal, 30)
  }
}

/// color extension hex code로 컬러를 사용하기 위함
extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}


#Preview {
  ContentView()
}
