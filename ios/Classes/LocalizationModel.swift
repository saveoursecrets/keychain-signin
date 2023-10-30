//
//  LocalizationModel.swift

import Foundation

struct LocalizationModel {

    fileprivate static let titleKey = "promptDialogTitle"
    fileprivate static let reasonKey = "promptDialogReason"
    fileprivate static let cancelKey = "cancelButtonTitle"

    let dialogTitle: String
    let reason: String
    let cancelButtonTitle: String

    static var `default` = LocalizationModel(
        dialogTitle: "",
        reason: "validate that you have access to this device",
        cancelButtonTitle: "Cancel"
    )

    static func from(_ dictionary: [String: Any]? = nil) -> LocalizationModel? {
        guard let dictionary,
              let title = dictionary[titleKey] as? String,
              let reason = dictionary[reasonKey] as? String,
              let cancel = dictionary[cancelKey] as? String else {
            return nil
        }
        return LocalizationModel(
            dialogTitle: title,
            reason: reason,
            cancelButtonTitle: cancel)
    }
}
