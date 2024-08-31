const ONFINALLY_CALLBACKS = Function[]
onfinally!(f::Function) = push!(ONFINALLY_CALLBACKS, f)

const ONEVENT_CALLBACKS = Function[]
onevent!(f::Function) = push!(ONEVENT_CALLBACKS, f)
