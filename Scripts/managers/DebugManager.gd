extends Node
## Has various statics for tracking what should be debugged
class_name DebugManager

# print statements
static var StatusApplied: bool = false
static var StatusProc: bool = false
static var UpgradeEditedAttack: bool = true

# debug visuals
static var SpawnObjectRange: bool = false # circle around spawn objects showing their range stat
static var PlayerDistanceRadius: bool = false # circles around player showing various distances in units
static var PlayerDistances: Array[float] = [10.0, 20.0, 50.0, 100.0]
