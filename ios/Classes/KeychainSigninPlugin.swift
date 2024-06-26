//
//  KeychainSigninPlugin.swift

import Foundation
import Flutter
import Security

/// A Flutter plugin to use the keychain for sign.
public class KeychainSigninPlugin: NSObject, FlutterPlugin {

    /// Registers the plugin with the Flutter engine.
    ///
    /// - Parameters:
    ///   - registrar: The Flutter plugin registrar.
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "keychain_signin", binaryMessenger: registrar.messenger())
        let instance = KeychainSigninPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /// Handles method calls from Flutter.
    ///
    /// - Parameters:
    ///   - call: The method call received from Flutter.
    ///   - result: The result callback to send the response back to Flutter.
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = PluginMethod.from(call) else {
            return result(FlutterMethodNotImplemented)
        }
        let access = KeychainSigninAccess()
        switch method {
            case .upsertAccountPassword(let account):
                do {
                    let status = try access.upsertAccountPassword(account: account)
                    if status == errSecSuccess || status == errSecUserCanceled {
                        result(status == errSecSuccess)
                    } else {
                        let flutterError = FlutterError(
                            code: "upsert_password_error",
                            message: "error upserting password: \(status)",
                            details: nil)
                        result(flutterError)
                    }
                } catch {
                    let flutterError = FlutterError(
                        code: "upsert_password_error",
                        message: "error upserting password: \(error)",
                        details: nil)
                    result(flutterError)
                }
            case .createAccountPassword(let account):
                do {
                    let status = try access.createAccountPassword(account: account)
                    if status == errSecSuccess || status == errSecUserCanceled {
                        result(status == errSecSuccess)
                    } else {
                        let flutterError = FlutterError(
                            code: "create_password_error",
                            message: "error creating password: \(status)",
                            details: nil)
                        result(flutterError)
                    }
                } catch {
                    let flutterError = FlutterError(
                        code: "create_password_error",
                        message: "error creating password: \(error)",
                        details: nil)
                    result(flutterError)
                }
            case .readAccountPassword(let account):
                let (status, retrievedPassword) = access.readAccountPassword(account: account)
                if status == errSecSuccess {
                    result(retrievedPassword)
                } else if(
                    status == errSecItemNotFound
                        || status == errSecUserCanceled) {
                    result(nil)
                } else {
                    let flutterError = FlutterError(
                        code: "read_password_error",
                        message: "error reading password: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .updateAccountPassword(let account):
                let status = access.updateAccountPassword(account: account)
                if status == errSecSuccess || status == errSecUserCanceled {
                    result(status == errSecSuccess)
                } else {
                    let flutterError = FlutterError(
                        code: "update_password_error",
                        message: "error updating password: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .deleteAccountPassword(let account):
                let status = access.deleteAccountPassword(account: account)
                if status == errSecSuccess || status == errSecItemNotFound {
                    result(status == errSecSuccess)
                } else {
                    let flutterError = FlutterError(
                        code: "delete_password_error",
                        message: "error deleting password: \(status)",
                        details: nil)
                    result(flutterError)
                }
        }
    }
}
