//
//  MemoriesViewModel.swift
//  Diary
//
//  Created by futami on 2020/02/04.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class MemoriesViewModel {
    // フラッシュon、offでアイコン切り替え
    func flashImage(flash: Bool) -> UIImage? {
        let flash = flash ? "flash_on" : "flash_off"
        return UIImage(named: flash)
    }
}
