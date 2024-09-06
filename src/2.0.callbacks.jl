# TODO: Add priority level to callbacks

const ONFINALLY_CALLBACKS = Function[]
onfinally!(f::Function) = push!(ONFINALLY_CALLBACKS, f)

const ONEVENT_CALLBACKS = Function[]
onevent!(f::Function) = push!(ONEVENT_CALLBACKS, f)

const ONINFO_CALLBACKS = Function[]
oninfo!(f::Function) = push!(ONINFO_CALLBACKS, f)

