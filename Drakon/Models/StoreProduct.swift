//
//  StoreProduct.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import StoreKit

struct StoreProduct: Identifiable {

    let id = UUID()
    let product: Product?
    let shopItem: ShopItem
}
