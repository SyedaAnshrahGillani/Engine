//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import EngineCore
import os.log

@frozen
public struct ViewInputs {

    public struct Options: OptionSet {
        public var rawValue: UInt32

        public init(rawValue: UInt32) { self.rawValue = rawValue }

        public static func flag(_ index: Int) -> Options {
            Options(rawValue: 1 << index)
        }

        public static let isAxisHorizontal = Options(rawValue: 1 << 3)
    }

    public var _graphInputs: _GraphInputs

    public var options: Options {
        get {
            do {
                let rawValue = try swift_getFieldValue("options", UInt32.self, _graphInputs)
                return Options(rawValue: rawValue)
            } catch {
                return Options(rawValue: 0)
            }
        }
        set {
            try? swift_setFieldValue("options", newValue.rawValue, &_graphInputs)
        }
    }

    init(inputs: _GraphInputs) {
        self._graphInputs = inputs
    }

    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    @_disfavoredOverload
    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value? {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    public subscript<Value>(
        key: String,
        _: Value.Type
    ) -> Value? {
        @_transparent get { _graphInputs[key, Value.self] }
    }
}

/// A `ViewModifier` that only modifies the static inputs
public protocol ViewInputsModifier: GraphInputsModifier {
    static func makeInputs(inputs: inout ViewInputs)
}

extension ViewInputsModifier {
    public static func makeInputs(
        modifier: _GraphValue<Self>,
        inputs: inout _GraphInputs
    ) {
        withUnsafeMutablePointer(to: &inputs) { ptr in
            ptr.withMemoryRebound(to: ViewInputs.self, capacity: 1) { ptr in
                makeInputs(inputs: &ptr.pointee)
            }
        }
    }
}

@frozen
public struct _ViewInputsLogModifier: ViewInputsModifier {

    @inlinable
    public init() { }

    public static func makeInputs(inputs: inout ViewInputs) {
        #if DEBUG
        var message = ""
        dump(inputs.options, to: &message)
        os_log(.debug, "%@", message)
        var ptr = inputs._graphInputs.customInputs.elements
        while let p = ptr {
            message = ""
            dump(p, to: &message)
            dump(p.fields, to: &message)
            dump(p.value, to: &message)
            ptr = p.after

            os_log(.debug, "%@", message)
        }
        #endif
    }
}

extension _ViewInputs {
    public var _graphInputs: _GraphInputs {
        @_transparent get {
            withUnsafePointer(to: self) { ptr in
                ptr.withMemoryRebound(to: _GraphInputs.self, capacity: 1) { ptr in
                    ptr.pointee
                }
            }
        }
        @_transparent set {
            withUnsafeMutablePointer(to: &self) { ptr in
                ptr.withMemoryRebound(to: _GraphInputs.self, capacity: 1) { ptr in
                    ptr.pointee = newValue
                }
            }
        }
    }

    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    @_disfavoredOverload
    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value? {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    public subscript<Value>(
        key: String,
        _: Value.Type
    ) -> Value? {
        @_transparent get { _graphInputs[key, Value.self] }
    }
}

extension _ViewListInputs {
    public var _graphInputs: _GraphInputs {
        @_transparent get {
            withUnsafePointer(to: self) { ptr in
                ptr.withMemoryRebound(to: _GraphInputs.self, capacity: 1) { ptr in
                    ptr.pointee
                }
            }
        }
        @_transparent set {
            withUnsafeMutablePointer(to: &self) { ptr in
                ptr.withMemoryRebound(to: _GraphInputs.self, capacity: 1) { ptr in
                    ptr.pointee = newValue
                }
            }
        }
    }

    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    @_disfavoredOverload
    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value? {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    public subscript<Value>(
        key: String,
        _: Value.Type
    ) -> Value? {
        @_transparent get { _graphInputs[key, Value.self] }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension _ViewListCountInputs {
    public var _graphInputs: _GraphInputs {
        get {
            withUnsafePointer(to: self) { ptr in
                ptr.withMemoryRebound(to: _GraphInputs.self, capacity: 1) { ptr in
                    ptr.pointee
                }
            }
        }
        set {
            withUnsafeMutablePointer(to: &self) { ptr in
                ptr.withMemoryRebound(to: _GraphInputs.self, capacity: 1) { ptr in
                    ptr.pointee = newValue
                }
            }
        }
    }

    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    @_disfavoredOverload
    public subscript<Input: ViewInputKey>(
        _ : Input.Type
    ) -> Input.Value? {
        @_transparent get { _graphInputs[Input.self] }
        @_transparent set { _graphInputs[Input.self] = newValue }
    }

    public subscript<Value>(
        key: String,
        _: Value.Type
    ) -> Value? {
        @_transparent get { _graphInputs[key, Value.self] }
    }
}
