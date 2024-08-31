const ONSETUP_CALLBACKS = Function[]
onsetup!(f::Function) = push!(ONSETUP_CALLBACKS, f)

const ONLOOP_CALLBACKS = Function[]
onloop!(f::Function) = push!(ONLOOP_CALLBACKS, f)

const ONFINALLY_CALLBACKS = Function[]
onfinally!(f::Function) = push!(ONFINALLY_CALLBACKS, f)

const ONEVENT_CALLBACKS = Function[]
onevent!(f::Function) = push!(ONEVENT_CALLBACKS, f)
