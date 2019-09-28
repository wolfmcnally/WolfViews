//
//  FeedbackGenerator.swift
//  WolfViews
//
//  Created by Wolf McNally on 2/11/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if os(iOS)
import AudioToolbox
import UIKit

public class FeedbackGenerator {
    private let haptic: Haptic?
    private let feedbackGenerator: Any? //UIFeedbackGenerator?
    private let soundID: SystemSoundID?

    public enum Haptic {
        case selection
        case heavy
        case medium
        case light
        case error
        case success
        case warning
    }

    public init(haptic: Haptic? = nil, soundFile: String? = nil, subdirectory: String? = nil) {
        self.haptic = haptic
        if let haptic = haptic {
            if #available(iOS 10.0, *) {
                switch haptic {
                case .selection:
                    feedbackGenerator = UISelectionFeedbackGenerator()
                case .heavy:
                    feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                case .medium:
                    feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                case .light:
                    feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                case .error, .success, .warning:
                    feedbackGenerator = UINotificationFeedbackGenerator()
                }
            } else {
                feedbackGenerator = nil
            }
        } else {
            feedbackGenerator = nil
        }

        if let soundFile = soundFile, let url = Bundle.main.url(forResource: soundFile, withExtension: nil, subdirectory: subdirectory) {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            self.soundID = soundID
        } else {
            soundID = nil
        }
    }

    public func play() {
        if let haptic = haptic {
            if #available(iOS 10.0, *) {
                switch haptic {
                case .selection:
                    (feedbackGenerator as! UISelectionFeedbackGenerator).selectionChanged()
                case .heavy, .medium, .light:
                    (feedbackGenerator as! UIImpactFeedbackGenerator).impactOccurred()
                case .error:
                    (feedbackGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.error)
                case .success:
                    (feedbackGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.success)
                case .warning:
                    (feedbackGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.warning)
                }
            }
        }
        if let soundID = soundID {
            AudioServicesPlaySystemSound(soundID)
        }
    }

    deinit {
        if let soundID = soundID {
            AudioServicesDisposeSystemSoundID(soundID)
        }
    }
}
#endif
