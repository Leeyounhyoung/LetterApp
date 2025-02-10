//
//  CustomTextEditorView.swift
//  LetterApp

import SwiftUI

// Swift의 TextEditor를 커스텀, UIKit의 UITextView를 수정
struct CustomTextEditorView: UIViewRepresentable {
  @Binding var text: String
  let lineCount: Int
  
  // UIKit의 UIView를 객체 정의
  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView() // UIKit의 멑티라인 텍스트 입력 필드 생성
    textView.backgroundColor = .clear // 배경을 투명하게 설정
    textView.delegate = context.coordinator // 델리게이트 설정
    
    
    // 줄 간격 및 문단 스타일 설정
    let style = NSMutableParagraphStyle()
    style.lineSpacing = AppTheme.letterLineSpacing
    style.paragraphSpacingBefore = AppTheme.letterParagraphSpacing
    
    // 줄 간격 설정 적용 및 폰트 적용
    textView.typingAttributes = [
      .paragraphStyle: style,
      .font: UIFont.systemFont(ofSize: AppTheme.letterFontSize)
    ]
    
    return textView
  }
  
  // 기존 UIView를 업데이트 상태가 변할 때 호출
  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
  }
  
  // Coordinator 생성
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  // UITextView의 동작을 제어할 수 있는 메서드를 제공하는 프로토콜
  class Coordinator: NSObject, UITextViewDelegate {
    var parent: CustomTextEditorView
    
    init(_ parent: CustomTextEditorView) {
      self.parent = parent
    }
    
    // 텍스트 뷰가 입력된 후 들어오는 함수
    func textViewDidChange(_ textView: UITextView) {
      parent.text = textView.text
    }
    
    // 텍스트가 입력되기 전에 텍스트가 범위를 넘어간지 판별하고 그 결과 값을 반환
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
      // 커서 위치와 텍스트를 입력 받아 추가 및 삭제 (기존 텍스트뷰를 번경하지 않고 추가가 되는 경우 줄수를 계산하기 위함)
      let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
      
      
      // 텍스트 레이아웃 관리를 담당하는 객체
      let layoutManager = NSLayoutManager()
      
      // 텍스트를 표시할 뷰의 영역을 나타내는 객체
      let textContainer = NSTextContainer(size: CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
      
      // 텍스트가 표시될 영역을 정의한 NSTextContainer를 layoutManager에 추가하여 레이아웃 계산을 수행하도록 연결
      layoutManager.addTextContainer(textContainer)
      
      
      // newText을 기반으로 NSTextStorage 객체를 생성
      let textStorage = NSTextStorage(string: newText)
      
      // NSTextStorage에 layoutManager를 추가하여, 텍스트의 레이아웃을 관리할 수 있도록 연결
      textStorage.addLayoutManager(layoutManager)
      
      // NSTextStorage에 폰트 속성을 추가하여, 텍스트의 폰트를 지정
      textStorage.addAttribute(.font, value: textView.font ?? UIFont.systemFont(ofSize: AppTheme.letterFontSize), range: NSRange(location: 0, length: textStorage.length))
      
      let totalLines = layoutManager.numberOfLines()
      
      // 마지막 줄일때 개행문자의 입력을 막음
      if totalLines == parent.lineCount && text == "\n" {
        return false
      }
      
      // 편지지를 넘어가지 않도록 막음
      if totalLines > parent.lineCount {
        if text.isEmpty {
          return true
        } else  {
          return false
        }
      }
      
      return true
    }
  }
}
