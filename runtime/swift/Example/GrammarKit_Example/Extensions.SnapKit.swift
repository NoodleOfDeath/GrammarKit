//
// The MIT License (MIT)
// 
// Copyright © 2019 NoodleOfDeath. All rights reserved.
// NoodleOfDeath
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

import SnapKit

// MARK: - UIView SnapKit Extensions
extension UIView {
    
    /// Returns a new `UIEdgeInsets` instance from a specified set of values
    /// and an unsigned flag.
    ///
    /// - Parameters:
    ///     - values: to inset each edge of this view within its
    /// superview with, in order of top, left, bottom, and right.
    fileprivate func edgeInsets(for values: [CGFloat]) -> UIEdgeInsets {
        var edgeInsets = UIEdgeInsets()
        edgeInsets.top = values.count > 0 ? values[0] : 0.0
        edgeInsets.left = values.count > 1 ? values[1] : 0.0
        edgeInsets.bottom = values.count > 2 ? values[2] : 0.0
        edgeInsets.right = values.count > 3 ? values[3] : 0.0
        return edgeInsets
    }
    
    /// Constrains the edges of this view to the edges of its superview using
    /// specified edge insets.
    ///
    /// - Parameters:
    ///     - values: to inset each edge of this view within its
    /// superview with, in order of top, left, bottom, and right.
    func constrainToSuperview(_ values: CGFloat...) {
        constrainToSuperview(edgeInsets: edgeInsets(for: values))
    }
    
    /// Constrains the edges of this view to the edges of its superview using
    /// specified edge insets.
    ///
    /// - Parameters:
    ///     - edgeInsets: to inset the edges of this view within its
    /// superview with.
    func constrainToSuperview(edgeInsets: UIEdgeInsets) {
        guard let superview = superview else { return }
        snp.makeConstraints { (dims) in
            dims.top.equalTo(superview).offset(edgeInsets.top)
            dims.left.equalTo(superview).offset(edgeInsets.left)
            dims.bottom.equalTo(superview).offset(edgeInsets.bottom)
            dims.right.equalTo(superview).offset(edgeInsets.right)
        }
    }
    
    /// Constrains the edges of this view to the edges of its superview using a
    /// specified padding constant.
    ///
    /// - Parameters:
    ///     - padding: constant to inset the edges of this view within
    /// its superview with.
    func constrainToSuperview(padding: CGFloat) {
        constrainToSuperview(edgeInsets: UIEdgeInsets(top: padding,
                                                      left: padding,
                                                      bottom: -padding,
                                                      right: -padding))
    }
    
    /// Constrains the edges of this view to the edges of its superview using
    /// specified edge insets.
    ///
    /// - Parameters:
    ///     - edgeInsetSize: to inset the edges of this view within its
    /// superview with where width is the unsigned horizontal edge inset
    /// and height is the unsigned vertical edge inset.
    func constrainToSuperview(edgeInsetSize: CGSize) {
        constrainToSuperview(edgeInsets: UIEdgeInsets(top: edgeInsetSize.height,
                                                      left: edgeInsetSize.width,
                                                      bottom: -edgeInsetSize.height,
                                                      right: -edgeInsetSize.width))
    }
    
    /// Adds a subview and constrains its edges to the edges of this view using
    /// specified edge insets.
    ///
    /// - Parameters:
    ///     - subview: to add to this view.
    ///     - values: to inset the edges of this view within its
    /// superview with, in order of top, left, bottom, and right.
    func addConstrainedSubview(_ subview: UIView, _ values: CGFloat...) {
        addSubview(subview)
        subview.constrainToSuperview(edgeInsets: edgeInsets(for: values))
    }
    
    /// Adds a subview and constrains its edges to the edges of this view using
    /// specified edge insets.
    ///
    /// - Parameters:
    ///     - subview: to add to this view.
    ///     - edgeInsets: to inset the edges of this view within its
    /// superview with.
    func addConstrainedSubview(_ subview: UIView, edgeInsets: UIEdgeInsets) {
        addSubview(subview)
        subview.constrainToSuperview(edgeInsets: edgeInsets)
    }
    
    /// Adds a subview and constrains its edges to the edges of this view using
    /// a specified padding constant.
    ///
    /// - Parameters:
    ///     - subview: to add to this view.
    ///     - padding: constant to inset the edges of this view within
    /// its superview with.
    func addConstrainedSubview(_ subview: UIView, padding: CGFloat) {
        addSubview(subview)
        subview.constrainToSuperview(padding: padding)
    }
    
    /// Adds a subview and constrains its edges to the edges of this view using
    /// a specified padding constant.
    ///
    /// - Parameters:
    ///     - subview: to add to this view.
    ///     - edgeInsetSize: to inset the edges of this view within
    /// its superview with, where width is the unsigned horizontal edge inset
    /// and height is the unsigned vertical edge inset.
    func addConstrainedSubview(_ subview: UIView, edgeInsetSize: CGSize) {
        addSubview(subview)
        subview.constrainToSuperview(edgeInsetSize: edgeInsetSize)
    }
    
}
