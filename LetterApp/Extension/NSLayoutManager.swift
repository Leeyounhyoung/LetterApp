//
//  Untitled.swift
//  LetterApp

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

