//
//  RoloPicker.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/13/25.
//

import SwiftUI

struct RoloPicker<Item: Hashable, Label: View>: View {
    let items: [Item]
    @Binding var selection: Item

    var height: CGFloat = 52
//    var inset: CGFloat = 4

    var backgroundColor: Color = .white
    var selectionColor: Color = Color(red: 0.06, green: 0.12, blue: 0.11)

    /// label(item, isSelected) — isSelected can be used for weight/scale, etc.
    /// DO NOT set the color inside the label — the color is set by the layers below.
    @ViewBuilder let label: (Item, Bool) -> Label

    @State private var dragStartIndex: Int? = nil
    @State private var dragTranslation: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let count = items.count
            let totalWidth = geo.size.width

            // Protection against empty array
            if count == 0 {
                Capsule().fill(backgroundColor)
            } else {
                let segmentWidth = (totalWidth /*- inset * 2*/) / CGFloat(count)

                let selectedIndex = items.firstIndex(of: selection) ?? 0
                let baseIndex = dragStartIndex ?? selectedIndex

                let baseX = CGFloat(baseIndex) * segmentWidth
                let maxX = CGFloat(count - 1) * segmentWidth

                // The current position of the capsule (moves with your finger while dragging)
                let currentX = clamp(baseX + dragTranslation, 0, maxX)

                ZStack(alignment: .leading) {
                    // Track background
                    Capsule()
                        .fill(backgroundColor)

                    // Moving selection capsule (background of selected)
                    Capsule()
                        .fill(selectionColor)
                        .frame(width: segmentWidth, height: height)// - inset * 2)
                        .offset(x: /*inset + */currentX, y: 0)//inset)

                    // 1) The base layer of labels (black) is where the taps are
                    labelsLayer(selectedIndex: selectedIndex)
                        .foregroundStyle(.black)

                    // 2) White layer of labels - visible only where the capsule is (mask)
                    labelsLayer(selectedIndex: selectedIndex)
                        .foregroundStyle(.white)
                        .mask(alignment: .topLeading) {
                            Capsule()
                                .frame(width: segmentWidth, height: height)// - inset * 2)
                                .offset(x: /*inset + */currentX, y: 0)//inset)
                        }
                        .allowsHitTesting(false)
                }
                .simultaneousGesture(
                    dragGesture(
                        segmentWidth: segmentWidth,
                        selectedIndex: selectedIndex,
                        maxX: maxX
                    )
                )
            }
        }
        .frame(height: height)
    }

    // MARK: - Labels layer

    @ViewBuilder
    private func labelsLayer(selectedIndex: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                let isSelected = (index == selectedIndex)

                label(item, isSelected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selection = item
                        }
                    }
            }
        }
        .padding(4)
    }

    // MARK: - Drag

    private func dragGesture(segmentWidth: CGFloat, selectedIndex: Int, maxX: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                if dragStartIndex == nil {
                    dragStartIndex = selectedIndex
                    dragTranslation = 0
                }

                let baseIndex = dragStartIndex ?? selectedIndex
                let baseX = CGFloat(baseIndex) * segmentWidth

                let newX = clamp(baseX + value.translation.width, 0, maxX)
                dragTranslation = newX - baseX
            }
            .onEnded { value in
                let baseIndex = dragStartIndex ?? selectedIndex
                let baseX = CGFloat(baseIndex) * segmentWidth

                let finalX = clamp(baseX + value.translation.width, 0, maxX)
                let newIndex = Int(round(finalX / segmentWidth))
                    .clamped(to: 0...(items.count - 1))

                withAnimation(.easeInOut(duration: 0.25)) {
                    selection = items[newIndex]
                    dragStartIndex = nil
                    dragTranslation = 0
                }
            }
    }

    private func clamp(_ x: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        min(max(x, minValue), maxValue)
    }
}

// MARK: - Helpers
private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
