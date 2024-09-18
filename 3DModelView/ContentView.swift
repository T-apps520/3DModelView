//
//  ContentView.swift
//  3DModelView
//
//  Created by Tomoya Watanabe on 2024/08/30.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var enlarge = false
    
    var body: some View {
        VStack {
            // トグルボタンを表示している部分
            VStack {
                // トグルを配置する
                // isOn: $enlargeの「$」記号は @Stateプロパティのバインディングを提供するために使われる
                // バインディングとは、ある変数とビュー要素を双方向ぬリンクすること
                // これにより、変数の値が変わるとビューの要素も変わり、逆にビューの要素が変わると変数の値が変わるようになる^
                Toggle("Enlarge RealityView Content", isOn: $enlarge)
                   // 見た目をボタンのスタイルにする
                    .toggleStyle(.button)
            // パディングを入れる
            }.padding()
            // 背景にグラスエフェクトを表示する
            .glassBackgroundEffect()
            
            // 球を表示している部分
            RealityView { content in
                // ①初期コンテンツを配置
                // あらかじめ用意された Scene という名前の3Dモデルを読み込む
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    // コンテンツに追加する
                    content.add(scene)
                }
            } update: { content in
                // ②SwiftUIのステートが変更された場合にコンテンツを更新
                // content配下にエンティティがある場合、最初のエンティティをscene変数に保持する
                if let scene = content.entities.first {
                    // enlargeがtrueの場合 1.4、 falseの場合 1.0をuniformScale変数に保持する
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    // 最初のエンティティ（この場合は球）のスケールを変更する
                    scene.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
            }
            // ジェスチャを有効にする
            .gesture(TapGesture()
                // 任意のエンティティを操作の対象とする
                .targetedToAnyEntity()
                // タップジェスチャが終了した時（≒親指と人差し指を離した時）の処理
                .onEnded { _ in
                // enlargeの値をトグル（Boolの値を反転）する
                enlarge.toggle()
                }
            )
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
